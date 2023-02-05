targetScope = 'subscription'

@description('The Azure region into which the resources should be deployed)')
@allowed([
  'uksouth'
  'ukwest'
])
param location string = 'uksouth'

@description('Environment code')
@minLength(3)
@maxLength(3)
param environmentCode string

@description('Name of the App Service plan SKU')
param appServicePlanSkuName string

@description('Existing key vault name')
param sharedKeyVaultName string

@description('Existing key vault resource group')
param sharedKeyVaultResourceGroup string

@description('Issuer signing key')
@secure()
param issuerSigningKey string

@description('Database connection string')
@secure()
param dbConnectionString string

@description('Database user Id')
@secure()
param userId string

@description('Database password')
@secure()
param password string

resource newResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'mshowto-${environmentCode}-${resourceAbbreviation}-rg'
  location: location
}

var resourceAbbreviation = 'mert'

module appServicePlan 'modules/appServicePlan.bicep' = {
  scope: newResourceGroup
  name: 'app-service-plan'
  params: {
    location: location
    environmentCode: environmentCode
    appServicePlanSkuName: appServicePlanSkuName
    resourceAbbreviation: resourceAbbreviation
  }
}

module appInsights 'modules/applicationInsights.bicep' = {
  scope: newResourceGroup
  name: 'app-insights'
  params: {
    location: location
    environmentCode: environmentCode
    resourceAbbreviation: resourceAbbreviation
  }
}

module appService 'modules/appService.bicep' = {
  scope: newResourceGroup
  name: 'app-service'
  params: {
    environmentCode: environmentCode
    serverFarmId: appServicePlan.outputs.id
    location: location
    resourceAbbreviation: resourceAbbreviation
  }
}

module keyVaultAccessPolicies 'modules/keyVaultAccessPolicies.bicep' = {
  scope: resourceGroup(sharedKeyVaultResourceGroup)
  name: 'key-vault-access-policies'
  params: {
    existingKeyVaultName: sharedKeyVaultName
    accessPolicies: [
      {
        principalId: appService.outputs.principalId
        tenantId: appService.outputs.tenantId
      }
    ]
  }
  dependsOn: [
    appService
  ]
}

module appConfig 'modules/appServiceConfig.bicep' = {
  scope: newResourceGroup
  name: 'app-service-config'
  params: {
    appServiceName: appService.outputs.name
    appInsightsInstrumentationKey: appInsights.outputs.instrumentationKey
    appInsightsConnectionString: appInsights.outputs.connectionString
    jwtValidateIssuer: false
    jwtValidateAudience: false
    issuerSigningKey: issuerSigningKey
    userId: userId
    password: password
    dbConnectionString: dbConnectionString
  }
  dependsOn: [
    appService
    keyVaultAccessPolicies
  ]
}
