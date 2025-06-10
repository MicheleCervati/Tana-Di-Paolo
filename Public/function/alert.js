function custom_alert(message, type) {
    const alert = document.getElementById('alert');
    const alertMessage = document.getElementById('alertMessage');

    alertMessage.textContent = message;
    alert.style.display = 'block';
    alert.classList.add('show');
    alert.classList.remove('alert-success', 'alert-danger');
    alert.classList.add(type === 'success' ? 'alert-success' : 'alert-danger');

    // Nascondi automaticamente dopo 5 secondi
    setTimeout(() => {
        alert.classList.remove('show');
        setTimeout(() => {
            alert.style.display = 'none';
        }, 150);
    }, 5000);
}