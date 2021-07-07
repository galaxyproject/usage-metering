/* Number of users running a tool, grouped by month and by year in two separate graphs. */

/* Query that group by month-year */
select concat(cast(EXTRACT(year FROM cast(job.create_time as date)) as varchar(4)),'-',cast(EXTRACT(month FROM cast(job.create_time as date)) as varchar(2))) as month_year, tool_id,count(distinct user_id) as numusers
from job join job_metric_numeric on job.id = job_metric_numeric.job_id
group by month_year,tool_id
order by month_year asc,numusers desc;

 
