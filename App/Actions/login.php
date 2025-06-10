<?php
require 'App\Model\User.php';
require 'App\Model\Carrello.php';
require 'App\Model\CarrelloCodiciSconto.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
require_once 'Functions/Shadows.php';

use App\Model\User;
use App\Model\Carrello;
use App\Model\CarrelloCodiciSconto;
use Functions\Log;
use Functions\Session;
use Functions\Shadows;
use Functions\Panic;
use Config\Project as Config;
use Database\Database;

Database::connect();

$email = $_POST['email'] ?? null;
$password = $_POST['password'] ?? null;
$referer = urldecode($_POST['referer']) ?? Config::$path;
$remember = $_POST['remember'] ?? null;

if (empty($email) || empty($password)) {
    Panic::panic('account/login', 1, $referer);
}

$user = [];
try {
    $user = User::get($email);
} catch (Exception $e) {
    Log::write($e);
    Panic::panic('account/login', 0, $referer);
}

if (!$user || !password_verify($password, $user['password'])) {
    Panic::panic('account/login', 2, $referer);
}

Session::start();
if ($remember) {
    Session::extend();
}
$_SESSION['uid'] = $user['id'];
$_SESSION['nome'] = $user['nome'];
Carrello::transfer($user['id'], Shadows::getID());
CarrelloCodiciSconto::transfer($user['id'], Shadows::getID());
header('Location: ' . $referer);