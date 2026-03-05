create database cars_db;
Create Schema task8;
CREATE TABLE task8.car_data_raw (
    date DATE,
    seller_name TEXT,
    seller_city TEXT,
    seller_state TEXT,
    seller_phone TEXT,
    car_make TEXT,
    car_model TEXT,
    car_year INT,
    car_color TEXT,
    customer_name TEXT,
    customer_email TEXT,
    customer_phone TEXT,
    customer_address TEXT,
    price DECIMAL(12, 2)
);

WITH Sellers AS (
    SELECT DISTINCT 
        DENSE_RANK() OVER (ORDER BY seller_name, seller_phone) AS seller_id,
        seller_name, seller_city, seller_state, seller_phone
    FROM task8.car_data_raw
),

Cars AS (
    SELECT DISTINCT 
        DENSE_RANK() OVER (ORDER BY car_make, car_model, car_year, car_color) AS car_id,
        car_make, car_model, car_year, car_color
    FROM task8.car_data_raw
),

Customers AS (
    SELECT DISTINCT 
        DENSE_RANK() OVER (ORDER BY customer_email) AS customer_id,
        customer_name, customer_email, customer_phone, customer_address
    FROM task8.car_data_raw
),

Final_Normalized_Data AS (
    SELECT 
        raw.date,
        s.seller_id,
        c.car_id,
        cust.customer_id,
        raw.price
    FROM task8.car_data_raw raw
    JOIN Sellers s ON raw.seller_name = s.seller_name AND raw.seller_phone = s.seller_phone
    JOIN Cars c ON raw.car_make = c.car_make AND raw.car_model = c.car_model AND raw.car_year = c.car_year AND raw.car_color = c.car_color
    JOIN Customers cust ON raw.customer_email = cust.customer_email
)

SELECT * FROM Final_Normalized_Data;