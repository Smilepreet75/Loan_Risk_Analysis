select distinct 
               PERCENTILE_CONT(0.33) within group (order by Revolving_Utilization) over() as P33,
               PERCENTILE_CONT(0.67) within group (order by Revolving_Utilization) over() as P67
               from data_for_sql
