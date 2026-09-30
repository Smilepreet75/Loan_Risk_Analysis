SELECT 
    CASE 
        WHEN Debt_Income_Ratio < 10 THEN '0-10'
        WHEN Debt_Income_Ratio < 20 THEN '10-20'
        WHEN Debt_Income_Ratio < 30 THEN '20-30'
        WHEN Debt_Income_Ratio < 40 THEN '30-40'
        WHEN Debt_Income_Ratio < 50 THEN '40-50'
        ELSE '50-75'
    END AS DTI_Bucket,
    COUNT(*) AS Total_Loans,
    COUNT(CASE WHEN Loan_Status = 'Charged Off' THEN 1 END) AS Charged_Off_Count,
    COUNT(CASE WHEN Loan_Status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*) AS Default_Rate_Pct
FROM data_for_sql
GROUP BY 
    CASE 
        WHEN Debt_Income_Ratio < 10 THEN '0-10'
        WHEN Debt_Income_Ratio < 20 THEN '10-20'
        WHEN Debt_Income_Ratio < 30 THEN '20-30'
        WHEN Debt_Income_Ratio < 40 THEN '30-40'
        WHEN Debt_Income_Ratio < 50 THEN '40-50'
        ELSE '50-75'
    END
ORDER BY DTI_Bucket;