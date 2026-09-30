-- View feeding the Power BI dashboard: base table + default flag + bucket columns.
-- Replace every <<placeholder>> with your own cutoff before running.

CREATE VIEW vw_loan_dashboard AS
SELECT
    d.*,

    -- 1 = defaulted, 0 = not (same definition used in all SQL analysis queries)
    CASE WHEN Loan_Status = 'Charged Off' THEN 1 ELSE 0 END AS Is_Charged_Off,

    -- Income (Joint applications excluded: their individual income can legitimately be $0)
    CASE
        WHEN Application_Type <> 'Individual' THEN 'Joint'
        WHEN Annual_Income < 53000  THEN '1 - Low'
        WHEN Annual_Income <= 83000 THEN '2 - Mid'
        ELSE '3 - High'
    END AS Income_Bucket,

    CASE
        WHEN Debt_Income_Ratio < 10 THEN '1 - 0-10'
        WHEN Debt_Income_Ratio < 20 THEN '2 - 10-20'
        WHEN Debt_Income_Ratio < 30 THEN '3 - 20-30'
        WHEN Debt_Income_Ratio < 40 THEN '4 - 30-40'
        WHEN Debt_Income_Ratio < 50 THEN '5 - 40-50'
        ELSE '6 - 50-75'
    END AS DTI_Bucket,

    CASE
        WHEN Revolving_Utilization < <<UTIL_P33>>  THEN '1 - Low'
        WHEN Revolving_Utilization <= <<UTIL_P67>> THEN '2 - Mid'
        ELSE '3 - High'
    END AS Utilization_Bucket,

    CASE
        WHEN Credit_History_Length < <<CH_P33>>  THEN '1 - Short'
        WHEN Credit_History_Length <= <<CH_P67>> THEN '2 - Medium'
        ELSE '3 - Long'
    END AS Credit_History_Bucket,

    CASE
        WHEN Interest_Rate < <<INT_LOW>>   THEN '1 - Low'
        WHEN Interest_Rate <= <<INT_HIGH>> THEN '2 - Mid'
        ELSE '3 - High'
    END AS Interest_Rate_Bucket,

    CASE
        WHEN Delinquencies_2Years = 0 THEN '1 - None'
        WHEN Delinquencies_2Years BETWEEN 1 AND 2 THEN '2 - 1-2'
        ELSE '3 - 3+'
    END AS Delinquency_Bucket,

    CASE
        WHEN Inquiries_Last_6Months = 0 THEN '1 - 0'
        WHEN Inquiries_Last_6Months = 1 THEN '2 - 1'
        WHEN Inquiries_Last_6Months = 2 THEN '3 - 2'
        ELSE '4 - 3+'
    END AS Inquiry_Bucket,

    CASE
        WHEN Public_Records_Bankruptcies = 0 THEN '1 - None'
        WHEN Public_Records_Bankruptcies = 1 THEN '2 - 1'
        ELSE '3 - 2+'
    END AS Bankruptcy_Bucket,

    CASE
        WHEN Mortgage_Accounts = 0 THEN '1 - 0'
        WHEN Mortgage_Accounts BETWEEN 1 AND 3 THEN '2 - 1-3'
        WHEN Mortgage_Accounts BETWEEN 4 AND 7 THEN '3 - 4-7'
        ELSE '4 - 8+'
    END AS Mortgage_Bucket

FROM data_for_sql AS d;
