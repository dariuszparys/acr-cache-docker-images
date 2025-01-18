param acrName string
param dockerUsernameSecretUri string
param dockerPATSecretUri string

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' existing = {
  name: acrName
}

resource credentials 'Microsoft.ContainerRegistry/registries/credentialSets@2023-11-01-preview' = {
  parent: acr
  name: 'dockerhub'
  identity: {
    type: 'SystemAssigned'
  } 
  properties: {
    authCredentials: [
      {
        name: 'Credential1'
        usernameSecretIdentifier: dockerUsernameSecretUri
        passwordSecretIdentifier: dockerPATSecretUri
      }
    ]
    loginServer: 'docker.io'
  }
}

output credentialsPrincipalId string = credentials.identity.principalId
