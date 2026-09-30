select sum(case when Loan_Status = 'Fully Paid' or Loan_Status ='Does not meet the credit policy. Status:Fully Paid' then Loan_Amount else 0 end)*100.0 / sum(Loan_Amount) as Fully_Paid_Loan, 
       sum(case when Loan_Status = 'Current' then Loan_Amount else 0 end)*100.0 / sum(Loan_Amount) as Current_Loan,
       sum(case when Loan_Status = 'Charged Off' or Loan_Status ='Does not meet the credit policy. Status:Charged Off' then Loan_Amount else 0 end)*100.0 / sum(Loan_Amount) as Charged_Off_Loan,
       sum(case when Loan_Status = 'Late (31-120 days)' or Loan_Status = 'Late (16-31 days)' then Loan_Amount else 0 end)*100.0 / sum(Loan_Amount) as Late_Loan,
       sum(case when Loan_Status = 'In Grace Period' then Loan_Amount else 0 end)*100.0 / sum(Loan_Amount) as In_Grace_Period
from data_for_sql;