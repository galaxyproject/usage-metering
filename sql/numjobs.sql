-- Number of jobs per tool per month.

SELECT
    TO_CHAR(job.create_time, 'YYYY-MM') AS date,
    tool_id,
    COUNT(DISTINCT id) AS num_jobs
FROM
    job
WHERE
    create_time >= '2021-10-01'
    AND create_time < '2022-11-01'
GROUP BY
    tool_id,
    date
ORDER BY
    date ASC,
    num_jobs DESC;
