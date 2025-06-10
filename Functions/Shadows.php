<?php

namespace Functions;
require_once 'App/Model/Shadows.php';
use App\Model\Shadows as ShadowsModel;
use Database\Database;

Database::connect();

class Shadows
{
    public static function getID(): int
    {
        ShadowsModel::clean();
        $expiration = new \DateTime("+1 month");
        if (isset($_SESSION['sid']) && $_SESSION['shExp'] < $expiration->getTimestamp()) return $_SESSION['sid'];
        ShadowsModel::create($expiration);
        $id = Database::lastInsertId();
        $_SESSION['sid'] = $id;
        $_SESSION['shExp'] = $expiration->getTimestamp();
        return $id;
    }

    public static function clear(): void
    {
        ShadowsModel::clean();
    }
}