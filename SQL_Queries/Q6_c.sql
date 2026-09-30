select case 
           when Revolving_Utilization < 38.09 then 'Low'
           when Revolving_Utilization <=62.90 then 'Mid'
           else 'High'
        end as Revolving_Utilization_Bucket,
        count(*) as Total_count,
        sum(case when Loan_Status  = 'Charged Off' then 1 end )as Charged_count,
        sum(case when Loan_Status  = 'Charged Off' then 1 end ) * 100.0 /count(*) as Default_Rate
        from data_for_sql
        group by 
        case 
           when Revolving_Utilization < 38.09 then 'Low'
           when Revolving_Utilization <=62.90 then 'Mid'
           else 'High'
        end
        order by 
        case 
            when(case 
                     when Revolving_Utilization < 38.09 then 'Low'
                     when Revolving_Utilization <=62.90 then 'Mid'
                     else 'High'
            end) = 'Low' then 1
            when(case 
                     when Revolving_Utilization < 38.09 then 'Low'
                     when Revolving_Utilization <=62.90 then 'Mid'
                     else 'High'
            end) = 'Mid' then 2
            else 3
        end
            
                
