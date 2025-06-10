<?php
require_once 'Config/Project.php';
use Config\Project as Config;
$path = Config::$path;
$main_classes = $main_classes ?? 'container my-4';
$uri = str_replace($path, '', $_SERVER['REQUEST_URI']);
$pages = [
    '' => "Homepage",
    'catalogo' => "Catalogo",
    'abbonamenti' => "Abbonamenti",
    'chiSiamo' => "Chi Siamo"
];
?>

<!doctype html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link rel="stylesheet" href="<?= $path ?>public/style/main.css">
    <link rel="icon" type="image/x-icon" href="<?= $path ?>images/logo.png">
    <script src="<?= $path ?>public/function/alert.js"></script>
    <title><?= Config::$name ?> - <?= $pages[$uri] ?? Config::$name ?></title>
</head>
<body class="d-flex flex-column">
<header data-bs-theme="dark" class="bg-body shadow-lg sticky-top">
    <div class="d-flex justify-content-between align-items-center py-2 container">
        <a href="<?= $path ?>" class="d-flex align-items-center text-decoration-none link-body-emphasis">
            <img src="<?= $path ?>public/image/logo.png" alt="<?= Config::$name ?> Logo" class="logo me-3"
                 height="100px">
            <span class="logo-text h1 my-0 d-none d-sm-block"><?= Config::$name ?></span>
        </a>
        <div class="d-flex align-items-center">
            <!-- Login/Account Button with Dropdown -->
            <?php if (isset($_SESSION['uid'])): ?>
                <!-- User is logged in - show dropdown -->
                <div class="dropdown mx-3">
                    <button class="btn btn-bd-secondary bg-primary dropdown-toggle"
                            type="button" id="userDropdown" data-bs-toggle="dropdown"
                            aria-expanded="false">
                        <i class="bi bi-person"></i>
                        <span class="ms-1 d-none d-md-inline"><?= $_SESSION['nome'] ?></span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow py-0" aria-labelledby="userDropdown">
                        <li>
                            <a class="dropdown-item d-flex align-baseline py-2 rounded-top"
                               href="<?= $path ?>account/show">
                                <i class="bi bi-person-circle me-2"></i>
                                Account
                            </a>
                        </li>
                        <li>
                            <hr class="dropdown-divider my-0">
                        </li>
                        <li>
                            <a class="dropdown-item d-flex align-baseline py-2 rounded-top"
                               href="<?= $path ?>account/questionario">
                                <i class="bi bi-card-checklist me-2"></i>
                                Questionario
                            </a>
                        </li>
                        <li>
                            <hr class="dropdown-divider my-0">
                        </li>
                        <li>
                            <a class="dropdown-item d-flex align-baseline py-2 rounded-top"
                               href="<?= $path ?>account/ordini">
                                <i class="bi bi-box-seam me-2"></i>
                                Ordini
                            </a>
                        </li>
                        <li>
                            <hr class="dropdown-divider my-0">
                        </li>
                        <li>
                            <a class="dropdown-item d-flex align-baseline py-2 rounded-top"
                               href="<?= $path ?>account/algoritmo">
                                <i class="bi bi-robot me-2"></i>
                                Algorimo
                            </a>
                        </li>
                        <li>
                            <hr class="dropdown-divider my-0">
                        </li>
                        <li>
                            <form action="<?= $path ?>action/logout" method="post">
                                <input type="hidden" name="referer" value="<?= $_SERVER['REQUEST_URI'] ?>">
                                <button type="submit" class="dropdown-item d-flex align-baseline py-2 rounded-bottom">
                                    <i class="bi bi-box-arrow-right me-2"></i>
                                    Logout
                                </button>
                            </form>
                        </li>
                    </ul>
                </div>
            <?php else: ?>
                <a href="<?= $path ?>account/login?ref=<?= urlencode($_GET['ref'] ?? $_SERVER['REQUEST_URI']) ?>"
                   class="btn btn-bd-secondary bg-primary mx-3 text-white text-decoration-none d-flex align-baseline">
                    <i class="bi bi-person me-2"></i>
                    <span>Login</span>
                </a>
            <?php endif; ?>
            <div class="dropdown bd-mode-toggle">
                <button class="btn btn-bd-primary py-2 dropdown-toggle" id="bd-theme"
                        type="button" aria-expanded="false" data-bs-toggle="dropdown" aria-label="Toggle theme (dark)">
                    <i class="bi bi-circle-half my-1"></i>
                    <span class="visually-hidden" id="bd-theme-text">Toggle theme</span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end shadow" aria-labelledby="bd-theme-text">
                    <li>
                        <button type="button" class="dropdown-item d-flex align-baseline"
                                data-bs-theme-value="light" aria-pressed="false">
                            <i class="bi bi-sun-fill me-2"></i>
                            Chiaro
                            <i class="bi bi-check2 ms-auto d-none"></i>
                        </button>
                    </li>
                    <li>
                        <button type="button" class="dropdown-item d-flex align-baseline active"
                                data-bs-theme-value="dark" aria-pressed="true">
                            <i class="bi bi-moon-stars-fill me-2"></i>
                            Scuro
                            <i class="bi bi-check2 ms-auto d-none"></i>
                        </button>
                    </li>
                    <li>
                        <button type="button" class="dropdown-item d-flex align-baseline" data-bs-theme-value="auto"
                                aria-pressed="false">
                            <i class="bi bi-circle-half me-2"></i>
                            Auto
                            <i class="bi bi-check2 ms-auto d-none"></i>
                        </button>
                    </li>
                </ul>
            </div>
            <button class="navbar-toggler mx-3 d-lg-none link-body-emphasis" type="button" data-bs-toggle="collapse"
                    data-bs-target="#navbar" aria-controls="navbar" aria-expanded="false"
                    aria-label="Toggle navigation">
                <i class="bi bi-list h1"></i>
            </button>
        </div>
    </div>
    <nav class="navbar navbar-expand-lg bg-body-tertiary py-0">
        <div class="container-fluid">
            <div class="collapse navbar-collapse" id="navbar">
                <ul class="navbar-nav my-3 me-auto">
                    <?php
                    foreach ($pages as $link => $page) {
                        $active = $uri == $link ? ' active' : '';
                        echo '<li class="nav-item mx-2"><a class="nav-link' . $active . '" href="' . $path . $link . '">' . $page . '</a></li>';
                    }
                    ?>
                </ul>
                <a href="<?= $path ?>carrello" class="mx-2 my-3 ms-lg-auto text-white text-decoration-none d-flex align-baseline">
                    <i class="bi bi-bag-fill me-2"></i>
                    Carrello
                </a>
            </div>
        </div>
    </nav>
</header>
<?php require 'alert.php' ?>
<div class="alert alert-dismissible fade" id="alert" role="alert" style="display: none; position: fixed; top: 20px; right: 20px; z-index: 1050;">
    <div id="alertMessage"></div>
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
</div>
<main class="flex-grow-1 <?= $main_classes ?>">