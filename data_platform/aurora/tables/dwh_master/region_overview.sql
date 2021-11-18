CREATE TABLE IF NOT EXISTS dwh_master.region_overview
(
	region_id character varying(255),
    region_name character varying(255),
    avg_gdp_per_capita double precision,
    avg_population_growth double precision,
    avg_income_share_10 double precision,
    sum_co2_emissions double precision,
    year integer,
    valid_from_date_cet date,
    valid_to_date_cet date,
    create_datetime_cet timestamp without time zone
)
TABLESPACE pg_default;

COMMENT ON COLUMN dwh_master.region_overview.region_name IS 'Region - World Bank definition';
COMMENT ON COLUMN dwh_master.region_overview.region_id IS 'Region code - World Bank definition';
COMMENT ON COLUMN dwh_master.region_overview.avg_gdp_per_capita IS 'Average GDP per capita, PPP (current international $)';
COMMENT ON COLUMN dwh_master.region_overview.avg_population_growth IS 'Average population growth (annual %)';
COMMENT ON COLUMN dwh_master.region_overview.avg_income_share_10 IS 'Average income share held by highest 10%';
COMMENT ON COLUMN dwh_master.region_overview.sum_co2_emissions IS 'Sum CO2 emissions (kiloton)';
COMMENT ON COLUMN dwh_master.region_overview.year IS 'Effective date - year';

ALTER TABLE IF EXISTS dwh_master.region_overview
    OWNER to adastra;