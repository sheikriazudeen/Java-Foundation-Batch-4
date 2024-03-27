create database Loan;
use  Loan;

-- drop table customer;
-- drop table carloan;
-- drop table homeloan;
-- drop table loan;

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255),
    EmailAddress VARCHAR(255),
    PhoneNumber VARCHAR(20),
    Address VARCHAR(255),
    CreditScore FLOAT
);
ALTER TABLE Customer
ALTER COLUMN CreditScore SET DEFAULT (300 + (RAND() * (500 - 300)));



CREATE TABLE Loan (
    LoanID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    PrincipalAmount DECIMAL(18, 2),
    InterestRate DECIMAL(5, 2),
    LoanTerm INT,
    LoanType ENUM('CarLoan', 'HomeLoan'),
    LoanStatus ENUM('Pending', 'Approved') ,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

ALTER TABLE Loan
ALTER COLUMN LoanStatus SET DEFAULT 'Pending';


CREATE TABLE HomeLoan (
    LoanID INT PRIMARY KEY,
    PropertyAddress VARCHAR(255),
    PropertyValue DECIMAL(18, 2),
    FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
);


CREATE TABLE CarLoan (
    LoanID INT PRIMARY KEY,
    CarModel VARCHAR(255),
    CarValue DECIMAL(18, 2),
    FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
);


INSERT INTO Customer (Name, EmailAddress, PhoneNumber, Address, CreditScore)
VALUES 
    ('Ramesh', 'ramesh@example.com', '1234567890', 'erd', 750.0),
    ('Roshan', 'roshan@example.com', '0987654321', 'cbe', 800.0),
    ('Varun', 'varun@example.com', '9876543210', 'che', 700.0);

INSERT INTO Loan (CustomerID, PrincipalAmount, InterestRate, LoanTerm, LoanType, LoanStatus)
VALUES 
    (1, 50000.00, 5.5, 60, 1, 'Approved'),
    (2, 200000.00, 4.0, 120, 2, 'Pending'),
    (3, 30000.00, 6.0, 36, 1, 'Approved');

INSERT INTO Loan (CustomerID, PrincipalAmount, InterestRate, LoanTerm, LoanType)
VALUES 
     (1, 50000.00, 5.5, 60, 1);
INSERT INTO HomeLoan (LoanID, PropertyAddress, PropertyValue)
VALUES 
    (1, '1234 erd, Suburb', 250000.00),
    (2, '567 cbe', 150000.00), 
    (3, '91011 che, Countryside', 300000.00); 

INSERT INTO CarLoan (LoanID, CarModel, CarValue)
VALUES 
    (1, 'Toyota Corolla', 25000.00),
    (2, 'Honda Civic', 20000.00),
    (3, 'Ford Figo', 40000.00); 
