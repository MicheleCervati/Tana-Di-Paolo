<?php
require_once 'App/Model/Ordine.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
use App\Model\Ordine;
use Functions\Log;
use Functions\Panic;
use Database\Database;

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$uid = $_SESSION['uid'] ?? null;

if (!$uid) {
    Panic::panicAPI(5, 401);
}

try {
    Database::connect();
    $rawOrdini = Ordine::fetch($uid);
} catch (Exception $e) {
    Log::write($e);
    Panic::panicAPI(0, 500);
}

echo json_encode($rawOrdini);