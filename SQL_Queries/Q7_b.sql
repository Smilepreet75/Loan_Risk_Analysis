SELECT 
    CASE 
        WHEN Public_Records = 0 THEN '0 (None)'
        WHEN Public_Records = 1 THEN '1'
        ELSE '2+'
    END AS Public_Records_Bucket,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 ELSE 0 END) AS Charged_Off_Count,
    SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Default_Ratio
FROM data_for_sql
GROUP BY 
    CASE 
        WHEN Public_Records = 0 THEN '0 (None)'
        WHEN Public_Records = 1 THEN '1'
        ELSE '2+'
    END
order by 
    CASE 
        WHEN Public_Records = 0 THEN '0 (None)'
        WHEN Public_Records = 1 THEN '1'
        ELSE '2+'
    END asc