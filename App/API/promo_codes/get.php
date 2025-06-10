<?php
require_once 'App/Model/CarrelloCodiciSconto.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
require_once 'Functions/Shadows.php';
use App\Model\CarrelloCodiciSconto;
use Functions\Log;
use Functions\Panic;
use Functions\Shadows;
use Database\Database;

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$uid = $_SESSION['uid'] ?? -1;
$sid = isset($_SESSION['uid']) ? -1 : Shadows::getID();

if (!$uid && !$sid) {
    Panic::panicAPI(5, 401);
}

try {
    Database::connect();
    $rawCarrello = CarrelloCodiciSconto::fetch($uid, $sid);
} catch (Exception $e) {
    Log::write($e);
    Panic::panicAPI(0, 500);
}

echo json_encode($rawCarrello);