let g_path = '/';
function load(path) {
    g_path = path;
    fetch(path + 'api/user/dettagli')
        .then(response => {
            if (!response.ok) {
                throw new Error('Errore nel caricamento dei dati dell\'utente');
            }
            return response.json();
        })
        .then(userData => {
            // Popola i campi nella scheda Info
            document.getElementById('info-nome').textContent = userData.nome;
            document.getElementById('info-cognome').textContent = userData.cognome;
            document.getElementById('info-email').textContent = userData.email;
            document.getElementById('info-ruolo').textContent = userData.ruolo;
            document.getElementById('info-nome-completo').textContent = userData.nome + ' ' + userData.cognome;
            document.getElementById('info-badge-ruolo').textContent = userData.ruolo;

            // Popola i campi nella scheda Modifica
            document.getElementById('user-id').value = userData.id;
            document.getElementById('nome').value = userData.nome;
            document.getElementById('cognome').value = userData.cognome;
            document.getElementById('email').value = userData.email;
            document.getElementById('ruolo').value = userData.ruolo;
        })
        .catch(error => {
            console.error('Errore:', error);
            custom_alert('Errore nel caricamento dei dati dell\'utente. Riprova più tardi.');
        });
}

document.getElementById('editForm').addEventListener('submit', async function (e) {
    e.preventDefault();

    const formData = new FormData(this);

    const response = await fetch(g_path + 'api/user/update', {
        method: 'POST',
        body: formData,
    });

    const result = await response.json();

    if (result.success) {
        location.reload();
    } else {
        custom_alert(result.message, 'danger');
    }
});