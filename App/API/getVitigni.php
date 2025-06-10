<?php
require_once 'App/Model/Vitigno.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
use Functions\Log;
use Functions\Panic;
use App\Model\Vitigno;
use Database\Database;

Database::connect();

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

try {
    $vitigni = Vitigno::fetchAll();
} catch (Exception $e) {
    Log::write($e);
    Panic::panicAPI(0, 500);
}

echo json_encode($vitigni);