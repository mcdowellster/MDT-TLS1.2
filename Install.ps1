<#
Add TLS 1.2 Support for DB Connections
Dan McDowell - PCTE
Dan.McDowell@sunlife.com

How: Extraction of the microsoft MSI, reg changes and loads of trail and error.
Run as System, during the TS in WinPE. Post WinPE Install MSI for Windows to have proper access to the driver

#>

#Vars
$SysDrive = $env:SystemDrive
$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath


#Add Reg entries
#Start-Process -FilePath "CScript.exe" -ArgumentList "SLF_AddTLS1.2WinPEReg.vbs" -Wait
Start-Process -FilePath "Regedit.exe" -ArgumentList "/s $dir\MS_OBD_TLS1.2.reg" -Wait

#Add LONG FFFF FFFF Hex key (VBScript overflow)
#Copy Files
Start-Process -FilePath "Robocopy.exe" -ArgumentList """$dir\Program Files\Microsoft SQL Server"" ""$SysDrive\Program Files\Microsoft SQL Server"" /mir /xx /log:X:\Windows\Temp\SMSTSLog\Robo1.log" -Wait
Start-Process -FilePath "Robocopy.exe" -ArgumentList """$dir\Program Files (x86)\Microsoft SQL Server"" ""$SysDrive\Program Files (x86)\Microsoft SQL Server"" /mir /xx" -Wait
Start-Process -FilePath "Robocopy.exe" -ArgumentList """$dir\System"" ""$SysDrive\Windows\SysWOW64"" /mir /xx" -Wait
Start-Process -FilePath "Robocopy.exe" -ArgumentList """$dir\System64"" ""$SysDrive\Windows\System32"" /mir /xx" -Wait
Start-Process -FilePath "Robocopy.exe" -ArgumentList """$dir\Windows\System32"" ""$SysDrive\Windows\SysWOW64"" /mir /xx" -Wait
Start-Process -FilePath "Robocopy.exe" -ArgumentList """$dir\Windows\SysWOW64"" ""$SysDrive\Windows\System32"" /mir /xx" -Wait

#Reg DLL
Start-Process -FilePath "Regsvr32.exe" -ArgumentList "$SysDrive\Windows\SysWOW64\msoledbsql.dll /s"

<#
#Attempt to reg DLLs
$filelist = (Get-ChildItem -Path . -Recurse -Include *.dll)

foreach($file in $filelist.Name){
    write-host "File: $file"
    Start-Process regsvr32.exe -ArgumentList "X:\Windows\SysWOW64\$file /s" -Wait
    Start-Process regsvr32.exe -ArgumentList "X:\Windows\System32\$file /s" -Wait
}

Write-Host "Installed providers:"
foreach ($provider in [System.Data.OleDb.OleDbEnumerator]::GetRootEnumerator())
{
    $v = New-Object PSObject        
    for ($i = 0; $i -lt $provider.FieldCount; $i++) 
    {
        Add-Member -in $v NoteProperty $provider.GetName($i) $provider.GetValue($i)
    }
    $v
}
#>