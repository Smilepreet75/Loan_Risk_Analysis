select distinct 
               PERCENTILE_CONT(0.33) within group( Order by Open_Accounts) over() as P33,
               PERCENTILE_CONT(0.67) within group(order by Open_Accounts) over() as P67
               from data_for_sql

