<?php

namespace Functions;
require_once 'Config/Project.php';
require_once 'Config/Codes.php';

use Config\Project as Config;
use Config\Codes as Codes;

class Panic
{
    public static function panic(string $location, string $code, string $referer = ''): void
    {
        if ($referer) {
            $referer = '&ref=' . urlencode($referer);
        }
        header("Location: " . Config::$path . "$location?err={$code}{$referer}");
        die();
    }

    public static function panicAPI(int $err_code, string $code): void
    {
        echo json_encode([
            'error' => true,
            'error_code' => $err_code,
            'message' => Codes::$errors[$err_code] ?? 'Unknown error',
        ]);
        http_response_code($code);
        die();
    }
}