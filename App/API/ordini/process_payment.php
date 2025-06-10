<?php
require_once 'App/Model/Ordine.php';
require_once 'App/Model/User.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
use App\Model\Ordine;
use App\Model\User;
use Functions\Log;
use Functions\Panic;
use Database\Database;

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$abbonamento = $_POST['abbonamento'] ?? null;

$uid = $_SESSION['uid'] ?? null;

if (!$uid) {
    Panic::panicAPI(5, 401);
}

try {
    Database::startTransaction();
    Ordine::transfer($uid);
    if ($abbonamento) {
        User::addAbbonamento($uid, $abbonamento);
    }
    Database::commitTransaction();
} catch (Exception $e) {
    try {
        Database::rollbackTransaction();
    } catch (Exception $e) {}
    if ($e->getMessage() == "Magazzino"){
        Panic::panicAPI(10, 400);
    } else {
        Log::write($e);
        Panic::panicAPI(0, 500);
    }
}

echo json_encode([
    'success' => true,
    'message' => 'Product added to cart successfully'
]);