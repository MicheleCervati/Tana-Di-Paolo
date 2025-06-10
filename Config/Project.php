<?php

namespace Config;

class Project
{
    public static string $path = '';
    public static string $name = 'La Tana di Paolo';
}

Project::$path = dirname($_SERVER['PHP_SELF']) . '/';