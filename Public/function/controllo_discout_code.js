async function controllaCodiceSconto(codice) {
    try {
        const response = await fetch(path + 'api/codici_sconto/get');
        if (!response.ok) {
            throw new Error('Errore nel recupero dei codici sconto: ' + response.status);
        }

        const data = await response.json();
        if (Array.isArray(data)) {
            const codiceTrovato = data.find(item => item.code.toLowerCase() === codice.toLowerCase());

            if (codiceTrovato) {

                localStorage.setItem("codice_sconto", codice);
                return codiceTrovato.percentuale || 0;
            } else {
                throw new Error('Codice sconto non valido');
            }
        } else {
            throw new Error('Impossibile caricare i codici sconto');
        }
    } catch (error) {
        console.error('Errore durante il recupero dei codici sconto:', error);
        throw error;
    }
}