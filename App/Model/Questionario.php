<?php

namespace App\Model;
use Database\Database;

class Questionario
{
    public static function loadRisposte(int $user){
        $risposte = Database::select("select * from questionari where utente = :user;", [
            'user' => $user
        ]) ?? [];
        if (empty($risposte)) {
            return [];
        }
        $risposte = $risposte[0];
        $tipologie = Database::select('select t.* from tipologie_preferite tp
            inner join tipologie t on t.id = tp.tipologia
            where tp.questionario = :user;', [
            'user' => $risposte['utente']
        ]) ?? [];
        $risposte['tipologie'] = $tipologie;
        return $risposte;
    }

    public static function saveRisposte(int $user, array $risposte, array $tipologie): void {
        $risposta = Database::select("select q.utente from questionari q where q.utente = :user;", [
            'user' => $user
        ]) ?? [];
        if (empty($risposta)) {
            Database::execute('insert into questionari(utente) values (:user);', [
                'user' => $user
            ]);
        }

        // Costruzione delle parti della query per l'update
        $setClauses = [];
        $bindParams = ['user' => $user];

        // Controlla ogni possibile campo e lo aggiunge alla query se presente nei dati
        $possibleFields = [
            'alcol', 'zuccheri_residui', 'glicerolo', 'acido_tartarico',
            'acido_malico', 'acido_citrico', 'tannini',
            'affinamento', 'passiti', 'maturazione'
        ];

        foreach ($possibleFields as $field) {
            if (isset($risposte[$field])) {
                $setClauses[] = "$field = :$field";
                $bindParams[$field] = $risposte[$field];
            }
        }

        // Se ci sono campi da aggiornare, esegui la query
        if (!empty($setClauses)) {
            $setClause = implode(', ', $setClauses);
            $query = "UPDATE questionari SET $setClause WHERE utente = :user";
            Database::execute($query, $bindParams);
        }

        Database::execute('delete from tipologie_preferite where questionario = :user;', [
            'user' => $user
        ]);

        // Inserimento delle nuove tipologie
        foreach ($tipologie as $tipologia) {
            Database::execute('insert into tipologie_preferite(questionario, tipologia) values (:user, :tipologia);', [
                'user' => $user,
                'tipologia' => $tipologia
            ]);
        }
    }
}