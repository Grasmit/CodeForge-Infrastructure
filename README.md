# **Deploying a Node.js App to Azure using Terraform and Docker**

## **Introduction**

This repository provides infrastructure as code (IaC) using Terraform to deploy a simple Node.js app on an Azure Virtual Machine (VM). Docker is used for containerization, making it easy to deploy and manage the application. The instructions below will guide you through the process of setting up and deploying the infrastructure.

## **Prerequisites**

Before you begin, ensure you have the following tools installed:

1. Terraform - [Install Terraform](https://developer.hashicorp.com/terraform/install)
2. Azure CLI - [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
3. Docker - [Install Docker](https://docs.docker.com/engine/install/)

## **Steps to Deploy**

1. **Azure Login:**
    - Open your terminal and run the following command to log in to your Azure account:
        
        ```bash
        az login
        ```
        
2. **Set Azure Subscription:**
    - If you have multiple subscriptions, set the desired subscription using the subscription name or ID:
        
        ```bash
        az account set --subscription <name or id>
        ```
        
3. **Initialize Terraform:**
    - Navigate to the root directory of the Terraform configuration and run:
        
        ```bash
        terraform init
        ```
        
4. **Terraform Plan:**
    - Generate and review an execution plan for the infrastructure changes:
        
        ```bash
        terraform plan
        ```
        
5. **Terraform Apply:**
    - Apply the Terraform configuration to create the Azure resources:
        
        ```bash
        terraform apply
        ```
        
6. **Deploy Dockerized Node.js App:**
    - Once the infrastructure is created, deploy the Node.js app using Docker:
7. **Access the App:**
    - Open a web browser and navigate to **`http://<VM-Public-IP>:80`** to view the running Node.js app.
8. **Terraform Destroy (Optional):**
    - When done, you can destroy the infrastructure to avoid incurring charges:
        
        ```bash
        terraform destroy
        ```
        

### **Demo**

Check out the Video for a walkthrough of the deployment process.
Watch a demonstration of the deployment process:

[![Watch the demo](https://github.com/Grasmit/infrastructure-as-a-code/master/IaC_demo.mp4)](https://github.com/Grasmit/infrastructure-as-a-code/master/IaC_demo.mp4)

## **Notes**

- Ensure that the Azure resource group, virtual network, and other resources are appropriately configured in the Terraform files.
- Customize the Node.js app in the 'app' directory based on your requirements.
