// Function to populate the vehicle management table with data from the backend
function populateVehicleTable() {
    const rescuer_id = localStorage.getItem('rescuer_id');  // Assuming rescuer_id is stored in localStorage

    // Fetch vehicle data for the rescuer from the backend
    fetch(`api/get_vehicle_data.php?rescuer_id=${rescuer_id}`)
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                alert('Error fetching vehicle data: ' + data.error);
                return;
            }

            // Get the table body element
            const tableBody = document.querySelector('#dataTable tbody');
            tableBody.innerHTML = '';  // Clear the table first

            // Populate the table with data
            data.data.forEach(item => {
                const row = document.createElement('tr');

                // Create cells for each piece of data
                const categoryCell = document.createElement('td');
                categoryCell.textContent = item.CategoryName;

                const nameCell = document.createElement('td');
                nameCell.textContent = item.Name;

                const detailNameCell = document.createElement('td');
                detailNameCell.textContent = item.DetailName;

                const detailValueCell = document.createElement('td');
                detailValueCell.textContent = item.DetailValue;

                const quantityCell = document.createElement('td');
                quantityCell.textContent = item.Quantity;

                // Append cells to the row
                row.appendChild(categoryCell);
                row.appendChild(nameCell);
                row.appendChild(detailNameCell);
                row.appendChild(detailValueCell);
                row.appendChild(quantityCell);

                // Append the row to the table body
                tableBody.appendChild(row);
            });
        })
        .catch(error => {
            console.error('Error fetching vehicle data:', error);
        });
}

// Function to populate the warehouse table with data from the backend
function populateWarehouseTable() {
    // Fetch warehouse data from the backend
    fetch(`api/get_warehouse_data.php`)
        .then(response => response.json())
        .then(data => {
            if (data.error) {
                alert('Error fetching warehouse data: ' + data.error);
                return;
            }

            // Get the table body element
            const tableBody = document.querySelector('#secondTable tbody');
            tableBody.innerHTML = '';  // Clear the table first

            // Populate the table with data
            data.data.forEach(item => {
                const row = document.createElement('tr');

                // Create cells for each piece of data
                const categoryCell = document.createElement('td');
                categoryCell.textContent = item.CategoryName;

                const nameCell = document.createElement('td');
                nameCell.textContent = item.Name;

                const detailNameCell = document.createElement('td');
                detailNameCell.textContent = item.DetailName;

                const detailValueCell = document.createElement('td');
                detailValueCell.textContent = item.DetailValue;

                const quantityCell = document.createElement('td');
                quantityCell.textContent = item.Quantity;

                // Append cells to the row
                row.appendChild(categoryCell);
                row.appendChild(nameCell);
                row.appendChild(detailNameCell);
                row.appendChild(detailValueCell);
                row.appendChild(quantityCell);

                // Append the row to the table body
                tableBody.appendChild(row);
            });
        })
        .catch(error => {
            console.error('Error fetching warehouse data:', error);
        });
}

// Ensure both functions run on page load to populate the tables
window.onload = function() {
    populateVehicleTable();   // Populate vehicle data on page load
    populateWarehouseTable(); // Populate warehouse data on page load

    // Refresh the table data every 10 seconds (10000 milliseconds)
    setInterval(populateVehicleTable, 10000);
    setInterval(populateWarehouseTable, 10000);
};

// Ensure the function runs on page load
window.onload = function() {
    populateVehicleTable();  // Populate the table with dummy data on page load
    populateWarehouseTable();
};

