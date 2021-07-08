/* Number of jobs per tool per month (ie, replicate this diagram) */

select to_char(job.create_time, 'YYYY-MM') as date, tool_id, count(DISTINCT id) as num_jobs
from job 
group by tool_id, date
order by date asc, num_jobs desc;
