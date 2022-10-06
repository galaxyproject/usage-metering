To run these queries, ssh to `galaxy-db-02` and enclose each of the 3 queries in
the following command, selecting the appropriate file name. An easy way to
collapse the queries to a single line is to use VSCode's `<CMD + j>` keyboard
shortcut. Don't forget to update and match the tool id to what you're querying.

The queries typically run up to 60 minutes.

```
psql galaxy_main -c "COPY (<place query here>) TO STDOUT WITH (FORMAT CSV,HEADER)" > [jobs | metric_num | datasets].csv
```
