<?php

namespace App\Model;
require_once 'Database/Database.php';

use Database\Database;

class Vitigno
{
    public static function fetchAll(): array
    {
        $query = 'SELECT * FROM vitigni';
        return Database::select($query);
    }
}