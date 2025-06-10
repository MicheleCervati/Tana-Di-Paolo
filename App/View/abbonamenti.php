<?php /**
 * @var string $path
 */?>
<?php require 'App/View/component/header.php'; ?>

<div class="container py-5">
    <h1 class="mb-4">Abbonamenti</h1>

    <div class="row" id="abbonamenti-container">
        <!-- Gli abbonamenti verranno caricati qui tramite JavaScript -->
        <div class="col-12 text-center">
            <div class="spinner-border" role="status">
                <span class="visually-hidden">Caricamento...</span>
            </div>
        </div>
    </div>
</div>
<script>
    const path = "<?= $path ?>";
</script>
<script src="<?= $path ?>public/function/abbonamenti.js"></script>

<?php require 'App/View/component/footer.php'; ?>