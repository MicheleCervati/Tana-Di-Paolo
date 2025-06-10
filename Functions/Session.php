<?php
namespace Functions;
require_once 'Config/Session.php';
use Config\Session as Config;

class Session extends Config
{
    public static function start()
    {
        ini_set('session.gc_maxlifetime', self::$session_duration);
        if (session_status() === PHP_SESSION_NONE) {
            session_start([
                'name' => self::$session_cookie,
                'sid_length' => 128,
                'sid_bits_per_character' => 6,
                'cookie_path' => '/',
            ]);
            if (array_key_exists('last_activity', $_SESSION)) {
                self::extend();
            }
        }
    }

    public static function extend()
    {
        if (session_status() == PHP_SESSION_ACTIVE) {
            $_SESSION['last_activity'] = time();
            setcookie(self::$session_cookie, session_id(), time() + self::$session_duration, '/');
        }
    }

    public static function destroy()
    {
        if (session_status() === PHP_SESSION_ACTIVE) {
            session_unset();
            session_destroy();
            setcookie(self::$session_cookie, '', time() - 3600, '/');
        }
    }
}