<#
.Synopsis
    Remove-VM.ps1
.DESCRIPTION
    Created: 2018-01-23
    Version: 1.0

    Author : Pontus Wendt
    Twitter: @pontuswendt
    Blog   : https://pontuswendt.blog

    Disclaimer: This script is provided "AS IS" with no warranties, confers no rights and 
    is not supported by the author or DeploymentArtist..
.EXAMPLE
    NA
#>


Param(
[Parameter(mandatory=$True,HelpMessage="Whats the name of the VM?")]
[ValidateNotNullOrEmpty()]
$VM_Name
)

Function Select-FolderDialog
{
    param([string]$Description="Select a Folder that your VHDX files belongs",[string]$RootFolder="Desktop")

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

# You can modify here if you have your VM in the same folder all the time.
$Folderpath = Select-FolderDialog
$Path = "$Folderpath\$VM_name.vhdx"


#Variabler
$Path = "$Folderpath\$VM_name.vhdx"
Stop-VM -name $VM_Name -Force
Remove-VM -Name "$VM_Name" -Force
Remove-Item -Path $Path -Force


Write-host "Succefully Deleted VM"  -ForegroundColor Green