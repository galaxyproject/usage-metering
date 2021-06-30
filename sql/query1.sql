/* Number of jobs per tool per month (ie, replicate this diagram) */

select tool_id,concat(cast(EXTRACT(year FROM cast(job.create_time as date)) as varchar(4)),'-',cast(EXTRACT(month FROM cast(job.create_time as date)) as varchar(2))) as month_year,count(DISTINCT job_id) as num_jobs
from job join job_metric_numeric on job.id = job_metric_numeric.job_id
group by tool_id,month_year
order by num_jobs desc;

