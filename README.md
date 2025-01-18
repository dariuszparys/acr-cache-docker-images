# Project Documentation for Bicep Project

## Overview

This project configures an Azure Container Registry with Docker Hub credentials
stored securely in Azure Key Vault, using managed identities for secure access.

## Project Structure

The project is organized into the following directories and files:

- **/src**: Contains the main Bicep file and modules for resource deployment.
- **/src/modules**: Includes reusable Bicep modules for creating and managing
  Azure resources.
- **/params**: Contains parameter files for different environments.
- **deploy.sh**: Script to automate the deployment process.
- **.env**: File for environment variables
- **README.md**: Project documentation and instructions.

## Prerequisites

- Azure subscription
- Azure CLI installed
- Bicep CLI installed (if necessary)
- Docker Hub account

## Deployment

1. Set environment variables:

```bash
export DOCKER_HUB_USERNAME="your-username"
export DOCKER_HUB_PAT="your-personal-access-token"
```

2. Configure parameters

Update `main.bicepparam` to your liking.

3. Run deployment:

```bash
chmod +x deploy.sh
./deploy.sh
```

## Caching Repositories

Once this is set up we can now cache any public repository from docker hub in
the Azure Container Registry. The following example show how to cache the python
repository.

```bash
az acr cache create -r <name of registry> -n mypython --source-repo docker.io/library/python -t python -c dockerhub
```

To pull images now from your CLI for instance

```bash
❯ az acr login -n <name of registry>

❯ docker pull <name of registry>.azurecr.io/python
Using default tag: latest
latest: Pulling from python
936252136b92: Download complete
e474a4a4cbbf: Download complete
d22b85d68f8a: Download complete
392351542e2f: Download complete
94c5996c7a64: Download complete
4cf0e15c283e: Download complete
7920d0c7c23d: Download complete
Digest: sha256:d57ec66c94b9497b9f3c66f6cdddc1e4e0bad4c584397e0b57a721baef0e6fdc
Status: Downloaded newer image for <name of registry>.azurecr.io/python:latest
<name of registry>.azurecr.io/python:latest

❯ docker pull <name of registry>.azurecr.io/python:3.11-slim-buster
3.11-slim-buster: Pulling from python
14aea17807c4: Download complete
db8899040fb5: Download complete
67cefd826e1d: Download complete
195c388ea91b: Download complete
d191be7a3c9f: Download complete
Digest: sha256:c46b0ae5728c2247b99903098ade3176a58e274d9c7d2efeaaab3e0621a53935
Status: Downloaded newer image for <name of registry>.azurecr.io/python:3.11-slim-buster
<name of registry>.azurecr.io/python:3.11-slim-buster
```

## Security

- Uses system-assigned managed identity for ACR
- Stores credentials securely in Key Vault
- Configures least-privilege access policies

## License

This project is licensed under the MIT License.
