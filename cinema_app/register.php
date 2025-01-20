<?php header("Access-Control-Allow-Origin: *");
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
    $name = $_POST['name'] ?? null;
    $email = $_POST['email'] ?? null;
    $password = $_POST['password'] ?? null;

    // Validate inputs
    if (empty($name) || empty($email) || empty($password)) {
        echo json_encode(["success" => false, "message" => "All fields are required"]);
        exit();
    }

    // Check if the email already exists
    $checkEmailQuery = "SELECT id FROM customers WHERE email = ?";
    $checkStmt = $connection->prepare($checkEmailQuery);

    if ($checkStmt) {
        $checkStmt->bind_param("s", $email);
        $checkStmt->execute();
        $result = $checkStmt->get_result();

        if ($result->num_rows > 0) {
            echo json_encode(["success" => false, "message" => "The email is already in use"]);
            $checkStmt->close();
            exit();
        }
        $checkStmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "Failed to prepare email check statement"]);
        exit();
    }

    // Hash the password
    $hashedPassword = password_hash($password, PASSWORD_BCRYPT);

    // Insert into the database
    $query = "INSERT INTO customers (name, email, password) VALUES (?, ?, ?)";
    $stmt = $connection->prepare($query);

    if ($stmt) {
        $stmt->bind_param("sss", $name, $email, $hashedPassword);
        
        if ($stmt->execute()) {
            echo json_encode(["success" => true, "message" => "Registration successful"]);
        } else {
            echo json_encode(["success" => false, "message" => "Error: " . $stmt->error]);
        }

        $stmt->close();
    } else {
        echo json_encode(["success" => false, "message" => "Failed to prepare statement"]);
    }
}
$connection->close();
?>