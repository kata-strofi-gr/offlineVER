/**
 * Map setup
 */


/**
 * Global variables
 */















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
