-- Average amount of cpu time per tool per month, in seconds.

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
    TO_CHAR(job.create_time, 'YYYY-MM') AS date,
    job.tool_id,
    ROUND(AVG(cpu_usage.cpu_usage_seconds), 0) AS avg_cpu_time_seconds
FROM
    job
    JOIN cpu_usage ON job.id = cpu_usage.job_id
GROUP BY
    date,
    job.tool_id
ORDER BY
    date ASC,
    avg_cpu_time_seconds DESC;
