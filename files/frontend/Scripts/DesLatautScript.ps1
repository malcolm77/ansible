#Get file path
$file = "C:\ProgramData\MorphoTrak\Bis\des\etc\lataut\des-wrapper.conf"

#Get content and write to line 22, where the username config is.
$content = Get-Content -Path $file

# Get Logged on user
$user_name = Get-WMIObject -class Win32_ComputerSystem | select username

# Split user String: NEXTGEN\test.user ---> test.user
$user_split = Split-Path $user_name."username" -Leaf

$content[21] = "wrapper.java.additional.11 = -Duser.name=" + $user_split

$content | Set-Content -Path $file

#Restart DES LATAUT service
Restart-Service -Name "DES-lataut" -Force