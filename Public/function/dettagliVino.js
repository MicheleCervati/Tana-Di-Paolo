/**
 * Variabili globali per la pagina dettaglio vino
 */
let wineId = null;
let relatedWines = [];

/**
 * Inizializza la pagina di dettaglio quando il DOM è completamente caricato
 */
document.addEventListener('DOMContentLoaded', function() {
    // Imposta il wineId dal valore globale o dall'URL
    wineId = VINO_ID || getWineIdFromUrl();

    if (!wineId) {
        showError('ID vino non valido');
        return;
    }

    // Carica i dettagli del vino
    fetchWineDetails(wineId);

    // Imposta gli event listener
    setupEventListeners();
});

/**
 * Ottiene l'ID del vino dall'URL corrente
 * @returns {number|null} - ID del vino o null se non trovato
 */
function getWineIdFromUrl() {
    const urlParts = window.location.pathname.split('/');

    // Cerca l'indice di "dettaglio" nell'URL
    const dettaglioIndex = urlParts.indexOf('dettaglio');

    // Se "dettaglio" è presente, il vino ID dovrebbe essere nell'elemento successivo
    if (dettaglioIndex > 0 && dettaglioIndex < urlParts.length - 1) {
        const id = parseInt(urlParts[dettaglioIndex + 1]);
        return isNaN(id) ? null : id;
    }

    // Approccio alternativo: cerca il pattern "vino/qualsiasi/ID"
    const vinoIndex = urlParts.indexOf('vino');
    if (vinoIndex > -1 && vinoIndex < urlParts.length - 2) {
        const id = parseInt(urlParts[vinoIndex + 2]);
        return isNaN(id) ? null : id;
    }

    return null;
}

/**
 * Imposta gli event listener per la pagina
 */
function setupEventListeners() {
    // Delegazione degli eventi per gestire elementi dinamici
    document.addEventListener('click', function(e) {
        // Aggiungi al carrello
        if (e.target && (e.target.id === 'addToCartBtn' || e.target.closest('#addToCartBtn'))) {
            e.preventDefault();
            addToCart();
        }

        // Gestione quantità
        if (e.target && e.target.classList.contains('quantity-btn')) {
            e.preventDefault();
            handleQuantityChange(e.target.dataset.action);
        }
    });

    // Listener per il cambio quantità manuale
    document.addEventListener('change', function(e) {
        if (e.target && e.target.id === 'quantity') {
            updateTotalPrice();
        }
    });
}

/**
 * Gestisce l'aumento/diminuzione della quantità
 * @param {string} action - 'increase' o 'decrease'
 */
function handleQuantityChange(action) {
    const quantityInput = document.getElementById('quantity');
    if (!quantityInput) return;

    const currentValue = parseInt(quantityInput.value);
    const maxQuantity = parseInt(quantityInput.max) || Infinity;

    if (action === 'increase' && currentValue < maxQuantity) {
        quantityInput.value = currentValue + 1;
    } else if (action === 'decrease' && currentValue > 1) {
        quantityInput.value = currentValue - 1;
    }

    updateTotalPrice();
}

/**
 * Recupera i dettagli del vino dall'API
 * @param {number} id - ID del vino da recuperare
 */
function fetchWineDetails(id) {
    const container = document.getElementById('wine-detail-container');
    if (!container) {
        console.error('Container del vino non trovato');
        return;
    }

    // Mostra il loader
    container.innerHTML = `
        <div class="text-center my-5">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Caricamento...</span>
            </div>
            <p class="mt-2">Caricamento dettagli vino...</p>
        </div>
    `;

    fetch(`${BASE_PATH}api/vino/${id}`)
        .then(response => {
            if (!response.ok) {
                throw new Error(`Errore HTTP: ${response.status}`);
            }
            return response.json();
        })
        .then(wine => {
            displayWineDetails(wine);
            document.title = `${wine.nome} - La Tana di Paolo`;
        })
        .catch(error => {
            console.error('Errore fetch dettagli vino:', error);
            showError('Impossibile caricare i dettagli del vino. Riprova più tardi.');
        });
}

/**
 * Visualizza i dettagli del vino nella pagina
 * @param {Object} wine - Oggetto con i dati del vino
 */
