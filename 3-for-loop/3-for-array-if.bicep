@description('The Azure region which the resources should be deployed')
param location string = resourceGroup().location

param crSettings array = [
  {
    skuName: 'Basic'
    name: 'mshowtocr${uniqueString(resourceGroup().id)}'
    location: 'uksouth'
    adminUserEnabled: true
  }
  {
    skuName: 'Standard'
    name: 'mshowtocr${uniqueString(resourceGroup().id)}'
    location: 'ukwest'
    adminUserEnabled: false
  }
  {
    skuName: 'Standard'
    name: 'mshowtocr${uniqueString(resourceGroup().id)}'
    location: 'westeurope'
    adminUserEnabled: false
  }
]

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = [for (crSetting, i) in crSettings: if (crSetting.location == location) {
  name: '${crSetting.name}${location}dev${i}'
  location: crSetting.location
  sku: {
    name: crSetting.skuName
  }
  properties: {
    adminUserEnabled: crSetting.adminUserEnabled
  }
}]
