create or replace procedure dwh_adm.drop_table(p_table varchar)
language plpgsql    
as $$
declare 
    sql text := 'DROP TABLE IF EXISTS ' || p_table;
begin
    execute sql;
end;$$