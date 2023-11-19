create database warehouse_management;

drop database warehouse_management;

use warehouse_management;

show tables;

drop table products;


delete from Product;

delete from Employee;

delete from Customer;

delete from Supplier;

delete from Order1;

delete from Order_details;

delete from Payment;

delete from Warehouse;

delete from Category;

delete from PaymentMethod;

delete from Shipment;

CREATE TABLE Product (
    Product_id INT AUTO_INCREMENT PRIMARY KEY,
    Product_name VARCHAR(255),
    Unit_size VARCHAR(50),
    Unit_weight DECIMAL(10,2),
    Discount DECIMAL(5,2),
    Price DECIMAL(10,2),
    In_stock INT,
    Supplier_id INT,
    Category_id INT,
    FOREIGN KEY (Supplier_id) REFERENCES Supplier(Supplier_id),
    FOREIGN KEY (Category_id) REFERENCES Category(Category_id)
);

CREATE TABLE Employee (
    Employee_id INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Address VARCHAR(255),
    Phone_no VARCHAR(15),
    Position VARCHAR(50),
    HireDate DATE
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone VARCHAR(15),
    address VARCHAR(255),
    email VARCHAR(255),
    staff_id INT,
    MembershipLevel VARCHAR(50),
    MembershipExpiryDate DATE,
    FOREIGN KEY (staff_id) REFERENCES Employee(Employee_id)
);


CREATE TABLE Supplier (
    Supplier_id INT PRIMARY KEY,
    Phone VARCHAR(15),
    Address VARCHAR(255),
    Email VARCHAR(255),
    ContactPerson VARCHAR(255),
    BankDetails VARCHAR(255)
);


CREATE TABLE Order1 (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    staff_id INT,
    TotalAmount DECIMAL(10,2),
    Shipment_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id),
    FOREIGN KEY (staff_id) REFERENCES Employee(Employee_id)
);

CREATE TABLE Order_details (
    Order_id INT,
    Bill_number INT,
    product_id INT,
    Quantity INT,
    Subtotal DECIMAL(10,2),
    PRIMARY KEY (Order_id, Bill_number, product_id),
    FOREIGN KEY (Order_id) REFERENCES Order1(order_id),
    FOREIGN KEY (product_id) REFERENCES Product(Product_id)
);

CREATE TABLE Payment (
    PayDueDate DATE,
    PaymentType VARCHAR(50),
    Bill_number INT,
    Amount DECIMAL(10,2),
    PRIMARY KEY (PayDueDate, PaymentType, Bill_number)
);


CREATE TABLE Warehouse (
    Warehouse_id INT PRIMARY KEY,
    Location VARCHAR(255),
    Capacity INT,
    Manager_id INT,
    FOREIGN KEY (Manager_id) REFERENCES Employee(Employee_id)
);

CREATE TABLE Category (
    Category_id INT PRIMARY KEY,
    Category_name VARCHAR(255)
);

CREATE TABLE PaymentMethod (
    PaymentMethod_id INT PRIMARY KEY,
    MethodName VARCHAR(255)
);

CREATE TABLE Shipment (
    Shipment_id INT PRIMARY KEY,
    ShipmentDate DATE,
    Destination VARCHAR(255),
    Status VARCHAR(50),
    Order_id INT,
    Warehouse_id INT,
    FOREIGN KEY (Order_id) REFERENCES Order1(order_id),
    FOREIGN KEY (Warehouse_id) REFERENCES Warehouse(Warehouse_id)
);

delete from Supplier;

select *from Supplier;

INSERT INTO Supplier (Supplier_id, Phone, Address, Email, ContactPerson, BankDetails)
VALUES 
(1, '123-456-7890', '123 Main Street, Cityville, State, 12345', 'supplier1@example.com', 'Jay Shah', '1234-5678-9012-3456'),
(2, '234-567-8901', '456 Oak Avenue, Townsville, State, 23456', 'supplier2@example.com', 'Kota Bharadwaj', '2345-6789-0123-4567'),
(3, '345-678-9012', '789 Maple Drive, Villageton, State, 34567', 'supplier3@example.com', 'Srujan Kothuri', '3456-7890-1234-5678'),
(4, '456-789-0123', '101 Pine Circle, Hamletville, State, 45678', 'supplier4@example.com', 'Krish Bharadwaj', '4567-8901-2345-6789'),
(5, '567-890-1234', '202 Elm Lane, Boroughville, State, 56789', 'supplier5@example.com', 'Jawahar Balachandher', '5678-9012-3456-7890');


