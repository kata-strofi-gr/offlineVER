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
    setCookie('rescuer_session', 'active', 1);  // Reset session for another 20 minutes
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
document.addEventListener("DOMContentLoaded", function() {
    checkSession();  // Initial check

    // Set an interval to check the session every minute (60000 milliseconds)
    setInterval(checkSession, 60000);  // Check every 1 minute
});

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
    window.removeEventListener('mousemove', extendSession);
    window.removeEventListener('keypress', extendSession);
    window.removeEventListener('click', extendSession);
    localStorage.removeItem('rescuer_id');
    localStorage.removeItem('userID');
    localStorage.removeItem('role');

    // Redirect to login page
    window.location.href = '../start.html';
});



// Function to show the vehicle management section and hide others
function showvehiclemanagement() {
    var contentSection = document.getElementById('vehiclem'); // Show this section
    var mapContainer = document.getElementById('mapContainerI'); // Hide the map section
    var contentSectionX = document.getElementById('taskm'); // Hide task management section
    var contentSectionX2 = document.getElementById('newAithmata'); // Hide new announcement section    
    var taskTable = document.getElementById('taskT'); // Hide task table

    contentSection.style.display = 'block';  // Show vehicle management
    contentSectionX2.style.display = 'block';  // Show new announcement section
    mapContainer.style.display = 'none';     // Hide map
    taskTable.style.display = 'none';        // Hide task table
}



// Event listeners for menu items
document.getElementById('vehiclemanagement').addEventListener('click', function (e) {
    e.preventDefault();  // Prevent default link behavior
    showvehiclemanagement();  // Call the function to show vehicle management
});


// Function to reset to the map view when the logo is clicked
document.getElementById('logoF').addEventListener('click', function (e) {
    e.preventDefault();
    var mapContainer = document.getElementById('mapContainerI'); // Show map
    var contentSectionX = document.getElementById('vehiclem'); // Hide vehicle management
    var contentSectionX1 = document.getElementById('newAithmata'); // Hide newAithmata
    var taskTable = document.getElementById('taskT'); // Show task table section

    // Display map and task table
    mapContainer.style.display = 'block';
    taskTable.style.display = 'block';  // Show taskT section

    // Hide other sections
    contentSectionX.style.display = 'none';
    contentSectionX1.style.display = 'none';
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


function populateTaskTable() {
    const taskTableBody = document.querySelector("#taskTable tbody");

    // Dummy data array
    const dummyTasks = [
        {
            name: "John Doe",
            phone: "123-456-7890",
            date: "2024-09-01",
            type: "Food Supplies",
            quantity: 10
        },
        {
            name: "Jane Smith",
            phone: "987-654-3210",
            date: "2024-09-02",
            type: "Medical Kit",
            quantity: 5
        },
        {
            name: "Alex Johnson",
            phone: "555-123-4567",
            date: "2024-09-03",
            type: "Water Bottles",
            quantity: 20
        },
        {
            name: "Emily Davis",
            phone: "444-555-6666",
            date: "2024-09-04",
            type: "Blankets",
            quantity: 15
        }
    ];

    // Insert dummy data into table
    dummyTasks.forEach(task => {
        const row = document.createElement("tr");

        const nameCell = document.createElement("td");
        nameCell.textContent = task.name;

        const phoneCell = document.createElement("td");
        phoneCell.textContent = task.phone;

        const dateCell = document.createElement("td");
        dateCell.textContent = task.date;

        const typeCell = document.createElement("td");
        typeCell.textContent = task.type;

        const quantityCell = document.createElement("td");
        quantityCell.textContent = task.quantity;

        // Append cells to the row
        row.appendChild(nameCell);
        row.appendChild(phoneCell);
        row.appendChild(dateCell);
        row.appendChild(typeCell);
        row.appendChild(quantityCell);

        // Append the row to the table body
        taskTableBody.appendChild(row);
    });
}

// Call the function when the page loads
document.addEventListener("DOMContentLoaded", function() {
    populateTaskTable();  // Populate the task table with dummy data
});
