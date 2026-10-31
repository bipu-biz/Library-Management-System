CREATE DATABASE IF NOT EXISTS LibraryDB;
USE LibraryDB;
SHOW DATABASES;
SELECT DATABASE();

USE LibraryDB;

CREATE TABLE Students (
    Student_ID INT PRIMARY KEY AUTO_INCREMENT,
    Student_Name VARCHAR(100) NOT NULL,
    Department VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15)
);

CREATE TABLE Books (
    Book_ID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(150) NOT NULL,
    Author VARCHAR(100) NOT NULL,
    Publisher VARCHAR(100),
    Quantity INT NOT NULL DEFAULT 1,
    Available_Quantity INT NOT NULL DEFAULT 1,
    CHECK (Quantity >= 0),
    CHECK (Available_Quantity >= 0),
    CHECK (Available_Quantity <= Quantity)
);

CREATE TABLE Book_Issue (
    Issue_ID INT PRIMARY KEY AUTO_INCREMENT,
    Student_ID INT NOT NULL,
    Book_ID INT NOT NULL,
    Issue_Date DATE NOT NULL,
    Return_Date DATE,
    Status VARCHAR(20) NOT NULL DEFAULT 'Issued',

    FOREIGN KEY (Student_ID)
        REFERENCES Students(Student_ID),

    FOREIGN KEY (Book_ID)
        REFERENCES Books(Book_ID),

    CHECK (Status IN ('Issued', 'Returned')),
    CHECK (Return_Date IS NULL OR Return_Date >= Issue_Date)
);
SHOW TABLES;

INSERT INTO Students
(Student_Name, Department, Email, Phone)
VALUES
('Rahul Sharma', 'Computer Science', 'rahul@gmail.com', '9876500001'),
('Priya Verma', 'Information Technology', 'priya@gmail.com', '9876500002'),
('Aman Kumar', 'Computer Science', 'aman@gmail.com', '9876500003'),
('Simran Kaur', 'Electronics', 'simran@gmail.com', '9876500004'),
('Arjun Singh', 'Mechanical', 'arjun@gmail.com', '9876500005');

SELECT * FROM Students;

INSERT INTO Books
(Title, Author, Publisher, Quantity, Available_Quantity)
VALUES
('Database System Concepts', 'Abraham Silberschatz', 'McGraw Hill', 5, 5),
('Let Us C', 'Yashavant Kanetkar', 'BPB Publications', 4, 4),
('Operating System Concepts', 'Abraham Silberschatz', 'Wiley', 3, 3),
('Computer Networks', 'Andrew Tanenbaum', 'Pearson', 4, 4),
('Clean Code', 'Robert C. Martin', 'Prentice Hall', 3, 3),
('Python Programming', 'Reema Thareja', 'Oxford', 5, 5),
('Java Programming', 'Herbert Schildt', 'McGraw Hill', 4, 4),
('Data Structures', 'Seymour Lipschutz', 'McGraw Hill', 3, 3),
('Artificial Intelligence', 'Stuart Russell', 'Pearson', 2, 2),
('Web Technology', 'Uttam K. Roy', 'Oxford', 4, 4);

SELECT * FROM Books;

INSERT INTO Book_Issue
(Student_ID, Book_ID, Issue_Date, Return_Date, Status)
VALUES
(1, 1, '2026-10-20', NULL, 'Issued'),
(2, 3, '2026-10-21', NULL, 'Issued'),
(3, 2, '2026-10-22', NULL, 'Issued'),
(4, 4, '2026-10-23', '2026-10-27', 'Returned'),
(5, 5, '2026-10-24', NULL, 'Issued');

UPDATE Books
SET Available_Quantity = Available_Quantity - 1
WHERE Book_ID IN (1, 2, 3, 5);

SELECT * FROM Book_Issue;

SELECT *
FROM Books
WHERE Available_Quantity > 0;

SELECT
    S.Student_Name,
    B.Title,
    B.Author,
    I.Issue_Date,
    I.Status
FROM Book_Issue I
INNER JOIN Students S
ON I.Student_ID = S.Student_ID
INNER JOIN Books B
ON I.Book_ID = B.Book_ID
WHERE S.Student_Name = 'Rahul Sharma';

SELECT COUNT(*) AS Total_Students
FROM Students;

SELECT SUM(Quantity) AS Total_Books
FROM Books;

SELECT COUNT(*) AS Currently_Issued
FROM Book_Issue
WHERE Status = 'Issued';

SELECT
    S.Student_Name,
    COUNT(I.Issue_ID) AS Total_Issued
FROM Students S
LEFT JOIN Book_Issue I
ON S.Student_ID = I.Student_ID
GROUP BY S.Student_ID, S.Student_Name;

START TRANSACTION;

UPDATE Book_Issue
SET Status = 'Returned',
    Return_Date = CURRENT_DATE
WHERE Issue_ID = 1
AND Status = 'Issued';

SET @updated_rows = ROW_COUNT();

UPDATE Books
SET Available_Quantity = Available_Quantity + 1
WHERE Book_ID = 1
AND @updated_rows = 1;

COMMIT;

SELECT * FROM Book_Issue;

SELECT * FROM Books;