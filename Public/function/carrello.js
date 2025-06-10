document.addEventListener('DOMContentLoaded', function () {
    fetchElementiCarrello();
});

// Variabili globali per gestire lo stato
let elementiCarrello = [];
let totaleOriginale = 0;
let scontoApplicato = {
    codice: '',
    tipo: '', // 'percentuale' o 'decimale'
    percentuale: 0,
    decimale: 0,
    valore: 0
};

/**
 * Recupera gli elementi del carrello dal server
 */
function fetchElementiCarrello() {
    fetch(path + 'api/carrello/get')
        .then(response => {
            if (!response.ok) {
                throw new Error('Errore nel recupero del carrello: ' + response.status);
            }
            return response.json();
        })
        .then(data => {
            if (Array.isArray(data)) {
                elementiCarrello = data;
                mostraElementiCarrello();
            } else {
                showError('Impossibile caricare gli elementi del carrello');
            }
        })
        .catch(error => {
            console.error('Errore durante il recupero del carrello:', error);
            showError('Impossibile caricare il carrello');
        });
}

/**
 * Cambia la quantità di un prodotto nel carrello
 */
async function cambiaQuantita(productId, operation) {
    const quantitaElement = document.getElementById(`quantita${productId}`);
    if (!quantitaElement) return;

    const currentQuantity = parseInt(quantitaElement.textContent);
    const newQuantity = currentQuantity + operation;

    // Non permettere quantità negative o zero
    if (newQuantity <= 0) return;

    try {
        const formData = new FormData();
        formData.append('product', productId);
        formData.append('quantity', newQuantity);

        const response = await fetch(path + 'api/carrello/update', {
            method: 'POST',
            body: formData
        });

        if (response.ok) {
            const result = await response.json();
            if (result.status === 'success') {
                // Aggiorna la quantità localmente
                const elemento = elementiCarrello.find(item => item.vino.id == productId);
                if (elemento) {
                    elemento.quantita = newQuantity;
                }

                // Aggiorna il DOM
                quantitaElement.textContent = newQuantity;
                aggiornaBottoniQuantita(productId, newQuantity);
                calcolaTotale();
                aggiornaTotaleDOM();
            } else {
                throw new Error(result.message || 'Errore nell\'aggiornamento');
            }
        } else {
            throw new Error('Errore nella comunicazione con il server');
        }
    } catch (error) {
        console.error('Errore:', error);
        alert('Errore nell\'aggiornamento della quantità: ' + error.message);
    }
}

/**
 * Aggiorna lo stato dei bottoni + e - per la quantità
 */
function aggiornaBottoniQuantita(productId, quantita) {
    const decreaseBtn = document.querySelector(`button[onclick*="cambiaQuantita(${productId}, -1)"]`);
    if (decreaseBtn) {
        decreaseBtn.disabled = quantita <= 1;
    }
}

/**
 * Calcola il totale del carrello
 */
function calcolaTotale() {
    totaleOriginale = 0;
    elementiCarrello.forEach(elemento => {
        totaleOriginale += parseFloat(elemento.vino.prezzo_vendita) * elemento.quantita;
    });
}

/**
 * Calcola il valore dello sconto
 */
function calcolaValoreSconto() {
    if (!scontoApplicato.codice) {
        scontoApplicato.valore = 0;
        return;
    }

    if (scontoApplicato.tipo === 'percentuale') {
        scontoApplicato.valore = (totaleOriginale * scontoApplicato.percentuale) / 100;
    } else if (scontoApplicato.tipo === 'decimale') {
        // Lo sconto decimale è un valore fisso
        scontoApplicato.valore = scontoApplicato.decimale;
        // Assicurati che lo sconto non superi il totale
        if (scontoApplicato.valore > totaleOriginale) {
            scontoApplicato.valore = totaleOriginale;
        }
    }
}

/**
 * Aggiorna il totale nel DOM
 */
function aggiornaTotaleDOM() {
    const totaleElement = document.querySelector('#totale-valore');
    const testoPagaElement = document.getElementById('testo-paga');

    if (totaleElement) {
        totaleElement.textContent = `€${totaleOriginale.toFixed(2)}`;
    }

    // Ricalcola il valore dello sconto
    calcolaValoreSconto();

    // Calcola il totale finale considerando eventuali sconti
    const totaleFinaleDaPagare = totaleOriginale - scontoApplicato.valore;

    if (testoPagaElement) {
        testoPagaElement.textContent = `Completa il pagamento di €${totaleFinaleDaPagare.toFixed(2)}`;
    }

    // Aggiorna anche la visualizzazione dello sconto se presente
    if (scontoApplicato.codice) {
        aggiornaScontoDOM();
    }
}

