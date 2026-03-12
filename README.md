\# Retail Sales SQL EDA



\## Project Overview



This project performs Exploratory Data Analysis (EDA) on a retail transaction dataset using SQL to uncover insights about sales performance, store contribution, product demand, and customer purchasing behavior.



\---



\## Project Structure



```

retail-sql-eda

│

├── dataset

│   └── retail\_transactions.csv

│

├── sql

│   ├── 01\_create\_database.sql

│   ├── 02\_data\_cleaning.sql

│   └── 03\_analysis.sql

│

└── README.md

```



This repository contains:



\* \*\*dataset/\*\* → raw dataset used for analysis

\* \*\*sql/\*\* → SQL scripts for database creation, data cleaning, and analysis

\* \*\*README.md\*\* → project documentation



\---



\## Dataset



The dataset contains \*\*2000 retail transactions\*\* from multiple stores including product, payment, and transaction details.



\### Columns



\* StoreID

\* Location

\* Product

\* Quantity

\* UnitPrice

\* PaymentType

\* TransactionID

\* Cashier

\* StoreManager

\* TimeOfDay

\* DayOfWeek

\* TotalPrice

\* Date

\* Time



\---



\## Analysis Performed



\### Executive Overview



\* Total revenue and transaction count

\* Average transaction value

\* Sales volume and date range



\### Store Performance



\* Store revenue ranking

\* Store revenue contribution

\* Most consistent performing store



\### Product Analysis



\* Top revenue products

\* Top selling products

\* Pareto analysis of product revenue



\### Time-Based Analysis



\* Peak sales hour

\* Highest revenue day

\* Daily revenue trends



\### Payment \& Workforce



\* Revenue by payment method

\* Cashier performance analysis



\### Advanced SQL Analysis



\* Running revenue totals

\* Top 20% transactions

\* High-value transaction detection



\---



\## SQL Skills Demonstrated



\* Aggregations (SUM, AVG, COUNT)

\* Window Functions (RANK, LAG)

\* Subqueries

\* Time-based analysis

\* Revenue contribution analysis



\---



\## Tools Used



MySQL • MySQL Workbench • CSV Dataset



\---



\## Author



Saurabh Prajapati



