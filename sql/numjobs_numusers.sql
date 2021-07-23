select to_char(job.create_time, 'YYYY-MM') as date, tool_id, count(DISTINCT id) as num_jobs, count(DISTINCT user_id) as num_users
from job 
group by tool_id, date
order by date asc