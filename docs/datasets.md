# Available datasets

There are 5 datasets downloaded from an external API in Airflow that are being used in our Data Platform demo.

|  Dataset | Source | sample URL |
|---|---|---|
| GDP per capita, PPP (current international $)  | World Bank API  | https://api.worldbank.org/v2/country/all/indicator/NY.GDP.PCAP.PP.CD?date=2013&per_page=400&format=json |
| Income share held by highest 10%  | World Bank API  | https://api.worldbank.org/v2/country/all/indicator/SI.DST.10TH.10?date=2019&per_page=400&format=json |
| Population growth (annual %) | World Bank API  | https://api.worldbank.org/v2/country/all/indicator/SP.POP.GROW?date=2016&per_page=400&format=json |
| CO2 emissions (kiloton)  | World Bank API  | https://api.worldbank.org/v2/country/all/indicator/EN.ATM.CO2E.KT?date=2019&per_page=400&format=json |
| LOV countries overview  | World Bank API  | https://api.worldbank.org/v2/country?format=json&per_page=400&page=1 |

## Data Lake - query the data

You can query the data in the Data Lake with AWS Athena. Data can be found in 2 schemas:

- `data_lake_raw` - raw data as downloaded from APIs
- `data_lake_curated` - transformed and cleaned API data

Available tables:

**data_lake_raw**

```
select * from data_lake_raw.income_share_10
select * from data_lake_raw.co2_emissions
select * from data_lake_raw.population_growth
select * from data_lake_raw.gdp_per_capita
select * from data_lake_raw.lov_countries
```

**data_lake_curated**

```
select * from data_lake_curated.wb_income_share_10
select * from data_lake_curated.wb_co2_emissions
select * from data_lake_curated.wb_population_growth
select * from data_lake_curated.wb_gdp_per_capita
select * from data_lake_curated.lov_wb_countries
```

## DWH - query the data

To query the DWH data you need to install pgAdmin (or other IDE) and connect to Aurora database via VPN. 

Data in DWH can be found in 3 different schemas:

- `dwh_landing` - landing schema for Data Lake data
- `dwh_master` - main DWH schema (transformed data)
- `dwh_adm` - technical schema (logs)

**dwh_landing**

Tables available:

```
select * from dwh_landing.wb_income_share_10
select * from dwh_landing.wb_co2_emissions
select * from dwh_landing.wb_population_growth
select * from dwh_landing.wb_gdp_per_capita
select * from dwh_landing.lov_wb_countries
```

**dwh_master**

Main DWH schema. There 3 tables containing transformed and aggregated data.

```
select * from dwh_master.country_overview
select * from dwh_master.region_overview
select * from dwh_master.world_overview
```

**dwh_adm**

Technical schema. The only important table here is `logs`.

```
select * from dwh_adm.logs
```
