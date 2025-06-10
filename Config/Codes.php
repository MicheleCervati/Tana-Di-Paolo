<?php

namespace Config;

class Codes
{
    public static array $errors = [
        '-1' => 'Errore generico',
        '0' => 'Impossibile connettersi al database',
        '1' => 'Errore nella richiesta',
        '2' => 'Password errata o account non esistente',
        '3' => 'Le password non corrispondono',
        '4' => 'Email già in uso',
        '5' => 'Non sei autenticato',
        '6' => 'Le password non coincidono',
        '7' => 'Risorsa non esistente',
        '8' => 'Questionario non compilato',
        '9' => 'La ricerca non ha prodotto risultati, contatta un nostro somelier all\'indirizzo email somelier@latanadipaolo.it',
        '10' => 'Impossibile completare l\'ordine per disponibilità insufficiente',
        '11' => 'Non hai abbonamenti attivi',
        '12' => 'Codice sconto non valido',
    ];

    public static array $successes = [
        '-1' => 'Operazione completata con successo',
        '0' => 'Pagamento effettuato con successo',
    ];
}