// Function to dynamically add new sets of fields for multiple items
function addDynamicFields() {
    const additionalFields = document.getElementById('additionalFields');
    const extraRequests = document.getElementById('extraRequests').value;  // Number of items
    const extraCount = parseInt(extraRequests);

    // Clear previous fields
    additionalFields.innerHTML = '';

    // Validate input
    if (isNaN(extraCount) || extraCount < 1) {
        alert("Please enter a valid number of items.");
        return;
    }

    // Add new sets of fields based on the number entered
    for (let i = 1; i <= extraCount; i++) {
        // Create label and dropdown for item type
        const typeLabel = document.createElement("label");
        typeLabel.textContent = "Είδος " + i;
        const typeSelect = document.createElement("select");
        typeSelect.name = "extraType" + i;

        // Populate the select dropdown with available items (dummy items used here)
        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.disabled = true;
        defaultOption.selected = true;
        defaultOption.textContent = 'Επιλέξτε είδος';
        typeSelect.appendChild(defaultOption);

        const items = ['Item 1', 'Item 2', 'Item 3'];  // Replace with actual warehouse items
        items.forEach(item => {
            const option = document.createElement('option');
            option.value = item;
            option.textContent = item;
            typeSelect.appendChild(option);
        });

        // Create label and input for quantity
        const quantityLabel = document.createElement("label");
        quantityLabel.textContent = "Ποσότητα " + i;
        const quantityInput = document.createElement("input");
        quantityInput.type = "number";
        quantityInput.name = "extraQuantity" + i;
        quantityInput.placeholder = "Ποσότητα";

        // Append the new fields to the form
        additionalFields.appendChild(typeLabel);
        additionalFields.appendChild(typeSelect);
        additionalFields.appendChild(quantityLabel);
        additionalFields.appendChild(quantityInput);
    }
}

// Event listener for "Προσθήκη" button
document.addEventListener('DOMContentLoaded', function () {
    const addButton = document.querySelector(".btn.add-fields");
    addButton.addEventListener('click', addDynamicFields);
    
    // Event listener for submitting the form (Φόρτωση or Εκφόρτωση buttons)
    const submitButton = document.getElementById('anasub');
    submitButton.addEventListener('click', function (event) {
        event.preventDefault();  // Prevent default form submission

        // Get main type and quantity
        const type = document.getElementById('type').value;
        const quantity = document.getElementById('quantity').value;

        // Collect additional items from dynamic fields
        const items = [{ name: type, quantity: parseInt(quantity) }];
        const extraFields = document.getElementById('additionalFields').children;
        for (let i = 0; i < extraFields.length; i += 4) {
            const extraType = extraFields[i + 1].value;
            const extraQuantity = extraFields[i + 3].value;
            if (extraType && extraQuantity) {
                items.push({ name: extraType, quantity: parseInt(extraQuantity) });
            }
        }

        // Mock functionality: Process the items as needed
        console.log(items);
        alert('Επιτυχής Φόρτωση/Εκφόρτωση. Τα αντικείμενα που καταχωρήθηκαν: ' + JSON.stringify(items));
    });
});


document.addEventListener('DOMContentLoaded', function () {
    // Populate the initial dropdown with dummy data
    populateItems();

    // Set event listeners for buttons
    document.querySelector('.btn.add-fields').addEventListener('click', addDynamicFields);
    document.getElementById('anasub').addEventListener('click', loadItems);
    document.getElementById('unloadBtn').addEventListener('click', unloadItems);
});

// Function to populate the initial dropdown with dummy data
function fetchAndPopulateItems() {
    fetch('../fetch_items.php')
        .then(response => response.json())
        .then(items => {
            // Populate the main type dropdown
            const typeSelect = document.getElementById('type');
            typeSelect.innerHTML = ''; // Clear existing options

            // Add default option
            const defaultOption = document.createElement('option');
            defaultOption.value = '';
            defaultOption.disabled = true;
            defaultOption.selected = true;
            defaultOption.textContent = 'Επιλέξτε είδος';
            typeSelect.appendChild(defaultOption);

            // Populate options with items fetched from the server
            items.forEach(item => {
                const option = document.createElement('option');
                option.value = item.Name; // Use the item Name as the value
                option.textContent = item.Name; // Use the item Name as the display text
                typeSelect.appendChild(option);
            });

            // Store fetched items globally for use in dynamic fields
            document.currentItems = items;
        })
        .catch(error => {
            console.error('Error fetching items:', error);
        });
}



