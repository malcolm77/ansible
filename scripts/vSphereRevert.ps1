
param (
     [string] $VIServer = $null,
     [string] $User = $null,
     [string] $Pass = $null,
     [string] $TargetVM = $null,
     [string] $Snapshot = $null
     )

Connect-VIServer $VIServer -User $User -Pass $Pass
Set-VM $TargetVM -Snapshot $Snapshot -Confirm:$false
Start-VM $TargetVM

# Connect-VIServer xxx.xxx.xxx.xxx -User "johdup.adm@TESTBENCH.domain" -Pass 'Welcome12345$$'
# Set-VM "Integration - Gold Image w/Ansible" -Snapshot BaseImage1 -Confirm:$false
# Start-VM "Integration - Gold Image w/Ansible"