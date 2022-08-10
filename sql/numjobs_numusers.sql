-- Count the number of jobs for a given tool along with the number of distinct
-- users that invoked those jobs.

SELECT
    tool_id,
    COUNT(DISTINCT id) AS num_jobs,
    COUNT(DISTINCT user_id) AS num_users
FROM
    job
GROUP BY
    tool_id
ORDER BY
    num_jobs DESC;
