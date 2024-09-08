/**
 * Cookies management
 */
function checkSession() {
    //todo: add functionality for logout, keep logged in etc?
    var sessionCookie = getCookie('citizen_session');
    var citizenID = localStorage.getItem('citizen_id');

    if (!sessionCookie || !citizenID) {
        // If the session cookie is missing or expired, redirect to login
        window.location.href = '/start.html';
    }
}

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

/**
 * Global variables
 */
var requestsData;
var offersData;
var announcementsData;
var allItemCategories;
var allItems;

/**
 * Event Listeners
 */
document.addEventListener("DOMContentLoaded", function () {
    //todo: refetch
    requestsData = fetchRequests();
    offersData = fetchOffers();
    announcementsData = fetchAnnouncements();
    allItemCategories = fetchCategories();
    allItems = fetchItems();

    checkSession();  // Initial check //TODO: make this run immediately?
    setInterval(checkSession, 60000);  // Check every 1 minute

});

const categorySelect = document.getElementById('category');
categorySelect.addEventListener('change', function () {
    allItems.then(items => {
        populateRequestItems(items);
    });
});

const requestsScreenButton = document.getElementById('requestsScreen');
requestsScreenButton.addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    showRequestsScreen();
});

const offersScreenButton = document.getElementById('offersScreen');
offersScreenButton.addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    showOffersScreen();
});

//todo: aposindesi dummy
const logoutButton = document.getElementById('logout');
logoutButton.addEventListener('click', function(e) {
    e.preventDefault(); // Prevent default link behavior
    window.location.href = 'http://127.0.0.1:5500/start.html#';
});

/**
 * Mobile frontend  //todo: this doesn't do anything??
 */
const menuItems = document.querySelectorAll('.menu-item');
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

/**
 * Frontend Functions
 */
function toggleMenu() {
    const menuBar = document.querySelector('.menu-bar');
    menuBar.style.display = menuBar.style.display === 'flex' ? 'none' : 'flex';
}

function showRequestsScreen() {
    var contentSection1 = document.getElementById('newRequest');
    var contentSection2 = document.getElementById('historyR');
    var contentSection3 = document.getElementById('offerG');
    var contentSection4 = document.getElementById('offerGH');

    contentSection1.style.display = 'block';
    contentSection2.style.display = 'flex';
    contentSection3.style.display = 'none';
    contentSection4.style.display = 'none';

    allItemCategories.then(categories => {
        populateRequestCategories(categories);
    });

    requestsData.then(requests => {
        populateRequestHistory(requests);
    });
    
}

function showOffersScreen(){
    var contentSection1 = document.getElementById('newRequest');
    var contentSection2 = document.getElementById('historyR');
    var contentSection3 = document.getElementById('offerG');
    var contentSection4 = document.getElementById('offerGH');

    contentSection1.style.display = 'none';
    contentSection2.style.display = 'none';
    contentSection3.style.display = 'block';
    contentSection4.style.display = 'block';

    offersData.then(offers => {
        populateOfferHistory(offers);
    });

    announcementsData.then(announcements => {
        populateNewOffer(announcements);
    });
}

function populateRequestCategories(data) {
    const categoryList = document.getElementById('category');
    
    categoryList.innerHTML = `
            <option value="" disabled selected>Επιλέξτε κατηγορία</option>
            <option value="all">All</option>
                `;
    data.forEach(row => {

        const category = row.CategoryName;
        const id = row.CategoryID;

        let categoryOption = document.createElement('option');
            categoryOption.innerHTML = category;
            categoryOption.setAttribute('value', id);
            categoryList.appendChild(categoryOption);
        
    });
}

function populateRequestItems(data) {
    const newRequestTable = document.getElementById('newRequest');
    const categoryList = newRequestTable.querySelector('#category');
    const itemsList = newRequestTable.querySelector('#itemsList');
    const selectedCategory = categoryList.value;

    itemsList.innerHTML = '';

    if (selectedCategory === 'all') {
        data.forEach(item => {
            let option = document.createElement('option');
            option.value = item.Name;
            itemsList.appendChild(option);
        });
    } else {
        const filteredItems = data.filter(item => item.CategoryID === selectedCategory);
        filteredItems.forEach(item => {
            let option = document.createElement('option');
            option.value = item.Name;
            itemsList.appendChild(option);
        });
    }
}

function populateRequestHistory(data) {
    const tableBody = document.querySelector('#dataTable tbody');
    tableBody.innerHTML = '';

    data.forEach(row => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${row.Name}</td>
            <td>${row.CategoryName}</td>
            <td>${row.Quantity}</td>
            <td>${row.DateCreated}</td>
            <td>${row.DateAssignedVehicle}</td> 
            <td>${row.DateFinished}</td>
        `; //TODO: dates are messed up
        tableBody.appendChild(tr);
    });
}

function populateNewOffer(data) {
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

function populateOfferHistory(data) {
    const tableBody = document.querySelector('#dataTable2 tbody');
    tableBody.innerHTML = '';

    data.forEach(row => {
        const tr = document.createElement('tr');
        tr.innerHTML = `
            <td>${row.Name}</td>
            <td>${row.CategoryName}</td>
            <td>${row.Quantity}</td>
            <td>${row.DateCreated}</td>
            <td>${row.DateAssignedVehicle}</td> 
            <td>${row.DateFinished}</td> 
        `; //TODO: dates are messed up
        tableBody.appendChild(tr);
    });
}

/**
 * Backend Functions
 */
function fetchCategories() {
    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        xhr.open('GET', '../fetch_categories.php/', true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                resolve(JSON.parse(xhr.responseText));
            } else {
                console.error('Failed to fetch all categories data');
                resolve([]);
            }
        };

        xhr.onerror = function () {
            console.error('Request error fetching categories');
            resolve([]);
        };


        xhr.send();
    });
}

function fetchItems() {
    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        xhr.open('GET', '../fetch_items.php', true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                resolve(JSON.parse(xhr.responseText));
            } else {
                console.error('Failed to fetch all items data');
                resolve([]);
            }
        };

        xhr.onerror = function () {
            console.error('Request error fetching items');
            resolve([]);
        };

        xhr.send();
    });
}

function fetchRequests() {
    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        let citizen_id = localStorage.getItem('citizen_id');
        xhr.open('GET', 'fetch_citizen_requests.php/' + citizen_id, true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                resolve(JSON.parse(xhr.responseText));
            } else {
                console.error('Failed to fetch requests data');
                resolve([]);
            }
        };

        xhr.onerror = function () {
            console.error('Request error fetching requests');
            resolve([]);
        };

        xhr.send();
    });
};

function fetchOffers() {
    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        let citizen_id = localStorage.getItem('citizen_id');
        xhr.open('GET', 'fetch_citizen_offers.php/' + citizen_id, true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                resolve(JSON.parse(xhr.responseText));
            } else {
                console.error('Failed to fetch offers data');
                resolve([]);
            }
        };

        xhr.onerror = function () {
            console.error('Request error fetching offers');
            resolve([]);
        };

        xhr.send();
    });
};

function fetchAnnouncements() {
    return new Promise((resolve, reject) => {
        const xhr = new XMLHttpRequest();
        xhr.open('GET', '../fetch_announcements_detailed.php', true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                resolve(JSON.parse(xhr.responseText));
            } else {
                console.error('Failed to fetch announcements data');
                resolve([]);
            }
        };

        xhr.onerror = function () {
            console.error('Request error fetching announcements');
            resolve([]);
        };

        xhr.send();
    });
}
