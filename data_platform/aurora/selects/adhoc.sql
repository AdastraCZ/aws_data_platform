-------------
-------- logs
select *
from dwh_adm.logs
order by create_datetime_cet desc;

-------------
-- Czech Rep. overview
select *
from dwh_master.country_overview
where country_id = 'CZE'
order by valid_to_date_cet desc;

-------------
-- Europe's data
select *
from dwh_master.region_overview
where region_id = 'Z7'
order by year desc;

-------------
-- comparing Europe and "East Asia & Pacific"
with europe_data as (
	select *
	from dwh_master.region_overview
	where region_id = 'Z7'
),
east_asia_data as (
	select *
	from dwh_master.region_overview
	where region_id = 'Z4'
)
select 
e.year,
e.avg_gdp_per_capita as europe_avg_gdp_per_capita,
a.avg_gdp_per_capita as e_asia_avg_gdp_per_capita,
e.avg_population_growth as europe_avg_population_growth,
a.avg_population_growth as e_asia_avg_population_growth,
e.avg_income_share_10 as europe_avg_income_share_10,
a.avg_income_share_10 as e_asia_avg_income_share_10,
e.sum_co2_emissions as europe_sum_co2_emissions,
a.sum_co2_emissions as e_asia_sum_co2_emissions,
e.valid_from_date_cet,
e.valid_to_date_cet,
e.create_datetime_cet
from europe_data e
left outer join east_asia_data a
on e.year = a.year
order by year desc;

-------------
-- world's data
select *
from dwh_master.world_overview
order by year desc;

-------------
-- list of countries, regions
select distinct country_name, region_name, region_code
from dwh_master.country_overview
order by region_name


