// // document.addEventListener('DOMContentLoaded', function() {
// //     // Check if the user is logged in
// //     var xhr = new XMLHttpRequest();
// //     xhr.open('GET', 'check_login.php', true);
// //     xhr.onreadystatechange = function() {
// //         if (xhr.readyState === 4 && xhr.status === 200) {
// //             var response = JSON.parse(xhr.responseText);
// //             if (!response.loggedin) {
// //                 window.location.href = 'start.html';
// //             }
// //         }
// //     };
// //     xhr.send();

//     // // Auto logout after 10 minutes of inactivity
//     // var logoutTimer;
//     // function resetLogoutTimer() {
//     //     clearTimeout(logoutTimer);
//     //     logoutTimer = setTimeout(function() {
//     //         alert('You have been logged out due to inactivity.');
//     //         window.location.href = 'logout.php';
//     //     }, 10 * 60 * 1000); // 10 minutes
//     // }

//     // document.addEventListener('mousemove', resetLogoutTimer);
//     // document.addEventListener('keydown', resetLogoutTimer);

//     // // Refresh session every 5 minutes
//     // setInterval(function() {
//     //     var xhr = new XMLHttpRequest();
//     //     xhr.open('POST', 'refresh_session.php', true);
//     //     xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
//     //     xhr.send();
//     // }, 5 * 60 * 1000); // 5 minutes

//     // resetLogoutTimer();

//     // Logout button functionality
//     // var logoutButton = document.getElementById('loggout');
//     // if (logoutButton) {
//     //     logoutButton.addEventListener('click', function() {
//     //         var xhr = new XMLHttpRequest();
//     //         xhr.open('POST', 'logout.php', true);
//     //         xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
//     //         xhr.onreadystatechange = function() {
//     //             if (xhr.readyState === 4 && xhr.status === 200) {
//     //                 window.location.href = 'start.html';
//     //             }
//     //         };
//     //         xhr.send();
//     //     });
//     // }
// });
