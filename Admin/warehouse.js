document.addEventListener('DOMContentLoaded', function () {
    const filterSelect = document.getElementById('filterType');
    const dataTableBody = document.querySelector('#dataTable tbody');
    let allItems = [];
    let selectedCategories = [];

    function fetchData() {
        const xhr = new XMLHttpRequest();
        xhr.open('GET', 'fetch_inventory.php', true);

        xhr.onload = function () {
            if (xhr.status === 200) {
                allItems = JSON.parse(xhr.responseText);
                populateFilterOptions(allItems);
                applyFilters(); // Apply filters after populating options
            } else {
                console.error('Failed to fetch data');
            }
        };

        xhr.send();
    }

    function populateFilterOptions(items) {
        const uniqueCategories = [...new Set(items.map(item => item.Category))];
        filterSelect.innerHTML = ''; // Clear current options

        // Add the "All" option
        const allOption = document.createElement('option');
        allOption.value = 'all';
        allOption.textContent = 'All';
        filterSelect.appendChild(allOption);

        uniqueCategories.forEach(category => {
            const option = document.createElement('option');
            option.value = category;
            option.textContent = category;
            filterSelect.appendChild(option);
        });

        // Reapply previously selected categories
        selectedCategories.forEach(category => {
            const option = [...filterSelect.options].find(opt => opt.value === category);
            if (option) {
                option.selected = true;
            }
        });
    }

    function applyFilters() {
        if (selectedCategories.length === 0 || selectedCategories.includes('all')) {
            renderTable(allItems); // If "All" is selected, show all items
        } else {
            const filteredItems = allItems.filter(item => selectedCategories.includes(item.Category));
            renderTable(filteredItems);
        }
    }

    function renderTable(items) {
        dataTableBody.innerHTML = ''; // Clear the existing table rows
        items.forEach(item => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${item.Category || 'Unknown'}</td>
                <td>${item.Name || 'Unnamed'}</td>
                <td>${item.Description || 'No Description'}</td>
                <td>${item.Quantity || 0}</td>
                <td>${item.Location || 'Unknown'}</td>
                <td>${item.ItemID}</td>
            `;
            dataTableBody.appendChild(row);
        });
    }

    filterSelect.addEventListener('change', function () {
        selectedCategories = Array.from(filterSelect.selectedOptions).map(option => option.value);
        applyFilters(); // Apply filters after selection
    });

    // Fetch data and populate the table initially
    fetchData();

    // Set up an interval to refresh the data every 10 seconds
    setInterval(fetchData, 10000);
});
