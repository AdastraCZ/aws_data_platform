# GDELT Project 

GDELT project is an open source global database of society. It is publishing world's events per country describing:

- what type of event it is (use of military force, political events etc.)
- sides (actors)
- date when it happened
- location etc.

It is large, historical dataset going back to 1979.

https://www.gdeltproject.org/

## Downloading datasets

### AWS 

AWS publishes some open source datasets available here: https://registry.opendata.aws/

Gdelt dataset is available: https://registry.opendata.aws/gdelt/

I have copied publicly available AWS data to our internal bucket using the following AWS CLI command:

```
aws s3 cp s3://gdelt-open-data/events/ s3://adastracz-demo-datalake-raw/gdelt_project/events/ --recursive
```

### LOV data

I have downloaded 3 dataset describing GDELT project events dimensions 

- actors (sides)
- event types
- countries

These datasets are available on GitHub at:

https://github.com/robikus/discursus_core/tree/release/0.0.2/discursus_core/dw/data