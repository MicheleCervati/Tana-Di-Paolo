/**
 * Riepilogo Preferenze Vini
 * File JavaScript per gestire la visualizzazione del riepilogo delle preferenze vini
 */

document.addEventListener('DOMContentLoaded', function() {
    // Elementi DOM
    const summaryContainer = document.getElementById('summary-container');
    const errorContainer = document.getElementById('error-container');
    const loadingContainer = document.getElementById('loading-container');

    // Mappa per i valori delle preferenze
    const preferenceMappings = {
        // Tipo di vino
        wine_type: {
            red: "Vino rosso",
            white: "Vino bianco",
            rose: "Vino rosato",
            sparkling: "Vino spumante",
            dessert: "Vino da dessert",
            "no-preference": "Nessuna preferenza"
        },
        // Intensità del gusto
        taste_intensity: {
            light: "Leggero e delicato",
            medium: "Medio",
            full: "Corposo e intenso",
            any: "Qualsiasi intensità"
        },
        // Aromi
        aromas: {
            fruity: "Fruttato",
            floral: "Floreale",
            herbal: "Erbaceo/Speziato",
            mineral: "Minerale/Terroso",
            oak: "Legno/Vaniglia",
            nutty: "Note di frutta secca"
        },
        // Abbinamento cibo
        food_pairing: {
            meat: "Carni rosse",
            poultry: "Carni bianche",
            fish: "Pesce e frutti di mare",
            vegetarian: "Piatti vegetariani",
            dessert: "Dessert",
            cheese: "Formaggi",
            aperitif: "Aperitivo"
        },
        // Concentrazione
        concentration: {
            light: "Vini leggeri e freschi",
            medium: "Vini di media struttura",
            concentrated: "Vini concentrati e strutturati",
            "no-preference": "Nessuna preferenza"
        },
        // Maturazione
        maturation: {
            young: "Vini giovani e freschi",
            balanced: "Vini con qualche anno di maturazione",
            aged: "Vini maturi e invecchiati",
            "no-preference": "Nessuna preferenza"
        },
        // Budget
        budget: {
            budget: "Fino a 15€",
            mid: "Tra 15€ e 30€",
            premium: "Oltre 30€",
            "no-preference": "Nessuna preferenza di prezzo"
        }
    };

    // Funzione per convertire il valore numerico in descrizione
    function getSliderDescription(value) {
        if (value <= 2) return "Molto basso";
        if (value <= 4) return "Basso";
        if (value <= 6) return "Medio";
        if (value <= 8) return "Alto";
        return "Molto alto";
    }

    // Carica i dati delle preferenze dell'utente
    function loadUserPreferences() {
        // Mostra il caricamento
        loadingContainer.classList.remove('d-none');
        summaryContainer.classList.add('d-none');
        errorContainer.classList.add('d-none');

        // Simula un caricamento per una migliore UX
        setTimeout(() => {
            fetch(`${path}api/user/dettagli`)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Errore nel caricamento del profilo utente');
                    }
                    return response.json();
                })
                .then(data => {
                    loadingContainer.classList.add('d-none');

                    if (data.preferenze) {
                        displayPreferences(data.preferenze);
                        summaryContainer.classList.remove('d-none');
                    } else {
                        // Se non ci sono preferenze, mostra un messaggio
                        errorContainer.innerHTML = `
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle-fill me-2"></i>
                            Non hai ancora impostato le tue preferenze. 
                            <a href="${path}questionario" class="alert-link">Compilare il questionario</a> per ricevere consigli personalizzati.
                        </div>`;
                        errorContainer.classList.remove('d-none');
                    }
                })
                .catch(error => {
                    loadingContainer.classList.add('d-none');
                    errorContainer.innerHTML = `
                    <div class="alert alert-danger">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        Si è verificato un errore durante il caricamento delle preferenze. Riprova più tardi.
                    </div>`;
                    errorContainer.classList.remove('d-none');
                    console.error('Errore:', error);
                });
        }, 800);
    }

    // Visualizza le preferenze dell'utente
    function displayPreferences(preferences) {
        // Sezione tipi di vino
        let wineTypesHTML = '';
        if (preferences.wine_type && preferences.wine_type.length > 0) {
            const wineTypes = Array.isArray(preferences.wine_type) ? preferences.wine_type : [preferences.wine_type];
            wineTypesHTML = wineTypes.map(type => {
                const label = preferenceMappings.wine_type[type] || type;
                let colorClass = '';

                switch(type) {
                    case 'red': colorClass = 'bg-danger'; break;
                    case 'white': colorClass = 'bg-warning'; break;
                    case 'rose': colorClass = 'bg-pink'; break;
                    case 'sparkling': colorClass = 'bg-amber'; break;
                }

                return `<div class="preference-tag">
                    ${colorClass ? `<span class="color-dot ${colorClass} me-1"></span>` : ''}
                    ${label}
                </div>`;
            }).join('');
        } else {
            wineTypesHTML = `<div class="text-muted">${questionnaire_texts.summary.sections.wine_types.none}</div>`;
        }
        document.getElementById('wine-types').innerHTML = wineTypesHTML;

        // Intensità del gusto
        if (preferences.taste_intensity) {
            document.getElementById('taste-intensity').textContent =
                preferenceMappings.taste_intensity[preferences.taste_intensity] || preferences.taste_intensity;
        }

        // Aromi preferiti
        let aromasHTML = '';
        if (preferences.aromas && preferences.aromas.length > 0) {
            const aromas = Array.isArray(preferences.aromas) ? preferences.aromas : [preferences.aromas];
            aromasHTML = aromas.map(aroma => {
                const label = preferenceMappings.aromas[aroma] || aroma;
                return `<div class="preference-tag">${label}</div>`;
            }).join('');
        } else {
            aromasHTML = `<div class="text-muted">${questionnaire_texts.summary.sections.aromas.none}</div>`;
        }
        document.getElementById('aromas-preferences').innerHTML = aromasHTML;

        // Abbinamento cibo
        if (preferences.food_pairing) {
            document.getElementById('food-pairing').textContent =
                preferenceMappings.food_pairing[preferences.food_pairing] || preferences.food_pairing;
        }

        // Caratteristiche sensoriali (slider)
        const sensorySliders = [
            { id: 'heat_intensity', element: 'heat-intensity' },
            { id: 'dryness', element: 'dryness-level' },
            { id: 'smoothness', element: 'smoothness-level' },
            { id: 'freshness', element: 'freshness-level' }
        ];

        sensorySliders.forEach(slider => {
            if (preferences[slider.id] !== undefined) {
                const value = parseInt(preferences[slider.id]);
                const description = getSliderDescription(value);
                const progressElement = document.getElementById(slider.element);

                if (progressElement) {
                    // Imposta il valore
                    progressElement.style.width = `${value * 10}%`;
                    progressElement.setAttribute('aria-valuenow', value);

                    // Imposta la classe di colore in base al valore
                    progressElement.className = 'progress-bar';
                    if (value <= 3) {
                        progressElement.classList.add('bg-info');
                    } else if (value <= 7) {
                        progressElement.classList.add('bg-primary');
                    } else {
                        progressElement.classList.add('bg-success');
                    }

                    // Imposta la descrizione
                    progressElement.textContent = description;
                }
            }
        });

        // Caratteristiche avanzate (slider)
        const advancedSliders = [
            { id: 'fruity_push', element: 'fruity-level' },
            { id: 'citrus_touch', element: 'citrus-level' },
            { id: 'persistence', element: 'persistence-level' },
            { id: 'wood_aging', element: 'wood-level' }
        ];

        advancedSliders.forEach(slider => {
            if (preferences[slider.id] !== undefined) {
                const value = parseInt(preferences[slider.id]);
                const description = getSliderDescription(value);
                const progressElement = document.getElementById(slider.element);

                if (progressElement) {
                    // Imposta il valore
                    progressElement.style.width = `${value * 10}%`;
                    progressElement.setAttribute('aria-valuenow', value);

                    // Imposta la classe di colore in base al valore
                    progressElement.className = 'progress-bar';
                    if (value <= 3) {
                        progressElement.classList.add('bg-info');
                    } else if (value <= 7) {
                        progressElement.classList.add('bg-primary');
                    } else {
                        progressElement.classList.add('bg-success');
                    }

                    // Imposta la descrizione
                    progressElement.textContent = description;
                }
            }
        });

        // Preferenze aggiuntive
        const additionalPrefs = [
            { id: 'concentration', element: 'concentration-level' },
            { id: 'maturation', element: 'maturation-level' },
            { id: 'budget', element: 'budget-level' }
        ];

        additionalPrefs.forEach(pref => {
            if (preferences[pref.id]) {
                const element = document.getElementById(pref.element);
                if (element) {
                    element.textContent = preferenceMappings[pref.id][preferences[pref.id]] || preferences[pref.id];
                }
            }
        });

        // Inizializza i tooltip
        const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        // Inizializza i chart radar se presenti
        if (typeof Chart !== 'undefined' && document.getElementById('wine-profile-chart')) {
            initRadarChart(preferences);
        }
    }

    // Inizializza il grafico radar per il profilo del vino
    function initRadarChart(preferences) {
        const ctx = document.getElementById('wine-profile-chart').getContext('2d');

        // Ottieni i valori per il grafico dai dati delle preferenze
        const dryness = preferences.dryness ? parseInt(preferences.dryness) : 5;
        const body = preferences.heat_intensity ? parseInt(preferences.heat_intensity) : 5;
        const acidity = preferences.freshness ? parseInt(preferences.freshness) : 5;
        const fruitiness = preferences.fruity_push ? parseInt(preferences.fruity_push) : 5;
        const tannin = preferences.smoothness ? 10 - parseInt(preferences.smoothness) : 5; // Invertiamo perché smoothness è l'opposto di tannino

        // Creiamo il grafico radar
        new Chart(ctx, {
            type: 'radar',
            data: {
                labels: ['Secchezza', 'Corpo', 'Acidità', 'Fruttato', 'Tannino'],
                datasets: [{
                    label: 'Il tuo profilo vino',
                    data: [dryness, body, acidity, fruitiness, tannin],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgb(54, 162, 235)',
                    pointBackgroundColor: 'rgb(54, 162, 235)',
                    pointBorderColor: '#fff',
                    pointHoverBackgroundColor: '#fff',
                    pointHoverBorderColor: 'rgb(54, 162, 235)'
                }]
            },
            options: {
                elements: {
                    line: {
                        borderWidth: 3
                    }
                },
                scales: {
                    r: {
                        angleLines: {
                            display: true
                        },
                        suggestedMin: 0,
                        suggestedMax: 10,
                        ticks: {
                            beginAtZero: true,
                            callback: function(value, index, values) {
                                if (value % 2 === 0) return value;
                                return '';
                            }
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                let value = context.raw;
                                let description = getSliderDescription(value);
                                return `${context.label}: ${value}/10 (${description})`;
                            }
                        }
                    }
                }
            }
        });
    }

    // Inizializzazione
    loadUserPreferences();

    // Event listener per il pulsante di modifica preferenze
    const editButton = document.getElementById('edit-preferences');
    if (editButton) {
        editButton.addEventListener('click', function() {
            window.location.href = `${path}questionario`;
        });
    }

    // Event listener per il pulsante di visualizzazione consigli
    const recommendationsButton = document.getElementById('view-recommendations');
    if (recommendationsButton) {
        recommendationsButton.addEventListener('click', function() {
            window.location.href = `${path}catalogo?filtered=true`;
        });
    }
});