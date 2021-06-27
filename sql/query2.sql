/*Query 2: Total amount of cpu time per tool per month. We can calculate this by multiplying runtime by number of cpus for each tool and summing it up. */

with cpu_usage as (
select distinct id,create_time,tool_id,state,command_line,tool_version,user_id,imported,destination_id,galaxy_version,metric_name,metric_value as cpu_usage
from job join job_metric_numeric on job.id = job_metric_numeric.job_id where metric_name = 'cpuacct.usage'),
runtime_seconds as (
select distinct id,create_time,tool_id,state,command_line,tool_version,user_id,imported,destination_id,galaxy_version,metric_name,metric_value as runtime_seconds from job join job_metric_numeric on job.id = job_metric_numeric.job_id where metric_name = 'runtime_seconds')

select cpu_usage.tool_id,extract(month from cpu_usage.create_time) as month,extract(year from cpu_usage.create_time) as year,SUM(cpu_usage.cpu_usage * runtime_seconds.runtime_seconds) as total_cpu_time
from cpu_usage join runtime_seconds on cpu_usage.id = runtime_seconds.id and cpu_usage.create_time = runtime_seconds.create_time and cpu_usage.tool_id = runtime_seconds.tool_id
and cpu_usage.state = runtime_seconds.state and cpu_usage.command_line = runtime_seconds.command_line and cpu_usage.tool_version = runtime_seconds.tool_version and cpu_usage.user_id = runtime_seconds.user_id
and cpu_usage.imported = runtime_seconds.imported and cpu_usage.destination_id = runtime_seconds.destination_id and cpu_usage.galaxy_version = runtime_seconds.galaxy_version
group by extract(month from cpu_usage.create_time),extract(year from cpu_usage.create_time),cpu_usage.tool_id;



/* Average amount of cpu time per tool per month. It’d be great to visualize this as a bar graph with error bars indicating 1 standard deviation of runtime.
Total amount of memory allocated per tool per month

Average amount of memory allocated per tool per month
Number of users running a tool, grouped by month and by year in two separate graphs.*/