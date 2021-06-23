Scripts and queries for inspecting Galaxy usage data.

# Environment and data setup
Before getting started, we'll get a hold of a subset of Galaxy data so it is
easier and faster to work with. This setup needs to be done once for a given set
of data. Once the data is available, we can start querying it.
## Extracting reduced data from a Galaxy database
Put the following `Job` query in a file called `job_query.sql`,
adjusting desired dates:
```
copy (
SELECT
  id, create_time, tool_id, state, command_line, tool_version, user_id, imported, destination_id, galaxy_version
FROM
  job
WHERE
  create_time >= '2021-05-01'
  AND create_time < '2021-06-01') TO STDOUT;
```

Run the query from the command shell:
```
psql < job_query.sql > job_table.txt
```

Next, put the following `Metrics` query in a file called `metrics_query.sql`,
matching the dates to the ones used in the job query above:
```
select
    job.id,
    job_metric_numeric.metric_name,
    job_metric_numeric.metric_value
from
    job
INNER JOIN job_metric_numeric
    ON job_metric_numeric.job_id = job.id
WHERE
    job.create_time >= '2021-05-01' AND
    job.create_time < '2021-06-01' AND
    (job_metric_numeric.metric_name = 'galaxy_slots' OR
     job_metric_numeric.metric_name = 'galaxy_slots' OR;
```

Run the query from the command shell:
```
psql < metrics_query.sql > metrics_table.txt
```

## Importing data into a local database
Once we have the data, we can import it into a local database for easier querying.
To get started, let's start a Postgres server using a Docker container, mapping
a volume to a host path.

```
docker run -d --name main-data-postgres -e POSTGRES_PASSWORD=changeThis -v ~/psql-main-data/:/var/lib/postgresql/data -p 5432:5432 postgres
```

Place the extracted files (`job_table.txt`, `metrics_table.txt`, and
`scheamafile`) into `~/psql-main-data/` so it's available within the PostgreSQL
container.

Exec into the container and create a database
```
docker exec -it main-data-postgres bash
cd /var/lib/postgresql/data/
```

Next, we'll create the necessary tables. The structure for the tables is in the
file in this repo called `tables.sql`, which should be placed alongside the
above data files.
```
createdb -U postgres -O postgres galaxy
psql -U postgres galaxy < tables.sql
```

Lastly, we import the data. Note that this process will take a few minutes.
```
psql -U postgres -c "\copy job from 'jobs_data.txt';" galaxy
psql -U postgres -c "\copy job_metric_numeric from 'metrics_data.txt';" galaxy
```
