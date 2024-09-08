<?php
header('Content-Type: application/json');

// Get the citizen name from the URL
if (isset($_SERVER['PATH_INFO'])) {
    $userID = trim($_SERVER['PATH_INFO'], '/'); // Trim leading and trailing slashes
} else {
    $userID = null; // Or handle this case as needed
}

// Include the database configuration file
include '../db_config.php';

if ($userID) {
    $sql = "
        SELECT
            items.Name,
            categ.CategoryName,
            reqitems.Quantity,
            req.DateCreated,
            req.DateAssignedVehicle
        FROM Requests req
        LEFT JOIN RequestItems reqitems ON req.RequestID = reqitems.RequestID
        LEFT JOIN Items items ON reqitems.ItemID = items.ItemID
        LEFT JOIN Category categ ON items.CategoryID = categ.CategoryID
        LEFT JOIN Citizen cit ON req.CitizenID = cit.CitizenID
        WHERE cit.UserID = $userID";

    $result = $conn->query($sql);
    $items = [];
    while ($row = $result->fetch_assoc()) {
        $items[] = [
            'Name' => $row['Name'],
            'Category' => $row['Category'],
            'Quantity' => $row['Quantity'],
            'DateCreated' => $row['DateCreated'],
            'DateAssignedVehicle' => $row['DateAssignedVehicle'],
        ];
    }

    $conn->close();
    echo json_encode($items);

}

?>
