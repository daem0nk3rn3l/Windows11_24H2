<# 
#> Adds Windows Defender Allow rules for Microsoft teams

$UserSID = (New-Object -ComObject Microsoft.DiskQuota).TranslateLogonNameToSID((Get-CIMInstance -Class Win32_ComputerSystem).Username)
$ProfilePath = Get-Itemproperty registry::"HKU\$UserSID\Volatile Environment" | select-object -ExpandProperty "USERPROFILE"
$TeamsDir = $profilepath + '\appdata\local\Microsoft\Teams\current\teams.exe'
$firewallRuleName = 'teams.exe'
 
$ruleExist = Get-NetFirewallRule -DisplayName $firewallRuleName -ErrorAction SilentlyContinue
 
if($ruleExist)
{
    Set-NetFirewallRule -DisplayName $firewallRuleName -Profile Any -Action Allow
}
else
{
    New-NetfirewallRule -DisplayName $firewallRuleName -Direction Inbound -Protocol TCP -Profile Any -Program $TeamsDir -Action Allow
    New-NetfirewallRule -DisplayName $firewallRuleName -Direction Inbound -Protocol UDP -Profile Any -Program $TeamsDir -Action Allow
}
