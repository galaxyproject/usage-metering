/* Number of users running a tool, grouped by month and by year in two separate graphs. */

/* Query that group by month-year */
select to_char(create_time,'YYYY-MM') as date, tool_id,count(distinct user_id) as numusers
from job
group by date,tool_id
order by date asc,numusers desc;

 
