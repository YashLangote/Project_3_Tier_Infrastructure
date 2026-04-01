#!/bin/bash
# Update packages and install Apache and PHP
dnf update -y
dnf install -y httpd php php-mysqli

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create the PHP backend processing script
cat <<EOF > /var/www/html/submit.php
<?php
// Prevent HTTP 500 errors so we can actually see connection issues
mysqli_report(MYSQLI_REPORT_OFF); 

\$servername = "${db_endpoint}"; 
\$username   = "dbadmin";
\$password   = "${db_password}";
\$dbname     = "ecommerce_db";

// Create connection to RDS
\$conn = new mysqli(\$servername, \$username, \$password, \$dbname);

// Check connection
if (\$conn->connect_error) {
  die("Database Connection failed: " . \$conn->connect_error);
}

// Process the form data
if (\$_SERVER["REQUEST_METHOD"] == "POST") {
    \$name = htmlspecialchars(\$_POST['name']);
    \$email = htmlspecialchars(\$_POST['email']);
    
    echo "<h3>Success!</h3>";
    echo "Received registration for: " . \$name . " (" . \$email . ")<br>";
    echo "<p>Connected successfully to the secure RDS database at <b>" . \$servername . "</b>!</p>";
}
?>
EOF