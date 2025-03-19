#!/bin/bash

# CloudShirt Application Setup Script
# This script installs and configures everything needed to run the CloudShirt application
# with an external SQL Server, RDS database and EFS file system

# Install dotnet-sdk-6.0
sudo yum update -y

yum -y install nfs-utils
mkdir /efs
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport fs-0b274588d48bfd579.efs.us-east-1.amazonaws.com:/ /efs
cd /efs
sudo chmod go+rw .
cd /

sudo yum install -y dotnet-sdk-6.0 git
export DOTNET_CLI_HOME=/root/.dotnet

# Install git
sudo yum install git -y
sudo git clone https://github.com/looking4ward/CloudShirt.git

# Update appsettings.json using defined variables
sudo sed -i "s/Server.*CatalogDb;/Server=${RDS_ENDPOINT},1433;User ID=${RDS_USERNAME};Password=${RDS_PASSWORD};Initial Catalog=Microsoft.eShopOnWeb.CatalogDb;/" CloudShirt/src/Web/appsettings.json
sudo sed -i "s/Server.*Identity;/Server=${RDS_ENDPOINT},1433;User ID=${RDS_USERNAME};Password=${RDS_PASSWORD};Initial Catalog=Microsoft.eShopOnWeb.Identity;/" CloudShirt/src/Web/appsettings.json
sudo sed -i "s/Server.*CatalogDb;/Server=${RDS_ENDPOINT},1433;User ID=${RDS_USERNAME};Password=${RDS_PASSWORD};Initial Catalog=Microsoft.eShopOnWeb.CatalogDb;/" CloudShirt/src/PublicApi/appsettings.json
sudo sed -i "s/Server.*Identity;/Server=${RDS_ENDPOINT},1433;User ID=${RDS_USERNAME};Password=${RDS_PASSWORD};Initial Catalog=Microsoft.eShopOnWeb.Identity;/" CloudShirt/src/PublicApi/appsettings.json

INSTANCE_PUBLIC_IP=$(wget -qO- http://checkip.amazonaws.com)
# run the application in folder Web port 80
cd CloudShirt/src/Web
sudo dotnet build
sudo dotnet run --urls "http://0.0.0.0:80/" >> /efs/$INSTANCE_PUBLIC_IP.web.log 2>&1 &
cd /

# Run the application in folder PublicApi port 5009
cd CloudShirt/src/PublicApi
sudo dotnet build
sudo dotnet run --urls "http://0.0.0.0:5099/"