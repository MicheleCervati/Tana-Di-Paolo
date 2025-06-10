<?php

namespace Functions;
require 'Config/Log.php';
use Config\Log as Config;

class Log extends Config
{
    static private function getDirectory(): string{
        $directory = dirname(__DIR__).DIRECTORY_SEPARATOR.Config::$folder;
        if (!is_dir($directory)) {
            mkdir($directory, 0777, true);
        }
        return $directory;
    }
    static function write(\Exception $e): void
    {
        $timespan = "[" . date('H:i:s') . "] ";
        $error_msg = "On " . $e->getFile() . " line " . $e->getLine() . ": " . $e->getMessage() . "\n";
        $directory = self::getDirectory();
        $destination = $directory . DIRECTORY_SEPARATOR . date('d-m-Y') . '.log';
        error_log($timespan . $error_msg, 3, $destination);
    }
}