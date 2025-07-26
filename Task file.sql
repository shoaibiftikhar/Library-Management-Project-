SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM members;
SELECT * FROM books;
SELECT * FROM issued_status;
SELECT * FROM return_status;

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;
--Task 2: Update an Existing Member's Address
UPDATE members
SET member_address = '126 Oak St'
WHERE member_id = 'C105';
SELECT * FROM members;


--Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE   issued_id =   'IS117';
SELECT * FROM issued_status;

--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'

--Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book

SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1

--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt.

CREATE TABLE book_cnts 
AS
SELECT 
b.isbn, 
b.book_title, 
COUNT(ist.issued_id) AS no_issued
FROM books as b
JOIN 
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 2;

SELECT * FROM 
book_cnts;


--Task 7. Retrieve All Books in a Specific Category:
SELECT * FROM books
WHERE category = 'Classic';

--Task 8: Find Total Rental Income by Category:
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn           
GROUP BY 1

--task 9: List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days'

INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C113', 'sam', '145 Main St', '2025-06-01'),
('C114', 'jhon', '134 Main St', '2025-05-01');

--task 10: List Employees with Their Branch Manager's Name and their branch details:
SELECT 
    e1.*,
	b.manager_id,
	e2.emp_name as manager
FROM employees as e1
JOIN
branch as b
on b.branch_id = e1.branch_id
JOIN
employees as e2
on b.manager_id = e2.emp_id
--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
CREATE TABLE books_price_greater_then_seven
AS
SELECT * FROM books
WHERE rental_price > 7.00;

SELECT * FROM books_price_greater_then_seven


--Task 12: Retrieve the List of Books Not Yet Returned
SELECT 
      DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;
--project end



