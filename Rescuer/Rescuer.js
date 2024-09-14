/**
 * Cookies management
 */
function checkSession() {
    var sessionCookie = getCookie('rescuer_session');
    var rescuer_id = localStorage.getItem('rescuer_id');

    if (!sessionCookie || !rescuer_id) {
        // If the session cookie is missing or expired, redirect to login
        localStorage.removeItem('rescuer_id');
        window.location.href = '../start.html';
    }
}

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
    setCookie('rescuer_session', 'active', sessionTime);  // Reset session for another sessionTime minutes
}

/**
 * Icons
 */
var baseIcon = L.icon({
    iconUrl: '../markers/base.svg',  // Path to your custom icon
    iconSize: [35, 50],
    iconAnchor: [15, 45],
    popupAnchor: [0, -45],
});

var pendingRequestIcon = L.icon({
    iconUrl: '../markers/pendingRequestIcon_red.svg',
    iconSize: [35, 50],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
});

var inProgressRequestIcon = L.icon({
    iconUrl: '../markers/inProgressRequestIcon_green.svg',
    iconSize: [35, 50],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
});

var pendingOfferIcon = L.icon({
    iconUrl: '../markers/pendingOfferIcon_orange.svg', // Replace with your icon path
    iconSize: [35, 50],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],

});

var inProgressOfferIcon = L.icon({
    iconUrl: '../markers/inProgressOfferIcon_blue.svg', // Replace with your icon path
    iconSize: [35, 50],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
});

// Create a custom icon for the vehicle marker
var blueIcon = new L.Icon({
    iconUrl: '../markers/vehicle.svg', // Replace with your icon path
    iconSize: [35, 50],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
});

/**
 * Global variables
 */
// variables for response data
var tasks_data;
var vehicle_data;
var base_data;
var vehicle_base_data;
var rescuer_data;
var availabe_requests_data;
var availabe_offers_data;
var expiryDates = { "Requests": null, "Offers": null, "Tasks": null, "VehicleBaseRescuer": null };
const expiryTime = 60000; // 1 minute in milliseconds
const sessionTime = 20 // 20 minutes

// map variables
var baseMarker; // To store the base marker
let vehicleMarkerLatLng; // To store vehicle coordinates
let vehicleMarker; // To store the vehicle marker
let allMarkers = []; // Array to store all markers
let inProgressRequestMarkers = []; // Array to store in-progress request markers
let pendingRequestMarkers = []; // Array to store pending request markers
let inProgressOfferMarkers = []; // Array to store in-progress offer markers
let pendingOfferMarkers = []; // Array to store pending offer markers
let drawnLines = []; // Array to store drawn lines

let isInProgressOfferFilterActive = false; // State to track if the in-progress offer filter is active
let isPendingOfferFilterActive = false; // State to track if the pending offer filter is active
let isInProgressRequestFilterActive = false; // State to track if the in-progress request filter is active
let isPendingRequestFilterActive = false; // State to track if the pending request filter is active
let isLinesFilterActive = false; // State to track if the lines filter is active

let initialLoad = true; // Flag to check if it's the first load
let currentCenter; // To store the current center of the map
let currentZoom;  // To store the current zoom level of the map

/**
 * Event Listeners
 */
window.addEventListener('mousemove', extendSession);
window.addEventListener('keypress', extendSession);
window.addEventListener('click', extendSession);

document.getElementById('vehiclemanagement').addEventListener('click', function (e) {
    e.preventDefault();  // Prevent default link behavior
    showVehicleManagement();  // Call the function to show vehicle management
});

document.getElementById('loggout').addEventListener('click', function (e) {
    e.preventDefault();

    // Remove the session cookie and rescuer ID from localStorage
    document.cookie = "rescuer_session=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
    window.removeEventListener('mousemove', extendSession);
    window.removeEventListener('keypress', extendSession);
    window.removeEventListener('click', extendSession);
    localStorage.removeItem('rescuer_id');
    localStorage.removeItem('role');

    // Redirect to login page
    window.location.href = '../start.html';
});

//todo: change contents to function
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
    // Remove the modified grid layout class
    document.body.classList.remove('vehicle-management-active');
});

