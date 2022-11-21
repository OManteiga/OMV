 $PSVersionTable
 PS C:\Windows\system32> $PSVersionTable

#Name                           Value                                                       
#----                           -----                                                       
#PSVersion                      5.1.19041.1682                                              
#PSEdition                      Desktop                                                     
#PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}                                     
#BuildVersion                   10.0.19041.1682                                             
#CLRVersion                     4.0.30319.42000                                             
#WSManStackVersion              3.0                                                         
#PSRemotingProtocolVersion      2.3                                                         
#SerializationVersion           1.1.0.1   

$version=$PSVersionTable
$version

#Ayuda

Show-Command
Get-Help
Get-Help -Full
Get-Help -ShowWindow
Update-Help

help cmdlet
help Get-Service -ShowWindow
help *network* -ShowWindow
help Get-DisplayResolution

# Funiconan comandos habituales externos
ping localhost

## Borrar pantalla
Clear-Host

##Cmdlets ejecutados
Get-History

# Policy Execution Script
Get-ExecutionPolicy

#PS C:\Windows\system32> Get-ExecutionPolicy
#Restricted


Set-ExecutionPolicy Unrestricted

#PS C:\Windows\system32> Set-ExecutionPolicy 








