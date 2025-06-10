<?php
require 'App\Model\User.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';

use App\Model\User;
use Functions\Log;
use Functions\Panic;
use Config\Project as Config;
use Database\Database;

Database::connect();

$nome = $_POST['nome'] ?? null;
$cognome = $_POST['cognome'] ?? null;
$email = $_POST['email'] ?? null;
$password = $_POST['password'] ?? null;
$confirm_password = $_POST['confirm_password'] ?? null;
$referer = urldecode($_POST['referer']) ?? Config::$path;

if (empty($nome) || empty($cognome) || empty($email) || empty($password) || empty($confirm_password)) {
    Panic::panic('account/register', 1, $referer);
}

if ($password !== $confirm_password) {
    Panic::panic('account/register', 3, $referer);
}

try {
    $user = User::get($email);
    if ($user['id']) {
        Panic::panic('account/register', 4, $referer);
    }
    User::create($nome, $cognome, $email, $password);
} catch (Exception $e) {
    Log::write($e);
    Panic::panic('account/register', 0, $referer);
}
header('Location: ' . $referer);