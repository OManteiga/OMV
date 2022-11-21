--Creamos la base de datos

USE master 
go

DROP DATABASE IF EXISTS Trasteros 
GO
CREATE DATABASE [Trasteros] 
	ON PRIMARY ( NAME = 'Trasteros', 
		FILENAME = 'C:\Data\Trasteros_Fijo.mdf' , 
		SIZE = 15360KB , MAXSIZE = UNLIMITED, FILEGROWTH = 0) 
	LOG ON ( NAME = 'Trasteros_log', 
		FILENAME = 'C:\Data\Trasteros_log.ldf' , 
		SIZE = 10176KB , MAXSIZE = 2048GB , FILEGROWTH = 10%) 
GO


USE Trasteros
GO
-- CREAMOS LOS FILEGROUPS
ALTER DATABASE [Trasteros] ADD FILEGROUP [FG_Archivo] 
GO 
ALTER DATABASE [Trasteros] ADD FILEGROUP [FG_2016] 
GO 
ALTER DATABASE [Trasteros] ADD FILEGROUP [FG_2017] 
GO 
ALTER DATABASE [Trasteros] ADD FILEGROUP [FG_2018]
GO

select * from sys.filegroups
GO

-- -- CREAMOS LOS FICHEROS

ALTER DATABASE [Trasteros] ADD FILE ( NAME = 'Alquiler_Archivo', FILENAME = 'c:\DATA_TRASTEROS\Alquiler_Archivo.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_Archivo] 
GO
ALTER DATABASE [Trasteros] ADD FILE ( NAME = 'Alquiler_2016', FILENAME = 'c:\DATA_TRASTEROS\Alquiler_2016.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2016] 
GO
ALTER DATABASE [Trasteros] ADD FILE ( NAME = 'Alquiler_2017', FILENAME = 'c:\DATA_TRASTEROS\Alquiler_2017.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2017] 
GO
ALTER DATABASE [Trasteros] ADD FILE ( NAME = 'Alquiler_2018', FILENAME = 'c:\DATA_TRASTEROS\Alquiler_2018.ndf', SIZE = 5MB, MAXSIZE = 100MB, FILEGROWTH = 2MB ) TO FILEGROUP [FG_2018] 
GO


select * from sys.filegroups
GO

select * from sys.database_files
GO


-- CREAMOS LA FUNCION CON SUS LIMITES

CREATE PARTITION FUNCTION FN_Alquiler_fecha (datetime) 
AS RANGE RIGHT 
	FOR VALUES ('2016-01-01','2017-01-01')
GO

-- CREAMOS EL ESQUEMA DE LA PARTICION

CREATE PARTITION SCHEME Alquiler_fecha 
AS PARTITION FN_Alquiler_fecha 
	TO (FG_Archivo,FG_2016,FG_2017,FG_2018) 
GO

---CREAMOS LA TABLA 

DROP TABLE IF EXISTS Alta_Alquiler
GO
CREATE TABLE Alta_Alquiler
	( id_alta int identity (1,1), 
	nombre varchar(20), 
	apellido varchar (20), 
	fecha_alta datetime ) 
	ON Alquiler_fecha 
		(fecha_alta) 
GO

-- INSERTAMOS DATOS

INSERT INTO Alta_Alquiler 
	Values ('Oliver','Manteiga','2015-01-01'), 
			('Noelia','Hermida','2015-05-05'), 
			('Lenny','Greta','2015-08-11')
Go

-- METADATA INFORMATION

SELECT *,$Partition.FN_Alquiler_fecha(fecha_alta) AS Partition
FROM Alta_Alquiler
GO


--1	Oliver	Manteiga	2015-01-01 00:00:00.000			1
--2	Noelia	Hermida		2015-05-05 00:00:00.000			1
--3	Lenny	Greta		2015-08-11 00:00:00.000			1





--METEMOS OTROS TRES REGISTROS

INSERT INTO Alta_Alquiler 
	VALUES ('Laura','Muñoz','2016-06-23'), 
	('Rosa Maria','Leandro','2016-02-03'), 
	('Federico','Ramos','2016-04-06')
GO

SELECT *,$Partition.FN_Alquiler_fecha(fecha_alta) 
FROM Alta_Alquiler
GO

--1	Oliver	Manteiga	2015-01-01 00:00:00.000	1
--2	Noelia	Hermida		2015-05-05 00:00:00.000	1
--3	Lenny	Greta		2015-08-11 00:00:00.000	1
--4	Laura	Muñoz		2016-06-23 00:00:00.000	2
--5	Rosa Maria	Leandro	2016-02-03 00:00:00.000	2
--6	Federico	Ramos	2016-04-06 00:00:00.000	2



select p.partition_number, p.rows from sys.partitions p 
inner join sys.tables t 
on p.object_id=t.object_id and t.name = 'Alta_Alquiler' 
GO


--1	3
--2	3
--3	0


INSERT INTO Alta_Alquiler 
	VALUES ('Alex','Seijas','2017-05-21'), 
	('Monica','Martinez','2017-07-09'), 
	('Pupo','Rojos','2017-09-12')
GO

--(3 rows affected)

SELECT *,$Partition.FN_Alquiler_fecha(fecha_alta) 
FROM Alta_Alquiler
GO

--1	Oliver	Manteiga	2015-01-01 00:00:00.000	1
--2	Noelia	Hermida	2015-05-05 00:00:00.000	1
--3	Lenny	Greta	2015-08-11 00:00:00.000	1
--4	Laura	Muñoz	2016-06-23 00:00:00.000	2
--5	Rosa Maria	Leandro	2016-02-03 00:00:00.000	2
--6	Federico	Ramos	2016-04-06 00:00:00.000	2
--7	Alex	Seijas	2017-05-21 00:00:00.000	3
--8	Monica	Martinez	2017-07-09 00:00:00.000	3
--9	Pupo	Rojos	2017-09-12 00:00:00.000	3






INSERT INTO Alta_Alquiler 
	VALUES ('Lali','Perez','2018-02-12'), 
	('Pablo','Moure','2018-01-23'), 
	('Jorge','Marcos','2018-02-23')
GO



SELECT *,$Partition.FN_Alquiler_fecha(fecha_alta) as PARTITION
FROM Alta_Alquiler
GO


--1	Oliver	Manteiga			2015-01-01 00:00:00.000		1
--2	Noelia	Hermida				2015-05-05 00:00:00.000		1
--3	Lenny	Greta				2015-08-11 00:00:00.000		1
--4	Laura	Muñoz				2016-06-23 00:00:00.000		2
--5	Rosa Maria	Leandro			2016-02-03 00:00:00.000		2
--6	Federico	Ramos			2016-04-06 00:00:00.000		2
--7	Alex	Seijas				2017-05-21 00:00:00.000		3
--8	Monica	Martinez			2017-07-09 00:00:00.000		3
--9	Pupo	Rojos				2017-09-12 00:00:00.000		3
--10Lali	Perez			2018-02-12 00:00:00.000		3
--11Pablo	Moure			2018-01-23 00:00:00.000		3
--12Jorge	Marcos			2018-02-23 00:00:00.000		3


-------------------------------------------- SPLIT--------------------------------------------
---UTILIZAMOS EL SPLIT PARA DIVIDIR EL ULTIMA PARTICION PARA SEPARAR EL 2017 DEL 2018 y crear otra particion

ALTER PARTITION FUNCTION FN_Alquiler_fecha() 
	SPLIT RANGE ('2018-01-01'); 
GO

SELECT *,$Partition.FN_Alquiler_fecha(fecha_alta) as PARTITION
FROM Alta_Alquiler
GO

--1	Oliver	Manteiga	2015-01-01 00:00:00.000		1
--2	Noelia	Hermida		2015-05-05 00:00:00.000		1
--3	Lenny	Greta		2015-08-11 00:00:00.000		1
--4	Laura	Muñoz		2016-06-23 00:00:00.000		2
--5	Rosa Maria	Leandro	2016-02-03 00:00:00.000		2
--6	Federico	Ramos	2016-04-06 00:00:00.000		2
--7	Alex	Seijas		2017-05-21 00:00:00.000		3
--8	Monica	Martinez	2017-07-09 00:00:00.000		3
--9	Pupo	Rojos		2017-09-12 00:00:00.000		3
--10	Lali	Perez	2018-02-12 00:00:00.000		4
--11	Pablo	Moure	2018-01-23 00:00:00.000		4
--12	Jorge	Marcos	2018-02-23 00:00:00.000		4


-------------------------------------------------------- MERGE--------------------------------------------------

--------------VAMOS A FUSIONAR 

ALTER PARTITION FUNCTION FN_Alquiler_fecha ()
 MERGE RANGE ('2016-01-01'); 
 GO

SELECT *,$Partition.FN_Alquiler_fecha(fecha_alta) 
FROM Alta_Alquiler
GO


--1	Oliver	Manteiga	2015-01-01 00:00:00.000		1
--2	Noelia	Hermida		2015-05-05 00:00:00.000		1
--3	Lenny	Greta		2015-08-11 00:00:00.000		1
--4	Laura	Muñoz		2016-06-23 00:00:00.000		1
--5	Rosa Maria	Leandro	2016-02-03 00:00:00.000		1
--6	Federico	Ramos	2016-04-06 00:00:00.000		1
--7	Alex	Seijas		2017-05-21 00:00:00.000		2
--8	Monica	Martinez	2017-07-09 00:00:00.000		2
--9	Pupo	Rojos		2017-09-12 00:00:00.000		2
--10	Lali	Perez		2018-02-12 00:00:00.000		3
--11	Pablo	Moure		2018-01-23 00:00:00.000		3
--12	Jorge	Marcos		2018-02-23 00:00:00.000		3



------------------------------------- SWITCH---------------------------------------

--La operación SWITCH es una operación interesante para mover datos de forma rápida entre objetos.
--Borramos el fichero y el filegroup


USE master
GO
ALTER DATABASE Trasteros REMOVE FILE Alquiler_2016
go

ALTER DATABASE Trasteros REMOVE FILEGROUP FG_2016 
GO

--The file 'Alquiler_2016' has been removed.
--The filegroup 'FG_2016' has been removed.

--Completion time: 2022-11-21T22:04:01.9845971+01:00


USE Trasteros
go

SELECT *,$Partition.FN_Alquiler_fecha(fecha_alta) 
FROM Alta_Alquiler
GO

--1	Oliver	Manteiga	2015-01-01 00:00:00.000	1
--2	Noelia	Hermida	2015-05-05 00:00:00.000	1
--3	Lenny	Greta	2015-08-11 00:00:00.000	1
--4	Laura	Muñoz	2016-06-23 00:00:00.000	1
--5	Rosa Maria	Leandro	2016-02-03 00:00:00.000	1
--6	Federico	Ramos	2016-04-06 00:00:00.000	1
--7	Alex	Seijas	2017-05-21 00:00:00.000	2
--8	Monica	Martinez	2017-07-09 00:00:00.000	2
--9	Pupo	Rojos	2017-09-12 00:00:00.000	2
--10	Lali	Perez	2018-02-12 00:00:00.000	3
--11	Pablo	Moure	2018-01-23 00:00:00.000	3
--12	Jorge	Marcos	2018-02-23 00:00:00.000	3

CREATE TABLE Alta_Alquiler_nuevo
( id_alta int identity (1,1), 
nombre varchar(20), 
apellido varchar (20), 
fecha_alta datetime ) 
ON FG_Archivo
go


ALTER TABLE Alta_Alquiler 
	SWITCH Partition 1 to Alta_Alquiler_nuevo
go


select * from Alta_Alquiler 
go


--7	Alex	Seijas	2017-05-21 00:00:00.000
--8	Monica	Martinez	2017-07-09 00:00:00.000
--9	Pupo	Rojos	2017-09-12 00:00:00.000
--10	Lali	Perez	2018-02-12 00:00:00.000
--11	Pablo	Moure	2018-01-23 00:00:00.000
--12	Jorge	Marcos	2018-02-23 00:00:00.000


-------------------------------------------------------TRUNCATE------------------------------------------------------

TRUNCATE TABLE Alta_Alquiler 
	WITH (PARTITIONS (3));
go

select * from Alta_Alquiler
GO

--7	Alex	Seijas	2017-05-21 00:00:00.000
--8	Monica	Martinez	2017-07-09 00:00:00.000
--9	Pupo	Rojos	2017-09-12 00:00:00.000