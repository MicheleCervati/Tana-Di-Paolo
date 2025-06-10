<?php
$tab_title = 'Chi Siamo';
$main_classes = 'container my-4';
require 'App/View/component/header.php';
?>
    <div class="hero-section about-hero">
    <div class="parallax-bg" style="background-image: url('<?=$path?>/Public/image/team.png');"></div>
    <div class="position-absolute top-50 start-50 translate-middle text-center text-white">
        <h1 class="display-2 fw-bold mb-3" data-aos="fade-up">Chi Siamo</h1>
        <p class="lead fs-3 mb-4" data-aos="fade-up" data-aos-delay="200">La passione per il vino che unisce tradizione e innovazione</p>
        <div class="wine-divider">
            <i class="bi bi-flower3"></i>
            <span class="line"></span>
            <i class="bi bi-cup-fill"></i>
            <span class="line"></span>
            <i class="bi bi-flower3"></i>
        </div>
    </div>
</div>

<section class="container my-5 py-5">
    <div class="row align-items-center">
        <div class="col-lg-6" data-aos="fade-right">
            <div class="position-relative">
                <img src="<?=$path?>/Public/image/cantina.jpg" class="img-fluid rounded-3 shadow" alt="La nostra cantina">
                <div class="wine-bottle-overlay">
                    <i class="bi bi-wind text-wine"></i>
                </div>
            </div>
        </div>
        <div class="col-lg-6 ps-lg-5" data-aos="fade-left">
            <div class="mb-4">
                <h2 class="display-5 fw-bold text-wine mb-3">La Nostra Storia</h2>
                <div class="wine-divider-small mb-4">
                    <span class="line-sm"></span>
                    <i class="bi bi-diamond-fill"></i>
                    <span class="line-sm"></span>
                </div>
                <p class="lead">La Tana di Paolo nasce dalla passione condivisa per l'eccellenza enologica e il desiderio di rendere accessibile a tutti il meraviglioso mondo del vino.</p>
                <p>Il nostro progetto prende vita nel cuore delle colline italiane, con l'obiettivo di unire la tradizione vinicola secolare alla modernità della tecnologia. Crediamo che ogni bottiglia racconti una storia unica di territorio, passione e dedizione, e la nostra missione è aiutarti a scoprire quella perfetta per il tuo palato.</p>
                <p>Attraverso un approccio innovativo e personalizzato, offriamo un'esperienza enologica su misura che risponde alle preferenze individuali, guidandoti in un viaggio sensoriale attraverso i sapori, i profumi e le storie dei migliori vini italiani e internazionali.</p>
            </div>
        </div>
    </div>
</section>

