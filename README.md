# UiPath demo image deployment pipeline

## Environment setup

Create a linux VM and install docker, following the instructions here: https://docs.docker.com/install/linux/docker-ce/ubuntu/

Create a container registry: 
```
az acr create --resource-group presales-cloud-poc-rg --name demovmcontainer --sku Basic
```

Create an identity for the VM and assign the role of owner over the container registry:

```
az vm identity assign --resource-group presales-cloud-poc-rg --name dev-linux 
spID=$(az vm show --resource-group presales-cloud-poc-rg --name dev-linux --query identity.principalId --out tsv)
resourceID=$(az acr show --resource-group presales-cloud-poc-rg --name demovmcontainer --query id --output tsv)
az role assignment create --assignee $spID --scope $resourceID --role owner
```

