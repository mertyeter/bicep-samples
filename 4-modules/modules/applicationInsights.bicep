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

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: 'mshowto-${environmentCode}-${resourceAbbreviation}-ai'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}

output instrumentationKey string = appInsights.properties.InstrumentationKey
output connectionString string = appInsights.properties.ConnectionString
