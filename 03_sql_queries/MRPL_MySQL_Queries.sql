CREATE DATABASE mrpl_sales;
USE mrpl_sales;

USE mrpl_sales;

SELECT COUNT(*) AS Total_Rows FROM MRPL_Sales_Data;

-- BUSINESS PROBLEM 1: Top Revenue-Generating Industries

SELECT
    Industry,
    COUNT(Order_ID) AS Total_Orders,
    ROUND(SUM(Total_Revenue_INR) / 10000000, 2) AS Revenue_Crore,
    ROUND(AVG(Gross_Margin_Pct), 2) AS Avg_Margin_Pct,
    ROUND(SUM(Total_Revenue_INR) * 100 /
        (SELECT SUM(Total_Revenue_INR) FROM MRPL_Sales_Data), 2) AS Revenue_Share_Pct
FROM MRPL_Sales_Data
GROUP BY Industry
ORDER BY Revenue_Crore DESC;

-- BUSINESS PROBLEM 2: Delivery Delay by Region

SELECT
    Region,
    COUNT(Order_ID)                                                    AS Total_Orders,
    SUM(CASE WHEN Delay_Days > 0 THEN 1 ELSE 0 END)                   AS Delayed_Orders,
    ROUND(SUM(CASE WHEN Delay_Days > 0 THEN 1 ELSE 0 END)
        * 100 / COUNT(Order_ID), 2)                                   AS Delay_Rate_Pct,
    ROUND(AVG(Delay_Days), 1)                                          AS Avg_Delay_Days,
    ROUND(SUM(CASE WHEN On_Time_Delivery = 'Yes' THEN 1 ELSE 0 END)
        * 100 / COUNT(Order_ID), 2)                                   AS On_Time_Pct
FROM MRPL_Sales_Data
GROUP BY Region
ORDER BY Delay_Rate_Pct DESC;

-- BUSINESS PROBLEM 3: Product Type Profitability

SELECT
    Product_Type,
    COUNT(Order_ID)                                                    AS Total_Orders,
    ROUND(SUM(Total_Revenue_INR) / 10000000, 2)                       AS Revenue_Crore,
    ROUND(AVG(Gross_Margin_Pct), 2)                                    AS Avg_Margin_Pct
FROM MRPL_Sales_Data
GROUP BY Product_Type
ORDER BY Avg_Margin_Pct DESC;
 
-- Detailed by each product
SELECT
    Product_Name,
    Product_Type,
    COUNT(Order_ID)                                                    AS Orders,
    ROUND(AVG(Gross_Margin_Pct), 2)                                    AS Avg_Margin_Pct,
    ROUND(SUM(Total_Revenue_INR) / 10000000, 2)                       AS Revenue_Crore
FROM MRPL_Sales_Data
GROUP BY Product_Name, Product_Type
ORDER BY Avg_Margin_Pct DESC; 

-- BUSINESS PROBLEM 4: Seasonal Demand by Quarter

SELECT
    Quarter,
    COUNT(Order_ID)                                                    AS Total_Orders,
    ROUND(SUM(Total_Revenue_INR) / 10000000, 2)                       AS Revenue_Crore,
    ROUND(AVG(Total_Revenue_INR), 0)                                   AS Avg_Order_Value_INR,
    ROUND(COUNT(Order_ID) * 100 /
        (SELECT COUNT(*) FROM MRPL_Sales_Data), 2)                    AS Order_Share_Pct
FROM MRPL_Sales_Data
GROUP BY Quarter
ORDER BY Quarter; 

-- BUSINESS PROBLEM 5: Salesperson Performance

SELECT
    Salesperson,
    COUNT(Order_ID)                                                    AS Total_Orders,
    ROUND(SUM(Total_Revenue_INR) / 10000000, 2)                       AS Revenue_Crore,
    ROUND(AVG(Gross_Margin_Pct), 2)                                    AS Avg_Margin_Pct,
    ROUND(SUM(CASE WHEN On_Time_Delivery = 'Yes' THEN 1 ELSE 0 END)
        * 100 / COUNT(Order_ID), 2)                                   AS On_Time_Pct,
    RANK() OVER (ORDER BY SUM(Total_Revenue_INR) DESC)                AS Revenue_Rank
FROM MRPL_Sales_Data
GROUP BY Salesperson
ORDER BY Revenue_Crore DESC; 

-- Executive KPI Summary

SELECT
    COUNT(Order_ID)                                                    AS Total_Orders,
    ROUND(SUM(Total_Revenue_INR) / 10000000, 2)                       AS Total_Revenue_Crore,
    ROUND(AVG(Gross_Margin_Pct), 2)                                    AS Overall_Margin_Pct,
    ROUND(SUM(CASE WHEN On_Time_Delivery = 'Yes' THEN 1 ELSE 0 END)
        * 100 / COUNT(Order_ID), 2)                                   AS OnTime_Pct,
    ROUND(AVG(Delay_Days), 1)                                          AS Avg_Delay_Days,
    COUNT(DISTINCT Client_Name)                                        AS Total_Clients,
    COUNT(DISTINCT Region)                                             AS Regions_Served
FROM MRPL_Sales_Data;