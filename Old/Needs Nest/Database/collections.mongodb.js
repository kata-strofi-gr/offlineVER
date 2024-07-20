// Needs extension MongoDB for VSCode
use('NeedsNest');

// **MongoDB Schema Creation**

// Drop existing collections
db.Users.drop(); // Drop the 'Users' collection
db.Base.drop(); // Drop the 'Base' collection
db.Items.drop(); // Drop the 'Items' collection
db.Inventory.drop(); // Drop the 'Inventory' collection

// Create the 'Users' collection with validation schema
db.createCollection('Users', {
  validator: {
    $jsonSchema: {
      bsonType: 'object', // The document must be an object
      required: ['username', 'password', 'type'], // The 'username', 'password', and 'type' fields are required
      properties: {
        _id: { // The '_id' field
          bsonType: 'objectId', // Must be an ObjectId type
          description: 'Unique identifier for the user' // Purpose of the field
        },
        type: { // The 'type' field
          bsonType: 'array', // Must be an array type
          description: 'Type of the user (citizen, rescuer, administrator)', // Purpose of the field
          items: { // Items within the 'type' array
            bsonType: 'string', // Must be a string type
            enum: ['citizen', 'rescuer', 'administrator'], // Allowed values for the 'type' field items
          }
        },
        username: { // The 'username' field
          bsonType: 'string', // Must be a string type
          description: 'Username for the user' // Purpose of the field
        },
        password: { // The 'password' field
          bsonType: 'string', // Must be a string type
          description: 'Password for the user' // Purpose of the field
        },
        firstName: { // The 'firstName' field (optional)
          bsonType: 'string', // Must be a string type
          description: 'First name of the user' // Purpose of the field
        },
        lastName: { // The 'lastName' field (optional)
          bsonType: 'string', // Must be a string type
          description: 'Last name of the user' // Purpose of the field
        },
        phoneNumber: { // The 'phoneNumber' field (optional)
          bsonType: 'string', // Must be a string type
          description: 'Phone number of the user' // Purpose of the field
        },
        address: { // The 'address' field (optional)
          bsonType: 'string', // Must be a string type
          description: 'Address of the user' // Purpose of the field
        }
      }
    }
  }
});

// Create the 'Base' collection with validation schema
db.createCollection('Base', {
  validator: {
    $jsonSchema: {
      bsonType: 'object', // The document must be an object
      required: ['base_name', 'base_location'], // The 'base_name' and 'base_location' fields are required
      properties: {
        _id: { // The '_id' field
          bsonType: 'objectId', // Must be an ObjectId type
          description: 'Unique identifier for the base' // Purpose of the field
        },
        base_name: { // The 'base_name' field
          bsonType: 'string', // Must be a string type
          description: 'Name of the base' // Purpose of the field
        },
        base_location: { // The 'base_location' field
          bsonType: 'object', // Must be an object type
          description: 'Location of the base in GeoJSON format (Point)', // Purpose of the field
          properties: {
            type: { // The 'type' property within 'base_location'
              bsonType: 'string', // Must be a string type
              enum: ['Point'], // Allowed value for the 'type' property: 'Point'
            },
            coordinates: { // The 'coordinates' property within 'base_location'
              bsonType: 'array', // Must be an array type
              items: { // Items within the 'coordinates' array
                bsonType: 'number', // Must be a number type
              },
              minItems: 2, // Minimum number of items in the 'coordinates' array (2)
              maxItems: 2 // Maximum number of items in the 'coordinates' array (2)
            }
          }
        }
      }
    }
  }
});

db.createCollection('Items', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['category', 'item_name', 'description'],
      properties: {
        _id: {
          bsonType: 'objectId',
          description: 'Unique identifier for the item',
        },
        category: {
          bsonType: 'string',
          description: 'Category of the item',
        },
        item_name: {
          bsonType: 'string',
          description: 'Name of the item',
        },
        description: {
          bsonType: 'string',
          description: 'Description of the item',
        },
        expire_date: {
          bsonType: 'date',
          description: 'Expiration date and time of the item',
        },
      },
    },
  },
});


db.createCollection('Inventory', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['items', 'base'],
      properties: {
        _id: {
          bsonType: 'objectId',
          description: 'Unique identifier for the inventory item',
        },
        items: {
          bsonType: 'array',
          description: 'Array containing references to the Items Collection and quantities',
          items: {
            bsonType: 'object',
            required: ['item', 'quantity'],
            properties: {
              item: {
                bsonType: 'objectId',
                description: 'Reference to the Items Collection',
              },
              quantity: {
                bsonType: 'int',
                description: 'Quantity of the item in the base',
              },
            },
          },
        },
        base: {
          bsonType: 'objectId',
          description: 'Reference to the Base Collection',
        },
      },
    },
  },
});


db.Announcements.drop();

db.createCollection('Announcements', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['admin_id', 'items', 'title', 'message', 'date_created'],
      properties: {
        _id: {
          bsonType: 'objectId',
          description: 'Unique identifier for the announcement',
        },
        admin_id: {
          bsonType: 'objectId',
          description: 'Reference to the Users collection for the administrator',
        },
        items: {
          bsonType: 'array',
          description: 'Array containing item details',
          items: {
            bsonType: 'object',
            required: ['item_id', 'quantity'],
            properties: {
              item_id: {
                bsonType: 'objectId',
                description: 'Reference to the Items collection',
              },
              quantity: {
                bsonType: 'int',
                description: 'Quantity of the item in the announcement',
              },
            },
          },
        },
        title: {
          bsonType: 'string',
          description: 'Title of the announcement',
        },
        message: {
          bsonType: 'string',
          description: 'Message content of the announcement',
        },
        date_created: {
          bsonType: 'date',
          description: 'Date when the announcement was created',
        },
      },
    },
  },
});

