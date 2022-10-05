-- Input and output datasets for tool jobs within a date range.

--   job_id  | dataset_id |   extension    | file_size_bytes |    param_name     |  type
-- ----------+------------+----------------+-----------------+-------------------+--------
--  46125645 |   86129031 | txt            |             615 | summary_file      | output
--  46125645 |   86128923 | fastqsanger.gz |       130663769 | input_1           | input
--  46125645 |   86129030 | bam            |       238543498 | output_alignments | output
--  46125645 |   72870066 | fasta          |          193421 | history_item      | input
--  46125645 |   86128932 | fastqsanger.gz |       133706258 | input_2           | input

WITH tool_job_ids AS (
    SELECT
        id AS job_id
    FROM
        job
    WHERE
        tool_id LIKE '%hisat2%'
        AND create_time >= '2021-10-01'
        AND create_time < '2022-10-01'
        AND state = 'ok'
),
hda_ids AS (
    SELECT
        job_to_input_dataset.job_id,
        job_to_input_dataset.dataset_id AS hda_id,
        job_to_input_dataset.name,
        'input' as type
    FROM
        job_to_input_dataset
        JOIN tool_job_ids ON tool_job_ids.job_id = job_to_input_dataset.job_id
    UNION
    SELECT
        job_to_output_dataset.job_id,
        job_to_output_dataset.dataset_id AS hda_id,
        job_to_output_dataset.name,
        'output' as type
    FROM
        job_to_output_dataset
        JOIN tool_job_ids ON tool_job_ids.job_id = job_to_output_dataset.job_id
),
dataset_ids AS (
    SELECT
        hda_ids.job_id,
        hda_ids.name as param_name,
        hda_ids.type,
        history_dataset_association.dataset_id,
        history_dataset_association.extension
    FROM
        history_dataset_association
        JOIN hda_ids ON history_dataset_association.id = hda_ids.hda_id
)
SELECT
    dataset_ids.job_id as job_id,
    id as dataset_id,
    dataset_ids.extension,
    COALESCE(dataset.total_size, -1) as file_size_bytes,
    dataset_ids.param_name as param_name,
    dataset_ids.type
FROM
    dataset
    JOIN dataset_ids ON dataset.id = dataset_ids.dataset_id
ORDER BY
    job_id
