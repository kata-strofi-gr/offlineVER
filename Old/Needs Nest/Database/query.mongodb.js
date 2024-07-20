// Needs extension MongoDB for VSCode
use('NeedsNest');
const result = db.Inventory.aggregate([
    {
      $unwind: "$items", // Unwind the items array
    },
    {
      $lookup: {
        from: "Items",
        localField: "items.item",
        foreignField: "_id",
        as: "itemDetails",
      },
    },
    {
      $project: {
        _id: 0, // Exclude the ID from the result
        itemName: "$itemDetails.item_name",
        quantity: "$items.quantity",
      },
    },
  ]);
  
print('-------------------------------------');
  result.forEach((item) => {
    printjson(item);
  });

  result = db.Announcements.aggregate([
    {
      $lookup: {
        from: 'Users', 
        localField: 'admin_id',
        foreignField: '_id',
        as: 'admin',
      },
    },
    {
      $unwind: '$admin',
    },
    {
      $unwind: '$items',
    },
    {
      $lookup: {
        from: 'Items', 
        localField: 'items.item_id',
        foreignField: '_id',
        as: 'item',
      },
    },
    {
      $unwind: '$item',
    },
    {
      $project: {
        _id: 0,
        announcement_title: '$title',
        announcement_message: '$message',
        item_name: '$item.item_name',
        item_quantity: '$items.quantity',
        date_created: '$date_created',
        administrator_username: '$admin.username',
        
      },
    },
  ]);
  print('-------------------------------------');
  result.forEach((item) => {
    printjson(item);
  });

 
  result=db.Requests.aggregate([
    {
      $lookup: {
        from: 'Users',
        localField: 'citizen_id',
        foreignField: '_id',
        as: 'citizen',
      },
    },
    {
      $unwind: '$citizen',
    },
    {
      $lookup: {
        from: 'Items',
        localField: 'item',
        foreignField: '_id',
        as: 'item',
      },
    },
    {
      $unwind: '$item',
    },
    {
      $project: {
        _id: 0,
        user_name: '$citizen.username',
        item_name: '$item.item_name',
        quantity_requested: '$quantity_requested',
        status: '$status',
        date_requested: '$date_requested',
        date_fulfilled: '$date_fulfilled',
      },
    },
  ]);

  print('-------------------------------------');
  result.forEach((item) => {
    printjson(item);
  });

  result=db.Requests.aggregate([
    {
      $lookup: {
        from: 'Users',
        localField: 'citizen_id',
        foreignField: '_id',
        as: 'citizen',
      },
    },
    {
      $unwind: '$citizen',
    },
    {
      $lookup: {
        from: 'Items',
        localField: 'item',
        foreignField: '_id',
        as: 'item',
      },
    },
    {
      $unwind: '$item',
    },
    {
       $match: {
         quantity_requested:{$gte: 4},
       }
    },
    {
      $project: {
        _id: 0,
        user_name: '$citizen.username',
        item_name: '$item.item_name',
        quantity_requested: '$quantity_requested',
        status: '$status',
        date_requested: '$date_requested',
        date_fulfilled: '$date_fulfilled',
      },
    },
  ]);

  print('-------------------------------------');
  result.forEach((item) => {
    printjson(item);
  });


  result=db.Offers.aggregate([
    {
      $lookup: {
        from: 'Users',
        localField: 'citizen_id',
        foreignField: '_id',
        as: 'citizen',
      },
    },
    {
      $unwind: '$citizen',
    },
    {
      $unwind: '$items',
    },
    {
      $lookup: {
        from: 'Items',
        localField: 'items.item_id',
        foreignField: '_id',
        as: 'item',
      },
    },
    {
      $project: {
        _id: 0,
        user_name: '$citizen.username',
        item_name: '$item.item_name',
        quantity_requested: '$items.quantity',
        status: '$status',
        date_offered: '$date_offered',
        date_accepted: '$date_accepted',
      },
    },
  ]);

  print('-------------------------------------');
  result.forEach((item) => {
    printjson(item);
  });

result = db.Tasks.aggregate([
  {
    $match: { type: 'request', 
  } ,
  },
  {
    $lookup: {
      from: 'Requests',
      localField: 'task_type',
      foreignField: '_id',
      as: 'request'
    }
  },
  {
    $unwind: '$request'
  },
  {
    $lookup: {
      from: 'Users',
      localField: 'request.citizen_id',
      foreignField: '_id',
      as: 'citizen'
    }
  },
  {
    $unwind: '$citizen'
  },
  {
    $lookup: {
      from: 'Items',
      localField: 'request.item',
      foreignField: '_id',
      as: 'item',
    },
  },
  {
    $unwind: '$item',
  },
{
    $project: {
      _id: 0,
      type : 1 ,
      citizenUsername: '$citizen.username',
      itemName: '$item.item_name',
      quantity: '$request.quantity_requested',
      date_created: 1,
      date_assigned: 1,
      date_completed: 1,
      status: 1
    }
  }
]);

  print('-------------------------------------');
  result.forEach((item) => {
    printjson(item);
  });


  result = db.Tasks.aggregate([
    {
      $match: { type: 'request', 
    } ,
    },
    {
      $lookup: {
        from: 'Requests',
        localField: 'task_type',
        foreignField: '_id',
        as: 'request'
      }
    },
    {
      $unwind: '$request'
    },
    {
      $lookup: {
        from: 'Users',
        localField: 'request.citizen_id',
        foreignField: '_id',
        as: 'citizen'
      }
    },
    {
      $unwind: '$citizen'
    },
    {
      $lookup: {
        from: 'Items',
        localField: 'request.item',
        foreignField: '_id',
        as: 'item',
      },
    },
    {
      $unwind: '$item',
    },
  {
      $project: {
        _id: 0,
        type : 1 ,
        citizenUsername: '$citizen.username',
        itemName: '$item.item_name',
        quantity: '$request.quantity_requested',
        date_created: 1,
        date_assigned: 1,
        date_completed: 1,
        status: 1
      }
    }
  ]);
  
    print('-------------------------------------');
    result.forEach((item) => {
      printjson(item);
    });


    result= db.Vehicles.aggregate([
      {
        $lookup: {
          from: 'Users',
          localField: 'rescuer_id',
          foreignField: '_id',
          as: 'rescuerDetails',
        },
      },
      {
        $unwind: '$rescuerDetails',
      },
      {
        $lookup: {
          from: 'Tasks',
          localField: 'active_tasks',
          foreignField: '_id',
          as: 'taskDetails',
        },
      },
      {
        $unwind: {
          path: '$taskDetails',
          preserveNullAndEmptyArrays: true,
        },
      },
      {
        $lookup: {
          from: 'Items',
          localField: 'items.item_id',
          foreignField: '_id',
          as: 'itemDetails',
        },
      },
      {
        $project: {
          rescuer_name: '$rescuerDetails.username',
          vehicle_name: 1,
          current_location: 1,
          status: 1,
          task_type: '$taskDetails.type',
          item_name: '$itemDetails.item_name',
          quantity: '$items.quantity',
        },
      },
    ])


    print('-------------------------------------');
    result.forEach((item) => {
      printjson(item);
    });