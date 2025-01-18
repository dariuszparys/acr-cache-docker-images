param location string
param keyVaultName string
param dockerHubUsername string
@secure()
param dockerHubPAT string

var uniqueKeyVaultName = '${keyVaultName}-${uniqueString(subscription().id, resourceGroup().id)}'

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: take(uniqueKeyVaultName, 24)
  location: location
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: []
    enabledForTemplateDeployment: true
  }
}

resource dockerUsernameSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'dockerhub-username'
  properties: {
    value: dockerHubUsername
  }
}

resource dockerPATSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: 'dockerhub-pat'
  properties: {
    value: dockerHubPAT
  }
}

output keyVaultName string = keyVault.name
output dockerUsernameSecretUri string = dockerUsernameSecret.properties.secretUri
#disable-next-line outputs-should-not-contain-secrets
output dockerPATSecretUri string = dockerPATSecret.properties.secretUri
