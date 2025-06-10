/**
 * Variabili globali per gestire lo stato dell'applicazione
 */
let currentPage = 1;
let itemsPerPage = 10;
let totalPages = 1;
let currentOrdinamento = 'nome';
let currentOrdinamentoTipo = 'asc';

/**
 * Inizializza l'applicazione quando il DOM è completamente caricato
 */
document.addEventListener('DOMContentLoaded', function() {
    // Carica le tipologie di vino per i filtri
    fetchWineTypes();

    // Imposta gli event listener per i filtri e la paginazione
    document.getElementById('filterForm').addEventListener('submit', function(e) {
        e.preventDefault();
        currentPage = 1; // Resetta la pagina quando si filtrano i risultati
        fetchWines();
    });

    document.getElementById('itemsPerPage').addEventListener('change', function() {
        itemsPerPage = parseInt(this.value);
        currentPage = 1; // Resetta la pagina quando si cambia il numero di item per pagina
        fetchWines();
    });

    // Event listener per il cambio di ordinamento
    document.getElementById('ordinamento').addEventListener('change', function() {
        currentOrdinamento = this.value;
        currentPage = 1; // Resetta la pagina quando si cambia l'ordinamento
        fetchWines();
    });

    document.getElementById('ordinamentoTipo').addEventListener('change', function() {
        currentOrdinamentoTipo = this.value;
        currentPage = 1; // Resetta la pagina quando si cambia il tipo di ordinamento
        fetchWines();
    });

    // Carica i vini all'avvio
    fetchWines();
});

/**
 * Recupera le tipologie di vino dall'API e aggiorna i filtri
 */
