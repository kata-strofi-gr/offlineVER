document.addEventListener('DOMContentLoaded', function() {
    // Periodic AJAX call to keep session alive
    setInterval(function() {
        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'refresh_session.php', true);
        xhr.send();
    }, 5 * 60 * 1000); // Every 5 minutes

    // Logout Functionality
    document.getElementById('logoutButton').addEventListener('click', function(e) {
        e.preventDefault();
        var xhr = new XMLHttpRequest();
        xhr.open('GET', 'logout.php', true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                window.location.href = 'start.html';
            }
        };
        xhr.send();
    });
});
