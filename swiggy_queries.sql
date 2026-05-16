-- ============================================
-- Swiggy Power BI Dashboard - SQL Queries
-- Author: Vibha Pateshwari
-- Description:
-- SQL queries used for data validation,
-- cleaning, transformation, and feature creation
-- before building the Power BI dashboard.
-- ============================================


-- ============================================
-- 1. Preview all tables
-- ============================================

SELECT * FROM dbo.dim_date;
SELECT * FROM dbo.dim_restaurant;
SELECT * FROM dbo.dim_dish;
SELECT * FROM dbo.dim_location;
SELECT * FROM dbo.fact_orders;


-- ============================================
-- 2. Check row counts for all tables
-- ============================================

SELECT COUNT(*) AS dim_date_count FROM dbo.dim_date;
SELECT COUNT(*) AS dim_restaurant_count FROM dbo.dim_restaurant;
SELECT COUNT(*) AS dim_dish_count FROM dbo.dim_dish;
SELECT COUNT(*) AS dim_location_count FROM dbo.dim_location;
SELECT COUNT(*) AS fact_orders_count FROM dbo.fact_orders;


-- ============================================
-- 3. Create and populate a proper date column
-- ============================================

ALTER TABLE dbo.dim_date
ADD order_date_new DATE;

UPDATE dbo.dim_date
SET order_date_new = TRY_CONVERT(DATE, order_date, 5);

SELECT * 
FROM dbo.dim_date
WHERE order_date IS NULL;


-- ============================================
-- 4. Create month and year columns
-- ============================================

ALTER TABLE dbo.dim_date
ADD Month_Name VARCHAR(10),
    Month_Number INT,
    Year_Number INT;

UPDATE dbo.dim_date
SET
    Month_Name = DATENAME(MONTH, order_date_new),
    Month_Number = MONTH(order_date_new),
    Year_Number = YEAR(order_date_new);


-- ============================================
-- 5. Create food type classification column
-- ============================================

ALTER TABLE dbo.dim_dish
ADD Food_Type VARCHAR(20);

UPDATE dbo.dim_dish
SET Food_Type =
    CASE
        WHEN LOWER(dish_name) LIKE '%chicken%' OR
             LOWER(dish_name) LIKE '%egg%' OR
             LOWER(dish_name) LIKE '%fish%' OR
             LOWER(dish_name) LIKE '%mutton%' OR
             LOWER(dish_name) LIKE '%prawn%' OR
             LOWER(dish_name) LIKE '%biryani%' OR
             LOWER(dish_name) LIKE '%kabab%' OR
             LOWER(dish_name) LIKE '%kebab%' OR
             LOWER(dish_name) LIKE '%non-veg%' OR
             LOWER(dish_name) LIKE '%non veg%'
        THEN 'Non-Veg'
        ELSE 'Veg'
    END;


-- ============================================
-- 6. Create day name column
-- ============================================

ALTER TABLE dbo.dim_date
ADD Day_Name VARCHAR(10);

UPDATE dbo.dim_date
SET Day_Name = FORMAT(order_date_new, 'ddd');


-- ============================================
-- 7. Create day number column for sorting
-- ============================================

ALTER TABLE dbo.dim_date
ADD Day_Number INT;

UPDATE dbo.dim_date
SET Day_Number =
    CASE
        WHEN DATEPART(WEEKDAY, order_date_new) = 1 THEN 7
        ELSE DATEPART(WEEKDAY, order_date_new) - 1
    END;


-- ============================================
-- 8. Create week number column
-- ============================================

ALTER TABLE dbo.dim_date
ADD Week_Number INT;

UPDATE dbo.dim_date
SET Week_Number = DATEPART(WEEK, order_date_new);


-- ============================================
-- 9. Create quarter column
-- ============================================

ALTER TABLE dbo.dim_date
ADD Quarter INT;

UPDATE dbo.dim_date
SET Quarter = DATEPART(QUARTER, order_date_new);