function fetchWineTypes() {
    fetch(path + 'api/tipologie/lista')
        .then(response => {
            if (!response.ok) {
                throw new Error('Errore nel recupero delle tipologie: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            if (Array.isArray(data)) {
                updateWineTypeFilters(data);
            } else {
                console.error('Formato dati non valido per le tipologie');
                showError('Impossibile caricare le tipologie di vino');
            }
        })
        .catch(error => {
            console.error('Errore durante il recupero delle tipologie:', error);
            document.getElementById('tipologie-container').innerHTML =
                '<div class="alert alert-warning py-1">Impossibile caricare le tipologie</div>';
        });
}

/**
 * Aggiorna i filtri delle tipologie con i dati dall'API
 * @param {Array} types - Array delle tipologie di vino dall'API
 */
function updateWineTypeFilters(types) {
    const container = document.getElementById('tipologie-container');
    container.innerHTML = '';

    if (types.length === 0) {
        container.innerHTML = '<div class="alert alert-info py-1">Nessuna tipologia disponibile</div>';
        return;
    }

    // Crea un checkbox per ogni tipologia
    types.forEach(type => {
        const typeId = type.id || '';
        const typeName = type.tipologia || '';

        const checkboxHtml = `
            <div class="form-check form-check-inline">
                <input class="form-check-input tipologia-check" type="checkbox" 
                       id="tipo${typeId}" name="tipologia[]" value="${typeName}">
                <label class="form-check-label" for="tipo${typeId}">${typeName}</label>
            </div>
        `;

        container.innerHTML += checkboxHtml;
    });
}

/**
 * Recupera l'elenco dei vini dall'API in base ai filtri applicati
 */
function fetchWines() {
    // Costruisci l'URL della richiesta API con i filtri
    let apiUrl = buildApiUrl();

    // Mostra il loader
    document.getElementById('wine-container').innerHTML = `
        <div class="col-12 text-center">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Caricamento...</span>
            </div>
            <p>Caricamento vini in corso...</p>
        </div>
    `;

    // Fetch dei dati dall'API
    fetch(apiUrl)
        .then(response => {
            if (!response.ok) {
                throw new Error('Errore nella risposta del server: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            if (data && data.vini && Array.isArray(data.vini)) {
                displayWines(data);
                updatePagination(data);
                updateResultsCount(data);
            } else {
                showError('Formato dati non valido');
            }
        })
        .catch(error => {
            console.error('Errore durante il recupero dei vini:', error);
            showError('Impossibile caricare i vini. Riprova più tardi.');
        });
}

/**
 * Costruisce l'URL dell'API con i parametri di filtro
 * @returns {string} URL completo per la richiesta API
 */
function buildApiUrl() {
    // Base URL
    let url = path + 'api/vini/lista';

    // Parametri
    let params = new URLSearchParams();

    // Paginazione
    params.append('pagina', currentPage);
    params.append('limit', itemsPerPage);

    // Ordinamento
    params.append('ordinamento', currentOrdinamento);
    params.append('ordinamentoTipo', currentOrdinamentoTipo);

    // Nome del vino (ricerca)
    const nomeVino = document.getElementById('nomeVino').value.trim();
    if (nomeVino) params.append('nome', nomeVino);

    // Prezzo minimo e massimo
    const minPrezzo = document.getElementById('minPrezzo').value;
    const maxPrezzo = document.getElementById('maxPrezzo').value;

    if (minPrezzo) params.append('min_prezzo', minPrezzo);
    if (maxPrezzo) params.append('max_prezzo', maxPrezzo);

    // Tipologie selezionate
    const tipologieChecked = document.querySelectorAll('.tipologia-check:checked');
    tipologieChecked.forEach(checkbox => {
        params.append('tipologia[]', checkbox.value.toLowerCase());
    });

    return `${url}?${params.toString()}`;
}

/**
 * Visualizza i vini nel container principale
 * @param {Object} data - Dati dei vini dall'API
 */
function displayWines(data) {
    const container = document.getElementById('wine-container');
    container.innerHTML = ''; // Rimuovi loader

    if (data.vini.length === 0) {
        container.innerHTML = `
            <div class="col-12 text-center">
                <div class="alert alert-info">
                    <i class="bi bi-info-circle me-2"></i>
                    Nessun vino trovato con i criteri selezionati.
                </div>
            </div>
        `;
        return;
    }

    // Crea una card per ogni vino
    data.vini.forEach(wine => {
        const wineCard = createWineCard(wine);
        container.appendChild(wineCard);
    });
}

/**
 * Crea una card per un singolo vino
 * @param {Object} wine - Oggetto con i dati del vino
 * @returns {HTMLElement} - Elemento DOM della card
 */
function createWineCard(wine) {
    // Crea il container della colonna
    const col = document.createElement('div');
    col.className = 'col-md-4 col-lg-3 mb-4';

    // Genera una breve descrizione basata sui dati del vino
    const description = `${wine.tipologia.nome}, ${wine.annata}`;

    // Crea l'HTML della card con link alla pagina dettaglio
    col.innerHTML = `
        <div class="card h-100 shadow-sm border-light">
            <a href="${path}vino/dettaglio/${wine.id}" class="text-decoration-none">
                <div class="bg-light text-center p-3" style="height: 220px;">
                    <img src="${path}Public/image/vini/${wine.immagine}"
                         class="img-fluid h-100"
                         alt="${wine.nome}"
                         style="object-fit: contain;">
                </div>
                <div class="card-body text-center text-body">
                    <h5 class="card-title">${wine.nome}</h5>
                    <div class="card-text">
                        <p class="text-muted mb-1 small">${description}</p>
                        <p class="fw-bold mb-2">${wine.cantina.nome}</p>
                        <p class="mb-3 small">${wine.vitigno.nome}</p>
                        <div class="d-flex justify-content-between align-items-center">
                            <span class="badge bg-primary fs-6">€ ${parseFloat(wine.prezzo_vendita).toFixed(2)}</span>
                            <span class="text-muted small">${wine.quantita_magazzino} in stock</span>
                        </div>
                    </div>
                </div>
            </a>
        </div>
    `;

    return col;
}

/**
 * Aggiorna la paginazione in base ai dati ricevuti dall'API
 * @param {Object} data - Dati di paginazione dall'API
 */
function updatePagination(data) {
    totalPages = data.pagine_totali;
    currentPage = parseInt(data.pagina);

    // Costruisci la paginazione
    const paginationTop = document.getElementById('paginationTop');
    const paginationBottom = document.getElementById('paginationBottom');

    // Crea l'HTML della paginazione
    const paginationHtml = createPaginationHtml(currentPage, totalPages);

    // Aggiorna entrambe le paginazioni
    paginationTop.innerHTML = paginationHtml;
    paginationBottom.innerHTML = paginationHtml;

    // Aggiungi event listener ai link di paginazione
    document.querySelectorAll('.page-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            const page = parseInt(this.getAttribute('data-page'));
            if (page && page !== currentPage) {
                currentPage = page;
                fetchWines();
                // Scroll to top after loading new page
                window.scrollTo({top: 0, behavior: 'smooth'});
            }
        });
    });
}