/**
 * Aggiorna la visualizzazione dello sconto nel DOM
 */
function aggiornaScontoDOM() {
    const valoreScontoElem = document.getElementById('valore-sconto');
    const totaleScontatoElem = document.getElementById('totale-scontato');
    const scontoApplicatoDiv = document.getElementById('sconto-applicato');

    if (scontoApplicato.codice && scontoApplicato.valore > 0) {
        const totaleScontato = totaleOriginale - scontoApplicato.valore;

        if (valoreScontoElem) {
            let testoSconto = `€${scontoApplicato.valore.toFixed(2)}`;
            if (scontoApplicato.tipo === 'percentuale') {
                testoSconto += ` (${scontoApplicato.percentuale}%)`;
            } else {
                testoSconto += ` (sconto fisso)`;
            }
            valoreScontoElem.textContent = testoSconto;
        }
        if (totaleScontatoElem) {
            totaleScontatoElem.textContent = `€${totaleScontato.toFixed(2)}`;
        }
        if (scontoApplicatoDiv) {
            scontoApplicatoDiv.classList.remove('d-none');
        }
    }
}

/**
 * Mostra gli elementi del carrello
 */
function mostraElementiCarrello() {
    const displayContainer = document.getElementById('display');
    const pagaContainer = document.getElementById('paga');

    if (!displayContainer) return;

    // Verifica se il carrello è vuoto
    if (elementiCarrello.length === 0) {
        displayContainer.innerHTML = '<div class="alert alert-info">Il tuo carrello è vuoto</div>';
        if (pagaContainer) pagaContainer.innerHTML = '';
        return;
    }

    // Calcola il totale
    calcolaTotale();

    // Genera HTML per gli elementi del carrello
    let cardHtml = '';
    elementiCarrello.forEach(elemento => {
        cardHtml += generaCardElemento(elemento);
    });

    // Genera HTML per la sezione sconto
    const scontoHtml = generaSezioneCodiceSconto();

    // Genera HTML per il totale
    const totaleHtml = generaSezioneTotale();

    // Aggiorna il DOM
    displayContainer.innerHTML = cardHtml + scontoHtml + totaleHtml;

    if (pagaContainer) {
        pagaContainer.innerHTML = generaBottonePagamento();
    }

    // Aggiungi event listener per il codice sconto
    const applicaScontoBtn = document.getElementById('applica-sconto');
    if (applicaScontoBtn) {
        applicaScontoBtn.addEventListener('click', applicaSconto);
    }
}

/**
 * Genera HTML per un elemento del carrello
 */
function generaCardElemento(elemento) {
    const vino = elemento.vino;
    return `
        <div class="card mb-3 shadow-sm border-0" style="background: linear-gradient(135deg, #fff 0%, #f8f9fa 100%);">
            <div class="row g-0 align-items-center p-2">
                <div class="col-md-3">
                    <div class="p-3 text-center">
                        <img src="Public/image/vini/${vino.immagine}" 
                             class="img-fluid rounded" 
                             style="max-width: 80px; max-height: 120px; object-fit: contain;"
                             alt="${vino.nome}">
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="card-body py-3">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="card-title fw-bold mb-0 text-dark">${vino.nome}</h5>
                            <button onclick="eliminaElemento(${vino.id})" 
                                    class="btn btn-danger btn-sm px-2 py-1">
                                Rimuovi
                            </button>
                        </div>
                        <div class="row">
                            <div class="col-sm-8">
                                <p class="card-text mb-1 text-muted">
                                    <small><strong>Tipologia:</strong> ${vino.tipologia}</small>
                                </p>
                                <p class="card-text mb-0">
                                    <span class="fw-bold text-success fs-5">€${parseFloat(vino.prezzo_vendita).toFixed(2)}</span>
                                </p>
                            </div>
                            <div class="col-sm-4 text-end">
                                <p class="card-text mb-2">
                                    <small class="text-muted">Quantità:</small>
                                </p>
                                <div class="d-flex align-items-center justify-content-end">
                                    <button onclick="cambiaQuantita(${vino.id}, -1)" 
                                            class="btn btn-outline-secondary btn-sm me-1" 
                                            ${elemento.quantita <= 1 ? 'disabled' : ''}>-</button>
                                    <span class="mx-2 fw-bold" id="quantita${vino.id}">${elemento.quantita}</span>
                                    <button onclick="cambiaQuantita(${vino.id}, 1)" 
                                            class="btn btn-outline-secondary btn-sm ms-1">+</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `;
}

/**
 * Genera HTML per la sezione codice sconto
 */
