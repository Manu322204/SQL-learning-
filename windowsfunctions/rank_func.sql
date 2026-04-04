/* WINDOW RANKING FUNCTIONS

Types:
1. Integer-based:
   - ROW_NUMBER()
   - RANK()
   - DENSE_RANK()
   - NTILE()

2. Percentage-based:
   - CUME_DIST()
   - PERCENT_RANK()
-----------------------------------------------------------------------*/

/* 
ROW_NUMBER():
- Does not handle ties

RANK():
- Assigns the same rank to tied values
- May leave gaps in ranking

DENSE_RANK():
- Assigns the same rank to tied values
- Does not skip ranks
-----------------------------------------------------------------------*/

/* Task:
   Rank the orders based on their sales from highest to lowest
*/

SELECT
    orderid,
    productid,
    sales,
    ROW_NUMBER() OVER (ORDER BY sales DESC) AS row_number_sales,
    RANK() OVER (ORDER BY sales DESC) AS ranking,
    DENSE_RANK() OVER (ORDER BY sales DESC) AS dense_ranking
FROM sales.orders;


/* 
Find the highest sales for each product (Top-N analysis)
*/

SELECT *
FROM (
    SELECT 
        orderid,
        productid,
        sales,
        ROW_NUMBER() OVER (
            PARTITION BY productid 
            ORDER BY sales DESC
        ) AS rank_by_product
    FROM sales.orders
) t
WHERE rank_by_product = 1;


/* 
Bottom-N analysis:
Helps analyze underperformance to manage risk and optimize

Find the lowest customers based on their total sales
*/

SELECT *
FROM (
    SELECT 
        customerid,
        SUM(sales) AS total_sales,
        ROW_NUMBER() OVER (ORDER BY SUM(sales)) AS rank_customers
    FROM sales.orders
    GROUP BY customerid
) t
WHERE rank_customers <= 2;