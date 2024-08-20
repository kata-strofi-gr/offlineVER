// Initialize the map at a default position; this will be updated once the base location is fetched
var map = L.map('map').setView([51.505, -0.09], 16);

// Add a tile layer from OpenStreetMap
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 25,
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);

var baseMarker; // To store the base marker
var newBaseLatLng; // To store the new coordinates after dragging

// Custom icons for different statuses and types
var baseIcon = L.icon({
    iconUrl: 'markers/base.svg',  // Path to your custom icon
    iconSize: [35, 50],
    iconAnchor: [15, 45],
    popupAnchor: [0, -45],
});

var pendingRequestIcon = L.icon({
    iconUrl: 'markers/pendingRequestIcon_red.svg',
    iconSize: [35, 50],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
});

var inProgressRequestIcon = L.icon({
    iconUrl: 'markers/inProgressRequestIcon_green.svg',
    iconSize: [35, 50],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
});

var pendingOfferIcon = L.icon({
    iconUrl: 'markers/pendingOfferIcon_orange.svg', // Replace with your icon path
    iconSize: [35, 50],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],

});

var inProgressOfferIcon = L.icon({
    iconUrl: 'markers/inProgressOfferIcon_blue.svg', // Replace with your icon path
    iconSize: [35, 50],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
});

// Create a custom icon for the vehicle marker
var blueIcon = new L.Icon({
    iconUrl: 'markers/vehicle.svg', // Replace with your icon path
    iconSize: [35, 50],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
});

