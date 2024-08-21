<#
.Synopsis
    Create-VM.ps1
.DESCRIPTION
    Created: 2018-01-23
    Version: 1.0

    Author : Pontus Wendt
    Twitter: @pontuswendt
    Blog   : https://clientstuff.blog

    Disclaimer: This script is provided "AS IS" with no warranties, confers no rights and 
    is not supported by the author or DeploymentArtist..
.EXAMPLE
    NA
#>


Param(
[Parameter(mandatory=$True,HelpMessage="Whats the name of the VM?")]
[ValidateNotNullOrEmpty()]
$VM_Name,

[parameter(mandatory=$True,HelpMessage="How much memory do you want in GB?(Example 4)")]
[ValidateNotNullOrEmpty()]
$VMMemoryinGB,

[parameter(mandatory=$True,HelpMessage="How large HD in GB (Example 80)")]
[ValidateNotNullOrEmpty()]
$HDsizeinGB
)

Function Select-FolderDialog
{
    param([string]$Description="Select a Folder that you wanna save your vhdx files",[string]$RootFolder="Desktop")

 [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") |
     Out-Null     

   $objForm = New-Object System.Windows.Forms.FolderBrowserDialog
        $objForm.Rootfolder = $RootFolder
        $objForm.Description = $Description
        $Show = $objForm.ShowDialog()
        If ($Show -eq "OK")
        {
            Return $objForm.SelectedPath
        }
        Else
        {
            Write-Error "Operation cancelled by user."
        }
    }


# You can modify here if you always want to save your machines to a specific folder.
$Folderpath = Select-FolderDialog
$Path = "$Folderpath\$VM_name.vhdx"


#Modify
#Change $NetworkSwitch to your standard switch in hyper-v, mine is Bridge 
$NetworkSwitch = "Bridge"



#Creating Virtual machine
New-VM -Name "$VM_Name" –MemoryStartupBytes ([int64]$VMMemoryinGB*1024*1024*1024) -NewVHDPath $Path -NewVHDSizeBytes ([int64]$HDsizeinGB*1024*1024*1024) -Generation 2 -SwitchName $NetworkSwitch

#Change boot Order 'Network THEN Hardrive'
$vmNetworkAdapter = get-VMNetworkAdapter -Name "Network Adapter" -VMName "$VM_Name"
$vmHardDiskDrive = get-VMHardDiskDrive -VMName "$VM_Name"
Set-VMFirmware "$VM_Name" -BootOrder $vmNetworkAdapter, $vmHardDiskDrive

Start-vm $VM_name

& vmconnect.exe localhost $VM_name

Write-host "Succefully Created VM, Starting.."  -ForegroundColor Green