<section class="bg-wine py-5">
    <div class="container py-5">
        <div class="text-center mb-5" data-aos="fade-up">
            <h2 class="display-5 fw-bold mb-3">Il Nostro Team</h2>
            <div class="wine-divider mx-auto mb-4">
                <span class="line"></span>
                <i class="bi bi-people-fill"></i>
                <span class="line"></span>
            </div>
            <p class="lead col-lg-8 mx-auto">Quattro appassionati uniti dall'amore per il vino e dalla volontà di offrire un'esperienza enologica straordinaria e personalizzata.</p>
        </div>

        <div class="row g-5">
            <!-- Membro 1 -->
            <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="100">
                <div class="team-card">
                    <div class="team-image-wrapper">
                        <div class="team-image" style="background-image: url('<?=$path?>/public/image/team/somelier.jpeg');"></div>
                        <div class="team-wine-glass">
                            <i class="bi bi-cup-straw"></i>
                        </div>
                    </div>
                    <div class="team-content">
                        <h3 class="h4 fw-bold mb-1">Matteo Fuso</h3>
                        <p class="text-wine mb-3">Sommelier & Fondatore</p>
                        <p class="team-description">Esperto degustatore con una passione per i vini rossi corposi e strutturati. La sua conoscenza delle cantine italiane è il cuore del nostro catalogo.</p>
                        <div class="team-social">
                            <a href="#" class="team-social-link"><i class="bi bi-linkedin"></i></a>
                            <a href="#" class="team-social-link"><i class="bi bi-instagram"></i></a>
                            <a href="#" class="team-social-link"><i class="bi bi-envelope-fill"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="200">
                <div class="team-card">
                    <div class="team-image-wrapper">
                        <div class="team-image" style="background-image: url('<?=$path?>/public/image/Team/il_meglio.jpg');"></div>
                        <div class="team-wine-glass">
                            <i class="bi bi-cup-straw"></i>
                        </div>
                    </div>
                    <div class="team-content">
                        <h3 class="h4 fw-bold mb-1">Michele Cervati</h3>
                        <p class="text-wine mb-3">Responsabile Tecnologico</p>
                        <p class="team-description">Mente innovativa dietro il nostro algoritmo di personalizzazione. Unisce la sua passione per la tecnologia a quella per i vini bianchi aromatici.</p>
                        <div class="team-social">
                            <a href="#" class="team-social-link"><i class="bi bi-linkedin"></i></a>
                            <a href="https://www.instagram.com/michelecervati_/profilecard/?igsh=d3N0bnhpbG12ZmNh" class="team-social-link"><i class="bi bi-instagram"></i></a>
                            <a href="#" class="team-social-link"><i class="bi bi-envelope-fill"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="300">
                <div class="team-card">
                    <div class="team-image-wrapper">
                        <div class="team-image" style="background-image: url('<?=$path?>/public/image/team/leader.jpg');"></div>
                        <div class="team-wine-glass">
                            <i class="bi bi-cup-straw"></i>
                        </div>
                    </div>
                    <div class="team-content">
                        <h3 class="h4 fw-bold mb-1">Xiaqiang Qiu</h3>
                        <p class="text-wine mb-3">Relazioni Internazionali</p>
                        <p class="team-description">Il nostro ponte con i produttori di vino internazionali. La sua conoscenza dei mercati asiatici ha arricchito la nostra offerta con selezioni uniche.</p>
                        <div class="team-social">
                            <a href="#" class="team-social-link"><i class="bi bi-linkedin"></i></a>
                            <a href="#" class="team-social-link"><i class="bi bi-instagram"></i></a>
                            <a href="#" class="team-social-link"><i class="bi bi-envelope-fill"></i></a>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="400">
                <div class="team-card">
                    <div class="team-image-wrapper">
                        <div class="team-image" style="background-image: url('<?=$path?>/public/image/team/pompiere.jpg');"></div>
                        <div class="team-wine-glass">
                            <i class="bi bi-cup-straw"></i>
                        </div>
                    </div>
                    <div class="team-content">
                        <h3 class="h4 fw-bold mb-1">Francesca Rossi</h3>
                        <p class="text-wine mb-3">Esperta in Customer Experience</p>
                        <p class="team-description">La sua sensibilità per i vini naturali si riflette nel nostro approccio cliente-centrico e nella cura per ogni dettaglio dell'esperienza utente.</p>
                        <div class="team-social">
                            <a href="#" class="team-social-link"><i class="bi bi-linkedin"></i></a>
                            <a href="https://www.instagram.com/francesca_rossiii_/profilecard/?igsh=d3N0bnhpbG12ZmNh" class="team-social-link"><i class="bi bi-instagram"></i></a>
                            <a href="#" class="team-social-link"><i class="bi bi-envelope-fill"></i></a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="container my-5 py-5">
    <div class="row align-items-center">
        <div class="col-lg-6 order-lg-2" data-aos="fade-left">
            <div class="position-relative">
                <img src="<?=$path?>/Public/image/wine-tasting.jpg" class="img-fluid rounded-3 shadow" alt="Degustazione vini">
                <div class="wine-drops-overlay">
                    <i class="bi bi-droplet-fill"></i>
                    <i class="bi bi-droplet-half"></i>
                    <i class="bi bi-droplet"></i>
                </div>
            </div>
        </div>
        <div class="col-lg-6 pe-lg-5 order-lg-1" data-aos="fade-right">
            <div class="mb-4">
                <h2 class="display-5 fw-bold text-wine mb-3">La Nostra Filosofia</h2>
                <div class="wine-divider-small mb-4">
                    <span class="line-sm"></span>
                    <i class="bi bi-diamond-fill"></i>
                    <span class="line-sm"></span>
                </div>
                <p class="lead">Crediamo che il vino sia un'esperienza personale, una scoperta continua che merita di essere guidata e personalizzata.</p>
                <p>La nostra filosofia si basa su tre principi fondamentali:</p>

                <div class="philosophy-point mb-3">
                    <div class="philosophy-icon">
                        <i class="bi bi-award"></i>
                    </div>
                    <div class="philosophy-content">
                        <h4 class="h5 fw-bold">Qualità senza compromessi</h4>
                        <p>Selezioniamo solo vini di eccellenza, lavorando direttamente con produttori che condividono la nostra passione per la qualità.</p>
                    </div>
                </div>

                <div class="philosophy-point mb-3">
                    <div class="philosophy-icon">
                        <i class="bi bi-fingerprint"></i>
                    </div>
                    <div class="philosophy-content">
                        <h4 class="h5 fw-bold">Personalizzazione autentica</h4>
                        <p>Attraverso il nostro algoritmo proprietario, analizziamo le tue preferenze per offrirti una selezione di vini perfettamente allineata ai tuoi gusti.</p>
                    </div>
                </div>

                <div class="philosophy-point">
                    <div class="philosophy-icon">
                        <i class="bi bi-book"></i>
                    </div>
                    <div class="philosophy-content">
                        <h4 class="h5 fw-bold">Educazione e scoperta</h4>
                        <p>Ti accompagniamo in un viaggio di scoperta enologica, fornendoti conoscenze e storie che arricchiscono ogni sorso.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="bg-wine-light py-5">
    <div class="container py-5">
        <div class="text-center mb-5" data-aos="fade-up">
            <h2 class="display-5 fw-bold text-wine mb-3">I Nostri Servizi</h2>
            <div class="wine-divider mx-auto mb-4">
                <span class="line"></span>
                <i class="bi bi-gift-fill"></i>
                <span class="line"></span>
            </div>
            <p class="lead col-lg-8 mx-auto">Offriamo un'esperienza enologica completa e personalizzata, pensata per soddisfare ogni tipo di appassionato.</p>
        </div>

        <div class="row g-4">
            <!-- Servizio 1 -->
            <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="100">
                <div class="service-card h-100">
                    <div class="service-icon">
                        <i class="bi bi-clipboard-data"></i>
                    </div>
                    <h3 class="h4 fw-bold mb-3">Questionario Personalizzato</h3>
                    <p>Il nostro questionario interattivo analizza le tue preferenze e il tuo profilo gustativo per creare una selezione di vini su misura per te.</p>
                    <a href="<?=$path?>account/questionario" class="btn btn-outline-wine rounded-pill mt-3">Scopri di più</a>
                </div>
            </div>

            <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="200">
                <div class="service-card h-100">
                    <div class="service-icon">
                        <i class="bi bi-box-seam"></i>
                    </div>
                    <h3 class="h4 fw-bold mb-3">Abbonamenti Esclusivi</h3>
                    <p>Ricevi periodicamente a casa tua una selezione di vini scelti appositamente per te dal nostro team di esperti, basata sul tuo profilo personale.</p>
                    <a href="<?=$path?>abbonamenti" class="btn btn-outline-wine rounded-pill mt-3">Esplora i piani</a>
                </div>
            </div>

            <div class="col-lg-4 col-md-6" data-aos="fade-up" data-aos-delay="300">
                <div class="service-card h-100">
                    <div class="service-icon">
                        <i class="bi bi-basket"></i>
                    </div>
                    <h3 class="h4 fw-bold mb-3">Catalogo Curato</h3>
                    <p>Esplora il nostro catalogo di oltre 500 vini selezionati con cura, con descrizioni dettagliate e abbinamenti gastronomici consigliati.</p>
                    <a href="<?=$path?>catalogo" class="btn btn-outline-wine rounded-pill mt-3">Visita il catalogo</a>
                </div>
            </div>
