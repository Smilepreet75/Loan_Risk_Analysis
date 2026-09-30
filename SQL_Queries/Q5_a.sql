SELECT 
    Purpose,
    COUNT(*) AS Total_Loans,
    ISNULL(SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 END), 0) AS Charged_Off_Count,
    ISNULL(SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 END), 0) * 100.0 / COUNT(*) AS Default_Ratio
FROM data_for_sql
GROUP BY Purpose
ORDER BY Total_Loans DESC;