param location string
@minLength(5)
param acrName string
param uniqueSuffix string = uniqueString(resourceGroup().id)

var uniqueAcrName = '${acrName}${uniqueSuffix}'

resource acr 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: take(uniqueAcrName, 50)
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    adminUserEnabled: false
  }
}

output acrLoginServer string = acr.properties.loginServer
output acrName string = acr.name
