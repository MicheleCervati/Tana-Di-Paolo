<?php
namespace Router;
include 'Route.php';
class Router
{
    private array $routes = [];
    public function add(Route $route): void{
        $this->routes[] = $route;
    }

    public function match(string $uri, string $method): array {
        foreach ($this->routes as $route) {
            if (preg_match($route->getPattern(), $uri, $matches)) {
                if (!in_array($method, $route->getMethods())) {
                    throw new \Exception("405");
                }
                return [
                    'controller' => $route->getController(),
                    'action' => $route->getAction(),
                    'params' => array_slice($matches, 1),
                ];
            }
        }
        throw new \Exception("404");
    }
}