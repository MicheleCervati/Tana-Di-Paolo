<?php
require_once 'App/Model/CarrelloCodiciSconto.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
require_once 'Functions/Shadows.php';
use App\Model\CarrelloCodiciSconto;
use Functions\Log;
use Functions\Panic;
use Functions\Shadows;
use Database\Database;

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$uid = $_SESSION['uid'] ?? -1;
$sid = isset($_SESSION['uid']) ? -1 : Shadows::getID();

$code = $_POST['codice'] ?? null;

if (!$uid && !$sid) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Sessione non valida'
    ]);
    exit;
}

if (!$code) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Codice sconto non fornito'
    ]);
    exit;
}

try {
    Database::connect();

    // Aggiungi il codice sconto al carrello (questo verificherà anche la validità)
    CarrelloCodiciSconto::add($uid, $sid, $code);

    // Recupera i dettagli del codice sconto applicato
    $rawCarrello = CarrelloCodiciSconto::fetch($uid, $sid);

    if (empty($rawCarrello)) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Nessun codice sconto trovato'
        ]);
        exit;
    }

    // Trova il codice sconto specifico tra quelli disponibili
    $scontoApplicato = null;
    foreach ($rawCarrello as $sconto) {
        if ($sconto['code'] === $code) {
            $scontoApplicato = $sconto;
            break;
        }
    }

    if (!$scontoApplicato) {
        echo json_encode([
            'status' => 'error',
            'message' => 'Codice sconto non valido'
        ]);
        exit;
    }

    // Determina se è percentuale o decimale
    if ($scontoApplicato['percentuale'] != 0) {
        echo json_encode([
            'status' => 'success',
            'tipo' => 'percentuale',
            'percentuale' => floatval($scontoApplicato['percentuale']),
            'codice' => $code
        ]);
    } else {
        echo json_encode([
            'status' => 'success',
            'tipo' => 'decimale',
            'decimale' => floatval($scontoApplicato['decimale']),
            'codice' => $code
        ]);
    }

} catch (Exception $e) {
    Log::write($e);

    // Gestisci l'eccezione specifica per codice non valido
    if ($e->getMessage() === 'Not Valid') {
        echo json_encode([
            'status' => 'error',
            'message' => 'Codice sconto non valido'
        ]);
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'Errore interno del server'
        ]);
    }
}