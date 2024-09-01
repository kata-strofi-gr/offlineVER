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

    let requestItems = [];
    let offerItems = [];

    function fetchRequestData() {
        const xhr = new XMLHttpRequest();
        let userID = sessionStorage.getItem('userID');
        xhr.open('GET', 'fetch_citizen_request.php/' + userID, true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                requestItems = JSON.parse(xhr.responseText);
                populateTable(requestItems);
            } else {
                console.error('Failed to fetch data');
            }
        };

        xhr.send();
    };

    function fetchOfferData() {
        const xhr = new XMLHttpRequest();
        let userID = sessionStorage.getItem('userID');
        xhr.open('GET', 'fetch_citizen_offer.php/' + userID, true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                offerItems = JSON.parse(xhr.responseText);
                populateTable2(offerItems);
            } else {
                console.error('Failed to fetch data');
            }
        };

        xhr.send();
    };

    fetchRequestData();
    fetchOfferData();

});

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

// Optional: Open popup on page load
// openPopup();
document.getElementById('aithmataaShow').addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    showaithmata();
});

document.getElementById('prosforessShow').addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    showprosfores();
});

//aposindesi dummy
document.getElementById('loggout').addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    window.location.href = 'http://127.0.0.1:5500/start.html#';
});

//leitourgies parathiron apo to menu
function showaithmata() {
    //to parakato pernaei
    var contentSection = document.getElementById('newAithmata2');
    var contentSection2 = document.getElementById('historyR');
    var contentSection3 = document.getElementById('offerG');
    var contentSection4 = document.getElementById('offerGH');
    //ta parakato kovontai
    
    //pernaei
    contentSection.style.display = 'block';
    contentSection2.style.display = 'block';
    //kovontai
    contentSection3.style.display = 'none';
    contentSection4.style.display = 'none';
    
}

function showprosfores(){
    var contentSection = document.getElementById('newAithmata2');
    var contentSection2 = document.getElementById('historyR');
    var contentSection3 = document.getElementById('offerG');
    var contentSection4 = document.getElementById('offerGH');

    contentSection3.style.display = 'block';
    contentSection4.style.display = 'block';

    contentSection.style.display = 'none';
    contentSection2.style.display = 'none';
}

