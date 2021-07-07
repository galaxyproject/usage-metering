/*Average amount of memory allocated per tool per month*/

with totalmem as (
select distinct job_id, metric_value from job_metric_numeric
where metric_name = 'memtotal')

select concat(cast(EXTRACT(year FROM cast(job.create_time as date)) as varchar(4)),'-',cast(EXTRACT(month FROM cast(job.create_time as date)) as varchar(2))) as month_year,tool_id,avg(metric_value) as avgMemory
from job join totalmem on job.id = totalmem.job_id
group by month_year,tool_id
order by month_year asc, avgMemory desc; 