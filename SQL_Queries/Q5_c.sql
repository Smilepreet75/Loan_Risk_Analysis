select distinct Term, 
       count(*) as Total_Count,
       sum(case when Loan_Status = 'Charged Off' then 1 end) as Charged_Off_Count,
       sum(case when Loan_Status = 'Charged Off' then 1 end) *100.0/ count(*) as Default_Rate
       from data_for_sql
       group by Term