</section>

<section class="container my-5 py-5">
    <div class="text-center mb-5" data-aos="fade-up">
        <h2 class="display-5 fw-bold text-wine mb-3">I Nostri Numeri</h2>
        <div class="wine-divider mx-auto mb-4">
            <span class="line"></span>
            <i class="bi bi-graph-up"></i>
            <span class="line"></span>
        </div>
        <p class="lead col-lg-8 mx-auto">Cifre che raccontano la nostra dedizione all'eccellenza enologica.</p>
    </div>

    <div class="row g-4 text-center">
        <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="100">
            <div class="stats-card">
                <div class="stats-icon">
                    <i class="bi bi-cup-straw"></i>
                </div>
                <h3 class="display-4 fw-bold text-wine counter-value">500+</h3>
                <p class="stats-label">Vini Selezionati</p>
            </div>
        </div>

        <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="200">
            <div class="stats-card">
                <div class="stats-icon">
                    <i class="bi bi-house-door"></i>
                </div>
                <h3 class="display-4 fw-bold text-wine counter-value">120+</h3>
                <p class="stats-label">Cantine Partner</p>
            </div>
        </div>

        <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="300">
            <div class="stats-card">
                <div class="stats-icon">
                    <i class="bi bi-people"></i>
                </div>
                <h3 class="display-4 fw-bold text-wine counter-value">5000+</h3>
                <p class="stats-label">Clienti Soddisfatti</p>
            </div>
        </div>

        <div class="col-lg-3 col-md-6" data-aos="fade-up" data-aos-delay="400">
            <div class="stats-card">
                <div class="stats-icon">
                    <i class="bi bi-globe"></i>
                </div>
                <h3 class="display-4 fw-bold text-wine counter-value">15</h3>
                <p class="stats-label">Paesi Rappresentati</p>
            </div>
        </div>
    </div>
