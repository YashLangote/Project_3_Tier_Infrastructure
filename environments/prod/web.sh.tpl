#!/bin/bash
# Update packages and install Nginx
dnf update -y
dnf install -y nginx

# Start and enable Nginx to run on boot
systemctl start nginx
systemctl enable nginx

# Create the HTML registration form
cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>User Registration</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        .container { max-width: 400px; margin: auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        input[type="text"], input[type="email"] { width: 100%; padding: 10px; margin: 10px 0; }
        input[type="submit"] { background-color: #4CAF50; color: white; padding: 10px 15px; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Register Here</h2>
        <form action="/submit.php" method="POST">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>
            
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            
            <input type="submit" value="Register">
        </form>
    </div>
</body>
</html>
EOF

# Configure Nginx Reverse Proxy to forward requests to the App Tier
# Amazon Linux Nginx automatically includes files in default.d
echo 'location /submit.php { proxy_pass http://${app_ip}/submit.php; }' > /etc/nginx/default.d/php-proxy.conf

# Restart Nginx to apply the new proxy rule
systemctl restart nginx