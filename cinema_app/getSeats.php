<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Include database connection
$connection = new mysqli("localhost", "root", "", "th_ctms");

// Check connection
if ($connection->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed: " . $connection->connect_error]);
    exit();
}

// Validate and get room_id
$data = json_decode(file_get_contents("php://input"), true);
$room_id = $data['room_id'] ?? null;

if (!$room_id) {
    echo json_encode(["success" => false, "message" => "Room ID is required."]);
    exit();
}

// Fetch seats for the room
$query = "SELECT * FROM seats WHERE room_id = ?";
$stmt = $connection->prepare($query);
$stmt->bind_param("i", $room_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    echo json_encode(["success" => true, "message" => "No seats available for this room.", "data" => []]);
    $stmt->close();
    $connection->close();
    exit();
}

// Format seat data
$seats = [];
while ($row = $result->fetch_assoc()) {
    $seats[] = [
        "id" => $row['id'],
        "seat_number" => $row['seat_number'],
        "is_booked" => (int)$row['is_booked'],
        "status" => (int)$row['status']
    ];
}

// Send JSON response
echo json_encode(["success" => true, "message" => "Seats fetched successfully.", "data" => $seats]);

$stmt->close();
$connection->close();
?>
