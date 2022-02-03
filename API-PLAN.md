# Customer Flybuys Service

This document outlines the proposal for a Customer Flybuys service.

## Key responsibilities
- An API to add Flybuys points to a customer’s account.
- An API for viewing customer’s Flybuys points balances.


## DB tables

### Table `customers`.
| Column | Datatype | PK | NN | UN | AI |
| -- | -- | -- | -- | -- | -- |
| id | INT(15) | Yes | Yes | -- | Yes |
| card_number | VARCHAR(100) | -- | Yes | Yes | -- |
| first_name | VARCHAR(100) | -- | Yes | -- | -- |
| middle_name | VARCHAR(100) | -- | -- | -- | -- |
| last_name | VARCHAR(100) | -- | Yes | -- | -- |
| email_address | VARCHAR(50) | -- | -- | -- | -- |
| date_of_birth | DATE | -- | Yes | -- | -- |
| created_at | DATE | -- | Yes | -- | -- |

### Table `partners`.
| Column | Datatype | PK | NN | UN | AI |
| -- | -- | -- | -- | -- | -- |
| id | INT(15) | Yes | Yes | -- | Yes |
| partner_name | VARCHAR(100) | -- | Yes | -- | -- |
| created_at | DATE | -- | Yes | -- | -- |

### Table `users`.
| Column | Datatype | PK | NN | UN | AI |
| -- | -- | -- | -- | -- | -- |
| id | INT(15) | Yes | Yes | -- | Yes |
| account_number | VARCHAR(100) | -- | Yes | Yes | -- |
| password | VARCHAR(100) | -- | Yes | -- | -- |
| first_name | VARCHAR(100) | -- | Yes | -- | -- |
| last_name | VARCHAR(100) | -- | Yes | -- | -- |
| group | INT(10) | -- | Yes | -- | -- |
| active | INT(1) | -- | Yes | -- | -- |
| created_at | DATE | -- | Yes | -- | -- |
- `account_number`: The unique key number 
- `active`: 1 or 0
- `group`: 0 - system user, 1 - admin, 2 - partner, 3 - staff, 4 - manager

### Table `flybuy_points`.
| Column | Datatype | PK | NN | UN | AI |
| -- | -- | -- | -- | -- | -- |
| id | INT(15) | Yes | Yes | -- | Yes |
| customer_id | INT(15) | -- | Yes | Yes | -- |
| balance | INT(15) | -- | Yes | -- | -- |
| created_at | DATE | -- | Yes | -- | -- |
| updated_at | DATE | -- | Yes | -- | -- |

### Table `flybuy_records`.
| Column | Datatype | PK | NN | UN | AI |
| -- | -- | -- | -- | -- | -- |
| id | INT(15) | Yes | Yes | -- | Yes |
| customer_id | INT(15) | -- | Yes | -- | -- |
| partner_id | INT(15) | -- | Yes | -- | -- |
| points | INT(15) | -- | Yes | -- | -- |
| comment | VARCHAR(100) | -- | Yes | -- | -- |
| status | VARCHAR(45) | -- | Yes | -- | -- |
| created_at | DATE | -- | Yes | -- | -- |
| updated_at | DATE | -- | Yes | -- | -- |
- `points`: This value can be positive or negative, a positive value means increasing points, a negative value means decreasing a few points
- `status`: pending, approved, cancelled

### Table `flybuy_record_activities`.
| Column | Datatype | PK | NN | UN | AI |
| -- | -- | -- | -- | -- | -- |
| id | INT(15) | Yes | Yes | -- | Yes |
| flybuy_record__id | INT(15) | -- | Yes | -- | -- |
| action | VARCHAR(45) | -- | Yes | -- | -- |
| user_id | INT(15) | -- | Yes | -- | -- |
| user_name | VARCHAR(100) | -- | Yes | -- | -- |
| comment | VARCHAR(100) | -- | Yes | -- | -- |
| created_at | DATE | -- | Yes | -- | -- |
- `action`: approved, cancelled, added
- `user_name`: The full name (first_name + last_name)


## Proposed Endpoints

Working name for the endpoint is `/flybuys-service/v1`.

| Method | URI | Description |
| -- | -- | -- |
| POST  | /flybuys | Create a record to add Flybuys points to a customer's account |
| GET   | /customers/{card_number} | Query customer's Flybuys points balance |

### Request Headers
| KEY | VALUE |
| Content-Type | application/vnd.api+json |
| Authorization | Basic YWxhZGRpbjpvcGVuc2VzYW1l |
| api-key | LKJDSDF99SDFJK0EFK |
| Accept | application/vnd.api+json |

### Create a record
`POST /flybuys`

#### **Request**
```json
{
    "data": {
        "type": "flybuys",
        "attributes": {
            "card_number": "60141016700078611",
            "partner_id": "22",
            "points": "-200",
            "comment": "This customer redeem 200 points to buy a gift."
        }
    }
}
```

#### Validation Rules
- `card_number` 16 to 19 characters, only numbers and spaces are allowed.
- `partner_id` only numbers are allowed.
- `points` only numbers are allowed and can not be zero.
- `comment` maximum allowed 100 characters

#### **Response Success**
```json
{
    "data": {
        "status": "success",
        "code": 200,
        "detail": "The request has been submitted successfully."
    }
}
```

#### **Response Error**
```json
{
    "errors": [{
        "status": "422",
        "source": {
            "pointer": "/data/attributes/points"
        },
        "title":  "Invalid Attribute",
        "detail": "The value of points can not be zero."
    }]
}
```

### Get a customer's Flybuys points balance
`Get /customers/{card_number}`

#### **Response**
```json
{
  "data": {
    "type": "customers",
    "id": "60141016700078611",
    "attributes": {
      "balance": "288",
      "first_name": "Tom",
      "middle_name": "Jack",
      "last_name": "JK",
      "email_address" : "Tom.JK@gmail.com",
      "date_of_birth": "2019-02-06"
    }
  }
}
```

## PubSub

### Topics
- `flybuys.points-record-created` - used to notify remote services to add records one by one
#### **Note** 
There might be more than thousands of partners who will use this API at the same time, so we use PubSub which allows services to communicate asynchronously by broadcasting events.


## Assumptions
- There should be a backend interface for staffs to view, approve or cancel requests.
- The Flybuys points will be only counted into balance once the request is approved.
- All requests will be stored in the table `flybuy_records` and won't never be removed.
- Table `flybuy_record_activities` records all activities, e.g. points adding, requests cancellation and approvals.
