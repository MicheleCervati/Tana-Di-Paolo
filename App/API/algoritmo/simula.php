<?php
require_once 'App/Model/Questionario.php';
require_once 'App/Model/Vino.php';
require_once 'App/Model/User.php';
require_once 'App/Model/Algoritmo.php';
require_once 'App/Model/Ordine.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
use App\Model\Questionario;
use App\Model\User;
use App\Model\Vino;
use App\Model\Algoritmo;
use App\Model\Ordine;
use Functions\Log;
use Functions\Panic;

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$uid = $_SESSION['uid'] ?? null;
$round = $_POST['round'] ?? 12;
$step = $_POST['step'] ?? 0.05;

if (!$uid) {
    Panic::panicAPI(5, 401);
}

try {
    $user = User::get($uid);
    $abbonamento = $user['abbonamento'];
    if (!$abbonamento) {
        Panic::panicAPI(11, 403);
    }
    $quantity = match($abbonamento){
        1 => 2,
        2 => 4,
        3 => 6,
    };
    $questionario = Questionario::loadRisposte($uid);
    if (!$questionario) {
        Panic::panicAPI(8, 400);
    }
    $masimi = Vino::maxStats();
    $minimi = Vino::minStats();
    $utlimiInviati = Ordine::ultimiInviati($uid);
    $vini = Algoritmo::run($round, $step, $quantity, $masimi, $minimi, $questionario, $utlimiInviati);
} catch (Exception $e) {
    if ($e->getMessage() == 'No match') {
        Panic::panicAPI(9, 400);
    } else {
        Log::write($e);
        Panic::panicAPI(0, 500);
    }
}

foreach ($vini as &$vino){
    $vino['vino'] = Vino::fetch($vino['id']);
}

echo json_encode($vini);