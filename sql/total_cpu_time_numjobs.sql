-- Total amount of cpu time per tool per month (in seconds) and number of jobs per tool.

WITH cpu_usage AS (
    SELECT
        DISTINCT job_id,
        metric_value / 1000000000 AS cpu_usage_seconds  -- Convert from nanoseconds to seconds.
    FROM
        job_metric_numeric
    WHERE
        metric_name = 'cpuacct.usage'
)
SELECT
    to_char(job.create_time, 'YYYY-MM') AS date,
    job.tool_id,
    ROUND(SUM(cpu_usage.cpu_usage_seconds), 0) AS total_cpu_time_seconds,
    COUNT(DISTINCT id) AS num_jobs
FROM
    job
    JOIN cpu_usage ON job.id = cpu_usage.job_id
GROUP BY
    date,
    job.tool_id
ORDER BY
    date ASC,
    total_cpu_time_seconds DESC;
