Use brendasbakeries;

SELECT 
CONCAT (customer.lastname, ', ' , customer.firstname) AS Customer,
customer.email AS Email,
sale.date AS 'Sale Date',
salelineitem.price AS 'Sale Price',
CONCAT (employee.lastname, ', ' , employee.firstname) AS Employee


FROM Customer
INNER JOIN Sale ON Customer.ID = Sale.CustomerID
INNER JOIN SaleLineItem ON Sale.ID = SaleLineItem.SaleID
INNER JOIN Employee ON Sale.EmployeeID = Employee.ID

ORDER BY Customer;