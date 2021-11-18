# Setting up AWS Data Platform for the first time

You can create your own instance of Data Platform in your AWS account following the steps below.

## Setting up Data Platform

1. Login to AWS Management Console (https://eu-central-1.console.aws.amazon.com/console/home?nc2=h_ct&src=header-signin&region=eu-central-1)

2. Go to CloudFormation service and create a new stack `iam` using this [template](https://github.com/robikus/adastra_aws_demo/blob/main/data_platform/infrastructure/env/cloudformation/iam.yml)

3. After creating a stack go to `AWS->IAM->Users->DataPlatformAdmin->Security credentials` and generate a new `Access key` (get an AWS access key and secret access key) 

4. Log in to your **GitHub** account, go to `Adastra AWS Data Platform repo -> Settings -> Secrets` and create 2 new secrets (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) using the access and secret key from the previous step:

5. sign in to your **Terraform Cloud** account (https://app.terraform.io/session). There are 3 workspaces that need to be created for 'Adastra AWS Data Platform' 

- adastra-dp-airflow
- adastra-dp-data-lake
- adastra-dp-infrastructure

6. For each `workspace` go to `Variables` and create 2 new environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` using the AWS `Access key` obtained earlier.

7. Run a GitHub CI workflow (started automatically with every new commit). Running this workflow will deploy all the `Terraform` code.

8. Now you can manually create the rest of the `AWS CloudFormation` stacks:

- `iam` : https://github.com/robikus/adastra_aws_demo/blob/main/data_platform/infrastructure/env/cloudformation/network.yml
- `network` : https://github.com/robikus/adastra_aws_demo/blob/main/data_platform/infrastructure/env/cloudformation/network.yml
- `aurora` : https://github.com/robikus/adastra_aws_demo/blob/main/data_platform/infrastructure/aurora/cloudformation/aurora.yml
- `airflow` : https://github.com/robikus/adastra_aws_demo/blob/main/data_platform/infrastructure/airflow/cloudformation/mwaa.yml

9. Now you should be all set up. All you need to do now is to set the new Aurora connections and Airflow variables (details in the Aurora and Airflow docs).

Lets summarize the steps above:

```
1. create iam CloudFormation stack
2. create security credentials for the newly created user (DataPlatformAdmin)
3. Use the credentials for GitHub and Terraform Cloud integration
4. create manually the rest of the CloudFormation stacks (network, aurora, airflow)
5. set up new Aurora connections and Airflow variables 
```
