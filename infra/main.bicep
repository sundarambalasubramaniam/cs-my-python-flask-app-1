targetScope = 'resourceGroup'

@description('Name of the Azure Web App')
param appServiceName string

@description('Name of the App Service Plan')
param appServicePlanName string

@description('Azure region for deployment')
param location string

var sku = {
  name: 'F1'
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: sku
  properties: {
    reserved: true
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: appServiceName
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.13'
    }
  }
  kind: 'app,linux'
}

output webAppName string = webApp.name
output webAppUrl string = 'https://${webApp.properties.defaultHostName}'
