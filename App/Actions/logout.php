<?php
use Functions\Session;
use Config\Project as Config;

$referer = urldecode($_POST['referer']) ?? Config::$path;
Session::start();
Session::destroy();
header('Location: ' . $referer);