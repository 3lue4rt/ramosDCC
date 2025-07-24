document.addEventListener('DOMContentLoaded', function () {
    const buttons = document.querySelectorAll('.like-btn');
    buttons.forEach(button => {
        button.addEventListener('click', function () {
            const opinionId = this.getAttribute('data-opinion-id');
            const likes = this.getAttribute('data-likes')
            const url = this.getAttribute('data-action');  // << aquí toma la URL dinámica
            const csrftoken = getCookie('csrftoken');

            fetch(url, {
                method: 'POST',
                headers: { 
                    'Content-Type': 'application/x-www-form-urlencoded',
                    'X-CSRFToken': csrftoken
                },
                body: new URLSearchParams({ opinion_id: opinionId , curr_likes: likes})
            })
            .then(response => response.json())
            .then(data => {
                document.getElementById('likes-count-' + opinionId).innerText = data.likes;
                this.setAttribute('data-likes', data.likes)
            });
        });
    });
});

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
