CREATE TABLE IF NOT EXISTS dwh_master.country_overview
(
    country_id character varying(255),
    country_name character varying(255),
    country_capital character varying(255),
    region_name character varying(255),
    region_code character varying(255),
    income_level character varying(255),
    gdp_per_capita double precision,
    population_growth double precision,
    income_share_10 double precision,
    co2_emissions double precision,
    year integer,
    valid_from_date_cet date,
    valid_to_date_cet date,
    create_datetime_cet timestamp without time zone
)
TABLESPACE pg_default;

COMMENT ON COLUMN dwh_master.country_overview.country_id IS 'country ISO 3 code';
COMMENT ON COLUMN dwh_master.country_overview.country_capital IS 'Capital';
COMMENT ON COLUMN dwh_master.country_overview.region_name IS 'Region - World Bank definition';
COMMENT ON COLUMN dwh_master.country_overview.region_code IS 'Region code - World Bank definition';
COMMENT ON COLUMN dwh_master.country_overview.income_level IS 'Income level - World bank definition';
COMMENT ON COLUMN dwh_master.country_overview.gdp_per_capita IS 'GDP per capita, PPP (current international $)';
COMMENT ON COLUMN dwh_master.country_overview.population_growth IS 'Population growth (annual %)';
COMMENT ON COLUMN dwh_master.country_overview.income_share_10 IS 'Income share held by highest 10%';
COMMENT ON COLUMN dwh_master.country_overview.co2_emissions IS 'CO2 emissions (kiloton)';
COMMENT ON COLUMN dwh_master.country_overview.year IS 'Effective date - year';

ALTER TABLE IF EXISTS dwh_master.country_overview
    OWNER to adastra;