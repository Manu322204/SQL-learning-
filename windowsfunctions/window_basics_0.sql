--window basics 
--find the total sales acorss all orders
--additionally provide details such as orderid,orderdate 
select orderid,productid ,orderdate, sum(sales) over( ) total_sales  from  sales.Orders;

--find the total sales for each product additionally provide information such as orderid ,orderdate and also total sales 
--find the total sales for each combination of product and order status 

select orderid,productid ,OrderStatus,orderdate,sales,sum(sales) over() totalsales, sum(sales) over(partition by productid  ) total_salesbyproducts  ,
sum(sales) over (partition by productid, orderstatus) salesbyproductidandorderstatus from  sales.Orders;

--rank each order based on their sales from highest to lowest ,provide orderid and order date 
select rank() over (order by sales desc) ranksales ,orderid ,orderdate ,sales from sales.orders;




--felxibility of window 
--they allow aggregation of data at different granularities within the same query
select * from sales.Orders --to get all coulmns in the 

--orderby is to sort data within the window 
--defalut sorting asc (from lowest to highest )
--frame clause can only be used used together with order by clause 
--lower value must be before the higher boundary 
--frame clause is to create window inside the window 
--for only preceding the current row can be skipped 

--normal form rows between current row and 2  precceding 
-- short form rows 2 preceding (only works for preceding not following )
--default orderby always uses frame and defalut is between unbounded preceding and current frame)
select orderid,orderdate,orderstatus ,sales ,sum(sales) over (partition by orderstatus order by orderdate rows between current row and 2
following ) from sales.orders;


--find the total sales for each orderstatus .only for two products 101 and 102
select orderid,ProductID, sales,orderstatus,orderdate, sum(sales) over (partition by orderstatus) from sales.orders where productid in (101,102);

--rank the customers based on the totalsales 
select customerid,sum(sales) totalsales,
rank() over(order by sum(sales) DESC) rankcustoemr
 from sales.orders
 group by CustomerID