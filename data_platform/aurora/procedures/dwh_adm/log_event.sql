create or replace procedure dwh_adm.log_event(p_log_event varchar, p_source_system varchar, p_dag_name varchar, p_dag_run_id varchar, p_mapping_name varchar, p_description varchar)
language plpgsql    
as $$
begin
    INSERT INTO dwh_adm.logs values (p_log_event, p_source_system, p_dag_name, p_dag_run_id, p_mapping_name, p_description, now() AT TIME ZONE 'CET');
end;$$