/* DATA BASE ENGINE : is the brain of the database ,executes multiple operations such as storing ,retreiving ,and managing data within the database 
1.DISK STORAGE : data is stored permanently 
+capacity :can store large amount of the data 
-speed : slow to read and write 
     **user data storage :it is the main content of the data base this is where the actual data that  user care about is stored .ex:sales.orders, sales.product
	 **system catalog :database's internal storage for its own information . a blue print that keeps track of everything about the database itself,not the user data 
	                  like it holds meta data(data about data ) of the database.
     **temporary storage :temporary space used by the database for short-term tasks,like processing querries or sorting data.
	                      once the task is done it cleans up the storage 
2.CACHE STORAGE : where data is stored temporarily 
+speed :extremly fast to read and to write 
- capacity : can hold smaller amount of data */

--information schema : a system-defined schema with in built- in views that provide info about the database ,like tables and coulmns
select * from 
INFORMATION_SCHEMA.COLUMNS

select 
distinct table_name 
from INFORMATION_SCHEMA.COLUMNS

/*query inside another query 
why subqueries : to divdide the large  tasks to simple ones
 FROM  subqueries 

task : select the products that have a price higher than the  average of all products*/

--main query 
select *
from (--subqueries 
       select *,avg(price ) over() avgsales  from sales.Products)t 

where price > avgsales;

--task : rank  customer based on their total amount of sales 

--main query 
select 
* ,
rank() over (order by totalsales desc) customerank
from 
--subquery 
     (select CustomerID
    ,sum(sales) totalsales
    from sales.Orders
    group by CustomerID) t


/*SELECT subqueires 
used to aggregate data side by side with the main queires data ,allowing for direst comarision .

select 
 column1,
   (select columns from table1 where condition ) as alias  from 
tabe1

rule :only scalar subqueries are allowed to be used for subqueries in the select suqueries
 task : show the product ids ,names ,prices and total number of orders  */

 select 
 productid,
 product ,
 price ,--subquery
  (select count(*) totalorders from sales.orders) totalorders 
 from sales.Products;

/* JOIN subqueries used to prepare the data (filtering or aggregation ) before joining it with other tables 
task: show all the customer details and find the total orders of each customer */

--main query 

select * from sales.Customers c 
left join (

select customerid,count(*) totalorders from sales.orders
group by  CustomerID
) o
on c.CustomerID= o.CustomerID

/*subqueries in WHERE : used for complex filtering logic and makes query more flexible and dynamic 
syntax: main query 
  select colum1, cl2
  from table 1 
  where column =(slect column from table 2 where condition ) subquery

task: find the products that have a price higher than the average price of all products */
select productid,
price  from sales.Products
where price > (select avg(price ) avgprice  from sales.products)

/* IN operator 
in operator helps in filtering the data ( list of values)
example : select * from sales.orders where customerid in (1,2,5,7) basically it matches value from a list 

syntax :
  select col1 ,col2 
  from talbe1 
   where  col in (select column from table2 where condition ) --subquery
 
 task: show the details of orders made by customers in germany.
   */
  
    select * from sales.orders
	where CustomerID  in (
	select customerid   from sales.customers where country ='germany')
  
  -- task : the orders made by coustomers not from germany 

  select * from sales.orders
	where CustomerID  not  in (
	select customerid   from sales.customers where country ='germany')

	/* ANY  operator : checks if a value matches any value within a list 
	used to check if a value is true for AT LEAST  one of the value in a list .

	syntax : where column < any (select column from table 1 where condition )
	
task :find the female employees whose salaries are greater 
than the salaries of any male employee
*/

select employeeid ,firstname ,salary ,gender  from sales.Employees
where gender ='F'
and salary > any (select salary from sales.employees where gender ='m')

/* ALL OPERATOR :
 check of a value matches all value within a list .
 task: 
 find the female employee whose salaries are greater than the salaries of all male employees */

 select employeeid ,firstname ,salary ,gender  from sales.Employees
where gender ='F'
and salary > ALL
(select salary from sales.employees where gender ='m')

/* non -colrrealted (a subquery that runs independently from the main query | correlated subqueries ( that relay on values from the main query )
task : show all customers details and find the total orders for each customer. */

 select * ,
( select count(*)   from sales.orders o where  o.customerid =c .customerid) totalsales
 from sales.Customers c --co-rrelated subquery 


 /*
 EXIST operator :
 check if subquery returns any rows 
 syntax:
  select col1,col2
   from table2 
   where exists ( select 1 
                from table1
				 where tabel1.id=table2.id)
task : find the details of orders made by customers in germany */
-- main query 
select * from sales.orders  o
where exists 
       (select 1 from sales.customers  c 
        where country ='germany '
		and o.CustomerID=c.CustomerID )




 