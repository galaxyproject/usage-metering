CREATE TABLE job (
    id integer NOT NULL,
    create_time timestamp without time zone DEFAULT now(),
    tool_id character varying(255),
    tool_version text DEFAULT '1.0.0'::text,
    user_id integer DEFAULT 0,
    destination_id character varying(255)
);

CREATE TABLE job_metric_numeric (
    job_id integer,
    metric_name character varying(255),
    metric_value numeric(26,7)
);
