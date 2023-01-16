# Calling a Stored Procedure from PowerShell

Invoke-Sqlcmd -ServerInstance localhost -Database TEMPDB -Query "CustomerSales"



$results = Invoke-Sqlcmd -ServerInstance localhost -Database tempdb -Query "CustomerSales"
foreach ($sale in $results) {Write-Host("Customer: " + $sale.CustomerID + ", TotalSale:$" +$sale.totalsale)}



$results = Invoke-Sqlcmd -ServerInstance localhost -Database tempdb -Query "CustomerSales"
$results | Select-Object CustomerID, totalsale | out-file c:\procesos.txt
notepad c:\procesos.txt

$results = Invoke-Sqlcmd -ServerInstance localhost -Database tempdb -Query "CustomerSales"
$results | Select-Object CustomerID, totalsale | Export-Csv -Path "c:\sales.csv" -NoTypeInformation

notepad c:\sales.csv

# Calling Procs from PowerShell with Parameters

$results = Invoke-Sqlcmd -ServerInstance localhost -Database AdventureWorks2019 -Query "uspGetBillOfMaterials"

$results = Invoke-Sqlcmd -ServerInstance localhost -Database AdventureWorks2019 -Query "[dbo].[uspGetBillOfMaterials] @StartProductID = 749, @CheckDate = '2010-05-26'"
$results 

$productid = 749
$checkdate = "2010-05-26"
$results = Invoke-Sqlcmd -ServerInstance localhost -Database AdventureWorks2019 -Query "[dbo].[uspGetBillOfMaterials] @StartProductID = $productid, @CheckDate = '$checkdate'"
$results | Export-Csv -Path "c:\sproc.csv" -NoTypeInformation
notepad c:\sproc.csv


############################3

# ADO.NET

## Creamos la conexión

$Server = "localhost"
$Database = "AdventureWorks2019"
$SqlConn = New-Object System.Data.SqlClient.SqlConnection("Server = $Server; Database = $Database; Integrated Security = True;")

##Aquí la abrimos

$SqlConn.Open()

##Creamos el objeto (que es un procedimiento de almacenado)

$cmd = $SqlConn.CreateCommand()
$cmd.CommandType = 'StoredProcedure'
$cmd.CommandText = 'dbo.uspGetBillOfMaterials'

## Le añadimos los parámetros de entrada

$p1 = $cmd.Parameters.Add('@StartProductID',[int])
$p1.ParameterDirection.Input
$p1.Value = 749

$p2 = $cmd.Parameters.Add('@CheckDate',[DateTime])
$p2.ParameterDirection.Input
$p2.Value = '2010-05-26'


$results = $cmd.ExecuteReader()
$dt = New-Object System.Data.DataTable
$dt.Load($results)

##Cerramos l
$SqlConn.Close()
$dt | Export-Csv -LiteralPath "C:\sproc.txt" -NoTypeInformation
notepad C:\sproc.txt



##"ProductAssemblyID","ComponentID","ComponentDesc","TotalQuantity","StandardCost","ListPrice","BOMLevel","RecursionLevel"
##"749","820","HL Road Front Wheel","1,00","146,5466","330,0600","1","0"
##"749","828","HL Road Rear Wheel","1,00","158,5346","357,0600","1","0"
##"749","948","Front Brakes","1,00","47,2860","106,5000","1","0"
##"820","401","HL Hub","1,00","0,0000","0,0000","2","1"
##"820","506","Reflector","2,00","0,0000","0,0000","2","1"
##"828","491","HL Nipple","36,00","0,0000","0,0000","2","1"
##"828","527","Spokes","36,00","0,0000","0,0000","2","1"
##"401","524","HL Spindle/Axle","1,00","0,0000","0,0000","3","2"














