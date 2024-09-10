// Initialize the map at a default position; this will be updated once the base location is fetched
var map = L.map('map').setView([51.505, -0.09], 16);

// Add a tile layer from OpenStreetMap
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 25,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);

// Global variables to track markers, lines, and fil

var baseMarker; // To store the base marker
var newBaseLatLng; // To store the new coordinates after dragging
let vehicleMarkerLatLng; // To store vehicle coordinates
let vehicleMarker; // To store the vehicle marker
let allMarkers = []; // Array to store all markers
let inProgressMarkers = []; // Array to store in-progress request markers
let pendingMarkers = []; // Array to store pending request markers
let offerMarkers = []; // Array to store offer markers
let drawnLines = []; // Array to store drawn lines

let isInProgressFilterActive = false; // State to track if the in-progress filter is active
let isPendingFilterActive = false; // State to track if the pending filter is active
let isOfferFilterActive = false; // State to track if the offer filter is active
let isActiveVehiclesFilterActive = false; // State to track if the active vehicles filter is active
let isInactiveVehiclesFilterActive = false; // State to track if the inactive vehicles filter is active
let isLinesFilterActive = false; // State to track if the lines filter is active

let initialLoad = true; // Flag to check if it's the first load

// Custom icons for different statuses and types
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

let currentCenter; // To store the current center of the map
let currentZoom;  // To store the current zoom level of the map

function fetchDataAndUpdateMap() {

    // Save the current center and zoom level before fetching the data
    if (!initialLoad) {
        currentCenter = map.getCenter();
        currentZoom = map.getZoom();
    }

    fetch('map_fetch.php/' + localStorage.getItem('rescuer_id'))
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                console.error(data.error);
                return;
            }
            updateMap(data);
        })
        .catch(error => {
            console.error('Fetch Error:', error);
        });
}

// Function to clear all lines from the map
function clearLines() {
    drawnLines.forEach(line => map.removeLayer(line));
    drawnLines = [];
}

