document.addEventListener('DOMContentLoaded', function() {
    // Login button functionality
    document.getElementById('loginButton').addEventListener('click', function() {
        var username = document.getElementById('usernameF').value;
        var password = document.getElementById('passwordF').value;

        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'login.php', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            if (response.role === 'Administrator') {
                                window.location.href = 'admin.html';
                            } else {
                                window.location.href = 'blank.html';
                            }
                        } else {
                            alert('Login failed: ' + response.message);
                        }
                    } catch (e) {
                        console.error('Error parsing JSON:', e);
                        alert('An error occurred during login.');
                    }
                } else {
                    console.log('Server returned an error status:', xhr.status);
                }
            }
        };
        
        var data = 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password);
        xhr.send(data);
    });

    // Registration pop-up toggle
    document.getElementById('registerLink').addEventListener('click', function() {
        document.getElementById('contF').classList.remove('active');
        document.getElementById('registerPopup').classList.add('active');
    });

    document.getElementById('exitRegisterButton').addEventListener('click', function() {
        document.getElementById('registerPopup').classList.remove('active');
    });

    // Register button functionality
    document.getElementById('registerButton').addEventListener('click', function() {
        var username = document.getElementById('registerUsername').value;
        var password = document.getElementById('registerPassword').value;
        var firstName = document.getElementById('firstName').value;
        var lastName = document.getElementById('lastName').value;
        var phoneNumber = document.getElementById('phoneNumber').value;
        var latitude = document.getElementById('latitude').value;
        var longitude = document.getElementById('longitude').value;

        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'register.php', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var response = JSON.parse(xhr.responseText);
                        if (response.success) {
                            alert('Registration successful! Please log in.');
                            document.getElementById('registerPopup').classList.remove('active');
                        } else {
                            alert('Registration failed: ' + response.message);
                        }
                    } catch (e) {
                        console.error('Error parsing JSON:', e);
                        alert('An error occurred during registration.');
                    }
                } else {
                    console.log('Server returned an error status:', xhr.status);
                }
            }
        };
        
        var data = 'username=' + encodeURIComponent(username) +
                   '&password=' + encodeURIComponent(password) +
                   '&firstName=' + encodeURIComponent(firstName) +
                   '&lastName=' + encodeURIComponent(lastName) +
                   '&phoneNumber=' + encodeURIComponent(phoneNumber) +
                   '&latitude=' + encodeURIComponent(latitude) +
                   '&longitude=' + encodeURIComponent(longitude);
        xhr.send(data);
    });
});
