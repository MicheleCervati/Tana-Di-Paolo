<?php
/**
 * @var string $path
 */
require_once 'Config/Questionario.php';
use Config\Questionario;
require 'App/View/component/header.php'; ?>

    <div class="container my-5">
        <div class="card shadow-lg border-0 rounded-3">
            <div class="card-header bg-primary text-white py-3">
                <h1 class="h3 mb-0 fw-bold">Questionario Preferenze Vino</h1>
            </div>

            <div class="card-body p-4">
                <!-- Messaggi di stato -->
                <div class="alert alert-success alert-dismissible fade show d-none" id="success-message" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Questionario salvato con successo!
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
                <div class="alert alert-danger alert-dismissible fade show d-none" id="error-message" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> <span id="error-text"></span>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>

                <form id="questionario-form">
                    <!-- Sezione per tipologie di vino -->
                    <div class="mb-5">
                        <div class="d-flex align-items-center border-bottom pb-2 mb-4">
                            <i class="bi bi-cup-hot fs-4 me-2 text-primary"></i>
                            <h2 class="h5 mb-0 fw-bold">Tipologie di vino preferite</h2>
                        </div>

                        <p class="text-muted mb-3">Seleziona almeno una tipologia di vino che preferisci:</p>
                        <div id="tipologie-container" class="row g-3">
                            <?php foreach (Questionario::$domande[0]['opzioni'] as $key => $opzione): ?>
                                <div class="col-lg-3 col-md-4 col-sm-6">
                                    <div class="form-check">
                                        <input class="form-check-input tipologia-checkbox"
                                               type="checkbox"
                                               value="<?= $opzione['valore'] ?>"
                                               id="tipo-<?= $key ?>"
                                               name="tipologie[]">
                                        <label class="form-check-label" for="tipo-<?= $key ?>">
                                            <?= $opzione['testo'] ?>
                                        </label>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    </div>

                    <!-- Sezione caratteristiche del vino -->
                    <div class="mb-5">
                        <div class="d-flex align-items-center border-bottom pb-2 mb-4">
                            <i class="bi bi-bar-chart-line fs-4 me-2 text-primary"></i>
                            <h2 class="h5 mb-0 fw-bold">Caratteristiche organolettiche</h2>
                        </div>

                        <div class="row g-4">
                            <?php
                            // Array per raggruppare gli slider in colonne
                            $sliders = [
                                'alcol', 'zuccheri_residui', 'glicerolo', 'acido_tartarico',
                                'acido_malico', 'acido_citrico', 'tannini', 'affinamento'
                            ];

                            foreach ($sliders as $index => $sliderName):
                                // Trova la domanda corrispondente
                                $domandaKey = array_search($sliderName, array_column(Questionario::$domande, 'nome'));
                                if ($domandaKey !== false):
                                    $domanda = Questionario::$domande[$domandaKey];
                                    ?>
                                    <div class="col-lg-6 col-md-12">
                                        <div class="card h-100 border-0 shadow-sm">
                                            <div class="card-body">
                                                <h3 class="h6 fw-bold mb-3"><?= $domanda['titolo'] ?></h3>
                                                <div class="form-group">
                                                    <div class="d-flex justify-content-between mb-2">
                                                        <span class="small text-muted">Minimo</span>
                                                        <span class="badge bg-primary value-display">0</span>
                                                        <span class="small text-muted">Massimo</span>
                                                    </div>
                                                    <input type="range"
                                                           class="form-range"
                                                           min="<?= $domanda['min'] ?>"
                                                           max="<?= $domanda['max'] ?>"
                                                           step="1"
                                                           id="<?= $domanda['nome'] ?>"
                                                           name="<?= $domanda['nome'] ?>"
                                                           value="0">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                <?php
                                endif;
                            endforeach;
                            ?>
                        </div>
                    </div>

                    <!-- Sezione altre preferenze -->
                    <div class="mb-5">
                        <div class="d-flex align-items-center border-bottom pb-2 mb-4">
                            <i class="bi bi-sliders fs-4 me-2 text-primary"></i>
                            <h2 class="h5 mb-0 fw-bold">Altre preferenze</h2>
                        </div>

                        <div class="row g-4">
                            <!-- Passiti -->
                            <div class="col-md-6">
                                <div class="card h-100 border-0 shadow-sm">
                                    <div class="card-body">
                                        <?php
                                        $passitiKey = array_search('passiti', array_column(Questionario::$domande, 'nome'));
                                        if ($passitiKey !== false):
                                            $domanda = Questionario::$domande[$passitiKey];
                                            ?>
                                            <h3 class="h6 fw-bold mb-3"><?= $domanda['titolo'] ?></h3>
                                            <div class="form-group">
                                                <?php foreach ($domanda['opzioni'] as $key => $opzione): ?>
                                                    <div class="form-check mb-2">
                                                        <input class="form-check-input"
                                                               type="radio"
                                                               name="<?= $domanda['nome'] ?>"
                                                               id="<?= $domanda['nome'] ?>-<?= $key ?>"
                                                               value="<?= $opzione['valore'] / 100 ?>">
                                                        <label class="form-check-label" for="<?= $domanda['nome'] ?>-<?= $key ?>">
                                                            <?= $opzione['testo'] ?>
                                                        </label>
                                                    </div>
                                                <?php endforeach; ?>
                                            </div>
                                        <?php endif; ?>
                                    </div>
                                </div>
                            </div>

                            <!-- Maturazione -->
                            <div class="col-md-6">
                                <div class="card h-100 border-0 shadow-sm">
                                    <div class="card-body">
                                        <?php
                                        $annataKey = array_search('annata', array_column(Questionario::$domande, 'nome'));
                                        if ($annataKey !== false):
                                            $domanda = Questionario::$domande[$annataKey];
                                            ?>
                                            <h3 class="h6 fw-bold mb-3"><?= $domanda['titolo'] ?></h3>
                                            <div class="form-group">
                                                <?php foreach ($domanda['opzioni'] as $key => $opzione): ?>
                                                    <div class="form-check mb-2">
                                                        <input class="form-check-input"
                                                               type="radio"
                                                               name="<?= $domanda['nome'] ?>"
                                                               id="<?= $domanda['nome'] ?>-<?= $key ?>"
                                                               value="<?= $opzione['valore'] / 100 ?>">
                                                        <label class="form-check-label" for="<?= $domanda['nome'] ?>-<?= $key ?>">
                                                            <?= $opzione['testo'] ?>
                                                        </label>
                                                    </div>
                                                <?php endforeach; ?>
                                            </div>
                                        <?php endif; ?>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Bottoni finali -->
                    <div class="d-flex justify-content-center mt-5">
                        <button type="button" class="btn btn-primary btn-lg px-5 py-3 shadow-sm" id="save-btn-bottom">
                            <i class="bi bi-save me-2"></i> Salva Preferenze
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>let PATH = "<?= $path ?>";</script>
    <script src="<?= $path ?>Public/function/questionario.js" defer></script>

<?php require 'App/View/component/footer.php'; ?>