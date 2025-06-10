<?php /**
 * @var string $path
 */?>
<?php require 'App/View/component/header.php'; ?>

    <div class="container py-5">
        <h4 class="mb-4">Checkout</h4>

        <div class="row">
            <!-- Dettagli Carrello (Sinistra) -->
            <div class="col-md-6 mb-4">
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Il tuo carrello</h5>
                    </div>
                    <div class="card-body p-0">
                        <div id="cart-loading" class="text-center py-4">
                            <div class="spinner-border spinner-border-sm" role="status">
                                <span class="visually-hidden">Caricamento...</span>
                            </div>
                            <p class="mt-2">Caricamento carrello...</p>
                        </div>

                        <div id="cart-error" class="alert alert-danger m-3 d-none" role="alert">
                            Si è verificato un errore nel caricamento del carrello. Riprova più tardi.
                        </div>

                        <div id="cart-empty" class="alert alert-info m-3 d-none" role="alert">
                            Il tuo carrello è vuoto. <a href="<?= $path ?>shop">Continua lo shopping</a>.
                        </div>

                        <div id="cart-content" class="d-none">
                            <ul class="list-group list-group-flush" id="cart-items">
                                <!-- Gli elementi del carrello verranno caricati qui tramite JavaScript -->
                            </ul>
                        </div>
                    </div>
                </div>

                <!-- Abbonamento (se presente) -->
                <?php if (isset($_GET['abbonamento'])){ ?>
                    <div class="card" id="abbonamento-card">
                        <div class="card-header">
                            <h5 class="mb-0">Abbonamento selezionato</h5>
                        </div>
                        <div class="card-body">
                            <div id="abbonamento-loading" class="text-center py-3">
                                <div class="spinner-border spinner-border-sm" role="status">
                                    <span class="visually-hidden">Caricamento...</span>
                                </div>
                            </div>

                            <div id="abbonamento-content" class="d-none">
                                <h6 class="mb-2" id="abbonamento-titolo">-</h6>
                                <p class="small text-muted mb-3" id="abbonamento-descrizione">-</p>
                                <div class="d-flex justify-content-between">
                                    <span>Prezzo mensile:</span>
                                    <strong id="abbonamento-prezzo">-</strong>
                                </div>
                            </div>

                            <div id="abbonamento-none" class="d-none">
                                <p class="mb-0">Nessun abbonamento selezionato.</p>
                            </div>
                        </div>
                    </div>
                <?php } ?>

                <!-- Codici Sconto -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">Codici sconto</h5>
                    </div>
                    <div class="card-body" id="codici-sconto-section">
                        <div id="codici-loading" class="text-center py-3">
                            <div class="spinner-border spinner-border-sm" role="status">
                                <span class="visually-hidden">Caricamento...</span>
                            </div>
                        </div>

                        <div id="codici-empty" class="d-none">
                            <p class="mb-0 text-muted">Nessun codice sconto applicato.</p>
                        </div>

                        <div id="codici-content" class="d-none">
                            <div id="codici-list">
                                <!-- I codici sconto applicati verranno mostrati qui -->
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Riepilogo totale -->
                <div class="card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">Riepilogo ordine</h5>
                    </div>
                    <div class="card-body">
                        <div id="summary-content" class="d-none">
                            <div class="d-flex justify-content-between mb-2">
                                <span>Totale prodotti:</span>
                                <span id="totale-prodotti">-</span>
                            </div>

                            <?php if (isset($_GET['abbonamento'])){ ?>
                                <div class="d-flex justify-content-between mb-2" id="abbonamento-row">
                                    <span>Abbonamento:</span>
                                    <span id="totale-abbonamento">-</span>
                                </div>
                            <?php } ?>

                            <div class="d-flex justify-content-between mb-2" id="totale-provvisorio-row">
                                <span>Totale provvisorio:</span>
                                <span id="totale-provvisorio">-</span>
                            </div>

                            <div id="sconti-section" class="d-none">
                                <div class="d-flex justify-content-between mb-2 text-success">
                                    <span>Totale sconti:</span>
                                    <span id="totale-sconti">-</span>
                                </div>
                            </div>

                            <hr>

                            <div class="d-flex justify-content-between mb-2">
                                <strong>Totale:</strong>
                                <strong id="totale-complessivo">-</strong>
                            </div>

                            <div class="small text-muted mb-3">
                                <i class="bi bi-info-circle me-1"></i> I prezzi includono IVA.
                            </div>
                        </div>

                        <div id="summary-loading" class="text-center py-3">
                            <div class="spinner-border spinner-border-sm" role="status">
                                <span class="visually-hidden">Caricamento...</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pagamento (Destra) -->
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5 class="mb-0">Dati di pagamento</h5>
                    </div>
                    <div class="card-body">
                        <form id="payment-form">
                            <div>
                                <h6 class="mb-3">Dettagli carta di credito</h6>

                                <div class="mb-3">
                                    <label for="card-name" class="form-label">Nome sulla carta</label>
                                    <input type="text" class="form-control" id="card-name" placeholder="Mario Rossi" required>
                                </div>

                                <div class="mb-3">
                                    <label for="card-number" class="form-label">Numero carta</label>
                                    <input type="text" class="form-control" id="card-number" placeholder="1234 5678 9012 3456" required>
                                </div>

                                <div class="row mb-4">
                                    <div class="col-md-6 mb-3 mb-md-0">
                                        <label for="card-expiry" class="form-label">Data di scadenza</label>
                                        <input type="text" class="form-control" id="card-expiry" placeholder="MM/AA" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="card-cvv" class="form-label">CVV</label>
                                        <input type="text" class="form-control" id="card-cvv" placeholder="123" required>
                                    </div>
                                </div>
                            </div>

                            <p class="small text-muted mb-4">
                                Cliccando su "Completa Pagamento" accetti i <a href="<?= $path ?>">Termini e Condizioni</a> e l'<a href="<?= $path ?>">Informativa sulla Privacy</a>.
                            </p>

                            <button type="submit" class="btn btn-primary w-100" id="pay-button">
                                Completa Pagamento
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const path = "<?= $path ?>";
    </script>
    <script src="<?= $path ?>public/function/checkout.js"></script>

<?php require 'App/View/component/footer.php'; ?>