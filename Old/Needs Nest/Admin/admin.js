let mapOptions = {
    center:[38.29026, 21.795],
    zoom:17,
}

let geoJsonData = {
    type: "FeatureCollection",
    features: []
};


let map = new L.map('map', mapOptions);
let layer = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png');
map.addLayer(layer);

let locations = [
    {
        "id": 1,
        "lat": 38.29026,
        "long": 21.795,
        "iconUrl": '../Media/base.png',
        "title": "Base",
    },
    {
        "id": 2,
        "lat": 38.28898,
        "long": 21.79422,
        "iconUrl": '../Media/truck.png',
        "title": "Vehicle 1",
        "url": "https://www.google.com/"
    },
    {
        "id": 3,
        "lat": 38.2895,
        "long": 21.7831,
        "iconUrl": '../Media/truck.png',
        "title": "Vehicle 2",
        "url": "https://www.google.com/"
    },
];

let popupOptions = {
    "closeButton": false,
};

// Function to calculate distance between two points
function calculateDistance(latlng1, latlng2) {
    return latlng1.distanceTo(latlng2);
}

locations.forEach(element => {
    let customIcon = L.icon({
        iconUrl: element.iconUrl,
        iconSize: [40, element.id === 1 ? 25 : 40],
    });

    let marker = new L.Marker([element.lat, element.long], {
        draggable: true,
        icon: customIcon,
    }).addTo(map)
    .on("mouseover", event => {
        event.target.bindPopup('<div class="card"><img src="'+element.iconUrl+'" width="80" height="80" alt="'+element.title+'">   <h3>'+element.title+'</h3></div>', popupOptions).openPopup();
    })
    .on("mouseout", event => {
        event.target.closePopup();
    })
    .on("click", () => {
        window.open(element.url);
    })
    .on("dragend", event => {
        const newLatLng = event.target.getLatLng();
        element.lat = newLatLng.lat;
        element.long = newLatLng.lng;

        // Check if the marker is not the base (id !== 1)
        if (element.id !== 1) {
            let baseLatLng = L.latLng(locations.find(loc => loc.id === 1).lat, locations.find(loc => loc.id === 1).long);
            let distanceInMeters = calculateDistance(newLatLng, baseLatLng);
            console.log(`Distance between ${element.title} and Base: ${distanceInMeters} meters`);
        }
    });
});

