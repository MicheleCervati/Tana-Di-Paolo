<?php

namespace App\Controller;

class ViniController
{
    public function catalogo(): void
    {
        require_once 'App/View/catalogo.php';
    }

    public function vino(array $params): void
    {
        $vino = $params[0];
        require_once 'App/View/vino.php';
    }
}