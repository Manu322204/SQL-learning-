/* value window functions 
          lead(expr,offset,default)   ** returns defaultvalue  if previous row value  is not avilable
          lag(expr,offset,default)       default ="null"
          first_value(expr)
          last_value(expr)

lead() access value from the next row withing a window
lag() access values from the previous row within  a window 
-----------------------------------------------------------------------------------------------
task : analyze the month-over-month (mom) perfomance by finding the percentage change in sales between 
the current month and previous month 
-------------------------------------------------------------------------------------------------*/
select *,
currentmonthsales-previousmonthsales  as month_over_month,
round(cast((currentmonthsales-previousmonthsales) as float)/previousmonthsales * 100,1) as mom_percent
from(
select month(orderdate) ordermonth,
sum(sales) currentmonthsales,
lag(sum(sales)) over(order by month(orderdate) ) previousmonthsales 
from sales.orders
group by month(orderdate) )t

/* customer retention analysis 
measure customer's behaviour and loylaty to help busineess build strong relationship with customers 

-----------------------------------------------------------------------------------------------
task : rank customers based on the average days between their orders
--------------------------------------------------------------------------------------------*/
select
   customerid,
   avg(daysuntilnextorder) avgdays ,
   rank() over (order by  coalesce(avg(daysuntilnextorder),999999)) rankavg  
   
   from (
               select  orderid,customerid,  orderdate currentdate ,
               lead(orderdate) over (partition by customerid order by orderdate) nextorder,
               datediff(day,orderdate,lead(orderdate) over (partition by customerid order by orderdate)) daysuntilnextorder
                from sales.orders)t
group by 
CustomerID


/*first_value() : returns the first row within the window
last_value() :return the last row within the window   
 default: range between the unbounded preceeding and current row 
-------------------------------------------------------------------------------------------------
task : find the lowest and highest sales for each product s
find the differece between the current and the lowest sales 
----------------------------------------------------------------------------------------------*/
select 
orderid,productid,
sales ,
first_value(sales) over (partition by productid order by sales ) minvalue,
last_value(sales) over (partition by productid order by sales rows between  current row and unbounded following ) highestval,
sales-first_value(sales) over (partition by productid order by sales ) as diffrenceinsales
from sales.orders 