</section>

<section class="bg-wine text-white py-5">
    <div class="container py-5">
        <div class="text-center mb-5" data-aos="fade-up">
            <h2 class="display-5 fw-bold mb-3">Cosa Dicono Di Noi</h2>
            <div class="wine-divider-light mx-auto mb-4">
                <span class="line-light"></span>
                <i class="bi bi-chat-quote-fill"></i>
                <span class="line-light"></span>
            </div>
            <p class="lead col-lg-8 mx-auto">Le esperienze di chi ha già scoperto La Tana di Paolo.</p>
        </div>

        <div class="row testimonial-slider">

            <div class="col-lg-4 mb-4" data-aos="fade-up" data-aos-delay="100">
                <div class="testimonial-card">
                    <div class="testimonial-content">
                        <p>"La personalizzazione è davvero sorprendente. Ogni bottiglia che ho ricevuto sembra essere stata scelta pensando esattamente ai miei gusti. Un servizio eccellente che ha trasformato il mio modo di scoprire nuovi vini."</p>
                    </div>
                    <div class="testimonial-author">
                        <div class="testimonial-rating">
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                        </div>
                        <h4 class="h6 fw-bold mb-0">Prof.Filippo Gasparini</h4>
                        <p class="small">Abbonato da 1 anno</p>
                    </div>
                </div>
            </div>

            <div class="col-lg-4 mb-4" data-aos="fade-up" data-aos-delay="200">
                <div class="testimonial-card">
                    <div class="testimonial-content">
                        <p>"Come appassionata di vini naturali, ho trovato in La Tana di Paolo un partner perfetto. La selezione è impeccabile e il team è sempre pronto a fornire consigli e suggerimenti personalizzati."</p>
                    </div>
                    <div class="testimonial-author">
                        <div class="testimonial-rating">
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-half"></i>
                        </div>
                        <h4 class="h6 fw-bold mb-0">Prof.ssa Sara Romagnolo</h4>
                        <p class="small">Abbonata da 6 mesi</p>
                    </div>
                </div>
            </div>


            <div class="col-lg-4 mb-4" data-aos="fade-up" data-aos-delay="300">
                <div class="testimonial-card">
                    <div class="testimonial-content">
                        <p>"Ho partecipato a una delle loro degustazioni online ed è stata un'esperienza illuminante. La competenza del team è evidente e il loro approccio al vino è accessibile anche per chi, come me, è alle prime armi."</p>
                    </div>
                    <div class="testimonial-author">
                        <div class="testimonial-rating">
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                            <i class="bi bi-star-fill"></i>
                        </div>
                        <h4 class="h6 fw-bold mb-0">Prof. Massimiliano Raspa</h4>
                        <p class="small">Cliente da 3 mesi</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<section class="cta-section-about my-5">
    <div class="container py-5">
        <div class="row align-items-center">
            <div class="col-lg-8 text-white mb-4 mb-lg-0" data-aos="fade-right">
                <h2 class="display-5 fw-bold mb-3">Inizia il tuo viaggio enologico personalizzato</h2>
                <p class="lead mb-4">Scopri vini che raccontano storie e che si adattano perfettamente ai tuoi gusti. Completa il nostro questionario e lasciati guidare in un'esperienza unica.</p>
                <div class="d-flex flex-wrap gap-3">
                    <a href="<?=$path?>account/questionario" class="btn btn-light btn-lg px-5 py-3 rounded-pill fw-bold">Completa il Questionario</a>
                    <a href="<?=$path?>catalogo" class="btn btn-outline-light btn-lg px-4 py-3 rounded-pill">Esplora il Catalogo</a>
                </div>
            </div>
            <div class="col-lg-4" data-aos="fade-left">
                <div class="cta-wine-glass">
                    <svg viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
                        <path d="M90,40 C90,40 80,70 80,100 C80,130 90,160 90,160 L110,160 C110,160 120,130 120,100 C120,70 110,40 110,40 Z" fill="none" stroke="#ffffff" stroke-width="2"/>
                        <ellipse cx="100" cy="40" rx="20" ry="5" fill="none" stroke="#ffffff" stroke-width="2"/>
                        <path d="M90,160 L110,160 L110,180 L90,180 Z" fill="none" stroke="#ffffff" stroke-width="2"/>
                        <ellipse cx="100" cy="190" rx="30" ry="5" fill="none" stroke="#ffffff" stroke-width="2"/>
                    </svg>
                </div>
            </div>
        </div>
    </div>
