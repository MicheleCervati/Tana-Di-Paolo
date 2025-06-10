<?php

namespace App\Model;

require_once 'App/Model/CarrelloCodiciSconto.php';
use App\Model\CarrelloCodiciSconto;
use Database\Database;

class Ordine
{
    public static function fetch(int $user){
        $orders_db = Database::select("SELECT * FROM ordini o WHERE o.utente = :user ORDER BY o.data DESC;", [
            'user' => $user
        ]) ?? [];
        $orders = [];
        foreach ($orders_db as $order) {
            $orders[] = [
                'id' => $order['id'],
                'data' => $order['data'],
                'da_abbonamento' => $order['da_abbonamento'],
                'totale' => $order['totale'],
                'articoli' => Database::select('SELECT 
                    m.id as magazzino_id,
                    v.id as vino_id, 
                    v.nome, 
                    m.cantina as cid, 
                    c.cantina, 
                    v.vitigno as vid, 
                    vg.vitigno as vitigno_nome,
                    v.tipologia, 
                    t.tipologia as tipologia_nome, 
                    m.annata, 
                    m.immagine, 
                    ro.quantita,
                    m.prezzo_vendita
                    FROM righe_ordini ro
                    INNER JOIN magazzino m ON m.id = ro.vino
                    INNER JOIN vini v ON v.id = m.vino
                    INNER JOIN cantine c ON c.id = m.cantina
                    INNER JOIN vitigni vg ON vg.id = v.vitigno
                    INNER JOIN tipologie t ON t.id = v.tipologia
                    WHERE ro.ordine = :ordine;',
                    [
                        'ordine' => $order['id']
                    ])
            ];
        }
        return $orders;
    }

    public static function transfer(int $user)
    {
        // Verifica disponibilità magazzino
        $check = Database::select("SELECT COUNT(*) as tot FROM righe_carrello rc
            INNER JOIN magazzino m ON m.id = rc.vino
            WHERE rc.utente = :usr AND m.quantita - rc.quantita < 0;", [
            'usr' => $user
        ])[0]['tot'] ?? 0;
        if ($check > 0) {
            throw new \Exception('Magazzino insufficiente');
        }

        // Calcola il totale dell'ordine
        $price = Database::select('SELECT SUM(m.prezzo_vendita * rc.quantita) as sum FROM righe_carrello rc 
            INNER JOIN magazzino m ON m.id = rc.vino
            WHERE rc.utente = :user;', [
            'user' => $user
        ])[0]['sum'] ?? 0;

        if (!$price) {
            return;
        }

        $codici = CarrelloCodiciSconto::fetch($user, -1);

        // Applica i codici sconto
        if (count($codici) > 0) {
            foreach ($codici as $codice) {
                if ($codice['decimale']) {
                    $price -= $codice['decimale'];
                }
                if ($codice['percentuale']) {
                    $price -= $codice['percentuale'] / 100 * $price;
                }
            }
        }

        if ($price < 0) {
            $price = 0;
        }

        // Segna i codici sconto come usati
        if (count($codici) > 0) {
            Database::execute('update righe_carrello_sconti set usato = 1 where utente = :uid;', [
                'uid' => $user
            ]);
        }

        // Crea l'ordine
        Database::execute("INSERT INTO ordini(utente, totale, data) VALUES (:utente, :sum, NOW());", [
            'utente' => $user,
            'sum' => $price
        ]);
        $ordine = Database::lastInsertId();

        // Trasferisci gli articoli dal carrello all'ordine
        Database::execute('INSERT INTO righe_ordini(ordine, vino, quantita)
            SELECT :ordine, rc.vino, rc.quantita FROM righe_carrello rc
            WHERE rc.utente = :user;',[
            'ordine' => $ordine,
            'user' => $user
        ]);

        // Aggiorna le quantità in magazzino
        Database::execute('UPDATE magazzino m
            INNER JOIN righe_carrello rc ON m.id = rc.vino
            SET m.quantita = m.quantita - rc.quantita
            WHERE rc.utente = :user;', [
            'user' => $user
        ]);

        // Svuota il carrello
        Database::execute('DELETE FROM righe_carrello WHERE utente = :user;', [
            'user' => $user
        ]);
    }

    public static function ordineAbbonamento(int $user, array $vini){
        // Crea ordine da abbonamento
        Database::execute("INSERT INTO ordini(utente, da_abbonamento, totale, data) VALUES (:utente, 1, 0, NOW());", [
            'utente' => $user,
        ]);
        $ordine = Database::lastInsertId();

        // Aggiungi i vini all'ordine
        foreach ($vini as $vino) {
            Database::execute('INSERT INTO righe_ordini(ordine, vino, quantita) VALUES (:ordine, :vino, 1);', [
                'ordine' => $ordine,
                'vino' => $vino
            ]);
        }

        // Aggiorna le quantità in magazzino
        Database::execute('UPDATE magazzino m
            INNER JOIN righe_ordini ro ON m.id = ro.vino
            SET m.quantita = m.quantita - ro.quantita
            WHERE ro.ordine = :ordine;', [
            'ordine' => $ordine
        ]);
    }

    public static function ultimiInviati(int $user){
        $vini = Database::select("select distinct m.vino from 
            (select * from ordini o
            WHERE o.da_abbonamento = 1 and o.utente = :uid
            order by o.id desc limit 2) o
            inner join righe_ordini ro on ro.ordine = o.id
            inner join magazzino m on m.id = ro.vino;", [
            'uid' => $user
        ]);
        return array_column($vini, 'vino');
    }
}