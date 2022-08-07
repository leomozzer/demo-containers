# demo-containers

# Instructions
## Without docker-compose


docker run --name container-test ubuntu:latest /bin/echo 'Hello world'
 

STEPS:

ENTRAR NO TERMINAL LINUX
DB
>> Criar a imagem do banco
docker build -t mysql-image -f api/db/Dockerfile .
docker image ls

>> Subir o container do banco
docker run -d --rm --name mysql-container mysql-image
docker ps
docker run -d -v "$(pwd)/api/db/data:/var/lib/mysql" --rm --name mysql-container mysql-image

>> Conectar em modo iterativo (mostrar banco novo zerado)
docker exec -it mysql-container /bin/bash

>> Conectar cliente MySQL
mysql -uroot -pskaylink
>
show databases;

>> Importar os dados (abrir o script e falar sobre)
docker exec -i mysql-container mysql -uroot -pskaylink < api/db/script.sql

>> Conectar cliente MySQL (mostrar de novo agora com dados)
mysql -uroot -pskaylink
>
use skaylinkbr;
show tables;
select * from people;
-----------------------------------------------------------
ENTRAR NO TERMINAL WINDOWS
API
entrar no dir raiz
npm init
responder questoes
npm install
-----------------------------------------------------------

>> Mostrar o api/src/index.js
//Pegar o ip do banco
//docker inspect mysql-container

>> Criar a imagem do API server
docker build -t node-image -f api/Dockerfile .

>> Subir o container do API server
docker run -d -v $(pwd)/api:/home/node/app -p 9001:9001 --link mysql-container --rm --name node-container node-image
docker run -d -v $(pwd)/api:/home/node/app --link mysql-container --rm --name node-container node-image


>> Mostrar o website/index.php
docker build -t php-image -f website/Dockerfile .
docker run -d -v $(pwd)/website:/var/www/html -p 8888:80 --link node-container --rm --name php-container php-image


-----------------------------------------------------------


volume do banco
-v $(pwd)/api/db/data/var/lib/mysql

## With docker-compose

```
docker-compose up
...
docker-compose down
```
-----------------------------------------------------------
## Terraform

### Backend
* Create a new file called `variables.tfvars` in the terraform/backend folder
* Add the values below in the new file
```
#Account
subscription_id = ""
client_id       = ""
client_secret   = ""
tenant_id       = ""

#App
environment = "dev"
app_name    = "demo-containers"
```
* Use the commands below:
```
terraform init
terraform plan -var-file="variables.tfvars" -out=main.plan
terraform apply -auto-approve main.plan
```

## Docker Compose and Azure Manually
* [Deploy a multi-container group using Docker Compose](https://docs.microsoft.com/en-us/azure/container-instances/tutorial-docker-compose)
* Use the terraform/backend to create the Azure Container Registry (ACR)
* Get the credentials of the ACR
* Use the command `docker login <acrName>.azurecr.io` and provide the username and password
* az acr login --name <acrName>
### mysql
* docker-compose up --build -d
* docker-compose down
* docker-compose push
* Create a container instance to MySql
    * Use the port 3306
* Open the Container instance of the mysql
* connect to it and run the command in the mysql
### api
* Get the ip address in of the ACI mysql
* Add in the api connect mysql
* Create a container instance to api
    * Use the port 9001
* docker-compose up --build -d
* docker-compose down
* docker-compose push

* https://docs.microsoft.com/pt-br/azure/app-service/tutorial-multi-container-app

## Docker Compose and Azure Pipeline

### Configuration
* Create a new service connection with the `Azure Resource Manager` in the subscription level
* Access it and create a new client secret (save the info)
* Access the subscription where the service connection has access
* In the `Access control` attach the following permissions with the recently created service connection
```
AcrImageSigner
AcrPull
AcrPush
Contributor
Storage Account Contributor
```
* Create a resource group
* Create an storage account and a container in the resource group
* Create an key vault in the resource group
* Add the following secrets in the key vault
```
CLIENT-ID
CLIENT-SECRET
STORAGE-ACCOUNT-CONTAINER
STORAGE-ACCOUNT-KEY
STORAGE-ACCOUNT-NAME
SUBSCRIPTION-ID
TENANT-ID
```
* Access the `Library` in the `Pipelines`
* Create a new variables group called `demo-containers-group`
* Enable the `Link secrets from an Azure Key Vault as variables`
* Use the recently key vault created
* Attach the secrets that were created


### Backend pipeline
* Create a new Azure pipeline using the `pipelines/backend/azure-pipelines.yml`
* Run the pipeline and allow it to access the items needed
* Get the credentials of the ACR that was created

### App pipeline
* Access the `Library` in the `Pipelines`
* Create a new variables group called `demo-containers-acr-group`
* Add the following variables
```
acr-admin-password -> value of the password of the ACR
acr-name -> value of the user of the ACR
```
* Create a new pipeline using the `pipelines/app/azure-pipelines.yml`
* Run the pipeline and allow it to access the items needed


######


- in terraform-acr
```
terraform plan -var-file "../dev.tfvars" -out "dev.plan"
terraform apply "dev.plan"
terraform destroy -var-file "../dev.tfvars"
```

https://docs.microsoft.com/en-us/azure/container-instances/container-instances-application-gateway
https://truestorydavestorey.medium.com/how-to-get-an-azure-container-instance-running-inside-a-vnet-with-a-fileshare-mount-using-terraform-a12f5b2b86ce