function generaSezioneCodiceSconto() {
    return `
        <div class="card mb-3 shadow-sm">
            <div class="card-body">
                <h5 class="card-title">Hai un codice sconto?</h5>
                <div class="input-group mb-3">
                    <input type="text" id="codice-sconto" class="form-control" 
                           placeholder="Inserisci il tuo codice" ${scontoApplicato.codice ? 'disabled' : ''}>
                    <button class="btn btn-outline-secondary" type="button" id="applica-sconto"
                            ${scontoApplicato.codice ? 'disabled' : ''}>Applica</button>
                </div>
                <div id="messaggio-sconto"></div>
            </div>
        </div>
    `;
}

/**
 * Genera HTML per la sezione totale
 */
function generaSezioneTotale() {
    // Ricalcola il valore dello sconto
    calcolaValoreSconto();

    return `
        <div class="card mb-3 shadow-sm">
            <div class="card-body">
                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="card-title mb-0">Totale:</h5>
                    <span class="fw-bold fs-5" id="totale-valore">€${totaleOriginale.toFixed(2)}</span>
                </div>
                <div id="sconto-applicato" class="${scontoApplicato.codice ? '' : 'd-none'}">
                    <div class="d-flex justify-content-between align-items-center text-success">
                        <span>Sconto:</span>
                        <span id="valore-sconto">€${scontoApplicato.valore.toFixed(2)}${
        scontoApplicato.tipo === 'percentuale' ?
            ` (${scontoApplicato.percentuale}%)` :
            ' (sconto fisso)'
    }</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center fw-bold">
                        <span>Totale scontato:</span>
                        <span id="totale-scontato">€${(totaleOriginale - scontoApplicato.valore).toFixed(2)}</span>
                    </div>
                </div>
                <input type="hidden" id="codice-applicato" value="${scontoApplicato.codice}">
            </div>
        </div>
    `;
}

/**
 * Genera HTML per il bottone di pagamento
 */
function generaBottonePagamento() {
    const totaleDaPagare = totaleOriginale - scontoApplicato.valore;

    return `
        <button class="btn btn-success btn-lg w-100 d-flex align-items-center justify-content-center gap-2 shadow rounded-pill fw-bold" 
                onclick="vaiAPagare()">
            <i class="bi bi-credit-card fs-5"></i>
            <span id="testo-paga">Completa il pagamento di €${totaleDaPagare.toFixed(2)}</span>
        </button>
    `;
}

/**
 * Applica il codice sconto
 */
async function applicaSconto() {
    const codiceInput = document.getElementById('codice-sconto');
    const messaggioSconto = document.getElementById('messaggio-sconto');

    if (!codiceInput || !messaggioSconto) return;

    const codice = codiceInput.value.trim();

    if (!codice) {
        messaggioSconto.innerHTML = '<div class="alert alert-warning">Inserisci un codice sconto</div>';
        return;
    }

    messaggioSconto.innerHTML = '<div class="alert alert-info">Verifica codice in corso...</div>';

    try {
        const result = await controllaCodiceSconto(codice);

        // Salva i dati dello sconto
        scontoApplicato.codice = codice;
        scontoApplicato.tipo = result.tipo;

        if (result.tipo === 'percentuale') {
            scontoApplicato.percentuale = result.percentuale;
            scontoApplicato.decimale = 0;
        } else {
            scontoApplicato.decimale = result.decimale;
            scontoApplicato.percentuale = 0;
        }

        // Calcola il valore dello sconto
        calcolaValoreSconto();

        // Aggiorna il DOM
        aggiornaTotaleDOM();

        // Disabilita i controlli
        codiceInput.disabled = true;
        document.getElementById('applica-sconto').disabled = true;
        document.getElementById('codice-applicato').value = codice;

        // Mostra messaggio di successo
        let testoSuccesso = `Codice "${codice}" applicato con successo!`;
        if (result.tipo === 'percentuale') {
            testoSuccesso += ` Hai ricevuto uno sconto del ${result.percentuale}%.`;
        } else {
            testoSuccesso += ` Hai ricevuto uno sconto fisso di €${result.decimale.toFixed(2)}.`;
        }

        messaggioSconto.innerHTML = `
            <div class="alert alert-success">
                ${testoSuccesso}
                <button type="button" class="btn btn-sm btn-link text-danger ms-2" onclick="rimuoviSconto()">
                    Rimuovi sconto
                </button>
            </div>
        `;

    } catch (error) {
        messaggioSconto.innerHTML = `<div class="alert alert-danger">${error.message}</div>`;
    }
}

/**
 * Rimuove lo sconto applicato
 */
