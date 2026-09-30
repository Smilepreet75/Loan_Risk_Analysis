select distinct
               PERCENTILE_CONT(0.33) within group (order by Credit_History_Length) over() P33,
               PERCENTILE_CONT(0.67) within group (order by Credit_History_Length) over() P67
from data_for_sql
