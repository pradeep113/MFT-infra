param disks_practiselciappdev001_OsDisk_1_63fabfd433e2456793a6999f327a919e_externalid string = '/subscriptions/2f571c43-a917-4964-bc96-73739a4f058e/resourceGroups/practise-ci-app-rg-app-01/providers/Microsoft.Compute/disks/practiselciappdev001_OsDisk_1_63fabfd433e2456793a6999f327a919e'
param networkInterfaces_practiselciappdev001892_externalid string = '/subscriptions/2f571c43-a917-4964-bc96-73739a4f058e/resourceGroups/practise-ci-app-rg-app-01/providers/Microsoft.Network/networkInterfaces/practiselciappdev001892'
param location string = resourceGroup().location
param vmName string = 'practiselciappdev001'
param virtualNetworkName string = 'practise-ci-app-dev-vn-01'
param networkSecurityGroupName string = 'practiselciappdev001-nsg'
param subnetName = 'practise-ci-app-dev-subnet-01'

var addressPrefix = '10.0.0.0/16'
var subnetPrefix = '10.0.0.0/24'


resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}
resource nic 'Microsoft.Network/networkInterfaces@2022-09-01' = {
  properties:{
    ipConfigurations:[
      name: 'ipconfig01'
      properties: {
        privateIPAllocationMethod: 'Dynamic'
      }
      subnet: {
        id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
      }
    ]
  }
  dependsOn:[
    virtualNetwork
  ]
}
resource vmName 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: vmName
  location: location
  tags: {
    env: 'dev'
  }
  plan: {
    name: 'ntg_ubuntu_18_04'
    product: 'ntg_ubuntu_18_04'
    publisher: 'ntegralinc1586961136942'
  }
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    storageProfile: {
      imageReference: {
        publisher: 'ntegralinc1586961136942'
        offer: 'ntg_ubuntu_18_04'
        sku: 'ntg_ubuntu_18_04'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${vmName}_OsDisk_1_63fabfd433e2456793a6999f327a919e'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: vmName
      adminUsername: 'mftvmadmin'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
