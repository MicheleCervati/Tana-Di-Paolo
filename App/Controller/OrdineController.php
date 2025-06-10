<?php

namespace App\Controller;

class OrdineController  extends Controller
{
    /**
     * Costruttore
     */
    public function __construct()
    {
        parent::__construct();
        // Verifica che l'utente sia autenticato per accedere a queste funzionalità
        $this->checkLogin();
    }
    /**
     * API: Recupera lo storico degli ordini dell'utente
     */
    public function storico() {
        // Recupera l'ID dell'utente dalla sessione
        $userId = $_SESSION['user_id'];

        // Inizializza il modello ordini
        $ordiniModel = $this->loadModel('OrdiniModel');

        // Recupera tutti gli ordini dell'utente
        $ordini = $ordiniModel->getOrdiniByUserId($userId);

        // Invia la risposta come JSON
        header('Content-Type: application/json');
        echo json_encode($ordini);
        exit;
    }

    /**
     * API: Recupera i dettagli di un ordine specifico
     * @param int $id - ID dell'ordine
     */
    public function dettaglio($id) {
        // Recupera l'ID dell'utente dalla sessione
        $userId = $_SESSION['user_id'];

        // Inizializza il modello ordini
        $ordiniModel = $this->loadModel('OrdiniModel');

        // Verifica che l'ordine appartenga all'utente
        $ordine = $ordiniModel->getOrdineById($id);

        if (!$ordine || $ordine['user_id'] != $userId) {
            // Se l'ordine non esiste o non appartiene all'utente corrente
            header('Content-Type: application/json');
            echo json_encode([
                'status' => 'error',
                'message' => 'Ordine non trovato'
            ]);
            exit;
        }

        // Recupera i dettagli completi dell'ordine (prodotti, abbonamento ecc.)
        $dettaglioOrdine = $ordiniModel->getDettaglioOrdine($id);

        // Invia la risposta come JSON
        header('Content-Type: application/json');
        echo json_encode([
            'status' => 'success',
            'ordine' => $dettaglioOrdine
        ]);
        exit;
    }

    /**
     * API: Elabora un nuovo ordine
     */
    public function process_payment() {
        // Recupera l'ID dell'utente dalla sessione
        $userId = $_SESSION['user_id'];

        // Inizializza i modelli necessari
        $carrelloModel = $this->loadModel('CarrelloModel');
        $ordiniModel = $this->loadModel('OrdiniModel');
        $abbonamentiModel = $this->loadModel('AbbonamentiModel');

        // Recupera i prodotti nel carrello
        $prodottiCarrello = $carrelloModel->getCarrelloItems($userId);

        if (empty($prodottiCarrello)) {
            // Se il carrello è vuoto e non è stato richiesto un abbonamento, errore
            if (!isset($_POST['abbonamento'])) {
                header('Content-Type: application/json');
                echo json_encode([
                    'success' => false,
                    'message' => 'Il carrello è vuoto'
                ]);
                exit;
            }
        }

        // Inizializza i dati dell'ordine
        $dataOrdine = [
            'user_id' => $userId,
            'data_ordine' => date('Y-m-d H:i:s'),
            'stato' => 'In elaborazione',
            'metodo_pagamento' => 'Carta di credito' // Default, potrebbe essere passato dal form
        ];

        // Gestione dell'abbonamento se presente
        $abbonamentoId = isset($_POST['abbonamento']) ? (int)$_POST['abbonamento'] : null;
        $abbonamento = null;

        if ($abbonamentoId) {
            $abbonamento = $abbonamentiModel->getAbbonamentoById($abbonamentoId);
            if ($abbonamento) {
                $dataOrdine['abbonamento_id'] = $abbonamentoId;
            }
        }

        // Crea il nuovo ordine
        $ordineId = $ordiniModel->creaOrdine($dataOrdine);

        if (!$ordineId) {
            header('Content-Type: application/json');
            echo json_encode([
                'success' => false,
                'message' => 'Errore durante la creazione dell\'ordine'
            ]);
            exit;
        }

        // Salva i prodotti dell'ordine
        foreach ($prodottiCarrello as $prodotto) {
            $ordiniModel->aggiungiProdottoOrdine([
                'ordine_id' => $ordineId,
                'vino_id' => $prodotto['vino']['id'],
                'quantita' => $prodotto['quantita'],
                'prezzo_unitario' => 19.99 // Prezzo fisso come nel file pagamento.js
            ]);
        }

        // Svuota il carrello dopo aver completato l'ordine
        $carrelloModel->svuotaCarrello($userId);

        // Risposta di successo
        header('Content-Type: application/json');
        echo json_encode([
            'success' => true,
            'ordine_id' => $ordineId
        ]);
        exit;
    }
}