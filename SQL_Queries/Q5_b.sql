select case
           when Loan_Amount <10000 then 'Low'
           when Loan_Amount <=18000 then 'Mid'
           else 'High'
           end as Loan_Amount_Bucket,
       Count(*) as Total_Rate,
       sum(case when Loan_Status = 'Charged Off' then 1 end) as Charged_Off,
       sum(case when Loan_Status = 'Charged Off' then 1 end) *100.0/count(*) as Default_Rate 
       from data_for_sql
       group by 
       case
           when Loan_Amount <10000 then 'Low'
           when Loan_Amount <=18000 then 'Mid'
           else 'High'
           end
       order by 
       case
           when
               (case when Loan_Amount <10000 then 'Low'
                when Loan_Amount <=18000 then 'Mid'
                else 'High'
                end) = 'Low' then 1
            when
                (case when Loan_Amount <10000 then 'Low'
                when Loan_Amount <=18000 then 'Mid'
                else 'High'
                end) = 'Mid' then 2
            else 3
        end;

