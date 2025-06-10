<?php

namespace App\Model;
require_once 'Database/Database.php';

use Database\Database;

class Abbonamento
{
    public static function fetchAll(): array
    {
        $query = 'SELECT * FROM abbonamenti';
        return Database::select($query);
    }
}