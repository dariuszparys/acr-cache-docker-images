targetScope = 'subscription'

param resourceGroupName string // = 'rg-caching-docker-images'
param location string // = 'East US'
param dockerHubUsername string
@secure()
param dockerHubPAT string

module resourceGroup 'modules/resource-group.bicep'= {
  name: 'resourceGroupDeployment'
  params: {
    groupName: resourceGroupName
    location: location
    dockerHubUsername: dockerHubUsername
    dockerHubPAT: dockerHubPAT
  }
  scope: subscription()
}
