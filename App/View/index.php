<?php

$main_classes = '';




require 'App/View/component/header.php'; ?>



<!-- CSS personalizzato -->
<style>
    .hero-section {
        position: relative;
        height: 33%;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
        background-color: #000; /* fallback se l'immagine non carica */
    }

    .hero-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        filter: brightness(0.5) contrast(1.1) saturate(1.05);
        transition: transform 0.8s ease, filter 0.8s ease;
        border-bottom: 2px solid rgba(255, 255, 255, 0.1);
    }

    .hero-image:hover {
        transform: scale(1.02);
        filter: brightness(0.6) contrast(1.15);
    }




    .btn-wine {
        background-color: #8B0000;
        border-color: #8B0000;
        color: white;
        transition: all 0.3s ease;
    }

    .btn-wine:hover {
        background-color: #6B0000;
        border-color: #6B0000;
        color: white;
        transform: translateY(-3px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.1);
    }

    .feature-card {
        transition: all 0.3s ease;
        border-radius: 10px;
    }

    .feature-card:hover {
        transform: translateY(-10px);
        box-shadow: 0 15px 30px rgba(0,0,0,0.1);
    }

    .feature-icon {
        color: #8B0000;
        font-size: 3rem;
    }


    .cta-section {
        position: relative;
        min-height: 60vh;
        background: url('<?=$path?>/public/image/bg_vini2.jpg') center center / cover no-repeat;
        display: flex;
        align-items: center;
    }

    .cta-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5); /* semitrasparente elegante */
        z-index: 1;
    }

    .cta-section .container {
        position: relative;
        z-index: 2;
        padding-top: 4rem;
        padding-bottom: 4rem;
    }



    .feature-section-image {
        border-radius: 10px;
        box-shadow: 0 15px 30px rgba(0,0,0,0.15);
        transition: all 0.3s ease;
    }

    .feature-section-image:hover {
        transform: scale(1.03);
    }
</style>

<!-- Hero Section -->
<div class="hero-section">
    <img src="<?=$path?>/public/image/bg_vino_versato.jpg" class="hero-image" alt="Vino pregiato">
    <div class="position-absolute top-50 start-50 translate-middle text-center text-white">
        <h1 class="display-3 fw-bold mb-4">La Tana di Paolo</h1>
        <p class="lead fs-4 mb-4">Eccellenza enologica personalizzata per il tuo palato</p>
        <div class="d-flex justify-content-center gap-3">
            <a href="<?=$path?>catalogo" class="btn btn-wine btn-lg px-5 py-3 rounded-pill fw-bold">Scopri i Nostri Vini</a>
            <a href="<?=$path?>account/questionario" class="btn btn-outline-light btn-lg px-4 py-3 rounded-pill">Personalizza</a>
        </div>
    </div>
</div>

<!-- Descrizione Progetto -->
<div class="container my-5 py-5">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="text-center mb-5">
                <h2 class="display-5 fw-bold mb-4">La tua esperienza enologica su misura</h2>
                <p class="lead">Scopri un modo nuovo di apprezzare il vino, guidato dalle tue preferenze personali.</p>
            </div>

            <div class="row g-4 mt-4">
                <div class="col-md-4">
                    <div class="feature-card card h-100 border-0 shadow-sm">
                        <div class="card-body text-center py-5">
                            <div class="mb-4">
                                <i class="bi bi-search feature-icon"></i>
                            </div>
                            <h3 class="h4 card-title mb-3">Selezione Personalizzata</h3>
                            <p class="card-text">Il nostro algoritmo analizza le tue preferenze per suggerirti i vini più adatti al tuo gusto e alla tua sensibilità.</p>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="feature-card card h-100 border-0 shadow-sm">
                        <div class="card-body text-center py-5">
                            <div class="mb-4">
                                <i class="bi bi-calendar-event feature-icon"></i>
                            </div>
                            <h3 class="h4 card-title mb-3">Abbonamenti Esclusivi</h3>
                            <p class="card-text">Ricevi periodicamente selezioni di vini scelti appositamente per te, direttamente a casa tua.</p>
                        </div>
                    </div>
                </div>

                <div class="col-md-4">
                    <div class="feature-card card h-100 border-0 shadow-sm">
                        <div class="card-body text-center py-5">
                            <div class="mb-4">
                                <i class="bi bi-award feature-icon"></i>
                            </div>
                            <h3 class="h4 card-title mb-3">Qualità Garantita</h3>
                            <p class="card-text">Il nostro catalogo include oltre 500 vini selezionati dalle migliori cantine italiane e internazionali.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Categorie Vini -->
