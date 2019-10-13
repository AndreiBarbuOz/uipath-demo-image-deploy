FROM ubuntu:18.04

ARG PACKER_VERSION="1.4.1"
ENV PACKER_VERSION="$PACKER_VERSION"
ENV ANSIBLE_CALLBACK_WHITELIST="profile_tasks"

# Default Packer config values
ENV AZ_LOCATION="Southeast Asia"
ENV AZ_VM_SIZE="Standard_D4s_v3"
ENV AZ_IMAGE_RESOURCE_GROUP="presales-cloud-poc-rg"
ENV AZ_STORAGE_ACCOUNT_NAME="presalesdemobuild"

# Install Ansible
WORKDIR /install
RUN apt-get update && \
    apt-get install -y software-properties-common unzip python-pip wget sudo && \
    apt-add-repository -y ppa:ansible/ansible && \
    apt-get update && \
    apt-get install -y ansible && \
    pip install -U "pywinrm>=0.3.0"

# Install Packer
RUN wget https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip && \
    unzip packer_${PACKER_VERSION}_linux_amd64.zip && \
    mv packer /usr/local/bin

RUN useradd -ms /bin/bash ansible
RUN mkdir -p /ansible/scripts /ansible/playbooks
WORKDIR /ansible
