

If ((Get-PSSnapin -Name Microsoft.BDD.PSSnapIn -ErrorAction SilentlyContinue) -eq $null)
{  
    Add-PSSnapin Microsoft.BDD.PSSnapIn
}

If ((Get-PSDrive -Name DeploymentShare -ErrorAction SilentlyContinue) -eq $null)
{
    New-PSDrive -Name DeploymentShare -PSProvider MDTProvider -Root "E:\DeploymentShare"
}


$sourceFile = Get-ChildItem 'DeploymentShare:\Task Sequences\Windows 10 20H2\*.wim' | Sort-Object LastWriteTime -Descending | Select-Object -First 1



#This file contains a helper function that accepts a Task sequence index number, e.g. W20H2-01, as an input,
#and returns a new task sequence number that either increments the numeric suffix OR adds a numeric suffix if


# Sroll past the end of the function to see how it's used.


function Increment-TSIndex {
    param ( [string]$index )
    if ($index -match '^(.*?)([0-9]+)$') {
        $prefix = $matches[1]
        $suffix = $matches[2]
        $value = [int]::Parse($suffix)
        $value++
        $formatstring = ("0" * $suffix.Length)
        $value.toString($formatstring)
        $index = $prefix + $value.toString($formatstring)
    } else {
        $index = $index + "01"
    }

    return $index
} # end function Increment-TSIndex

$ID = '20H2_04'
$newIndex = Increment-TSIndex $ID
# Write-host "The old index was $oldIndex and the new index is $newIndex."



Import-MDTTaskSequence -Template client.xml -name "Windows10v20H2_LP_WIM$newIndex" -ID $ID -OperatingSystemPath 'DeploymentShare:\Operating Systems\20H2\20H2ENTCUAPR.wim' -Path 'DeploymentShare:\Task Sequences\Windows 10 20H2' -Version 1.0
Copy-Item -Path "E:\DeploymentShare\Control\20H2_02\*" -Destination "E:\DeploymentShare\Control\$newIndex" -PassThru 







Import-MDTTaskSequence -Template client.xml -name "Windows10v20H2_LP_WIM$newIndex" -ID $ID -OperatingSystemPath 'DeploymentShare:\Operating Systems\20H2\20H2ENTCUAPR.wim' -Path 'DeploymentShare:\Task Sequences\Windows 10 20H2' -Version 1.0
Copy-Item -Path "E:\DeploymentShare\Control\20H2_02\*" -Destination "E:\DeploymentShare\Control\$newIndex" -PassThru 
