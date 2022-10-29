@description('The name of the container registry')
param name string = 'mshowtocr${uniqueString(resourceGroup().id)}'

@description('The Azure region which the resources should be deployed')
param location string = resourceGroup().location

@allowed([
  'Basic'
  'Standard'
])
@description('The SKU of the resource')
param skuName string = 'Basic'

@maxValue(5)
@minValue(1)
@description('The number of resources to create')
param resourceCount int

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = [for i in range(1, resourceCount): {
  name: '${name}${i}'
  location: location
  sku: {
    name: skuName
  }
}]