function displayWineDetails(wine) {
    const container = document.getElementById('wine-detail-container');
    if (!container) return;

    // Formatta i dati
    const formattedPrice = parseFloat(wine.prezzo_vendita).toFixed(2);
    const gradazione = wine.alcol ? `${parseFloat(wine.alcol).toFixed(1)}% vol.` : 'N/D';

    // Determina disponibilità
    const availability = getAvailabilityInfo(wine.quantita_magazzino);

    // Costruisci sezione aromi
    const aromiHtml = buildAromiHtml(wine.aromi);

    // HTML della pagina
    container.innerHTML = `
        <div class="row">
            <!-- Immagine del vino -->
            <div class="col-md-5 mb-4">
                <div class="bg-light rounded p-3 text-center">
                    <img src="${BASE_PATH}Public/image/vini/${wine.immagine || 'default.jpg'}" 
                         class="img-fluid" 
                         alt="${wine.nome}" 
                         style="max-height: 500px; object-fit: contain;">
                </div>
            </div>
            
            <!-- Dettagli del vino -->
            <div class="col-md-7">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item"><a href="${BASE_PATH}">Home</a></li>
                        <li class="breadcrumb-item"><a href="${BASE_PATH}catalogo">Catalogo</a></li>
                        <li class="breadcrumb-item active">${wine.nome}</li>
                    </ol>
                </nav>
                
                <h1 class="mb-2">${wine.nome}</h1>
                <h6 class="text-muted mb-4">${wine.cantina?.nome || 'Cantina non disponibile'}</h6>
                
                <!-- Prezzo e disponibilità -->
                <div class="mb-4">
                    <div class="d-flex align-items-center">
                        <h2 class="me-3 mb-0">€ ${formattedPrice}</h2>
                        <span class="badge bg-secondary">${wine.tipologia?.nome || 'N/D'}</span>
                    </div>
                    <p class="mt-2 ${availability.class}">
                        <i class="bi ${availability.icon}"></i> 
                        ${availability.text} ${availability.quantityText}
                    </p>
                </div>
                
                <!-- Selezione quantità e aggiungi al carrello -->
                <div class="mb-4">
                    <div class="input-group mb-3" style="max-width: 200px;">
                        <button class="btn btn-outline-secondary quantity-btn" data-action="decrease" type="button">-</button>
                        <input type="number" class="form-control text-center" id="quantity" 
                               value="1" min="1" max="${wine.quantita_magazzino || 0}">
                        <button class="btn btn-outline-secondary quantity-btn" data-action="increase" type="button">+</button>
                    </div>
                    
                    <div class="d-flex align-items-center gap-3">
                        <button id="addToCartBtn" class="btn btn-primary ${wine.quantita_magazzino <= 0 ? 'disabled' : ''}" 
                                ${wine.quantita_magazzino <= 0 ? 'disabled' : ''}>
                            <i class="bi bi-cart-plus"></i> Aggiungi al carrello
                        </button>
                        <p class="mb-0" id="totalPrice">Totale: € ${formattedPrice}</p>
                    </div>
                </div>
                
                <!-- Caratteristiche principali -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Caratteristiche</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <p class="mb-1 fw-bold">Tipologia:</p>
                                <p>${wine.tipologia?.nome || 'N/D'}</p>
                                
                                <p class="mb-1 fw-bold">Vitigno:</p>
                                <p>${wine.vitigno?.nome || 'N/D'}</p>
                                
                                <p class="mb-1 fw-bold">Annata:</p>
                                <p>${wine.annata || 'N/D'}</p>
                            </div>
                            <div class="col-md-6 mb-3">
                                <p class="mb-1 fw-bold">Gradazione alcolica:</p>
                                <p>${gradazione}</p>
                                
                                <p class="mb-1 fw-bold">Invecchiamento:</p>
                                <p>${wine.invecchiamento?.nome || 'N/D'}</p>
                                
                                <p class="mb-1 fw-bold">Maturazione:</p>
                                <p>${wine.maturazione ? `${wine.maturazione} mesi` : 'N/D'}</p>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Aromi -->
                ${aromiHtml}
                
                <!-- Caratteristiche tecniche -->
                <div class="card mb-4">
                    <div class="card-header">
                        <h5 class="mb-0">Caratteristiche tecniche</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <p class="mb-1 fw-bold">Zuccheri residui:</p>
                                <p>${wine.zuccheri_residui ? `${wine.zuccheri_residui} g/l` : 'N/D'}</p>
                                
                                <p class="mb-1 fw-bold">Tannini:</p>
                                <p>${wine.tannini ? `${wine.tannini} mg/l` : 'N/D'}</p>
                            </div>
                            <div class="col-md-6">
                                <p class="mb-1 fw-bold">Acidità totale:</p>
                                <p>${calculateTotalAcidity(wine)} g/l</p>
                                
                                <p class="mb-1 fw-bold">Glicerolo:</p>
                                <p>${wine.glicerolo ? `${wine.glicerolo} g/l` : 'N/D'}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `;
}

/**
 * Calcola l'acidità totale sommando i vari acidi
 */
function calculateTotalAcidity(wine) {
    const acids = [
        parseFloat(wine.acido_tartarico) || 0,
        parseFloat(wine.acido_malico) || 0,
        parseFloat(wine.acido_citrico) || 0,
        parseFloat(wine.acido_lattico) || 0
    ];

    const total = acids.reduce((sum, acid) => sum + acid, 0);
    return total.toFixed(2);
}

/**
 * Costruisce l'HTML per la sezione aromi
 */
function buildAromiHtml(aromi) {
    if (!aromi || Object.keys(aromi).length === 0) {
        return '';
    }

    let html = '<div class="card mb-4"><div class="card-header"><h5 class="mb-0">Aromi</h5></div><div class="card-body"><div class="row">';

    for (const [category, items] of Object.entries(aromi)) {
        if (items && items.length > 0) {
            html += `
                <div class="col-md-6 mb-3">
                    <h6 class="fw-bold">${capitalizeFirstLetter(category)}:</h6>
                    <ul class="list-unstyled">
                        ${items.map(item => `<li><i class="bi bi-dot"></i> ${item}</li>`).join('')}
                    </ul>
                </div>
            `;
        }
    }

    html += '</div></div></div>';
    return html;
}

