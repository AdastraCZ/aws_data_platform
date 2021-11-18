create or replace procedure dwh_master.region_overview_map()
language plpgsql    
as $$
begin
--
    CALL dwh_adm.log_event('Start', 'postgres', null, null, 'dwh_master.region_overview_map', null);
    --
    TRUNCATE TABLE dwh_master.region_overview;

    INSERT INTO dwh_master.region_overview
        with process_dates as (
            select 
                to_date('01.01.' || extract(year from current_date) - generate_series, 'DD.MM.YYYY')  as process_date,
                extract(year from current_date) - generate_series as year
            from generate_series(0, 50)
        ),
        data as (
        select 
            lov.region_iso_2_code as region_id,
            lov.region_name as region_name,
            gdp.val as gdp_per_capita,
            pop.val as population_growth,
            inc.val as income_share_10,
            co.val as co2_emissions,
            years.year,
            years.process_date as valid_from_date_cet,
            to_date('31.12.' || years.year, 'DD.MM.YYYY') as valid_to_date_cet,
            CURRENT_TIMESTAMP AT TIME ZONE 'CET' as create_datetime_cet
        from dwh_landing.lov_wb_countries lov
        cross join process_dates years
        left outer join dwh_landing.wb_gdp_per_capita gdp
        on lov.country_iso_3_code = gdp.country_iso_3_code
        and years.process_date between gdp.valid_from_date_cet and gdp.valid_to_date_cet
        left outer join dwh_landing.wb_co2_emissions co
        on lov.country_iso_3_code = co.country_iso_3_code
        and years.process_date between co.valid_from_date_cet and co.valid_to_date_cet
        left outer join dwh_landing.wb_population_growth pop
        on lov.country_iso_3_code = pop.country_iso_3_code
        and years.process_date between pop.valid_from_date_cet and pop.valid_to_date_cet
        left outer join dwh_landing.wb_income_share_10 inc
        on lov.country_iso_3_code = inc.country_iso_3_code
        and years.process_date between inc.valid_from_date_cet and inc.valid_to_date_cet
        )
        select 
			region_id,
			region_name,
			avg(gdp_per_capita) as avg_gdp_per_capita,
			avg(population_growth) as avg_population_growth,
			avg(income_share_10) as avg_income_share_10,
			sum(co2_emissions) as sum_co2_emissions,
			year,
			valid_from_date_cet,
			valid_to_date_cet,
			create_datetime_cet
        from data 
        where (gdp_per_capita is not null
        or population_growth is not null
        or income_share_10 is not null
        or co2_emissions is not null)
        -- no aggregate region
        and region_id != 'NA'
		group by region_id, region_name, year, valid_from_date_cet, valid_to_date_cet, create_datetime_cet;
    --
    CALL dwh_adm.log_event('Finish', 'postgres', null, null, 'dwh_master.region_overview_map', null);
--
end;$$