SELECT 
    CASE 
        WHEN Mortgage_Accounts = 0 THEN '0'
        WHEN Mortgage_Accounts BETWEEN 1 AND 3 THEN '1-3'
        WHEN Mortgage_Accounts BETWEEN 4 AND 7 THEN '4-7'
        ELSE '8+'
    END AS Mortgage_Bucket,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 ELSE 0 END) AS Charged_Off_Count,
    SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Default_Ratio
FROM data_for_sql
GROUP BY 
    CASE 
        WHEN Mortgage_Accounts = 0 THEN '0'
        WHEN Mortgage_Accounts BETWEEN 1 AND 3 THEN '1-3'
        WHEN Mortgage_Accounts BETWEEN 4 AND 7 THEN '4-7'
        ELSE '8+'
    END;