<div class="container mb-5">
    <div class="row g-4">
        <div class="col-md-3">
            <div class="card border-0 overflow-hidden shadow-sm h-100">
                <img src="<?=$path?>/public/image/vini/1.jpg" class="card-img-top" alt="Vini Rossi" style="height: 100%; object-fit: cover;">
                <div class="card-body text-center">
                    <h5 class="card-title fw-bold mb-0">Vini Rossi</h5>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 overflow-hidden shadow-sm h-100">
                <img src="<?=$path?>/public/image/vini/6.jpg" class="card-img-top" alt="Vini Bianchi" style="height: 100%; object-fit: cover;">
                <div class="card-body text-center">
                    <h5 class="card-title fw-bold mb-0">Vini Bianchi</h5>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 overflow-hidden shadow-sm h-100">
                <img src="<?=$path?>/public/image/vini/5.jpg" class="card-img-top" alt="Vini Passiti" style="height: 100%; object-fit: cover;">
                <div class="card-body text-center">
                    <h5 class="card-title fw-bold mb-0">Vini Passiti</h5>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 overflow-hidden shadow-sm h-100">
                <img src="<?=$path?>/public/image/vini/27.jpg" class="card-img-top" alt="Spumanti" style="height: 100%; object-fit: cover;">
                <div class="card-body text-center">
                    <h5 class="card-title fw-bold mb-0">Spumanti</h5>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- CTA Section -->
<div class="cta-section my-5">
    <div class="cta-overlay"></div>
    <div class="container py-4 position-relative">
        <div class="row align-items-center">
            <div class="col-lg-8 text-white mb-4 mb-lg-0">
                <h2 class="display-6 fw-bold mb-3">Scopri la nostra selezione di vini pregiati</h2>
                <p class="lead">Esplora il nostro catalogo di vini rossi, bianchi, rosati e spumanti. Ogni bottiglia racconta una storia di passione, territorio e tradizione.</p>
            </div>
            <div class="col-lg-4 text-lg-end text-center">
                <a href="<?=$path?>catalogo" class="btn btn-light btn-lg px-5 py-3 rounded-pill fw-bold">Visualizza Catalogo</a>
            </div>
        </div>
    </div>
</div>

<!-- Feature Section -->
<div class="container my-5 py-5">
    <div class="row align-items-center">
        <div class="col-lg-6 mb-4 mb-lg-0">
            <div class="position-relative">
                <img src="https://images.unsplash.com/photo-1528823872057-9c018a7a7553?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1000&q=80" class="img-fluid feature-section-image" alt="Cantina di vini">

            </div>
        </div>
        <div class="col-lg-6">
            <h2 class="display-6 fw-bold mb-4">Un progetto innovativo</h2>
            <p class="lead mb-4">La Tana di Paolo nasce dall'idea di unire la tradizione vinicola con la tecnologia moderna per offrire un'esperienza personalizzata.</p>
            <p class="mb-4">Il nostro obiettivo è creare un ponte tra appassionati e il mondo del vino, utilizzando un algoritmo innovativo che analizza le preferenze dell'utente basandosi su caratteristiche come tipologia, intensità, aromi e molto altro.</p>

            <div class="mt-4 d-flex flex-wrap gap-3">
                <a href="<?=$path?>account/questionario" class="btn btn-wine btn-lg px-4 py-3 rounded-pill">Completa il Questionario</a>
                <a href="<?=$path?>abbonamenti" class="btn btn-outline-dark btn-lg px-4 py-3 rounded-pill">Scopri gli Abbonamenti</a>
            </div>
        </div>
    </div>
</div>

<!-- Link Bootstrap Icons -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

<?php require 'App/View/component/footer.php'; ?>
