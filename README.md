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
* Add the values below in the file `terraform.tfvars`
```
subscription_id = ""
client_id       = ""
client_secret   = ""
tenant_id       = ""
```
* Use the commands below:
```
terraform init
terraform plan -var-file="terraform.tfvars" -out=main.plan
terraform apply -auto-approve main.plan
```


## Azure

### api
* Use the terraform/backend to create the Azure Container Registry (ACR)
* Get the credentials of the ACR
* Use the command `docker login <acrName>.azurecr.io` and provide the username and password
* Run the command `docker build . -t <acrName>.azurecr.io/api`
* Run the command `docker push <acrName>.azurecr.io/api`

## Docker Compose and Azure
* [Deploy a multi-container group using Docker Compose](https://docs.microsoft.com/en-us/azure/container-instances/tutorial-docker-compose)
* az acr login --name <acrName>
* docker-compose up --build -d
* docker-compose down
* docker-compose push
* Create a container instance to MySql
    * Create a vnet inside
    * Use the port 3306
* Open the Container instance of the mysql
* connect to it and run the command in the mysql
* Get the ip address in of the ACI mysql
* Add in the api connect mysql
* Create a container instance to api
    * Create a vnet inside
    * Use the port 9001
* docker-compose up --build -d
* docker-compose down
* docker-compose push

* https://docs.microsoft.com/pt-br/azure/app-service/tutorial-multi-container-app