db.Requests.drop();
db.createCollection('Requests', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['citizen_id', 'item', 'quantity_requested', 'status', 'date_requested'],
      properties: {
        _id: {
          bsonType: 'objectId',
          description: 'Unique identifier for the request',
        },
        citizen_id: {
          bsonType: 'objectId',
          description: 'Reference to the Users collection for the citizen',
        },
        item: {
          bsonType: 'objectId',
          description: 'Reference to the Items collection',
        },
        quantity_requested: {
          bsonType: 'int',
          description: 'Quantity of the item requested',
        },
        status: {
          bsonType: 'string',
          enum: ['Pending', 'Accepted' ,'Fulfilled'],
          description: 'Status of the request (Pending, Accepted , Fulfilled)',
        },
        date_requested: {
          bsonType: 'date',
          description: 'Date when the request was made',
        },
        date_fulfilled: {
          bsonType: 'date',
          description: 'Date when the request was fulfilled (optional)',
        },
      },
    },
  },
});

db.Offers.drop();
db.createCollection('Offers', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['citizen_id', 'items', 'status', 'date_offered'],
      properties: {
        _id: {
          bsonType: 'objectId',
          description: 'Unique identifier for the offer',
        },
        citizen_id: {
          bsonType: 'objectId',
          description: 'Reference to the Users collection for the citizen',
        },
        items: {
          bsonType: 'array',
          items: {
            bsonType: 'object',
            required: ['item_id', 'quantity'],
            properties: {
              item_id: {
                bsonType: 'objectId',
                description: 'Reference to the Items collection',
              },
              quantity: {
                bsonType: 'int',
                description: 'Quantity of the offered item',
              },
            },
          },
          description: 'Array containing items with their quantity',
        },
        status: {
          bsonType: 'string',
          enum: ['Pending', 'In Progres', 'Cancelled','Fulfilled'],
          description: 'Status of the offer (Pending, Accepted, Cancelled, Fulfilled)',
        },
        date_offered: {
          bsonType: 'date',
          description: 'Date when the offer was made',
        },
        date_accepted: {
          bsonType: 'date',
          description: 'Date when the offer was accepted (optional)',
        },
      },
    },
  },
});

db.Tasks.drop();
db.createCollection('Tasks', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['type', 'task_type', 'date_created', 'status'],
      properties: {
        _id: {
          bsonType: 'objectId',
          description: 'Unique identifier for the task',
        },
        type: {
          bsonType: 'string',
          enum: ['request', 'offer'],
          description: 'Type of the task (request or offer)',
        },
        task_type: {
          bsonType: 'objectId',
          description: 'Reference to the Offers or Requests collection based on task type',
        },
        date_created: {
          bsonType: 'date',
          description: 'Date when the task was created',
        },
        date_assigned: {
          bsonType: 'date',
          description: 'Date when the task was assigned (optional)',
        },
        date_completed: {
          bsonType: 'date',
          description: 'Date when the task was completed (optional)',
        },
        status: {
          bsonType: 'string',
          enum: ['Pending', 'In Progress', 'Completed', 'Cancelled'],
          description: 'Status of the task (Pending, In Progress, Completed, Cancelled)',
        },
      },
    },
  },
});
db.Vehicles.drop();
db.createCollection('Vehicles', {
  validator: {
    $jsonSchema: {
      bsonType: 'object',
      required: ['rescuer_id', 'vehicle_name', 'current_location', 'status', 'items', 'active_tasks'],
      properties: {
        _id: {
          bsonType: 'objectId',
          description: 'Unique identifier for the vehicle',
        },
        rescuer_id: {
          bsonType: 'objectId',
          description: 'Reference to Users collection for the rescuer',
        },
        vehicle_name: {
          bsonType: 'string',
          description: 'Name of the vehicle',
        },
        current_location: {
          bsonType: 'object',
          required: ['type', 'coordinates'],
          description: 'GeoJSON representing the current location of the vehicle',
          properties: {
            type: {
              bsonType: 'string',
              description: 'Type of GeoJSON (Point)',
            },
            coordinates: {
              bsonType: 'array',
              description: 'Array of coordinates [longitude, latitude]',
              items: {
                bsonType: 'double',
              },
              minItems: 2,
              maxItems: 2,
            },
          },
        },
        status: {
          bsonType: 'string',
          enum: ['Available', 'Tasked'],
          description: 'Status of the vehicle (Available or Tasked)',
        },
        items: {
          bsonType: 'array',
          description: 'Array of references to Items with quantity',
          items: {
            bsonType: 'object',
            required: ['item_id', 'quantity'],
            properties: {
              item_id: {
                bsonType: 'objectId',
                description: 'Reference to Items collection for the item',
              },
              quantity: {
                bsonType: 'int',
                description: 'Quantity of the item in the vehicle',
              },
            },
          },
        },
        active_tasks: {
          bsonType: 'array',
          description: 'Array of references to active Tasks',
          items: {
            bsonType: 'objectId',
            description: 'Reference to Tasks collection for the active task',
          },
          maxItems: 4,
        },
      },
    },
  },
});