<?php

namespace App\Controller;

class ChiSiamoController
{
    public function chiSiamo($params = []) {
        $tab_title = 'Chi Siamo';
        $main_classes = 'container my-4';
        require 'App/View/chiSiamo.php';
    }

}