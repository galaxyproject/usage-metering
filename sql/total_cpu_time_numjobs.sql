with cpu_usage as ( 
select distinct job_id,metric_value as cpu_usage
from job_metric_numeric where metric_name = 'cpuacct.usage'),



runtime_seconds as (
select distinct job_id,metric_value as runtime_seconds
from job_metric_numeric where metric_name = 'runtime_seconds'),

runtime_cpu_combined as (
select distinct cpu_usage.job_id,cpu_usage,runtime_seconds
from cpu_usage join runtime_seconds
on cpu_usage.job_id = runtime_seconds.job_id),

select job.tool_id,to_char(job.create_time, 'YYYY-MM') as date,SUM(runtime_cpu_combined.cpu_usage * runtime_cpu_combined.runtime_seconds) as total_cpu_time
, COUNT(distinct id) as num_jobs
from job join runtime_cpu_combined on job.id = runtime_cpu_combined.job_id
group by date,job.tool_id
order by date asc, total_cpu_time desc;