// Add event listeners for the toggle buttons
document.getElementById('toggleTakenRequests').addEventListener('click', toggleInProgressRequests);
document.getElementById('togglePendingRequests').addEventListener('click', togglePendingRequests);
document.getElementById('toggleTakenOffers').addEventListener('click', toggleInProgressOffers);
document.getElementById('togglePendingOffers').addEventListener('click', togglePendingOffers);
document.getElementById('toggleLines').addEventListener('click', toggleLines);

document.getElementById('completedButton').addEventListener('click', postCompletedTasks);
document.getElementById('task').addEventListener('click', postTaskUndertaking);

/**
 * Frontend functions
 */

// Function to show the vehicle management section and hide others
function showVehicleManagement() {
    var contentSection = document.getElementById('vehiclem'); // Show this section
    var mapContainer = document.getElementById('mapContainerI'); // Hide the map section
    var contentSectionX2 = document.getElementById('newAithmata'); // Hide new announcement section    
    var taskTable = document.getElementById('taskT'); // Hide task table

    contentSection.style.display = 'block';  // Show vehicle management
    contentSectionX2.style.display = 'block';  // Show new announcement section
    mapContainer.style.display = 'none';     // Hide map
    taskTable.style.display = 'none';        // Hide task table
    document.body.classList.add('vehicle-management-active');
}

function populateTaskTable() {
    const taskTableBody = document.getElementById("taskTable")
        .querySelector('tbody')

    taskTableBody.innerHTML = "";

    tasks_data.Requests.concat(tasks_data.Offers).forEach(task => {
        const row = document.createElement("tr");
        row.dataset.taskId = task.ID; // Store the task ID in the cell

        // Checkbox cell
        const checkboxCell = document.createElement("td");
        const checkbox = document.createElement("input");
        checkbox.type = "checkbox";
        checkbox.classList.add("task-checkbox"); // Add custom class for styling
        checkboxCell.appendChild(checkbox);

        // Data cells
        const taskTypeCell = document.createElement("td");
        taskTypeCell.textContent = task.Type;

        const nameCell = document.createElement("td");
        nameCell.textContent = task.Name + " " + task.Surname;

        const phoneCell = document.createElement("td");
        phoneCell.textContent = task.Phone;

        const dateCell = document.createElement("td");
        dateCell.textContent = task.DateCreated;

        const itemTypeCell = document.createElement("td");
        itemTypeCell.textContent = task.ItemNames;

        const quantityCell = document.createElement("td");
        quantityCell.textContent = task.ItemQuantities;

        // Append cells to the row
        row.appendChild(checkboxCell);  // Add checkbox cell to the row
        row.appendChild(taskTypeCell);
        row.appendChild(nameCell);
        row.appendChild(phoneCell);
        row.appendChild(dateCell);
        row.appendChild(itemTypeCell);
        row.appendChild(quantityCell);

        // Append the row to the table body
        taskTableBody.appendChild(row);
    });
}

// Function to clear all lines from the map
function clearLines() {
    drawnLines.forEach(line => map.removeLayer(line));
    drawnLines = [];
}

// Function to draw lines between vehicle and tasks
function drawTaskLines() {
    clearLines();

    // Draw lines to request tasks
    if (tasks_data.Requests && !isInProgressRequestFilterActive && !isLinesFilterActive) {
        tasks_data.Requests.forEach(request => {
            const line = L.polyline([[vehicle_data.Latitude, vehicle_data.Longitude], [request.Latitude, request.Longitude]], {
                color: 'green'
            }).addTo(map);
            drawnLines.push(line);
        });
    }

    // Draw lines to offer tasks
    if (tasks_data.Offers && !isInProgressOfferFilterActive && !isLinesFilterActive) {
        tasks_data.Offers.forEach(offer => {
            const line = L.polyline([[vehicle_data.Latitude, vehicle_data.Longitude], [offer.Latitude, offer.Longitude]], {
                color: 'blue'
            }).addTo(map);
            drawnLines.push(line);
        });
    }
}

// Function to draw a line between a request/offer marker and the rescuer's vehicle coordinates
function drawLineToVehicle(marker, vehicleMarkerLatLng) {
    if (vehicleMarkerLatLng) {
        const line = L.polyline([[marker.getLatLng().lat, marker.getLatLng().lng], [vehicleMarkerLatLng.lat, vehicleMarkerLatLng.lng]], {
            color: 'green'
        }).addTo(map);
        drawnLines.push(line);
    }
}

