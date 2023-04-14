param virtualMachines_practiselciappdev001_name string = 'practiselciappdev001'
param disks_practiselciappdev001_OsDisk_1_63fabfd433e2456793a6999f327a919e_externalid string = '/subscriptions/2f571c43-a917-4964-bc96-73739a4f058e/resourceGroups/practise-ci-app-rg-app-01/providers/Microsoft.Compute/disks/practiselciappdev001_OsDisk_1_63fabfd433e2456793a6999f327a919e'
param networkInterfaces_practiselciappdev001892_externalid string = '/subscriptions/2f571c43-a917-4964-bc96-73739a4f058e/resourceGroups/practise-ci-app-rg-app-01/providers/Microsoft.Network/networkInterfaces/practiselciappdev001892'

resource virtualMachines_practiselciappdev001_name_resource 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: virtualMachines_practiselciappdev001_name
  location: 'centralindia'
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
        name: '${virtualMachines_practiselciappdev001_name}_OsDisk_1_63fabfd433e2456793a6999f327a919e'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: disks_practiselciappdev001_OsDisk_1_63fabfd433e2456793a6999f327a919e_externalid
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachines_practiselciappdev001_name
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
          id: networkInterfaces_practiselciappdev001892_externalid
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