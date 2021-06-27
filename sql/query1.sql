/* Number of jobs per tool per month (ie, replicate this diagram) */

select tool_id,extract(month from create_time) as month,extract(year from create_time) as year,count(DISTINCT job_id) as num_jobs
from job join job_metric_numeric on job.id = job_metric_numeric.job_id
group by tool_id,extract(month from create_time),extract(year from create_time);

