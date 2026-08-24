# Olist-E-Commerce-SQL-Data-Cleaning-Business-Analysis
A comprehensive SQL data analysis project using the Olist Brazilian E-Commerce dataset and MySQL. The project focuses on data exploration, cleaning, data quality validation, relational analysis and extracting business insights from customers, orders, products, payments, reviews and delivery data.

## 🎯 Project Objectives

- Understand the structure and relationships between multiple e-commerce tables
- Explore customer, order, product, payment, review and seller data
- Identify and handle data quality issues
- Validate dates, NULL values, duplicates and inconsistent records
- Establish appropriate primary and foreign key relationships
- Perform relational analysis using SQL joins
- Calculate important business metrics
- Analyze customer, order, payment, product, review and delivery data
- Generate actionable business insights from the dataset

---

## 🗂️ Dataset

The project uses the **Olist Brazilian E-Commerce Public Dataset**, which contains information about orders placed on the Olist marketplace in Brazil.

The dataset contains multiple related tables covering areas such as:

- Customers
- Orders
- Order Items
- Order Payments
- Order Reviews
- Products
- Sellers
- Product Categories
- Geolocation(Not used because of file size)

The dataset contains approximately **100K orders** and related transactional records.

---

## 🛠️ Tools & Technologies

- **MySQL**
- **MySQL Workbench**
- SQL
- Relational Database Concepts
- Data Cleaning
- Data Quality Validation
- Data Analysis

### SQL Concepts Used

- SELECT
- WHERE
- GROUP BY
- HAVING
- ORDER BY
- CASE
- Aggregate Functions
- INNER JOIN
- LEFT JOIN
- RIGHT JOIN
- Subqueries
- Common Table Expressions (CTEs)
- Window Functions
- Date & Time Functions
- String Functions
- NULL Handling
- Data Type Conversion
- Primary Keys
- Foreign Keys
- Data Validation

---

## 🏗️ Project Workflow

### 1. Database Exploration

- Inspected the available tables
- Examined table structures and columns
- Checked row counts
- Identified important identifiers
- Studied relationships between tables

### 2. Data Cleaning

Performed SQL-based cleaning to identify and resolve issues such as:

- Incorrect data types
- Blank values
- NULL values
- Duplicate records
- Invalid dates
- Inconsistent categorical values
- Missing product categories
- Incorrect or suspicious date relationships

### 3. Data Quality Validation

Created validation queries to identify potential data-quality problems.

Examples include:

- Checking duplicate customer identifiers
- Checking missing product categories
- Checking invalid dates
- Checking delivery dates occurring before approval dates
- Checking blank values in numeric columns
- Checking unexpected values in categorical fields
- Validating relationships between tables

### 4. Relational Data Analysis

Used joins across multiple tables to analyze relationships between:

- Customers and orders
- Orders and payments
- Orders and reviews
- Orders and products
- Products and categories
- Orders and delivery information

### 5. Business Analysis

Calculated and analyzed metrics such as:

- Total orders
- Delivered order percentage
- Average Order Value (AOV)
- Payment method distribution
- Customer counts
- Product category availability
- Delivery performance
- Review data quality
- Order and payment patterns

---

## 📊 Key Analysis Performed

### Customer Analysis

- Total customer records
- Unique customer analysis
- Customer identifier validation
- Customer order relationships

### Order Analysis

- Order status distribution
- Delivered order percentage
- Order volume analysis
- Order date analysis
- Order lifecycle validation

### Payment Analysis

- Payment method distribution
- Payment counts
- Payment percentages
- Total payment value
- Average Order Value

### Product Analysis

- Product category analysis
- Missing category identification
- Product data-quality checks
- Product attribute validation

### Delivery Analysis

- Delivery date validation
- Delivery timeline analysis
- Identification of inconsistent delivery records
- Order approval vs. delivery date validation

### Review Analysis

- Review record validation
- Review date validation
- Identification of suspicious/future dates
- Review-related data-quality checks

---

## 📈 Selected Findings

Some of the analysis produced the following results:

- Approximately **99K customer records** were identified in the customer table.
- Approximately **100K orders** were analyzed.
- Around **97% of orders** were identified as delivered based on the order status analysis.
- The calculated **Average Order Value was approximately R$153.07**.
- Data-quality checks identified missing and inconsistent product category information.
- Multiple date inconsistencies were identified during order and review validation.
- Duplicate values were identified in customer identifiers and investigated using SQL.
- Blank values were identified in several product attributes and evaluated during the cleaning process.

> These findings are based on the cleaned/processed dataset and the SQL analysis performed in this project.

---

## 🧹 Data Cleaning Examples

Some of the major cleaning and validation tasks included:

```sql
-- Example: Converting text dates into DATETIME

UPDATE orders
SET order_date_new =
    STR_TO_DATE(order_date, '%d-%m-%Y %H:%i:%s');
