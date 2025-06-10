document.addEventListener('DOMContentLoaded', function() {
    // Variabili globali
    let ordini = [];
    let ordiniCaricati = false;

    // Elementi DOM
    const ordiniLoading = document.getElementById('ordini-loading');
    const ordiniVuoti = document.getElementById('ordini-vuoti');
    const ordiniError = document.getElementById('ordini-error');
    const ordiniContainer = document.getElementById('ordini-container');

    // Verifica se c'è un messaggio di successo nell'URL
    const urlParams = new URLSearchParams(window.location.search);
    const successParam = urlParams.get('succ');

    if (successParam === '0') {
        // Mostra messaggio di successo per ordine completato
        mostraMessaggioSuccesso();
        // Rimuovi il parametro dall'URL senza ricaricare la pagina
        const newUrl = window.location.pathname;
        window.history.replaceState({}, document.title, newUrl);
    }

    // Carica gli ordini all'avvio
    caricaOrdini();

    /**
     * Carica la lista degli ordini dell'utente
     */
    function caricaOrdini() {
        // Mostra il loader
        ordiniLoading.classList.remove('d-none');
        ordiniVuoti.classList.add('d-none');
        ordiniError.classList.add('d-none');
        ordiniContainer.style.display = 'none';

        fetch(path + 'api/ordini/display')
            .then(response => {
                if (!response.ok) {
                    throw new Error('Errore nella risposta del server');
                }
                return response.json();
            })
            .then(data => {
                ordini = data;
                ordiniCaricati = true;
                visualizzaOrdini();
            })
            .catch(error => {
                console.error('Errore durante il caricamento degli ordini:', error);
                mostraErrore();
            })
            .finally(() => {
                // Nascondi sempre il loader
                ordiniLoading.classList.add('d-none');
            });
    }

    /**
     * Visualizza gli ordini nella pagina
     */
    function visualizzaOrdini() {
        // Verifica se ci sono ordini
        if (!ordini || ordini.length === 0) {
            ordiniVuoti.classList.remove('d-none');
            return;
        }

        // Ordina gli ordini per data (più recenti prima)
        ordini.sort((a, b) => new Date(b.data) - new Date(a.data));

        // Genera l'HTML per tutti gli ordini
        ordiniContainer.innerHTML = '';

        ordini.forEach(ordine => {
            const ordineElement = creaElementoOrdine(ordine);
            ordiniContainer.appendChild(ordineElement);
        });

        // Mostra il contenitore
        ordiniContainer.style.display = 'block';
    }

    /**
     * Crea l'elemento HTML per un singolo ordine
     */
    function creaElementoOrdine(ordine) {
        const ordineDiv = document.createElement('div');
        ordineDiv.className = 'card mb-3 shadow-sm';

        // Formatta la data
        const dataOrdine = new Date(ordine.data);
        const dataFormattata = dataOrdine.toLocaleDateString('it-IT', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });

        // Determina lo stato (se non presente, usa "Completato" come default)
        const stato = ordine.stato || 'Completato';
        const statoClass = getStatoClass(stato);
        const statoIcon = getStatoIcon(stato);

        // Calcola il totale dell'ordine
        const totaleOrdine = ordine.totale ? parseFloat(ordine.totale).toFixed(2) : 'N/D';

        // Conta il numero di articoli
        const numeroArticoli = ordine.articoli ? ordine.articoli.length : 0;
        const quantitaTotale = ordine.articoli ? ordine.articoli.reduce((sum, articolo) => sum + parseInt(articolo.quantita), 0) : 0;

        ordineDiv.innerHTML = `
            <div class="card-header d-flex justify-content-between align-items-center">
                <div>
                    <h5 class="mb-1">Ordine #${ordine.id}</h5>
                    <small class="text-muted">
                        <i class="bi bi-calendar-event me-1"></i>${dataFormattata}
                    </small>
                </div>
                <div class="text-end">
                    <span class="badge ${statoClass} fs-6">
                        <i class="bi ${statoIcon} me-1"></i>${stato}
                    </span>
                </div>
            </div>
            <div class="card-body">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="d-flex flex-wrap gap-2 mb-2">
                            <small class="text-muted">
                                <i class="bi bi-box me-1"></i>${numeroArticoli} prodott${numeroArticoli !== 1 ? 'i' : 'o'} (${quantitaTotale} totale)
                            </small>
                            ${ordine.da_abbonamento ? `
                                <small class="text-muted">
                                    <i class="bi bi-star me-1"></i>Da abbonamento
                                </small>
                            ` : ''}
                        </div>
                        ${totaleOrdine !== 'N/D' ? `
                            <div class="mt-2">
                                <strong class="text-primary fs-5">€ ${totaleOrdine}</strong>
                            </div>
                        ` : ''}
                        
                        <!-- Anteprima prodotti -->
                        ${ordine.articoli && ordine.articoli.length > 0 ? `
                            <div class="mt-3">
                                <div class="row g-2">
                                    ${ordine.articoli.slice(0, 3).map(articolo => `
                                        <div class="col-auto">
                                            <div class="d-flex align-items-center bg-light rounded p-2" style="max-width: 200px;">
                                                ${articolo.immagine ? `
                                                    <img src="${path}public/image/vini/${articolo.immagine}" 
                                                         alt="${articolo.nome}" 
                                                         class="me-2 rounded" 
                                                         style="width: 25px; height: 25px; object-fit: cover;">
                                                ` : ''}
                                                <div class="flex-grow-1" style="min-width: 0;">
                                                    <div class="fw-medium text-truncate" style="font-size: 0.8rem;">${articolo.nome}</div>
                                                    <small class="text-muted">Qty: ${articolo.quantita}</small>
                                                </div>
                                            </div>
                                        </div>
                                    `).join('')}
                                    ${ordine.articoli.length > 3 ? `
                                        <div class="col-auto">
                                            <div class="d-flex align-items-center justify-content-center bg-secondary text-white rounded p-2" style="width: 40px; height: 40px;">
                                                <small>+${ordine.articoli.length - 3}</small>
                                            </div>
                                        </div>
                                    ` : ''}
                                </div>
                            </div>
                        ` : ''}
                    </div>
                    <div class="col-md-4 text-end">
                        <button class="btn btn-outline-primary btn-sm" onclick="visualizzaDettaglioOrdine(${ordine.id})">
                            <i class="bi bi-eye me-1"></i>Visualizza dettagli
                        </button>
                    </div>
                </div>
            </div>
        `;

        return ordineDiv;
    }

    /**
     * Determina la classe CSS per lo stato dell'ordine
     */
    function getStatoClass(stato) {
        switch (stato?.toLowerCase()) {
            case 'completato':
            case 'consegnato':
                return 'bg-success';
            case 'in elaborazione':
            case 'elaborazione':
                return 'bg-warning text-dark';
            case 'spedito':
            case 'in spedizione':
                return 'bg-info';
            case 'annullato':
            case 'cancellato':
                return 'bg-danger';
            default:
                return 'bg-success'; // Default per ordini completati
        }
    }

    /**
     * Determina l'icona per lo stato dell'ordine
     */
    function getStatoIcon(stato) {
        switch (stato?.toLowerCase()) {
            case 'completato':
            case 'consegnato':
                return 'bi-check-circle-fill';
            case 'in elaborazione':
            case 'elaborazione':
                return 'bi-clock-fill';
            case 'spedito':
            case 'in spedizione':
                return 'bi-truck';
            case 'annullato':
            case 'cancellato':
                return 'bi-x-circle-fill';
            default:
                return 'bi-check-circle-fill'; // Default per ordini completati
        }
    }

    /**
     * Mostra il messaggio di errore
     */
    function mostraErrore() {
        ordiniError.classList.remove('d-none');
        ordiniVuoti.classList.add('d-none');
        ordiniContainer.style.display = 'none';
    }

    /**
     * Mostra messaggio di successo per ordine completato
     */
    function mostraMessaggioSuccesso() {
        const successAlert = document.createElement('div');
        successAlert.className = 'alert alert-success alert-dismissible fade show mb-4';
        successAlert.innerHTML = `
            <div class="d-flex align-items-center">
                <i class="bi bi-check-circle-fill fs-3 me-3 text-success"></i>
                <div>
                    <h5 class="alert-heading mb-1">Ordine completato con successo!</h5>
                    <p class="mb-0">Il tuo ordine è stato elaborato correttamente. Riceverai una conferma via email.</p>
                </div>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        `;

        // Inserisci il messaggio prima del titolo
        const container = document.querySelector('.container');
        const titolo = container.querySelector('h2');
        container.insertBefore(successAlert, titolo);

        // Auto-rimuovi dopo 8 secondi
        setTimeout(() => {
            if (successAlert.parentNode) {
                successAlert.remove();
            }
        }, 8000);
    }

    /**
     * Visualizza i dettagli di un ordine specifico
     * Questa funzione è globale per essere accessibile dagli eventi onclick
     */
    window.visualizzaDettaglioOrdine = function(ordineId) {
        // Trova l'ordine nei dati già caricati
        const ordineDettaglio = ordini.find(o => o.id === ordineId);

        if (!ordineDettaglio) {
            console.error('Ordine non trovato:', ordineId);
            return;
        }

        // Mostra il modal con i dettagli
        const modalContent = `
            <div class="modal fade" id="dettaglioOrdineModal" tabindex="-1" aria-labelledby="dettaglioOrdineModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="dettaglioOrdineModalLabel">
                                <i class="bi bi-receipt me-2"></i>Dettaglio Ordine #${ordineId}
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <!-- Il contenuto verrà inserito qui -->
                        </div>
                    </div>
                </div>
            </div>
        `;

        // Rimuovi eventuali modali esistenti
        const existingModal = document.getElementById('dettaglioOrdineModal');
        if (existingModal) {
            existingModal.remove();
        }

        // Aggiungi il nuovo modale al DOM
        document.body.insertAdjacentHTML('beforeend', modalContent);

        // Mostra il modale
        const modal = new bootstrap.Modal(document.getElementById('dettaglioOrdineModal'));
        modal.show();

        // Mostra i dettagli dell'ordine
        mostraDettaglioOrdine(ordineDettaglio);
    };

    /**
     * Mostra i dettagli dell'ordine nel modal
     */
    function mostraDettaglioOrdine(dettaglioOrdine) {
        const modalBody = document.querySelector('#dettaglioOrdineModal .modal-body');

        // Calcola il totale se non è disponibile
        let totaleCalcolato = 0;
        if (dettaglioOrdine.articoli && dettaglioOrdine.articoli.length > 0) {
            totaleCalcolato = dettaglioOrdine.articoli.reduce((total, articolo) => {
                return total + (parseFloat(articolo.prezzo_vendita) * parseInt(articolo.quantita));
            }, 0);
        }

        const totaleOrdine = dettaglioOrdine.totale ? parseFloat(dettaglioOrdine.totale) : totaleCalcolato;
        const stato = dettaglioOrdine.stato || 'Completato';

        modalBody.innerHTML = `
            <div class="row">
                <div class="col-md-6">
                    <h6 class="border-bottom pb-2 mb-3">Informazioni Ordine</h6>
                    <div class="mb-2">
                        <strong>Stato:</strong> 
                        <span class="badge ${getStatoClass(stato)} ms-2">
                            ${stato}
                        </span>
                    </div>
                    <div class="mb-2">
                        <strong>Data:</strong> ${new Date(dettaglioOrdine.data).toLocaleDateString('it-IT', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        })}
                    </div>
                    <div class="mb-2">
                        <strong>Tipo:</strong> ${dettaglioOrdine.da_abbonamento ? 'Da abbonamento' : 'Ordine normale'}
                    </div>
                </div>
                <div class="col-md-6">
                    <h6 class="border-bottom pb-2 mb-3">Riepilogo</h6>
                    <div class="mb-2">
                        <strong>Totale Ordine:</strong> 
                        <span class="text-primary fs-5">€ ${totaleOrdine.toFixed(2)}</span>
                    </div>
                    <div class="mb-2">
                        <strong>Numero prodotti:</strong> ${dettaglioOrdine.articoli ? dettaglioOrdine.articoli.length : 0}
                    </div>
                    <div class="mb-2">
                        <strong>Quantità totale:</strong> ${dettaglioOrdine.articoli ? dettaglioOrdine.articoli.reduce((sum, a) => sum + parseInt(a.quantita), 0) : 0}
                    </div>
                </div>
            </div>

            ${dettaglioOrdine.articoli && dettaglioOrdine.articoli.length > 0 ? `
                <hr>
                <h6 class="mb-3">
                    <i class="bi bi-box me-2"></i>Prodotti Ordinati
                </h6>
                <div class="table-responsive">
                    <table class="table table-sm table-hover">
                        <thead class="table-light">
                            <tr>
                                <th>Prodotto</th>
                                <th class="text-center">Quantità</th>
                                <th class="text-end">Prezzo Unitario</th>
                                <th class="text-end">Subtotale</th>
                            </tr>
                        </thead>
                        <tbody>
                            ${dettaglioOrdine.articoli.map(articolo => `
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            ${articolo.immagine ? `
                                                <img src="${path}public/image/vini/${articolo.immagine}" 
                                                     alt="${articolo.nome}" 
                                                     class="me-3 rounded" 
                                                     style="width: 50px; height: 50px; object-fit: cover;">
                                            ` : `
                                                <div class="me-3 rounded bg-light d-flex align-items-center justify-content-center" 
                                                     style="width: 50px; height: 50px;">
                                                    <i class="bi bi-image text-muted"></i>
                                                </div>
                                            `}
                                            <div>
                                                <div class="fw-medium">${articolo.nome}</div>
                                                <div class="text-muted small">
                                                    <i class="bi bi-building me-1"></i>${articolo.cantina}
                                                </div>
                                                <div class="text-muted small">
                                                    <i class="bi bi-grape me-1"></i>${articolo.vitigno_nome} - ${articolo.tipologia_nome}
                                                </div>
                                                <div class="text-muted small">
                                                    <i class="bi bi-calendar me-1"></i>Annata: ${articolo.annata}
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-center align-middle">
                                        <span class="badge bg-secondary">${articolo.quantita}</span>
                                    </td>
                                    <td class="text-end align-middle">€ ${parseFloat(articolo.prezzo_vendita).toFixed(2)}</td>
                                    <td class="text-end align-middle">
                                        <strong>€ ${(parseFloat(articolo.prezzo_vendita) * parseInt(articolo.quantita)).toFixed(2)}</strong>
                                    </td>
                                </tr>
                            `).join('')}
                        </tbody>
                        <tfoot class="table-light">
                            <tr>
                                <td colspan="3" class="text-end"><strong>Totale Ordine:</strong></td>
                                <td class="text-end"><strong class="text-primary fs-5">€ ${totaleOrdine.toFixed(2)}</strong></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            ` : `
                <hr>
                <div class="text-center py-3 text-muted">
                    <i class="bi bi-box fs-1"></i>
                    <p class="mt-2">Nessun prodotto trovato per questo ordine</p>
                </div>
            `}
        `;
    }

    /**
     * Mostra messaggio di errore nel modal dei dettagli
     */
    function mostraErroreDettaglio(messaggio) {
        const modalBody = document.querySelector('#dettaglioOrdineModal .modal-body');
        modalBody.innerHTML = `
            <div class="alert alert-danger">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <strong>Errore:</strong> ${messaggio}
            </div>
        `;
    }
});