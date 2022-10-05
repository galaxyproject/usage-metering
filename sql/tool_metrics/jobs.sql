-- Jobs for a given tool within a date range.

--   job_id  |                           tool_id                            | tool_version  | state |        create_time
-- ----------+--------------------------------------------------------------+---------------+-------+----------------------------
--  46125645 | toolshed.g2.bx.psu.edu/repos/iuc/hisat2/hisat2/2.2.1+galaxy0 | 2.2.1+galaxy0 | ok    | 2022-10-01 00:22:53.578366
--  46127227 | toolshed.g2.bx.psu.edu/repos/iuc/hisat2/hisat2/2.2.1+galaxy0 | 2.2.1+galaxy0 | ok    | 2022-10-01 02:59:37.121108

SELECT
    id AS job_id,
    tool_id,
    tool_version,
    state,
    create_time
FROM
    job
WHERE
    tool_id LIKE '%hisat2%'
    AND create_time >= '2021-10-01'
    AND create_time < '2022-10-01'
    AND state = 'ok'
ORDER BY
    job_id
