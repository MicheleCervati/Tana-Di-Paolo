<?php
$tab_title = '500 - Internal Server Error';
$main_classes = 'container d-flex justify-content-center align-items-center flex-column my-5';
require 'App/View/component/header.php';
?>

    <div class="text-center">
        <h1 class="display-1 fw-bold">500</h1>
        <div class="mb-4 lead">Internal Server Error</div>
        <p class="mb-4">Something went wrong on our servers. We're working to fix the issue.</p>

        <div class="error-details mb-4 text-muted">
            <small>Error code: 500 Internal Server Error</small>
        </div>

        <div class="d-flex justify-content-center gap-3">
            <a href="<?= $base_path ?>" class="btn btn-primary">
                <i class="bi bi-house-door me-2"></i>Go Home
            </a>
            <button class="btn btn-outline-secondary" onclick="history.back()">
                <i class="bi bi-arrow-left me-2"></i>Go Back
            </button>
            <button class="btn btn-outline-primary" onclick="location.reload()">
                <i class="bi bi-arrow-clockwise me-2"></i>Try Again
            </button>
        </div>
    </div>

<?php require 'App/View/component/footer.php'; ?>