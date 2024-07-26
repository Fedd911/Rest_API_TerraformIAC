# Terraform_RestAPI_IAC
## Description

This project features Terraform code that deploys a REST API, along with a DynamoDB table and a Lambda function.

The implementation follows point 12 from the [Cloud Resume Challenge](https://cloudresumechallenge.dev/docs/the-challenge/aws/), which emphasizes the use of IaC. 

Instead of manually configuring API resources through the AWS console, this project utilizes Terraform to define and manage the infrastructure.

**All hail Terraform**

## Functionality

The purpose of the API and the Lambda function is to track the visitor count of my web resume project: [feddie.online](https://www.feddie.online/)

Each time the page is loaded, a GET request is sent to the API, which triggers the Lambda function. The Lambda code increments the visitor count by 1 in the DynamoDB table.

## Architecture Diagram
![Rest_API_Diagram](https://github.com/Fedd911/Rest_API_TerraformIAC/blob/main/REST_API.drawio.png)
