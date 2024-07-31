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
document.getElementById('newsCreate').addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    newAithma();
});
document.getElementById('rescuerCreate').addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    showStockManage();
});
document.getElementById('loggout').addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    window.location.href = 'http://127.0.0.1:5500/start.html#';
});

//leitourgies parathiron apo to menu
function newAithma() {
    var mapContainer = document.getElementById('mapContainerI');
    var contentSection = document.getElementById('newAithmata');

    mapContainer.style.display = 'none';
    contentSection.style.display = 'block';
}

//anakateuthinsi sthn admin othoni
document.getElementById('logoF').addEventListener('click', function(e) {
    e.preventDefault();
    var mapContainer = document.getElementById('mapContainerI');
    var requestSection = document.getElementById('newAithmata');

    mapContainer.style.display = 'block';
    requestSection.style.display = 'none';
});