// Function to update the map with base, vehicle, offer, and request data
function updateMap() {
    // Clear previous markers and lines
    allMarkers.forEach(marker => map.removeLayer(marker));
    inProgressRequestMarkers.forEach(marker => map.removeLayer(marker));
    pendingRequestMarkers.forEach(marker => map.removeLayer(marker));
    inProgressOfferMarkers.forEach(marker => map.removeLayer(marker));
    pendingOfferMarkers.forEach(marker => map.removeLayer(marker));
    drawnLines.forEach(line => map.removeLayer(line));

    allMarkers = []; // Reset the marker arrays
    inProgressRequestMarkers = [];
    pendingRequestMarkers = [];
    inProgressOfferMarkers = [];
    pendingOfferMarkers = [];

    drawnLines = [];

    // Clear the base marker if it exists
    if (baseMarker) {
        map.removeLayer(baseMarker);
    }

    // Clear the vehicle marker if it exists
    if (vehicleMarker) {
        map.removeLayer(vehicleMarker);
    }

    // Add the base marker with the custom icon
    baseMarker = L.marker([base_data.Latitude, base_data.Longitude], { icon: baseIcon }).addTo(map);

    // Store vehicle location for easy lookup
    vehicleMarkerLatLng = { lat: vehicle_data.Latitude, lng: vehicle_data.Longitude };

    vehicleMarker = L.marker([vehicleMarkerLatLng.lat, vehicleMarkerLatLng.lng], { icon: blueIcon, draggable: true});
    vehicleMarker.addTo(map).bindPopup(`<b>You are here!</b>`);

    // Handle dragging of the base marker
    vehicleMarker.on('dragend', function (event) {
        vehicleMarker.setLatLng = event.target.getLatLng();
        vehicle_data.Latitude = event.target.getLatLng().lat;
        vehicle_data.Longitude = event.target.getLatLng().lng;
        drawTaskLines();
        postVehiclePosition();
    });

    // If it's the initial load (browser refresh), set the map to the base location and open popup
    if (initialLoad) {
        map.setView([base_data.Latitude, base_data.Longitude], 16);
        vehicleMarker.openPopup();
        
        // Set the rescuer's name in the header //todo: not the right place to be in
        document.getElementById('rescuer-name').innerText = 'Συνδεδεμένος ως: ' + rescuer_data.Username + ' (Rescuer)';
        initialLoad = false;
    } else {
        // Reapply the saved center and zoom level after the update
        if (currentCenter && currentZoom) {
            map.setView(currentCenter, currentZoom);
        }
    }

    // Draw lines only if the lines filter is not active
    if (!isLinesFilterActive) {
        drawTaskLines();
    }

    // Add availabe request markers
    availabe_requests_data.forEach(function (request) {
        var icon = pendingRequestIcon;
        var requestMarker = L.marker([request.Latitude, request.Longitude], { icon: icon });

        // Add to the respective arrays
        allMarkers.push(requestMarker);
        pendingRequestMarkers.push(requestMarker);

        // Add marker to the map if the filters are not active or if it should be displayed
        if (!isInProgressRequestFilterActive) {
            requestMarker.addTo(map);
        }

        requestMarker.on('click', function () {
            clearLines(); // Clear lines when clicking a new marker
            showPopup({
                type: "request-box",
                title: "Διαθέσιμο Αίτημα",
                details: `
                <p><strong>Ονοματεπώνυμο:</strong> ${request.Name}</p>
                <p><strong>Τηλέφωνο:</strong> ${request.Phone}</p>
                <p><strong>Ημ/νια Καταχώρησης:</strong> ${request.DateCreated}</p>
                <p><strong>Είδη:</strong> ${request.ItemNames}</p>
                <p><strong>Ποσότητες:</strong> ${request.ItemQuantities}</p>
            `, taskID: request.RequestID,
                taskType: "Request"
            });

            // Draw a line to the vehicle if selected and the lines filter is not active
            if (!isLinesFilterActive && !isPendingRequestFilterActive) {
                drawLineToVehicle(requestMarker, vehicleMarkerLatLng); 
            }
        });
    });

    // Add availabe offer markers
    availabe_offers_data.forEach(function (offer) {
        var icon = pendingOfferIcon;
        var offerMarker = L.marker([offer.Latitude, offer.Longitude], { icon: icon });

        // Add to the respective arrays
        allMarkers.push(offerMarker);
        pendingOfferMarkers.push(offerMarker);

        // Add marker to the map if the filter is not active
        if (!isPendingOfferFilterActive) {
            offerMarker.addTo(map);
        }

        offerMarker.on('click', function () {
            clearLines(); // Clear lines when clicking a new marker
            showPopup({
                type: "offer-box",
                title: "Διαθέσιμη Προσφορά",
                details: `
                <p><strong>Ονοματεπώνυμο:</strong> ${offer.Name}</p>
                <p><strong>Τηλέφωνο:</strong> ${offer.Phone}</p>
                <p><strong>Ημ/νια Καταχώρησης:</strong> ${offer.DateCreated}</p>
                <p><strong>Είδη:</strong> ${offer.ItemNames}</p>
                <p><strong>Ποσότητες:</strong> ${offer.ItemQuantities}</p>
                
            `, 
                taskID: offer.OfferID,
                taskType: "Offer"
            });

            // Draw a line to the vehicle if selected and the lines filter is not active
            if (!isLinesFilterActive && !isPendingOfferFilterActive) {
                drawLineToVehicle(offerMarker, vehicleMarkerLatLng);
            }
        });
    });

    // Add offer tasks markers
    tasks_data.Offers.forEach(function (offer) {
        var icon = inProgressOfferIcon;

        var offerMarker = L.marker([offer.Latitude, offer.Longitude], { icon: icon });

        // Add to the respective arrays
        allMarkers.push(offerMarker);
        inProgressOfferMarkers.push(offerMarker);

        // Add marker to the map
        if (!isInProgressOfferFilterActive) {
            offerMarker.addTo(map);
        }

        offerMarker.on('click', function () {
            clearLines(); // Clear lines when clicking a new marker
            showPopup({
                type: "task-offer-box",
                title:"Προσφορά",
                details: `
                <p><strong>Ονοματεπώνυμο:</strong> ${offer.Name}</p>
                <p><strong>Τηλέφωνο:</strong> ${offer.Phone}</p>
                <p><strong>Ημ/νια Καταχώρησης:</strong> ${offer.DateCreated}</p>
                <p><strong>Είδος:</strong> ${offer.Type}</p>
                <p><strong>Ποσότητα:</strong> ${offer.Quantity}</p>
                <p><strong>Ημ/νια Ανάληψης Προσφοράς:</strong> ${offer.DateAssignedVehicle}</p>`,
            });

            // Draw a line to the vehicle if selected and the lines filter is not active
            if (!isLinesFilterActive && !isInProgressOfferFilterActive) {
                drawLineToVehicle(offerMarker, vehicleMarkerLatLng);
            }
        });
    });

    // Add request tasks markers
    tasks_data.Requests.forEach(function (request) {
        var icon = inProgressRequestIcon;

        var requestMarker = L.marker([request.Latitude, request.Longitude], { icon: icon });

        // Add to the respective arrays
        allMarkers.push(requestMarker);
        inProgressRequestMarkers.push(requestMarker);

        // Add marker to the map
        if (!isInProgressRequestFilterActive) {
            requestMarker.addTo(map);
        }

        requestMarker.on('click', function () {
            clearLines(); // Clear lines when clicking a new marker
            showPopup({
                type: "task-request-box",
                title:"Αίτημα",
                details: `
                <p><strong>Ονοματεπώνυμο:</strong> ${request.Name}</p>
                <p><strong>Τηλέφωνο:</strong> ${request.Phone}</p>
                <p><strong>Ημ/νια Καταχώρησης:</strong> ${request.DateCreated}</p>
                <p><strong>Είδος:</strong> ${request.Type}</p>
                <p><strong>Ποσότητα:</strong> ${request.Quantity}</p>
                <p><strong>Ημ/νια Ανάληψης Αιτήματος:</strong> ${request.DateAssignedVehicle}</p>`,
            });

            // Draw a line to the vehicle if selected and the lines filter is not active
            if (!isLinesFilterActive && !isInProgressRequestFilterActive) {
                drawLineToVehicle(requestMarker, vehicleMarkerLatLng);
            }
        });
    });
}

