<?php
/**
 * @var string $path
 * @var object $vino Oggetto vino
 */
?>
<?php require 'App/View/component/header.php'; ?>

    <div class="container my-5" id="wine-detail-container">
        <!-- Tutto il contenuto esistente va qui -->
    </div>

    <script>
        const BASE_PATH = '<?= $path ?>';
        const VINO_ID = <?= isset($vino->id) ? intval($vino->id) : 0 ?>;
    </script>
    <script src="<?= $path ?>Public/function/dettagliVino.js" defer></script>

<?php require 'App/View/component/footer.php'; ?>