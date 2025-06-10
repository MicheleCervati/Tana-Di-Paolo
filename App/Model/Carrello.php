<?php

namespace App\Model;

use Database\Database;

class Carrello
{
    public static function fetch(int $user, int $shadow){
        return Database::select("SELECT 
            m.id as id,
            v.id as vid, 
            v.nome, 
            m.cantina as cid, 
            c.cantina, 
            v.vitigno, 
            m.prezzo_vendita, 
            vg.vitigno as vitigno_nome,
            v.tipologia, 
            t.tipologia as tipologia_nome, 
            m.annata, 
            m.immagine, 
            rc.quantita, 
            m.quantita as quantita_magazzino
            FROM righe_carrello rc
            INNER JOIN magazzino m ON m.id = rc.vino
            INNER JOIN vini v ON v.id = m.vino
            INNER JOIN cantine c ON c.id = m.cantina
            INNER JOIN vitigni vg ON vg.id = v.vitigno
            INNER JOIN tipologie t ON t.id = v.tipologia
            WHERE rc.utente = :user OR rc.shadow = :shadow;",
            [
                'user' => $user,
                'shadow' => $shadow
            ]);
    }

    public static function update(int $user, int $shadow, int $vino, int $quantita)
    {
        Database::execute('UPDATE righe_carrello SET quantita = :quantita WHERE (utente = :user OR shadow = :shadow) AND vino = :vino',
            [
                'user' => $user,
                'shadow' => $shadow,
                'vino' => $vino,
                'quantita' => $quantita
            ]);
    }

    public static function delete(int $user, int $shadow, int $vino)
    {
        Database::execute('DELETE FROM righe_carrello WHERE (utente = :user OR shadow = :shadow) AND vino = :vino',
            [
                'user' => $user,
                'shadow' => $shadow,
                'vino' => $vino
            ]);
    }

    public static function add(int $user, int $shadow, int $vino, int $quantita)
    {
        $existing = Database::select('SELECT * FROM righe_carrello WHERE (utente = :user OR shadow = :shadow) AND vino = :vino',
            [
                'user' => $user,
                'shadow' => $shadow,
                'vino' => $vino
            ]);
        if (count($existing) > 0) {
            Database::execute('UPDATE righe_carrello SET quantita = quantita + :quantita WHERE (utente = :user OR shadow = :shadow) AND vino = :vino',
                [
                    'user' => $user,
                    'shadow' => $shadow,
                    'vino' => $vino,
                    'quantita' => $quantita
                ]);
        } else {
            Database::execute('INSERT INTO righe_carrello (utente, shadow, vino, quantita) VALUES (:user, :shadow, :vino, :quantita)',
                [
                    'user' => $user == -1 ? null : $user,
                    'shadow' => $shadow == -1 ? null : $shadow,
                    'vino' => $vino,
                    'quantita' => $quantita
                ]);
        }
    }

    public static function transfer(int $user, int $shadow)
    {
        // Recupera tutte le righe dallo shadow
        $rows = Database::select('SELECT * FROM righe_carrello WHERE shadow = :shadow', [
            'shadow' => $shadow
        ]);

        foreach ($rows as $row) {
            // Prova a vedere se esiste già una riga per l'utente con lo stesso vino
            $existing = Database::select('SELECT * FROM righe_carrello WHERE utente = :user AND vino = :vino', [
                'user' => $user,
                'vino' => $row['vino']
            ]);

            if ($existing) {
                Database::execute('UPDATE righe_carrello SET quantita = quantita + :add WHERE id = :id', [
                    'add' => $row['quantita'],
                    'id' => $existing[0]['id']
                ]);

                Database::execute('DELETE FROM righe_carrello WHERE id = :id', [
                    'id' => $row['id']
                ]);
            } else {
                Database::execute('UPDATE righe_carrello SET utente = :user, shadow = NULL WHERE id = :id', [
                    'user' => $user,
                    'id' => $row['id']
                ]);
            }
        }
    }
}