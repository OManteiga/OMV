PSDRIVE
CD SQLSERVER:\
Get-Location

## Shows using the full cmdet name.  
Set-Location SQLSERVER:\SQL  
Get-ChildItem  

# DESKTOP-V9719B2                 

## Shows using canonical aliases.  
sl SQLSERVER:\SQL  
gci  
  
## Shows using command prompt aliases.  
cd SQLSERVER:\SQL  
dir  
  
## Shows using Unix shell aliases.  
cd SQLSERVER:\SQL  
ls

## List the instances of the Database Engine on the local computer.  
  
Set-Location SQLSERVER:\SQL\localhost  
Get-ChildItem  
  
## Lists the categories of objects available in the  
## default instance on the local computer.  
Set-Location SQLSERVER:\SQL\localhost\DEFAULT  
Get-ChildItem  
  
## Lists the databases from the local default instance.  
## The force parameter is used to include the system databases.  
Set-Location SQLSERVER:\SQL\localhost\DEFAULT\Databases  
Get-ChildItem -force

ls

Set-Location pubs

ls

Set-Location Tables


#################################### GET SERVICE @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

### ARRANCAR Y DETENER SERVICIOS DE SQL

### CONSULTAMOS SERVICIOS DEL SISTEMA U LA SALIDA ES EN UNA VENTANA 
Get-Service | Out-GridView

### CONSULTAMOS LOS SERVICIOS DEL SISTEMA QUE CONTIENE SQL CON SALIDA OUT-GRIDVIEW
Get-Service | Where-Object{$_.name -like '*sql*'} |Out-GridView

### lo mismo pero con ALIAS (? = where-Object) y ()ogv = Out-Griedview)
Get-Service | ?{$_.Name -like '*sql*'} | ogv

### ARRANCAR EL SERVICIO
Start-Service "SQLSERVERAGENT"

### DETENER EL SERVICIO
Stop-Service "SQLSERVERAGENT"

## PARAR EL SERVICIO DE SQL 
Set-Service 'MSSQL$DOWSQL2019' -StartupType Disabled
Stop-Service -Name 'MSSQL$DOWSQL2019' -Force

# PODEMOS EJECUTARLO DESDE UN SCRIPT

PS C:\WINDOWS\system32> & "YOUR PATH\SQLServicesOn.ps1"

powershell.exe -noexit -File “YOUR PATH\SQLServicesOn.ps1”


######################

# Flujos de Codigo

$(get-service | where { $_.Name –eq “winrm” })

get-service | ?{$_.Name -eq "Dhcp"}

get-service | ?{$_.Name -eq "wuauserv"}
get-service | ?{$_.Name -eq "wuauserv"} | %{$_.Start()}
get-service | ?{$_.Name -eq "wuauserv"}
get-service | ?{$_.Name -eq "wuauserv"} | %{$_.Stop()}
Get-Service | Stop-Service -confirm






##################

############################    DBA TOOLS    ###################################################################

# https://dbatools.io/download/

Install-Module dbatools 

https://dbatools.io/soup2nutz/


##esto es para instalarlos solo para el usuario que esta en uso
Install-Module dbatools -Scope CurrentUser

# verify you have dbatools module installed
Get-InstalledModule -Name "dbatools"	

# 1.1.143    dbatools       PSGallery       The community module that enables SQL Server Pros to a..

# Quick overview of commands (RESUMEN DE TODOS LOS COMANDOS) 
Start-Process https://dbatools.io/commands



################################ BACKUP Y RESTORE CON UN CDMLET ####################################


# Almacena los BACKUPS en C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup

Backup-SqlDatabase -ServerInstance "localhost" -Database "Pubs"




# Backup completo con variables y AÑADIENDO LA FECHA


$dt = Get-Date -Format yyyyMMddHHmmss
$instancename = "localhost"
$dbname = 'Trasteros'
Backup-SqlDatabase -Serverinstance $instancename -Database $dbname -BackupFile "c:\BACKUP\$($dbname)_db_$($dt).bak"

##Trasteros_db_20221205204130.bak

