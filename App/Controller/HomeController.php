<?php

namespace App\Controller;

class HomeController
{
    public function show(): void
    {
        require_once 'App/View/index.php';
    }

}