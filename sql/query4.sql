/*Total amount of memory allocated per tool per month*/

with totalmem as (
select * from job join job_metric_numeric on job.id = job_metric_numeric.job_id
where metric_name = 'memtotal')

select extract(month from create_time) as month, extract(year from create_time) as year,tool_id,sum(metric_value) as totalMemory
from totalmem
group by extract(month from create_time), extract(year from create_time),tool_id;