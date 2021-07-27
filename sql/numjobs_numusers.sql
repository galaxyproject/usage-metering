select tool_id, count(DISTINCT id) as num_jobs, count(DISTINCT user_id) as num_users
from job 
group by tool_id
order by num_jobs desc, num_users desc;