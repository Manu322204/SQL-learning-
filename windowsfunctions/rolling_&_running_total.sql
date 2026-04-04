/*running and rollong total
running : aggregate all valuese from the begining up to the current point without droping off old data.
rolling :aggregate all vales within a fixed time window(eg.30 days ),as new data is added ,the oldest data point will be dropped .

calculate moving average of sales for each product over time (running ),
calculate moving average of sales for each product over time, only the next order */
 select 
   orderid,
  productid,
  orderdate ,
  sales ,
  avg(sales) over(partition by productid) avgbyprod,
  avg(sales) over(partition by productid order by orderdate ) movingavg,
  avg(sales) over(partition by productid order by orderdate rows between current row and 1 following  ) rollingavg
 from sales.orders