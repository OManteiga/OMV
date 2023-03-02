
--CREAMOS LA BASE DE DATOS 

DROP DATABASE IF EXISTS TrasterosDDM
GO
CREATE DATABASE TrasteroDDM
GO
USE TrasteroDDM
GO

--CREAMOS LA TABLA

DROP TABLE IF EXISTS AlquileresMensuales
GO

CREATE TABLE dbo.AlquileresMensuales (
		AlquilerID int IDENTITY (1,1) NOT NULL PRIMARY KEY,
		FechaAlquile datetime2 (7) NULL,
		Cliente varchar (50) NULL,
		Email varchar (150) NULL,
		Producto varchar(150) NULL,
		PrecioTotal decimal (10,2) NULL
		)
GO

--INSERTAMOS DATOS

SET IDENTITY_INSERT AlquileresMensuales ON

INSERT INTO [dbo].[AlquileresMensuales]([AlquilerID],[FechaAlquile] ,[Cliente]  ,[Email] ,[Producto]  ,[PrecioTotal])  VALUES (1, N'2019-05-01 00:00:00', N'Asif', N'Asif@companytest-0001.com', N'Dell Laptop', CAST(300.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[AlquileresMensuales]([AlquilerID],[FechaAlquile] ,[Cliente]  ,[Email] ,[Producto]  ,[PrecioTotal])   VALUES (2, N'2019-05-02 00:00:00', N'Mike',N'Mike@companytest-0002.com', N'Dell Laptop', CAST(300.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[AlquileresMensuales]([AlquilerID],[FechaAlquile] ,[Cliente]  ,[Email] ,[Producto]  ,[PrecioTotal])  VALUES (3, N'2019-05-02 00:00:00', N'Adil',N'Adil@companytest-0003.com',N'Lenovo Laptop', CAST(350.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[AlquileresMensuales]([AlquilerID],[FechaAlquile] ,[Cliente]  ,[Email] ,[Producto]  ,[PrecioTotal])   VALUES (4, N'2019-05-03 00:00:00', N'Sarah',N'Sarah@companytest-0004', N'HP Laptop', CAST(250.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[AlquileresMensuales]([AlquilerID],[FechaAlquile] ,[Cliente]  ,[Email] ,[Producto]  ,[PrecioTotal])   VALUES (5, N'2019-05-05 00:00:00', N'Asif', N'Asif@companytest-0001.com', N'Dell Desktop', CAST(200.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[AlquileresMensuales]([AlquilerID],[FechaAlquile] ,[Cliente]  ,[Email] ,[Producto]  ,[PrecioTotal])  VALUES (6, N'2019-05-10 00:00:00', N'Sam',N'Sam@companytest-0005', N'HP Desktop', CAST(300.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[AlquileresMensuales]([AlquilerID],[FechaAlquile] ,[Cliente]  ,[Email] ,[Producto]  ,[PrecioTotal])   VALUES (7, N'2019-05-12 00:00:00', N'Mike',N'Mike@companytest-0002.comcom', N'iPad', CAST(250.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[AlquileresMensuales]([AlquilerID],[FechaAlquile] ,[Cliente]  ,[Email] ,[Producto]  ,[PrecioTotal])  VALUES (8, N'2019-05-13 00:00:00', N'Mike',N'Mike@companytest-0002.comcom', N'iPad', CAST(250.00 AS Decimal(10, 2)))
INSERT INTO [dbo].[AlquileresMensuales]([AlquilerID],[FechaAlquile] ,[Cliente]  ,[Email] ,[Producto]  ,[PrecioTotal])     VALUES (9, N'2019-05-20 00:00:00', N'Peter',N'Peter@companytest-0006', N'Dell Laptop', CAST(350.00 AS Decimal(10, 2)))     
INSERT INTO [dbo].[AlquileresMensuales]([AlquilerID],[FechaAlquile] ,[Cliente]  ,[Email] ,[Producto]  ,[PrecioTotal])  VALUES (10, N'2019-05-25 00:00:00', N'Peter',N'Peter@companytest-0006', N'Asus Laptop', CAST(400.00 AS Decimal(10, 2)))
GO
SET IDENTITY_INSERT AlquileresMensuales OFF
GO
          
--CREAMOS USUARIO SIN LOGIN


DROP USER IF EXISTS DDMUSER
GO
CREATE USER DDMUSER WITHOUT LOGIN
GO
GRANT SELECT ON AlquileresMensuales TO DDMUSER
GO


--CREAMOS UN PROCEDIMIENTO DE ALMACENADO

CREATE OR ALTER PROC ShowMaskingStatus
AS 
BEGIN  
			SET NOCOUNT ON
			SELECT c.name ,tbl.name as table_name , c.is_masked, c.masking_function
			FROM sys.masked_columns AS c
			JOIN sys.tables AS  tbl
				ON c.object_id = tbl.object_id
			WHERE is_masked = 1
END
GO

EXEC ShowMaskingStatus
GO

---ESTOS  SON LOS CUATRO TIPOS DE DDM










--ENMASCARAMOS LA COLUMNA DE LA TABLA 'EMAIL' 


ALTER TABLE AlquileresMensuales
ALTER COLUMN Email varchar(200) MASKED WITH (FUNCTION = 'default()')
GO

EXEC ShowMaskingStatus
GO

 --IMPERSONAMOS Y HACEMOS LA SELECT PARA VER COMO ENMASCARA LA COLUMNA EMAIL

EXECUTE AS USER = 'DDMUSER'
GO

PRINT USER
GO

SELECT * FROM AlquileresMensuales
GO


--1	2019-05-01 00:00:00.0000000	Asif	xxxx	Dell Laptop		300.00
--2	2019-05-02 00:00:00.0000000	Mike	xxxx	Dell Laptop		300.00
--3	2019-05-02 00:00:00.0000000	Adil	xxxx	Lenovo Laptop	350.00
--4	2019-05-03 00:00:00.0000000	Sarah	xxxx	HP Laptop		250.00
--5	2019-05-05 00:00:00.0000000	Asif	xxxx	Dell Desktop	200.00
--6	2019-05-10 00:00:00.0000000	Sam		xxxx	HP Desktop		300.00
--7	2019-05-12 00:00:00.0000000	Mike	xxxx	iPad			250.00
--8	2019-05-13 00:00:00.0000000	Mike	xxxx	iPad			250.00
--9	2019-05-20 00:00:00.0000000	Peter	xxxx	Dell Laptop		350.00
--102019-05-25 00:00:00.0000000	Peter	xxxx	Asus Laptop		400.00



--VUELVO A DBO Y HAGO SELECT PARA VER QUE EL DBO SI QUE LO VE

REVERT 
GO

SELECT * FROM AlquileresMensuales
GO

--SELECT Email FROM AlquileresMensuales

--1	2019-05-01 00:00:00.0000000	Asif	Asif@companytest-0001.com	Dell Laptop		300.00
--2	2019-05-02 00:00:00.0000000	Mike	Mike@companytest-0002.com	Dell Laptop		300.00
--3	2019-05-02 00:00:00.0000000	Adil	Adil@companytest-0003.com	Lenovo Laptop	350.00
--4	2019-05-03 00:00:00.0000000	Sarah	Sarah@companytest-0004		HP Laptop		250.00
--5	2019-05-05 00:00:00.0000000	Asif	Asif@companytest-0001.com	Dell Desktop	200.00
--6	2019-05-10 00:00:00.0000000	Sam		Sam@companytest-0005		HP Desktop		300.00
--7	2019-05-12 00:00:00.0000000	Mike	Mike@companytest-0002.comcom	iPad		250.00
--8	2019-05-13 00:00:00.0000000	Mike	Mike@companytest-0002.comcom	iPad		250.00
--9	2019-05-20 00:00:00.0000000	Peter	Peter@companytest-0006		Dell Laptop		350.00
--10	2019-05-25 00:00:00.0000000	Peter	Peter@companytest-0006		Asus Laptop		400.00




ALTER TABLE AlquileresMensuales
	ALTER COLUMN Cliente ADD MASKED WITH (FUNCTION = 'partial(1,"XXXXXXXXX",0)')  --- 1 ES PARA QUE ENSEÑE EL PRIMER CARACTER Y EL 0 PARA QUE NO AÑADA NADA MÁS
GO

 --Y MIRAMOS CON EL PROC QUE TABLAS ESTAMOS ENMASCARANDO

EXEC ShowMaskingStatus
GO


--VOLVEMOS AL USUARIO DE ANTES Y HACEMOS LA SELECT PARA VER QUE NOS ENMASCARO LA COLUMNA


EXECUTE AS USER = 'DDMUSER'
GO

PRINT USER
GO


SELECT Cliente, Email FROM AlquileresMensuales
GO


--AXXXXXXXXX	xxxx
--MXXXXXXXXX	xxxx
--AXXXXXXXXX	xxxx
--SXXXXXXXXX	xxxx
--AXXXXXXXXX	xxxx
--SXXXXXXXXX	xxxx
--MXXXXXXXXX	xxxx
--MXXXXXXXXX	xxxx
--PXXXXXXXXX	xxxx
--PXXXXXXXXX	xxxx



REVERT
GO

PRINT USER
GO

SELECT s.Cliente, s.Email FROM AlquileresMensuales s
GO

--Asif	Asif@companytest-0001.com
--Mike	Mike@companytest-0002.com
--Adil	Adil@companytest-0003.com
--Sarah	Sarah@companytest-0004
--Asif	Asif@companytest-0001.com
--Sam	Sam@companytest-0005
--Mike	Mike@companytest-0002.comcom
--Mike	Mike@companytest-0002.comcom
--Peter	Peter@companytest-0006
--Peter	Peter@companytest-0006





--------------DIINAMIC RANDO (GENERA UN NUMERO ALEATORIO)



ALTER TABLE AlquileresMensuales
	ALTER COLUMN PrecioTotal decimal (10,2) MASKED WITH (FUNCTION = 'random(1,12)')
GO


EXEC ShowMaskingStatus
GO

------Cliente		AlquileresMensuales	1	partial(1, "XXXXXXXXX", 0)
------Email			AlquileresMensuales	1	default()
------PrecioTotal	AlquileresMensuales	1	random(1.00, 12.00)


--VOLVEMOS AL USUARIO Y HACEMOS LA SELECT PARA VER COMO NOS VARIA LOS PRECIOS DE LOS PRODUCTOS


EXECUTE AS USER = 'DDMUSER'
GO

PRINT USER
GO

SELECT s.PrecioTotal FROM AlquileresMensuales s
go

--7.62
--1.69
--11.43
--10.05
--1.28
--11.44
--1.32
--11.27
--9.32
--1.54

REVERT 
GO


-------CUSTOM STRING DYNAMIC DATA MASKING OF PRODUCT COLUMN

ALTER TABLE AlquileresMensuales
	ALTER COLUMN Producto ADD MASKED WITH (FUNCTION = 'partial(1,"---",1)')
GO

EXEC ShowMaskingStatus
GO


--Cliente		AlquileresMensuales	1	partial(1, "XXXXXXXXX", 0)
--Email		AlquileresMensuales	1	default()
--Producto	AlquileresMensuales	1	partial(1, "---", 1)
--PrecioTotal	AlquileresMensuales	1	random(1.00, 12.00)


--VOLVEMOS AL USUARIO Y HACEMOS LA SELECT PARA VER COMO NOS VARIA  DE LOS PRODUCTOS


EXECUTE AS USER = 'DDMUSER'
GO

PRINT USER
GO


SELECT	* FROM AlquileresMensuales
GO

--1	2019-05-01 00:00:00.0000000	AXXXXXXXXX	xxxx	D---p	3.91
--2	2019-05-02 00:00:00.0000000	MXXXXXXXXX	xxxx	D---p	2.32
--3	2019-05-02 00:00:00.0000000	AXXXXXXXXX	xxxx	L---p	2.08
--4	2019-05-03 00:00:00.0000000	SXXXXXXXXX	xxxx	H---p	11.44
--5	2019-05-05 00:00:00.0000000	AXXXXXXXXX	xxxx	D---p	7.56
--6	2019-05-10 00:00:00.0000000	SXXXXXXXXX	xxxx	H---p	11.09
--7	2019-05-12 00:00:00.0000000	MXXXXXXXXX	xxxx	i---d	5.43
--8	2019-05-13 00:00:00.0000000	MXXXXXXXXX	xxxx	i---d	11.03
--9	2019-05-20 00:00:00.0000000	PXXXXXXXXX	xxxx	D---p	11.36
--102019-05-25 00:00:00.0000000	PXXXXXXXXX	xxxx	A---p	11.84


REVERT
GO

SELECT	* FROM AlquileresMensuales
GO


--1	2019-05-01 00:00:00.0000000	Asif	Asif@companytest-0001.com	Dell Laptop	300.00
--2	2019-05-02 00:00:00.0000000	Mike	Mike@companytest-0002.com	Dell Laptop	300.00
--3	2019-05-02 00:00:00.0000000	Adil	Adil@companytest-0003.com	Lenovo Laptop	350.00
--4	2019-05-03 00:00:00.0000000	Sarah	Sarah@companytest-0004	HP Laptop	250.00
--5	2019-05-05 00:00:00.0000000	Asif	Asif@companytest-0001.com	Dell Desktop	200.00
--6	2019-05-10 00:00:00.0000000	Sam	Sam@companytest-0005	HP Desktop	300.00
--7	2019-05-12 00:00:00.0000000	Mike	Mike@companytest-0002.comcom	iPad	250.00
--8	2019-05-13 00:00:00.0000000	Mike	Mike@companytest-0002.comcom	iPad	250.00
--9	2019-05-20 00:00:00.0000000	Peter	Peter@companytest-0006	Dell Laptop	350.00
--10	2019-05-25 00:00:00.0000000	Peter	Peter@companytest-0006	Asus Laptop	400.00






--AHORA LE VAMOS A DAR EL PERMISO AL USER 'DDMUSER' PARA QUE VEA LAS COLUMNAS QUE ESTAN ENMASCARADAAS  (A PARTIR DE LA NUEVA VERSION DE SMSS SE PUEDE DAR PERMISOS POR COLUMNA EN VEZ DE POR TABLA)



GRANT UNMASK TO DDMUSER
GO


EXECUTE AS USER = 'DDMUSER'
GO

PRINT USER
GO

SELECT	* FROM AlquileresMensuales
GO

--1	2019-05-01 00:00:00.0000000	Asif	Asif@companytest-0001.com		Dell Laptop		300.00
--2	2019-05-02 00:00:00.0000000	Mike	Mike@companytest-0002.com		Dell Laptop		300.00
--3	2019-05-02 00:00:00.0000000	Adil	Adil@companytest-0003.com		Lenovo Laptop	350.00
--4	2019-05-03 00:00:00.0000000	Sarah	Sarah@companytest-0004			HP Laptop		250.00
--5	2019-05-05 00:00:00.0000000	Asif	Asif@companytest-0001.com		Dell Desktop	200.00
--6	2019-05-10 00:00:00.0000000	Sam		Sam@companytest-0005			HP Desktop		300.00
--7	2019-05-12 00:00:00.0000000	Mike	Mike@companytest-0002.comcom	iPad			250.00
--8	2019-05-13 00:00:00.0000000	Mike	Mike@companytest-0002.comcom	iPad			250.00
--9	2019-05-20 00:00:00.0000000	Peter	Peter@companytest-0006			Dell Laptop		350.00
--102019-05-25 00:00:00.0000000	Peter	Peter@companytest-0006			Asus Laptop		400.00




--AHOTA VAMOS A QUITAR LA MASCARA A LA COLUMNA DEL EMAIL


REVERT
GO
PRINT USER
GO


ALTER TABLE AlquileresMensuales
	ALTER COLUMN Email DROP MASKED
GO


EXEC ShowMaskingStatus
GO

SELECT s.Email FROM AlquileresMensuales s
GO

--Asif@companytest-0001.com
--Mike@companytest-0002.com
--Adil@companytest-0003.com
--Sarah@companytest-0004
--Asif@companytest-0001.com
--Sam@companytest-0005
--Mike@companytest-0002.comcom
--Mike@companytest-0002.comcom
--Peter@companytest-0006
--Peter@companytest-0006



-----QUITAMOS EL PERMISO AL USUARIO Y MIRAMOS QUE NO VEMOS LAS COLUMNAS

REVOKE UNMASK TO DDMUSER
GO

EXECUTE AS USER = 'DDMUSER'
GO

PRINT USER
GO

SELECT * FROM AlquileresMensuales
GO


--1	2019-05-01 00:00:00.0000000	AXXXXXXXXX	Asif@companytest-0001.com		D---p	3.91
--2	2019-05-02 00:00:00.0000000	MXXXXXXXXX	Mike@companytest-0002.com		D---p	2.32
--3	2019-05-02 00:00:00.0000000	AXXXXXXXXX	Adil@companytest-0003.com		L---p	2.08
--4	2019-05-03 00:00:00.0000000	SXXXXXXXXX	Sarah@companytest-0004			H---p	11.44
--5	2019-05-05 00:00:00.0000000	AXXXXXXXXX	Asif@companytest-0001.com		D---p	7.56
--6	2019-05-10 00:00:00.0000000	SXXXXXXXXX	Sam@companytest-0005			H---p	11.09
--7	2019-05-12 00:00:00.0000000	MXXXXXXXXX	Mike@companytest-0002.comcom	i---d	5.43
--8	2019-05-13 00:00:00.0000000	MXXXXXXXXX	Mike@companytest-0002.comcom	i---d	11.03
--9	2019-05-20 00:00:00.0000000	PXXXXXXXXX	Peter@companytest-0006			D---p	11.36
--102019-05-25 00:00:00.0000000	PXXXXXXXXX	Peter@companytest-0006			A---p	11.84