<?php
use Config\Codes;
require_once 'Config/Codes.php';

if (isset($_GET['err'])) {
    $err = $_GET['err'];
    if (!array_key_exists($err, Codes::$errors)) {
        $err = '-1';
    }
    $error = Codes::$errors[$err];
    echo "<div class='alert alert-danger alert-dismissible mx-4 my-3' role='alert'>
          <p class='flex-grow-1 my-0 align-baseline'><i class='bi bi-exclamation-triangle me-2'></i>$error</p>
          <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
    </div>";
}

if (isset($_GET['succ'])) {
    $succ = $_GET['succ'];
    if (!array_key_exists($succ, Codes::$successes)) {
        $succ = '-1';
    }
    $success = Codes::$successes[$succ];
    echo "<div class='alert alert-success alert-dismissible mx-4 my-3' role='alert'>
          <p class='flex-grow-1 my-0 align-baseline'><i class='bi bi-check-circle me-2'></i>$success</p>
          <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
    </div>";
}