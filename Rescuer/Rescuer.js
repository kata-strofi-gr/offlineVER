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



// Function to show the vehicle management section and hide others
function showvehiclemanagement() {
    var contentSection = document.getElementById('vehiclem'); // Show this section
    var mapContainer = document.getElementById('mapContainerI'); // Hide the map section
    var contentSectionX = document.getElementById('taskm'); // Hide task management section
    var contentSectionX2 = document.getElementById('newAithmata'); // Hide task management section    

    contentSection.style.display = 'block';  // Show vehicle management
    contentSectionX2.style.display = 'block';  // Hide task management
    mapContainer.style.display = 'none';     // Hide map
    contentSectionX.style.display = 'none';  // Hide task management
}

// Function to show the task management section and hide others
function showtaskmanagement() {
    var contentSection = document.getElementById('taskm'); // Show this section
    var mapContainer = document.getElementById('mapContainerI'); // Hide the map section
    var contentSectionX = document.getElementById('vehiclem'); // Hide vehicle management section
    var contentSectionX2 = document.getElementById('newAithmata'); // Hide new announcement section

    contentSection.style.display = 'block';  // Show task management
    mapContainer.style.display = 'none';     // Hide map
    contentSectionX.style.display = 'none';  // Hide vehicle management
    contentSectionX2.style.display = 'none';  // Hide new announcement section
}

// Event listener to trigger task management view
document.getElementById('taskmanagement').addEventListener('click', function (e) {
    e.preventDefault();  // Prevent default link behavior
    showtaskmanagement();  // Call the function to show task management
});



// Event listeners for menu items
document.getElementById('vehiclemanagement').addEventListener('click', function (e) {
    e.preventDefault();  // Prevent default link behavior
    showvehiclemanagement();  // Call the function to show vehicle management
});



// Function to reset to the map view when the logo is clicked
document.getElementById('logoF').addEventListener('click', function(e) {
    e.preventDefault();
    var mapContainer = document.getElementById('mapContainerI'); // Show map
    var contentSectionX = document.getElementById('taskm'); // Hide task management
    var contentSectionX2 = document.getElementById('vehiclem'); // Hide vehicle management
    var contentSectionX1 = document.getElementById('newAithmata');

    mapContainer.style.display = 'block';   // Show map
    contentSectionX.style.display = 'none'; // Hide task management
    contentSectionX2.style.display = 'none'; // Hide vehicle management
    contentSectionX1.style.display = 'none'; // Hide vehicle management
});

//mobile version
// Add this to your mapScript.js

function toggleMenu() {
    const menuBar = document.querySelector('.menu-bar');
    menuBar.style.display = menuBar.style.display === 'flex' ? 'none' : 'flex';
}

document.addEventListener('DOMContentLoaded', function() {
    const menuItems = document.querySelectorAll('.menu-item-container');

    menuItems.forEach(item => {
        item.addEventListener('click', function(event) {
            if (window.innerWidth <= 768) {
                event.stopPropagation(); // Prevent the click from closing the menu
                menuItems.forEach(el => el !== this && el.classList.remove('active'));
                this.classList.toggle('active');
            }
        });
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function() {
        if (window.innerWidth <= 768) {
            menuItems.forEach(item => item.classList.remove('active'));
        }
    });
});
