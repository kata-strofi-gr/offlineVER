// Needs extension MongoDB for VSCode

use('NeedsNest');

// Insert a single user
db.Users.insertOne({
  type: ['citizen'],
  username: 'john_doe',
  password: 'hashed_password',
  firstName: 'John',
  lastName: 'Doe',
  phoneNumber: '1234567890',
  address: '123 Main St, Cityville',
});

db.Users.insertOne({
  type: ['citizen'],
  username: 'joccchn_doe',
  password: 'hashed_ccccpassword',
  firstName: 'John',
  lastName: 'Doe',
  phoneNumber: '1234567890',
  address: '123 Main St, Cityville',
});

// Insert multiple Users
db.Users.insertMany([
  {
    type: ['rescuer'],
    username: 'rescue_hero',
    password: 'hashed_password',
    firstName: 'Rescue',
    lastName: 'Hero',
    phoneNumber: '9876543210',
    address: '456 Rescuer St, Saver City',
  },
  {
    type: ['administrator'],
    username: 'admin_master',
    password: 'hashed_password',
    firstName: 'Admin',
    lastName: 'Master',
    phoneNumber: '5551234567',
    address: '789 Admin Blvd, Control City',
  },
]);

db.Base.insertOne({
  base_name: 'Base',
  base_location: {
    type: 'Point',
    coordinates: [38.254837, 21.743031], 
  },
});

db.Items.insertMany([
  {
    category: 'Food',
    item_name: 'Rice',
    description: 'High-quality rice for consumption',
    expire_date: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000), // One year from now
  },
  {
    category: 'Medicine',
    item_name: 'Painkiller',
    description: 'Effective pain relief medicine',
    expire_date: new Date(Date.now() + 365 * 24 * 60 * 60 * 1000), // One year from now
  },
 
]);

db.Items.insertOne({
  category: 'Electronics',
  item_name: 'Smartphone',
  description: 'High-end smartphone with advanced features',
  expire_date: new Date('2024-04-24 T00:00:00Z'), // April 24, 2024
});


const item = db.Items.findOne({ item_name:'Smartphone'});
const itemId = item._id;
const item1 = db.Items.findOne({ item_name: 'Rice' });
const itemId1 = item1._id;
const item2 = db.Items.findOne({ item_name: 'Painkiller'});
const itemId2= item2 ._id;
const base = db.Base.findOne({ base_name: 'Base' });
const baseid = base._id;
const admin = db.Users.findOne({ type: { $in: ['administrator'] }});
const adminid =admin._id;
const citizen = db.Users.findOne({ type: { $in: ['citizen'] }});
const citizenid =citizen._id;
const rescuer = db.Users.findOne({ type: { $in: ['rescuer'] }});
const rescuerid =rescuer._id;


db.Inventory.insertOne({
  items: [
    { item: ObjectId(itemId), quantity: 50 },
    { item: ObjectId(itemId1), quantity: 30 },
  
  ],
  base: ObjectId(baseid),
});

db.Announcements.insertMany([
  {
    admin_id: ObjectId(adminid), 
    items: [
      { item_id: ObjectId(itemId), quantity: 10 }, 
      { item_id: ObjectId(itemId1), quantity: 5 }, 
      { item_id: ObjectId(itemId2), quantity: 5 }, 
    ],
    title: 'Emergency Announcement',
    message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut eget justo sed urna posuere tincidunt.',
    date_created: new Date('2024-04-24 T00:00:00Z'),
  },
  {
    admin_id: ObjectId(adminid), 
    items: [
      { item_id: ObjectId(itemId1), quantity: 8 }, 
      { item_id: ObjectId(itemId), quantity: 15 },
    ],
    title: 'Urgent Announcement',
    message: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut eget justo sed urna posuere tincidunt.',
    date_created: new Date('2024-04-24 T00:00:00Z'),
  },
]);

db.Requests.insertMany([
  {
    citizen_id: ObjectId(citizenid),
    item: ObjectId(itemId1),
    quantity_requested: 3,
    status: 'Pending',
    date_requested: new Date('2023-11-25T12:00:00Z'),
  },
  {
    citizen_id: ObjectId(citizenid),
    item: ObjectId(itemId),
    quantity_requested: 5,
    status: 'Pending',
    date_requested: new Date('2023-11-25T12:15:00Z'),
  },
  {
    citizen_id: ObjectId(citizenid),
    item: ObjectId(itemId2),
    quantity_requested: 2,
    status: 'Accepted',
    date_requested: new Date('2023-11-25T12:30:00Z'),
    date_fulfilled: new Date('2023-11-25T13:00:00Z'),
  },
  {
    citizen_id: ObjectId(citizenid),
    item: ObjectId(itemId2),
    quantity_requested: 1,
    status: 'Fulfilled',
    date_requested: new Date('2023-11-25T13:15:00Z'),
    date_fulfilled: new Date('2023-11-25T13:30:00Z'),
  },
  {
    citizen_id: ObjectId(citizenid),
    item: ObjectId(itemId),
    quantity_requested: 4,
    status: 'Pending',
    date_requested: new Date('2023-11-25T13:30:00Z'),
  },
]);

