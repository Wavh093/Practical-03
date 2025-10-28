-- Viewing all data

SELECT *
FROM practical3.sales.shopping;

-- 1) Find all records where Size is missing and the purchase_amount is greater than 50. 
-- Expected Columns: Customer ID, Size, purchase_amount, Item Purchased 

SELECT customer_id, Size, purchase_amount, item_purchased
FROM practical3.sales.shopping
WHERE Size IS NULL AND purchase_amount > 50;

-- 2) List the total number of purchases grouped by Season, treating NULL values as 'Unknown Season'. 
-- Expected Columns: Season, Total Purchases 

SELECT 
    CASE WHEN Season IS NULL THEN 'Unknown Season'
    ELSE Season
END AS season,
COUNT(customer_id) AS total_purchases
FROM practical3.sales.shopping
GROUP BY season;

-- 3) Count how many customers used each Payment Method, treating NULLs as 'Not Provided'. 
-- Expected Columns: Payment Method, Customer Count 

SELECT 
    CASE WHEN payment_method IS NULL THEN 'Not Provided'
    ELSE payment_method
END AS payment_method,
COUNT(customer_id) AS customer_count 
FROM practical3.sales.shopping
GROUP BY payment_method;

-- 4) Show customers where Promo Code Used is NULL and Review Rating is below 3.0. 
-- Expected Columns: Customer ID, Promo Code Used, Review Rating, Item Purchased 

SELECT customer_id, promo_code_used, review_rating 
FROM practical3.sales.shopping
WHERE promo_code_used IS NULL AND review_rating < 3.0;

-- 5) Group customers by Shipping Type, and return the average purchase_amount, treating missing values as 0.
-- Expected Columns: Shipping Type, Average purchase_amount

SELECT shipping_type, AVG(purchase_amount) AS Average_purchase_amount
FROM practical3.sales.shopping
GROUP BY shipping_type;

-- 6) Display the number of purchases per Location only for those with more than 5 purchases and no NULL Payment Method. 
-- Expected Columns: Location, Total Purchases

SELECT location, COUNT(customer_id) AS total_purchases
FROM practical3.sales.shopping
GROUP BY location, payment_method
HAVING total_purchases > 5 AND payment_method IS NOT NULL;

-- 7) Create a column Spender Category that classifies customers using CASE: 'High' if amount > 80, 'Medium' if BETWEEN 50 AND 80, 'Low' otherwise. Replace NULLs in purchase_amount with 0. 
-- Expected Columns: Customer ID, purchase_amount, Spender Category

-- adding the spender category column
ALTER TABLE practical3.sales.shopping
ADD COLUMN spender_category STRING;

UPDATE practical3.sales.shopping
SET spender_category =
    CASE WHEN purchase_amount > 80 THEN 'High'
        WHEN purchase_amount BETWEEN 50 AND 80 THEN 'Medium'
        ELSE 'Low'
    END;

--removing the null values
UPDATE practical3.sales.shopping
SET purchase_amount =
    CASE WHEN purchase_amount IS NULL THEN 0
    ELSE purchase_amount
END;

-- viewing the output
Select customer_id, purchase_amount, spender_category
FROM practical3.sales.shopping
ORDER BY purchase_amount ASC;

-- 8) Find customers who have no Previous Purchases value but whose Color is not NULL. 
-- Expected Columns: Customer ID, Color, Previous Purchases

SELECT customer_id, previous_purchases, color
FROM practical3.sales.shopping
WHERE previous_purchases IS NULL AND color IS NOT NULL;

-- 9) Group records by Frequency of Purchases and show the total amount spent per group, treating NULL frequencies as 'Unknown'. 
-- Expected Columns: Frequency of Purchases, Total purchase_amount

SELECT 
CASE 
    WHEN frequency_of_purchases IS NULL THEN 'Unknown'
    ELSE frequency_of_purchases
END AS frequency_of_purchases,
SUM(purchase_amount) AS tot_purchase_amount
FROM practical3.sales.shopping
GROUP BY frequency_of_purchases
ORDER BY tot_purchase_amount DESC;

