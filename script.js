document.addEventListener('DOMContentLoaded', function() {
    const menuToggle = document.getElementById('menu-toggle');
    const overlay = document.getElementById('overlay');
    const closeOverlay = document.getElementById('closeOverlay');
    const overlayLoginButton = document.getElementById('overlayLoginButton');

    menuToggle.addEventListener('click', function() {
        if (overlay.style.display === 'flex') {
            overlay.style.display = 'none';
        } else {
            overlay.style.display = 'flex';
        }
    });

    closeOverlay.addEventListener('click', function() {
        overlay.style.display = 'none';
    });

    // Close overlay when clicking outside the content
    overlay.addEventListener('click', function(event) {
        if (event.target === overlay) {
            overlay.style.display = 'none';
        }
    });

    // Optional: Add functionality to overlay login button if needed
    overlayLoginButton.addEventListener('click', function() {
        alert('Login button clicked inside overlay');
    });
});



//savvatou login
document.addEventListener("DOMContentLoaded", () => {
    const wrapperButton = document.querySelector(".logBT");
    const popupOverlay = document.getElementById("popupOverlay");
    const exitButton = document.getElementById("exitButton");

    wrapperButton.addEventListener("click", () => {
        popupOverlay.classList.add("active");
    });

    exitButton.addEventListener("click", () => {
        popupOverlay.classList.remove("active");
    });

    // Close the popup if the overlay is clicked
    popupOverlay.addEventListener("click", (e) => {
        if (e.target === popupOverlay) {
            popupOverlay.classList.remove("active");
        }
    });
});
