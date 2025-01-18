#!/bin/bash

# Check if environment variables are set
if [ -z "$DOCKER_HUB_USERNAME" ] || [ -z "$DOCKER_HUB_PAT" ]; then
    echo "Error: DOCKER_HUB_USERNAME and DOCKER_HUB_PAT environment variables must be set"
    exit 1
fi

# Variables
BICEP_FILE="src/main.bicep"
PARAM_FILE="src/main.bicepparam"
DEPLOYMENT_NAME="caching-docker-images-deployment"

# Execute the Bicep file
az deployment sub create \
    --name $DEPLOYMENT_NAME \
    --location "East US" \
    --template-file $BICEP_FILE \
    --parameters $PARAM_FILE \
    --parameters dockerHubUsername="$DOCKER_HUB_USERNAME" dockerHubPAT="$DOCKER_HUB_PAT"  