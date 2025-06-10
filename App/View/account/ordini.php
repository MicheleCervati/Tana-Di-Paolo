<?php /**
 * @var string $path
 */?>
<?php require 'App/View/component/header.php'; ?>

<h1>Ordini</h1>



    <!-- Contenitore principale dello storico ordini -->
    <div class="container py-4">
        <h2 class="mb-4">I Tuoi Ordini</h2>

        <!-- Loader per caricamento ordini -->
        <div id="ordini-loading" class="text-center py-5">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Caricamento...</span>
            </div>
            <p class="mt-2">Caricamento dei tuoi ordini...</p>
        </div>

        <!-- Messaggio ordini vuoti -->
        <div id="ordini-vuoti" class="alert alert-info d-none">
            <div class="text-center py-4">
                <i class="bi bi-bag-x fs-1"></i>
                <h5 class="mt-3">Non hai ancora effettuato ordini</h5>
                <p>Esplora il nostro catalogo e scopri i nostri vini selezionati.</p>
                <a href="<?=$path?>/catalogo" class="btn btn-primary mt-2">
                    Vai al catalogo
                </a>
            </div>
        </div>

        <!-- Messaggio di errore -->
        <div id="ordini-error" class="alert alert-danger d-none">
            <div class="text-center py-3">
                <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                <h5 class="mt-2">Impossibile caricare gli ordini</h5>
                <p>Si è verificato un errore durante il recupero dei tuoi ordini. Riprova più tardi.</p>
            </div>
        </div>

        <!-- Contenitore ordini -->
        <div id="ordini-container">
            <!-- Gli ordini verranno generati dinamicamente qui -->
        </div>
    </div>

    <!-- Script per la gestione degli ordini -->
    <script>
        let path = "<?php echo htmlspecialchars($path ?? './'); ?>";
        console.log('Path definito come:', path);
    </script>
    <script src="<?=$path?>Public/function/storico.js"></script>





<?php require 'App/View/component/footer.php'; ?>