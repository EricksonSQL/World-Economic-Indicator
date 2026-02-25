use PortfolioProject

EXEC sp_help 'world_economic_indicators';

CREATE TABLE world_economic_indicators_clean (
    Country_Name NVARCHAR(255),
    Country_Code NVARCHAR(10),
    Year INT,
    Remittances_Percent_GDP FLOAT,
    Unemployment_Rate FLOAT,
    GDP_Current_USD FLOAT,
    GDP_Growth_Annual FLOAT
);

INSERT INTO world_economic_indicators_clean
SELECT
    [Country Name],
    [Country Code],
    TRY_CAST([Year] AS INT),

    TRY_CAST([Personal remittances, received (% of GDP)] AS FLOAT),

    TRY_CAST([Unemployment, total (% of total labor force)] AS FLOAT),

    TRY_CAST([GDP (current US$)_x] AS FLOAT),

    TRY_CAST([GDP growth (annual %)_x] AS FLOAT)

FROM world_economic_indicators;

SELECT *
FROM world_economic_indicators_clean

-- Understand the Dataset
SELECT COUNT(*) AS Total_Rows
FROM world_economic_indicators_clean;

SELECT MIN(Year) AS Min_Year, MAX(Year) AS Max_Year
FROM world_economic_indicators_clean;

SELECT COUNT(DISTINCT Country_Name) AS Total_Countries
FROM world_economic_indicators_clean;

-- Global Economic Overview

-- Average GDP Growth Per Year
SELECT 
    Year,
    AVG(GDP_Growth_Annual) AS Avg_GDP_Growth
FROM world_economic_indicators_clean
GROUP BY Year
ORDER BY Year desc;

-- Top 10 Countries by GDP (Latest Year)
CREATE VIEW vw_real_countries AS
SELECT *
FROM world_economic_indicators_clean
WHERE Country_Name NOT LIKE '%income%'
AND Country_Name NOT LIKE '%World%'
AND Country_Name NOT LIKE '%members%'
AND Country_Name NOT LIKE '%total%';

SELECT TOP 10
    Country_Code,
    Country_Name,
    GDP_Current_USD
FROM vw_real_countries
WHERE Year = (SELECT MAX(Year) FROM vw_real_countries)
ORDER BY GDP_Current_USD DESC;

ALTER VIEW vw_real_countries AS
SELECT *
FROM world_economic_indicators_clean
WHERE Country_Code NOT IN (
    'WLD','HIC','LIC','LMC','UMC',
    'EAS','ECA','EUU','ARB','NAC',
    'SAS','SSA','IBD','IDA','OED','PST','IBT','LMY','MIC','LTE','EAP','TEA','ECS','EMU','EAR','LCN','TLA','LAC','TEC','MEA','TSA','SSF',
    'TSS'
);

-- Unemployment Analysis

-- Countries with Highest Unemployment (2022)
SELECT TOP 10
    Year, 
    Country_Name,
    Unemployment_Rate
FROM world_economic_indicators_clean
WHERE Year = (SELECT MAX(Year) FROM world_economic_indicators_clean)
ORDER BY Unemployment_Rate DESC;

--Global Average Unemployment Trend
SELECT 
    Year,
    AVG(Unemployment_Rate) AS Avg_Unemployment
FROM world_economic_indicators_clean
GROUP BY Year
ORDER BY Year;

UPDATE world_economic_indicators_clean
SET Unemployment_Rate = NULL
WHERE Unemployment_Rate = 0
AND Year < 1980;   -- adjust based data

SELECT
    Year,
    AVG(Unemployment_Rate) AS Avg_Unemployment
FROM vw_real_countries
GROUP BY Year
ORDER BY Year DESC;

TRUNCATE TABLE world_economic_indicators_clean;

INSERT INTO world_economic_indicators_clean
SELECT
    [Country Name] AS Country_Name,
    [Country Code] AS Country_Code,
    TRY_CAST([Year] AS INT),

    TRY_CAST(
        NULLIF([Personal remittances, received (% of GDP)], '')
        AS FLOAT
    ),

    TRY_CAST(
        NULLIF([Unemployment, total (% of total labor force)], '')
        AS FLOAT
    ),

    TRY_CAST([GDP (current US$)_x] AS FLOAT),

    TRY_CAST([GDP growth (annual %)_x] AS FLOAT)

FROM world_economic_indicators;

SELECT *
FROM world_economic_indicators_clean
WHERE Year < 1970
ORDER BY Year;

-- Remittances Analysis
-- Countries Most Dependent on Remittances
SELECT TOP 10
    Country_Name,
    Remittances_Percent_GDP
FROM vw_real_countries
WHERE Year = (SELECT MAX(Year) FROM vw_real_countries)
ORDER BY Remittances_Percent_GDP DESC;

-- Correlation Style Exploration
-- Does Higher GDP Mean Lower Unemployment?
SELECT
    Country_Name,
    GDP_Current_USD,
    Unemployment_Rate
FROM vw_real_countries
WHERE Year = (SELECT MAX(Year) FROM vw_real_countries)
ORDER BY GDP_Current_USD DESC;

-- Countries with Consistent GDP Growth
SELECT 
    Country_Name,
    AVG(GDP_Growth_Annual) AS Avg_Growth_Last5Years
FROM vw_real_countries
WHERE Year >= (SELECT MAX(Year) - 5 FROM world_economic_indicators_clean)
GROUP BY Country_Name
HAVING AVG(GDP_Growth_Annual) > 3
ORDER BY Avg_Growth_Last5Years DESC;

-- Rank Countries by GDP Per Year
SELECT
    Country_Name,
    Year,
    GDP_Current_USD,
    RANK() OVER (PARTITION BY Year ORDER BY GDP_Current_USD DESC) AS GDP_Rank
FROM vw_real_countries;






