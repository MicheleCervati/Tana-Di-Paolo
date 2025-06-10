document.addEventListener('DOMContentLoaded', function() {
    let userData = null;
    let subscriptionData = [];

    // Funzione per mostrare alert
    function showAlert(message, type = 'info') {
        const alertContainer = document.getElementById('alertContainer');
        const iconMap = {
            'success': 'bi-check-circle-fill',
            'danger': 'bi-exclamation-triangle-fill',
            'warning': 'bi-exclamation-triangle-fill',
            'info': 'bi-info-circle-fill'
        };

        const alertHtml = `
                    <div class="alert alert-${type} alert-dismissible fade show border-0 shadow-sm" role="alert">
                        <i class="${iconMap[type] || 'bi-info-circle-fill'} me-2"></i>
                        ${message}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                `;
        alertContainer.innerHTML = alertHtml;

        // Auto dismiss dopo 5 secondi
        setTimeout(() => {
            const alert = alertContainer.querySelector('.alert');
            if (alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            }
        }, 5000);
    }

    // Funzione per caricare i dati degli abbonamenti
    async function loadSubscriptions() {
        try {
            const response = await fetch(`${path}api/abbonamenti/lista`);
            if (!response.ok) {
                throw new Error('Errore nel caricamento degli abbonamenti');
            }
            subscriptionData = await response.json();
        } catch (error) {
            console.error('Errore caricamento abbonamenti:', error);
        }
    }

    // Funzione per verificare i dettagli utente
    async function checkUserDetails() {
        try {
            // Carica prima i dati degli abbonamenti
            await loadSubscriptions();

            const response = await fetch(`${path}api/user/dettagli`);

            if (!response.ok) {
                throw new Error('Errore nel recupero dei dati utente');
            }

            userData = await response.json();
            updateSubscriptionDisplay();
            checkSubscriptionAccess();

        } catch (error) {
            console.error('Errore:', error);
            showAlert('Errore nel caricamento dei dati utente: ' + error.message, 'danger');
            document.getElementById('loadingUser').classList.add('d-none');
        }
    }

    // Funzione per ottenere il titolo dell'abbonamento dall'API
    function getSubscriptionTitle(subscriptionId) {
        const subscription = subscriptionData.find(sub => sub.id === subscriptionId);
        return subscription ? subscription.titolo : 'Abbonamento Sconosciuto';
    }

    // Funzione per aggiornare la visualizzazione dell'abbonamento
    function updateSubscriptionDisplay() {
        const subscriptionBadge = document.getElementById('subscriptionBadge');
        const subscriptionLabel = document.getElementById('subscriptionLabel');
        const subscriptionText = document.getElementById('subscriptionText');

        if (userData && userData.abbonamento) {
            const subscriptionInfo = getSubscriptionInfo(userData.abbonamento);
            const subscriptionTitle = getSubscriptionTitle(userData.abbonamento);

            subscriptionLabel.className = `badge fs-6 px-3 py-2 ${subscriptionInfo.class}`;
            subscriptionText.textContent = subscriptionTitle;
            subscriptionBadge.classList.remove('d-none');
        }
    }

    // Funzione per ottenere le informazioni dell'abbonamento (colori)
    function getSubscriptionInfo(level) {
        const subscriptions = {
            1: { class: 'bg-secondary text-white' },
            2: { class: 'bg-primary text-white' },
            3: { class: 'bg-success text-white' }
        };
        return subscriptions[level] || { class: 'bg-light text-dark' };
    }

    // Funzione per controllare l'accesso all'algoritmo
    function checkSubscriptionAccess() {
        document.getElementById('loadingUser').classList.add('d-none');

        // Assumendo che l'accesso all'algoritmo richieda abbonamento livello 2 o superiore
        if (userData.abbonamento >= 1) {
            document.getElementById('algorithmSection').classList.remove('d-none');
            enableAlgorithmFeatures();
        } else {
            // Aggiorna il testo del messaggio di accesso negato con il nome corretto
            const requiredSubscription = getSubscriptionTitle(1); // Premium
            document.getElementById('requiredSubscription').textContent = requiredSubscription;
            document.getElementById('accessDenied').classList.remove('d-none');
        }
    }

    // Funzione per abilitare le funzionalità dell'algoritmo
    function enableAlgorithmFeatures() {
        const simulateBtn = document.getElementById('simulateBtn');
        const runBtn = document.getElementById('runBtn');

        simulateBtn.addEventListener('click', runSimulation);
        runBtn.addEventListener('click', runAlgorithm);
    }

    // Funzione per eseguire la simulazione
    async function runSimulation() {
        const btn = document.getElementById('simulateBtn');
        const originalText = btn.innerHTML;

        try {
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Simulazione in corso...';

            const response = await fetch(`${path}api/algoritmo/simulate`);

            const results = await response.json();

            if (results.error) {
                throw new Error(results.message || 'Errore sconosciuto durante la simulazione');
            }
            displaySimulationResults(results);
            showAlert('Simulazione completata con successo!', 'success');

            // Abilita il pulsante di esecuzione dopo una simulazione riuscita
            document.getElementById('runBtn').disabled = false;

        } catch (error) {
            console.error('Errore simulazione:', error);
            showAlert('Errore durante la simulazione: ' + error.message, 'danger');
        } finally {
            btn.disabled = false;
            btn.innerHTML = originalText;
        }
    }

    // Funzione per mostrare i risultati della simulazione
    function displaySimulationResults(results) {
        const container = document.getElementById('simulationData');
        const resultsCount = document.getElementById('resultsCount');

        if (!results || results.length === 0) {
            container.innerHTML = `
                        <div class="text-center py-5">
                            <i class="bi bi-search text-muted" style="font-size: 3rem;"></i>
                            <h5 class="text-muted mt-3">Nessun risultato trovato</h5>
                            <p class="text-muted">L'algoritmo non ha trovato raccomandazioni per i criteri attuali.</p>
                        </div>
                    `;
            resultsCount.innerHTML = '<i class="bi bi-list-ul me-1"></i>0 risultati';
            document.getElementById('simulationResults').classList.remove('d-none');
            return;
        }

        // Aggiorna il contatore
        resultsCount.innerHTML = `<i class="bi bi-list-ul me-1"></i>${results.length} risultati`;

        let html = `<div class="row g-4">`;

        results.forEach((result, index) => {
            const vino = result.vino;
            const precisione = (result.precisione * 100).toFixed(1);
            const imageUrl = vino.immagine ? `${path}public/image/vini/${vino.immagine}` : `${path}public/images/vini/default.jpg`;

            // Determina il colore della progress bar basato sulla precisione
            let progressClass = 'bg-danger';
            if (precisione >= 80) progressClass = 'bg-success';
            else if (precisione >= 60) progressClass = 'bg-warning';
            else if (precisione >= 40) progressClass = 'bg-info';

            // Determina il badge per la quantità
            let quantityBadge = 'bg-danger';
            if (vino.quantita_magazzino > 50) quantityBadge = 'bg-success';
            else if (vino.quantita_magazzino > 10) quantityBadge = 'bg-warning text-dark';

            html += `
                        <div class="col-lg-6 col-xl-4">
                            <div class="card h-100 border-0 shadow-sm position-relative" style="transition: transform 0.2s; cursor: pointer;" 
                                 onmouseover="this.style.transform='translateY(-5px)'" 
                                 onmouseout="this.style.transform='translateY(0)'">
                                
                                <!-- Badge ranking nell'angolo -->
                                <div class="position-absolute top-0 start-0 m-2" style="z-index: 1;">
                                    <span class="badge bg-primary rounded-pill">#${index + 1}</span>
                                </div>
                                
                                <div class="row g-0 h-100">
                                    <!-- Contenitore immagine con dimensioni fisse e sfondo bianco -->
                                    <div class="col-5">
                                        <div class="bg-white rounded-start d-flex align-items-center justify-content-center position-relative" 
                                             style="height: 200px; overflow: hidden;">
                                            <img src="${imageUrl}" 
                                                 class="img-fluid" 
                                                 alt="${vino.nome}" 
                                                 style="max-height: 180px; max-width: 100%; object-fit: contain;">
                                            
                                            <!-- Badge tipologia sovrapposto -->
                                            <div class="position-absolute bottom-0 end-0 m-2">
                                                <span class="badge ${vino.tipologia === 'Bianco' ? 'bg-light text-dark border' : vino.tipologia === 'Rosso' ? 'bg-dark' : 'bg-info'}" 
                                                      style="font-size: 0.7rem;">
                                                    <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i>
                                                    ${vino.tipologia}
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- Contenuto -->
                                    <div class="col-7">
                                        <div class="card-body p-3 d-flex flex-column h-100">
                                            <div class="flex-grow-1">
                                                <h6 class="card-title mb-2 fw-bold" style="font-size: 0.95rem; line-height: 1.2;">
                                                    ${vino.nome}
                                                </h6>
                                                <div class="mb-2">
                                                    <p class="card-text mb-1" style="font-size: 0.8rem;">
                                                        <i class="bi bi-building me-1 text-muted"></i>
                                                        <strong>${vino.cantina}</strong>
                                                    </p>
                                                    <p class="card-text mb-2" style="font-size: 0.75rem;">
                                                        <i class="bi bi-grape me-1 text-muted"></i>
                                                        <span class="text-muted">${vino.vitigno}</span>
                                                        <span class="ms-2">
                                                            <i class="bi bi-calendar3 me-1 text-muted"></i>
                                                            ${vino.annata}
                                                        </span>
                                                    </p>
                                                </div>
                                                
                                                <!-- Barra precisione -->
                                                <div class="mb-3">
                                                    <div class="d-flex justify-content-between align-items-center mb-1">
                                                        <small class="text-muted fw-bold">
                                                            <i class="bi bi-target me-1"></i>Precisione
                                                        </small>
                                                        <small class="fw-bold">${precisione}%</small>
                                                    </div>
                                                    <div class="progress" style="height: 8px;">
                                                        <div class="progress-bar ${progressClass}" 
                                                             role="progressbar" 
                                                             style="width: ${precisione}%;"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <!-- Footer card -->
                                            <div class="mt-auto">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div class="d-flex flex-column">
                                                        <span class="fw-bold text-success h6 mb-0">
                                                            <i class="bi bi-currency-euro"></i>${parseFloat(vino.prezzo_vendita).toFixed(2)}
                                                        </span>
                                                    </div>
                                                    <div class="text-end">
                                                        <span class="badge ${quantityBadge}" style="font-size: 0.7rem;">
                                                            <i class="bi bi-box me-1"></i>${vino.quantita_magazzino} pz
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    `;
        });

        html += `</div>`;

        container.innerHTML = html;
        document.getElementById('simulationResults').classList.remove('d-none');

        // Smooth scroll ai risultati
        setTimeout(() => {
            document.getElementById('simulationResults').scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }, 100);
    }

    // Funzione per eseguire l'algoritmo
    async function runAlgorithm() {
        const btn = document.getElementById('runBtn');
        const originalText = btn.innerHTML;

        try {
            btn.disabled = true;
            btn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Esecuzione in corso...';

            const response = await fetch(`${path}api/algoritmo/run`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                }
            });

            const result = await response.json();
            if (result.error) {
                throw new Error(result.message || 'Errore sconosciuto durante la simulazione');

            }
            showAlert('Algoritmo eseguito con successo! Reindirizzamento agli ordini...', 'success');

            // Reindirizza alla pagina ordini dopo 2 secondi
            setTimeout(() => {
                window.location.href = `${path}account/ordini`;
            }, 2000);

        } catch (error) {
            console.error('Errore esecuzione:', error);
            showAlert('Errore durante l\'esecuzione dell\'algoritmo: ' + error.message, 'danger');
            btn.disabled = false;
            btn.innerHTML = originalText;
        }
    }

    // Avvia il controllo dell'utente al caricamento della pagina
    checkUserDetails();
});