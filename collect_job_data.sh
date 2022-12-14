#!/bin/bash

# This script fetches data from a Galaxy database and archives it in S3 bucket.

# The data is from the previous month and includes two tables: job and
# job_metric_numeric. The data from both tables is uploaded to an S3 bucket as
# two tar.gz files. On Main, the script runs about 30 minutes.

# To use, edit the hard coded paths and invoke via ./collect_job_data.sh

START_TIME=$(date +%s)

BUCKET_NAME=usegalaxy-historic-data

cd /home/afgane/jobs_history

PREVIOUS_MONTH=`date --date="$(date +%Y-%m-15) - 1 month" "+%Y-%m"`
PREVIOUS_MONTH_START=`date --date="$(date +%Y-%m-01) - 1 month" "+%Y-%m-%d"`
PREVIOUS_MONTH_END=`date --date="$(date +%Y-%m-01) - 1 day" "+%Y-%m-%d"`

printf '%s -- Creating SQL queries.\n' "$(date)";
# Create job query
echo "COPY (
SELECT
  id, create_time, tool_id, tool_version, user_id, destination_id
FROM
  job
WHERE
  create_time >= '$PREVIOUS_MONTH_START'
  AND create_time < '$PREVIOUS_MONTH_END') TO STDOUT;" > job_query.sql

# Create metrics query
echo "COPY (
SELECT
    job.id,
    job.destination_id,
    job_metric_numeric.metric_name,
    job_metric_numeric.metric_value
FROM
    job
INNER JOIN job_metric_numeric
    ON job_metric_numeric.job_id = job.id
WHERE
    job.create_time >= '$PREVIOUS_MONTH_START' AND
    job.create_time < '$PREVIOUS_MONTH_END' AND
    (job_metric_numeric.metric_name = 'galaxy_slots' OR
     job_metric_numeric.metric_name = 'memory.max_usage_in_bytes' OR
     job_metric_numeric.metric_name = 'galaxy_memory_mb' OR
     job_metric_numeric.metric_name = 'galaxy_slots' OR
     job_metric_numeric.metric_name = 'cpuacct.usage' OR
     job_metric_numeric.metric_name = 'runtime_seconds')) TO STDOUT;" > metrics_query.sql

printf '%s -- Fetching job table data for %s...\n' "$(date)" "$PREVIOUS_MONTH";
psql galaxy_main < job_query.sql > job_table.txt;

printf '%s -- Got the job table data; archiving...\n' "$(date)";
tar -czf job_table.tar.gz job_table.txt;

printf '%s -- Fetching job metrics table data for %s...\n' "$(date)" "$PREVIOUS_MONTH";
psql galaxy_main < metrics_query.sql > metrics_table.txt;

printf '%s -- Got the job metrics table data; archiving...\n' "$(date)";
tar -czf metrics_table.tar.gz metrics_table.txt

printf '%s -- Uploading %s data to S3 bucket usegalaxy-historic-data...\n' "$(date)" "$PREVIOUS_MONTH";
/home/afgane/aws_cli/bin/aws --profile cost-modeling s3 cp ./job_table.tar.gz s3://$BUCKET_NAME/$PREVIOUS_MONTH-job-table.tar.gz --acl public-read
/home/afgane/aws_cli/bin/aws --profile cost-modeling s3 cp ./metrics_table.tar.gz s3://$BUCKET_NAME/$PREVIOUS_MONTH-metrics-table.tar.gz --acl public-read

printf '%s -- Done.\n' "$(date)";
printf "Runtime: $(date -ud "@$(($(date +%s) - $START_TIME))" +%T) (HH:MM:SS)";
