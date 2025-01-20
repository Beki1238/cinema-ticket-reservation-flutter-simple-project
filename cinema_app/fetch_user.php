<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

header("Content-Type: application/json");

// Database connection
$conn = new mysqli("localhost", "root", "", "th_ctms");

if ($conn->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed"]);
    exit();
}

// Handle POST request
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $user_id = $_POST['user_id']; // Assume user_id is passed from Flutter

    if (!empty($user_id)) {
        // Prepare and execute the query to fetch user details
        $stmt = $conn->prepare("SELECT name, email, profile_image_url FROM users WHERE id = ?");
        $stmt->bind_param("i", $user_id);
        $stmt->execute();
        $result = $stmt->get_result();

        // Check if user exists
        if ($result->num_rows > 0) {
            $user = $result->fetch_assoc();

            // Return user details
            echo json_encode([
                'status' => 'success',
                'data' => [
                    'name' => $user['name'],
                    'email' => $user['email'],
                    'profile_image_url' => $user['profile_image_url'] ?? null, // Optional
                ],
            ]);
        } else {
            // User not found
            echo json_encode([
                'status' => 'error',
                'message' => 'User not found',
            ]);
        }
        $stmt->close();
    } else {
        // Missing user ID
        echo json_encode([
            'status' => 'error',
            'message' => 'User ID is required',
        ]);
    }
} else {
    // Invalid request method
    echo json_encode([
        'status' => 'error',
        'message' => 'Invalid request method',
    ]);
}

// Close connection
$conn->close();
?>