</section>
    <section class="container my-5 py-5">
        <div class="text-center mb-5" data-aos="fade-up">
            <h2 class="display-5 fw-bold text-wine mb-3">Contattaci</h2>
            <div class="wine-divider mx-auto mb-4">
                <span class="line"></span>
                <i class="bi bi-envelope-heart"></i>
                <span class="line"></span>
            </div>
            <p class="lead col-lg-8 mx-auto">Hai domande o vuoi saperne di più? Non esitare a metterti in contatto con noi.</p>
        </div>
        <div class="container">
            <div class="contact-cards-grid row row-cols-1 row-cols-md-2 row-cols-xl-4 g-4">
                <!-- La nostra sede -->
                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="bi bi-geo-alt-fill"></i>
                    </div>
                    <div class="contact-details">
                        <h4 class="h5 fw-bold">La nostra sede</h4>
                        <p>Via Alcide de Gasperi, 21<br>45100 Rovigo (RO)<br>Italia</p>
                    </div>
                </div>
                <!-- Telefono -->
                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="bi bi-telephone-fill"></i>
                    </div>
                    <div class="contact-details">
                        <h4 class="h5 fw-bold">Telefono</h4>
                        <p>+39 0123 456789<br>Lun-Ven: 8:30-12:30</p>
                    </div>
                </div>
                <!-- Email -->
                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="bi bi-envelope-fill"></i>
                    </div>
                    <div class="contact-details">
                        <h4 class="h5 fw-bold">Email</h4>
                        <p>support@latanadipaolo.it</p>
                    </div>
                </div>
                <!-- Orari -->
                <div class="contact-card">
                    <div class="contact-icon">
                        <i class="bi bi-clock-fill"></i>
                    </div>
                    <div class="contact-details">
                        <h4 class="h5 fw-bold">Orari</h4>
                        <p>Sede fisica: Lun-Ven 10:30-19:00<br>Supporto online: 7 giorni su 7</p>
                    </div>
                </div>
            </div>

            <!-- Social Links -->
            <div class="social-links">
                <h4 class="h5 fw-bold mb-3">Seguici sui social</h4>
                <div class="d-flex gap-3">
                    <a href="#" class="social-link" title="Facebook">
                        <i class="bi bi-facebook"></i>
                    </a>
                    <a href="#" class="social-link" title="Instagram">
                        <i class="bi bi-instagram"></i>
                    </a>
                    <a href="#" class="social-link" title="Twitter">
                        <i class="bi bi-twitter-x"></i>
                    </a>
                    <a href="#" class="social-link" title="YouTube">
                        <i class="bi bi-youtube"></i>
                    </a>
                    <a href="#" class="social-link" title="LinkedIn">
                        <i class="bi bi-linkedin"></i>
                    </a>
                </div>
            </div>
        </div>
    </section>

    <section class="map-section mb-n5">
    <div class="container-fluid p-0">
        <div class="map-container" data-aos="fade-up">
            <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2818.3863747773656!2d11.793689876974683!3d45.08149207899361!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x477efa0be28ee4c1%3A0xecf32eb2f6aaa7c7!2sI.T.I.S.%20Ferruccio%20Viola!5e0!3m2!1sit!2sit!4v1716262789722!5m2!1sit!2sit" width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
            <div class="map-overlay">
                <div class="container">
                    <div class="row">

                    </div>
                </div>
            </div>
        </div>
    </div>
</section>
<link href="Public/style/chiSiamo.css" rel="stylesheet">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        AOS.init({
            duration: 800,
            easing: 'ease-in-out',
            once: true
        });
    });
</script>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

<?php require 'App/View/component/footer.php'; ?>