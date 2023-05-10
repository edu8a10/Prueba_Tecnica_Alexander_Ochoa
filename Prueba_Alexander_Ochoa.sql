-- [1]. Creacion tabla: [paciente]

CREATE TABLE paciente
(
Id INT IDENTITY(1,1) PRIMARY KEY,
Nombre VARCHAR(250),
TipoDocumento VARCHAR(15),
Documento VARCHAR(50),
FechaNacimiento DATE,
Direccion VARCHAR(250),
Telefono VARCHAR(50) NULL,
Celular VARCHAR(50) NULL,
Correo VARCHAR(250) NULL,
GrupoSanguineo NVARCHAR(5),
RH NVARCHAR(5),
FechaMovimiento DATETIME
)

-- [2]. Creacion tabla: [movimientos]

CREATE TABLE movimientos
(
FechaMovimiento DATE,
HoraMovimiento VARCHAR(15),
TipoMovimiento VARCHAR(15),
DatoAnterior VARCHAR(250),
DatoNuevo VARCHAR(250)
)

-- [3]. Poblar tabla: [paciente]

INSERT INTO paciente

SELECT 'Alexander Ochoa' AS Nombre,
'CC' AS TipoDocumento,
'1030549342' AS Documento,
'12/09/1988' AS FechaNacimiento,
'CR 72F BIS 38D 55 SUR' AS Direccion,
NULL AS Telefono,
'3203241346' AS Celular,
'edu8a10@gmail.com' AS Correo,
'A' AS GrupoSanguineo,
'+' AS RH,
GETDATE()

-- [4]. Creación de PA (insertar):

CREATE PROCEDURE [dbo].[paInsertarPaciente]
AS

	BEGIN

		INSERT INTO [dbo].[movimientos]
		
		SELECT CONVERT(DATE,FechaMovimiento),
		CONVERT(VARCHAR,FechaMovimiento,24),
		'Insert',
		null,
		Nombre
		FROM paciente
		WHERE
		FechaMovimiento=(SELECT MAX(FechaMovimiento) FROM paciente)	

	END

-- [5]. Creacion de trigger (insertar):

 CREATE TRIGGER [dbo].[tgInsertar]
  ON [paciente]
  FOR INSERT
  AS
  
	BEGIN
	
		EXEC [dbo].[paInsertarPaciente]
	
	END

-- Validacion trigger:

INSERT INTO paciente

SELECT 'Edwin Sanchez' AS Nombre,
'CC' AS TipoDocumento,
'1030549342' AS Documento,
'12/09/1988' AS FechaNacimiento,
'CR 72F BIS 38D 55 SUR' AS Direccion,
NULL AS Telefono,
'3203241346' AS Celular,
'edu8a10@gmail.com' AS Correo,
'A' AS GrupoSanguineo,
'+' AS RH,
GETDATE()

SELECT *
FROM paciente

SELECT *
FROM movimientos

-- [6]. Creación de trigger (actualizar):

ALTER TRIGGER [dbo].[tgActualizar]
ON dbo.paciente
FOR UPDATE
AS

IF UPDATE(Nombre) OR UPDATE(TipoDocumento) OR UPDATE(Documento) OR /*UPDATE(FechaNacimiento) OR*/ UPDATE(Direccion) OR UPDATE(Telefono) OR UPDATE(Celular) OR UPDATE(Correo) OR UPDATE(GrupoSanguineo) OR UPDATE(RH)

	BEGIN
	
	INSERT INTO movimientos
	
	SELECT CONVERT(DATE,GETDATE()),
	CONVERT(VARCHAR,GETDATE(),24),
	'Update',
	CASE	WHEN ant.Nombre<>act.Nombre THEN ant.Nombre
			WHEN ant.TipoDocumento<>act.TipoDocumento THEN ant.TipoDocumento
			WHEN ant.Documento<>act.Documento THEN ant.Documento
			--WHEN ant.FechaNacimiento<>act.FechaNacimiento THEN ant.FechaNacimiento
			WHEN ant.Direccion<>act.Direccion THEN ant.Direccion
			WHEN ant.Telefono<>act.Telefono THEN ant.Telefono
			WHEN ant.Celular<>act.Celular THEN ant.Celular
			WHEN ant.Correo<>act.Correo THEN ant.Correo
			WHEN ant.GrupoSanguineo<>act.GrupoSanguineo THEN ant.GrupoSanguineo
			WHEN ant.RH<>act.RH THEN ant.RH
	END,
	CASE	WHEN ant.Nombre<>act.Nombre THEN act.Nombre
			WHEN ant.TipoDocumento<>act.TipoDocumento THEN act.TipoDocumento
			WHEN ant.Documento<>act.Documento THEN act.Documento
			--WHEN ant.FechaNacimiento<>act.FechaNacimiento THEN act.FechaNacimiento
			WHEN ant.Direccion<>act.Direccion THEN act.Direccion
			WHEN ant.Telefono<>act.Telefono THEN act.Telefono
			WHEN ant.Celular<>act.Celular THEN act.Celular
			WHEN ant.Correo<>act.Correo THEN act.Correo
			WHEN ant.GrupoSanguineo<>act.GrupoSanguineo THEN act.GrupoSanguineo
			WHEN ant.RH<>act.RH THEN act.RH
	END
	FROM deleted AS ant
	JOIN inserted AS act ON (act.Id=ant.Id)
	
	END
	
ELSE

	BEGIN
	
	RAISERROR('No es posible modificar los campos que desea actualizar',10,1)

	END

-- Validacion trigger:

SELECT *
FROM paciente

SELECT *
FROM movimientos

UPDATE paciente
SET TipoDocumento='CE'
WHERE
Id=3

-- [7]. Creación de trigger (eliminar):

CREATE TRIGGER [dbo].[tgDelete]
ON dbo.paciente
AFTER DELETE
AS

	BEGIN
	
	INSERT INTO movimientos
	
	SELECT CONVERT(DATE,GETDATE()),
	CONVERT(VARCHAR,GETDATE(),24),
	'Delete',
	del.Nombre,
	null
	FROM deleted AS del
	
	END

-- Validacion trigger:

SELECT *
FROM paciente

SELECT *
FROM movimientos

DELETE FROM PACIENTE WHERE Id=3
