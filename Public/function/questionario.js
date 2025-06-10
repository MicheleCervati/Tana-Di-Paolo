
document.addEventListener('DOMContentLoaded', function() {
    // Configura gli slider
    document.querySelectorAll('input[type="range"]').forEach(slider => {
        const valueDisplay = slider.parentElement.querySelector('.value-display');

        slider.addEventListener('input', function() {
            valueDisplay.textContent = this.value;
            // Aggiorna anche il colore del badge in base al valore
            updateBadgeColor(valueDisplay, this.value, this.max);
        });

        // Imposta il valore iniziale
        valueDisplay.textContent = slider.value;
        updateBadgeColor(valueDisplay, slider.value, slider.max);
    });

    // Configura i pulsanti di salvataggio
    document.getElementById('save-btn-bottom').addEventListener('click', saveQuestionario);

    // Carica automaticamente le risposte salvate all'avvio
    loadQuestionario();

    // Aggiungi un event listener per i pulsanti di chiusura degli alert
    document.querySelectorAll('.btn-close').forEach(btn => {
        btn.addEventListener('click', function() {
            this.closest('.alert').classList.add('d-none');
        });
    });
});

// Funzione per aggiornare il colore dei badge in base al valore
function updateBadgeColor(badge, value, max) {
    const intensity = value / max;

    // Rimuovi tutte le classi di colore precedenti
    badge.classList.remove('bg-primary', 'bg-success', 'bg-warning', 'bg-danger');

    // Assegna una classe di colore in base all'intensità
    if (intensity < 0.25) {
        badge.classList.add('bg-primary');
    } else if (intensity < 0.5) {
        badge.classList.add('bg-success');
    } else if (intensity < 0.75) {
        badge.classList.add('bg-warning');
    } else {
        badge.classList.add('bg-danger');
    }
}

// Funzione per normalizzare i valori degli slider a un range 0-1
function normalizeSliderValue(value, max) {
    return parseFloat(value) / max;
}

// Funzione per caricare le risposte salvate
function loadQuestionario() {

    fetch(PATH + 'api/questionario/load')
        .then(response => {
            if (!response.ok) {
                if (response.status === 401) {
                    showError("Non sei autenticato. Effettua il login per continuare.");
                } else {
                    throw new Error('Errore nel caricamento dei dati');
                }
            }
            return response.json();
        })
        .then(data => {
            if (data) {
                // Imposta i valori degli slider (normalizzando dal formato 0-1)
                if (data.alcol !== undefined) document.getElementById('alcol').value = Math.round(data.alcol * 100);
                if (data.zuccheri_residui !== undefined) document.getElementById('zuccheri_residui').value = Math.round(data.zuccheri_residui * 100);
                if (data.glicerolo !== undefined) document.getElementById('glicerolo').value = Math.round(data.glicerolo * 100);
                if (data.acido_tartarico !== undefined) document.getElementById('acido_tartarico').value = Math.round(data.acido_tartarico * 100);
                if (data.acido_malico !== undefined) document.getElementById('acido_malico').value = Math.round(data.acido_malico * 100);
                if (data.acido_citrico !== undefined) document.getElementById('acido_citrico').value = Math.round(data.acido_citrico * 100);
                if (data.tannini !== undefined) document.getElementById('tannini').value = Math.round(data.tannini * 100);
                if (data.affinamento !== undefined) document.getElementById('affinamento').value = Math.round(data.affinamento * 100);

                // Aggiorna i display degli slider
                document.querySelectorAll('input[type="range"]').forEach(slider => {
                    const valueDisplay = slider.parentElement.querySelector('.value-display');
                    valueDisplay.textContent = slider.value;
                    updateBadgeColor(valueDisplay, slider.value, slider.max);
                });

                // Imposta i radio button
                if (data.passiti !== undefined) {
                    const value = Math.round(data.passiti * 100);
                    const radioBtn = document.querySelector(`input[name="passiti"][value="${value/100}"]`);
                    if (radioBtn) radioBtn.checked = true;
                }

                if (data.maturazione !== undefined) {
                    const value = Math.round(data.maturazione * 100);
                    const radioBtn = document.querySelector(`input[name="annata"][value="${value/100}"]`);
                    if (radioBtn) radioBtn.checked = true;
                }

                // Imposta le tipologie selezionate
                if (data.tipologie && data.tipologie.length > 0) {
                    // Prima deseleziona tutte le tipologie
                    document.querySelectorAll('.tipologia-checkbox').forEach(checkbox => {
                        checkbox.checked = false;
                    });

                    // Poi seleziona quelle presenti nei dati
                    data.tipologie.forEach(tipo => {
                        const checkboxes = document.querySelectorAll('.tipologia-checkbox');
                        checkboxes.forEach(checkbox => {
                            if (checkbox.value === tipo.tipologia) {
                                checkbox.checked = true;
                            }
                        });
                    });
                }
            }
        })
        .catch(error => {
            // Ignora gli errori di "nessun dato" perché l'utente potrebbe non avere ancora completato il questionario
            if (error.message !== 'Errore nel caricamento dei dati') {
                showError(error.message);
            }
        });
}

