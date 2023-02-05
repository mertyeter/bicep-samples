param crSettings array = [
  {
    skuName: 'Basic'
    name: 'mshowtocr${uniqueString(resourceGroup().id)}dev1'
    location: 'uksouth'
    adminUserEnabled: true
  }
  {
    skuName: 'Standard'
    name: 'mshowtocr${uniqueString(resourceGroup().id)}dev2'
    location: 'ukwest'
    adminUserEnabled: false
  }
  {
    skuName: 'Standard'
    name: 'mshowtocr${uniqueString(resourceGroup().id)}dev3'
    location: 'westeurope'
    adminUserEnabled: false
  }
]

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2022-02-01-preview' = [for crSetting in crSettings: {
  name: '${crSetting.name}'
  location: crSetting.location
  sku: {
    name: crSetting.skuName
  }
  properties: {
    adminUserEnabled: crSetting.adminUserEnabled
  }
}]
