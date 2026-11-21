select * from walmart_data ;
----
select count(*) from walmart_data ;
select payment_method , count(*)
from walmart_data
group by payment_method ;

select count(distinct branch)
from walmart_data ;

select max(quantity) from walmart_data ;

--- business problems 
-- Q.1 finding different payment method and no of transaction & no of quantity sold

select payment_method , count(*) as no_of_payments , sum(quantity) as no_of_quantity_sold
from walmart_data
group by payment_method ;

-- Q.2 
-- identifiy the highest rated category in each branch , displaying the branch , category
-- average rating

SELECT *
FROM (
    SELECT
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER (
            PARTITION BY branch
            ORDER BY AVG(rating) desc
        ) AS cat_rank
    FROM walmart_data
    GROUP BY branch, category
) AS ranked_categories
WHERE cat_rank = 1;

-- Q.3
-- identify the busiest day for each branch based on the no of transactions
 SELECT *
FROM
(
    SELECT
        branch,
        DATE_FORMAT(
            STR_TO_DATE(walmart_date, '%d/%m/%y'),
            '%W'
        ) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER (
            PARTITION BY branch
            ORDER BY COUNT(*) DESC
        ) AS cat_rank
    FROM walmart_data
    GROUP BY
        branch,
        day_name
) AS cat_name
WHERE cat_rank = 1;

-- Q.4
-- total quantity of item sold per payment method , list the payment method and total quantity 

select payment_method , 
-- count(*) as no_of_payments ,
 sum(quantity) as no_of_quantity_sold
from walmart_data
group by payment_method ;

-- Q.5
-- determine the average , minimum , maximum rating of the category for each city
-- list the city , average_rating , minimum_rating and maximum_rating

select city , category ,
min(rating) as min_rating , max(rating) as max_rating , avg(rating) as avg_rating 
from walmart_data 
group by city , category ;

-- Q.6
-- calcualte the total profit for each category by considering total profit as ( unit_price * quantity * profit_margin )
-- list category and total_profit ordered from highest to lower profit 

select category ,
sum(total) as total_revenue ,
 sum(total * profit_margin) as profit 
from walmart_data
group by category 
order by total_revenue desc ;

-- Q.7
-- determine the most common payment method fro each branch . display branch and the preferred_payment_method . 

with cte as
(
SELECT branch, payment_method, COUNT(*) AS total_transaction,
rank () over (partition by branch order by COUNT(*) desc ) as payment_rank
FROM walmart_data
GROUP BY branch, payment_method )
select * 
from cte 
where payment_rank = 1 ;

-- Q.8
-- categorise sales into three group morning , afternoon and evening
-- find out the each shifts and no of invoices

SELECT
branch ,
    CASE
        WHEN HOUR(CAST(`time` AS TIME)) < 12 THEN 'Morning'
        WHEN HOUR(CAST(`time` AS TIME)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift_time,
    COUNT(*) AS total_transaction
FROM walmart_data
GROUP BY branch , shift_time ;    

-- Q.9
-- identify 5 branch with highest decrease ratio in
-- revenue compare to last year ( current year 2023 and last year 2022 )

-- rdr == current_yr_rev - last_yr_rev /last_rev*100

SELECT *,
       YEAR(STR_TO_DATE(`walmart_date`, '%d/%m/%y')) AS formated_year
FROM walmart_data;

-- 2022 sales

WITH revenue_2022 AS (
    SELECT
        branch,
        SUM(total) AS last_year_rev
    FROM walmart_data
    WHERE YEAR(STR_TO_DATE(`walmart_date`, '%d/%m/%y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT
        branch,
        SUM(total) AS cr_year_rev
    FROM walmart_data
    WHERE YEAR(STR_TO_DATE(`walmart_date`, '%d/%m/%y')) = 2023
    GROUP BY branch
)
SELECT
    ly.branch,
    ly.last_year_rev,
    cy.cr_year_rev,
    ROUND((ly.last_year_rev - cy.cr_year_rev) / ly.last_year_rev * 100, 2) AS decrease_ratio
FROM revenue_2022 ly
JOIN revenue_2023 cy
    ON ly.branch = cy.branch
WHERE ly.last_year_rev > cy.cr_year_rev
ORDER BY decrease_ratio DESC
LIMIT 5;

-- When is demand peaking, and are we staffed for it?
-- Business question: Which hours and shifts carry the traffic, so staffing and checkout lanes match demand?

SELECT
    MONTH(STR_TO_DATE(`walmart_date`, '%d/%m/%y'))  AS month_no,
    COUNT(*)                                AS txns,
    ROUND(SUM(total), 2)                    AS revenue
FROM walmart_data
WHERE YEAR(STR_TO_DATE(`walmart_date`, '%d/%m/%y')) BETWEEN 2020 AND 2023
GROUP BY month_no
ORDER BY month_no;

-- Where does profit come from, as opposed to revenue?
-- Business question: Which branches and categories earn the most profit, and which have high sales but weak margins?

-- Branch level
SELECT
    Branch,
    ROUND(SUM(total), 2)                                   AS revenue,
    ROUND(SUM(total * profit_margin), 2)                   AS profit,
    ROUND(SUM(total * profit_margin) / SUM(total) * 100, 2) AS margin_pct,
    RANK() OVER (ORDER BY SUM(total) DESC)                 AS revenue_rank,
    RANK() OVER (ORDER BY SUM(total * profit_margin) DESC) AS profit_rank
FROM walmart_data
GROUP BY Branch
ORDER BY profit DESC;

-- Category level
SELECT
    category,
    COUNT(*)                                               AS txns,
    ROUND(SUM(total), 2)                                   AS revenue,
    ROUND(SUM(total * profit_margin), 2)                   AS profit,
    ROUND(SUM(total * profit_margin) / SUM(total) * 100, 2) AS margin_pct
FROM walmart_data
GROUP BY category
ORDER BY profit DESC;

-- How satisfied are customers, and what drives low ratings?
-- Business question: Which categories, payment methods and branches get the weakest ratings?

-- By category and payment method
SELECT category, payment_method,
       COUNT(*) AS txns,
       ROUND(AVG(rating), 2) AS avg_rating
FROM walmart_data
GROUP BY category, payment_method
ORDER BY avg_rating;

-- Lowest-rated branches
SELECT Branch,
       COUNT(*) AS txns,
       ROUND(AVG(rating), 2) AS avg_rating
FROM walmart_data
GROUP BY Branch
HAVING COUNT(*) >= 50
ORDER BY avg_rating
LIMIT 5;
      
















