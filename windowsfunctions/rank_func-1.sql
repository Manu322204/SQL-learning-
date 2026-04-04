/* assign unique ids (use case )
assign unique id to the rows od the 'orders archieve' table 
[paginating: the process of breaking down a large data into smaller , more mangable chunks ]
*/

 select 
 row_number() over (order by orderid,orderdate) uniqueid,
 * from sales.OrdersArchive;


 /*
 idientify duplicates :remove or identify 
 identify duplicate rows in the table 'orders archive ' and return a clean result without any duplicates8 */
  select * from (select 
 row_number() over (partition by orderid order by creationtime desc ) rn,
 * from sales.OrdersArchive) t 
 where rn>1


 /* ntile ()
  divides the rows into specified number of approximatley equal group(buckets )
  sql rule: when there are odd number of rows then the larger groups come first 
  buket size= number or rows / number of buckets 
  */
  select 
  orderid,
  sales,
  ntile(1) over (order by sales desc ) onebucket ,
  ntile(2) over (order by sales desc) twobucket ,
  ntile(3) over (order  by sales desc) threebucket,
  ntile(4) over (order by sales desc) fourbucket
  from sales.orders 

  /*use case :
 1. data segmentation data analyst 
  */
 select * ,
 case when buckets=1 then 'high'
     when buckets =2 then  'medium'
	 when buckets=3 then 'low '
end salessegmentations
from 
 
 ( select 
  orderid,sales,
  ntile(3 ) over (order by sales desc) buckets
  from sales.orders)t

  --2.equalizing load  data engineering :it is difficult to transfer entire big table so break them into chuncks and then transfer 
 -- in order to export the data, divide the orders into 2 groups 
 select 
 ntile(2) over (order by orderid) buckets,
 * from sales.orders;





 /* percentage based ranking function 
 cume_dist() cumulative distributiob calaculates the distribution of data points within a window
 cume_dist= position of number /number of rows 

 percent_rank:
            calacuate the relative position of each row 
			percent_rank= position nr-1/number of rows-1
find the products that falls within the highest 40% of prices 			*/
select 
   * ,
   concat(distrank  * 100 ,'%') distrankper from
(
  select product ,price,
  cume_dist() over(order by price desc) distrank
  from sales.products )t

where distrank<=0.4


			   