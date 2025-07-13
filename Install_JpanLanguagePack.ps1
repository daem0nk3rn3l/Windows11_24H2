# Install Windows 11 24H2 Japanese language packs with Dictionary files
# /Limit Access only goes to local directory and does not call out to the internet Windows Update server
# ========================================================================================================

$CabFileDirectory = ".\"
$LogFolder = "C:\applog"
$DismLogFile = "$LogFolder\Japanese_Dism_LanguagePackInstall.log"
$LogFile = "$LogFolder\Japanese_LanguagePackInstall.log"
$JPDIC="C:\windows\IME\IMEJP\DICTS\" 

function Get-TimeStamp {
    return "[{0:yyyy-MM-dd HH:mm:ss}]" -f (Get-Date)
}

if (!(Test-Path -Path $LogFolder)) {
    try {
        New-Item -ItemType Directory -Path $LogFolder -Force | Out-Null
    } catch {
        Write-Output "$(Get-TimeStamp) Failed to create log folder." | Out-File -Append -FilePath $LogFile
    }
}

# Log Start Time
$StartTime = Get-Date
Write-Output "$(Get-TimeStamp) Starting CAB installation..." | Out-File -Append -FilePath $LogFile
Write-Output "$(Get-TimeStamp) DISM START TIME: $StartTime" | Out-File -FilePath $DismLogFile

$CabFiles = Get-ChildItem -Path $CabFileDirectory -Filter *.cab -Recurse
$arguments = "/online /Add-Package"

foreach ($CabFile in $CabFiles) {
    $arguments += " /PackagePath=""$($CabFile.FullName)"""
}

$arguments += " /LimitAccess"
Write-Output "$(Get-TimeStamp) Calling DISM with arguments: $arguments" | Out-File -Append -FilePath $LogFile

# Append DISM output
cmd.exe /c "dism.exe $arguments >> `"$DismLogFile`" 2>&1"

$DirCheck = Test-Path($JPDIC) -PathType Container
If ($DirCheck)
{
"Japan Dictionary folder exists. Copying dictionary files" | Add-Content $LogFile
Copy-Item -path .\IME-JP\imjptk.DIC -Destination "$JPDIC" 
Copy-Item -path .\IME-JP\IMJPZP.DIC -Destination "$JPDIC" 
Copy-Item -path .\IME-JP\SDDS0411.DIC -Destination "$JPDIC"         
"Copy Complete" | Add-Content $LogFile
}

# Log End Time
$EndTime = Get-Date
Write-Output "$(Get-TimeStamp) DISM END TIME: $EndTime" | Out-File -Append -FilePath $DismLogFile
Write-Output "$(Get-TimeStamp) CAB installation completed." | Out-File -Append -FilePath $LogFile
Write-Output "$(Get-TimeStamp) Start Time: $StartTime" | Out-File -Append -FilePath $LogFile
Write-Output "$(Get-TimeStamp) End Time:   $EndTime" | Out-File -Append -FilePath $LogFile

Write-Output "`nAll CAB installation completed. Log saved to: $LogFile"