// Function to show the vehicle popup
function showPopup({ type, title, details, taskID=null, taskType=null }) {
    const popup = document.getElementById('draggableBox');
    popup.className = type
    if (taskID && taskType) {
        popup.dataset.taskId = taskID;
        popup.dataset.taskType = taskType
    } else {
        popup.dataset.taskId = null;
        popup.dataset.taskType = null;
    }

    const popupTitle = popup.querySelector('.task-title');
    const popupDetails = popup.querySelector('.task-details');

    popupTitle.innerHTML = title;
    popupDetails.innerHTML = details;

    popup.style.display = 'flex';
}

// Close button event for vehicle popup
document.getElementById('closeBox').addEventListener('click', function () {
    document.getElementById('draggableBox').style.display = 'none';
    drawTaskLines();
});

// Function to toggle the filter for "In Progress Requests"
function toggleInProgressRequests() {
    const button = document.getElementById('toggleTakenRequests');

    if (isInProgressRequestFilterActive) {
        inProgressRequestMarkers.forEach(marker => marker.addTo(map)); // Re-add in-progress markers
        button.classList.remove('active-filter');
    } else {
        inProgressRequestMarkers.forEach(marker => map.removeLayer(marker)); // Remove in-progress markers
        button.classList.add('active-filter');
    }

    isInProgressRequestFilterActive = !isInProgressRequestFilterActive;
    drawTaskLines();
}

