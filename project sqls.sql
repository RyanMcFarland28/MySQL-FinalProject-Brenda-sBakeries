-- Project # 4 Ryan McFarland
-- Viewing the sales that were over $15 each
USE brendasbakeries;

SELECT 
    *
FROM
    salelineitem
WHERE
    price > 15; 
    
-- ----------------------------------------------------------------------
-- Project # 5 Ryan McFarland
-- Viewing the sales of customers 1 or 2

SELECT 
    *
FROM
    Sale
WHERE
    CustomerID = 1 OR customerID = 2
ORDER BY Date;

-- ----------------------------------------------------------------------
-- Project # 6 Ryan McFarland
-- This query shows the the products that have sold more than 18 units and the 
-- total amount of dollars each product has created

SELECT 
    COUNT(Quantity) AS 'Quantity Sold',
    Product.Name AS Product,
    SUM(Price) AS 'Total Sales'
FROM
    SaleLineItem
        INNER JOIN
    Product ON SaleLineItem.ProductID = Product.ID
GROUP BY Product.Name
HAVING COUNT(quantity) > 18;

-- ----------------------------------------------------------------------
-- Project # 7 Ryan McFarland
-- This shows who the customer was and their email address, who the employee who 
-- created the sale, and when the sale occurred and what the total of the sale was
SELECT 
    CONCAT(customer.lastname,
            ', ',
            customer.firstname) AS Customer,
    customer.email AS Email,
    sale.date AS 'Sale Date',
    salelineitem.price AS 'Sale Price',
    CONCAT(employee.lastname,
            ', ',
            employee.firstname) AS Employee
FROM
    Customer
        INNER JOIN
    Sale ON Customer.ID = Sale.CustomerID
        INNER JOIN
    SaleLineItem ON Sale.ID = SaleLineItem.SaleID
        INNER JOIN
    Employee ON Sale.EmployeeID = Employee.ID
ORDER BY Customer;

-- ----------------------------------------------------------------------
-- Project # 8 Ryan McFarland
-- All of the customers who purchased bakery, even showing those that have not bought bakery after April 17, 2016

SELECT 
    CONCAT(customer.lastname,
            ', ',
            customer.firstname) AS Customer,
    Email,
    ShopID,
    EmployeeID
FROM
    Customer
        LEFT OUTER JOIN
    Sale ON Sale.CustomerID = Customer.ID
GROUP BY Customer.LastName
ORDER BY Customer.LastName;

-- ----------------------------------------------------------------------
-- Project # 9 Ryan McFarland
-- 

SELECT 
    CONCAT (employee.lastname, ', ' , employee.firstname) AS Employee,
    Max(Sale.Date) AS 'Last Sale Date',
    COUNT(customer.id) AS 'Total Customers',
    Shop.Name AS 'Shop'
    
FROM
    Employee
    INNER JOIN Sale ON Sale.EmployeeID = Employee.ID
    INNER JOIN Customer ON Sale.CustomerID = Customer.ID
    INNER JOIN Shop ON Sale.ShopID = Shop.ID
    
    
    GROUP BY employee, Shop.Name
ORDER BY employee DESC;

-- ----------------------------------------------------------------------
-- Project # 10 Ryan McFarland
-- view to see vendor and order details
SELECT 
    ordersdate AS 'Order Date',
    Orders.Price AS 'Order Price',
    Vendor.Name AS 'Vendor',
    Vendor.Phone AS 'Vendor Phone'
    
FROM
    Vendor
    INNER JOIN Orders ON Orders.VendorID = Vendor.ID

ORDER BY ordersdate;

-- ----------------------------------------------------------------------
-- Project # 11 Ryan McFarland
-- 

DROP PROCEDURE IF EXISTS Vendor_Orders;

DELIMITER $$

CREATE PROCEDURE Vendor_Orders(inVendorID INT, OUT outPrice DECIMAL (5,2))

BEGIN 

	SET outPrice = (SELECT sum(Price)
					FROM Orders 
					INNER JOIN Vendor on Orders.VendorID = Vendor.ID
                    WHERE VendorID = inVendorID);
    
END
$$

DELIMITER ;

-- ----------------
CALL Vendor_Orders(5, @outPrice) ;

SELECT @outPrice AS 'Total Price';


-- ----------------------------------------------------------------------
-- Project # 12 Ryan McFarland
-- This before insert does not allow a vendor's contract date to be anything other than the current date so that if the person entering information messes up and types and old year or puts the incorrect date in, it will be changed automatically to the current date

DROP TRIGGER IF EXISTS Vendor_Before_Insert;

DELIMITER $$

CREATE TRIGGER Vendor_Before_Insert
	BEFORE INSERT ON Vendor
    FOR EACH ROW
    BEGIN
		IF NEW.contractdate > curdate() THEN
		SET NEW.ContractDate = Curdate();
        END IF;
	END $$
    
DELIMITER ;



INSERT INTO Vendor (Name, ContractDate, Address, City, State, ZIP, Phone)
			VALUES ('Ryan McFarland', '2018-08-09', '123 High North St', 'Berea', 'OH', '44247', '440-888-4725');
            

SELECT 
    *
FROM
    Vendor
ORDER BY ID DESC;

-- ----------------------------------------------------------------------
-- Project # 13 Ryan McFarland
-- 

DROP TRIGGER IF EXISTS Vendor_State;
DELIMITER $$
CREATE TRIGGER Vendor_State
BEFORE UPDATE ON Vendor
FOR EACH ROW
BEGIN
    IF NEW.State != 'OH' THEN
			SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT= 'Vendor must be from Ohio, only locally sourced ingredients for Brenda!';
		END IF;
END $$
DELIMITER ;

UPDATE Vendor
SET Vendor.State = 'NY'
WHERE ID = 1 ;

-- ----------------------------------------------------------------------
-- Project # 14 Ryan McFarland
-- 

CREATE TABLE log_table (
    old_customer_id VARCHAR(20),
    when_deleted DATE
);
DROP TRIGGER IF EXISTS user_delete;
DELIMITER $$
CREATE TRIGGER user_delete 
AFTER DELETE ON Customer 
FOR EACH ROW BEGIN
INSERT INTO log_table(old_customer_id,when_deleted) VALUES (OLD.id,NOW());
END $$
DELIMITER ;



DELETE FROM Customer 
WHERE
    Customer.ID IN (75 , 35, 90, 86);
SELECT 
    old_customer_id AS 'Deleted Customer ID',
    when_deleted AS 'Deleted Date'
FROM
    log_table;
-- ----------------------------------------------------------------------
