
CREATE DATABASE economics;
USE economics;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS costs;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS revenue;
DROP TABLE IF EXISTS employee;
CREATE TABLE products(
product_id VARCHAR(10) PRIMARY KEY,
product_name VARCHAR (50),
price DECIMAL(10,2));
CREATE TABLE costs(
product_id VARCHAR(10) PRIMARY KEY,
cost_materials DECIMAL(10,2),
cost_labor DECIMAL(10,2));
CREATE TABLE sales(
sale_id VARCHAR(10) PRIMARY KEY,
product_id VARCHAR(10),
quantity INT,
sale_date DATE);
CREATE TABLE revenue(
revenue_id VARCHAR(10) PRIMARY KEY,
sale_id VARCHAR(10),
revenue DECIMAL(10,2));
CREATE TABLE employee(
employee_id VARCHAR(10),
product_id VARCHAR(10));




