

---Guardar Imagenes dentro de la base de datos
---Tipo de campo VARBINARY(MAX) .  IMAGE (DEPRECATED)


Use pubs
GO 
DROP TABLE IF EXISTS logo
GO
CREATE Table Logo
(
	LogoId int,
	LogoName varchar(255),
	LogoImage varbinary(max)
)
go


INSERT INTO dbo.Logo
(
	LogoId,
	LogoName,
	LogoImage
)

SELECT 1,'Arbusto',
	*FROM OPENROWSET
	( BULK 'C:\IMAGENES\arbusto.jpg',SINGLE_BLOB) as ImageFile
	GO
	
	INSERT INTO dbo.Logo
(
	LogoId,
	LogoName,
	LogoImage
)

SELECT 2,'Fruta',
	*FROM OPENROWSET
	( BULK 'C:\IMAGENES\fruta.jpg',SINGLE_BLOB) as ImageFile
	GO

	INSERT INTO dbo.Logo
(
	LogoId,
	LogoName,
	LogoImage
)

SELECT 3,'Flor',
	*FROM OPENROWSET
	( BULK 'C:\IMAGENES\flor.jpg',SINGLE_BLOB) as Imagefile
	GO

	SELECT * FROM dbo.Logo
	GO

