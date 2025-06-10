<?php

namespace App\Controller;
require_once 'Functions/Panic.php';

use Functions\Panic;

class SessionController
{
    public function login()
    {
        require 'App/Actions/login.php';
    }

    public function logout()
    {
        require 'App/Actions/logout.php';
    }

    public function register()
    {
        require 'App/Actions/register.php';
    }

    public function update()
    {
        if (!isset($_SESSION['uid'])) {
            Panic::panic('account/login', 5, urlencode($_SERVER['REQUEST_URI']));
        }
        require 'App/Actions/update_account.php';
    }
}