<?php /**
 * @var string $path
 */?>
<?php require 'App/View/component/header.php'; ?>

<?php
// Carica il file JSON con i testi
$questionnaire_texts = json_decode(file_get_contents('Public/data/testo.json'), true);

// Controllo se il file JSON è stato caricato correttamente
if (!$questionnaire_texts) {
    die('Errore nel caricamento dei testi del questionario.');
}
?>

    <div class="container py-5">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4><?= $questionnaire_texts['summary']['title'] ?? 'Riepilogo Preferenze Vino' ?></h4>
            <div>
                <button id="edit-preferences" class="btn btn-outline-primary me-2">
                    <i class="bi bi-pencil-square me-1"></i> <?= $questionnaire_texts['summary']['edit_button'] ?? 'Modifica Preferenze' ?>
                </button>
                <button id="view-recommendations" class="btn btn-primary">
                    <i class="bi bi-wine-bottle me-1"></i> <?= $questionnaire_texts['summary']['recommendations_button'] ?? 'Visualizza Consigli' ?>
                </button>
            </div>
        </div>

        <!-- Loading -->
        <div id="loading-container" class="text-center py-5">
            <div class="spinner-border" role="status">
                <span class="visually-hidden">Caricamento...</span>
            </div>
            <p class="mt-3"><?= $questionnaire_texts['loading']['preferences'] ?? 'Caricamento delle tue preferenze...' ?></p>
        </div>

        <!-- Area errori -->
        <div id="error-container" class="d-none"></div>

        <!-- Contenitore riepilogo preferenze -->
        <div id="summary-container" class="d-none">
            <div class="row">
                <div class="col-lg-8">
                    <!-- Card Preferenze Generali -->
                    <div class="card shadow-sm mb-4 border-0">
                        <div class="card-header bg-dark text-white">
                            <h5 class="mb-0"><?= $questionnaire_texts['summary']['sections']['general']['title'] ?? 'Preferenze Generali' ?></h5>
                        </div>
                        <div class="card-body">
                            <div class="row mb-4">
                                <div class="col-md-6 mb-3 mb-md-0">
                                    <h6 class="fw-bold border-bottom pb-2">
                                        <i class="bi bi-droplet-fill me-2 text-danger"></i>
                                        <?= $questionnaire_texts['summary']['sections']['wine_types']['title'] ?? 'Tipi di Vino Preferiti' ?>
                                    </h6>
                                    <div id="wine-types" class="d-flex flex-wrap gap-2 mt-3">
                                        <!-- Contenuto generato dinamicamente -->
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="fw-bold border-bottom pb-2">
                                        <i class="bi bi-stars me-2 text-warning"></i>
                                        <?= $questionnaire_texts['summary']['sections']['aromas']['title'] ?? 'Aromi Preferiti' ?>
                                    </h6>
                                    <div id="aromas-preferences" class="d-flex flex-wrap gap-2 mt-3">
                                        <!-- Contenuto generato dinamicamente -->
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-3 mb-md-0">
                                    <h6 class="fw-bold border-bottom pb-2">
                                        <i class="bi bi-thermometer-half me-2 text-primary"></i>
                                        <?= $questionnaire_texts['summary']['sections']['intensity']['title'] ?? 'Intensità del Gusto' ?>
                                    </h6>
                                    <p id="taste-intensity" class="mt-3">
                                        <!-- Contenuto generato dinamicamente -->
                                    </p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="fw-bold border-bottom pb-2">
                                        <i class="bi bi-egg-fried me-2 text-success"></i>
                                        <?= $questionnaire_texts['summary']['sections']['food']['title'] ?? 'Abbinamento Cibo' ?>
                                    </h6>
                                    <p id="food-pairing" class="mt-3">
                                        <!-- Contenuto generato dinamicamente -->
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Card Caratteristiche Sensoriali -->
                    <div class="card shadow-sm mb-4 border-0">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><?= $questionnaire_texts['summary']['sections']['sensory']['title'] ?? 'Caratteristiche Sensoriali' ?></h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-bold" data-bs-toggle="tooltip" data-bs-title="<?= $questionnaire_texts['questionnaire']['sections']['section2']['questions']['q5']['description'] ?? 'Quanto preferisci che il vino sia caldo al palato' ?>">
                                        <i class="bi bi-thermometer-sun me-1 text-danger"></i>
                                        <?= $questionnaire_texts['questionnaire']['sections']['section2']['questions']['q5']['label'] ?? 'Calore' ?>
                                    </span>
                                    </div>
                                    <div class="progress">
                                        <div id="heat-intensity" class="progress-bar" role="progressbar" style="width: 50%" aria-valuenow="5" aria-valuemin="0" aria-valuemax="10">Medio</div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-bold" data-bs-toggle="tooltip" data-bs-title="<?= $questionnaire_texts['questionnaire']['sections']['section2']['questions']['q6']['description'] ?? 'Quanto secco preferisci il tuo vino' ?>">
                                        <i class="bi bi-droplet me-1 text-info"></i>
                                        <?= $questionnaire_texts['questionnaire']['sections']['section2']['questions']['q6']['label'] ?? 'Secchezza' ?>
                                    </span>
                                    </div>
                                    <div class="progress">
                                        <div id="dryness-level" class="progress-bar" role="progressbar" style="width: 50%" aria-valuenow="5" aria-valuemin="0" aria-valuemax="10">Medio</div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-bold" data-bs-toggle="tooltip" data-bs-title="<?= $questionnaire_texts['questionnaire']['sections']['section2']['questions']['q7']['description'] ?? 'Quanto morbido preferisci il tuo vino' ?>">
                                        <i class="bi bi-cloud-haze me-1 text-warning"></i>
                                        <?= $questionnaire_texts['questionnaire']['sections']['section2']['questions']['q7']['label'] ?? 'Morbidezza' ?>
                                    </span>
                                    </div>
                                    <div class="progress">
                                        <div id="smoothness-level" class="progress-bar" role="progressbar" style="width: 50%" aria-valuenow="5" aria-valuemin="0" aria-valuemax="10">Medio</div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-bold" data-bs-toggle="tooltip" data-bs-title="<?= $questionnaire_texts['questionnaire']['sections']['section2']['questions']['q8']['description'] ?? 'Quanto fresco e vivace preferisci il tuo vino' ?>">
                                        <i class="bi bi-wind me-1 text-success"></i>
                                        <?= $questionnaire_texts['questionnaire']['sections']['section2']['questions']['q8']['label'] ?? 'Freschezza' ?>
                                    </span>
                                    </div>
                                    <div class="progress">
                                        <div id="freshness-level" class="progress-bar" role="progressbar" style="width: 50%" aria-valuenow="5" aria-valuemin="0" aria-valuemax="10">Medio</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Card Caratteristiche Avanzate -->
                    <div class="card shadow-sm mb-4 border-0">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0"><?= $questionnaire_texts['summary']['sections']['advanced']['title'] ?? 'Caratteristiche Avanzate' ?></h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-bold" data-bs-toggle="tooltip" data-bs-title="<?= $questionnaire_texts['questionnaire']['sections']['section3']['questions']['q9']['description'] ?? 'Quanto prominenti devono essere le note fruttate' ?>">
                                        <i class="bi bi-apple me-1 text-danger"></i>
                                        <?= $questionnaire_texts['questionnaire']['sections']['section3']['questions']['q9']['label'] ?? 'Note Fruttate' ?>
                                    </span>
                                    </div>
                                    <div class="progress">
                                        <div id="fruity-level" class="progress-bar" role="progressbar" style="width: 50%" aria-valuenow="5" aria-valuemin="0" aria-valuemax="10">Medio</div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-bold" data-bs-toggle="tooltip" data-bs-title="<?= $questionnaire_texts['questionnaire']['sections']['section3']['questions']['q10']['description'] ?? 'Quanto evidenti preferisci le note agrumate' ?>">
                                        <i class="bi bi-brightness-high me-1 text-warning"></i>
                                        <?= $questionnaire_texts['questionnaire']['sections']['section3']['questions']['q10']['label'] ?? 'Note Agrumate' ?>
                                    </span>
                                    </div>
                                    <div class="progress">
                                        <div id="citrus-level" class="progress-bar" role="progressbar" style="width: 50%" aria-valuenow="5" aria-valuemin="0" aria-valuemax="10">Medio</div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-bold" data-bs-toggle="tooltip" data-bs-title="<?= $questionnaire_texts['questionnaire']['sections']['section3']['questions']['q11']['description'] ?? 'Quanto a lungo preferisci che il sapore persista' ?>">
                                        <i class="bi bi-hourglass-split me-1 text-primary"></i>
                                        <?= $questionnaire_texts['questionnaire']['sections']['section3']['questions']['q11']['label'] ?? 'Persistenza' ?>
                                    </span>
                                    </div>
                                    <div class="progress">
                                        <div id="persistence-level" class="progress-bar" role="progressbar" style="width: 50%" aria-valuenow="5" aria-valuemin="0" aria-valuemax="10">Medio</div>
                                    </div>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="fw-bold" data-bs-toggle="tooltip" data-bs-title="<?= $questionnaire_texts['questionnaire']['sections']['section3']['questions']['q12']['description'] ?? 'Quanto evidenti preferisci le note di legno' ?>">
                                        <i class="bi bi-tree me-1 text-success"></i>
                                        <?= $questionnaire_texts['questionnaire']['sections']['section3']['questions']['q12']['label'] ?? 'Note di Legno' ?>
                                    </span>
                                    </div>
                                    <div class="progress">
                                        <div id="wood-level" class="progress-bar" role="progressbar" style="width: 50%" aria-valuenow="5" aria-valuemin="0" aria-valuemax="10">Medio</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Card Preferenze Finali -->
                    <div class="card shadow-sm mb-4 mb-lg-0 border-0">
                        <div class="card-header bg-info text-white">
                            <h5 class="mb-0"><?= $questionnaire_texts['summary']['sections']['final']['title'] ?? 'Preferenze Aggiuntive' ?></h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-4 mb-3 mb-md-0">
                                    <h6 class="fw-bold border-bottom pb-2">
                                        <i class="bi bi-intersect me-2 text-primary"></i>
                                        <?= $questionnaire_texts['questionnaire']['sections']['section4']['questions']['q13']['label'] ?? 'Concentrazione' ?>
                                    </h6>
                                    <p id="concentration-level" class="mt-3">
                                        <!-- Contenuto generato dinamicamente -->
                                    </p>
                                </div>
                                <div class="col-md-4 mb-3 mb-md-0">
                                    <h6 class="fw-bold border-bottom pb-2">
                                        <i class="bi bi-hourglass me-2 text-warning"></i>
                                        <?= $questionnaire_texts['questionnaire']['sections']['section4']['questions']['q14']['label'] ?? 'Maturazione' ?>
                                    </h6>
                                    <p id="maturation-level" class="mt-3">
                                        <!-- Contenuto generato dinamicamente -->
                                    </p>
                                </div>
                                <div class="col-md-4">
                                    <h6 class="fw-bold border-bottom pb-2">
                                        <i class="bi bi-currency-euro me-2 text-success"></i>
                                        <?= $questionnaire_texts['questionnaire']['sections']['section4']['questions']['q15']['label'] ?? 'Budget' ?>
                                    </h6>
                                    <p id="budget-level" class="mt-3">
                                        <!-- Contenuto generato dinamicamente -->
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <!-- Grafico del profilo -->
                    <div class="card shadow-sm border-0">
                        <div class="card-header bg-gradient bg-dark text-white">
                            <h5 class="mb-0">
                                <i class="bi bi-graph-up me-2"></i>
                                <?= $questionnaire_texts['summary']['sections']['profile_chart']['title'] ?? 'Profilo del Vino' ?>
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="text-center mb-3">
                                <canvas id="wine-profile-chart" height="250"></canvas>
                            </div>
                            <p class="text-muted text-center small">
                                <?= $questionnaire_texts['summary']['sections']['profile_chart']['description'] ?? 'Questo grafico rappresenta il tuo profilo di gusto ideale per il vino' ?>
                            </p>
                        </div>
                    </div>

                    <!-- Consigli personalizzati -->
                    <div class="card shadow-sm mt-4 border-0">
                        <div class="card-header bg-gradient bg-success text-white">
                            <h5 class="mb-0">
                                <i class="bi bi-lightbulb me-2"></i>
                                <?= $questionnaire_texts['summary']['sections']['tips']['title'] ?? 'Consigli Personalizzati' ?>
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="d-flex align-items-start mb-3">
                                <div class="flex-shrink-0">
                                    <i class="bi bi-check-circle-fill text-success fs-4"></i>
                                </div>
                                <div class="flex-grow-1 ms-3">
                                    <h6 class="fw-bold"><?= $questionnaire_texts['summary']['sections']['tips']['tip1']['title'] ?? 'Vitigni Consigliati' ?></h6>
                                    <p class="text-muted"><?= $questionnaire_texts['summary']['sections']['tips']['tip1']['content'] ?? 'In base alle tue preferenze, potresti apprezzare vini provenienti da questi vitigni: Sangiovese, Nebbiolo, Montepulciano.' ?></p>
                                </div>
                            </div>
                            <div class="d-flex align-items-start mb-3">
                                <div class="flex-shrink-0">
                                    <i class="bi bi-check-circle-fill text-success fs-4"></i>
                                </div>
                                <div class="flex-grow-1 ms-3">
                                    <h6 class="fw-bold"><?= $questionnaire_texts['summary']['sections']['tips']['tip2']['title'] ?? 'Regioni da Esplorare' ?></h6>
                                    <p class="text-muted"><?= $questionnaire_texts['summary']['sections']['tips']['tip2']['content'] ?? 'Ti consigliamo di esplorare vini provenienti da queste regioni: Toscana, Piemonte, Puglia.' ?></p>
                                </div>
                            </div>
                            <div class="d-flex align-items-start">
                                <div class="flex-shrink-0">
                                    <i class="bi bi-check-circle-fill text-success fs-4"></i>
                                </div>
                                <div class="flex-grow-1 ms-3">
                                    <h6 class="fw-bold"><?= $questionnaire_texts['summary']['sections']['tips']['tip3']['title'] ?? 'Abbinamenti Perfetti' ?></h6>
                                    <p class="text-muted"><?= $questionnaire_texts['summary']['sections']['tips']['tip3']['content'] ?? 'I vini che corrispondono al tuo profilo si abbinano perfettamente con: carni rosse, formaggi stagionati, primi piatti ricchi.' ?></p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        const path = "<?= $path ?>";
        // Passiamo i testi del questionario al JavaScript
        const questionnaire_texts = <?= json_encode($questionnaire_texts) ?>;
    </script>
    <script src="<?= $path ?>Public/function/riepilogo.js"></script>

    <style>
        /* Stile per i tag delle preferenze */
        .preference-tag {
            display: inline-flex;
            align-items: center;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 50px;
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            box-shadow: 0 1px 2px rgba(0,0,0,0.05);
            transition: all 0.2s ease;
        }
        .preference-tag:hover {
            background-color: #e9ecef;
            transform: translateY(-1px);
        }

        /* Pallini colorati */
        .color-dot {
            width: 16px;
            height: 16px;
            border-radius: 50%;
            display: inline-block;
        }
        .bg-pink { background-color: #FF9A9E; }
        .bg-amber { background-color: #FFB347; }

        /* Progress bars */
        .progress {
            height: 1.5rem;
            border-radius: 50px;
            background-color: #f8f9fa;
            box-shadow: inset 0 1px 2px rgba(0,0,0,0.1);
        }
        .progress-bar {
            border-radius: 50px;
            font-weight: 600;
            line-height: 1.5rem;
            text-shadow: 0 1px 1px rgba(0,0,0,0.2);
        }

        /* Cards */
        .card {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .card-header {
            border-bottom: none;
            padding: 1rem 1.5rem;
        }
        .card-body {
            padding: 1.5rem;
        }

        /* Animazioni */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .card {
            animation: fadeIn 0.6s ease forwards;
        }
        .card:nth-child(1) { animation-delay: 0.1s; }
        .card:nth-child(2) { animation-delay: 0.2s; }
        .card:nth-child(3) { animation-delay: 0.3s; }
        .card:nth-child(4) { animation-delay: 0.4s; }

        /* Tooltip personalizzati */
        .tooltip {
            font-size: 0.8rem;
        }
        .tooltip .tooltip-inner {
            max-width: 250px;
            padding: 0.5rem 1rem;
            background-color: #343a40;
            box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        }
    </style>

<?php require 'App/View/component/footer.php'; ?>