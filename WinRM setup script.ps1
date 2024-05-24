
# $PasswordLength=13 #Password Length
# $NonAlphaChar=5 #The number of non Alphabetical Characters
# Add-Type -AssemblyName 'System.Web'
# [System.Web.Security.Membership]::GeneratePassword($PasswordLength,$NonAlphaChar)
# $Password = [System.Web.Security.Membership]::GeneratePassword($PasswordLength,$NonAlphaChar) | ConvertTo-SecureString -AsPlainText -Force #use text

#####
#!!! Password will be used until certirficate baed authentication can be setup
#####

$Password = "s4?cuTcn?T-CR384b" | ConvertTo-SecureString -AsPlainText -Force
$Username = "ansible"

Try {
   New-LocalUser $Username -Password $Password -FullName "Ansible Admin" -Description "Ansible controller” -ErrorAction Stop
   }
Catch [Microsoft.PowerShell.Commands.UserExistsException] {
   Set-LocalUser -Name $Username -Password $Password
   Write-Host User:$Username already exist
   Write-Host password has been updated
}


try {
   Add-LocalGroupMember -Group "Administrators" -Member "ansible" -ErrorAction Stop
   }
catch [Microsoft.PowerShell.Commands.MemberExistsException] {
   Write-Host User:$Username already exist in Administrator group
}

# Remove all Listeners, its easier to remove then reconfigure
#Remove-Item -Path WSMan:\localhost\Listener\* -Recurse -Force

#GET THE HOSTNAME
# $gwmi_hostname = gwmi Win32_ComputerSystem| %{$_.DNSHostName}

# Setting up the SSL listener

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"

(New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)

powershell.exe -ExecutionPolicy ByPass -File $file  -GlobalHttpFirewallAccess -SkipNetworkProfileCheck -DisableBasicAuth


# Remove HTTP listener
# Get-ChildItem -Path WSMan:\localhost\Listener | Where-Object { $_.Keys -contains "Transport=HTTP" } | Remove-Item -Recurse -Force

# echo listeners
winrm enumerate winrm/config/Listener

#winrm get winrm/config

# Enable Certiticate auth
Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true

#Enable Basic Auth
Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $true

winrm get winrm/config