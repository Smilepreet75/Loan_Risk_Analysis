select Grade,
     count(case when Loan_Status = 'Charged Off' then 1 end) as ChargedOff_Count,
     count(*) as Total_Loan,
     COUNT(CASE WHEN Loan_Status = 'Charged Off' THEN 1 END) * 100.0 / COUNT(*) AS Default_Rate_Pct
     from data_for_sql
     group by Grade
     order by Default_Rate_Pct