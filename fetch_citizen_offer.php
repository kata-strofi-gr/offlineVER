<?php
header('Content-Type: application/json');

// Get the citizen name from the URL
if (isset($_SERVER['PATH_INFO'])) {
    $userID = trim($_SERVER['PATH_INFO'], '/'); // Trim leading and trailing slashes
} else {
    $userID = null; // Or handle this case as needed
}

// Include the database configuration file
include 'db_config.php';

if ($userID) {
    $sql = "
        SELECT
            i.Name,
            i.Category,
            oi.Quantity,
            o.DateCreated,
            o.DateAssignedVehicle
        FROM Offers o
        LEFT JOIN OfferItems oi ON o.OfferID = oi.OfferID
        LEFT JOIN Items i ON oi.ItemID = i.ItemID
        LEFT JOIN Citizen c ON o.CitizenID = c.CitizenID
        WHERE c.UserID = $userID";

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
