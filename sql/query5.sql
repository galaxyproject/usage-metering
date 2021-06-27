/* Number of users running a tool, grouped by month and by year in two separate graphs. */

/* Query that group by month */
select extract(month from create_time) as month, extract(year from create_time) as year, count(distinct user_id) as numusers
from job join job_metric_numeric on job.id = job_metric_numeric.job_id
group by extract(month from create_time), extract(year from create_time);

/* Query that gropu by year */
select extract(year from create_time) as year, count(distinct user_id) as numusers
from job join job_metric_numeric on job.id = job_metric_numeric.job_id
group by extract(year from create_time); 
