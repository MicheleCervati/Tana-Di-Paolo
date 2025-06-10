<?php

namespace App\Model;

use Database\Database;

class CarrelloCodiciSconto
{
    public static function fetch(int $user, int $shadow){
        return Database::select("select c.id, cs.code, cs.percentuale, cs.decimale
            from righe_carrello_sconti c
            inner join codici_sconto cs on cs.id = c.promocode
            where c.usato = 0 and (c.utente = :user OR c.shadow = :shadow)
            order by cs.decimale desc, cs.percentuale asc;",
            [
                'user' => $user,
                'shadow' => $shadow
            ]);
    }

    public static function delete(int $user, int $shadow, string $promocode)
    {
        Database::execute('DELETE c
            FROM righe_carrello_sconti c
            INNER JOIN codici_sconto s ON s.id = c.promocode 
            WHERE (c.utente = :user OR c.shadow = :shadow)
              AND s.code = :promocode
              AND c.usato = 0',
            [
                'user' => $user,
                'shadow' => $shadow,
                'promocode' => $promocode
            ]);
    }

    public static function add(int $user, int $shadow, string $promocode)
    {
        $codice = Database::select("select * from codici_sconto cs
            where cs.code = :codice", [
                'codice' => $promocode
            ])[0] ?? null;
        if (!$codice) {
            throw new \Exception('Not Valid');
        }
        $carrello = Database::select("select * from righe_carrello_sconti where (utente = :user OR shadow = :shadow) and promocode = :promocode;",
            [
                'user' => $user,
                'shadow' => $shadow,
                'promocode' => $codice['id']
            ])[0] ?? null;
        if (!$carrello) {
            Database::execute('INSERT INTO righe_carrello_sconti (utente, shadow, promocode) VALUES (:user, :shadow, :promocode)',
                [
                    'user' => $user == -1 ? null : $user,
                    'shadow' => $shadow == -1 ? null : $shadow,
                    'promocode' => $codice['id']
                ]);
        }
    }

    public static function transfer(int $user, int $shadow)
    {
        // Recupera tutte le righe dallo shadow
        $rows = Database::select('SELECT * FROM righe_carrello_sconti WHERE shadow = :shadow', [
            'shadow' => $shadow
        ]);

        foreach ($rows as $row) {
            // Prova a vedere se esiste già una riga per l'utente con lo stesso vino
            $existing = Database::select('SELECT * FROM righe_carrello_sconti WHERE utente = :user AND promocode = :code', [
                'user' => $user,
                'code' => $row['promocode']
            ]);

            if (!$existing) {
                Database::execute('UPDATE righe_carrello SET utente = :user, shadow = NULL WHERE id = :id', [
                    'user' => $user,
                    'id' => $row['id']
                ]);
            }
        }
    }
}