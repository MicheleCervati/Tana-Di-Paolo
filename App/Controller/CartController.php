<?php

namespace App\Controller;
require_once 'Functions/Panic.php';

use Functions\Panic;

class CartController
{
    public function carrello(): void
    {
        require_once 'App/View/carrello.php';
    }

    public function checkout(): void
    {
        if (!isset($_SESSION['uid'])) {
            Panic::panic('account/login', 5, urlencode($_SERVER['REQUEST_URI']));
        }
        require_once 'App/View/checkout.php';
    }
}