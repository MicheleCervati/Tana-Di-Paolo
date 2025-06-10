<?php
$tab_title = '405 - Method Not Allowed';
$main_classes = 'container d-flex justify-content-center align-items-center flex-column my-5';
require 'App/View/component/header.php';
?>

    <div class="text-center">
        <h1 class="display-1 fw-bold">405</h1>
        <div class="mb-4 lead">Method Not Allowed</div>
        <p class="mb-4">The request method is not supported for the requested resource.</p>

        <div class="error-details mb-4 text-muted">
            <small>Error code: 405 Method Not Allowed</small>
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