//anakateuthinsi sthn admin othoni
document.getElementById('logoF').addEventListener('click', function(e) {
    e.preventDefault();
    var contentSection = document.getElementById('newAithmata2');
    var contentSection2 = document.getElementById('historyR')
    var contentSection3 = document.getElementById('offerG');
    var contentSection4 = document.getElementById('offerGH');

    
    contentSection.style.display = 'none';
    contentSection2.style.display = 'none';
    contentSection3.style.display = 'none';
    contentSection4.style.display = 'none';
    
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

function populateTable(data) {
    const tableBody = document.querySelector('#dataTable tbody');
    tableBody.innerHTML = '';

    data.forEach(row => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${row.Name}</td>
            <td>${row.Category}</td>
            <td>${row.Quantity}</td>
            <td>${row.DateCreated}</td>
            <td>${row.DateAssignedVehicle}</td> 
        `; //TODO: dates are messed up
        tableBody.appendChild(tr);
    });
}

// Filter functionality


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


const newMockData = [
    { category: 'Ψωμί', quantity: 100, id: 1 },
    { category: 'Ρύζι', quantity: 200, id: 2 },
    { category: 'Ζυμαρικά', quantity: 150, id: 3 },
    { category: 'Γάζες', quantity: 50, id: 4 },
    { category: 'Αντισηπτικά', quantity: 75, id: 5 },
    { category: 'Κουβέρτες', quantity: 120, id: 6 },
    { category: 'Ρούχα', quantity: 60, id: 7 },
    { category: 'Εμφιαλωμένο νερό', quantity: 300, id: 8 },
    { category: 'Παυσίπονα', quantity: 100, id: 9 },
    { category: 'Αντιβιοτικά', quantity: 50, id: 10 },
    { category: 'Κονσέρβες', quantity: 180, id: 11 },
    { category: 'Μάσκες', quantity: 200, id: 12 },
    { category: 'Εμφιαλωμένο νερό', quantity: 500, id: 13 },
    { category: 'Αντιφλεγμονώδη', quantity: 70, id: 14 },
    { category: 'Κάλτσες', quantity: 90, id: 15 }
    // Add more mock data as needed
];

function populateNewTable(data) {
    const tableBody = document.querySelector('#newDataTable tbody');
    tableBody.innerHTML = '';

    data.forEach(row => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${row.category}</td>
            <td>${row.quantity}</td>
            <td><input type="checkbox" data-id="${row.id}"></td>
        `;
        tableBody.appendChild(tr);
    });
}

populateNewTable(newMockData);


const mockData2 = [
    { type: 'Τρόφιμα', category: 'Ψωμί', quantity: 100, dateACC: '2024-01-01', dateCOL: '2024-01-10', id: 1 },
    { type: 'Τρόφιμα', category: 'Ρύζι', quantity: 200, dateACC: '2024-01-02', dateCOL: '2024-01-11', id: 2 },
    { type: 'Τρόφιμα', category: 'Ζυμαρικά', quantity: 150, dateACC: '2024-01-03', dateCOL: '2024-01-12', id: 3 },
    { type: 'Υγειονομικό Υλικό', category: 'Γάζες', quantity: 50, dateACC: '2024-01-04', dateCOL: '2024-01-13', id: 4 },
    { type: 'Υγειονομικό Υλικό', category: 'Αντισηπτικά', quantity: 75, dateACC: '2024-01-05', dateCOL: '2024-01-14', id: 5 },
    { type: 'Ρουχισμός', category: 'Κουβέρτες', quantity: 120, dateACC: '2024-01-06', dateCOL: '2024-01-15', id: 6 },
    { type: 'Ρουχισμός', category: 'Ρούχα', quantity: 60, dateACC: '2024-01-07', dateCOL: '2024-01-16', id: 7 },
    { type: 'Νερό', category: 'Εμφιαλωμένο νερό', quantity: 300, dateACC: '2024-01-08', dateCOL: '2024-01-17', id: 8 },
    { type: 'Φάρμακα', category: 'Παυσίπονα', quantity: 100, dateACC: '2024-01-09', dateCOL: '2024-01-18', id: 9 },
    { type: 'Φάρμακα', category: 'Αντιβιοτικά', quantity: 50, dateACC: '2024-01-10', dateCOL: '2024-01-19', id: 10 },
    { type: 'Τρόφιμα', category: 'Κονσέρβες', quantity: 180, dateACC: '2024-01-11', dateCOL: '2024-01-20', id: 11 },
    { type: 'Υγειονομικό Υλικό', category: 'Μάσκες', quantity: 200, dateACC: '2024-01-12', dateCOL: '2024-01-21', id: 12 },
    { type: 'Νερό', category: 'Εμφιαλωμένο νερό', quantity: 500, dateACC: '2024-01-13', dateCOL: '2024-01-22', id: 13 },
    { type: 'Φάρμακα', category: 'Αντιφλεγμονώδη', quantity: 70, dateACC: '2024-01-14', dateCOL: '2024-01-23', id: 14 },
    { type: 'Ρουχισμός', category: 'Κάλτσες', quantity: 90, dateACC: '2024-01-15', dateCOL: '2024-01-24', id: 15 }
    // Add more mock data as needed
];

function populateTable2(data) {
    const tableBody = document.querySelector('#dataTable2 tbody');
    tableBody.innerHTML = '';

    data.forEach(row => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${row.Name}</td>
            <td>${row.Category}</td>
            <td>${row.Quantity}</td>
            <td>${row.DateCreated}</td>
            <td>${row.DateAssignedVehicle}</td> 
        `; //TODO: dates are messed up
        tableBody.appendChild(tr);
    });
}
// Populate table with initial mock data
populateTable2(mockData2);

// Filter functionality