/**
 * Crea l'HTML per la paginazione
 * @param {number} currentPage - Pagina corrente
 * @param {number} totalPages - Numero totale di pagine
 * @returns {string} - HTML della paginazione
 */
function createPaginationHtml(currentPage, totalPages) {
    if (totalPages <= 1) return '';

    let html = '';

    // Pulsante Precedente
    html += `
        <li class="page-item ${currentPage === 1 ? 'disabled' : ''}">
            <a class="page-link" href="#" data-page="${currentPage - 1}" aria-label="Previous">
                <span aria-hidden="true">&laquo;</span>
            </a>
        </li>
    `;

    // Logica per mostrare un numero ragionevole di pagine
    let startPage = Math.max(1, currentPage - 2);
    let endPage = Math.min(totalPages, currentPage + 2);

    // Assicurati di mostrare almeno 5 pagine se possibile
    if (endPage - startPage < 4) {
        if (startPage === 1) {
            endPage = Math.min(totalPages, startPage + 4);
        } else if (endPage === totalPages) {
            startPage = Math.max(1, endPage - 4);
        }
    }

    // Prima pagina e ellipsis
    if (startPage > 1) {
        html += `<li class="page-item"><a class="page-link" href="#" data-page="1">1</a></li>`;
        if (startPage > 2) {
            html += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
        }
    }

    // Pagine numerate
    for (let i = startPage; i <= endPage; i++) {
        html += `
            <li class="page-item ${i === currentPage ? 'active' : ''}">
                <a class="page-link" href="#" data-page="${i}">${i}</a>
            </li>
        `;
    }

    // Ultima pagina e ellipsis
    if (endPage < totalPages) {
        if (endPage < totalPages - 1) {
            html += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
        }
        html += `<li class="page-item"><a class="page-link" href="#" data-page="${totalPages}">${totalPages}</a></li>`;
    }

    // Pulsante Successivo
    html += `
        <li class="page-item ${currentPage === totalPages ? 'disabled' : ''}">
            <a class="page-link" href="#" data-page="${currentPage + 1}" aria-label="Next">
                <span aria-hidden="true">&raquo;</span>
            </a>
        </li>
    `;

    return html;
}

/**
 * Aggiorna il conteggio dei risultati
 * @param {Object} data - Dati con conteggio risultati
 */
function updateResultsCount(data) {
    document.getElementById('viniMostrati').textContent = data.vini_mostrati;
    document.getElementById('viniTrovati').textContent = data.vini_trovati;
}

/**
 * Mostra un messaggio di errore
 * @param {string} message - Messaggio di errore da visualizzare
 */
function showError(message) {
    // Sostituisci l'indicatore di caricamento con un messaggio di errore
    const container = document.getElementById('wine-container');
    container.innerHTML = `
        <div class="col-12 text-center">
            <div class="alert alert-warning">
                <i class="bi bi-exclamation-triangle me-2"></i>
                Impossibile caricare i vini. Riprova più tardi.
            </div>
        </div>
    `;
    if (typeof custom_alert === 'function') {
        custom_alert(message, 'danger');
    } else {
        console.error(message);
    }
}