document.addEventListener('DOMContentLoaded', function() {
    var loginButton = document.getElementById('loginButton');
    var logoutButton = document.getElementById('loggout');

    loginButton.addEventListener('click', function() {
        var username = document.getElementById('usernameF').value;
        var password = document.getElementById('passwordF').value;

        console.log('Login button clicked');
        console.log('Username:', username);
        console.log('Password:', password);

        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'login.php', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                console.log('XHR readyState:', xhr.readyState);
                console.log('XHR status:', xhr.status);
                
                if (xhr.status === 200) {
                    var response = JSON.parse(xhr.responseText);
                    console.log('Response from server:', response);
                    
                    if (response.success) {
                        console.log('Login successful, role:', response.role);
                        if (response.role === 'Administrator') {
                            window.location.href = 'admin.html';
                        } else {
                            window.location.href = 'blank.html';
                        }
                    } else {
                        console.log('Login failed:', response.message);
                        alert('Login failed: ' + response.message);
                    }
                } else {
                    console.log('Server returned an error status:', xhr.status);
                }
            }
        };
        
        var data = 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password);
        console.log('Data sent to server:', data);
        xhr.send(data);
    });

    // if (logoutButton) {
    //     logoutButton.addEventListener('click', function() {
    //         var xhr = new XMLHttpRequest();
    //         xhr.open('POST', 'logout.php', true);
    //         xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    //         xhr.onreadystatechange = function() {
    //             if (xhr.readyState === 4 && xhr.status === 200) {
    //                 window.location.href = 'start.html';
    //             }
    //         };
    //         xhr.send();
    //     });
    // }

    // // Auto logout after 10 minutes of inactivity
    // var logoutTimer;
    // function resetLogoutTimer() {
    //     clearTimeout(logoutTimer);
    //     logoutTimer = setTimeout(function() {
    //         alert('You have been logged out due to inactivity.');
    //         window.location.href = 'logout.php';
    //     }, 10 * 60 * 1000); // 10 minutes
    // }

    // document.addEventListener('mousemove', resetLogoutTimer);
    // document.addEventListener('keydown', resetLogoutTimer);

    // // Refresh session every 5 minutes
    // setInterval(function() {
    //     var xhr = new XMLHttpRequest();
    //     xhr.open('POST', 'refresh_session.php', true);
    //     xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    //     xhr.send();
    // }, 5 * 60 * 1000); // 5 minutes

    // resetLogoutTimer();
});
