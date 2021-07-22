with numusers as (
    select to_char(job.create_time, 'YYYY-MM') as date, tool_id, count(DISTINCT user_id) as num_users
    from job 
    group by tool_id, date
    order by date asc, num_users desc
),

numjobs as (
    select to_char(job.create_time, 'YYYY-MM') as date, tool_id, count(DISTINCT id) as num_jobs
    from job 
    group by tool_id, date
    order by date asc, num_jobs desc
)

select numjobs.date, numjobs.tool_id, num_jobs, num_users
from numusers join numjobs on 
numjobs.tool_id = numusers.tool_id and numjobs.date = numusers.date
order by date asc