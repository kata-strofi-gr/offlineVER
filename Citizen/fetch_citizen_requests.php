<?php
header('Content-Type: application/json');

// Get the citizen name from the URL
if (isset($_SERVER['PATH_INFO'])) {
    $citizen_id = trim($_SERVER['PATH_INFO'], '/'); // Trim leading and trailing slashes
} else {
    $citizen_id = null; // Or handle this case as needed
}

// Include the database configuration file
include '../db_config.php';

if ($citizen_id) {
    $sql = "
        SELECT
            items.Name,
            categ.CategoryName,
            reqitems.Quantity,
            req.DateCreated,
            IFNULL(req.DateAssignedVehicle, '-') DateAssignedVehicle,
            IFNULL(req.DateFinished, '-') DateFinished
        FROM Requests req
        LEFT JOIN RequestItems reqitems ON req.RequestID = reqitems.RequestID
        LEFT JOIN Items items ON reqitems.ItemID = items.ItemID
        LEFT JOIN Category categ ON items.CategoryID = categ.CategoryID
        LEFT JOIN Citizen cit ON req.CitizenID = cit.CitizenID
        WHERE req.CitizenID = $citizen_id";

    $result = $conn->query($sql);
    $items = [];
    if ($result->num_rows > 0) {
        while ($row = $result->fetch_assoc()) {
            $items[] = [
                'Name' => $row['Name'],
                'CategoryName' => $row['CategoryName'],
                'Quantity' => $row['Quantity'],
                'DateCreated' => $row['DateCreated'],
                'DateAssignedVehicle' => $row['DateAssignedVehicle'],
                'DateFinished' => $row['DateFinished']
            ];
        }
    }

    $conn->close();
    echo json_encode($items);

}

?>
