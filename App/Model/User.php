<?php

namespace App\Model;
require_once 'Database/Database.php';

use Database\Database;

class User
{
    public static function get(string|int $usr): array
    {
        $query = 'SELECT u.id, u.email, u.password, u.nome, u.cognome, u.abbonamento, r.id as rid, r.ruolo
            FROM utenti u INNER JOIN ruoli r ON u.ruolo = r.id WHERE u.email = :email or u.id = :id';
        return Database::select($query, [
            ':email' => is_numeric($usr) ? null : $usr,
            ':id' => $usr,
        ])[0] ?? [];
    }

    public static function create(string $nome, string $cognome, string $email, string $password, int $ruolo = 1): void
    {
        Database::execute('INSERT INTO utenti (nome, cognome, email, password, ruolo) VALUES (:nome, :cognome, :email, :password, :ruolo)', [
            ':nome' => $nome,
            ':cognome' => $cognome,
            ':email' => $email,
            ':ruolo' => $ruolo,
            ':password' => password_hash($password, PASSWORD_DEFAULT),
        ]);
    }

    public static function update(int $id, string $nome, string $cognome, string $email, ?string $password): void
    {
        $query = 'UPDATE utenti SET nome = :nome, cognome = :cognome, email = :email';
        $bindings = [
            ':nome' => $nome,
            ':cognome' => $cognome,
            ':email' => $email,
            ':id' => $id,
        ];
        $password && $query .= ', password = :password' && $bindings[':password'] = password_hash($password, PASSWORD_DEFAULT);
        $query .= ' WHERE id = :id';
        Database::execute($query, $bindings);
    }

    public static function addAbbonamento(int $id, int $abbonamento): void
    {
        $abb = Database::select("select * from abbonamenti a where a.id = :abbonamento;", [
            ':abbonamento' => $abbonamento,
        ])[0] ?? [];
        if (empty($abb)) {
            throw new \Exception("Abbonamento non trovato");
        }
        Database::execute('UPDATE utenti SET abbonamento = :abbonamento WHERE id = :id', [
            ':id' => $id,
            ':abbonamento' => $abbonamento,
        ]);
    }
}