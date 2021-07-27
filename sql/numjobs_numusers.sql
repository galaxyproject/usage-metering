SELECT
    tool_id,
    count(DISTINCT id) AS num_jobs,
    count(DISTINCT user_id) AS num_users
FROM
    job
GROUP BY
    tool_id
ORDER BY
    num_jobs DESC;
