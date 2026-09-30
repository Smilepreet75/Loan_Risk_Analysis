SELECT 
    CASE 
        WHEN Inquiries_Last_6Months = 0 THEN '0'
        WHEN Inquiries_Last_6Months = 1 THEN '1'
        WHEN Inquiries_Last_6Months = 2 THEN '2'
        WHEN Inquiries_Last_6Months >= 3 THEN '3+'
    END AS Inquiry_Bucket,
    COUNT(*) AS Total_Loans,
    SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 ELSE 0 END) AS Charged_Off_Count,
    SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 ELSE 0 END) * 100.0 / COUNT(*) AS Default_Ratio
FROM data_for_sql
GROUP BY 
    CASE 
        WHEN Inquiries_Last_6Months = 0 THEN '0'
        WHEN Inquiries_Last_6Months = 1 THEN '1'
        WHEN Inquiries_Last_6Months = 2 THEN '2'
        WHEN Inquiries_Last_6Months >= 3 THEN '3+'
    END
order by 
    CASE 
        WHEN Inquiries_Last_6Months = 0 THEN '0'
        WHEN Inquiries_Last_6Months = 1 THEN '1'
        WHEN Inquiries_Last_6Months = 2 THEN '2'
        WHEN Inquiries_Last_6Months >= 3 THEN '3+'
    END asc;