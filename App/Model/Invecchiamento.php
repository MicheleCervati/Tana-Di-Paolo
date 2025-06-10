<?php

namespace App\Model;
require_once 'Database/Database.php';

use Database\Database;

class Invecchiamento
{
    public static function fetchAll(): array
    {
        $query = 'SELECT i.id, i.invecchiamento FROM invecchiamenti i';
        return Database::select($query);
    }
}