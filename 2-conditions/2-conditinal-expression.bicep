@description('The name of the container registry')
param name string = 'mshowtocr${uniqueString(resourceGroup().id)}'

@description('The Azure region which the resources should be deployed')
param location string = resourceGroup().location

@allowed([
  'dev'
  'test'
  'prod'
])
param environment string

@allowed([
  'Basic'
  'Standard'
])
@description('The SKU of the resource')
param skuName string

var willBeDeployed = environment == 'prod' ? false : true

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = if (willBeDeployed) {
  name: name
  location: location
  sku: {
    name: skuName
  }
}