function rimuoviSconto() {
    if (!confirm('Sei sicuro di voler rimuovere lo sconto applicato?')) {
        return;
    }

    // Chiama l'API per rimuovere lo sconto dal database
    const formData = new FormData();
    formData.append('codice', scontoApplicato.codice);

    fetch(path + 'api/sconto/rimuovi', {
        method: 'POST',
        body: formData
    })
        .then(response => response.json())
        .then(data => {
            if (data.status === 'success') {
                // Reset dello sconto
                scontoApplicato = {
                    codice: '',
                    tipo: '',
                    percentuale: 0,
                    decimale: 0,
                    valore: 0
                };

                // Reset dei controlli DOM
                const codiceInput = document.getElementById('codice-sconto');
                const applicaBtn = document.getElementById('applica-sconto');
                const messaggioSconto = document.getElementById('messaggio-sconto');
                const scontoApplicatoDiv = document.getElementById('sconto-applicato');
                const codiceApplicatoInput = document.getElementById('codice-applicato');

                if (codiceInput) {
                    codiceInput.disabled = false;
                    codiceInput.value = '';
                }
                if (applicaBtn) applicaBtn.disabled = false;
                if (messaggioSconto) messaggioSconto.innerHTML = '';
                if (scontoApplicatoDiv) scontoApplicatoDiv.classList.add('d-none');
                if (codiceApplicatoInput) codiceApplicatoInput.value = '';

                // Aggiorna i totali
                aggiornaTotaleDOM();
            } else {
                alert('Errore nella rimozione dello sconto: ' + (data.message || 'Errore sconosciuto'));
            }
        })
        .catch(error => {
            console.error('Errore:', error);
            alert('Errore nella rimozione dello sconto');
        });
}

/**
 * Elimina un elemento dal carrello
 */
function eliminaElemento(productId) {
    if (!confirm('Sei sicuro di voler rimuovere questo prodotto dal carrello?')) {
        return;
    }

    fetch(path + 'api/carrello/delete', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: 'product=' + encodeURIComponent(productId),
        credentials: 'include'
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Errore nella rimozione del prodotto');
            }
            return response.json();
        })
        .then(data => {
            if (data.status === 'success') {
                // Rimuovi l'elemento dall'array locale
                elementiCarrello = elementiCarrello.filter(item => item.vino.id != productId);

                // Se il carrello è vuoto, reset dello sconto
                if (elementiCarrello.length === 0) {
                    scontoApplicato = { codice: '', tipo: '', percentuale: 0, decimale: 0, valore: 0 };
                }

                // Aggiorna la visualizzazione
                mostraElementiCarrello();
            } else {
                throw new Error(data.message || 'Errore nella rimozione del prodotto');
            }
        })
        .catch(error => {
            console.error('Errore durante la rimozione del prodotto:', error);
            showError('Impossibile rimuovere il prodotto dal carrello: ' + error.message);
        });
}

/**
 * Vai alla pagina di pagamento
 */
function vaiAPagare() {
    let url = path + 'carrello/checkout';

    if (scontoApplicato.codice) {
        url += '?codice_sconto=' + encodeURIComponent(scontoApplicato.codice);
    }

    location.href = url;
}

/**
 * Mostra un messaggio di errore
 */
function showError(message) {
    const displayContainer = document.getElementById('display');
    const pagaContainer = document.getElementById('paga');

    if (displayContainer) {
        displayContainer.innerHTML = `<div class="alert alert-danger">${message}</div>`;
    }
    if (pagaContainer) {
        pagaContainer.innerHTML = '';
    }
}

/**
 * Funzione per controllare il codice sconto
 */
async function controllaCodiceSconto(codice) {
    return new Promise((resolve, reject) => {
        const formData = new FormData();
        formData.append('codice', codice);

        fetch(path + 'api/sconto/verifica', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'success') {
                    resolve(data);
                    localStorage.setItem('codice_magico', codice)
                } else {
                    reject(new Error(data.message || 'Codice sconto non valido'));
                }
            })
            .catch(error => {
                reject(new Error('Errore nella verifica del codice sconto'));
            });
    });
}

/**
 * Funzione per creare card di vino (mantenuta dal codice originale)
 */
function createWineCard(wine) {
    const col = document.createElement('div');
    col.className = 'col-md-4 col-lg-3 mb-4';

    const description = `${wine.tipologia.nome}, ${wine.annata}`;

    col.innerHTML = `
        <div class="card h-100 shadow-sm border-light">
            <a href="${path}vino/dettaglio/${wine.id}" class="text-decoration-none">
                <div class="bg-light text-center p-3" style="height: 220px;">
                    <img src="${path}Public/image/vini/${wine.immagine}"
                         class="img-fluid h-100"
                         alt="${wine.nome}"
                         style="object-fit: contain;">
                </div>
                <div class="card-body text-center text-white">
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