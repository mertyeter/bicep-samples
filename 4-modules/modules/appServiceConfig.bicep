@description('App service name')
param appServiceName string

@description('Application insights instrumentation key')
param appInsightsInstrumentationKey string

@description('Application insights connection string')
param appInsightsConnectionString string

@description('Validate JWT issuer or not')
param jwtValidateIssuer bool

@description('Validate JWT audience or not')
param jwtValidateAudience bool

@description('JWT issuer signing key')
@secure()
param issuerSigningKey string

@description('SQL connection user id')
@secure()
param userId string

@description('SQL connection password')
@secure()
param password string

@description('Database connection string')
@secure()
param dbConnectionString string

resource appService 'Microsoft.Web/sites@2022-03-01' existing = {
  name: appServiceName
}

resource appSettings 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: appService
  name: 'appsettings'
  properties: {
    APPINSIGHTS_INSTRUMENTATIONKEY: appInsightsInstrumentationKey
    APPLICATIONINSIGHTS_CONNECTION_STRING: appInsightsConnectionString
    ApplicationInsightsAgent_EXTENSION_VERSION: '~3'
    APPINSIGHTS_PROFILERFEATURE_VERSION: '1.0.0'
    APPINSIGHTS_SNAPSHOTFEATURE_VERSION: '1.0.0'
    JWT__ValidateIssuer: string(jwtValidateIssuer)
    JWT__ValidateAudience: string(jwtValidateAudience)
    JWT__IssuerSigningKey: issuerSigningKey
  }
}

resource connectionStrings 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: appService
  name: 'connectionstrings'
  properties: {
    DbConnectionString: {
      type: 'SQLAzure'
      value: dbConnectionString
    }
    UserId: {
      type: 'Custom'
      value: userId
    }
    Password: {
      type: 'Custom'
      value: password
    }
  }
}
