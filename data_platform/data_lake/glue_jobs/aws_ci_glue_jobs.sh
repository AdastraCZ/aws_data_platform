#!/bin/bash
set -e

aws s3 rm s3://adastracz-demo-glue-jobs/ --recursive

aws s3 sync ./data_platform/data_lake/glue_jobs/scripts/curated/ s3://adastracz-demo-glue-jobs/curated/

aws s3 sync ./data_platform/data_lake/glue_jobs/scripts/export/ s3://adastracz-demo-glue-jobs/export/

