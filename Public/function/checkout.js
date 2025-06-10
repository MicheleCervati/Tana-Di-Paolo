document.addEventListener('DOMContentLoaded', function() {
    // Recupera l'ID dell'abbonamento dall'URL
    const urlParams = new URLSearchParams(window.location.search);
    const abbonamentoId = urlParams.get('abbonamento');

    // Variabili per i dati del carrello e dell'abbonamento
    let carrello = [];
    let abbonamentoSelezionato = null;
    let codiciSconto = [];
    let totaleProdotti = 0;
    let totaleAbbonamento = 0;
    let totaleProvvisorio = 0;
    let totaleSconti = 0;
    let totaleComplessivo = 0;
    let ordineDisponibile = true; // Flag per controllare se l'ordine può essere completato

    // Funzione per recuperare e verificare il codice sconto dal localStorage
    async function verificaCodiceLocalStorage() {
        const codiceMagico = localStorage.getItem('codice_magico');

        if (codiceMagico) {
            console.log('Codice trovato nel localStorage:', codiceMagico);

            try {
                const result = await controllaCodiceSconto(codiceMagico);

                // Aggiungi il codice alla lista dei codici sconto
                codiciSconto.push({
                    code: codiceMagico,
                    percentuale: result.percentuale || 0,
                    decimale: result.decimale || 0,
                    tipo: result.tipo
                });

                console.log('Codice sconto applicato automaticamente:', codiceMagico);

                // Rimuovi il codice dal localStorage dopo averlo utilizzato
                localStorage.removeItem('codice_magico');

                return true;
            } catch (error) {
                console.error('Errore nella verifica del codice localStorage:', error);
                // Rimuovi il codice non valido dal localStorage
                localStorage.removeItem('codice_magico');
                return false;
            }
        }

        return false;
    }

    // Carica i dati
    Promise.all([
        fetch(path + 'api/carrello/get').then(response => response.json()),
        verificaCodiceLocalStorage(), // Verifica il codice dal localStorage
        abbonamentoId ? fetch(path + 'api/abbonamenti/lista').then(res => res.json()) : Promise.resolve([])
    ])
        .then(async ([datiCarrello, codiceScontoApplicato, listaAbbonamenti]) => {
            carrello = datiCarrello;

            // Se è presente un abbonamentoId, trova l'abbonamento corrispondente
            if (abbonamentoId && listaAbbonamenti.length > 0) {
                abbonamentoSelezionato = listaAbbonamenti.find(a => a.id == abbonamentoId);
            }

            // Visualizza tutti i componenti
            visualizzaCarrello();
            visualizzaAbbonamento();
            visualizzaCodiciSconto();
            calcolaTotali();
            aggiornaStatoPagamento();

            // Se è stato applicato un codice sconto, mostra un messaggio
            if (codiceScontoApplicato) {
                mostraMessaggioScontoApplicato();
            }
        })
        .catch(error => {
            console.error('Si è verificato un errore:', error);

            document.getElementById('cart-loading').classList.add('d-none');
            document.getElementById('cart-error').classList.remove('d-none');

            document.getElementById('abbonamento-loading')?.classList.add('d-none');
            document.getElementById('codici-loading')?.classList.add('d-none');
            document.getElementById('summary-loading')?.classList.add('d-none');
        });

    // Gestisce il form di pagamento
    document.getElementById('payment-form').addEventListener('submit', function(e) {
        e.preventDefault();

        // Controlla di nuovo la disponibilità prima di procedere
        if (!ordineDisponibile) {
            custom_alert('Non è possibile completare l\'ordine a causa di prodotti non disponibili in magazzino.');
            return;
        }

        const payButton = document.getElementById('pay-button');
        payButton.disabled = true;
        payButton.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Elaborazione in corso...';

        // Recupera eventuale parametro 'abbonamento' dall'URL
        const urlParams = new URLSearchParams(window.location.search);
        const abbonamento = urlParams.get('abbonamento');

        const formData = new FormData();
        if (abbonamento) {
            formData.append('abbonamento', abbonamento);
        }

        // Aggiungi i codici sconto applicati
        if (codiciSconto.length > 0) {
            codiciSconto.forEach((codice, index) => {
                formData.append(`codice_sconto_${index}`, codice.code);
            });
            formData.append('numero_codici_sconto', codiciSconto.length);
        }

        // Invia i dati all'API come form-data
        fetch(path + 'api/ordini/process_payment', {
            method: 'POST',
            body: formData
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    location.href = path + 'account/ordini?succ=0';
                } else {
                    custom_alert(data.message || 'Errore durante il pagamento.');
                }
            })
            .catch(error => {
                console.error('Errore:', error);
                custom_alert('Si è verificato un errore durante il pagamento. Riprova.');

                payButton.disabled = false;
                payButton.innerHTML = 'Completa Pagamento';
            });
    });

    // Funzione per mostrare un messaggio di sconto applicato
    function mostraMessaggioScontoApplicato() {
        // Trova un contenitore dove mostrare il messaggio (potresti dover adattare questo)
        const messaggioContainer = document.getElementById('sconto-applicato-message');
        if (messaggioContainer) {
            messaggioContainer.innerHTML = `
                <div class="alert alert-success mb-3">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    <strong>Codice sconto applicato!</strong> Lo sconto è stato applicato automaticamente al tuo ordine.
                </div>
            `;
        }
    }

    // Funzione per controllare il codice sconto (come nel file carrello)
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
                    } else {
                        reject(new Error(data.message || 'Codice sconto non valido'));
                    }
                })
                .catch(error => {
                    reject(new Error('Errore nella verifica del codice sconto'));
                });
        });
    }

    // Funzione per visualizzare i prodotti nel carrello
    function visualizzaCarrello() {
        const cartItemsContainer = document.getElementById('cart-items');
        const cartContent = document.getElementById('cart-content');
        const cartLoading = document.getElementById('cart-loading');
        const cartEmpty = document.getElementById('cart-empty');

        cartLoading.classList.add('d-none');

        // Verifica se il carrello è vuoto
        if (!carrello || carrello.length === 0) {
            cartEmpty.classList.remove('d-none');
            return;
        }

        // Mostra il contenuto del carrello
        cartContent.classList.remove('d-none');
        cartItemsContainer.innerHTML = '';

        // Reset del flag di disponibilità
        ordineDisponibile = true;
        totaleProdotti = 0;

        // Aggiungi ogni prodotto alla lista
        carrello.forEach(item => {
            const vino = item.vino;
            const quantitaRichiesta = item.quantita;
            const quantitaDisponibile = vino.quantita_magazzino;
            const isDisponibile = quantitaRichiesta <= quantitaDisponibile;

            // Se almeno un prodotto non è disponibile, l'ordine non può essere completato
            if (!isDisponibile) {
                ordineDisponibile = false;
            }

            const listItem = document.createElement('li');
            listItem.className = 'list-group-item py-3';

            // Aggiunge classe per evidenziare prodotti non disponibili
            if (!isDisponibile) {
                listItem.classList.add('border-danger', 'bg-body-tertiary');
            }

            listItem.innerHTML = `
                <div class="d-flex align-items-center">
                    <div class="me-3 bg-white d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                        <img src="${path}public/image/vini/${vino.immagine}" alt="${vino.nome}" class="img-fluid rounded" style="max-height: 100%; max-width: 100%; object-fit: contain;">
                    </div>
                    <div class="flex-grow-1">
                        <h6 class="mb-0">${vino.nome}</h6>
                        <div class="small text-muted">
                            ${vino.cantina} | ${vino.annata} | ${vino.tipologia}
                        </div>
                        <div class="d-flex justify-content-between align-items-center mt-1">
                            <div>
                                <span>Quantità: ${quantitaRichiesta}</span>
                                <div class="small ${isDisponibile ? 'text-success' : 'text-danger'}">
                                    Disponibili: ${quantitaDisponibile}
                                    ${!isDisponibile ? '<br><i class="bi bi-exclamation-triangle-fill me-1"></i><strong>Non disponibile</strong>' : ''}
                                </div>
                            </div>
                            <div class="text-end">
                                <span class="fw-bold ${!isDisponibile ? 'text-muted text-decoration-line-through' : ''}">
                                    € ${(quantitaRichiesta * vino.prezzo_vendita).toFixed(2)}
                                </span>
                                ${!isDisponibile ? '<br><small class="text-danger">Prezzo non valido</small>' : ''}
                            </div>
                        </div>
                        ${!isDisponibile ? `
                            <div class="alert alert-danger mt-2 mb-0 py-2">
                                <small><i class="bi bi-exclamation-triangle-fill me-1"></i>
                                Quantità richiesta (${quantitaRichiesta}) superiore alla disponibilità in magazzino (${quantitaDisponibile}).
                                <a href="${path}carrello" class="alert-link">Modifica il carrello</a> per continuare.</small>
                            </div>
                        ` : ''}
                    </div>
                </div>
            `;

            cartItemsContainer.appendChild(listItem);

            // Calcola il totale dei prodotti solo per quelli disponibili
            if (isDisponibile) {
                totaleProdotti += quantitaRichiesta * vino.prezzo_vendita;
            }
        });
    }

    // Funzione per visualizzare l'abbonamento selezionato
    function visualizzaAbbonamento() {
        const abbonamentoLoading = document.getElementById('abbonamento-loading');
        const abbonamentoContent = document.getElementById('abbonamento-content');
        const abbonamentoNone = document.getElementById('abbonamento-none');

        if (!abbonamentoLoading) {
            return;
        }

        abbonamentoLoading.classList.add('d-none');

        // Verifica se c'è un abbonamento selezionato
        if (abbonamentoSelezionato) {
            abbonamentoContent.classList.remove('d-none');

            // Aggiorna i dettagli dell'abbonamento
            document.getElementById('abbonamento-titolo').innerText = abbonamentoSelezionato.titolo;
            document.getElementById('abbonamento-descrizione').innerText = abbonamentoSelezionato.descrizione;
            document.getElementById('abbonamento-prezzo').innerText = '€ ' + parseFloat(abbonamentoSelezionato.prezzo).toFixed(2);

            // Aggiorna il totale dell'abbonamento
            totaleAbbonamento = parseFloat(abbonamentoSelezionato.prezzo);
        } else {
            abbonamentoNone.classList.remove('d-none');
            const abbonamentoRow = document.getElementById('abbonamento-row');
            if (abbonamentoRow) {
                abbonamentoRow.classList.add('d-none');
            }
        }
    }

    // Funzione per calcolare lo sconto di un singolo codice
    function calcolaScontoSingolo(codice, baseImporto) {
        console.log('Calcolo sconto per codice:', codice);
        let totaleSconto = 0;
        let descrizioneSconto = [];
        let importoRimanente = baseImporto;

        // Prima applica lo sconto decimale (fisso)
        if (codice.decimale && parseFloat(codice.decimale) > 0) {
            const scontoDecimale = parseFloat(codice.decimale);
            totaleSconto += scontoDecimale;
            importoRimanente -= scontoDecimale;
            if (importoRimanente < 0) {
                importoRimanente = 0;
            }
            descrizioneSconto.push(`€${scontoDecimale.toFixed(2)} fisso`);
        }

        // Poi applica la percentuale sull'importo rimanente
        if (codice.percentuale && codice.percentuale > 0) {
            const scontoPercentuale = (importoRimanente * codice.percentuale) / 100;
            totaleSconto += scontoPercentuale;
            descrizioneSconto.push(`${codice.percentuale}% sul rimanente`);
        }

        if (totaleSconto < 0) {
            totaleSconto = 0;
        }

        return {
            totale: totaleSconto,
            descrizione: descrizioneSconto.join(' + ')
        };
    }

    // Funzione per visualizzare i codici sconto applicati
    function visualizzaCodiciSconto() {
        const codiciLoading = document.getElementById('codici-loading');
        const codiciEmpty = document.getElementById('codici-empty');
        const codiciContent = document.getElementById('codici-content');
        const codiciList = document.getElementById('codici-list');

        if (codiciLoading) {
            codiciLoading.classList.add('d-none');
        }

        // Verifica se ci sono codici sconto applicati
        if (!codiciSconto || codiciSconto.length === 0) {
            if (codiciEmpty) {
                codiciEmpty.classList.remove('d-none');
            }
            return;
        }

        // Mostra i codici sconto applicati
        if (codiciContent) {
            codiciContent.classList.remove('d-none');
        }

        if (codiciList) {
            codiciList.innerHTML = '';

            let importoBase = totaleProdotti + totaleAbbonamento;

            codiciSconto.forEach(codice => {
                const codiceDiv = document.createElement('div');
                codiceDiv.className = 'border rounded p-3 mb-2 bg-success-subtle border-success';

                // Calcola lo sconto per questo codice
                const scontoInfo = calcolaScontoSingolo(codice, importoBase);

                codiceDiv.innerHTML = `
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <div class="fw-bold text-success">
                                <i class="bi bi-tag-fill me-2"></i>${codice.code}
                            </div>
                            <div class="small text-muted">${scontoInfo.descrizione}</div>
                        </div>
                        <div class="text-end">
                            <div class="fw-bold text-success">
                                -€${scontoInfo.totale.toFixed(2)}
                            </div>
                        </div>
                    </div>
                `;

                codiciList.appendChild(codiceDiv);

                // Aggiorna l'importo base per il prossimo codice (se ci sono più codici)
                importoBase -= scontoInfo.totale;
                if (importoBase < 0) importoBase = 0;
            });
        }
    }

    // Funzione per calcolare e visualizzare i totali
    function calcolaTotali() {
        const summaryLoading = document.getElementById('summary-loading');
        const summaryContent = document.getElementById('summary-content');

        // Calcola il totale provvisorio (prodotti + abbonamento)
        totaleProvvisorio = totaleProdotti + totaleAbbonamento;

        // Calcola il totale sconti applicando tutti i codici in sequenza
        totaleSconti = 0;
        let importoRimanente = totaleProvvisorio;

        codiciSconto.forEach(codice => {
            const scontoInfo = calcolaScontoSingolo(codice, importoRimanente);
            totaleSconti += scontoInfo.totale;
            importoRimanente -= scontoInfo.totale;
            if (importoRimanente < 0) importoRimanente = 0;
        });

        // Calcola il totale complessivo
        totaleComplessivo = totaleProvvisorio - totaleSconti;

        // Assicurati che il totale non sia negativo
        if (totaleComplessivo < 0) {
            totaleComplessivo = 0;
        }

        // Aggiorna i totali nella UI
        const totaleProdottiElement = document.getElementById('totale-prodotti');
        if (totaleProdottiElement) {
            totaleProdottiElement.innerText = '€ ' + totaleProdotti.toFixed(2);
        }

        if (totaleAbbonamento > 0) {
            const totaleAbbonamentoElement = document.getElementById('totale-abbonamento');
            if (totaleAbbonamentoElement) {
                totaleAbbonamentoElement.innerText = '€ ' + totaleAbbonamento.toFixed(2);
            }
        }

        const totaleProvvisorioElement = document.getElementById('totale-provvisorio');
        if (totaleProvvisorioElement) {
            totaleProvvisorioElement.innerText = '€ ' + totaleProvvisorio.toFixed(2);
        }

        // Mostra/nascondi la sezione sconti
        const scontiSection = document.getElementById('sconti-section');
        if (scontiSection) {
            if (totaleSconti > 0) {
                scontiSection.classList.remove('d-none');
                const totaleScontiElement = document.getElementById('totale-sconti');
                if (totaleScontiElement) {
                    totaleScontiElement.innerText = '-€ ' + totaleSconti.toFixed(2);
                }
            } else {
                scontiSection.classList.add('d-none');
            }
        }

        const totaleComplessivoElement = document.getElementById('totale-complessivo');
        if (totaleComplessivoElement) {
            totaleComplessivoElement.innerText = '€ ' + totaleComplessivo.toFixed(2);
        }

        // Nascondi il caricamento e mostra il riepilogo
        if (summaryLoading) {
            summaryLoading.classList.add('d-none');
        }
        if (summaryContent) {
            summaryContent.classList.remove('d-none');
        }
    }

    // Funzione per aggiornare lo stato del pulsante di pagamento
    function aggiornaStatoPagamento() {
        const payButton = document.getElementById('pay-button');

        if (!payButton) return;

        if (!ordineDisponibile) {
            payButton.disabled = true;
            payButton.innerHTML = '<i class="bi bi-exclamation-triangle-fill me-2"></i>Ordine non disponibile';
            payButton.classList.remove('btn-primary');
            payButton.classList.add('btn-danger');

            // Aggiungi un messaggio esplicativo sopra il pulsante
            const existingWarning = document.getElementById('payment-warning');
            if (!existingWarning) {
                const warningDiv = document.createElement('div');
                warningDiv.id = 'payment-warning';
                warningDiv.className = 'alert alert-danger mb-3';
                warningDiv.innerHTML = `
                    <h6 class="alert-heading"><i class="bi bi-exclamation-triangle-fill me-2"></i>Impossibile completare l'ordine</h6>
                    <p class="mb-0">Alcuni prodotti nel carrello non sono disponibili nella quantità richiesta. 
                    Modifica il carrello per procedere con il pagamento.</p>
                `;
                payButton.parentNode.insertBefore(warningDiv, payButton);
            }
        } else {
            payButton.disabled = false;
            payButton.innerHTML = 'Completa Pagamento';
            payButton.classList.remove('btn-danger');
            payButton.classList.add('btn-primary');

            // Rimuovi il messaggio di avviso se presente
            const existingWarning = document.getElementById('payment-warning');
            if (existingWarning) {
                existingWarning.remove();
            }
        }
    }
});