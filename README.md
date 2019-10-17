# UiPath container for deployment pipelines

## Purpose
The project deploys a pipeline which builds the Dockerfile, and pushes the image to an Azure Container Registry. The purpose of the Docker image is to be used in Azure pipelines for building Images using [Packer](https://www.packer.io/) and [Ansible](https://www.ansible.com)

![Diagram](https://www.lucidchart.com/publicSegments/view/c810404e-7b5f-4b2e-b51b-23a832058d53/image.png)
## Development environment setup

During development, a Linux VM can be provisioned and Docker installed, following the instructions here: https://docs.docker.com/install/linux/docker-ce/ubuntu/. The machine will be used for testing the Dockerfile. 

## Prerequisites 

The list of items needed for development and deployment:
* Azure account
* Development machine with Docker installed
* An `acr` (Azure Container Registry) in a resourge group. One can be created using: 
    ```
    az acr create --resource-group <resource group name> --name <container name> --sku Basic
    ```
* (Optional - when using an Azure Linux VM for development) Create a `system assigned identity` for the VM and assign the role of owner over the container registry:

    ```
    az vm identity assign --resource-group <resource group name> --name <linux machine> 
    spID=$(az vm show --resource-group <resource group name> --name <linux machine> --query identity.principalId --out tsv)
    resourceID=$(az acr show --resource-group <resource group name> --name <container name> --query id --output tsv)
    az role assignment create --assignee $spID --scope $resourceID --role owner
    ```
    This will allow `az acr login --identity` using the aforementioned identity
* An `Azure Pipeline` build triggered by the repository
* The `Azure Pipeline` needs to have variable group called `demo-vm-deploy` containing these values:
    - containerRegistry
    - azureSubscription
    - repositoryName

