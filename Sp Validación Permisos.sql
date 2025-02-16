USE [Data]

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SpCheckReadPermission]  @Id_Roles INT, @table_name NVARCHAR(250)
AS   

SET NOCOUNT ON;

BEGIN
    DECLARE @Permiso VARCHAR(150);
	--DECLARE @Id_Roles INT = 4
	--DECLARE @table_name VARCHAR(250) = 'TbEmpleados'
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

	Select CASE WHEN @Id_Usuario is null THEN 'Esa persona no cuenta con un usuario'
	ELSE 'Ingreso Exitoso' END AS [Message]

	
	IF @Permiso is not null
		begin
			SELECT 
				CASE WHEN @Permiso = 'NO_ACCESS' THEN 'El usuario: '+@User+' no cuenta con los permisos para la tabla: '+@table_name
					ELSE @Permiso END AS [Message]
		end
	else
		Select 'Sin información por mostrar' as Mensaje

	--INSERT INTO TbRegistros
	--SELECT @Id_Roles AS Id_Role, GETDATE() AS Fecha_Acceso, @Id_Usuario AS Id_Usuarios, @table_name AS Tabla

	IF @Permiso = 'Lectura' AND @Id_Roles = 2
		Begin
			SELECT Id_Empleados,Cedula,Nombre,Fecha_Ingreso
			FROM TbEmpleados 
			WHERE Departamento = 'Ventas'
		End
	Else Select 'Sin permisos para consultar esas tablas' as Mensaje

	IF @Permiso = 'Lectura' AND @Id_Roles = 3
	begin
	SELECT 'Tabla Empleados'  [Data]
	SELECT * FROM TbEmpleados
	SELECT 'Tabla Pagos'  [Data]
	SELECT * FROM TbPagos
	end
	Else Select 'Sin permisos para consultar esas tablas' as Mensaje

	IF @Permiso = 'Lectura' AND @Id_Roles = 4
	Begin
	SELECT 'Tabla Pagos'  [Data]
	SELECT * FROM TbPagos
	End
	ELSE Select 'Sin permisos para consultar esas tablas' as Mensaje
	
END;
