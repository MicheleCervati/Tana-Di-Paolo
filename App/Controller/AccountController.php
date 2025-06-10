<?php
namespace App\Controller;
require_once 'App/Model/User.php';
require_once 'Functions/Panic.php';
require_once 'Config/Log.php';

use Functions\Panic;

class AccountController
{
    public function register(): void
    {
        require_once 'App/View/account/register.php';
    }

    public function login(): void
    {
        require_once 'App/View/account/login.php';
    }

    public function show(): void {
        if (!isset($_SESSION['uid'])) {
            Panic::panic('account/login', 5, urlencode($_SERVER['REQUEST_URI']));
        }
        require_once 'App/View/account/account.php';
    }

    public function questionario(): void {
        if (!isset($_SESSION['uid'])) {
            Panic::panic('account/login', 5, urlencode($_SERVER['REQUEST_URI']));
        }
        require_once 'App/View/account/questionario.php';
    }

    public function ordini(): void {
        if (!isset($_SESSION['uid'])) {
            Panic::panic('account/login', 5, urlencode($_SERVER['REQUEST_URI']));
        }
        require_once 'App/View/account/ordini.php';
    }

    public function algoritmo(): void {
        if (!isset($_SESSION['uid'])) {
            Panic::panic('account/login', 5, urlencode($_SERVER['REQUEST_URI']));
        }
        require_once 'App/View/account/algoritmo.php';
    }
}