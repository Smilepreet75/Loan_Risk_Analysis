select case
           when Open_Accounts <9 then 'Low'
           when Open_Accounts <=13 then 'Mid'
           else 'High'
           end as Account_Bucket,
           count(*) as Total_Count,
           sum(case when Loan_Status = 'Charged Off' then 1 end) as Charged_count,
           sum(case when Loan_Status = 'Charged Off' then 1 end) *100.0 / count(*) as Default_Rate
       from data_for_sql
       group by 
       case 
           when Open_Accounts <9 then 'Low'
           when Open_Accounts <=13 then 'Mid'
           else 'High'
       end
       order by
       case 
           when(case when Open_Accounts <9 then 'Low'
                     when Open_Accounts <=13 then 'Mid'
                     else 'High'
           end) = 'Low' then 1
           when(case when Open_Accounts <9 then 'Low'
                     when Open_Accounts <=13 then 'Mid'
                     else 'High'
           end) = 'Mid' then 2
           else 3
       end

