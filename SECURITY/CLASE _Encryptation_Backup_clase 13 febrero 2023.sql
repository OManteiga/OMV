
-- ENCRYPTION BACKUP


-- EXECUTE ON SOURCE SERVER

USE master;
GO
DROP DATABASE IF EXISTS [MyTDETest]
GO
CREATE DATABASE 
GO
USE [MyTDETest]
GO
CREATE TABLE [dbo].[authors](
	[au_id] int NOT NULL,
	[au_lname] [varchar](40) NOT NULL,
	[au_fname] [varchar](20) NOT NULL,
	[phone] [char](12) NOT NULL,
	[address] [varchar](40) NULL,
	[city] [varchar](20) NULL,
	[state] [char](2) NULL,
	[zip] [char](5) NULL,
	[contract] [bit] NOT NULL,
 CONSTRAINT [UPKCL_auidind] PRIMARY KEY CLUSTERED 
(
	[au_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
USE master
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Abcd1234.';
go

--Msg 15578, Level 16, State 1, Line 85
--There is already a master key in the database. Please drop it before performing this statement.

-- INFORMACION EN BD MASTER

CREATE CERTIFICATE MyServerCert 
WITH SUBJECT = 'Mi Certificado Backup';
go


SELECT * 
FROM sys.certificates
GO


USE [MyTDETest];
GO
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE MyServerCert;
GO

-- Warning: The certificate used for encrypting the database encryption key has not been backed up.
-- You should immediately back up the certificate and the private key associated with the certificate. If the certificate ever becomes unavailable or if you must restore or attach the database on another server, you must have backups of both the certificate and the private key or you will not be able to open the database.

ALTER DATABASE [MyTDETest]
SET ENCRYPTION ON;
GO

--ON SOURCE SERVER
USE master
GO

-- Backup database with encryption option & required encryption algorithm
BACKUP DATABASE [MyTDETest]
TO DISK = 'C:\temp\MyTDETest.bak'
WITH
ENCRYPTION
(
ALGORITHM = AES_256,
SERVER CERTIFICATE = MyServerCert
),
STATS = 10,INIT 
GO

--Processed 344 pages for database 'MyTDETest', file 'MyTDETest' on file 1.
--Processed 2 pages for database 'MyTDETest', file 'MyTDETest_log' on file 1.
--BACKUP DATABASE successfully processed 346 pages in 1.872 seconds (1.440 MB/sec).

BACKUP CERTIFICATE MyServerCert
    TO FILE = 'C:\temp\MyServerCert'
    WITH PRIVATE KEY
       ( 
        FILE = 'C:\temp\MyServerCert.pvk' ,
        ENCRYPTION BY PASSWORD = 'ABCD1234.'
      )
go


-- Miro en temp esta MyServerCert y MyTDETest.bak

-- Probando en este Servidor

USE master
GO
DROP DATABASE [MyTDETest]
GO
RESTORE DATABASE [MyTDETest] 
    FROM  DISK = 'C:\temp\MyTDETest.bak' 
    WITH  FILE = 1,  NOUNLOAD,  STATS = 5, 
    MOVE 'MyTDETest' TO 'C:\temp\MyTDETest.mdf',  
    MOVE 'MyTDETest_log' TO 'C:\temp\MyTDETest_log.ldf'
GO

USE [MyTDETest]
GO
SELECT * FROM AUTHORS
GO


-- Nuevo Servidor

USE master
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'abcd1234.';
GO
CREATE CERTIFICATE MyServerCert  
FROM FILE = 'C:\temp\MyServerCert'
GO

-- Error

--Msg 15208, Level 16, State 19, Line 5
--The certificate, asymmetric key, or private key file is not valid or does not exist; or you do not have permissions for it.


-- Concedo permisos crea Certificado pero

-- Intento RESTORE

RESTORE DATABASE [MyTDETest] 
    FROM  DISK = 'C:\temp\MyTDETest.bak' 
    WITH  FILE = 1,  NOUNLOAD,  STATS = 5, 
    MOVE 'MyTDETest' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\MyTDETest.mdf',  
    MOVE 'MyTDETest_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\MyTDETest_log.ldf'
 
GO

--Msg 15507, Level 16, State 1, Line 2
--A key required by this operation appears to be corrupted.
--Msg 3013, Level 16, State 1, Line 2
--RESTORE DATABASE is terminating abnormally.

-- En BOL

-- The ENCRYPTION BY PASSWORD option is not required when the private key will be encrypted with the database master key.
--  Use this option only when the private key will be encrypted with a password. 
--If no password is specified, the private key of the certificate will be encrypted using the database master key. 
-- Omitting this clause will cause an error if the master key of the database cannot be opened.

SELECT * 
FROM sys.certificates
GO

-- MyServerCert	259	1	MK	ENCRYPTED_BY_MASTER_KEY	1	Mi Certificado TDE	1f 26 7e e4 50 83 8f b8 4c 97 38 af 07 0f 0c 44	0x0106000000000009010000002449EBE9576E632A650513F714577948A2B07E26	S-1-9-1-3924511012-711159383-4145218917-1215911700-645836962	Mi Certificado TDE	2020-02-05 17:45:03.000	2019-02-05 17:45:03.000	0x2449EBE9576E632A650513F714577948A2B07E26	NULL	NULL	2048



-- SECOND SERVER

USE master
GO
 
-- If the MASTER KEY doesn't already exist.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'abcd1234.';
go
IF EXISTS (SELECT 1 
	FROM sys.certificates WHERE name = 'MyServerCert')
    DROP CERTIFICATE MyServerCert
GO 

-- Restaurando Certificado en el 2 Servidor

CREATE CERTIFICATE MyServerCert  
    FROM FILE = 'C:\temp\MyServerCert'
     WITH PRIVATE KEY 
      ( 
        FILE = 'C:\temp\MyServerCert.pvk' ,
        DECRYPTION BY PASSWORD = 'ABCD1234.' 
      ) 
GO
 
RESTORE DATABASE [MyTDETest] 
    FROM  DISK = 'C:\temp\MyTDETest.bak' 
    WITH  FILE = 1,  NOUNLOAD,  STATS = 5, 
    MOVE N'MyTDETest' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MyTDETest.mdf',  
    MOVE N'MyTDETest_log' TO 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\MyTDETest_log.ldf'
 
GO


--100 percent processed.
--Processed 360 pages for database 'MyTDETest', file 'MyTDETest' on file 1.
--Processed 2 pages for database 'MyTDETest', file 'MyTDETest_log' on file 1.
--RESTORE DATABASE successfully processed 362 pages in 0.117 seconds (24.172 MB/sec).





