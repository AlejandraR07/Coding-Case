USE [Data]

/****** Object:  StoredProcedure [dbo].[spAlertEmail]    Script Date: 2025-02-15 08:46:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SpCheckReadPermission]  @Id_Roles INT, @table_name NVARCHAR(250)
AS   

SET NOCOUNT ON;

BEGIN
    DECLARE @Permiso VARCHAR(150);
	--DECLARE @Id_Roles INT = 2
	--DECLARE @table_name VARCHAR(250) = 'TbPagos'
	DECLARE @User VARCHAR(100)
	DECLARE @Id_Usuario INT

    SELECT @Permiso = Tipo_Permiso, @User = TbUs.Usuario, @Id_Usuario = TbUs.Id_Usuarios
	FROM TbRoles AS TbR WITH (NOLOCK)
	INNER JOIN TbUsuarios AS TbUs WITH (NOLOCK)
	ON TbR.Id_Roles = TbUs.Id_Roles
	INNER JOIN TbPermisos AS TbP WITH (NOLOCK)
	ON TbR.Id_Roles = TbP.Id_Roles
    WHERE TbP.Id_Roles = @Id_Roles
    AND Tabla = @table_name;
	
	SELECT 
		CASE WHEN @Permiso = 'NO_ACCESS' THEN 'El usuario: '+@User+' no cuenta con los permisos para la tabla: '+@table_name
			ELSE @Permiso END AS [Message]

	INSERT INTO TbRegistros
	SELECT @Id_Roles AS Id_Role, GETDATE() AS Fecha_Acceso, @Id_Usuario AS Id_Usuarios, @table_name AS Tabla

END;

GO