-- 10) Display a list of all Category values with the number of times each was purchased, excluding rows where Category is NULL.
-- Expected Columns: Category, Total Purchases

SELECT category , COUNT(customer_id) AS tot_purchases
FROM practical3.sales.shopping
GROUP BY category
HAVING category IS NOT NULL;

-- 11) Return the top 5 Locations with the highest total purchase_amount, replacing NULLs in amount with 0. 
-- Expected Columns: Location, Total purchase_amount

SELECT location, SUM(purchase_amount) tot_purchase_amount
FROM practical3.sales.shopping
GROUP BY location;

-- 12) Group customers by Gender and Size, and count how many entries have a NULL Color. 
-- Expected Columns: Gender, Size, Null Color Count

SELECT Gender, Size, COUNT_IF(color IS NULL) AS null_count
FROM practical3.sales.shopping
GROUP BY Gender, Size;

-- 13) Identify all Item Purchased where more than 3 purchases had NULL Shipping Type. 
-- Expected Columns: Item Purchased, NULL Shipping Type Count

SELECT item_purchased, COUNT_IF(SHIPPING_TYPE IS NULL) As null_count
FROM practical3.sales.shopping
GROUP BY item_purchased
HAVING null_count > 3;

-- 14) Show a count of how many customers per Payment Method have NULL Review Rating. 
-- Expected Columns: Payment Method, Missing Review Rating Count

SELECT payment_method, COUNT_IF(review_rating IS NULL) AS null_count
FROM practical3.sales.shopping
GROUP BY payment_method;

-- 15) Group by Category and return the average Review Rating, replacing NULLs with 0, and filter only where average is greater than 3.5. 
-- Expected Columns: Category, Average Review Rating

SELECT category, 
        AVG(COALESCE(review_rating, 0)) AS Average_Review_rating
FROM practical3.sales.shopping
WHERE category IS NOT NULL
GROUP BY category;
HAVING AVG(COALESCE(review_rating,0)) > 3.5;

-- 16) List all Colors that are missing (NULL) in at least 2 rows and the average Age of customers for those rows. 
-- Expected Columns: Color, Average Age

SELECT color, 
        AVG(age) AS average_age
FROM practical3.sales.shopping
WHERE color IS NULL
GROUP BY color
HAVING COUNT (*) >= 2;


-- 17) Use CASE to create a column Delivery Speed: 'Fast' if Shipping Type is 'Express' or 'Next Day Air', 'Slow' if 'Standard', 'Other' for all else including NULL. Then count how many customers fall into each category. 
-- Expected Columns: Delivery Speed, Customer Count

SELECT 
  CASE 
    WHEN shipping_type IN ('Express', 'Next Day Air') THEN 'Fast'
    WHEN shipping_type = 'Standard' THEN 'Slow'
    ELSE 'Other'
  END AS Delivery_Speed,
  COUNT(*) AS Customer_Count
FROM practical3.sales.shopping
GROUP BY Delivery_Speed;

-- 18) Find customers whose purchase_amount is NULL and whose Promo Code Used is 'Yes'. 
-- Expected Columns: Customer ID, purchase_amount, Promo Code Used

SELECT customer_id, purchase_amount, promo_code_used
FROM practical3.sales.shopping
WHERE purchase_amount IS NULL AND promo_code_used = TRUE;

-- 19) Group by Location and show the maximum Previous Purchases, replacing NULLs with 0, only where the average rating is above 4.0. 
-- Expected Columns: Location, Max Previous Purchases, Average Review Rating

SELECT location, 
        MAX(COALESCE(previous_purchases,0)) AS max_previous_purchase,
        AVG(COALESCE(review_rating,0)) AS Avg_review_rating
FROM practical3.sales.shopping
GROUP BY location
HAVING Avg_review_rating > 4.0;

-- 20) Show customers who have a NULL Shipping Type but made a purchase in the range of 30 to 70 USD. 
-- Expected Columns: Customer ID, Shipping Type, purchase_amount, Item Purchased

SELECT customer_id, shipping_type, purchase_amount,item_purchased
FROM practical3.sales.shopping
WHERE (shipping_type IS NULL) AND (purchase_amount BETWEEN 30 AND 70);
