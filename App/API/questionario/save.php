<?php
require_once 'App/Model/Questionario.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
use App\Model\Questionario;
use Functions\Log;
use Functions\Panic;
use Database\Database;

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$uid = $_SESSION['uid'] ?? null;

if (!$uid) {
    Panic::panicAPI(5, 401);
}

$fields = [
    'alcol', 'zuccheri_residui', 'glicerolo', 'acido_tartarico',
    'acido_malico', 'acido_citrico', 'tannini',
    'affinamento', 'passiti', 'maturazione'
];

$risposte = [];
foreach ($fields as $field) {
    if (is_numeric($_POST[$field] ?? null) && $_POST[$field] >= 0 && $_POST[$field] <= 1) {
        $risposte[$field] = $_POST[$field];
    } else {
        Panic::panicAPI(1, 400);
    }
}

$tipologie = $_POST['tipologie'] ?? [];
foreach ($tipologie as $tipo) {
    if (!is_numeric($tipo)) {
        Panic::panicAPI(1, 400);
    }
}

try {
    Database::connect();
    Questionario::saveRisposte($uid, $risposte, $tipologie);
} catch (Exception $e) {
    Log::write($e);
    Panic::panicAPI(0, 500);
}

echo json_encode([
    'success' => true,
    'message' => 'Questionario salvato con successo'
]);