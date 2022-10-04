-- Fetch metrics for jobs for a specific tool. Edit the tool id to query for it.
--
-- The following fields are returned for a job, including sizes for all input and output files:
--
--   job_id  |                              tool_id                               | tool_version  | job_state |        metric_name        |    metric_value     | file_size_bytes
-- ----------+--------------------------------------------------------------------+---------------+-----------+---------------------------+---------------------+-----------------
--  46126790 | toolshed.g2.bx.psu.edu/repos/devteam/bowtie2/bowtie2/2.4.2+galaxy0 | 2.4.2+galaxy0 | error     | cpuacct.usage             | 21396595944.0000000 |              84
--  46126790 | toolshed.g2.bx.psu.edu/repos/devteam/bowtie2/bowtie2/2.4.2+galaxy0 | 2.4.2+galaxy0 | error     | cpuacct.usage             | 21396595944.0000000 |         3997264
--  46126790 | toolshed.g2.bx.psu.edu/repos/devteam/bowtie2/bowtie2/2.4.2+galaxy0 | 2.4.2+galaxy0 | error     | galaxy_slots              |           6.0000000 |              84
--  46126790 | toolshed.g2.bx.psu.edu/repos/devteam/bowtie2/bowtie2/2.4.2+galaxy0 | 2.4.2+galaxy0 | error     | galaxy_slots              |           6.0000000 |         3997264
--  46126790 | toolshed.g2.bx.psu.edu/repos/devteam/bowtie2/bowtie2/2.4.2+galaxy0 | 2.4.2+galaxy0 | error     | memory.max_usage_in_bytes |  6625558528.0000000 |              84
--  46126790 | toolshed.g2.bx.psu.edu/repos/devteam/bowtie2/bowtie2/2.4.2+galaxy0 | 2.4.2+galaxy0 | error     | memory.max_usage_in_bytes |  6625558528.0000000 |         3997264
--  46126790 | toolshed.g2.bx.psu.edu/repos/devteam/bowtie2/bowtie2/2.4.2+galaxy0 | 2.4.2+galaxy0 | error     | processor_count           |          32.0000000 |              84
--  46126790 | toolshed.g2.bx.psu.edu/repos/devteam/bowtie2/bowtie2/2.4.2+galaxy0 | 2.4.2+galaxy0 | error     | processor_count           |          32.0000000 |         3997264
--  46126790 | toolshed.g2.bx.psu.edu/repos/devteam/bowtie2/bowtie2/2.4.2+galaxy0 | 2.4.2+galaxy0 | error     | runtime_seconds           |          35.0000000 |              84
--  46126790 | toolshed.g2.bx.psu.edu/repos/devteam/bowtie2/bowtie2/2.4.2+galaxy0 | 2.4.2+galaxy0 | error     | runtime_seconds           |          35.0000000 |         3997264

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
    state AS job_state,
    job_resource_usage.metric_name,
    job_resource_usage.metric_value,
    dataset_sizes.file_size_bytes
FROM
    job
    JOIN job_resource_usage ON job.id = job_resource_usage.job_id
    JOIN dataset_sizes ON job.id = dataset_sizes.job_id
WHERE
    tool_id LIKE '%bowtie2%'
    AND create_time >= '2021-09-01'
    AND create_time < '2022-09-01'
