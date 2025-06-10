<?php
require_once 'App/Model/Vino.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
require_once 'formatRaw.php';
use Functions\Log;
use Functions\Panic;
use App\Model\Vino;
use Database\Database;

Database::connect();

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

$minPrezzo = $_GET['min_prezzo'] ?? null;
$maxPrezzo = $_GET['max_prezzo'] ?? null;
$tipologia = $_GET['tipologia'] ?? [];
$nome = $_GET['nome'] ?? null;
$ordinamento = $_GET['ordinamento'] ?? "nome";
$ordinamentoTipo = $_GET['ordinamentoTipo'] ?? "asc";
$pagina = $_GET['pagina'] ?? 1;
$limit = $_GET['limit'] ?? 10;

if (($minPrezzo && !is_numeric($minPrezzo)) || ($maxPrezzo && !is_numeric($maxPrezzo)) ||
    ($tipologia && !is_array($tipologia)) || ($pagina && !is_numeric($pagina)) || ($limit && !is_numeric($limit))) {
    Panic::panicAPI(1, 400);
}
$filters = [];
$minPrezzo && $filters['min_prezzo'] = $minPrezzo;
$maxPrezzo && $filters['max_prezzo'] = $maxPrezzo;
$tipologia && $filters['tipologia'] = $tipologia;
$nome && $filters['nome'] = $nome;

try {
    $vini = Vino::fetchAll(
        limit: $limit,
        offset: ($pagina - 1) * $limit,
        filters: $filters,
        ordinamento: $ordinamento,
        ordinamentoTipo: $ordinamentoTipo
    );
    $count = Vino::count($filters);
} catch (Exception $e) {
    echo $e;
    Log::write($e);
    Panic::panicAPI(0, 500);
}

foreach ($vini as &$vino)
{
    formatRaw($vino);
}

echo json_encode([
    "pagina" => $pagina,
    "pagine_totali" => ceil($count / $limit),
    "vini_trovati" => $count,
    "vini_mostrati" => count($vini),
    "vini" => $vini,
]);

# EX: /api/vini/lista?limit=20&pagina=2&max_prezzo=20&tipologia[]=bianco&tipologia[]=rosso