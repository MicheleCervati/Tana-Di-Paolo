<?php

namespace App\Model;
require_once 'Database/Database.php';

use Database\Database;

class Tipologia
{
    public static function fetchAll(): array
    {
        $query = 'SELECT * FROM tipologie';
        return Database::select($query);
    }
}