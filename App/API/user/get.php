<?php
require_once 'App/Model/User.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
use App\Model\User;
use Functions\Log;
use Functions\Panic;

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$uid = $_SESSION['uid'] ?? null;

if (!$uid) {
    Panic::panicAPI(5, 401);
}

try {
    $utente = User::get($uid);
    unset($utente['password']);
} catch (Exception $e) {
    Log::write($e);
    Panic::panicAPI(0, 500);
}

echo json_encode($utente);