// Function to toggle the filter for "Pending Requests"
function togglePendingRequests() {
    const button = document.getElementById('togglePendingRequests');

    if (isPendingRequestFilterActive) {
        pendingRequestMarkers.forEach(marker => marker.addTo(map)); // Re-add pending markers
        button.classList.remove('active-filter');
    } else {
        pendingRequestMarkers.forEach(marker => map.removeLayer(marker)); // Remove pending markers
        button.classList.add('active-filter');
    }

    isPendingRequestFilterActive = !isPendingRequestFilterActive;
    drawTaskLines();
}

// Function to toggle the filter for "In progress Offers"
function toggleInProgressOffers() {
    const button = document.getElementById('toggleTakenOffers');

    if (isInProgressOfferFilterActive) {
        inProgressOfferMarkers.forEach(marker => marker.addTo(map)); // Re-add offer markers
        button.classList.remove('active-filter');
    } else {
        inProgressOfferMarkers.forEach(marker => map.removeLayer(marker)); // Remove offer markers
        button.classList.add('active-filter');
    }

    isInProgressOfferFilterActive = !isInProgressOfferFilterActive;
    drawTaskLines();
}

// Function to toggle the filter for "In progress Offers"
function togglePendingOffers() {
    const button = document.getElementById('togglePendingOffers');

    if (isPendingOfferFilterActive) {
        pendingOfferMarkers.forEach(marker => marker.addTo(map)); // Re-add offer markers
        button.classList.remove('active-filter');
    } else {
        pendingOfferMarkers.forEach(marker => map.removeLayer(marker)); // Remove offer markers
        button.classList.add('active-filter');
    }

    isPendingOfferFilterActive = !isPendingOfferFilterActive;
    drawTaskLines();
}

// Function to toggle the filter for "Lines"
function toggleLines() {
    const button = document.getElementById('toggleLines');

    if (isLinesFilterActive) {
        drawnLines.forEach(line => line.addTo(map)); // Re-add lines
        button.classList.remove('active-filter');
    } else {
        drawnLines.forEach(line => map.removeLayer(line)); // Remove lines
        button.classList.add('active-filter');
    }

    isLinesFilterActive = !isLinesFilterActive;
}

// Function to show the confirmation popup
function showConfirmPopup() {
    const confirmationBox = document.getElementById('confirmationBox');
    confirmationBox.style.display = 'block';
}

/**
 * Backend functions
 */
function fetchAllExpired() {
    let update_map = false;
    let update_tasks = false;
    let promises = [];
    if (expiryDates['Requests'] == null || Date.now() - expiryDates['Requests'] > expiryTime) {
        promises.push(fetchRequests());
        update_map = true;
    }

    if (expiryDates['Offers'] == null || Date.now() - expiryDates['Offers'] > expiryTime) {
        promises.push(fetchOffers());
        update_map = true;
    }

    if (expiryDates['Tasks'] == null || Date.now() - expiryDates['Tasks'] > expiryTime) {
        promises.push(fetchTasks());
        update_map = true;
        update_tasks = true;
    }

    if (expiryDates['VehicleBaseRescuer'] == null || Date.now() - expiryDates['VehicleBaseRescuer'] > expiryTime) {
        // save coordinates
        if (!initialLoad) {
            currentCenter = map.getCenter();
            currentZoom = map.getZoom();
        }
        promises.push(fetchVehicleBaseRescuer());
        update_map = true;
    }

    Promise.all(promises).then(() => {
        if (update_map) {
            updateMap();
        }

        if (update_tasks) {
            populateTaskTable();
        }
    });
}

