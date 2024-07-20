add_events()

function add_events() {
    document.getElementById('nav-branding').addEventListener('click', function(){load_page('citizen.html');});
    document.getElementById('nav-announcements').addEventListener('click', function(){load_page('announcements.html');});
    document.getElementById('nav-requests').addEventListener('click', function(){load_page('requests.html');});
    document.getElementById('nav-offers').addEventListener('click', function(){load_page('offers.html');});
}

function load_page(page) {
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            document.querySelector('html').innerHTML =
            this.responseText;
            add_events()
        }
    };
    xhttp.open("GET", page, true);
    xhttp.send();
}
