SELECT 
    COUNT(*) AS Total_Charged_Off_Loans,
    SUM(Loan_Amount) AS Total_Charged_Off_Amount,
    SUM(Total_Payment) AS Total_Amount_Paid_Before_Default,
    SUM(Recoveries) AS Total_Recovered_After_Default,
    SUM(Collection_Recovery_Fee) AS Total_Recovery_Fees,
    SUM(Loan_Amount) - SUM(Total_Payment) - SUM(Recoveries) AS Net_Amount_Lost,
    (SUM(Total_Payment) + SUM(Recoveries)) * 100.0 / SUM(Loan_Amount) AS Pct_Amount_Recovered
FROM data_for_sql
WHERE Loan_Status = 'Charged Off';