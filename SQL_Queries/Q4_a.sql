select 
    case 
        when Annual_Income < 53000 then 'Low'
        when Annual_Income <= 83000 then 'Mid'
        else 'High'
    end as Income_Bucket,
    count(*) as Total_Loans,
    sum(case when Loan_Status = 'Charged Off' then 1 else 0 end) as Charged_Off_Count,
    sum(case when Loan_Status = 'Charged Off' then 1 else 0 end) * 100.0 / count(*) as Default_Ratio
from data_for_sql
where Application_Type = 'Individual'
group by 
    case 
        when Annual_Income < 53000 then 'Low'
        when Annual_Income <= 83000 then 'Mid'
        else 'High'
    end
order by 
    case 
        when (case when Annual_Income < 53000 then 'Low'
                   when Annual_Income <= 83000 then 'Mid'
                   else 'High' end) = 'Low' then 1
        when (case when Annual_Income < 53000 then 'Low'
                   when Annual_Income <= 83000 then 'Mid'
                   else 'High' end) = 'Mid' then 2
        else 3
    end;