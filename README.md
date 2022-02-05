# The Ice Cream Truck

![Build Status](https://github.com/simplecov-ruby/simplecov/workflows/stable/badge.svg?branch=main)

Ice Cream Truck is a fictional ice cream vendor represented through Ruby on Rails API interface. It features end points necessary to conduct business with a said truck. This implementation shows a simplified e-commerce setup and can be easily expanded upon.

The project is [online](http://icecreamtruck.xyz). You can see available API routes in action on [Postman](https://www.postman.com/science-candidate-75542469/workspace/altera-consulting-public/request/14871795-53a24fd0-7117-4ded-897b-81d962ef533c) (requires a free account).

To read a better styled version of this reference document go to [HTML documentation]().



## Installation
---
### Requirements
* Bundler 2.3.4
* Ruby 3.1.0
* Ruby on Rails 7.0.1
* Yarn 1.22.15
* PostgreSQL 14.1

### Setup
```sh
git clone git@github.com:JazzJackrabbit/icecreamtruck.git
cd icecreamtruck
bundle install
bin/rake db:create
bin/rake db:schema:load
bin/rake db:seed
```
### Run
Launch the server Procfile with your favorite tool. Yours truly is using [Hivemind](https://github.com/DarthSim/hivemind).
```sh
hivemind Procfile
```


### Test

Run the test suite with ```rspec```. 
Supplementary coverage report is generated to *(icecreamtruck)/coverage/index.html*.


## Documentation
---
### Database Schema

![Build](https://uce22ad804fb51db56099f1f7cbc.previews.dropboxusercontent.com/p/thumb/ABYIgctAqL1aHZoege6TFkEr12hpPV9-m-GE7CANtmzRVf-d1jHrv2VEjQ9dyv-lwqWRBuB3N06LXKbuBnolzDL9X4bKn2y-wlfdf9sP3NWEUHAidjAtXIxc_afXXbe4E8zs4dYPBIwrr1XNP89MtuTNW599ls3UFMPYDWE03eMu7NeNRJOaH_wpsVn_ihIipQl7e6jI8lic-SWqYiqhkrNcMj9PkaFwbuKUOtSgIScCyg7i8v2F9xjWL6LLoLRx5xyY0zazxAwoeaSFPthgzvAT6s1HneWQtQOX2tnZ16TOw3N-BXsi-A39oLPnnj1MpM4sPZOpku8t3aAQT7gzRXx5dPdvyz7G2KUibPUwJAvU9pYlLQlStcuPJUT_aEflDwc/p.png)

Basic data structures look as follows:

**Trucks** – Data entity for current truck and possible future ones (ID, Name).

**Products** - Individual products being sold (ID, Name, Category, Price, Labels). Product belongs to one category and can have many labels.

**Product Categories** – Categories for the products, such as ice cream, shaved ice and snacks (ID, Name). One category has many products.

**Product Inventories** – Inventory records for the truck (ID, Truck, Product, Quantity).

**Orders** – Order records (ID, Truck, Product, Quantity, TotalAmount).

**OrderItems** – Information about products belonging to a given order (ID, Order, Product, Quantity, FrozenProductPrice, FrozenProductName). "Frozen" data attributes exist to preserve order data in case related products get updated in the future.

Lastly, there is a **Merchants** table for admin user authentication and truck management.


### API Routes
---

#### **Customer**

Requests in this section are meant to be accessible by customers.

#### Request:  `GET /api/v1/trucks`

Description: Retrieves all trucks

Output format:
```json
{
    "data": {
        "trucks": [
            {
                "id": 1,
                "name": "The Scoop Bus"
            }
        ],
        "meta": {
            "page": 1,
            "per_page": 20,
            "total_pages": 1,
            "total_count": 1
        }
    }
}
```

#### Request: `GET /api/v1/trucks/:id`

Description: Retrieves individual truck data

Output format:
```json
{
    "data": {
        "id": 1,
        "name": "The Scoop Bus",
        "products": [
            {
                "id": 1,
                "name": "Chocolate Ice Cream",
                "price": "1.83",
                "labels": "chocolate"
            },
           ...
        ]
    }
}
```


#### Request: `POST /api/v1/trucks/:truck_id/orders`

Description: Creates an order for truck

Input format: 
```json
{
    "items_attributes": [{
        "product_id": 1,
        "quantity": 5
    }]
}
```

Output format:
```json
{
    "message": "ENJOY!",
    "data": {
        "order": {
            "id": 6,
            "truck_id": 1,
            "total_amount": "18.3",
            "created_at": "2022-02-04T01:26:13Z",
            "products": [
                {
                    "product": {
                        "id": 1,
                        "name": "Chocolate Ice Cream",
                        "price": "1.83"
                    },
                    "quantity": 10
                },
            ]
        }
    }
}
```

#### **Merchant**

Requests in this section are meant to be accessible by merchant and require authentication with a Bearer token in request headers.

#### Request: ```POST /api/v1/auth/sign_in```

Description: Authenticates user and returns an authentication token.

Input format: 
```json
{
   "email": "merchant@icecreamtruck.xyz",
   "password": 12345678
}
```

Output format (access token and response body): 
```json
{
    "access-token": "abcd1dMVlvW2BT67xIAS_A", 
    "token-type": "Bearer", 
    "client": "LSJEVZ7Pq6DX5LXvOWMq1w",
    "expiry": "1519086891", 
    "uid": "merchant@icecreamtruck.xyz"
}

{
    "data": {
        "email": "merchant@icecreamtruck.xyz",
        "provider": "email",
        "uid": "merchant@icecreamtruck.xyz",
        "id": 1,
        "allow_password_change": false,
        "name": null,
        "nickname": null,
        "image": null
    }
}
```

#### Request: ```POST /api/v1/trucks```

Description: Create a truck

Input format: requires uid, client and access-token headers
```json
{
    'name': 'Truck Name'
}
```

Output format:
```json
{
    "data": {
        "id": 2,
        "name": "New Truck",
        "products": []
    }
}
```

#### Request: ```PUT /api/v1/trucks/:id```

Description: Update truck information

Input format: requires uid, client and access-token headers
```json
{
    'name': 'New Truck Name'
}
```

Output format:
```json
{
    "message": "Truck has been updated",
    "data": {
        "truck": {
            "id": 2,
            "name": "New Truck"
        }
    }
}
```

#### Request: ```DELETE /api/v1/trucks/:id```

Description: Archives a truck

Input format: requires uid, client and access-token headers

Output format:
```json
{
    "message": "Truck has been permanently archived"
}
```

#### Request: ```GET	/api/v1/trucks/:truck_id/orders```

Description: Lists all orders for a given truck.

Input format: requires uid, client and access-token headers

Output format: 
```json
{
    "data": {
        "total_revenue": "58.23",
        "orders": [
            {
                "id": 6,
                "truck_id": 1,
                "total_amount": "18.3",
                "created_at": "2022-02-04T01:26:13Z"
            },
           ...
        ],
        "meta": {
            "page": 1,
            "per_page": 20,
            "total_pages": 1,
            "total_count": 6
        }
    }
}
```

#### Request: ```GET	/api/v1/trucks/:truck_id/inventory```

Description: List all products and their quantities for a given truck

Input format: requires uid, client and access-token headers

Output format: 
```json
{
    "data": {
        "inventory": [
            {
                "product": {
                    "id": 1,
                    "name": "Chocolate Ice Cream",
                    "price": "1.83",
                    "labels": "chocolate"
                },
                "quantity": 190,
                "updated_at": "2022-02-04T01:26:13Z"
            },
            {
                "product": {
                    "id": 2,
                    "name": "Pistachio Ice Cream",
                    "price": "1.5",
                    "labels": "pistachio"
                },
                "quantity": 200,
                "updated_at": "2022-02-03T21:29:50Z"
            },
            ...
        ]
    }
}
```

#### Request ```PUT /api/v1/trucks/:truck_id/inventory```

Description: Update inventory for a given truck

Input format: requires uid, client and access-token headers
```json
{
    "product_id": 1,
    "quantity": 150
}
```

Output format: 
```json
{
    "message": "Inventory was successfully updated",
    "data": {
        "inventory": {
            "truck_id": 1,
            "product_id": 1,
            "quantity": 100,
            "updated_at": "2022-02-03T22:05:37Z"
        }
    }
}
```

#### Request: ```DELETE /api/v1/trucks/:id/inventory```

Description: Archives a truck

Input format: requires uid, client and access-token headers
```json
{
    "product_id": 1
}
```

Output format:
```json
{
    "message": "Inventory record was successfully deleted"
}
```

#### Request: ```GET /api/v1/truck/:truck_id/orders```

Description: List all orders for truck

Input format: requires uid, client and access-token headers

Output format:
```json
{
    "data": {
        "total_revenue": "58.23",
        "orders": [
            {
                "id": 6,
                "truck_id": 1,
                "total_amount": "18.3",
                "created_at": "2022-02-04T01:26:13Z"
            },
            ...
        ],
        "meta": {
            "page": 1,
            "per_page": 20,
            "total_pages": 1,
            "total_count": 6
        }
    }
}
```

#### Request: ```GET /api/v1/orders/:id```

Description: Get detailed order information

Input format: requires uid, client and access-token headers

Output format:
```json
{
    "data": {
        "order": {
            "id": 1,
            "truck_id": 1,
            "total_amount": "8.02",
            "created_at": "2022-02-03T21:29:51Z",
            "products": [
                {
                    "product": {
                        "id": 4,
                        "name": "Mint Ice Cream",
                        "price": "4.01"
                    },
                    "quantity": 2
                }
            ]
        }
    }
}
```

#### Request: ```GET /api/v1/product/:id```

Description: Get detailed product information

Input format: requires uid, client and access-token headers

Output format:
```json
{
    "data": {
        "product": {
            "id": 1,
            "name": "Product",
            "category_id": 1,
            "category": "Category",
            "price": "12.34",
            "labels": "'Label'",
            "created_at": "2022-02-03T00:43:55Z",
            "updated_at": "2022-02-04T21:44:11Z"
        }
    }
}
```

#### Request: ```GET /api/v1/products```

Description: Get list of all products

Input format: requires uid, client and access-token headers

Output format:
```json
{
    "data": {
        "products": [
            {
                "id": 2,
                "name": "Pistachio Ice Cream",
                "category_id": 1,
                "category": "newname",
                "price": "2.78",
                "labels": "",
                "created_at": "2022-02-03T00:43:55Z",
                "updated_at": "2022-02-03T00:43:55Z"
            },
            ...
        ]
    }
}
```

#### Request: ```POST /api/v1/products```

Description: Create new product

Input format: requires uid, client and access-token headers
```json
{
    name: 'Name'
    labels: ['label'],
    price: 12.34,
    category_id: 1
}

```

Output format:
```json
{
    "data": {
        "product": {
            "id": 9,
            "name": "Name",
            "category_id": 1,
            "category": "Category",
            "price": "12.34",
            "labels": "",
            "created_at": "2022-02-05T00:34:32Z",
            "updated_at": "2022-02-05T00:34:32Z"
        }
    }
}
```

#### Request: ```PUT /api/v1/products/:id```

Description: Update product information

Input format: requires uid, client and access-token headers
```json
{
    name: 'New Name'
    labels: ['label'],
    price: 12.34,
    category_id: 1
}

```

Output format:
```json
{
    "message": "Product was updated.",
    "data": {
        "product": {
            "id": 1,
            "name": "New Name",
            "category_id": 1,
            "category": "newname",
            "price": "12.34",
            "labels": "'newlable'",
            "created_at": "2022-02-03T00:43:55Z",
            "updated_at": "2022-02-05T00:36:07Z"
        }
    }
}
```

#### Request: ```DELETE /api/v1/products/:id```

Description: Archives a product

Input format: requires uid, client and access-token headers

Output format:
```json
{
    "message": "Product has been permanently archived"
}
```

#### Request: ```GET /api/v1/categories/:id```

Description: Get detailed category information

Input format: requires uid, client and access-token headers

Output format:
```json
{
    "data": {
        "category": {
            "id": 1,
            "name": "Category",
            "updated_at": "2022-02-05T00:38:09Z"
        }
    }
}
```

#### Request: ```GET /api/v1/categories```

Description: Get list of all categories

Input format: requires uid, client and access-token headers

Output format:
```json
{
    "data": {
        "categories": [
            {
                "id": 2,
                "name": "Shaved Ice",
                "updated_at": "2022-02-03T00:43:55Z"
            },
            {
                "id": 3,
                "name": "Snack",
                "updated_at": "2022-02-03T00:43:55Z"
            }
        ]
    }
}
```

#### Request: ```POST /api/v1/categories```

Description: Create new product

Input format: requires uid, client and access-token headers
```json
{
    name: 'New Category'
}

```

Output format:
```json
{
    "data": {
        "category": {
            "id": 5,
            "name": "New Category",
            "updated_at": "2022-02-05T00:40:32Z"
        }
    }
}
```

#### Request: ```PUT /api/v1/categories/:id```

Description: Update category information

Input format: requires uid, client and access-token headers
```json
{
    name: 'Updated Name'
}

```

Output format:
```json
{
    "message": "Category was updated.",
    "data": {
        "product": {
            "id": 5,
            "name": "Updated Name",
            "updated_at": "2022-02-05T00:40:32Z"
        }
    }
}
```

#### Request: ```DELETE /api/v1/products/:id```

Description: Archives a category and all associated products

Input format: requires uid, client and access-token headers

Output format:
```json
{
    "message": "Category has been permanently archived"
}
```

## Credits
---
Kirill Ragozin for Altera Consulting.