-- Average amount of memory consumed per tool per month.

WITH consumed_mem AS (
    SELECT
        DISTINCT job_id,
        metric_value
    FROM
        job_metric_numeric
    WHERE
        metric_name = 'memory.max_usage_in_bytes'
)
SELECT
    TO_CHAR(job.create_time, 'YYYY-MM') AS date,
    tool_id,
    ROUND(AVG(metric_value) * 0.000000001, 0) AS consumed_mem_gb  -- Convert to GB
FROM
    job
    JOIN consumed_mem ON job.id = consumed_mem.job_id
GROUP BY
    date,
    tool_id
ORDER BY
    date ASC,
    consumed_mem_gb DESC;
