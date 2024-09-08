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
            cat.CategoryName,
            offitems.Quantity,
            off.DateCreated,
            off.DateAssignedVehicle
        FROM Offers off
        LEFT JOIN OfferItems offitems ON off.OfferID = offitems.OfferID
        LEFT JOIN Items items ON offitems.ItemID = items.ItemID
        LEFT JOIN Category cat ON items.CategoryID = cat.CategoryID
        LEFT JOIN Citizen cit ON off.CitizenID = cit.CitizenID
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
