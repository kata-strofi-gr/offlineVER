<?php
header('Content-Type: application/json');

// Include the database configuration file
include '../db_config.php';

$sql = "
    SELECT 
        i.Category, 
        i.Name, 
        i.Description, 
        COALESCE(SUM(w.Quantity), 0) as Quantity, 
        'In Warehouse' as Location, 
        w.ItemID 
    FROM Warehouse w 
    LEFT JOIN Items i ON w.ItemID = i.ItemID 
    GROUP BY w.ItemID, i.Category, i.Name, i.Description

    UNION

    SELECT 
        i.Category, 
        i.Name, 
        i.Description, 
        COALESCE(SUM(vi.Quantity), 0) as Quantity, 
        CONCAT('On Vehicle (', u.Username, ')') as Location, 
        vi.ItemID 
    FROM VehicleItems vi 
    LEFT JOIN Items i ON vi.ItemID = i.ItemID 
    LEFT JOIN Vehicles v ON vi.VehicleID = v.VehicleID 
    LEFT JOIN Rescuer r ON v.RescuerID = r.RescuerID 
    LEFT JOIN Users u ON r.UserID = u.UserID
    GROUP BY vi.ItemID, i.Category, i.Name, i.Description, u.Username
";


$result = $conn->query($sql);

$items = [];
while ($row = $result->fetch_assoc()) {
    $items[] = [
        'Category' => $row['Category'],
        'Name' => $row['Name'],
        'Description' => $row['Description'],
        'Quantity' => $row['Quantity'],
        'Location' => $row['Location'],
        'ItemID' => $row['ItemID'],
    ];
}

$conn->close();

echo json_encode($items);
