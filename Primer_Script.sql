CREATE DATABASE TestDB
GO

USE TestDB
GO

DROP SCHEMA HR
GO

CREATE SCHEMA HR
GO

DROP TABLE IF EXITS HR.Employee
GO

CREATE TABLE HR.Employee
(
	EmployeeID CHAR(2),
	Givename VARCHAR(50),
	Surname VARCHAR(50),
	SSN CHAR(9) --no queremos que los becarios vean esto

)
GO

SELECT * FROM HR.Employee
GO

--EmployeeID	Givename	Surname	SSN
--1 			Luis		Arias		111     
--2 			Ana			 Gomez		222     
--3 			Juan		Perez		333     


DROP VIEW IF EXISTS HR.LookupEmployee
GO

CREATE VIEW HR.LookupEmployee
AS
		SELECT	EmployeeID, Givename, Surname
		FROM HR.Employee
GO


DROP ROLE IF EXISTS HumanresourcesAnalyst
GO

CREATE ROLE HumanresourcesAnalyst
GO

GRANT SELECT ON HR.LookupEmployee TO HumanresourcesAnalyst
GO

DROP USER IF EXISTS JaneDoe
GO
CREATE USER  JaneDoe WITHOUT LOGIN
GO

ALTER ROLE HumanresourcesAnalyst
ADD MEMBER JaneDoe
GO

EXECUTE AS USER = 'JaneDoe'
GO

SELECT * FROM HR.LookupEmployee
GO

PRINT USER 
GO

--JaneDoe


SELECT * FROM HR.Employee
GO

--Msg 229, Level 14, State 5, Line 75
--The SELECT permission was denied on the object 'Employee', database 'TestDB', sc

REVERT 
GO  

PRINT USER
GO

--STORE PROCEDURE

CREATE OR ALTER PROC HR.InsertNewEmployee
		--parametros de entrada
		@EmployeeID INT,
		@Givename VARCHAR(50),
		@Surname VARCHAR(50),
		@SSN CHAR(9)
AS 
BEGIN
INSERT INTO HR.Employee
(EmployeeID, Givename,Surname,SSN)
VALUES
(@EmployeeID, @Givename,@Surname,@SSN );

END

GO

EXEC HR.InsertNewEmployee 1, Luis, Perez,1111
GO

SELECT * FROM HR.Employee
GO


------------------CREAMOS NUEVO ROL


CREATE ROLE HumanResourcesRecruiter
GO

------------------LE DAMOS PERMISO PARA EJECUTAR EN EL SCHEMA HR.

GRANT EXECUTE ON SCHEMA ::[HR] TO HumanResourcesRecruiter
GO
------------------CREAMOS UN USUARIO SIN LOGIN

CREATE USER Juancho WITHOUT LOGIN
GO

---------------------Y LO METEMOS EN EL ROL 

ALTER ROLE HumanResourcesRecruiter
	ADD MEMBER Juancho
GO

------------------EJECUTAMOS COMO JUANCHO


EXECUTE AS USER = 'Juancho'
GO

PRINT USER
GO


----Juancho puede ejecutar el procedimiento de almacenado pero no puede introducir 
---los valores directamente en la tabla porque no tiene permisos

EXEC HR.InsertNewEmployee 5, Noelia, Hermida,5555
GO

---------------CAMBIAMOS A DBO PORQUE JAUNCHO NO TIENE PERMISO DE SELECT 

REVERT
GO

SELECT * FROM HR.Employee
GO

--1 	  Luis	 Arias	 111     
--2 	  Ana	  Gomez	 222     
--3 	  Juan	 Perez	 333     
--1 	Luis	Perez	1111     
--5 	Noelia	Hermida	5555     

