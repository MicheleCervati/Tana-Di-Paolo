<?php

namespace App\Model;
require_once 'Database/Database.php';

use Database\Database;

class Cantina
{
    public static function fetchAll(): array
    {
        $query = 'SELECT * FROM cantine';
        return Database::select($query);
    }
}