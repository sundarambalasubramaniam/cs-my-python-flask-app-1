targetScope = 'subscription'

@description('Name of the Azure Resource Group')
param resourceGroupName string

@description('Azure region for deployment')
param location string

@description('Name of the Azure Web App')
param appServiceName string

@description('Name of the App Service Plan')
param appServicePlanName string

@description('Abbreviations object loaded from abbreviations.json')
param abbreviations object

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: location
}

module webappRg 'webapp-rg.bicep' = {
  name: 'webappRg'
  scope: resourceGroup(resourceGroupName)
  params: {
    appServiceName: appServiceName
    appServicePlanName: appServicePlanName
    location: location
    abbreviations: abbreviations
  }
}

output webAppName string = webappRg.outputs.webAppName
output webAppUrl string = webappRg.outputs.webAppUrl
