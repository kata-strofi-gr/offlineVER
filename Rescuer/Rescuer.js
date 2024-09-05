// Function to set or reset a cookie
function setCookie(name, value, minutes) {
    var expires = "";
    if (minutes) {
        var date = new Date();
        date.setTime(date.getTime() + (minutes * 60 * 1000)); // Convert minutes to milliseconds
        expires = "; expires=" + date.toUTCString();
    }
    document.cookie = name + "=" + value + expires + "; path=/";
}

// Function to reset the session cookie when the user is active
function extendSession() {
    setCookie('rescuer_session', 'active', 20);  // Reset session for another 20 minutes
}

// Add event listeners for user activity (mousemove, keypress, click)
window.addEventListener('mousemove', extendSession);
window.addEventListener('keypress', extendSession);
window.addEventListener('click', extendSession);

// Function to continuously check if the session cookie exists and redirect if missing
function checkSession() {
    var sessionCookie = getCookie('rescuer_session');
    var rescuer_id = localStorage.getItem('rescuer_id');

    if (!sessionCookie || !rescuer_id) {
        // If the session cookie is missing or expired, redirect to login
        window.location.href = '../start.html';
    }
}

// Check the session immediately when the page loads
window.onload = function() {
    checkSession();  // Initial check

    // Set an interval to check the session every minute (60000 milliseconds)
    setInterval(checkSession, 60000);  // Check every 1 minute
};

// Function to get a cookie by name
function getCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1, c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length, c.length);
    }
    return null;
}

// Logout functionality
document.getElementById('loggout').addEventListener('click', function (e) {
    e.preventDefault();

    // Remove the session cookie and rescuer ID from localStorage
    document.cookie = "rescuer_session=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    localStorage.removeItem('rescuer_id');
    localStorage.removeItem('role');
    localStorage.removeItem('user_id');

    // Redirect to login page
    window.location.href = '../start.html';
});
