//mobile menu leitourgia
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

    // New map and dropdown code
    const mapContainer = document.querySelector('.map-container');
    const dropdown = document.getElementById('regionDropdown');
    const dropdownSelected = dropdown.querySelector('.dropdown-selected');
    const dropdownOptions = dropdown.querySelector('.dropdown-options');
    let svgDoc = null;

    // 1. Basic dropdown functionality
    dropdownSelected.addEventListener('click', function(e) {
        e.stopPropagation();
        const isOpen = dropdownOptions.style.display === 'block';
        dropdownOptions.style.display = isOpen ? 'none' : 'block';
    });

    // Close dropdown when clicking outside
    document.addEventListener('click', function() {
        dropdownOptions.style.display = 'none';
    });

    // 2. Wait for SVG to load
    const greeceMap = document.getElementById('greeceMap');
    greeceMap.addEventListener('load', function() {
        svgDoc = this.contentDocument;
        if (svgDoc) {
            initializeMap();
        }
    });

    function initializeMap() {
        // Define our regions
        const regions = [
            { id: 'thessaloniki', name: 'Θεσσαλονίκη' },
            { id: 'thessaly', name: 'Θεσσαλία' },
            { id: 'attica', name: 'Αττική' },
            { id: 'crete', name: 'Κρήτη' }
        ];

        // Set up each region in the SVG
        regions.forEach(region => {
            const path = svgDoc.getElementById(region.id);
            if (path) {
                // Add hover effect
                path.addEventListener('mouseenter', () => {
                    if (!path.classList.contains('active')) {
                        path.style.fill = '#FFAA33'; // Hover color
                    }
                });

                path.addEventListener('mouseleave', () => {
                    if (!path.classList.contains('active')) {
                        path.style.fill = ''; // Reset to original
                    }
                });

                // Add click handler
                path.addEventListener('click', () => {
                    selectRegion(region.id, region.name);
                });

                // Set cursor
                path.style.cursor = 'pointer';
            }
        });

        // Set up dropdown options
        dropdownOptions.querySelectorAll('.dropdown-option').forEach(option => {
            option.addEventListener('click', function(e) {
                e.stopPropagation();
                const regionId = this.dataset.region;
                const regionName = this.textContent;
                selectRegion(regionId, regionName);
            });
        });
    }

    function selectRegion(regionId, regionName) {
        // Clear previous selection
        if (svgDoc) {
            svgDoc.querySelectorAll('path').forEach(path => {
                path.style.fill = '';
                path.classList.remove('active');
            });

            // Highlight selected region
            const selectedPath = svgDoc.getElementById(regionId);
            if (selectedPath) {
                selectedPath.style.fill = '#FA4343'; // Your brand red
                selectedPath.classList.add('active');
            }
        }

        // Update dropdown text
        dropdownSelected.querySelector('span').textContent = regionName;
        dropdownOptions.style.display = 'none';
    }
});


//savvatou login
document.addEventListener("DOMContentLoaded", () => {
    const wrapperButton = document.querySelector(".logBT");
    const exitButton = document.getElementById("exitButton5");
    const cont2 = document.getElementById("contF");
    
    wrapperButton.addEventListener("click", () => {
        if (cont2.style.display === 'none' ) {
            cont2.style.display = 'grid';
        } else {
            cont2.style.display = 'none';
        }
    });

    exitButton.addEventListener("click", () => {
        cont2.style.display = 'none';
    });

    //gia mobile version
    const wrapperButton2 = document.querySelector(".customB");
    
    wrapperButton2.addEventListener("click", () => {
        if (cont2.style.display === 'none' ) {
            cont2.style.display = 'grid';
        } else {
            cont2.style.display = 'none';
        }
    });

    exitButton.addEventListener("click", () => {
        cont2.style.display = 'none';
    });

});
});