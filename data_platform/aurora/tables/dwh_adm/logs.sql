CREATE TABLE IF NOT EXISTS dwh_adm.logs
(
    log_event character varying(255),
    source_system character varying(255),
    dag_name character varying(255),
    p_dag_run_id character varying(255),
    mapping_name character varying(255),
    description character varying(255) ,
    create_datetime_cet timestamp without time zone
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS dwh_adm.logs
    OWNER to adastra;