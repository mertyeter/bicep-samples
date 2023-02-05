@description('Existing key vault name')
param existingKeyVaultName string

@description('Access policies to be added to the access policies')
param accessPolicies array = []

resource sharedKeyVault 'Microsoft.KeyVault/vaults@2022-07-01' existing = {
  name: existingKeyVaultName
}

resource keyVaultAccessPolicies 'Microsoft.KeyVault/vaults/accessPolicies@2022-07-01' = {
  parent: sharedKeyVault
  name: 'add'
  properties: {
    accessPolicies: [for accessPolicy in accessPolicies: {
      objectId: accessPolicy.principalId
      tenantId: accessPolicy.tenantId
      permissions: {
        secrets: [
          'get'
          'list'
        ]
      }
    }]
  }
}
