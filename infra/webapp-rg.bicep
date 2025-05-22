param appServiceName string
param appServicePlanName string
param location string
param abbreviations object

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
      appSettings: [
        {
          name: 'ABBREVIATIONS'
          value: json(string(abbreviations))
        }
      ]
    }
  }
  kind: 'app,linux'
}

output webAppName string = webApp.name
output webAppUrl string = 'https://${webApp.properties.defaultHostName}'

resource group 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: 'myResourceGroup'
}

module appService './appService.bicep' = {
  name: 'myAppService'
  scope: group
  params: {
    appServiceName: 'myUniqueAppName'
    appServicePlanName: 'myAppServicePlan'
    location: 'East US'
    abbreviations: {
      key1: 'value1'
      key2: 'value2'
    }
  }
}
