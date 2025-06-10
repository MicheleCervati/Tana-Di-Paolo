<?php

namespace Config;

class Questionario
{
    public static array $domande = [
        // Domanda 1: Scelta dello Stile di Vino
        [
            'titolo' => 'Se dovessi scegliere un\'esperienza enologica ideale, quale di questi stili ti attrae di più?',
            'tipo' => 'radio',
            'nome' => 'tipo',
            'opzioni' => [
                ['testo' => 'Vini chiari e freschi', 'valore' => 'Bianco'],
                ['testo' => 'Vini da dessert concentrati e maturi', 'valore' => 'Passito'],
                ['testo' => 'Vini intensi e strutturati', 'valore' => 'Rosso'],
                ['testo' => 'Bollicine festose', 'valore' => 'Spumante']
            ],
        ],

        // Domanda 2: Sensazione di Calore e Intensità
        [
            'titolo' => 'Quanto ti piace un vino che ti trasmette una sensazione di calore e intensità, come se avessi una scossa di energia al primo sorso?',
            'tipo' => 'slider',
            'nome' => 'alcol',
            'min' => 0,
            'max' => 100,
        ],

        // Domanda 3: Gusto Secco e Definito
        [
            'titolo' => 'Quanto prediligi un\'esperienza netta, dove la dolcezza non interferisce con la definizione del gusto?',
            'tipo' => 'slider',
            'nome' => 'zuccheri_residui',
            'min' => 0,
            'max' => 100,
        ],

        // Domanda 4: Sensazione Morbida e Avvolgente
        [
            'titolo' => 'Quanto apprezzi quella sensazione vellutata, come se il vino accarezzasse il palato in modo avvolgente?',
            'tipo' => 'slider',
            'nome' => 'glicerolo',
            'min' => 0,
            'max' => 100,
        ],

        // Domanda 5: Freschezza e Vivacità al Palato
        [
            'titolo' => 'Quanto ti piace sperimentare una sensazione immediata di freschezza che ti risveglia i sensi all\'assaggio?',
            'tipo' => 'slider',
            'nome' => 'acido_tartarico',
            'min' => 0,
            'max' => 100,
        ],

        // Domanda 6: Intensità della Spinta Fruttata
        [
            'titolo' => 'Quanto ti piace percepire una spinta leggera che esalta le note di frutta fresca, come un\'energia brillante che arricchisce il gusto?',
            'tipo' => 'slider',
            'nome' => 'acido_malico',
            'min' => 0,
            'max' => 100,
        ],

        // Domanda 7: Tocco Agrumato di Vivacità
        [
            'titolo' => 'Quanto trovi affascinante quella leggera scintilla agrumata che dona al vino un tocco di luminosità?',
            'tipo' => 'slider',
            'nome' => 'acido_citrico',
            'min' => 0,
            'max' => 100,
        ],

        // Domanda 8: Struttura e Persistenza
        [
            'titolo' => 'Quanto ti piace che il vino lasci in bocca una sensazione di presenza e durata, come un\'eco che si percepisce anche a distanza?',
            'tipo' => 'slider',
            'nome' => 'tannini',
            'min' => 0,
            'max' => 100,
        ],

        // Domanda 9: Influenza del Contatto con il Legno
        [
            'titolo' => 'Quanto è importante per te che il vino esprima sfumature complesse, derivanti da un affinamento in legno che ne arricchisce la struttura?',
            'tipo' => 'slider',
            'nome' => 'affinamento',
            'min' => 0,
            'max' => 100,
        ],

        // Domanda 10: Propensione verso Tecniche di Vinificazione Concentrata
        [
            'titolo' => 'Quanto sei attratto da vini che sono il risultato di processi produttivi che enfatizzano la concentrazione e intensità del gusto?',
            'tipo' => 'radio',
            'nome' => 'passiti',
            'opzioni' => [
                ['testo' => 'Molto incline', 'valore' => 100],
                ['testo' => 'Moderatamente incline', 'valore' => 50],
                ['testo' => 'Poco incline', 'valore' => 0]
            ],
        ],

        // Domanda 11: Preferenza per il Livello di Maturazione
        [
            'titolo' => 'Quanto preferisci che il vino esprima il carattere di una maturazione evoluta rispetto alla freschezza di una giovinezza spiccatamente vibrante?',
            'tipo' => 'radio',
            'nome' => 'annata',
            'opzioni' => [
                ['testo' => 'Giovane e vivace', 'valore' => 0],
                ['testo' => 'Un equilibrio tra giovinezza e maturità', 'valore' => 50],
                ['testo' => 'Maturo e complesso', 'valore' => 100]
            ],
        ]
    ];
}