/**
 * Restituisce le informazioni sulla disponibilità
 */
function getAvailabilityInfo(quantity) {
    quantity = parseInt(quantity) || 0;

    if (quantity <= 0) {
        return {
            class: 'text-danger',
            icon: 'bi-x-circle',
            text: 'Non disponibile',
            quantityText: ''
        };
    }

    if (quantity < 5) {
        return {
            class: 'text-warning',
            icon: 'bi-exclamation-circle',
            text: 'Ultime unità',
            quantityText: `(${quantity} in magazzino)`
        };
    }

    return {
        class: 'text-success',
        icon: 'bi-check-circle',
        text: 'Disponibile',
        quantityText: `(${quantity} in magazzino)`
    };
}

/**
 * Aggiorna il prezzo totale in base alla quantità selezionata
 */
function updateTotalPrice() {
    const quantityInput = document.getElementById('quantity');
    const totalPriceElement = document.getElementById('totalPrice');

    if (!quantityInput || !totalPriceElement) return;

    const quantity = parseInt(quantityInput.value);
    const priceText = document.querySelector('h2.me-3')?.textContent;
    const unitPrice = parseFloat(priceText?.replace('€', '').trim());


    // Limita la quantità al massimo disponibile
    const maxQuantity = parseInt(quantityInput.max) || Infinity;
    if (quantity > maxQuantity) {
        quantityInput.value = maxQuantity;
        updateTotalPrice();
        return;
    }

    if (isNaN(unitPrice)) return;

    const totalPrice = (quantity * unitPrice).toFixed(2);
    totalPriceElement.textContent = `Totale: € ${totalPrice}`;
}

/**
 * Aggiunge il vino corrente al carrello
 */
function addToCart() {
    const quantityInput = document.getElementById('quantity');
    if (!quantityInput) return;

    const quantity = parseInt(quantityInput.value);
    if (isNaN(quantity) || quantity <= 0) {
        showNotification('Seleziona una quantità valida', 'warning');
        return;
    }

    fetch(`${BASE_PATH}api/carrello/add`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams({
            product: wineId,
            quantity: quantity
        })
    })
        .then(response => {
            if (!response.ok) throw new Error('Errore nell\'aggiunta al carrello');
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showNotification('Prodotto aggiunto al carrello!', 'success');
                updateCartCounter(data.cart_count || 0);
            } else {
                showNotification(data.message || 'Errore nell\'aggiunta al carrello', 'danger');
            }
        })
        .catch(error => {
            console.error('Errore aggiunta al carrello:', error);
            showNotification('Errore nell\'aggiunta al carrello. Riprova più tardi.', 'danger');
        });
}

/**
 * Aggiorna il contatore del carrello
 */
function updateCartCounter(count) {
    const cartCounter = document.querySelector('.cart-counter');
    if (cartCounter) {
        cartCounter.textContent = count;
        cartCounter.classList.add('cart-counter-animation');
        setTimeout(() => cartCounter.classList.remove('cart-counter-animation'), 500);
    }
}

/**
 * Mostra una notifica all'utente
 */
function showNotification(message, type = 'info') {
    const toastContainer = document.getElementById('toast-container') || createToastContainer();

    const toastId = 'toast-' + Date.now();
    const toast = document.createElement('div');
    toast.className = `toast align-items-center text-white bg-${type} border-0`;
    toast.id = toastId;
    toast.setAttribute('role', 'alert');
    toast.setAttribute('aria-live', 'assertive');
    toast.setAttribute('aria-atomic', 'true');

    toast.innerHTML = `
        <div class="d-flex">
            <div class="toast-body">${message}</div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    `;

    toastContainer.appendChild(toast);
    new bootstrap.Toast(toast, { autohide: true, delay: 3000 }).show();

    toast.addEventListener('hidden.bs.toast', () => toast.remove());
}

/**
 * Crea il container per i toast se non esiste
 */
function createToastContainer() {
    const container = document.createElement('div');
    container.id = 'toast-container';
    container.className = 'position-fixed bottom-0 end-0 p-3';
    container.style.zIndex = '9999';
    document.body.appendChild(container);
    return container;
}

/**
 * Mostra un messaggio di errore
 */
function showError(message) {
    const container = document.getElementById('wine-detail-container');
    if (!container) return;

    container.innerHTML = `
        <div class="alert alert-danger">
            <i class="bi bi-exclamation-triangle me-2"></i>
            ${message}
        </div>
        <div class="text-center mt-4">
            <a href="${BASE_PATH}vini/catalogo" class="btn btn-primary">
                <i class="bi bi-arrow-left"></i> Torna al catalogo
            </a>
        </div>
    `;
}

/**
 * Utility: capitalizza la prima lettera
 */
function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
}