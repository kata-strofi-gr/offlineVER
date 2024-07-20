// Needs extension MongoDB for VSCode
use('NeedsNest');


// index on the 'type' field for faster queries on user types
db.Users.createIndex({ type: 1 });

// index on the 'username' field for faster queries on usernames
db.Users.createIndex({ username: 1 });


// Use getIndexes to see all indexes on the collection
const indexes = db.getCollection('Users').getIndexes();

// Print the indexes
printjson(indexes);


// index on the 'category' field
db.Items.createIndex({ category: 1 });
// index on the 'item_name' field
db.Items.createIndex({ item_name: 1 });
//index on the 'category' and 'item_name' fields
db.Items.createIndex({ category: 1, item_name: 1 });


// Use getIndexes to see all indexes on the collection
 indexes = db.getCollection('Items').getIndexes();

// Print the indexes
printjson(indexes);

// index on the 'category' field
db.Inventory.createIndex({ 'items.item': 1 });
db.Inventory.createIndex({ 'items.quantity': 1 });
db.Inventory.createIndex({ 'items.item': 1  , 'items.quantity': 1 });



indexes = db.getCollection('Inventory').getIndexes();


printjson(indexes);

// index on the 'admin_id' 
db.Announcements.createIndex({ 'admin_id': 1 });

// index on the 'date_created'
db.Announcements.createIndex({ 'date_created': 1 });

// index on the 'title' 
db.Announcements.createIndex({ 'title': 1 });

// index on the 'items.item_id'
db.Announcements.createIndex({ 'items.item_id': 1 });


indexes = db.getCollection('Announcements').getIndexes();

printjson(indexes);

db.Requests.createIndex({ 'citizen_id': 1 });
db.Requests.createIndex({ 'item': 1 });
db.Requests.createIndex({ 'status': 1 });
db.Requests.createIndex({ 'date_requested': 1 });
db.Requests.createIndex({ 'citizen_id': 1, 'item': 1 });
db.Requests.createIndex({ 'citizen_id': 1, 'item': 1 , 'quantity_requested': 1});

indexes = db.getCollection('Requests').getIndexes();

printjson(indexes);


db.Offers.createIndex({ "citizen_id": 1 });

db.Offers.createIndex({ "items.item_id": 1 });

db.Offers.createIndex({ "status": 1 });

db.Offers.createIndex({ "date_offered": 1 });

db.Offers.createIndex({ "citizen_id": 1, "items.item_id": 1 });
db.Offers.createIndex({ "citizen_id": 1, "items.item_id": 1, "items.quantity" :1});
indexes = db.getCollection('Offers').getIndexes();

printjson(indexes);


db.Tasks.createIndex({ type: 1});
db.Tasks.createIndex({ date_created: 1});
db.Tasks.createIndex({task_type: 1 });
db.Tasks.createIndex({ status: 1 });
db.Tasks.createIndex({ date_completed: 1});
db.Tasks.createIndex({ type: 1, task_type: 1, date_created: 1, status: 1 });

indexes = db.getCollection('Tasks').getIndexes();

printjson(indexes);

db.Vehicles.createIndex({ rescuer_id: 1 });
//comments for axil information for this weird shit indexing https://www.mongodb.com/docs/manual/core/indexes/index-types/geospatial/2dsphere/
db.Vehicles.createIndex({ current_location: "2dsphere" });
db.Vehicles.createIndex({ status: 1 });
db.Vehicles.createIndex({ "items.item_id": 1 });
db.Vehicles.createIndex({ "active_tasks": 1 });
db.Vehicles.createIndex({ rescuer_id: 1, status: 1 });
db.Vehicles.createIndex({ rescuer_id: 1, active_tasks: 1 });

indexes = db.getCollection('Vehicles').getIndexes();

printjson(indexes);