<?php
/**
 * @var int $vid
 */
require_once 'App/Model/Vino.php';
require_once 'Functions/Log.php';
require_once 'Functions/Panic.php';
require_once 'formatRaw.php';

use App\Model\Vino;
use Functions\Log;
use Functions\Panic;
use Database\Database;

Database::connect();

header('Access-Control-Allow-Origin: *');
header('Content-Type: application/json');

try {
    $vino = Vino::fetch($vid);
} catch (Exception $e) {
    Log::write($e);
    Panic::panicAPI(0, 500);
}

if (!$vino) {
    Panic::panicAPI(7, 404);
}

formatRaw($vino);
unset($vino['cid']);
unset($vino['vid']);
unset($vino['tid']);

echo json_encode($vino);