<?php
$tab_title = '404 - Page Not Found';
$main_classes = 'container d-flex justify-content-center align-items-center flex-column my-5';
require 'App/View/component/header.php';
?>

    <div class="text-center">
        <h1 class="display-1 fw-bold">404</h1>
        <div class="mb-4 lead">Oops! Page not found.</div>
        <p class="mb-4">The page you're looking for doesn't exist or has been moved.</p>

        <div class="error-details mb-4 text-muted">
            <small>Error code: 404 Page Not Found</small>
        </div>

        <div class="d-flex justify-content-center gap-3">
            <a href="<?= $base_path ?>" class="btn btn-primary">
                <i class="bi bi-house-door me-2"></i>Go Home
            </a>
            <button class="btn btn-outline-secondary" onclick="history.back()">
                <i class="bi bi-arrow-left me-2"></i>Go Back
            </button>
        </div>
    </div>

<?php require 'App/View/component/footer.php'; ?>