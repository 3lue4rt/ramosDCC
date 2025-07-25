document.addEventListener('DOMContentLoaded', function() {
    document.querySelectorAll('.delete-opinion-btn').forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            const opinionId = this.getAttribute('data-opinion-id');
            const deleteUrl = this.getAttribute('data-delete-url');
            
            if (confirm('¿Estás seguro que deseas eliminar esta opinión? Esta acción no se puede deshacer.')) {
                // Add loading state
                button.classList.add('deleting');
                button.innerHTML = '⌛ Eliminando...';
                
                // Send delete request
                fetch(deleteUrl, {
                    method: 'DELETE',
                    headers: {
                        'X-CSRFToken': getCookie('csrftoken'),
                        'Content-Type': 'application/json'
                    },
                    credentials: 'same-origin'
                })
                .then(response => {
                    if (response.ok) {
                        // Reload the page after successful deletion
                        window.location.reload();
                    } else {
                        button.classList.remove('deleting');
                        button.innerHTML = '🗑️ Eliminar';
                        alert('Error al eliminar la opinión');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    button.classList.remove('deleting');
                    button.innerHTML = '🗑️ Eliminar';
                    alert('Error al eliminar la opinión');
                });
            }
        });
    });
});

// Helper function to get CSRF token
function getCookie(name) {
    let cookieValue = null;
    if (document.cookie && document.cookie !== '') {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const cookie = cookies[i].trim();
            if (cookie.substring(0, name.length + 1) === (name + '=')) {
                cookieValue = decodeURIComponent(cookie.substring(name.length + 1));
                break;
            }
        }
    }
    return cookieValue;
}