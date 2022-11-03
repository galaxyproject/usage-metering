-- Number of jobs per month, total and run as part of a workflow.

WITH wf_jobs AS (
    SELECT
        TO_CHAR(workflow_invocation_step.create_time, 'YYYY-MM') AS date,
        COUNT(DISTINCT job_id) AS num_wf_jobs
    FROM
        workflow_invocation_step
    WHERE
        create_time >= '2021-10-01'
        AND create_time < '2022-11-01'
    GROUP BY
        date
),
all_jobs AS (
    SELECT
        TO_CHAR(job.create_time, 'YYYY-MM') AS date,
        COUNT(DISTINCT job.id) AS total_num_jobs
    FROM
        job
    WHERE
        create_time >= '2021-10-01'
        AND create_time < '2022-11-01'
    GROUP BY
        date
)
SELECT
    all_jobs.date,
    all_jobs.total_num_jobs AS num_all_jobs,
    wf_jobs.num_wf_jobs AS num_wf_jobs,
    ROUND(
        CAST(wf_jobs.num_wf_jobs AS DECIMAL) / all_jobs.total_num_jobs * 100,
        1
    ) AS pct_wf_jobs
FROM
    all_jobs
    JOIN wf_jobs ON all_jobs.date = wf_jobs.date
ORDER BY
    date ASC;
