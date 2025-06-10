<?php
require_once 'App/Model/Carrello.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
require_once 'Functions/Shadows.php';
use App\Model\Carrello;
use Functions\Log;
use Functions\Panic;
use Functions\Shadows;
use Database\Database;

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$product = $_POST['product'] ?? null;

if (!$product) {
    Panic::panicAPI(1, 400);
}

$uid = $_SESSION['uid'] ?? -1;
$sid = isset($_SESSION['uid']) ? -1 : Shadows::getID();

if (!$uid && !$sid) {
    Panic::panicAPI(5, 401);
}

try {
    Database::connect();
    Carrello::delete($uid, $sid, $product);
} catch (Exception $e) {
    Log::write($e);
    Panic::panicAPI(0, 500);
}

echo json_encode([
    'status' => 'success',
    'message' => 'Product deleted successfully'
]);