function fetchRequests() {
    // Return the fetch chain
    return fetch('api/availabe_requests.php')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                throw new Error(data.error);
            }
            availabe_requests_data = data;
        })
        .catch(error => {
            console.error('Fetch Error:', error);
            // Optionally re-throw the error if you want calling code to handle it
            throw error;
        });
}

function fetchOffers() {
    return fetch('api/availabe_offers.php')
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                throw new Error(data.error);
            }
            availabe_offers_data = data;
        })
        .catch(error => {
            console.error('Fetch Error:', error);
            throw error; // Rethrow after logging to allow caller to handle
        });
}

function fetchTasks() {
    return fetch('api/current_tasks.php/' + localStorage.getItem('rescuer_id'))
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                throw new Error(data.error);
            }
            tasks_data = data;
        })
        .catch(error => {
            console.error('Fetch Error:', error);
            throw error; // Rethrow after logging to allow caller to handle
        });
}

function fetchVehicleBaseRescuer() {
    return fetch('api/vehicle_base_rescuer_info.php/' + localStorage.getItem('rescuer_id'))
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                throw new Error(data.error);
            }
            vehicle_base_data = data;
            vehicle_data = vehicle_base_data.Vehicle;
            base_data = vehicle_base_data.Base;
            rescuer_data = vehicle_base_data.Rescuer;
        })
        .catch(error => {
            console.error('Fetch Error:', error);
            throw error; // Rethrow after logging to allow caller to handle
        });
}

function postVehiclePosition() {
    const data = {
        latitude: vehicle_data.Latitude,
        longitude: vehicle_data.Longitude
    };

    fetch('api/update_vehicle_pos.php/' + localStorage.getItem('rescuer_id'), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                throw new Error(data.error);
                alert(data.error);
            }
            console.log(data['message']);
        })
        .catch(error => {
            console.error('Fetch Error:', error);
            throw error; // Rethrow after logging to allow caller to handle
        });
}

function postTaskUndertaking() {
    // Get popup box
    const popup = document.getElementById('draggableBox');
    // get id and type from data
    const task_id = popup.dataset.taskId;
    const task_type = popup.dataset.taskType;

    // and displayed
    if (!task_id || !task_type || popup.style.display == 'none') {
        alert('Δεν έχετε επιλέξει καμία εργασία.');
        return;
    }

    // send post for each task localstorage rescuer id
    data = {
        task_id: task_id,
        task_type: task_type
    }

    fetch('api/undertake_task.php/' + localStorage.getItem('rescuer_id'), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify(data),
    })
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .then(data => {
            if (data.error) {
                throw new Error(data.error);
            }
            alert(data['message']);

            expiryDates['Tasks'] = null; // Force a refresh of the tasks and re-rendering
            expiryDates['Requests'] = null; // Force a refresh of the requests and re-rendering
            expiryDates['Offers'] = null; // Force a refresh of the offers and re-rendering
            popup.style.display = 'none';
            fetchAllExpired();
            
        })
        .catch(error => {
            console.error('Fetch Error:', error);
            throw error; // Rethrow after logging to allow caller to handle
    });
    


}

