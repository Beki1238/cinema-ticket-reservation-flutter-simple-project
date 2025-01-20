<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json");

// Validate the request method
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["success" => false, "message" => "Invalid request method"]);
    exit();
}

// Get the raw POST data
$data = json_decode(file_get_contents("php://input"), true);

// Validate input
$movie_id = $data['movie_id'] ?? null;
if (!$movie_id) {
    echo json_encode(["success" => false, "message" => "Movie ID is required"]);
    exit();
}

// Database connection
$connection = new mysqli("localhost", "root", "", "th_ctms");

// Check for connection errors
if ($connection->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed: " . $connection->connect_error]);
    exit();
}

// Fetch showtime and room details
$query = "
    SELECT 
        cinemarooms.id AS room_id,
        cinemarooms.name AS room_name,
        cinemarooms.base_price,
        showtime.start_time,
        showtime.price AS showtime_price
    FROM showtime
    JOIN cinemarooms ON showtime.room_id = cinemarooms.id
    WHERE showtime.movie_id = ?";
$stmt = $connection->prepare($query);

if (!$stmt) {
    echo json_encode(["success" => false, "message" => "Database query preparation failed."]);
    $connection->close();
    exit();
}

// Bind parameters and execute the statement
$stmt->bind_param("i", $movie_id);
$stmt->execute();
$result = $stmt->get_result();

// Check if any showtimes were found
if ($result->num_rows === 0) {
    echo json_encode([
        "success" => true,
        "message" => "No showtimes available for this movie.",
        "data" => []
    ]);
    $stmt->close();
    $connection->close();
    exit();
}

// Format the response
$response = [];
while ($row = $result->fetch_assoc()) {
    $response[] = [
        "room_id" => $row['room_id'],
        "room_name" => $row['room_name'],
        "base_price" => (float)$row['base_price'], // Cast to ensure proper data type
        "start_time" => $row['start_time'],
        "showtime_price" => (float)$row['showtime_price'] // Cast to ensure proper data type
    ];
}

// Send the JSON response
echo json_encode([
    "success" => true,
    "message" => "Showtime and room details fetched successfully.",
    "data" => $response
]);

// Clean up
$stmt->close();
$connection->close();
?>
