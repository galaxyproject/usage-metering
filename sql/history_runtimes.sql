-- Calculate runtime of each job in a history, also reporting allocated amount of memory and CPUs.

SELECT
    j.history_id,
    j.create_time,
    j.tool_id,
    job_memory_gb,
    cpu_count,
    cpu_count * runtime_seconds as total_runtime_sec
FROM
    (
        SELECT
            id,
            user_id,
            history_id,
            create_time,
            tool_id,
            state,
            COALESCE(
                (
                    SELECT
                        metric_value
                    FROM
                        job_metric_numeric
                    WHERE
                        metric_name = 'galaxy_memory_mb'
                        AND job_metric_numeric.job_id = job.id
                ),
                0
            ) / 1000.00 AS job_memory_gb,
            COALESCE(
                (
                    SELECT
                        metric_value
                    FROM
                        job_metric_numeric
                    WHERE
                        metric_name = 'galaxy_slots'
                        AND job_metric_numeric.job_id = job.id
                ),
                1
            ) AS cpu_count,
            COALESCE(
                (
                    SELECT
                        metric_value
                    FROM
                        job_metric_numeric
                    WHERE
                        metric_name = 'runtime_seconds'
                        AND job_metric_numeric.job_id = job.id
                ),
                1
            ) AS runtime_seconds
        FROM
            job
        WHERE
            history_id = 20
    ) AS j;
