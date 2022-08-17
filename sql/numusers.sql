-- Number of users running a tool, grouped by month and by year.

SELECT
    TO_CHAR(create_time, 'YYYY-MM') AS date,
    tool_id,
    COUNT(DISTINCT user_id) AS num_users
FROM
    job
GROUP BY
    date,
    tool_id
ORDER BY
    date ASC,
    num_users DESC;
