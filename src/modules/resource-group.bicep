targetScope = 'subscription'

param groupName string = 'myResourceGroup'
param location string = 'East US'
param dockerHubUsername string
@secure()
param dockerHubPAT string

resource myResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: groupName
  location: location
}

module acr 'acr.bicep' = {
  name: 'acrDeployment'
  scope: resourceGroup(myResourceGroup.name)
  params: {
    location: location
    acrName: 'acrdemo'
  }
}

module keyVault 'key-vault.bicep' = {
  name: 'keyVaultDeployment'
  scope: resourceGroup(myResourceGroup.name)
  params: {
    location: location
    keyVaultName: 'kv-demo'
    dockerHubUsername: dockerHubUsername
    dockerHubPAT: dockerHubPAT
  }
}

module acrCredentials 'acr-credentials.bicep' = {
  name: 'acrCredentialsDeployment'
  scope: resourceGroup(myResourceGroup.name)
  params: {
    acrName: acr.outputs.acrName
    dockerUsernameSecretUri: keyVault.outputs.dockerUsernameSecretUri
    dockerPATSecretUri: keyVault.outputs.dockerPATSecretUri
  }
}

module keyVaultAccessPolicies 'key-vault-access-policies.bicep' = {
  name: 'keyVaultAccessPoliciesDeployment'
  scope: resourceGroup(myResourceGroup.name)
  params: {
    principalId: acrCredentials.outputs.credentialsPrincipalId
    keyVaultName: keyVault.outputs.keyVaultName
  }
}

output resourceGroupName string = myResourceGroup.name
output acrLoginServer string = acr.outputs.acrLoginServer
