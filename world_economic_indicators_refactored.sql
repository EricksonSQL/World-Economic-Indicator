-- Complete refactored SQL analysis

-- Error handling example
BEGIN TRY
    -- Performance optimizations
    WITH CTE AS (
        SELECT * FROM EconomicIndicators
        WHERE Date >= '2020-01-01'
    )
    SELECT * FROM CTE;
END TRY
BEGIN CATCH
    PRINT 'An error occurred';
END CATCH;

-- Data validation example
IF EXISTS (SELECT 1 FROM EconomicIndicators WHERE GDP IS NULL)
    PRINT 'GDP data is not valid';

-- Comprehensive analysis queries
SELECT Country, AVG(GDP) AS AverageGDP
FROM EconomicIndicators
GROUP BY Country
ORDER BY AverageGDP DESC;

-- Indexes and best practices
CREATE INDEX IX_EconomicIndicators_Country ON EconomicIndicators(Country);
