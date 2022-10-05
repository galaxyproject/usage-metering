-- Job metrics for a specific tool within a date range.

--   job_id  | plugin  |        metric_name        |        metric_value
-- ----------+---------+---------------------------+----------------------------
--  38055787 | cgroup  | cpuacct.usage             |      4424772692282.0000000
--  38055787 | cgroup  | memory.max_usage_in_bytes |         9098698752.0000000
--  38055787 | core    | galaxy_slots              |                  6.0000000
--  38055787 | core    | runtime_seconds           |                827.0000000
--  38055787 | cpuinfo | processor_count           |                 32.0000000

WITH job_resource_usage AS (
    SELECT
        DISTINCT job_id,
        plugin,
        metric_name,
        metric_value
    FROM
        job_metric_numeric
    WHERE
        metric_name = 'memory.max_usage_in_bytes'
        OR metric_name = 'cpuacct.usage'
        OR metric_name = 'processor_count'
        OR metric_name = 'galaxy_slots'
        OR metric_name = 'runtime_seconds'
)
SELECT
    id AS job_id,
    job_resource_usage.plugin,
    job_resource_usage.metric_name,
    job_resource_usage.metric_value
FROM
    job
    JOIN job_resource_usage ON job.id = job_resource_usage.job_id
WHERE
    tool_id LIKE '%hisat2%'
    AND create_time >= '2021-10-01'
    AND create_time < '2022-10-01'
    AND state = 'ok'
ORDER BY
    job_id
