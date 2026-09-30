select distinct Home_Ownership, 
       COUNT(*) AS Total_Loans,
       isnull(SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 END),0) AS Charged_Off_Count,
       isnull(SUM(CASE WHEN Loan_Status = 'Charged Off' THEN 1 END),0) * 100.0 / COUNT(*) AS Default_Ratio
       from data_for_sql
       group by Home_Ownership
       order by Total_Loans desc