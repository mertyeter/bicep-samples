@description('Azure region into which the resources should be deployed)')
param location string = resourceGroup().location

@description('Environment code')
@minLength(3)
@maxLength(3)
param environmentCode string

@description('Abbreviation for the resource')
@minLength(3)
@maxLength(6)
param resourceAbbreviation string

@description('Name of the App Service plan SKU')
param appServicePlanSkuName string

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: 'mshowto-${environmentCode}-${resourceAbbreviation}-asp'
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: appServicePlanSkuName
  }
  kind: 'linux'
}

output id string = appServicePlan.id
