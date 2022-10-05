-- Fetch metrics for jobs for a specific tool.

-- Edit the tool id at the bottom to query for its metrics.
-- Edit dates and hda ids to query a different date range (see more below).
--
-- The following fields are returned, with metric_value being in the same units
-- as what Galaxy tracks (eg, nanoseconds for cpuacct.usage). file_size_bytes
-- includes all the input and output files.
--
--   job_id  |                           tool_id                            | tool_version  |        metric_name        |      metric_value      | file_size_bytes
-- ----------+--------------------------------------------------------------+---------------+---------------------------+------------------------+-----------------
--  37516112 | toolshed.g2.bx.psu.edu/repos/iuc/hisat2/hisat2/2.2.1+galaxy0 | 2.2.1+galaxy0 | cpuacct.usage             | 24879181800984.0000000 |      7343723441
--  37516112 | toolshed.g2.bx.psu.edu/repos/iuc/hisat2/hisat2/2.2.1+galaxy0 | 2.2.1+galaxy0 | galaxy_slots              |              6.0000000 |      7343723441
--  37516112 | toolshed.g2.bx.psu.edu/repos/iuc/hisat2/hisat2/2.2.1+galaxy0 | 2.2.1+galaxy0 | memory.max_usage_in_bytes |    14683353088.0000000 |      7343723441
--  37516112 | toolshed.g2.bx.psu.edu/repos/iuc/hisat2/hisat2/2.2.1+galaxy0 | 2.2.1+galaxy0 | processor_count           |             32.0000000 |      7343723441
--  37516112 | toolshed.g2.bx.psu.edu/repos/iuc/hisat2/hisat2/2.2.1+galaxy0 | 2.2.1+galaxy0 | runtime_seconds           |           5107.0000000 |      7343723441
--  37517121 | toolshed.g2.bx.psu.edu/repos/iuc/hisat2/hisat2/2.2.1+galaxy0 | 2.2.1+galaxy0 | cpuacct.usage             |   719844195118.0000000 |       321428192
--  37517121 | toolshed.g2.bx.psu.edu/repos/iuc/hisat2/hisat2/2.2.1+galaxy0 | 2.2.1+galaxy0 | galaxy_slots              |              6.0000000 |       321428192
--  37517121 | toolshed.g2.bx.psu.edu/repos/iuc/hisat2/hisat2/2.2.1+galaxy0 | 2.2.1+galaxy0 | memory.max_usage_in_bytes |     9825124352.0000000 |       321428192
--
--
-- To update the dataset_id for a different date range, the fastest method is to
-- just repeatedly run the following query manually until you zero in on the
-- desired hda id. This is because create_time on the
-- history_dataset_association table is not indexed and filtering by range is
-- super slow.
--
-- select create_time, id from history_dataset_association where id=<take a guess and then adjust>;

WITH job_resource_usage AS (
    SELECT
        DISTINCT job_id,
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
),
-- Create a list of all input and output hda ids for a job
hda_ids AS (
    SELECT
        job_id,
        dataset_id AS hda_id
    FROM
        job_to_input_dataset
    WHERE
        dataset_id >= 76060100  -- First hda id on September 1, 2021
        AND dataset_id <= 101939744  -- Last hda id on August 31, 2022
    UNION
    SELECT
        job_id,
        dataset_id AS hda_id
    FROM
        job_to_output_dataset
    WHERE
        dataset_id >= 76060100  -- First hda id on September 1, 2021
        AND dataset_id <= 101939744  -- Last hda id on August 31, 2022
),
-- Translate hda ids to dataset ids
dataset_ids AS (
    SELECT
        hda_ids.job_id,
        history_dataset_association.dataset_id
    FROM
        history_dataset_association
        JOIN hda_ids ON history_dataset_association.id = hda_ids.hda_id
    WHERE
        history_dataset_association.id >= 76060100  -- First hda id on September 1, 2021
        AND history_dataset_association.id <= 101939744  -- Last hda id on Aug 31, 2022
),
-- Query dataset size for all the job inputs and outputs
dataset_sizes AS (
    SELECT
        dataset_ids.job_id as job_id,
        COALESCE(dataset.total_size, 0) as file_size_bytes
    FROM
        dataset
        JOIN dataset_ids ON dataset.id = dataset_ids.dataset_id
)
SELECT
    id AS job_id,
    tool_id,
    tool_version,
    job_resource_usage.metric_name,
    job_resource_usage.metric_value,
    dataset_sizes.file_size_bytes
FROM
    job
    JOIN job_resource_usage ON job.id = job_resource_usage.job_id
    JOIN dataset_sizes ON job.id = dataset_sizes.job_id
WHERE
    tool_id LIKE '%hisat2%'
    AND create_time >= '2021-09-01'
    AND create_time < '2022-09-01'
    AND state = 'ok'
