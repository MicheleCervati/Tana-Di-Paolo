<?php
require 'Router/Router.php';
require 'Functions/Session.php';
use Router\Router;
use Router\Route;
use Functions\Session;

$uri = explode('?', $_SERVER['REQUEST_URI'])[0];
$path = dirname($_SERVER['PHP_SELF']);
$uri = '/' . trim(str_replace($path, '', $uri), '/');

$router = new Router();
$router->add(new Route('/', ['GET'], 'HomeController', 'show'));
$router->add(new Route('/catalogo', ['GET'], 'ViniController', 'catalogo'));
$router->add(new Route('/vino/dettaglio/([0-9]+)', ['GET'], 'ViniController', 'vino'));
$router->add(new Route('/account/login', ['GET'], 'AccountController', 'login'));
$router->add(new Route('/account/register', ['GET'], 'AccountController', 'register'));
$router->add(new Route('/account/show', ['GET'], 'AccountController', 'show'));
$router->add(new Route('/account/questionario', ['GET'], 'AccountController', 'questionario'));
$router->add(new Route('/account/ordini', ['GET'], 'AccountController', 'ordini'));
$router->add(new Route('/account/algoritmo', ['GET'], 'AccountController', 'algoritmo'));
$router->add(new Route('/carrello', ['GET'], 'CartController', 'carrello'));
$router->add(new Route('/carrello/checkout', ['GET'], 'CartController', 'checkout'));
$router->add(new Route('/abbonamenti', ['GET'], 'AbbonamentiController', 'abbonamenti'));
$router->add(new Route('/chiSiamo', ['GET'], 'ChiSiamoController', 'chiSiamo'));

$router->add(new Route('/api/vini/lista', ['GET'], 'APIController', 'showAllWines'));
$router->add(new Route('/api/vino/([0-9]+)', ['GET'], 'APIController', 'showWine'));
$router->add(new Route('/api/cantine/lista', ['GET'], 'APIController', 'showAllCantine'));
$router->add(new Route('/api/vitigni/lista', ['GET'], 'APIController', 'showAllVitigni'));
$router->add(new Route('/api/invecchiamenti/lista', ['GET'], 'APIController', 'showAllInvecchiamenti'));
$router->add(new Route('/api/tipologie/lista', ['GET'], 'APIController', 'showAllTipologie'));
$router->add(new Route('/api/abbonamenti/lista', ['GET'], 'APIController', 'showAllAbbonamenti'));
$router->add(new Route('/api/user/dettagli', ['GET'], 'APIController', 'showUser'));
$router->add(new Route('/api/user/update', ['POST'], 'APIController', 'updateUser'));
$router->add(new Route('/api/carrello/get', ['GET'], 'APIController', 'showCarrello'));
$router->add(new Route('/api/carrello/add', ['POST'], 'APIController', 'addCarrello'));
$router->add(new Route('/api/carrello/update', ['POST'], 'APIController', 'updateCarrello'));
$router->add(new Route('/api/carrello/delete', ['POST'], 'APIController', 'deleteCarrello'));
$router->add(new Route('/api/sconto/verifica', ['POST'], 'APIController', 'controlla_sconto'));
$router->add(new Route('/api/codici_sconto/get', ['GET'], 'APIController', 'getCodiciSconto'));
$router->add(new Route('/api/codici_sconto/add', ['POST'], 'APIController', 'addCodiceSconto'));
$router->add(new Route('/api/codici_sconto/delete', ['POST'], 'APIController', 'deleteCodiceSconto'));
$router->add(new Route('/api/ordini/process_payment', ['POST'], 'APIController', 'processPayment'));
$router->add(new Route('/api/ordini/display', ['GET'], 'APIController', 'getOrdini'));
$router->add(new Route('/api/questionario/load', ['GET'], 'APIController', 'loadQuestionario'));
$router->add(new Route('/api/questionario/save', ['POST'], 'APIController', 'saveQuestionario'));
$router->add(new Route('/api/algoritmo/simulate', ['GET'], 'APIController', 'simulate_algoritmo'));
$router->add(new Route('/api/algoritmo/run', ['POST'], 'APIController', 'run_algoritmo'));

$router->add(new Route('/action/login', ['POST'], 'SessionController', 'login'));
$router->add(new Route('/action/logout', ['POST'], 'SessionController', 'logout'));
$router->add(new Route('/action/register', ['POST'], 'SessionController', 'register'));

try {
    $route = $router->match($uri, $_SERVER['REQUEST_METHOD']);
    $controllerName = $route['controller'];
    $actionName = $route['action'];
    require_once "App/Controller/$controllerName.php";
    $controllerName = 'App\\Controller\\' . $controllerName;
    $controllerObj = new $controllerName();
    Session::start();
    $controllerObj->$actionName($route['params']);
} catch (Exception $e) {
    if ($e->getMessage() === "404") {
        http_response_code(404);
        require 'App/View/http_errors/404.php';
    } elseif ($e->getMessage() === "405") {
        http_response_code(405);
        require 'App/View/http_errors/405.php';
    } else {
        http_response_code(500);
        require 'App/View/http_errors/500.php';
    }
}