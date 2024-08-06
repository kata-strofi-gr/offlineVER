// Initialize the map
var map = L.map('map').setView([51.505, -0.09], 13);

// Add a tile layer from OpenStreetMap
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 19, // Adjusted maxZoom level
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
}).addTo(map);

document.addEventListener("DOMContentLoaded", function () {
    const draggableBox = document.getElementById("draggableBox");
    let offsetX = 0, offsetY = 0, isDragging = false;

    draggableBox.addEventListener("mousedown", function (e) {
        isDragging = true;
        offsetX = e.clientX - draggableBox.getBoundingClientRect().left;
        offsetY = e.clientY - draggableBox.getBoundingClientRect().top;
        draggableBox.style.position = 'absolute';
        draggableBox.style.zIndex = 1000;
    });

    document.addEventListener("mousemove", function (e) {
        if (isDragging) {
            draggableBox.style.left = `${e.clientX - offsetX}px`;
            draggableBox.style.top = `${e.clientY - offsetY}px`;
        }
    });

    document.addEventListener("mouseup", function () {
        isDragging = false;
    });
});



// Create a custom icon for the marker
var blueIcon = new L.Icon({
    iconUrl: 'https://cdn.jsdelivr.net/gh/pointhi/leaflet-color-markers@master/img/marker-icon-blue.png',
    shadowUrl: 'https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/images/marker-shadow.png',
    iconSize: [25, 41],
    iconAnchor: [12, 41],
    popupAnchor: [1, -34],
    shadowSize: [41, 41]
});

// Add a marker with the custom icon
var marker = L.marker([51.505, -0.09], {icon: blueIcon}).addTo(map);

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
document.getElementById('stockManage').addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    showStockManage();
});
document.getElementById('stockStatus').addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    showStockManage();
});
document.getElementById('statistikaShow').addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    showStatistika();
});
document.getElementById('newsCreate').addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    newAithma();
});
document.getElementById('rescuerCreate').addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    newDiasostis();
});

//aposindesi dummy
document.getElementById('loggout').addEventListener('click', function(e) {
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
