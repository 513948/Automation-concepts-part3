#!/bin/bash
# CloudShirt Application Setup Script
# This script installs and configures everything needed to run the CloudShirt application
# with an external SQL Server RDS database

# Variables
RDS_ENDPOINT="cloudshirt-db-instance.calfb8ypi1lz.us-east-1.rds.amazonaws.com"
RDS_USERNAME="admin"
RDS_PASSWORD="Welkom10!"

# Install dotnet-sdk-6.0
sudo yum update -y

sudo yum install -y dotnet-sdk-6.0 git
export DOTNET_CLI_HOME=/root/.dotnet

# Install git
sudo yum install git -y
sudo git clone https://github.com/looking4ward/CloudShirt.git

# Update appsettings.json using defined variables
sudo sed -i "s/Server.*CatalogDb;/Server=$RDS_ENDPOINT,1433;User ID=$RDS_USERNAME;Password=$RDS_PASSWORD;Initial Catalog=Microsoft.eShopOnWeb.CatalogDb;/" CloudShirt/src/Web/appsettings.json
sudo sed -i "s/Server.*Identity;/Server=$RDS_ENDPOINT,1433;User ID=$RDS_USERNAME;Password=$RDS_PASSWORD;Initial Catalog=Microsoft.eShopOnWeb.Identity;/" CloudShirt/src/Web/appsettings.json
sudo sed -i "s/Server.*CatalogDb;/Server=$RDS_ENDPOINT,1433;User ID=$RDS_USERNAME;Password=$RDS_PASSWORD;Initial Catalog=Microsoft.eShopOnWeb.CatalogDb;/" CloudShirt/src/PublicApi/appsettings.json
sudo sed -i "s/Server.*Identity;/Server=$RDS_ENDPOINT,1433;User ID=$RDS_USERNAME;Password=$RDS_PASSWORD;Initial Catalog=Microsoft.eShopOnWeb.Identity;/" CloudShirt/src/PublicApi/appsettings.json

# run the application in folder Web port 80
cd CloudShirt/src/Web
sudo dotnet build
sudo nohup dotnet run --urls "http://0.0.0.0:80/" &
cd /

# Run the application in folder PublicApi port 5009
cd CloudShirt/src/PublicApi
sudo dotnet build
sudo nohup dotnet run --urls "http://0.0.0.0:5009/" &