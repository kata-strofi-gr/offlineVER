<?php
// Include the database connection
include '../../db_config.php';  // Adjust this to your actual DB connection file

// Get the rescuer ID (this can be passed via POST or GET)
$rescuer_id = $_GET['rescuer_id'];  // Assuming you pass rescuer_id via GET

// Check if rescuer ID is provided
if (empty($rescuer_id)) {
    echo json_encode(['error' => 'Rescuer ID not provided.']);
    exit;
}

try {
    // Prepare the query to fetch the vehicle's items associated with the rescuer
    $stmt = $conn->prepare("
        SELECT vi.ItemID, i.Name, i.DetailName, i.DetailValue, vi.Quantity, c.CategoryName
        FROM VehicleItems vi
        JOIN Vehicles v ON vi.VehicleID = v.VehicleID
        JOIN Items i ON vi.ItemID = i.ItemID
        JOIN Category c ON i.CategoryID = c.CategoryID
        WHERE v.RescuerID = ?
    ");
    $stmt->bind_param("i", $rescuer_id);

    // Execute the query
    $stmt->execute();
    $result = $stmt->get_result();

    // Fetch data
    $vehicle_items = [];
    while ($row = $result->fetch_assoc()) {
        $vehicle_items[] = $row;
    }

    // Return the data as JSON
    echo json_encode(['data' => $vehicle_items]);

} catch (Exception $e) {
    // Handle exceptions and return an error
    echo json_encode(['error' => $e->getMessage()]);
}

// Close the statement and connection
$stmt->close();
$conn->close();
?>
