--aggregate function | syntax  ex : avg(sales) over (partition by productid order by sales)  , 
--agg function= (count,sum ,avg,min,max)

/*------------------------------------------------------------------------------
count :number of rows within a window 
count (*) counts all the rows in a table ,regardless of whether any value is null
count(1) is same as count(*) give same output 
counts the number of values in a coulmn,regradless of their data types.
count the total number of rows icluding the duplicates,not the unique values!

--------------------------------------------------------------------------------
task : find the total number of orders
additionally provide orderid and order date 
find total order for each customers
--------------------------------------------------------------------------------*/

select * from sales.orders;

select  orderid,orderdate ,customerid ,count(*) over(partition by customerid ) orderbycustomers,
count(*) over() totalsales  from sales.Orders;

/*--------------------------------------------------------------------------------
find the total number of customers ,
additionally provide all   customer's details ,
find the total number of score for the customers 
---------------------------------------------------------------------------------*/
select * ,
   count(*) over () totalcustomers,
   count(score) over() totalscores
   from sales.customers;

/*----------------------------------------------------------------------------------
check weather the table 'orders' contains any duplcate rows 
------------------------------------------------------------------------------------*/
select orderid,count(*) over (partition by orderid) checkpk
 from sales.orders;

 select 
 * from ( select orderid, count( *) over (partition by orderid) checkpk
 from sales.OrdersArchive
)t where checkpk > 1

/*-----------------------------------------------------------------------------------
sum() sum of all values in each window 
find the total sales across all orders ,
total sales for each products
aditionally provide details such as orderid, orderdate 
-------------------------------------------------------------------------------------
*/select * from sales.orders;
select orderid, orderdate ,productid , sum(sales)  over() totalsales ,sum(sales) over 
(partition by productid ) sumbyorderstatus  from sales.orders;

/* ----------------------------------------------------------------------------------
find the percentage contribution of each product's sales to the total sales
-------------------------------------------------------------------------------------
*/
select orderid,productid ,sales,sum(sales) over() totalsales,
 round (cast (sales as float ) / sum(sales) over() * 100,2)  [percentage of total]
from sales.Orders;

/*----------------------------------------------------------------------------------
average values within the window
avg()
find the average sales across all orders
find the average sales for each product 
additionally provide details such order id ,orderdate 
-----------------------------------------------------------------------------------*/
select orderid,productid ,orderdate , avg(sales) over () avg_sales_allorders, avg(sales) over (partition by productid) avgbyproductid  from sales.orders ;


/*--------------------------------------------------------------------------------
find the  average scores of the customers 
provide details such as customerid and lastname 
---------------------------------------------------------------------------------*/
select 
      customerid,lastname,score ,
	  avg(coalesce (score,0)) over () avgscore
from sales.Customers;

/*--------------------------------------------------------------------------
find all orders where sales are higher then the average sales across all orders
--------------------------------------------------------------------------*/

select * from (select 
orderid ,productid ,sales, avg(sales) over() avgbyproduct  from sales.orders) t
where sales > avgbyproduct

/*--------------------------------------------------------------------------
min and max
min() return lowest and max() highest sales
find  the highest & lowest  sales across all orders 
higheset lowest sales for each product 
additionally such as order id and order date 
----------------------------------------------------------------------------*/
select * from sales.Orders
select orderid,orderdate ,productid ,sales,min(sales) over() lowestsales ,max(sales) over() highestsales ,
min(sales) over (partition by productid) lowestsaleinproduct, max(sales) over(partition by productid) highestsalesinproducts from sales.orders

/*------------------------------------------------------------------------------
show the employee with the highest salaries 
-------------------------------------------------------------------------------*/

select * from sales.Employees
select * from(
select employeeid ,firstname ,salary ,max(salary) over() maxsal from sales.employees)t
where salary =maxsal

/*------------------------------------------------------------------------------
calculate the deviation of each sale from both the minimum snd maximum amounts 
--------------------------------------------------------------------------------*/
select orderid,orderdate,productid,sales ,min(sales) over() minvslues,max(sales) over(),
sales-min(sales) over() deviationfrmmim,
 max(sales) over() -sales deviationfrommax from sales.Orders