// Funzione per salvare il questionario
function saveQuestionario() {
    // Verifica se almeno una tipologia è selezionata
    const tipologieSelezionate = document.querySelectorAll('.tipologia-checkbox:checked');
    if (tipologieSelezionate.length === 0) {
        showError("Seleziona almeno una tipologia di vino");
        return;
    }

    // Raccogli i dati del form
    const formData = new FormData();

    // Valori degli slider normalizzati a 0-1
    formData.append('alcol', normalizeSliderValue(document.getElementById('alcol').value, 100));
    formData.append('zuccheri_residui', normalizeSliderValue(document.getElementById('zuccheri_residui').value, 100));
    formData.append('glicerolo', normalizeSliderValue(document.getElementById('glicerolo').value, 100));
    formData.append('acido_tartarico', normalizeSliderValue(document.getElementById('acido_tartarico').value, 100));
    formData.append('acido_malico', normalizeSliderValue(document.getElementById('acido_malico').value, 100));
    formData.append('acido_citrico', normalizeSliderValue(document.getElementById('acido_citrico').value, 100));
    formData.append('tannini', normalizeSliderValue(document.getElementById('tannini').value, 100));
    formData.append('affinamento', normalizeSliderValue(document.getElementById('affinamento').value, 100));

    // Radio buttons
    const passiti = document.querySelector('input[name="passiti"]:checked')?.value || 0;
    formData.append('passiti', passiti);

    const maturazione = document.querySelector('input[name="annata"]:checked')?.value || 0;
    formData.append('maturazione', maturazione);

    // Tipologie selezionate
    tipologieSelezionate.forEach((checkbox, index) => {
        // Supponendo che il valore salvato nel DB sia l'ID della tipologia
        // Usiamo 1, 2, 3, 4 come ID fittizi per Bianco, Passito, Rosso, Spumante
        let tipoId;
        switch(checkbox.value) {
            case 'Bianco': tipoId = 1; break;
            case 'Passito': tipoId = 2; break;
            case 'Rosso': tipoId = 3; break;
            case 'Spumante': tipoId = 4; break;
            default: tipoId = 0;
        }
        formData.append(`tipologie[${index}]`, tipoId);
    });

    // Invia i dati all'API
    fetch(PATH + 'api/questionario/save', {
        method: 'POST',
        body: formData
    })
        .then(response => {
            if (!response.ok) {
                if (response.status === 401) {
                    throw new Error("Non sei autenticato. Effettua il login per continuare.");
                } else {
                    throw new Error('Errore nel salvataggio dei dati');
                }
            }
            return response.json();
        })
        .then(data => {
            if (data.success) {
                showSuccess(data.message);
            } else {
                throw new Error(data.message || 'Errore sconosciuto');
            }
        })
        .catch(error => {
            showError(error.message);
        });
}

// Funzione per mostrare messaggi di successo
function showSuccess(message) {
    const successElement = document.getElementById('success-message');
    successElement.textContent = message;
    successElement.classList.remove('d-none');

    // Nascondi eventuali messaggi di errore
    document.getElementById('error-message').classList.add('d-none');

    // Scrolla all'inizio per mostrare il messaggio
    window.scrollTo({ top: 0, behavior: 'smooth' });

    // Nascondi il messaggio dopo 5 secondi
    setTimeout(() => {
        successElement.classList.add('d-none');
    }, 5000);
}

// Funzione per mostrare messaggi di errore
function showError(message) {
    const errorElement = document.getElementById('error-message');
    const errorText = document.getElementById('error-text');
    errorText.textContent = message;
    errorElement.classList.remove('d-none');

    // Nascondi eventuali messaggi di successo
    document.getElementById('success-message').classList.add('d-none');

    // Scrolla all'inizio per mostrare il messaggio
    window.scrollTo({ top: 0, behavior: 'smooth' });

    // Nascondi il messaggio dopo 5 secondi
    setTimeout(() => {
        errorElement.classList.add('d-none');
    }, 5000);
}