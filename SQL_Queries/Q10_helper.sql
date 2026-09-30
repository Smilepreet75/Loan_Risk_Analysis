select distinct
               PERCENTILE_CONT(0.33) within group (order by Interest_Rate) over() P33,
               PERCENTILE_CONT(0.67) within group (order by Interest_Rate) over() P67
from data_for_sql
