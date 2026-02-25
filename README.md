📊 World Economic Indicators SQL Analysis Project
This project showcases a structured SQL-based analysis of global macroeconomic data (1960–2022).
The objective is to clean, transform, and analyze economic indicators to extract meaningful insights about GDP, unemployment, and remittances across countries.

🔑 Key SQL Processes Used
- Created a cleaned table using TRY_CAST() to convert numeric columns
- Handled missing values using NULLIF()
- Standardized year format (INT)
- Created a VIEW to exclude regional and income aggregates
- Used GROUP BY and AVG() for trend analysis
- Applied subqueries to extract latest year data
- Used RANK() OVER (PARTITION BY Year) for country GDP ranking
- Filtered real countries using Country_Code NOT IN (...)

🛠 Tools & Skills Used
- SQL Server (SSMS)
- Views
- Window Functions
- Subqueries
- Aggregate Functions (AVG, COUNT, MAX, MIN)
- Data Cleaning & Transformation
- Analytical Ranking

📂 Files Included
- world_economic_indicators_query.sql – Complete SQL analysis script
- world_economic_indicators_query.csv – Raw version of the dataset

📊 Analysis Performed
- Global GDP Growth Trend (1960–2022)
- Top 10 Countries by GDP (Latest Year)
- Countries with Highest Unemployment
- Global Unemployment Trend
- Countries with Consistent GDP Growth
- GDP Ranking Per Year (Window Functions)

📌 Dataset Source

Kaggle – World Economic Indicators (1960–2022)
