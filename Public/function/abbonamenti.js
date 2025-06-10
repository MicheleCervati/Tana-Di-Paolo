document.addEventListener('DOMContentLoaded', function() {
    // Carica i dettagli dell'utente corrente
    let utenteCorrente = null;
    let abbonamentoAttualeId = null;

    // Carica gli abbonamenti e i dettagli utente in parallelo
    Promise.all([
        fetch(path + 'api/abbonamenti/lista'),
        fetch(path + 'api/user/dettagli')
    ])
        .then(responses => {
            // Controlla se entrambe le richieste sono andate a buon fine
            if (!responses[0].ok) {
                throw new Error('Errore nel caricamento degli abbonamenti');
            }

            // Elabora i risultati in base all'esito di entrambe le richieste
            return Promise.all([
                responses[0].json(),
                responses[1].ok ? responses[1].json() : { error: true }
            ]);
        })
        .then(data => {
            const [abbonamenti, utente] = data;

            // Verifica se l'utente è autenticato e ha già un abbonamento
            if (!utente.error) {
                utenteCorrente = utente;
                abbonamentoAttualeId = utente.abbonamento ? parseInt(utente.abbonamento) : null;
            }

            // Visualizza gli abbonamenti
            visualizzaAbbonamenti(abbonamenti);
        })
        .catch(error => {
            console.error('Si è verificato un errore:', error);
            document.getElementById('abbonamenti-container').innerHTML = `
            <div class="col-12">
                <div class="alert alert-danger" role="alert">
                    Si è verificato un errore nel caricamento degli abbonamenti. Riprova più tardi.
                </div>
            </div>
        `;
        });

    function visualizzaAbbonamenti(abbonamenti) {
        const container = document.getElementById('abbonamenti-container');
        container.innerHTML = '';

        abbonamenti.forEach(abbonamento => {
            const isDisabled = abbonamentoAttualeId !== null && abbonamento.id <= abbonamentoAttualeId;
            const isActive = abbonamentoAttualeId === abbonamento.id;

            const card = document.createElement('div');
            card.className = 'col-md-4 mb-4';

            card.innerHTML = `
                <div class="card h-100 ${isActive ? 'border-success' : ''}">
                    <div class="card-header ${isActive ? 'bg-success text-white' : ''}">
                        ${isActive ? '<span class="badge bg-white text-success me-2">Attivo</span>' : ''}
                        <h5 class="card-title mb-0">${abbonamento.titolo}</h5>
                    </div>
                    <div class="card-body">
                        <p class="card-text">${abbonamento.descrizione}</p>
                    </div>
                    <div class="card-footer d-flex justify-content-between align-items-center">
                        <h4 class="mb-0">${parseFloat(abbonamento.prezzo).toFixed(2)} €<small class="text-muted">/mese</small></h4>
                        <button 
                            class="btn ${isActive ? 'btn-success' : 'btn-primary'}" 
                            ${isDisabled ? 'disabled' : ''}
                            onclick="acquistaAbbonamento(${abbonamento.id})"
                        >
                            ${isActive ? 'Abbonamento Attivo' : (isDisabled ? 'Non Disponibile' : 'Acquista')}
                        </button>
                    </div>
                </div>
            `;

            container.appendChild(card);
        });

        // Se l'utente non è autenticato, mostra un messaggio
        if (!utenteCorrente || utenteCorrente.error) {
            const alertDiv = document.createElement('div');
            alertDiv.className = 'col-12 mt-3';
            alertDiv.innerHTML = `
                <div class="alert alert-info" role="alert">
                    <i class="bi bi-info-circle me-2"></i> Per acquistare un abbonamento, devi prima <a href="${path}account/login" class="alert-link">accedere</a> o <a href="${path}account/register" class="alert-link">registrarti</a>.
                </div>
            `;
            container.appendChild(alertDiv);
        }
    }
});

// Funzione globale per l'acquisto dell'abbonamento
function acquistaAbbonamento(id) {
    // Reindirizza alla pagina di checkout con l'ID dell'abbonamento selezionato
    window.location.href = path + 'carrello/checkout?abbonamento=' + id;
}