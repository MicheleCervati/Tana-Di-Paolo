<?php

namespace App\Model;
require_once 'Database/Database.php';
use Database\Database;

class Vino
{
    public static function fetchAll(int $limit = 10, int $offset = 0, array $filters = [], string $ordinamento="nome", $ordinamentoTipo='asc'): array
    {
        $query = 'SELECT m.id, v.nome, m.cantina as cid, c.cantina, v.vitigno as vid, vi.vitigno, v.tipologia as tid, t.tipologia,
            m.invecchiamento as iid,i.invecchiamento, m.alcol, m.annata, m.prezzo_vendita, m.immagine, m.quantita as quantita_magazzino FROM vini v
            inner join magazzino m on m.vino = v.id
            inner join tipologie t on t.id = v.tipologia
            inner join cantine c on c.id = m.cantina
            inner join invecchiamenti i on i.id = m.invecchiamento
            inner join vitigni vi on vi.id = v.vitigno';
        $binds = [];
        if (count($filters) > 0) {
            $query .= ' WHERE ';
            foreach ($filters as $key => $value) {
                switch ($key) {
                    case 'min_prezzo':
                        $query .= " m.prezzo_vendita >= :minPrezzo AND ";
                        $binds[':minPrezzo'] = $value;
                        break;
                    case 'max_prezzo':
                        $query .= " m.prezzo_vendita <= :maxPrezzo AND ";
                        $binds[':maxPrezzo'] = $value;
                        break;
                    case 'tipologia':
                        $tipologie = $value;
                        $query .= " t.tipologia IN (";
                        foreach ($tipologie as $i => $tipologia) {
                            $query .= ":tipologia$i, ";
                            $binds[":tipologia$i"] = $tipologia;
                        }
                        $query = rtrim($query, ', ') . ") AND ";
                        break;
                    case 'nome':
                        $query .= " v.nome LIKE :nome AND ";
                        $binds[':nome'] = "%$value%";
                        break;
                }
            }
            $query = rtrim($query, ' AND ');
        }
        $query.= match($ordinamento) {
            'nome' => ' ORDER BY v.nome',
            'prezzo_vendita' => ' ORDER BY m.prezzo_vendita',
            'annata' => ' ORDER BY m.annata',
            default => ' ORDER BY v.nome'
        };
        $query.= match($ordinamentoTipo) {
            'asc' => ' asc',
            'desc' => ' desc',
            default => ' asc'
        };
        $query.= " limit $limit offset $offset";
        return Database::select($query, $binds);
    }

    public static function fetch(int $id): array
    {
        $query = 'SELECT m.id, v.nome, m.aromi, m.cantina as cid, c.cantina, v.vitigno as vid, vi.vitigno, v.tipologia as tid, t.tipologia, m.invecchiamento as iid, i.invecchiamento, m.alcol,
            m.annata, m.maturazione, m.zuccheri_residui, m.glicerolo, m.passiti, m.acido_tartarico, m.acido_malico,
            m.acido_citrico, m.acido_lattico, m.tannini, m.prezzo_vendita, m.immagine, m.quantita as quantita_magazzino FROM vini v
            inner join magazzino m on m.vino = v.id
            inner join tipologie t on t.id = v.tipologia
            inner join cantine c on c.id = m.cantina
            inner join invecchiamenti i on i.id = m.invecchiamento
            inner join vitigni vi on vi.id = v.vitigno
            where m.id = :id';
        $result = Database::select($query, [':id' => $id]);
        return $result[0] ?? [];
    }

    public static function count(array $filters = []){
        $query = 'SELECT count(*) as count 
              FROM vini v 
              INNER JOIN tipologie t ON t.id = v.tipologia
              INNER JOIN magazzino m ON m.vino = v.id';

        $binds = [];
        if (count($filters) > 0) {
            $query .= ' WHERE ';
            foreach ($filters as $key => $value) {
                switch ($key) {
                    case 'min_prezzo':
                        $query .= " m.prezzo_vendita >= :minPrezzo AND ";
                        $binds[':minPrezzo'] = $value;
                        break;
                    case 'max_prezzo':
                        $query .= " m.prezzo_vendita <= :maxPrezzo AND ";
                        $binds[':maxPrezzo'] = $value;
                        break;
                    case 'tipologia':
                        $tipologie = $value;
                        $query .= " t.tipologia IN (";
                        foreach ($tipologie as $i => $tipologia) {
                            $query .= ":tipologia$i, ";
                            $binds[":tipologia$i"] = $tipologia;
                        }
                        $query = rtrim($query, ', ') . ") AND ";
                        break;
                    case 'nome':
                        $query .= " v.nome LIKE :nome AND ";
                        $binds[':nome'] = "%$value%";
                        break;
                }
            }
            $query = rtrim($query, ' AND ');
        }

        return Database::select($query, $binds)[0]['count'];
    }


    public static function maxStats(){
        return Database::select("
        SELECT 
            MAX(m.alcol) AS alcol,
            MAX(m.maturazione) AS maturazione,
            MAX(m.zuccheri_residui) AS zuccheri_residui,
            MAX(m.glicerolo) AS glicerolo,
            MAX(m.passiti) AS passiti,
            MAX(m.acido_tartarico) AS acido_tartarico,
            MAX(m.acido_malico) AS acido_malico,
            MAX(m.acido_citrico) AS acido_citrico,
            MAX(m.tannini) AS tannini,
            MAX(i.affinamento) AS affinamento
        FROM magazzino m
        INNER JOIN invecchiamenti i ON i.id = m.invecchiamento
    ")[0];
    }


    public static function minStats(){
        return Database::select("
        SELECT 
            MIN(m.alcol) AS alcol,
            MIN(m.maturazione) AS maturazione,
            MIN(m.zuccheri_residui) AS zuccheri_residui,
            MIN(m.glicerolo) AS glicerolo,
            MIN(m.passiti) AS passiti,
            MIN(m.acido_tartarico) AS acido_tartarico,
            MIN(m.acido_malico) AS acido_malico,
            MIN(m.acido_citrico) AS acido_citrico,
            MIN(m.tannini) AS tannini,
            MIN(i.affinamento) AS affinamento
        FROM magazzino m
        INNER JOIN invecchiamenti i ON i.id = m.invecchiamento
    ")[0];
    }
}