# Adastra - AWS Data Platform 

Welcome to Adastra AWS Data Platfrom. In this repo you can find fully functional demo of an AWS Data Platform (Data Lake + DWH). 

**How to make it work**

If you have an AWS account, you can log in and follow the `Setting up Data Platform` instructions below. Just **beware** that not all the services used in this demo provide a free tier plan - i.e. **spinning up this demo can cost you money**.

**Purpose**

This project can be used as a
- reference AWS Data Platform architecture
- sandbox people can play around with and learn AWS or explore new AWS services

**Tech stack**
You can check out the current tech stack here [Adastra AWS Data Platform overview](./docs/dp_overview.md). But this is an open project and everybody contributing to this project and adding new AWS (and other) technologies is more than welcome.

**Contributors:** 
- Robert Polakovic

## Overall architecture and data flow

- [Adastra AWS Data Platform overview](./docs/dp_overview.md)
- [Available datasets](./docs/datasets.md)
- [Airflow - data flow](./docs/airflow_process_flow.md)
- [Aurora - data flow](./docs/aurora_process_flow.md)

## Setting up Data Platform

- [Setting up AWS Data Platform](./docs/init_setup.md)
- [Airflow - initial setup](./docs/airflow_overview.md)
- [Integrating AWS Aurora with AWS Glue and S3](./docs/aurora_glue_connect.md)
- [VPN setup and logging in to Aurora](./docs/aurora_vpn.md)

## CI/CD and Git
- [CI/CD pipeline & Git repo](./docs/cicd.md)

## Todo
- [TODO list - what we want to implement next?](./docs/todo.md)




