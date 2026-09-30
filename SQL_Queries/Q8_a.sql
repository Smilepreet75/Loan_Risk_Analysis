SELECT distinct Address_State,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 ELSE 0 END) AS Charged_Off_Count,
    SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Default_Ratio
FROM data_for_sql
GROUP BY 
    Address_State
order by 
    Default_Ratio 