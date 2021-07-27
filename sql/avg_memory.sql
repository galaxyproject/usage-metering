/*Average amount of memory allocated per tool per month*/

with totalmem as (
select distinct job_id, metric_value from job_metric_numeric
where metric_name = 'memtotal')

select to_char(job.create_time,'YYYY-MM') as date,tool_id,avg(metric_value) as avgMemory
from job join totalmem on job.id = totalmem.job_id
group by date,tool_id
order by date asc, avgMemory desc; 