// Function to draw lines between vehicle and tasks
function drawLines(vehicle, requests, offers) {
    clearLines();

    // Draw lines to assigned requests
    if (vehicle.AssignedRequests && isInProgressFilterActive) {
        vehicle.AssignedRequests.split(',').forEach(reqID => {
            const request = requests.find(r => r.RequestID == reqID);
            if (request) {
                const line = L.polyline([[vehicle.VehicleLat, vehicle.VehicleLng], [request.Latitude, request.Longitude]], {
                    color: 'green'
                }).addTo(map);
                drawnLines.push(line);
            }
        });
    }

    // Draw lines to assigned offers
    if (vehicle.AssignedOffers) {
        vehicle.AssignedOffers.split(',').forEach(offerID => {
            const offer = offers.find(o => o.OfferID == offerID);
            if (offer) {
                const line = L.polyline([[vehicle.VehicleLat, vehicle.VehicleLng], [offer.Latitude, offer.Longitude]], {
                    color: 'blue'
                }).addTo(map);
                drawnLines.push(line);
            }
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
function updateMap(mapData) {
    const base = mapData.base;

    // Clear previous markers and lines
    allMarkers.forEach(marker => map.removeLayer(marker));
    inProgressMarkers.forEach(marker => map.removeLayer(marker));
    pendingMarkers.forEach(marker => map.removeLayer(marker));
    offerMarkers.forEach(marker => map.removeLayer(marker));
    drawnLines.forEach(line => map.removeLayer(line));

    allMarkers = []; // Reset the marker arrays
    inProgressMarkers = [];
    pendingMarkers = [];
    offerMarkers = [];
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
    baseMarker = L.marker([base.Latitude, base.Longitude], { icon: baseIcon}).addTo(map);
    
    // Store vehicle location for easy lookup
    vehicleMarkerLatLng = { lat: mapData.vehicle.VehicleLat, lng: mapData.vehicle.VehicleLng };

    vehicleMarker = L.marker([vehicleMarkerLatLng.lat, vehicleMarkerLatLng.lng], { icon: blueIcon });
    vehicleMarker.addTo(map).bindPopup(`<b>You are here!</b>`);

    // If it's the initial load (browser refresh), set the map to the base location and open popup
    if (initialLoad) {
        map.setView([base.Latitude, base.Longitude], 16);
        vehicleMarker.openPopup();
        initialLoad = false; // Reset the flag after the initial load
    } else {
        // Reapply the saved center and zoom level after the update
        if (currentCenter && currentZoom) {
            map.setView(currentCenter, currentZoom);
        }
    }

    // Draw lines only if the lines filter is not active
    if (!isLinesFilterActive) {
        drawLines(mapData.vehicle, mapData.requests, mapData.offers);
    }

    // Add request markers
    mapData.requests.forEach(function (request) {
        var icon = request.Status === 'PENDING' ? pendingRequestIcon : inProgressRequestIcon;
        var requestMarker = L.marker([request.Latitude, request.Longitude], { icon: icon });

        // Add to the respective arrays
        allMarkers.push(requestMarker);
        if (request.Status === 'INPROGRESS') {
            inProgressMarkers.push(requestMarker);
        } else if (request.Status === 'PENDING') {
            pendingMarkers.push(requestMarker);
        }

        // Add marker to the map if the filters are not active or if it should be displayed
        if ((!isInProgressFilterActive || request.Status !== 'INPROGRESS') &&
            (!isPendingFilterActive || request.Status !== 'PENDING')) {
            requestMarker.addTo(map);
        }

        requestMarker.on('click', function () {
            clearLines(); // Clear lines when clicking a new marker
            showPopup({
                type: "request-box",
                title: "Αίτημα",
                details: `
                <p><strong>Ονοματεπώνυμο:</strong> ${request.Name}</p>
                <p><strong>Τηλέφωνο:</strong> ${request.Phone}</p>
                <p><strong>Ημ/νια Καταχώρησης:</strong> ${request.DateCreated}</p>
                <p><strong>Είδη:</strong> ${request.ItemNames}</p>
                <p><strong>Ποσότητες:</strong> ${request.ItemQuantities}</p>
                ${request.Status === "INPROGRESS" ? `<p><strong>Ημ/νια Ανάληψης Οχήματος:</strong> ${request.DateAssignedVehicle}</p>` : ''}
            `
            });

            // Draw a line to the vehicle if in progress
            if (request.Status === 'INPROGRESS' && !isLinesFilterActive) {
                drawLineToVehicle(requestMarker, vehicleMarkerLatLng);
            }
        });
    });

    // Add offer markers
    mapData.offers.forEach(function (offer) {
        var icon = offer.Status === 'PENDING' ? pendingOfferIcon : inProgressOfferIcon;
        var offerMarker = L.marker([offer.Latitude, offer.Longitude], { icon: icon });

        // Add to the respective array
        allMarkers.push(offerMarker);
        offerMarkers.push(offerMarker);

        // Add marker to the map if the filter is not active
        if (!isOfferFilterActive) {
            offerMarker.addTo(map);
        }

        offerMarker.on('click', function () {
            clearLines(); // Clear lines when clicking a new marker
            showPopup({
                type: "offer-box",
                title: "Προσφορά",
                details: `
                <p><strong>Ονοματεπώνυμο:</strong> ${offer.Name}</p>
                <p><strong>Τηλέφωνο:</strong> ${offer.Phone}</p>
                <p><strong>Ημ/νια Καταχώρησης:</strong> ${offer.DateCreated}</p>
                <p><strong>Είδη:</strong> ${offer.ItemNames}</p>
                <p><strong>Ποσότητες:</strong> ${offer.ItemQuantities}</p>
                ${offer.Status === "INPROGRESS" ? `<p><strong>Ημ/νια Ανάληψης Οχήματος:</strong> ${offer.DateAssignedVehicle}</p>` : ''}
            `
            });

            // Draw a line to the vehicle if in progress
            if (offer.Status === 'INPROGRESS' && !isLinesFilterActive) {
                drawLineToVehicle(offerMarker, vehicleMarkerLatLng);
            }
        });
    });

}

// Function to toggle the filter for "Taken Requests"
function toggleInProgressRequests() {
    const button = document.getElementById('toggleTakenRequests');

    if (isInProgressFilterActive) {
        inProgressMarkers.forEach(marker => marker.addTo(map)); // Re-add in-progress markers
        button.classList.remove('active-filter');
    } else {
        inProgressMarkers.forEach(marker => map.removeLayer(marker)); // Remove in-progress markers
        button.classList.add('active-filter');
    }

    isInProgressFilterActive = !isInProgressFilterActive;
}

// Function to toggle the filter for "Pending Requests"
function togglePendingRequests() {
    const button = document.getElementById('togglePendingRequests');

    if (isPendingFilterActive) {
        pendingMarkers.forEach(marker => marker.addTo(map)); // Re-add pending markers
        button.classList.remove('active-filter');
    } else {
        pendingMarkers.forEach(marker => map.removeLayer(marker)); // Remove pending markers
        button.classList.add('active-filter');
    }

    isPendingFilterActive = !isPendingFilterActive;
}

// Function to toggle the filter for "Offers"
function toggleOffers() {
    const button = document.getElementById('toggleOffers');

    if (isOfferFilterActive) {
        offerMarkers.forEach(marker => marker.addTo(map)); // Re-add offer markers
        button.classList.remove('active-filter');
    } else {
        offerMarkers.forEach(marker => map.removeLayer(marker)); // Remove offer markers
        button.classList.add('active-filter');
    }

    isOfferFilterActive = !isOfferFilterActive;
}

// Function to toggle the filter for "Active Vehicles"
function toggleActiveVehicles() {
    const button = document.getElementById('toggleActiveVehicles');

    if (isActiveVehiclesFilterActive) {
        activeVehicleMarkers.forEach(marker => marker.addTo(map)); // Re-add active vehicle markers
        button.classList.remove('active-filter');
    } else {
        activeVehicleMarkers.forEach(marker => map.removeLayer(marker)); // Remove active vehicle markers
        button.classList.add('active-filter');
    }

    isActiveVehiclesFilterActive = !isActiveVehiclesFilterActive;
}

// Function to toggle the filter for "Inactive Vehicles"
function toggleInactiveVehicles() {
    const button = document.getElementById('toggleInactiveVehicles');

    if (isInactiveVehiclesFilterActive) {
        inactiveVehicleMarkers.forEach(marker => marker.addTo(map)); // Re-add inactive vehicle markers
        button.classList.remove('active-filter');
    } else {
        inactiveVehicleMarkers.forEach(marker => map.removeLayer(marker)); // Remove inactive vehicle markers
        button.classList.add('active-filter');
    }

    isInactiveVehiclesFilterActive = !isInactiveVehiclesFilterActive;
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

// Add event listeners for the toggle buttons
document.getElementById('toggleTakenRequests').addEventListener('click', toggleInProgressRequests);
document.getElementById('togglePendingRequests').addEventListener('click', togglePendingRequests);
document.getElementById('toggleOffers').addEventListener('click', toggleOffers);
document.getElementById('toggleActiveVehicles').addEventListener('click', toggleActiveVehicles);
document.getElementById('toggleLines').addEventListener('click', toggleLines);


// Function to show the confirmation popup
function showConfirmPopup() {
    const confirmationBox = document.getElementById('confirmationBox');
    confirmationBox.style.display = 'block';
}

// Function to confirm the new base location
function confirmBaseLocation() {
    if (newBaseLatLng) {
        // Send new base location to the server using Fetch API
        fetch('update_base_location.php', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                latitude: newBaseLatLng.lat,
                longitude: newBaseLatLng.lng
            })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Base location updated successfully!');
                    const confirmationBox = document.getElementById('confirmationBox');
                    confirmationBox.style.display = 'none';
                } else {
                    alert('Failed to update base location. ' + (data.error ? data.error : ''));
                }
            })
            .catch(error => {
                alert('Failed to send data to the server. Error: ' + error.message);
            });
    }
}


// Function to cancel the base location update
function cancelBaseLocation() {
    const confirmationBox = document.getElementById('confirmationBox');
    confirmationBox.style.display = 'none';
    newBaseLatLng = null; // Reset the new location
}

// Function to show the vehicle popup
function showPopup({ type, title, details }) {
    const popup = document.getElementById('draggableBox');
    popup.className = type;
    const popupTitle = popup.querySelector('.offer-title');
    const popupDetails = popup.querySelector('.offer-details');

    popupTitle.innerHTML = title;
    popupDetails.innerHTML = details;

    popup.style.display = 'flex';
}

// Close button event for vehicle popup
document.getElementById('closeBox').addEventListener('click', function () {
    document.getElementById('draggableBox').style.display = 'none';
    clearLines();
});

// Confirm button event for base location
document.getElementById('confirmButton').addEventListener('click', confirmBaseLocation);

// Cancel button event for base location
document.getElementById('cancelButton').addEventListener('click', cancelBaseLocation);


// Initial fetch and update of the map
fetchDataAndUpdateMap();

// Fetch and update map data every 10 seconds
setInterval(fetchDataAndUpdateMap, 10000);

// Get the popup element and close button
var externalPopup = document.getElementById('draggableBox');
var closePopup = document.getElementById('closeBox');

// Function to open the popup
function openPopup() {
    externalPopup.style.display = 'flex';
}

// Function to close the popup
function closePopupFunction() {
    externalPopup.style.display = 'none';
}

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

        // Checkbox cell
        const checkboxCell = document.createElement("td");
        const checkbox = document.createElement("input");
        checkbox.type = "checkbox";
        checkbox.classList.add("task-checkbox"); // Add custom class for styling
        checkboxCell.appendChild(checkbox);

        // Data cells
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
        row.appendChild(checkboxCell);  // Add checkbox cell to the row
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
document.addEventListener("DOMContentLoaded", function () {
    populateTaskTable();  // Populate the task table with dummy data
});
