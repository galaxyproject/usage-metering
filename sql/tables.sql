CREATE TABLE job (
    id integer NOT NULL,
    create_time timestamp without time zone DEFAULT now(),
    tool_id character varying(255),
    state character varying(64),
    command_line text,
    tool_version text DEFAULT '1.0.0'::text,
    user_id integer,
    imported boolean,
    destination_id character varying(255),
    galaxy_version character varying(64)
);

CREATE TABLE job_metric_numeric (
    job_id integer,
    metric_name character varying(255),
    metric_value numeric(26,7)
);
