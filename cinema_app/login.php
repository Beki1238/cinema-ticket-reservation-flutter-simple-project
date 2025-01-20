<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");

header("Content-Type: application/json");

// Database connection
$connection = new mysqli("localhost", "root", "", "th_ctms");

if ($connection->connect_error) {
    echo json_encode(["success" => false, "message" => "Database connection failed"]);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $email = $_POST['email'] ?? null;
    $password = $_POST['password'] ?? null;

    // Validate inputs
    if (empty($email) || empty($password)) {
        echo json_encode(["success" => false, "message" => "Email and password are required"]);
        exit();
    }

    // Query the database
    $query = "SELECT id, password FROM customers WHERE email = ?";
    $stmt = $connection->prepare($query);

    if ($stmt) {
        $stmt->bind_param("s", $email);
        $stmt->execute();
        $stmt->bind_result($id, $hashedPassword);
        $stmt->fetch();

        if ($id && password_verify($password, $hashedPassword)) {
            session_start();
            $_SESSION['customer_id'] = $id;
            echo json_encode(["success" => true, "message" => "Login successful", "customer_id" => $id]);
        } else {
            echo json_encode(["success" => false, "message" => "Invalid email or password"]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "Failed to prepare statement"]);
    }
}
$connection->close();
?>
