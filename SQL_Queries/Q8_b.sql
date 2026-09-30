SELECT distinct Address_State,
    COUNT(*) AS Total_Loans,
    SUM(Loan_Amount) AS Sum_LoanAmount
FROM data_for_sql
GROUP BY 
    Address_State
order by 
    Sum_LoanAmount desc