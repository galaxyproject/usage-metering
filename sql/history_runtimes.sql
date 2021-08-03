-- Calculate runtime of each job in a history, reporting tool id, real runtime,
-- system runtime, allocated amount of memory, and number of CPUs.
SELECT
    j.history_id,
    j.create_time,
    j.tool_id,
    ROUND(job_memory_gb, 1) AS job_memory_gb,
    cpu_count :: int,
    (cpu_count * runtime_seconds) :: int AS system_runtime_sec,
    runtime_seconds :: int AS real_runtime_sec
FROM
    (
        SELECT
            id,
            user_id,
            history_id,
            create_time,
            tool_id,
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
            job.id IN (
                SELECT
                    job_id
                FROM
                    dataset
                    INNER JOIN history_dataset_association ON history_dataset_association.dataset_id = dataset.id
                WHERE
                    history_dataset_association.history_id = 20
                    AND history_dataset_association.deleted = false
            )
    ) AS j
ORDER BY
    j.create_time DESC;
