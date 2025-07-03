#  Get local computer's HD statistics
  
Clear-Host

Get-WmiObject Win32_logicalDisk -ComputerName localhost -Filter "drivetype=3" | `
Select-Object DeviceID,`
@{Name="SizeMB";Expression={$_.size/1MB -as [int]}},`
@{Name="FreeMB";Expression={$_.freespace/1mb -as [int]}},`
@{Name="PctFree";Expression={[math]::round(($_.freespace/$_.size)*100,2)}}