// Function to fetch data from the server and update the map
function fetchDataAndUpdateMap() {
    fetch('map_fetch.php')
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


let drawnLines = []; // To keep track of drawn lines

// Function to clear all lines from the map
function clearLines() {
    drawnLines.forEach(line => map.removeLayer(line));
    drawnLines = [];
}

// Function to draw lines between vehicle and tasks
function drawLines(vehicle, requests, offers) {
    clearLines();

    // Draw lines to assigned requests
    if (vehicle.AssignedRequests) {
        vehicle.AssignedRequests.split(',').forEach(reqID => {
            const request = requests.find(r => r.RequestID == reqID);
            if (request) {
                const line = L.polyline([[vehicle.VehicleLat, vehicle.VehicleLng], [request.RequestLat, request.RequestLng]], {
                    color: 'red'
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
                const line = L.polyline([[vehicle.VehicleLat, vehicle.VehicleLng], [offer.OfferLat, offer.OfferLng]], {
                    color: 'blue'
                }).addTo(map);
                drawnLines.push(line);
            }
        });
    }
}


// Function to update the map with base, vehicle, offer, and request data
function updateMap(mapData) {
    const base = mapData.base;

    // Set the map view to the base's location
    map.setView([base.Latitude, base.Longitude], 16);

    // Clear existing markers
    map.eachLayer(function (layer) {
        if (layer instanceof L.Marker) {
            map.removeLayer(layer);
        }
    });

    // Add the base marker with the custom icon
    baseMarker = L.marker([base.Latitude, base.Longitude], { icon: baseIcon, draggable: true })
        .addTo(map)
        .bindPopup(`<b>${base.BaseName}</b><br>Drag to change location.`)
        .openPopup();

    // Handle dragging of the base marker
    baseMarker.on('dragend', function (event) {
        newBaseLatLng = event.target.getLatLng();
        showConfirmPopup(); // Show confirmation popup when dragging ends
    });

    // Add request markers
    mapData.requests.forEach(function (request) {
        var icon = request.Status === 'PENDING' ? pendingRequestIcon : inProgressRequestIcon;
        var requestMarker = L.marker([request.RequestLat, request.RequestLng], { icon: icon });

        requestMarker.on('click', function () {
            showPopup({
                type: "request-box",
                title: "Αίτημα",
                details: `
                <p><strong>Ονοματεπώνυμο:</strong> ${request.Name}</p>
                <p><strong>Τηλέφωνο:</strong> ${request.Phone}</p>
                <p><strong>Ημ/νια Καταχώρησης:</strong> ${request.DateCreated}</p>
                <p><strong>Είδη:</strong> ${request.ItemNames}</p>
                <p><strong>Ποσότητες:</strong> ${request.ItemQuantities}</p>
                ${request.RescuerUsername ? `<p><strong>Αναλήφθηκε από:</strong> ${request.RescuerUsername}</p>` : ''}
            `
            });
            // Find and draw lines to the associated vehicle
            if (request.RescuerID) {
                const vehicle = mapData.vehicles.find(v => v.VehicleID == request.RescuerID);
                if (vehicle) {
                    drawLines(vehicle, mapData.requests, mapData.offers);
                }
            }
        });
        requestMarker.addTo(map);
    });

    // Add offer markers
    mapData.offers.forEach(function (offer) {
        var icon = offer.Status === 'PENDING' ? pendingOfferIcon : inProgressOfferIcon;
        var offerMarker = L.marker([offer.OfferLat, offer.OfferLng], { icon: icon });

        offerMarker.on('click', function () {
            showPopup({
                type: "offer-box",
                title: "Προσφορά",
                details: `
                <p><strong>Ονοματεπώνυμο:</strong> ${offer.Name}</p>
                <p><strong>Τηλέφωνο:</strong> ${offer.Phone}</p>
                <p><strong>Ημ/νια Καταχώρησης:</strong> ${offer.DateCreated}</p>
                <p><strong>Είδη:</strong> ${offer.ItemNames}</p>
                <p><strong>Ποσότητες:</strong> ${offer.ItemQuantities}</p>
                ${offer.RescuerUsername ? `<p><strong>Αναλήφθηκε από:</strong> ${offer.RescuerUsername}</p>` : ''}
            `
            });

            // Find and draw lines to the associated vehicle
            if (offer.RescuerID) {
                const vehicle = mapData.vehicles.find(v => v.VehicleID == offer.RescuerID);
                if (vehicle) {
                    drawLines(vehicle, mapData.requests, mapData.offers);
                }
            }
        });
        offerMarker.addTo(map);
    });

    // Add vehicle markers
    mapData.vehicles.forEach(function (vehicle) {
        var vehicleMarker = L.marker([vehicle.VehicleLat, vehicle.VehicleLng], { icon: blueIcon });

        vehicleMarker.on('click', function () {
            showPopup({
                type: "vehicle-box",
                title: "Όχημα",
                details: `
                <p><strong>Διακριτικό Οχήματος:</strong> ${vehicle.RescuerUsername}</p>
                <p><strong>Φορτίο:</strong> ${vehicle.Load}</p>
                <p><strong>Κατάσταση:</strong> ${vehicle.Status}</p>
                <p><strong>Ενεργά Tasks:</strong> ${vehicle.ActiveTasks > 0 ? 'Ναι' : 'Όχι'}</p>
            `
            });

            // Draw lines for the selected vehicle
            drawLines(vehicle, mapData.requests, mapData.offers);
        });
        vehicleMarker.addTo(map);
    });
}


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
});

// Confirm button event for base location
document.getElementById('confirmButton').addEventListener('click', confirmBaseLocation);

// Cancel button event for base location
document.getElementById('cancelButton').addEventListener('click', cancelBaseLocation);


// Initial fetch and update of the map
fetchDataAndUpdateMap();

// Fetch and update map data every 20 seconds
setInterval(fetchDataAndUpdateMap, 20000);

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

// Add event listeners
marker.on('click', openPopup);
closePopup.addEventListener('click', closePopupFunction);

// Optional: Open popup on page load
// openPopup();
document.getElementById('stockManage').addEventListener('click', function (e) {
    e.preventDefault(); // Prevent default link behavior
    showStockManage();
});
document.getElementById('stockStatus').addEventListener('click', function (e) {
    e.preventDefault(); // Prevent default link behavior
    showStockManage();
});
document.getElementById('statistikaShow').addEventListener('click', function (e) {
    e.preventDefault(); // Prevent default link behavior
    showStatistika();
});
document.getElementById('newsCreate').addEventListener('click', function (e) {
    e.preventDefault(); // Prevent default link behavior
    newAithma();
});
document.getElementById('rescuerCreate').addEventListener('click', function (e) {
    e.preventDefault(); // Prevent default link behavior
    newDiasostis();
});

// Logout dummy function
document.getElementById('loggout').addEventListener('click', function (e) {
    e.preventDefault(); // Prevent default link behavior
    window.location.href = 'http://127.0.0.1:5500/start.html#';
});


//leitourgies parathiron apo to menu
function newAithma() {
    //to parakato pernaei
    var contentSection = document.getElementById('newAithmata');
    //ta parakato kovontai
    var mapContainer = document.getElementById('mapContainerI');
    var contentSectionX = document.getElementById('newDiasosths');
    var contentSectionX2 = document.getElementById('statistikoulia');
    var contentSectionX3 = document.getElementById('chartContainer');
    var contentSectionX4 = document.getElementById('stockW');
    //pernaei
    contentSection.style.display = 'block';
    //kovontai
    mapContainer.style.display = 'none';
    contentSectionX.style.display ='none';
    contentSectionX2.style.display ='none';
    contentSectionX3.style.display ='none';
    contentSectionX4.style.display ='none';
}

function newDiasostis() {
    //to parakato pernaei
    var contentSection = document.getElementById('newDiasosths');
    //ta parakato kruvontai
    var mapContainer = document.getElementById('mapContainerI');
    var contentSectionX = document.getElementById('newAithmata');
    var contentSectionX2 = document.getElementById('statistikoulia');
    var contentSectionX3 = document.getElementById('chartContainer');
    var contentSectionX4 = document.getElementById('stockW');
    //pernaei
    contentSection.style.display = 'block';
    //kovontai
    contentSectionX.style.display ='none';
    contentSectionX2.style.display ='none';
    contentSectionX3.style.display ='none';
    contentSectionX4.style.display ='none';
    mapContainer.style.display = 'none';
}

function showStatistika() {
    //to parakato pernaei
    var contentSection = document.getElementById('statistikoulia');
    //ta parakato kovontai
    var mapContainer = document.getElementById('mapContainerI');
    var contentSectionX = document.getElementById('newDiasosths');
    var contentSectionX2 = document.getElementById('newAithmata');
    var contentSectionX4 = document.getElementById('stockW');
    //pernaei
    contentSection.style.display = 'block';
    //kovontai
    mapContainer.style.display = 'none';
    contentSectionX.style.display ='none';
    contentSectionX2.style.display ='none';
    contentSectionX4.style.display ='none';
}

function showStockManage() {
    //to parakato pernaei
    var contentSection = document.getElementById('stockW');
    //ta parakato kruvontai
    var mapContainer = document.getElementById('mapContainerI');
    var contentSectionX = document.getElementById('newAithmata');
    var contentSectionX2 = document.getElementById('statistikoulia');
    var contentSectionX3 = document.getElementById('chartContainer');
    var contentSectionX4 = document.getElementById('newDiasosths');
    //pernaei
    contentSection.style.display = 'block';
    //kovontai
    contentSectionX.style.display ='none';
    contentSectionX2.style.display ='none';
    contentSectionX3.style.display ='none';
    contentSectionX4.style.display ='none';
    mapContainer.style.display = 'none';
}

//anakateuthinsi sthn admin othoni
document.getElementById('logoF').addEventListener('click', function(e) {
    e.preventDefault();
    var mapContainer = document.getElementById('mapContainerI');
    var contentSectionX = document.getElementById('newAithmata');
    var contentSectionX2 = document.getElementById('statistikoulia');
    var contentSection = document.getElementById('newDiasosths');
    var contentSectionX3 = document.getElementById('chartContainer');
    var contentSectionX4 = document.getElementById('stockW');

    mapContainer.style.display = 'block';
    contentSection.style.display = 'none';
    contentSectionX.style.display = 'none';
    contentSectionX2.style.display = 'none';
    contentSectionX3.style.display = 'none';
    contentSectionX4.style.display = 'none';
});




//extra aithmata
document.addEventListener("DOMContentLoaded", function() {
    var addButton = document.querySelector(".btn.add-fields");
    var additionalFields = document.getElementById("additionalFields");

    addButton.addEventListener("click", function() {
        // Clear previous fields
        additionalFields.innerHTML = '';

        // Get the number of extra requests
        var extraRequests = document.getElementById("extraRequests").value;
        var extraCount = parseInt(extraRequests);

        // Validate the input
        if (isNaN(extraCount) || extraCount < 1) {
            alert("Please enter a valid number of extra requests.");
            return;
        }

        // Add new sets of fields based on the number entered
        for (var i = 1; i <= extraCount; i++) {
            var typeLabel = document.createElement("label");
            typeLabel.textContent = "Είδος " + i;
            var typeSelect = document.createElement("select");
            typeSelect.name = "extraType" + i;
            typeSelect.innerHTML = `
                <option value="" disabled selected>Επιλέξτε είδος</option>
                <option value="option1">Option 1</option>
                <option value="option2">Option 2</option>
                <option value="option3">Option 3</option>
            `;

            var quantityLabel = document.createElement("label");
            quantityLabel.textContent = "Ποσότητα " + i;
            var quantityInput = document.createElement("input");
            quantityInput.type = "text";
            quantityInput.name = "extraQuantity" + i;
            quantityInput.placeholder = "Ποσότητα";

            additionalFields.appendChild(typeLabel);
            additionalFields.appendChild(typeSelect);
            additionalFields.appendChild(quantityLabel);
            additionalFields.appendChild(quantityInput);
        }
    });
});




$(function() {
    $(".datepicker").datepicker({
        dateFormat: "yy-mm-dd",
        showAnim: "slideDown"
    });
});

// Mock data for the line chart
const labels = ['Εβδομάδα 1', 'Εβδομάδα 2', 'Εβδομάδα 3', 'Εβδομάδα 4', 'Εβδομάδα 5'];
const newRequests = [30, 40, 35, 50, 55];
const newOffers = [25, 35, 30, 45, 50];
const completedRequests = [20, 30, 25, 40, 45];
const completedOffers = [15, 25, 20, 35, 90];

const data = {
    labels: labels,
    datasets: [
        {
            label: 'Νέα αιτήματα',
            data: newRequests,
            borderColor: '#FA4343',
            backgroundColor: '#FA4343',
            fill: false
        },
        {
            label: 'Νέες προσφορές',
            data: newOffers,
            borderColor: '#36A2EB',
            backgroundColor: '#36A2EB',
            fill: false
        },
        {
            label: 'Ολοκληρωμένα αιτήματα',
            data: completedRequests,
            borderColor: '#4BC0C0',
            backgroundColor: '#4BC0C0',
            fill: false
        },
        {
            label: 'Ολοκληρωμένες προσφορές',
            data: completedOffers,
            borderColor: '#FFCE56',
            backgroundColor: '#FFCE56',
            fill: false
        }
    ]
};

let chartInstance = null;

const config = {
    type: 'line',
    data: data,
    options: {
        responsive: true,
        plugins: {
            legend: {
                position: 'top',
            },
            tooltip: {
                mode: 'index',
                intersect: false,
            },
        },
        hover: {
            mode: 'nearest',
            intersect: true
        },
        scales: {
            x: {
                display: true,
                title: {
                    display: true,
                    text: 'Weeks'
                }
            },
            y: {
                display: true,
                title: {
                    display: true,
                    text: 'Count'
                }
            }
        }
    }
};

document.getElementById('showChartButton').addEventListener('click', function() {
    const chartContainer = document.getElementById('chartContainer');
    chartContainer.style.display = 'block';

    if (chartInstance) {
        chartInstance.destroy();  // Destroy the old chart instance
    }

    const ctx = document.getElementById('lineChart').getContext('2d');
    chartInstance = new Chart(ctx, config);  // Create a new chart instance
});


// Mock data for the table
const mockData = [
    
        { category: 'Τρόφιμα', name: 'Ψωμί', description: '500g, Πακέτο', quantity: 100, location: 'Αποθήκη', id: 1 },
        { category: 'Τρόφιμα', name: 'Ρύζι', description: '1kg, Σακούλα', quantity: 200, location: 'Αποθήκη', id: 2 },
        { category: 'Τρόφιμα', name: 'Ζυμαρικά', description: '500g, Πακέτο', quantity: 150, location: 'Αποθήκη', id: 3 },
        { category: 'Υγειονομικό Υλικό', name: 'Γάζες', description: '10τμχ, Πακέτο', quantity: 50, location: 'Αποθήκη', id: 4 },
        { category: 'Υγειονομικό Υλικό', name: 'Αντισηπτικά', description: '100ml, Μπουκάλι', quantity: 75, location: 'Αποθήκη', id: 5 },
        { category: 'Ρουχισμός', name: 'Κουβέρτες', description: '1τμχ, Φλις', quantity: 120, location: 'Αποθήκη', id: 6 },
        { category: 'Ρουχισμός', name: 'Ρούχα', description: 'Διάφορα μεγέθη, Κουτί', quantity: 60, location: 'Αποθήκη', id: 7 },
        { category: 'Νερό', name: 'Εμφιαλωμένο νερό', description: '1.5L, Μπουκάλι', quantity: 300, location: 'Αποθήκη', id: 8 },
        { category: 'Φάρμακα', name: 'Παυσίπονα', description: '20τμχ, Κουτί', quantity: 100, location: 'Αποθήκη', id: 9 },
        { category: 'Φάρμακα', name: 'Αντιβιοτικά', description: '10τμχ, Κουτί', quantity: 50, location: 'Αποθήκη', id: 10 },
        { category: 'Τρόφιμα', name: 'Κονσέρβες', description: '400g, Κονσέρβα', quantity: 180, location: 'Αποθήκη', id: 11 },
        { category: 'Υγειονομικό Υλικό', name: 'Μάσκες', description: '50τμχ, Πακέτο', quantity: 200, location: 'Αποθήκη', id: 12 },
        { category: 'Νερό', name: 'Εμφιαλωμένο νερό', description: '500ml, Μπουκάλι', quantity: 500, location: 'Αποθήκη', id: 13 },
        { category: 'Φάρμακα', name: 'Αντιφλεγμονώδη', description: '20τμχ, Κουτί', quantity: 70, location: 'Αποθήκη', id: 14 },
        { category: 'Ρουχισμός', name: 'Κάλτσες', description: '10τμχ, Πακέτο', quantity: 90, location: 'Αποθήκη', id: 15 }
    
    
    // Add more mock data as needed
];

function populateTable(data) {
    const tableBody = document.querySelector('#dataTable tbody');
    tableBody.innerHTML = '';

    data.forEach(row => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${row.category}</td>
            <td>${row.name}</td>
            <td>${row.description}</td>
            <td>${row.quantity}</td>
            <td>${row.location}</td>
            <td>${row.id}</td>
        `;
        tableBody.appendChild(tr);
    });
}

// Populate table with initial mock data
populateTable(mockData);

// Filter functionality
document.getElementById('filterType').addEventListener('change', function() {
    const filterValue = this.value;
    let filteredData = mockData;

    if (filterValue !== 'all') {
        filteredData = mockData.filter(row => row.category.toLowerCase() === filterValue.toLowerCase());
    }

    populateTable(filteredData);
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
