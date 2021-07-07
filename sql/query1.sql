/* Number of jobs per tool per month (ie, replicate this diagram) */

select to_char(job.create_time, 'YYYY-MM') as date, tool_id, count(DISTINCT job_id) as num_jobs
from job join job_metric_numeric on job.id = job_metric_numeric.job_id
group by tool_id, date
order by date asc, num_jobs desc;
