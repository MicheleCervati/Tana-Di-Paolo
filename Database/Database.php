<?php
namespace Database;
require_once 'Config/Database.php';
require_once 'Functions/Log.php';
use Config\Database as Config;
use Functions\Log;
use PDOException;
use PDO;

class Database extends Config
{
    private static ?PDO $PDO = null;

    public static function connect(): ?PDO{
        if (!isset(self::$PDO)) {
            try {
                self::$PDO = new PDO(
                    Config::$driver . ':host=' . Config::$host . ';dbname=' . Config::$dbname,
                    Config::$user,
                    Config::$password, [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                ]);
            } catch (PDOException $e) {
                Log::write($e);
            }
        }
        return self::$PDO;
    }

    public static function select(string $query, array $binds = []): array
    {
        if (self::$PDO === null) {
            throw new \Exception('Database is not connected');
        }
        $stm = self::$PDO->prepare($query);
        foreach ($binds as $key => $value) {
            $stm->bindValue($key, $value);
        }
        $stm->execute();
        $result = [];
        while ($row = $stm->fetch()) {
            $result[] = $row;
        }
        $stm->closeCursor();
        return $result;
    }

    public static function execute(string $query, array $binds = []): void
    {
        if (self::$PDO === null) {
            throw new \Exception('Database is not connected');
        }
        $stm = self::$PDO->prepare($query);
        foreach ($binds as $key => $value) {
            $stm->bindValue($key, $value);
        }
        $stm->execute();
        $stm->closeCursor();
    }

    public static function lastInsertId(): int
    {
        if (self::$PDO === null) {
            throw new \Exception('Database is not connected');
        }
        return self::$PDO->lastInsertId();
    }

    public static function startTransaction(): void
    {
        if (self::$PDO === null) {
            throw new \Exception('Database is not connected');
        }
        self::$PDO->beginTransaction();
    }

    public static function commitTransaction(): void
    {
        if (self::$PDO === null) {
            throw new \Exception('Database is not connected');
        }
        self::$PDO->commit();
    }

    public static function rollbackTransaction(): void
    {
        if (self::$PDO === null) {
            throw new \Exception('Database is not connected');
        }
        self::$PDO->rollBack();
    }
}