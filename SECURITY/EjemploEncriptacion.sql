--Creamos un login para la BD despues la BD y despues el usuario para ese Login
--Despues creamos la tabla 

USE MASTER
GO
CREATE LOGIN BankManagerLogin WITH PASSWORD='abcd1234.'
GO
CREATE DATABASE Mibanco
GO
USE Mibanco
GO
CREATE USER BankManagerUser FOR LOGIN BankManagerLogin
GO

DROP TABLE IF EXISTS Customers
GO
CREATE TABLE Customers
	(customer_id INT PRIMARY KEY,
	first_name varchar(50) NOT NULL,
	last_name varchar (50) NOT NULL,
	social_security_number varbinary (100) NOT NULL)


--Concedemos permiso y creamos la clave simetrica

GRANT SELECT, INSERT, UPDATE, DELETE ON Customers
TO BankManagerUser
GO

CREATE SYMMETRIC KEY BankManager_User_Key
AUTHORIZATION BankManagerUser
WITH ALGORITHM=AES_256
ENCRYPTION BY PASSWORD='abcd1234.'
GO

--IMPERSONAMOSABRIMOS LA CLAVE SIMETRICO E INSERTAMOS CON LAS CLAVES DE INSERTACION

EXECUTE AS USER='BankManagerUser'
GO
OPEN SYMMETRIC KEY BankManager_User_Key
DECRYPTION BY PASSWORD='abcd1234.'
GO
INSERT INTO Customers VALUES (1,'Howard','Stern',
EncryptByKey(Key_GUID('BankManager_User_Key'),'042-32-1324'))
INSERT INTO Customers VALUES (2,'Donald','Trump',
EncryptByKey(Key_GUID('BankManager_User_Key'),'035-13-6524'))	
INSERT INTO Customers VALUES (3,'Bill','Gates',
EncryptByKey(Key_GUID('BankManager_User_Key'),'553-13-5784'))
GO

SELECT * FROM dbo.Customers
GO

CLOSE ALL SYMMETRIC KEYS
GO



--VAMOS A DESENCRIPTAR

OPEN SYMMETRIC KEY BankMananger_User_Key
DECRYPTION BY PASSWORD ='abcd1234.'
go

SELECT customer_id,first_name + '' + last_name AS [Nombre Cliente],
CONVERT (VARCHAR,DecryptByKey(social_security_number))
as 'Numero Seguridad Social'
FROM Customers
GO


