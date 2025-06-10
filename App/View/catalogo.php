<?php /**
 * @var string $path
 */?>
<?php require 'App/View/component/header.php'; ?>

    <div class="container my-5">
        <h1 class="text-center mb-4">Catalogo dei Vini</h1>

        <!-- Filtri -->
        <div class="row mb-4">
            <div class="col-md-12">
                <div class="card shadow-sm">
                    <div class="card-body">
                        <h5 class="card-title mb-3">Filtri</h5>
                        <form id="filterForm" class="row g-3">
                            <div class="col-md-3">
                                <label for="nomeVino" class="form-label">Nome Vino</label>
                                <input type="text" class="form-control" id="nomeVino" name="nome" placeholder="Cerca per nome...">
                            </div>
                            <div class="col-md-2">
                                <label for="minPrezzo" class="form-label">Prezzo Minimo</label>
                                <div class="input-group">
                                    <span class="input-group-text">€</span>
                                    <input type="number" class="form-control" id="minPrezzo" name="min_prezzo" min="0" step="0.01" placeholder="Min">
                                </div>
                            </div>
                            <div class="col-md-2">
                                <label for="maxPrezzo" class="form-label">Prezzo Massimo</label>
                                <div class="input-group">
                                    <span class="input-group-text">€</span>
                                    <input type="number" class="form-control" id="maxPrezzo" name="max_prezzo" min="0" step="0.01" placeholder="Max">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Tipologia</label>
                                <div id="tipologie-container">
                                    <!-- Le tipologie verranno caricate dinamicamente dall'API -->
                                    <div class="spinner-border spinner-border-sm text-primary" role="status">
                                        <span class="visually-hidden">Caricamento tipologie...</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button type="submit" class="btn btn-primary w-100">Filtra</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Controlli per ordinamento e visualizzazione -->
        <div class="row mb-2">
            <div class="col-md-3">
                <div class="d-flex align-items-center">
                    <label for="itemsPerPage" class="me-2">Vini per pagina:</label>
                    <select id="itemsPerPage" class="form-select" style="width: auto">
                        <option value="10">10</option>
                        <option value="20">20</option>
                        <option value="50">50</option>
                    </select>
                </div>
            </div>
            <div class="col-md-4">
                <div class="d-flex align-items-center">
                    <label for="ordinamento" class="me-2">Ordina per:</label>
                    <select id="ordinamento" class="form-select me-2" style="width: auto">
                        <option value="nome">Nome</option>
                        <option value="prezzo_vendita">Prezzo</option>
                        <option value="annata">Annata</option>
                    </select>
                    <select id="ordinamentoTipo" class="form-select" style="width: auto">
                        <option value="asc">Crescente</option>
                        <option value="desc">Decrescente</option>
                    </select>
                </div>
            </div>
            <div class="col-md-5">
                <!-- Spazio vuoto per bilanciare il layout -->
            </div>
        </div>

        <!-- Paginazione superiore in riga separata -->
        <div class="row mb-3">
            <div class="col-12">
                <nav aria-label="Paginazione superiore">
                    <ul class="pagination justify-content-end mb-0" id="paginationTop">
                        <!-- Paginazione generata dinamicamente -->
                    </ul>
                </nav>
            </div>
        </div>

        <!-- Risultati -->
        <div class="row" id="wine-container">
            <!-- Wine cards will be loaded here from API -->
            <div class="col-12 text-center">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Caricamento...</span>
                </div>
                <p>Caricamento vini in corso...</p>
            </div>
        </div>

        <!-- Paginazione inferiore -->
        <div class="row mt-4">
            <div class="col-md-6">
                <p id="resultsCount" class="text-muted">
                    Mostrando <span id="viniMostrati">0</span> di <span id="viniTrovati">0</span> vini
                </p>
            </div>
            <div class="col-md-6">
                <nav aria-label="Paginazione inferiore">
                    <ul class="pagination justify-content-end" id="paginationBottom">
                        <!-- Paginazione generata dinamicamente -->
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <script>let path = '<?=$path?>'</script>
    <script src='<?=$path?>Public/function/catalogo.js'></script>

<?php require 'App/View/component/footer.php'; ?>