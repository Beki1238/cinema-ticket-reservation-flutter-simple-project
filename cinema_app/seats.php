<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

// Database connection
$connection = new mysqli("localhost", "root", "", "th_ctms");

if ($connection->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed: " . $connection->connect_error]);
    exit();
}

// Get room_id from request
$room_id = $_GET['room_id'] ?? null;
if (!$room_id) {
    echo json_encode(["success" => false, "message" => "Room ID is required"]);
    exit();
}

// Fetch seat details
$query = "
    SELECT 
        seat_number, 
        status 
    FROM seats 
    WHERE room_id = ?";
$stmt = $connection->prepare($query);

if (!$stmt) {
    echo json_encode(["success" => false, "message" => "Failed to prepare the database query."]);
    $connection->close();
    exit();
}

$stmt->bind_param("i", $room_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode([
        "success" => true,
        "message" => "No seats found for the specified room.",
        "data" => []
    ]);
    $stmt->close();
    $connection->close();
    exit();
}

// Format the seat data
$seats = [];
while ($row = $result->fetch_assoc()) {
    $seats[] = [
        "seat_number" => (int)$row['seat_number'],
        "status" => $row['status'] // e.g., "booked", "available", "temporary"
    ];
}

// Send the JSON response
echo json_encode([
    "success" => true,
    "data" => $seats
]);

$stmt->close();
$connection->close();
?>
