--this part of the sql code explains the windows function 

--total sales acorss all orders 
select sum(sales) total_sales
 from sales.orders
 
 --total sales for each products 
 select  ProductID ,sum(sales) from_each_product from sales.Orders
 group by ProductID;

 --find the total sales for each product ,additionally provide details such orderid and order dae 
 --we cant use group by because gruopby cant do aggegration and provide details at same time so we use window function 
 --this windows function returns a result for each row (result granulaity )
 select 
   productid ,orderid,orderdate,
   sum(sales)over(partition by productid) totalsalesbyproduct 
from sales.Orders;
