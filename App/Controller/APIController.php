<?php
namespace App\Controller;
require_once 'App/Model/User.php';
require_once 'Config/Log.php';
use Database\Database;

Database::connect();

class APIController
{
    public function showAllWines(): void
    {
        require 'App/API/vini/getAll.php';
    }

    public function controlla_sconto(): void
    {
        require 'App/API/promo_codes/verifica_sconto.php';
    }

    public function showWine(array $params): void
    {
        $vid = $params[0];
        require 'App/API/vini/get.php';
    }

    public function showAllCantine(): void
    {
        require 'App/API/getCantine.php';
    }

    public function showAllVitigni(): void
    {
        require 'App/API/getVitigni.php';
    }

    public function showAllInvecchiamenti(): void
    {
        require 'App/API/getInvecchiamenti.php';
    }

    public function showAllTipologie(): void
    {
        require 'App/API/getTipologie.php';
    }

    public function showAllAbbonamenti(): void
    {
        require 'App/API/getAbbonamenti.php';
    }

    public function showUser(): void
    {
        require 'App/API/user/get.php';
    }

    public function updateUser(): void
    {
        require 'App/API/user/update.php';
    }

    public function showCarrello(): void
    {
        require 'App/API/carrello/get.php';
    }

    public function addCarrello(): void
    {
        require 'App/API/carrello/add.php';
    }

    public function deleteCarrello(): void
    {
        require 'App/API/carrello/delete.php';
    }

    public function updateCarrello(): void
    {
        require 'App/API/carrello/update.php';
    }

    public function addCodiceSconto(): void
    {
        require 'App/API/promo_codes/add.php';
    }
    public function deleteCodiceSconto(): void
    {
        require 'App/API/promo_codes/delete.php';
    }
    public function getCodiciSconto(): void
    {
        require 'App/API/promo_codes/get.php';
    }
    public function processPayment(): void
    {
        require 'App/API/ordini/process_payment.php';
    }

    public function getOrdini(): void
    {
        require 'App/API/ordini/get.php';
    }

    public function loadQuestionario(): void
    {
        require 'App/API/questionario/get.php';
    }

    public function saveQuestionario(): void
    {
        require 'App/API/questionario/save.php';
    }

    public function simulate_algoritmo(): void {
        require 'App/API/algoritmo/simula.php';
    }

    public function run_algoritmo(): void {
        require 'App/API/algoritmo/run.php';
    }
}