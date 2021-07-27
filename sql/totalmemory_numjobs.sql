with totalmem as (
    select distinct job_id,metric_value
    from job_metric_numeric
    where metric_name = 'memtotal'
)

select tool_id,sum(metric_value) as totalMemory,
COUNT(distinct id) as num_jobs
from job join totalmem on job.id = totalmem.job_id
group by tool_id
order by totalMemory desc,num_jobs desc; 