// Function to dynamically add extra fields and populate them with items
// Function to dynamically add new sets of fields
function addDynamicFields() {
    const additionalFields = document.getElementById('additionalFields');
    const extraRequests = document.getElementById('extraRequests').value;
    const extraCount = parseInt(extraRequests);

    // Clear previous fields
    additionalFields.innerHTML = '';

    // Validate the input
    if (isNaN(extraCount) || extraCount < 1) {
        alert("Please enter a valid number of extra requests.");
        return;
    }

    // Add new sets of fields based on the number entered
    for (let i = 1; i <= extraCount; i++) {
        // Create label and dropdown for item type
        const typeLabel = document.createElement("label");
        typeLabel.textContent = "Είδος " + i;
        const typeSelect = document.createElement("select");
        typeSelect.name = "extraType" + i;

        // Populate the select dropdown with the available items
        const defaultOption = document.createElement('option');
        defaultOption.value = '';
        defaultOption.disabled = true;
        defaultOption.selected = true;
        defaultOption.textContent = 'Επιλέξτε είδος';
        typeSelect.appendChild(defaultOption);

        // Use the globally stored items to populate each new dropdown
        document.currentItems.forEach(item => {
            const option = document.createElement('option');
            option.value = item.Name;
            option.textContent = item.Name;
            typeSelect.appendChild(option);
        });

        // Create label and input for quantity
        const quantityLabel = document.createElement("label");
        quantityLabel.textContent = "Ποσότητα " + i;
        const quantityInput = document.createElement("input");
        quantityInput.type = "text";
        quantityInput.name = "extraQuantity" + i;
        quantityInput.placeholder = "Ποσότητα";

        // Append the new fields to the form
        additionalFields.appendChild(typeLabel);
        additionalFields.appendChild(typeSelect);
        additionalFields.appendChild(quantityLabel);
        additionalFields.appendChild(quantityInput);
    }
}

document.addEventListener('DOMContentLoaded', function () {
    fetchAndPopulateItems(); // Populate the original dropdown when the page loads

    const addButton = document.querySelector(".btn.add-fields");
    addButton.addEventListener('click', addDynamicFields); // Add fields when button is clicked

    const submitButton = document.getElementById('anasub');
    submitButton.addEventListener('click', function (event) {
        event.preventDefault(); // Prevent the form from submitting normally

        const type = document.getElementById('type').value;
        const quantity = document.getElementById('quantity').value;

        // Collect the main item and quantity
        const items = [{ name: type, quantity: parseInt(quantity) }];

        // Collect extra items and quantities from dynamic fields
        const extraFields = document.getElementById('additionalFields').children;
        for (let i = 0; i < extraFields.length; i += 4) {
            const extraType = extraFields[i + 1].value;
            const extraQuantity = extraFields[i + 3].value;
            if (extraType && extraQuantity) {
                items.push({ name: extraType, quantity: parseInt(extraQuantity) });
            }
        }

        // Get admin ID from localStorage (set during login)
        const adminID = localStorage.getItem('admin_id'); 
        if (!adminID) {
            alert('Admin ID not found. Please log in again.');
            return;
        }

        // Send the data to the server via AJAX
        const xhr = new XMLHttpRequest();
        xhr.open('POST', 'createannouncement.php', true);
        xhr.setRequestHeader('Content-Type', 'application/json');

        xhr.onload = function () {
            if (xhr.status === 200) {
                const response = JSON.parse(xhr.responseText);
                if (response.success) {
                    alert('Η ανακοίνωση δημιουργήθηκε επιτυχώς!');
                    document.getElementById('newAithmata').reset(); // Clear the form fields
                    document.getElementById('additionalFields').innerHTML = ''; // Clear additional fields
                } else {
                    alert('Σφάλμα: ' + response.message);
                }
            } else {
                alert('Η αίτηση απέτυχε. Κωδικός σφάλματος: ' + xhr.status);
            }
        };

        // Prepare the data to be sent to the server
        const data = JSON.stringify({ adminID: adminID, items: items });
        xhr.send(data);
    });
});
