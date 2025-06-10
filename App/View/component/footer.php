<?php
use Config\Project as Config;
/**
 * @var string $path
 */ ?>
</main>
<footer class="bg-body-tertiary text-white py-3 shadow-lg" data-bs-theme="dark">
    <div class="d-flex flex-wrap container justify-content-between">
        <p>&copy <?= date("Y") ?> <?= Config::$name ?>. Tutti i diritti riservati.</p>
        <a href="https://github.com/matteofuso/La-Tana-di-Paolo" target="_blank"><i
                    class="bi bi-github me-2 link-body-emphasis"></i><?= Config::$name ?></a>
    </div>
</footer>
<script src="<?= $path ?>public/function/colormode.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>
</body>
</html>