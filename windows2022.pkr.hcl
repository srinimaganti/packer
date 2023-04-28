source "azure-arm" "demo" {

#Authentication 
<Supply your SP>

#AzureMandatoryInputs
vm_size                           = "Standard_B2ms"
build_resource_group_name         = "NEWResource"
#SourceImageorBaseImage
os_type                           = "Windows"
image_offer                       = "WindowsServer"
image_publisher                   = "MicrosoftWindowsServer"
image_sku                         = "2022-Datacenter"

#WindowsRemoteManagementSettings
communicator                      = "winrm"
winrm_insecure                    = true
winrm_timeout                     = "5m"
winrm_use_ssl                     = true
winrm_username                    = "packer"

#TargetLocation
managed_image_name                = "V1IMAE"
managed_image_resource_group_name = "TESTResource"

azure_tags = {
    client = "NOCLIENT"
    project = "InternalProject"
  }
}

build {
  sources = ["source.azure-arm.demo"]

provisioner "powershell" {
scripts = [
"mount.ps1",
"install.ps1"
]
}

 provisioner "powershell" {
    inline = [
      "while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
      "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
      "while ($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }

}