INSERT INTO Product (Product_id, Product_name, Unit_size, Unit_weight, Discount, Price, In_stock, Supplier_id, Category_id)
VALUES 
(1, 'Product A', 'Large', 10.5, 0.05, 50.00, 100, 1, 1),
(2, 'Product B', 'Medium', 7.2, 0.03, 30.00, 200, 2, 1),
(3, 'Product C', 'Small', 5.0, 0.02, 20.00, 150, 3, 2),
(4, 'Product D', 'Extra Large', 15.0, 0.07, 70.00, 50, 4, 2),
(5, 'Product E', 'Medium', 8.0, 0.04, 40.00, 180, 5, 3);


INSERT INTO Employee (Employee_id, First_Name, Last_Name, Address, Phone_no, Position, HireDate)
VALUES 
(1, 'Jay', 'Shah', '123 Main Street, Cityville, State, 12345', '123-456-7890', 'Manager', '2023-01-15'),
(2, 'Kota', 'Bharadwaj', '456 Oak Avenue, Townsville, State, 23456', '234-567-8901', 'Supervisor', '2023-02-20'),
(3, 'Srujan', 'Kothuri', '789 Maple Drive, Villageton, State, 34567', '345-678-9012', 'Clerk', '2023-03-25'),
(4, 'Krish', 'Bharadwaj', '101 Pine Circle, Hamletville, State, 45678', '456-789-0123', 'Clerk', '2023-04-30'),
(5, 'Jawahar', 'Balachandher', '202 Elm Lane, Boroughville, State, 56789', '567-890-1234', 'Clerk', '2023-05-05');


INSERT INTO Customer (customer_id, first_name, last_name, phone, address, email, staff_id, MembershipLevel, MembershipExpiryDate)
VALUES 
(1, 'Alice', 'Smith', '111-222-3333', '789 Oak Street, Villageton, State, 67890', 'alice@example.com', 1, 'Gold', '2024-01-15'),
(2, 'Bob', 'Johnson', '444-555-6666', '456 Maple Avenue, Townsville, State, 56789', 'bob@example.com', 2, 'Silver', '2024-02-20'),
(3, 'Eve', 'Brown', '777-888-9999', '123 Pine Lane, Hamletville, State, 45678', 'eve@example.com', 3, 'Bronze', '2024-03-25'),
(4, 'Charlie', 'Davis', '000-111-2222', '101 Elm Circle, Cityville, State, 34567', 'charlie@example.com', 1, 'Gold', '2024-04-30'),
(5, 'Grace', 'Lee', '333-444-5555', '202 Birch Drive, Boroughville, State, 23456', 'grace@example.com', 2, 'Silver', '2024-05-05');


INSERT INTO `Order1` (order_id, order_date, customer_id, staff_id, TotalAmount)
VALUES 
(1, '2023-06-10', 1, 1, 150.00),
(2, '2023-06-11', 2, 3, 120.00),
(3, '2023-06-12', 3, 2, 90.00),
(4, '2023-06-13', 4, 5, 200.00),
(5, '2023-06-14', 5, 1, 160.00);

INSERT INTO Order_details (Order_id, Bill_number, product_id, Quantity, Subtotal)
VALUES 
(1, 101, 1, 2, 100.00),
(1, 101, 2, 3, 90.00),
(2, 102, 3, 4, 80.00),
(3, 103, 4, 1, 70.00),
(4, 104, 5, 5, 200.00);

INSERT INTO Payment (PayDueDate, PaymentType, Bill_number, Amount)
VALUES 
('2023-06-20', 'Credit Card', 101, 100.00),
('2023-06-21', 'Cash', 102, 80.00),
('2023-06-22', 'Check', 103, 70.00),
('2023-06-23', 'Credit Card', 104, 200.00),
('2023-06-24', 'Cash', 105, 160.00);


INSERT INTO Warehouse (Warehouse_id, Location, Capacity, Manager_id)
VALUES 
(1, 'Warehouse A', 500, 1),
(2, 'Warehouse B', 800, 2),
(3, 'Warehouse C', 1000, 3),
(4, 'Warehouse D', 700, 4),
(5, 'Warehouse E', 600, 5);


INSERT INTO Category (Category_id, Category_name)
VALUES 
(1, 'Category 1'),
(2, 'Category 2'),
(3, 'Category 3');


INSERT INTO PaymentMethod (PaymentMethod_id, MethodName)
VALUES 
(1, 'Credit Card'),
(2, 'Cash'),
(3, 'Check');


INSERT INTO Shipment (Shipment_id, ShipmentDate, Destination, Status, Order_id, Warehouse_id)
VALUES 
(1, '2023-06-15', 'Destination 1', 'Shipped', 1, 1),
(2, '2023-06-16', 'Destination 2', 'Shipped', 2, 2),
(3, '2023-06-17', 'Destination 3', 'Shipped', 3, 3),
(4, '2023-06-18', 'Destination 4', 'Shipped', 4, 4),
(5, '2023-06-19', 'Destination 5', 'Shipped', 5, 5);





select * from products;