function postCompletedTasks() {
    // get all checked checkboxes
    const checkboxes = document.getElementById('taskTable').querySelectorAll('.task-checkbox:checked');
    const task_ids = Array.from(checkboxes).map(checkbox => checkbox.parentElement.parentElement.dataset.taskId);
    const task_types = Array.from(checkboxes).map(checkbox => checkbox.parentElement.nextElementSibling.textContent);

    // If no checkboxes are selected, show an alert
    if (task_ids.length === 0) {
        alert('Δεν έχετε επιλέξει καμία εργασία.');
        return;
    }

    // send post for each task localstorage rescuer id
    task_ids.forEach(task_id => {
        var task_type = task_types[task_ids.indexOf(task_id)];
        var task;
        // search for the task json object
        if (task_type === "Offer"){
            task = tasks_data.Offers.filter((entry) => entry.ID === task_id)[0];
        } else {
            task = tasks_data.Requests.filter((entry) => entry.ID === task_id)[0];
        }

        var distance = calculateDistance(task.Latitude, task.Longitude, vehicle_data.Latitude, vehicle_data.Longitude);
        if (distance>100) {
            alert("Δεν βρίσκεστε αρκετά κοντά για ολοκληρώσετε την εργασία");
            return;
        }

        data = {
            task_id: task_id,
            task_type: task_type
        }
        fetch('api/complete_task.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(data),
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Network response was not ok');
                }
                return response.json();
            })
            .then(data => {
                if (data.error) {
                    throw new Error(data.error);
                }
                console.log(data['message']);

                expiryDates['Tasks'] = null; // Force a refresh of the tasks and re-rendering
                fetchAllExpired();
            })
            .catch(error => {
                console.error('Fetch Error:', error);
                throw error; // Rethrow after logging to allow caller to handle
            });
    });
}

function calculateDistance(lat1, lon1, lat2, lon2) {
    const R = 6371; // Radius of the Earth in kilometers
    const rad = Math.PI / 180; // Factor to convert degrees to radians
    const dLat = (lat2 - lat1) * rad;
    const dLon = (lon2 - lon1) * rad;

    const a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(lat1 * rad) * Math.cos(lat2 * rad) *
        Math.sin(dLon / 2) * Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c * 1000; // Distance in meters
}

function vehicleToTaskDistance(taskMarker) {
    const taskLatLng = taskMarker.getLatLng();
    const vehicleLatLng = vehicleMarker.getLatLng();
    const distance = calculateDistance(taskLatLng.lat, taskLatLng.lng, vehicleLatLng.lat, vehicleLatLng.lng);

    return distance

}

/**
 * Mobile Frontend Functions
 */
// Add this to your mapScript.js

function toggleMenu() {
    const menuBar = document.querySelector('.menu-bar');
    menuBar.style.display = menuBar.style.display === 'flex' ? 'none' : 'flex';
}

document.addEventListener('DOMContentLoaded', function () {
    const menuItems = document.querySelectorAll('.menu-item-container');

    menuItems.forEach(item => {
        item.addEventListener('click', function (event) {
            if (window.innerWidth <= 768) {
                event.stopPropagation(); // Prevent the click from closing the menu
                menuItems.forEach(el => el !== this && el.classList.remove('active'));
                this.classList.toggle('active');
            }
        });
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function () {
        if (window.innerWidth <= 768) {
            menuItems.forEach(item => item.classList.remove('active'));
        }
    });
});

/**
 * Setup
 */
// Initialize the map at a default position; this will be updated once the base location is fetched
var map = L.map('map').setView([51.505, -0.09], 16);

// Add a tile layer from OpenStreetMap
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 25,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);

// cookies
checkSession();  // Initial check
setInterval(checkSession, 60000);  // Check every 1 minute

document.addEventListener("DOMContentLoaded", function () {
    fetchAllExpired();
    setInterval(fetchAllExpired, expiryTime / 10); // check every one tenth of the expiry time
    currentCenter = map.getCenter();
    currentZoom = map.getZoom();
    //hide popup

});


const draggableBox = document.getElementById("draggableBox");

let isDragging = false;
let initialX, initialY, offsetX = 0, offsetY = 0;

draggableBox.addEventListener('mousedown', startDrag);
document.addEventListener('mousemove', drag);
document.addEventListener('mouseup', stopDrag);

// For touch devices
draggableBox.addEventListener('touchstart', startDrag);
document.addEventListener('touchmove', drag);
document.addEventListener('touchend', stopDrag);

function startDrag(e) {
    isDragging = true;
    const event = e.type === 'touchstart' ? e.touches[0] : e;
    initialX = event.clientX - offsetX;
    initialY = event.clientY - offsetY;

    draggableBox.style.cursor = 'grabbing';
}

function drag(e) {
    if (!isDragging) return;
    
    const event = e.type === 'touchmove' ? e.touches[0] : e;
    offsetX = event.clientX - initialX;
    offsetY = event.clientY - initialY;

    draggableBox.style.transform = `translate(${offsetX}px, ${offsetY}px)`;
}

function stopDrag() {
    isDragging = false;
    draggableBox.style.cursor = 'grab';
}

