document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('loginButton').addEventListener('click', function() {
        var username = document.getElementById('usernameF').value;
        var password = document.getElementById('passwordF').value;

        // Create a JSON object with the credentials
        var credentials = JSON.stringify({ username: username, password: password });

        // Define your secret key
        var secretKey = 'your-very-secure-and-random-secret-key';

        // Encrypt the JSON object
        var encrypted = CryptoJS.AES.encrypt(credentials, secretKey).toString();

        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'https://localhost/myproject/login.php', true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function () {
            if (xhr.readyState == 4 && xhr.status == 200) {
                var response = JSON.parse(xhr.responseText);

                // Decrypt the response
                var decryptedData = CryptoJS.AES.decrypt(response.data, secretKey).toString(CryptoJS.enc.Utf8);
                var decryptedResponse = JSON.parse(decryptedData);

                if (decryptedResponse.success) {
                    // Redirect to the role-specific dashboard
                    window.location.href = 'https://localhost/myproject/' + decryptedResponse.redirect;
                } else {
                    alert('Login failed: ' + decryptedResponse.message);
                }
            }
        };
        xhr.send('data=' + encodeURIComponent(encrypted));
    });
});
