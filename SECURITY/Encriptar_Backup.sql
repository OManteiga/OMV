
--CREAMOS BD Y ACTIVAMOS


USE MASTER 
GO

DROP DATABASE IF EXISTS ENCRIPTBACKUP
GO
CREATE DATABASE ENCRIPTBACKUP
GO
USE ENCRIPTBACKUP
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
)

--ACTIVAMOS MASTER Y CREAMOS LA MASTER KEY 

USE MASTER
GO

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'abcd1234.'
GO

--INFORMACIÓN EN BD MASTER
--CREAMOS EL CERTIFICADO

CREATE CERTIFICATE MyServerCert
WITH SUBJECT = 'Mi certificado TDE'
GO


--CONSULTAMOS SI CREO EL CERTIFICADO

SELECT *
FROM sys.certificates
GO


USE ENCRIPTBACKUP
GO

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE MyServerCert
GO


--DA UN WARNING QUE DICE QUE HAY QUE HACER BACKUP DEL CERTIFICADO

--Warning: The certificate used for encrypting the database encryption 
--key has not been backed up. You should immediately back up the certificate and the private key associated with the certificate.
--If the certificate ever becomes unavailable or if you must restore or attach the database on another server,
--you must have backups of both the certificate and the private key or you will not be able to open the database.



--VOLVEMOS A MASTER Y HACEMOS UN BACKUP DE LA BD


USE MASTER
GO

BACKUP DATABASE ENCRIPTBACKUP
TO DISK = 'C:\temp\ENCRIPTBACKUP.bak'
WITH 
ENCRYPTION
(
ALGORITHM = AES_256,
SERVER CERTIFICATE = MyServerCert
),
STATS = 10
GO

--HACEMOS BACKUP DEL CERTIFICADO Y LA CLAVE

BACKUP CERTIFICATE MyServerCert9
	TO FILE = 'C:\temp\MyServerCert'
	WITH PRIVATE KEY 
		(
		FILE = 'C:\temp\MyServerCert.pvk',
		ENCRYPTION BY PASSWORD = 'abcd1234.'
		)
GO

RESTORE DATABASE ENCRIPTBACKUP
	FROM DISK = 'C:\temp\ENCRIPTBACKUP'
	WITH FILE = 1,NOUNLOAD,STATS = 5,
	MOVE N'testBackup' TO 'C:\test',
	MOVE N'testBackup_log' TO 'C:\test'
GO




--RESTAURAMOS EL BACKUP ENCRIPTADO



CREATE CERTIFICATE MyServerCert3---Aqui pones el nombre del certificado que tu quieras
	FROM FILE = 'C:\t\YHCert'
	WITH PRIVATE KEY 
		(
		FILE = 'C:\t\YHCert.pvk',
		DECRYPTION BY PASSWORD = 'abcd1234.'
		)
GO


RESTORE DATABASE testBackup
FROM DISK = 'C:\t\YHtest.bak'
   WITH  FILE = 1,  NOUNLOAD,  STATS = 5
GO
