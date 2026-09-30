select case
       when Interest_Rate< 12 then 'Low'
       when Interest_Rate <= 18 then 'Mid'
       else 'High'
       end as Interest_Rate_Bucket,
       count(*) as Total_Count,
       isnull(sum(case when Loan_Status= 'Charged Off' then 1 end),0) as Charged_count,
       isnull(sum(case when Loan_Status= 'Charged Off' then 1 end) *100.0 / count(*),0) as Default_Ratio
from data_for_sql
group by 
       case
       when Interest_Rate< 12 then 'Low'
       when Interest_Rate <= 18 then 'Mid'
       else 'High'
       end
order by 
        case
            when(case
            when Interest_Rate< 12 then 'Low'
            when Interest_Rate <= 18 then 'Mid'
            else 'High'
            end) = 'Low' then 1
            when(case
            when Interest_Rate< 12 then 'Low'
            when Interest_Rate <= 18 then 'Mid'
            else 'High'
            end) = 'Mid' then 2
            else 3
         end