db.Offers.insertMany([
  {
    citizen_id: ObjectId(citizenid),
    items: [
      { item_id: ObjectId(itemId1), quantity: 2 },
      { item_id: ObjectId(itemId2), quantity: 1 },
      { item_id: ObjectId(itemId), quantity: 3000 },
    ],
    status: 'Pending',
    date_offered: new Date('2023-11-25T12:00:00Z'),
  },
  {
    citizen_id: ObjectId(citizenid),
    items: [
      { item_id: ObjectId(itemId1), quantity: 5 },
      { item_id: ObjectId(itemId), quantity: 10 },
    ],
    status: 'In Progres',
    date_offered: new Date('2023-11-26T15:30:00Z'),
    date_accepted: new Date('2023-11-27T10:45:00Z'),
  },
  {
    citizen_id: ObjectId(citizenid),
    items: [
      { item_id: ObjectId(itemId), quantity: 3 },
      { item_id: ObjectId(itemId2), quantity: 8 },
    ],
    status: 'Cancelled',
    date_offered: new Date('2023-11-28T08:20:00Z'),
  },
  {
    citizen_id: ObjectId(citizenid),
    items: [
      { item_id: ObjectId(itemId), quantity: 3 },
      { item_id: ObjectId(itemId2), quantity: 8 },
    ],
    status: 'Fulfilled',
    date_offered: new Date('2023-11-28T08:20:00Z'),
    date_accepted: new Date('2024-11-27T10:45:00Z'),
  },
  
]);

const request = db.Requests.findOne({ status: 'Pending' });
const requestid =request._id;
const request1 = db.Requests.findOne({ status: 'Fulfilled' });
const requestid1 =request1._id;
const request2 = db.Requests.findOne({ status: 'Accepted' });
const requestid2 =request2._id;
db.Tasks.insertMany([
  {
  type: 'request',
  task_type: ObjectId(requestid), 
  status: 'Pending',
  date_created: new Date('2023-11-25T10:00:00Z'),
  },
  {
  type: 'request',
  task_type: ObjectId(requestid1), 
  status: 'Completed',
  date_created: new Date('2023-11-25T10:00:00Z'),
  date_assigned: new Date('2023-11-25T12:15:00Z'),
  date_completed: new Date('2023-11-25T15:45:00Z'),
  },
  {
    type: 'request',
    task_type: ObjectId(requestid2), 
    status: 'In Progress',
    date_created: new Date('2023-11-25T10:00:00Z'),
    date_assigned: new Date('2023-11-25T12:15:00Z'),
  }
]);

const offer = db.Offers.findOne({ status: 'Pending' });
const offerid =offer._id;
const offer1 = db.Offers.findOne({ status: 'In Progres' });
const offerid1 =offer1._id;
const offer2 = db.Offers.findOne({ status: 'Cancelled' });
const offerid2 =offer2._id;
const offer3 = db.Offers.findOne({ status: 'Fulfilled' });
const offerid3 =offer3._id;

db.Tasks.insertMany([
  {
  type: 'offer',
  task_type: ObjectId(offerid), 
  status: 'Pending',
  date_created: new Date('2023-11-25T10:00:00Z'),
  },
  {
  type: 'offer',
  task_type: ObjectId(offerid1), 
  status: 'In Progress',
  date_created: new Date('2023-11-25T10:00:00Z'),
  date_assigned: new Date('2023-11-25T12:15:00Z'),
  },
  {
    type: 'offer',
    task_type: ObjectId(offerid3), 
    status: 'Completed',
    date_created: new Date('2023-11-25T10:00:00Z'),
    date_assigned: new Date('2023-11-25T12:15:00Z'),
    date_assigned: new Date('2023-11-25T12:15:00Z'),

  },
  {
    type: 'offer',
    task_type: ObjectId(offerid2), 
    status: 'Cancelled',
    date_created: new Date('2023-11-25T10:00:00Z'),
    date_assigned: new Date('2023-11-25T12:15:00Z'),
  }
]);


const task = db.Tasks.findOne({ type: 'request' , status:'In Progress' });
const taskid = task._id;
const task1 = db.Tasks.findOne({ type: 'offer', status:'In Progress' });
const taskid1 = task1._id;

db.Vehicles.insertOne({
  rescuer_id: ObjectId(rescuerid), 
  vehicle_name: 'Rescue Vehicle 1',
  current_location: {
    type: "Point",
    coordinates: [38.254837, 21.743031],
  },
  status: "Tasked",
  items: [
    { item_id: ObjectId(itemId), quantity: 2 },   
    { item_id: ObjectId(itemId1), quantity: 7 },  
    { item_id: ObjectId(itemId2), quantity: 700 },
  ],
  active_tasks: [
    ObjectId(taskid),   
    ObjectId(taskid1), 
  ],
});

