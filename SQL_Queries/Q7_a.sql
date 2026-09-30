select distinct 
       CASE 
           WHEN Delinquencies_2Years = 0 THEN '0 (None)'
           WHEN Delinquencies_2Years BETWEEN 1 AND 2 THEN '1-2'
           ELSE '3+'
       END as Delinquencies_Bucket,
       count(*) as Total_count,
       isnull(sum(case when Loan_Status = 'Charged Off' then 1 end),0) as Charged_count,
       isnull(sum(case when Loan_Status = 'Charged Off' then 1 end),0) *100.0 / count(*) as Default_Rate
from data_for_sql 
group by 
 CASE 
           WHEN Delinquencies_2Years = 0 THEN '0 (None)'
           WHEN Delinquencies_2Years BETWEEN 1 AND 2 THEN '1-2'
           ELSE '3+'
       END
order by 
 CASE 
           WHEN Delinquencies_2Years = 0 THEN '0 (None)'
           WHEN Delinquencies_2Years BETWEEN 1 AND 2 THEN '1-2'
           ELSE '3+'
       END asc