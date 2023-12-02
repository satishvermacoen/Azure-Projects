# Arm-Virtual-Machine

## This is code of Virtual Machine in .json Arm You can Copy-Paste and Modifed Accd to required


{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "virtualMachines_vm01_name": {
            "defaultValue": "vm01",
            "type": "String"
        },
        "virtualNetworks_vm_vnet_name": {
            "defaultValue": "vm-vnet",
            "type": "String"
        },
        "networkInterfaces_vm01NetworkInterface_name": {
            "defaultValue": "vm01NetworkInterface",
            "type": "String"
        },
        "storageAccounts_vmstorage7da257ehytrdk_name": {
            "defaultValue": "vmstorage7da257ehytrdk",
            "type": "String"
        }
    },
    "variables": {},
    "resources": [
        {
            "type": "Microsoft.Network/virtualNetworks",
            "apiVersion": "2022-11-01",
            "name": "[parameters('virtualNetworks_vm_vnet_name')]",
            "location": "centralindia",
            "tags": {
                "displayName": "vm-vnet"
            },
            "properties": {
                "addressSpace": {
                    "addressPrefixes": [
                        "10.0.0.0/16"
                    ]
                },
                "subnets": [
                    {
                        "name": "Subnet-1",
                        "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('virtualNetworks_vm_vnet_name'), 'Subnet-1')]",
                        "properties": {
                            "addressPrefix": "10.0.0.0/24",
                            "delegations": [],
                            "privateEndpointNetworkPolicies": "Disabled",
                            "privateLinkServiceNetworkPolicies": "Enabled"
                        },
                        "type": "Microsoft.Network/virtualNetworks/subnets"
                    },
                    {
                        "name": "Subnet-2",
                        "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('virtualNetworks_vm_vnet_name'), 'Subnet-2')]",
                        "properties": {
                            "addressPrefix": "10.0.1.0/24",
                            "delegations": [],
                            "privateEndpointNetworkPolicies": "Disabled",
                            "privateLinkServiceNetworkPolicies": "Enabled"
                        },
                        "type": "Microsoft.Network/virtualNetworks/subnets"
                    }
                ],
                "virtualNetworkPeerings": [],
                "enableDdosProtection": false
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts",
            "apiVersion": "2022-09-01",
            "name": "[parameters('storageAccounts_vmstorage7da257ehytrdk_name')]",
            "location": "centralindia",
            "tags": {
                "displayName": "vmstorageaccount12312"
            },
            "sku": {
                "name": "Standard_LRS",
                "tier": "Standard"
            },
            "kind": "Storage",
            "properties": {
                "minimumTlsVersion": "TLS1_0",
                "allowBlobPublicAccess": true,
                "networkAcls": {
                    "bypass": "AzureServices",
                    "virtualNetworkRules": [],
                    "ipRules": [],
                    "defaultAction": "Allow"
                },
                "supportsHttpsTrafficOnly": false,
                "encryption": {
                    "services": {
                        "file": {
                            "keyType": "Account",
                            "enabled": true
                        },
                        "blob": {
                            "keyType": "Account",
                            "enabled": true
                        }
                    },
                    "keySource": "Microsoft.Storage"
                }
            }
        },
        {
            "type": "Microsoft.Network/networkInterfaces",
            "apiVersion": "2022-11-01",
            "name": "[parameters('networkInterfaces_vm01NetworkInterface_name')]",
            "location": "centralindia",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('virtualNetworks_vm_vnet_name'), 'Subnet-1')]"
            ],
            "tags": {
                "displayName": "vm01Nic"
            },
            "kind": "Regular",
            "properties": {
                "ipConfigurations": [
                    {
                        "name": "ipconfig1",
                        "id": "[concat(resourceId('Microsoft.Network/networkInterfaces', parameters('networkInterfaces_vm01NetworkInterface_name')), '/ipConfigurations/ipconfig1')]",
                        "etag": "W/\"92de2867-2420-4f30-b9b6-43fa5596c492\"",
                        "type": "Microsoft.Network/networkInterfaces/ipConfigurations",
                        "properties": {
                            "provisioningState": "Succeeded",
                            "privateIPAddress": "10.0.0.4",
                            "privateIPAllocationMethod": "Dynamic",
                            "subnet": {
                                "id": "[resourceId('Microsoft.Network/virtualNetworks/subnets', parameters('virtualNetworks_vm_vnet_name'), 'Subnet-1')]"
                            },
                            "primary": true,
                            "privateIPAddressVersion": "IPv4"
                        }
                    }
                ],
                "dnsSettings": {
                    "dnsServers": []
                },
                "enableAcceleratedNetworking": false,
                "enableIPForwarding": false,
                "disableTcpStateTracking": false,
                "nicType": "Standard"
            }
        },
        {
            "type": "Microsoft.Network/virtualNetworks/subnets",
            "apiVersion": "2022-11-01",
            "name": "[concat(parameters('virtualNetworks_vm_vnet_name'), '/Subnet-1')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_vm_vnet_name'))]"
            ],
            "properties": {
                "addressPrefix": "10.0.0.0/24",
                "delegations": [],
                "privateEndpointNetworkPolicies": "Disabled",
                "privateLinkServiceNetworkPolicies": "Enabled"
            }
        },
        {
            "type": "Microsoft.Network/virtualNetworks/subnets",
            "apiVersion": "2022-11-01",
            "name": "[concat(parameters('virtualNetworks_vm_vnet_name'), '/Subnet-2')]",
            "dependsOn": [
                "[resourceId('Microsoft.Network/virtualNetworks', parameters('virtualNetworks_vm_vnet_name'))]"
            ],
            "properties": {
                "addressPrefix": "10.0.1.0/24",
                "delegations": [],
                "privateEndpointNetworkPolicies": "Disabled",
                "privateLinkServiceNetworkPolicies": "Enabled"
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/blobServices",
            "apiVersion": "2022-09-01",
            "name": "[concat(parameters('storageAccounts_vmstorage7da257ehytrdk_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_vmstorage7da257ehytrdk_name'))]"
            ],
            "sku": {
                "name": "Standard_LRS",
                "tier": "Standard"
            },
            "properties": {
                "cors": {
                    "corsRules": []
                },
                "deleteRetentionPolicy": {
                    "allowPermanentDelete": false,
                    "enabled": false
                }
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/fileServices",
            "apiVersion": "2022-09-01",
            "name": "[concat(parameters('storageAccounts_vmstorage7da257ehytrdk_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_vmstorage7da257ehytrdk_name'))]"
            ],
            "sku": {
                "name": "Standard_LRS",
                "tier": "Standard"
            },
            "properties": {
                "protocolSettings": {
                    "smb": {}
                },
                "cors": {
                    "corsRules": []
                },
                "shareDeleteRetentionPolicy": {
                    "enabled": true,
                    "days": 7
                }
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/queueServices",
            "apiVersion": "2022-09-01",
            "name": "[concat(parameters('storageAccounts_vmstorage7da257ehytrdk_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_vmstorage7da257ehytrdk_name'))]"
            ],
            "properties": {
                "cors": {
                    "corsRules": []
                }
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/tableServices",
            "apiVersion": "2022-09-01",
            "name": "[concat(parameters('storageAccounts_vmstorage7da257ehytrdk_name'), '/default')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_vmstorage7da257ehytrdk_name'))]"
            ],
            "properties": {
                "cors": {
                    "corsRules": []
                }
            }
        },
        {
            "type": "Microsoft.Compute/virtualMachines",
            "apiVersion": "2023-03-01",
            "name": "[parameters('virtualMachines_vm01_name')]",
            "location": "centralindia",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/StorageAccounts', parameters('storageAccounts_vmstorage7da257ehytrdk_name'))]",
                "[resourceId('Microsoft.Network/networkInterfaces', parameters('networkInterfaces_vm01NetworkInterface_name'))]"
            ],
            "tags": {
                "displayName": "vm01"
            },
            "properties": {
                "hardwareProfile": {
                    "vmSize": "Standard_D1"
                },
                "storageProfile": {
                    "imageReference": {
                        "publisher": "MicrosoftWindowsServer",
                        "offer": "WindowsServer",
                        "sku": "2012-R2-Datacenter",
                        "version": "latest"
                    },
                    "osDisk": {
                        "osType": "Windows",
                        "name": "[concat(parameters('virtualMachines_vm01_name'), 'OSDisk')]",
                        "createOption": "FromImage",
                        "vhd": {
                            "uri": "[concat('http://', parameters('storageAccounts_vmstorage7da257ehytrdk_name'), concat('.blob.core.windows.net/vhds/', parameters('virtualMachines_vm01_name'), 'OSDisk.vhd'))]"
                        },
                        "caching": "ReadWrite",
                        "deleteOption": "Detach",
                        "diskSizeGB": 127
                    },
                    "dataDisks": []
                },
                "osProfile": {
                    "computerName": "[parameters('virtualMachines_vm01_name')]",
                    "adminUsername": "satish",
                    "windowsConfiguration": {
                        "provisionVMAgent": true,
                        "enableAutomaticUpdates": true,
                        "patchSettings": {
                            "patchMode": "AutomaticByOS",
                            "assessmentMode": "ImageDefault"
                        },
                        "enableVMAgentPlatformUpdates": false
                    },
                    "secrets": []
                },
                "networkProfile": {
                    "networkInterfaces": [
                        {
                            "id": "[resourceId('Microsoft.Network/networkInterfaces', parameters('networkInterfaces_vm01NetworkInterface_name'))]"
                        }
                    ]
                }
            }
        },
        {
            "type": "Microsoft.Storage/storageAccounts/blobServices/containers",
            "apiVersion": "2022-09-01",
            "name": "[concat(parameters('storageAccounts_vmstorage7da257ehytrdk_name'), '/default/vhds')]",
            "dependsOn": [
                "[resourceId('Microsoft.Storage/storageAccounts/blobServices', parameters('storageAccounts_vmstorage7da257ehytrdk_name'), 'default')]",
                "[resourceId('Microsoft.Storage/storageAccounts', parameters('storageAccounts_vmstorage7da257ehytrdk_name'))]"
            ],
            "properties": {
                "immutableStorageWithVersioning": {
                    "enabled": false
                },
                "defaultEncryptionScope": "$account-encryption-key",
                "denyEncryptionScopeOverride": false,
                "publicAccess": "None"
            }
        }
    ]
}