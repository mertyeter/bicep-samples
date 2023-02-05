@description('The name of the container registry')
param name string = 'mshowtocr${uniqueString(resourceGroup().id)}'

@description('The Azure region which the resources should be deployed')
param location string = resourceGroup().location

@allowed([
  'Basic'
  'Standard'
])
@description('The SKU of the resource')
param skuName string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = {
  name: name
  location: location
  sku: {
    name: skuName
  }
}
