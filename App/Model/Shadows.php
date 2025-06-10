<?php

namespace App\Model;
require_once 'Database/Database.php';

use Database\Database;

class Shadows
{
    public static function get(int $usr): array
    {
        $query = 'select * from shadows s where s.id = :id';
        return Database::select($query, [
            'id' => $usr,
        ])[0] ?? [];
    }

    public static function create(\DateTime $expiration): void
    {
        Database::execute('insert into shadows(expire) value(:expire)', ['expire' => $expiration->format('Y-m-d H:i:s')]);
    }

    public static function clean(): void
    {
        Database::execute('delete from shadows where expire < now()');
    }
}