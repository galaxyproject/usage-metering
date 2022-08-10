-- Count total memory a tool consumed, was alloctaed, and ratio across all jobs.

WITH consumed_mem AS (
    SELECT
        DISTINCT job_id,
        metric_value as max_mem
    FROM
        job_metric_numeric
    WHERE
        metric_name = 'memory.max_usage_in_bytes'
),
allocated_mem AS (
    SELECT
        DISTINCT job_id,
        metric_value as allc_mem
    FROM
        job_metric_numeric
    WHERE
        metric_name = 'galaxy_memory_mb'
),
aggregate_mem AS (
    SELECT
        tool_id,
        COUNT(DISTINCT id) AS num_jobs,
        ROUND(SUM(max_mem) * 0.000000001, 0) AS consumed_mem_gb,  -- Convert to GB
        CAST(SUM(allc_mem) * 0.001 AS int) AS allocated_mem_gb -- Convert to GB
    FROM
        job
        JOIN consumed_mem ON job.id = consumed_mem.job_id
        JOIN allocated_mem ON job.id = allocated_mem.job_id
    GROUP BY
        tool_id
)
SELECT
    tool_id,
    num_jobs,
    consumed_mem_gb,
    allocated_mem_gb,
    ROUND(100 * consumed_mem_gb/allocated_mem_gb, 1) AS pct_mem_consumed
FROM
    aggregate_mem
ORDER BY
    consumed_mem_gb DESC;
