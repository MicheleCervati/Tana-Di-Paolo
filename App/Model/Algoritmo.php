<?php

namespace App\Model;
require_once 'Database/Database.php';

use Database\Database;

class Algoritmo
{
    public static function run(int $round, float $step, int $quantity, array $massimi, array $minimi, array $questionario, array $ultimiInviati): array{
        $vini = [];
        $viniID = [];

        for ($i = 1; $i <= $round; $i++){
            $query = 'SELECT m.id, m.vino FROM magazzino m 
                     INNER JOIN vini v ON v.id = m.vino 
                     INNER JOIN invecchiamenti i ON i.id = m.invecchiamento 
                     WHERE ';

            $precisione = 1 - $step * $i;
            $params = [];
            $paramCounter = 0;

            foreach ($massimi as $key => $valore){
                if ($key == 'passiti'){
                    if ($questionario[$key] == 0.5){
                        $query .= "m.passiti IN (0, 1) AND ";
                    } else {
                        $paramName = 'param' . $paramCounter++;
                        $query .= "m.passiti = :$paramName AND ";
                        $params[$paramName] = $questionario[$key];
                    }
                    continue;
                }

                // Determina l'alias corretto per il campo
                $alias = 'm.';
                if ($key === 'affinamento') {
                    $alias = 'i.';
                }

                $min = $minimi[$key] + ($valore - $minimi[$key]) * ($questionario[$key] - $step * $i);
                $max = $minimi[$key] + ($valore - $minimi[$key]) * ($questionario[$key] + $step * $i);

                $minParam = 'min' . $paramCounter;
                $maxParam = 'max' . $paramCounter;
                $paramCounter++;

                $query .= "$alias$key BETWEEN :$minParam AND :$maxParam AND ";
                $params[$minParam] = $min;
                $params[$maxParam] = $max;
            }

            // Rimuovi l'ultimo " AND "
            $query = substr($query, 0, -5);

            // Aggiungi condizioni per disponibilità e tipologie
            $query .= " AND m.quantita > 0";

            if (!empty($questionario['tipologie'])) {
                $tipologieIds = array_column($questionario['tipologie'], 'id');
                $tipologieParams = [];
                foreach ($tipologieIds as $index => $tipologiaId) {
                    $paramName = 'tipologia' . $index;
                    $tipologieParams[] = ':' . $paramName;
                    $params[$paramName] = $tipologiaId;
                }
                $query .= " AND v.tipologia IN (" . implode(',', $tipologieParams) . ")";
            }

            // Escludi gli ultimi inviati
            if (!empty($ultimiInviati)) {
                $ultimiParams = [];
                foreach ($ultimiInviati as $index => $ultimoId) {
                    $paramName = 'ultimo' . $index;
                    $ultimiParams[] = ':' . $paramName;
                    $params[$paramName] = $ultimoId;
                }
                $query .= " AND m.vino NOT IN (" . implode(',', $ultimiParams) . ")";
            }

            $query .= " ORDER BY m.qualita DESC";

            $risultati = Database::select($query, $params);

            foreach ($risultati as $risultato) {
                if (!in_array($risultato['id'], $viniID)){
                    $ultimiInviati[] = $risultato['vino'];
                    $risultato['precisione'] = $precisione;
                    $vini[] = $risultato;
                    $viniID[] = $risultato['id'];
                    if (count($vini) >= $quantity){
                        break;
                    }
                }
            }

            if (count($vini) >= $quantity){
                break;
            }
        }

        if (count($vini) < $quantity){
            throw new \Exception('No match', 400);
        }

        return $vini;
    }
}