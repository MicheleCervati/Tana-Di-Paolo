<?php
require_once 'App\Model\User.php';
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

$nome = $_POST['nome'] ?? null;
$cognome = $_POST['cognome'] ?? null;
$email = $_POST['email'] ?? null;
$current_password = $_POST['current_password'] ?? null;
$new_password = $_POST['new_password'] ?? null;
$new_password_confirm = $_POST['confirm_password'] ?? null;
$password = null;

if (empty($nome) || empty($cognome) || empty($email)) {
    Panic::panicAPI(1, 400);
}

if (!empty($current_password)) {
    if ($new_password !== $new_password_confirm) {
        Panic::panicAPI(3, 400);
    }
    try {
        $user = User::get($uid);
    } catch (Exception $e) {
        Log::write($e);
        Panic::panicAPI(0, 500);
    }
    if (password_verify($current_password, $user['password'])) {
        $password = $new_password;
    } else {
        Panic::panicAPI(6, 401);
    }
}

try {
    User::update($uid, $nome, $cognome, $email, $password);
} catch (Exception $e) {
    Log::write($e);
    Panic::panicAPI(0, 500);
}

$_SESSION['nome'] = $nome;
echo json_encode([
    'success' => true,
    'message' => 'Modifiche salvate con successo'
]);