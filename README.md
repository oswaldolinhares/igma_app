# README
![Descrição da Imagem](./images/igma.png)

## Description ##

In Igma's technical test, you will be challenged to create a customer registration API with CPF validation before storing them in the database. The technical requirements include creating endpoints for creating customers, searching for customers by CPF, and listing all customers with pagination. You must also implement a CPF validation algorithm manually, choose your preferred programming language and database, and follow best programming practices such as object-oriented programming, testing, and documentation.

## Tooling ##

### Versions ###
* **Ruby**  3.3.0  
* **Rails**  7.1.3  


### Database and Storage ###   
* **SQlite3** 1.4  

### Testing ###   
* **Rspec-rails**  Testing framework for Rails.  
* **Database_cleaner-active_record** Maintaining database consistency during Ruby on Rails tests.   
* **FactoryBotRails**  Used to easily create test objects with fake data.  
* **Faker**  Generates random data for testing.  
* **Shoulda-matchers**  Provides simplifications for testing Rails functionality. 

### Development ###   
* **Rubocop**  Code style analyzer and linter.  
* **Pry**  Debug and explore Ruby code interactively for better development.  

## Getting Started ##   
To get started, ensure that you have the following prerequisites installed on your system:

* Ruby (version 3.3.0)  
* Rails (version 7.1.3)  
* SQLite  

### Setup ###  

1. Clone the repository to your local machine.  

`git clone https://github.com/oswaldolinhares/igma_app`  
  
2. Navigate to the project directory.   

`cd igma_app`  

3. Run the following command to set up the project, which will install dependencies, create the database, and perform necessary setup tasks.     

`cd bin/setup`  

### Running tests ###  

This command will execute all the tests

`bundle exec rspec spec`  

### Running the project ###  

This will start the development server, and you can access the application at http://localhost:3000.

`bundle exec rails server` 

# API Documentation

The Customer Registration API allows you to create, list, and search for customers. You can use the following requests to test different scenarios:

## Create a Client with Valid Parameters

**Método:** POST
**URL:** `http://localhost:3000/api/customers`  
**Body:**
```json
{
  "customer": {
    "name": "John Doe",
    "cpf": "110.446.620-18",
    "date_of_birth": "2000-01-01"
  }
}
```
**Status:** 201 Created  
**Response:**  
```json
{
  "customer": {
    "id": 1,
    "name": "John Doe",
    "cpf": "11044662018",
    "date_of_birth": "2000-01-01",
    "created_at": "2024-01-20T13:55:49.540Z",
    "updated_at": "2024-01-20T13:55:49.540Z"
  }
}
```

## Create a Client with Invalid Data

**Método:** POST  
**URL:** `http://localhost:3000/api/customers`  
**Body:**
```json
{
  "customer": {
    "name": null,
    "cpf": "110.446.620-18",
    "date_of_birth": "2000-01-01"
  }
}
```
**Status:** 422 Unprocessable Content  
**Response:**  
```json
{
  "errors": [
    "Name can't be blank"
  ]
}
```

## Create a Client with Invalid CPF (Tax Identification Number)

**Método:** POST  
**URL:** `http://localhost:3000/api/customers`  
**Body:**
```json
{
  "customer": {
    "name": "John Doe",
    "cpf": "A10.446.620-18",
    "date_of_birth": "2000-01-01"
  }
}
```
**Status:** 422 Unprocessable Content  
**Response:**  
```json
{
  "errors": [
    "Cpf is invalid"
  ]
}
```

## List Clients when there are no registrations

**Método:** GET  
**URL:** `http://localhost:3000/api/customers`  
**Status:** 200 Ok  
**Response:**
```json
{
  "customers": []
}
```

## List Clients with Pagination

**Método:** GET  
**URL:** `http://localhost:3000/api/customers?page=2&per_page=5`  
**Status:** 200 Ok  
**Response:**  
```json
{
  "customers": [
    {
      "id": 1,
      "name": "John Doe",
      "cpf": "11044662018",
      "date_of_birth": "2000-01-01",
      "created_at": "2024-01-20T13:55:49.540Z",
      "updated_at": "2024-01-20T13:55:49.540Z"
    },
    {
      "id": 1,
      "name": "Astolfo Rdolfo",
      "cpf": "14232187412",
      "date_of_birth": "2000-01-01",
      "created_at": "2024-01-20T13:55:49.540Z",
      "updated_at": "2024-01-20T13:55:49.540Z"
    }
  ]
}
```

## Search by CPF (Tax Identification Number)

**Método:** GET  
**URL:** `http://localhost:3000/api/customers?cpf=110.446.620-18`  
**Status:** 200 Ok  
**Response:**  
```json
{
  "customer": {
    "id": 1,
    "name": "John Doe",
    "cpf": "11044662018",
    "date_of_birth": "2000-01-01",
    "created_at": "2024-01-20T13:55:49.540Z",
    "updated_at": "2024-01-20T13:55:49.540Z"
  }
}
```
## Search by Invalid CPF (Tax Identification Number)

**Método:** GET  
**URL:** `http://localhost:3000/api/customers?cpf=A10.446.620-18`  
**Status:** 422 Unprocessable Content  
**Response:**  
```json
{
  "error": "CPF is invalid"
}
```

## Search by CPF of Unregistered Client

**Método:** GET  
**URL:** `http://localhost:3000/api/customers?cpf=410.446.620-18`  
**Status:** 404 Not Found  
**Response:**  
```json
{
  "error": "Customer not found"
}
```
