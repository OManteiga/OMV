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