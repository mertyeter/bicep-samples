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

@description('App service plan Id')
param serverFarmId string

resource appService 'Microsoft.Web/sites@2022-03-01' = {
  name: 'mshowto-${environmentCode}-${resourceAbbreviation}-as'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: serverFarmId
    httpsOnly: true
    siteConfig: {
      ftpsState: 'FtpsOnly'
      http20Enabled: true
      linuxFxVersion: 'DOTNETCORE|6.0'
    }
  }
}

output name string = appService.name
output principalId string = appService.identity.principalId
output tenantId string = appService.identity.tenantId
