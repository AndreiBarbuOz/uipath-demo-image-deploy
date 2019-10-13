FROM ubuntu:18.04

ARG PACKER_VERSION="1.4.1"
ENV PACKER_VERSION="$PACKER_VERSION"
ENV ANSIBLE_CALLBACK_WHITELIST="profile_tasks"

# Default Packer config values
ENV AZ_LOCATION="West Europe"
ENV AZ_VM_SIZE="Standard_F4s_v2"
ENV AZ_IMAGE_RESOURCE_GROUP="Packer-Images-RG"
ENV AZ_STORAGE_ACCOUNT_NAME="uipathdevtest"

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
COPY scripts/ ./scripts/
COPY win-ansible-image.json .

CMD [ "packer",  "build", "win-ansible-image.json" ]
