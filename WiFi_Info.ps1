#  Get Wi-Fi Name / Password
#  created 2.5.2023
#

(netsh wlan show profiles) | Select-String "\:(.+)$" | %{$name=$_.Matches.Groups[1].Value.Trim(); $_} `
| %{(netsh wlan show profile name="$name" key=clear)} | Select-String "Key Content\W+\:(.+)$" `
| %{$pass=$_.Matches.Groups[1].Value.Trim(); $_} | %{[PSCustomObject]@{ PROFILE_NAME=$name;PASSWORD=$pass }} | Format-Table `
| Out-File "$env:userprofile\OneDrive\Desktop\Wi-Fi_network_passwords.txt"
