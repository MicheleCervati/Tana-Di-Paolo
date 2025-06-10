<?php /**
 * @var string $path
 */?>
<?php require 'App/View/component/header.php'; ?>

    <div class="container mt-4">
        <div class="row">
            <div class="col-12">
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <h1 class="mb-0">
                        <i class="bi bi-cpu me-2 text-primary"></i>
                        Algoritmo di Raccomandazione Vini
                    </h1>
                    <!-- Badge abbonamento -->
                    <div id="subscriptionBadge" class="d-none">
                        <span id="subscriptionLabel" class="badge fs-6 px-3 py-2">
                            <i class="bi bi-star-fill me-1"></i>
                            <span id="subscriptionText">Caricamento...</span>
                        </span>
                    </div>
                </div>

                <!-- Alert per messaggi -->
                <div id="alertContainer"></div>

                <!-- Loading iniziale -->
                <div id="loadingUser" class="text-center mb-4">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body py-5">
                            <div class="spinner-border text-primary mb-3" role="status" style="width: 3rem; height: 3rem;">
                                <span class="visually-hidden">Caricamento...</span>
                            </div>
                            <h5 class="text-muted">Verifica dell'abbonamento in corso...</h5>
                            <p class="text-muted mb-0">Attendere prego</p>
                        </div>
                    </div>
                </div>

                <!-- Sezione Algoritmo -->
                <div id="algorithmSection" class="d-none">
                    <!-- Card Simulazione -->
                    <div class="card mb-4 border-0 shadow-sm">
                        <div class="card-header bg-info text-white border-0">
                            <div class="d-flex align-items-center">
                                <i class="bi bi-flask fs-4 me-2"></i>
                                <div>
                                    <h5 class="mb-0">Simulazione Algoritmo</h5>
                                    <small class="opacity-75">Testa l'algoritmo senza modificare i dati</small>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <p class="card-text text-muted">
                                Esegui una simulazione per vedere i risultati dell'algoritmo senza modificare i dati reali.
                                Potrai visualizzare in anteprima le raccomandazioni prima dell'esecuzione effettiva.
                            </p>
                            <button id="simulateBtn" class="btn btn-info btn-lg px-4">
                                <i class="bi bi-play-fill me-2"></i>
                                Avvia Simulazione
                            </button>
                        </div>
                    </div>

                    <!-- Risultati Simulazione -->
                    <div id="simulationResults" class="card mb-4 border-0 shadow-sm d-none">
                        <div class="card-header bg-success text-white border-0">
                            <div class="d-flex align-items-center justify-content-between">
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-graph-up fs-4 me-2"></i>
                                    <div>
                                        <h5 class="mb-0">Risultati Simulazione</h5>
                                        <small class="opacity-75">Raccomandazioni generate dall'algoritmo</small>
                                    </div>
                                </div>
                                <span id="resultsCount" class="badge bg-light text-dark fs-6 px-3 py-2">
                                    <i class="bi bi-list-ul me-1"></i>
                                    0 risultati
                                </span>
                            </div>
                        </div>
                        <div class="card-body">
                            <div id="simulationData"></div>
                        </div>
                    </div>

                    <!-- Card Esecuzione Algoritmo -->
                    <div class="card border-0 shadow-sm">
                        <div class="card-header bg-warning text-dark border-0">
                            <div class="d-flex align-items-center">
                                <i class="bi bi-gear-fill fs-4 me-2"></i>
                                <div>
                                    <h5 class="mb-0">Esecuzione Algoritmo</h5>
                                    <small class="opacity-75">Applica le raccomandazioni al sistema</small>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <p class="card-text text-muted">
                                Esegui l'algoritmo per creare l'ordine con tutti i vini suggeriti dal sistema.
                            </p>
                            <button id="runBtn" class="btn btn-warning btn-lg px-4">
                                <i class="bi bi-rocket-takeoff me-2"></i>
                                Esegui Algoritmo
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Sezione accesso negato -->
                <div id="accessDenied" class="d-none">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body text-center py-5">
                            <div class="mb-4">
                                <i class="bi bi-shield-lock text-danger" style="font-size: 4rem;"></i>
                            </div>
                            <h3 class="text-danger mb-3">Accesso Negato</h3>
                            <p class="lead text-muted mb-4">
                                Il tuo abbonamento attuale non include l'accesso all'algoritmo di raccomandazione vini.
                            </p>
                            <div class="alert alert-info border-0">
                                <i class="bi bi-info-circle me-2"></i>
                                È richiesto un abbonamento <strong id="requiredSubscription">Premium</strong> o superiore per utilizzare questa funzionalità.
                            </div>
                            <button class="btn btn-primary btn-lg px-4">
                                <i class="bi bi-arrow-up-circle me-2"></i>
                                Aggiorna Abbonamento
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const path = "<?= $path ?>";
    </script>

    <script src="<?= $path ?>Public/function/algoritmo.js"></script>

<?php require 'App/View/component/footer.php'; ?>