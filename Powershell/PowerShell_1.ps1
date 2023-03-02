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

#Para cambiar la politica de ejecución 
Set-ExecutionPolicy Unrestricted

#PS C:\Windows\system32> Set-ExecutionPolicy 

#Insatalar el modulo para SQL
Install-Module -Name SqlServer

#Restaurar por defecto
$psISE.Options.RestoreDefaults()

#Cambiar el color de fondo
$psISE.Options.ConsolePaneBackgroundColor= "blue"

#Cambiar el tipo de letra 
$psISE.Options.FontName = "Arial"

 #Cambiar el tamañano de letra
$psISE.Options.FontSize = 25

#el zoom la fuente 
$psISE.Options.Zoom = 175


#Alias

alias
get-alias ls

# upmo --> alias de update modules

#Obtenenr alias de un cdmlet "Get-Service"
get-alias -Definition "Get-Service"
get-alias -Definition "Get-Alias"

#Crear nuestro propios alias temporales
New-Alias -Name d -Value get-childitem

#Comprobamos
d


 #Ver los procesos que estaqn ocurriendo

 Get-Process

 # que me lo mande a un fichero
 Get-Process | out-file c:\procesos.txt

 #que me lo abra con un programa 
notepad C:\procesos.txt



#·pipeline . envio de ficheros
Get-Process | Export-CSV proc.csv
notepad .\procs.csv

get-process | out-Gridiew

#para decirle que el modulo que vas a instalar es de confianza
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

#Instalar el modulo para SQL
Install-Module -Name SqlServer -AllowClobber #(añadimos -AllowClobber si nos da un error)

#para encontrar el modulo
Find-Module sqlServer

#Para actualizar el modulo
Update-Module -Name SqlServer -AllowClobber