USE [master]
GO
/****** Object:  Database [Permisos]    Script Date: 16/02/2025 11:26:08 p. m. ******/
CREATE DATABASE [Permisos]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Permisos', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Permisos.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Permisos_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Permisos_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Permisos] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Permisos].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Permisos] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Permisos] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Permisos] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Permisos] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Permisos] SET ARITHABORT OFF 
GO
ALTER DATABASE [Permisos] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Permisos] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Permisos] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Permisos] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Permisos] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Permisos] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Permisos] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Permisos] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Permisos] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Permisos] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Permisos] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Permisos] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Permisos] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Permisos] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Permisos] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Permisos] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Permisos] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Permisos] SET RECOVERY FULL 
GO
ALTER DATABASE [Permisos] SET  MULTI_USER 
GO
ALTER DATABASE [Permisos] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Permisos] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Permisos] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Permisos] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Permisos] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Permisos] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Permisos', N'ON'
GO
ALTER DATABASE [Permisos] SET QUERY_STORE = OFF
GO
USE [Permisos]
GO
/****** Object:  User [DjangoUser]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE USER [DjangoUser] FOR LOGIN [DjangoUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [DjangoUser]
GO
ALTER ROLE [db_datareader] ADD MEMBER [DjangoUser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [DjangoUser]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_VerificarAcceso]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[fn_VerificarAcceso](@usuario_id INT, @tabla VARCHAR(200))
RETURNS BIT
AS
BEGIN
    DECLARE @permiso BIT = 0;

    SELECT 
        @permiso = COALESCE(CASE WHEN P.Tipo_Permiso = 'NO_ACCESS' THEN 0 ELSE 1 END, 0)
    FROM TbPermisos P
    JOIN TbUsuarios U ON P.Id_Roles = U.Id_Roles
    WHERE U.Id_Usuarios = @usuario_id  
    AND P.Tabla = @tabla;

    RETURN @permiso;
END;

GO
/****** Object:  Table [dbo].[TbEmpleados]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbEmpleados](
	[Id_Empleados] [int] IDENTITY(1,1) NOT NULL,
	[Cedula] [int] NULL,
	[Nombre] [varchar](300) NULL,
	[Direccion] [varchar](150) NULL,
	[Fecha_Ingreso] [date] NULL,
	[Id_Roles] [int] NULL,
	[Departamento] [nchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Empleados] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_TbEmpleados] UNIQUE NONCLUSTERED 
(
	[Id_Empleados] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TbPagos]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbPagos](
	[Id_Pagos] [int] IDENTITY(1,1) NOT NULL,
	[Id_Empleados] [int] NULL,
	[Cantidad] [decimal](16, 6) NULL,
	[Fecha_Pago] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Pagos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_TbPagos] UNIQUE NONCLUSTERED 
(
	[Id_Pagos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TbRoles]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbRoles](
	[Id_Roles] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion_Rol] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Roles] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_TbRoles] UNIQUE NONCLUSTERED 
(
	[Id_Roles] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TbUsuarios]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbUsuarios](
	[Id_Usuarios] [int] IDENTITY(1,1) NOT NULL,
	[Usuario] [varchar](250) NULL,
	[Id_Empleados] [int] NULL,
	[Id_Roles] [int] NULL,
	[Departamento] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Usuarios] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_TbUsuarios] UNIQUE NONCLUSTERED 
(
	[Id_Usuarios] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TbPermisos]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbPermisos](
	[Id_Permisos] [int] IDENTITY(1,1) NOT NULL,
	[Id_Roles] [int] NULL,
	[Tabla] [varchar](200) NULL,
	[Tipo_Permiso] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Permisos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_TbPermisos] UNIQUE NONCLUSTERED 
(
	[Id_Permisos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_pagos]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_pagos]
AS
SELECT        pag.Id_Empleados, pag.Cantidad, pag.Fecha_Pago, r.Id_Roles,r.Descripcion_Rol, u.Departamento, p.Tipo_Permiso 
FROM            dbo.TbPagos AS pag INNER JOIN
                         dbo.TbPermisos AS p ON p.Tabla = 'TbPagos' INNER JOIN
                         dbo.TbRoles AS r ON r.Id_Roles = p.Id_Roles INNER JOIN
                         dbo.TbUsuarios AS u ON u.Id_Roles = r.Id_Roles
WHERE        (r.Descripcion_Rol = 'Gerente') AND (pag.Id_Empleados IN
                             (SELECT        Id_Empleados
                               FROM            dbo.TbEmpleados e
                               WHERE        (e.Departamento = u.Departamento))) OR
                         (r.Descripcion_Rol = 'UserSpecific')
GO
/****** Object:  View [dbo].[vw_Empleados_Con_Permisos]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_Empleados_Con_Permisos] AS
SELECT e.*
FROM TbEmpleados e
JOIN TbUsuarios u ON e.Id_Empleados = u.Id_Empleados
JOIN TbPermisos p ON u.Id_Roles = p.Id_Roles
WHERE p.Tabla = 'TbEmpleados';
GO
/****** Object:  Table [dbo].[auth_group]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_group](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](150) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [auth_group_name_a6ea08ec_uniq] UNIQUE NONCLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_group_permissions]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_group_permissions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[group_id] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_permission]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_permission](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[content_type_id] [int] NOT NULL,
	[codename] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[password] [nvarchar](128) NOT NULL,
	[last_login] [datetimeoffset](7) NULL,
	[is_superuser] [bit] NOT NULL,
	[username] [nvarchar](150) NOT NULL,
	[first_name] [nvarchar](150) NOT NULL,
	[last_name] [nvarchar](150) NOT NULL,
	[email] [nvarchar](254) NOT NULL,
	[is_staff] [bit] NOT NULL,
	[is_active] [bit] NOT NULL,
	[date_joined] [datetimeoffset](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [auth_user_username_6821ab7c_uniq] UNIQUE NONCLUSTERED 
(
	[username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user_groups]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user_groups](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[group_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[auth_user_user_permissions]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[auth_user_user_permissions](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NOT NULL,
	[permission_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_admin_log]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_admin_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[action_time] [datetimeoffset](7) NOT NULL,
	[object_id] [nvarchar](max) NULL,
	[object_repr] [nvarchar](200) NOT NULL,
	[action_flag] [smallint] NOT NULL,
	[change_message] [nvarchar](max) NOT NULL,
	[content_type_id] [int] NULL,
	[user_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_content_type]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_content_type](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[app_label] [nvarchar](100) NOT NULL,
	[model] [nvarchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_migrations]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_migrations](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[app] [nvarchar](255) NOT NULL,
	[name] [nvarchar](255) NOT NULL,
	[applied] [datetimeoffset](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[django_session]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[django_session](
	[session_key] [nvarchar](40) NOT NULL,
	[session_data] [nvarchar](max) NOT NULL,
	[expire_date] [datetimeoffset](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[session_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[TbRegistros]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TbRegistros](
	[Id_Registros] [int] IDENTITY(1,1) NOT NULL,
	[Id_Roles] [int] NULL,
	[Fecha_Acceso] [date] NULL,
	[Id_Usuarios] [int] NULL,
	[Tabla] [varchar](200) NULL,
	[Tipo_Permiso] [nchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_Registros] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UC_TbRegistros] UNIQUE NONCLUSTERED 
(
	[Id_Registros] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[token_blacklist_blacklistedtoken]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[token_blacklist_blacklistedtoken](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[blacklisted_at] [datetimeoffset](7) NOT NULL,
	[token_id] [bigint] NOT NULL,
 CONSTRAINT [token_blacklist_blacklistedtoken_id_e1c86975_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[token_blacklist_outstandingtoken]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[token_blacklist_outstandingtoken](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[token] [nvarchar](max) NOT NULL,
	[created_at] [datetimeoffset](7) NULL,
	[expires_at] [datetimeoffset](7) NOT NULL,
	[user_id] [int] NULL,
	[jti] [nvarchar](255) NOT NULL,
 CONSTRAINT [token_blacklist_outstandingtoken_id_69982597_pk] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [token_blacklist_outstandingtoken_jti_hex_d9bdf6f7_uniq] UNIQUE NONCLUSTERED 
(
	[jti] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [auth_group_permissions_group_id_b120cbf9]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE NONCLUSTERED INDEX [auth_group_permissions_group_id_b120cbf9] ON [dbo].[auth_group_permissions]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_group_permissions_group_id_permission_id_0cd325b0_uniq]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [auth_group_permissions_group_id_permission_id_0cd325b0_uniq] ON [dbo].[auth_group_permissions]
(
	[group_id] ASC,
	[permission_id] ASC
)
WHERE ([group_id] IS NOT NULL AND [permission_id] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_group_permissions_permission_id_84c5c92e]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE NONCLUSTERED INDEX [auth_group_permissions_permission_id_84c5c92e] ON [dbo].[auth_group_permissions]
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_permission_content_type_id_2f476e4b]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE NONCLUSTERED INDEX [auth_permission_content_type_id_2f476e4b] ON [dbo].[auth_permission]
(
	[content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [auth_permission_content_type_id_codename_01ab375a_uniq]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [auth_permission_content_type_id_codename_01ab375a_uniq] ON [dbo].[auth_permission]
(
	[content_type_id] ASC,
	[codename] ASC
)
WHERE ([content_type_id] IS NOT NULL AND [codename] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_groups_group_id_97559544]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE NONCLUSTERED INDEX [auth_user_groups_group_id_97559544] ON [dbo].[auth_user_groups]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_groups_user_id_6a12ed8b]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE NONCLUSTERED INDEX [auth_user_groups_user_id_6a12ed8b] ON [dbo].[auth_user_groups]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_groups_user_id_group_id_94350c0c_uniq]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [auth_user_groups_user_id_group_id_94350c0c_uniq] ON [dbo].[auth_user_groups]
(
	[user_id] ASC,
	[group_id] ASC
)
WHERE ([user_id] IS NOT NULL AND [group_id] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_user_permissions_permission_id_1fbb5f2c]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE NONCLUSTERED INDEX [auth_user_user_permissions_permission_id_1fbb5f2c] ON [dbo].[auth_user_user_permissions]
(
	[permission_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_user_permissions_user_id_a95ead1b]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE NONCLUSTERED INDEX [auth_user_user_permissions_user_id_a95ead1b] ON [dbo].[auth_user_user_permissions]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [auth_user_user_permissions_user_id_permission_id_14a6b632_uniq]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [auth_user_user_permissions_user_id_permission_id_14a6b632_uniq] ON [dbo].[auth_user_user_permissions]
(
	[user_id] ASC,
	[permission_id] ASC
)
WHERE ([user_id] IS NOT NULL AND [permission_id] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [django_admin_log_content_type_id_c4bce8eb]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE NONCLUSTERED INDEX [django_admin_log_content_type_id_c4bce8eb] ON [dbo].[django_admin_log]
(
	[content_type_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [django_admin_log_user_id_c564eba6]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE NONCLUSTERED INDEX [django_admin_log_user_id_c564eba6] ON [dbo].[django_admin_log]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [django_content_type_app_label_model_76bd3d3b_uniq]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE UNIQUE NONCLUSTERED INDEX [django_content_type_app_label_model_76bd3d3b_uniq] ON [dbo].[django_content_type]
(
	[app_label] ASC,
	[model] ASC
)
WHERE ([app_label] IS NOT NULL AND [model] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [django_session_expire_date_a5c62663]    Script Date: 16/02/2025 11:26:09 p. m. ******/
CREATE NONCLUSTERED INDEX [django_session_expire_date_a5c62663] ON [dbo].[django_session]
(
	[expire_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[auth_group_permissions]  WITH CHECK ADD  CONSTRAINT [auth_group_permissions_group_id_b120cbf9_fk_auth_group_id] FOREIGN KEY([group_id])
REFERENCES [dbo].[auth_group] ([id])
GO
ALTER TABLE [dbo].[auth_group_permissions] CHECK CONSTRAINT [auth_group_permissions_group_id_b120cbf9_fk_auth_group_id]
GO
ALTER TABLE [dbo].[auth_group_permissions]  WITH CHECK ADD  CONSTRAINT [auth_group_permissions_permission_id_84c5c92e_fk_auth_permission_id] FOREIGN KEY([permission_id])
REFERENCES [dbo].[auth_permission] ([id])
GO
ALTER TABLE [dbo].[auth_group_permissions] CHECK CONSTRAINT [auth_group_permissions_permission_id_84c5c92e_fk_auth_permission_id]
GO
ALTER TABLE [dbo].[auth_permission]  WITH CHECK ADD  CONSTRAINT [auth_permission_content_type_id_2f476e4b_fk_django_content_type_id] FOREIGN KEY([content_type_id])
REFERENCES [dbo].[django_content_type] ([id])
GO
ALTER TABLE [dbo].[auth_permission] CHECK CONSTRAINT [auth_permission_content_type_id_2f476e4b_fk_django_content_type_id]
GO
ALTER TABLE [dbo].[auth_user_groups]  WITH CHECK ADD  CONSTRAINT [auth_user_groups_group_id_97559544_fk_auth_group_id] FOREIGN KEY([group_id])
REFERENCES [dbo].[auth_group] ([id])
GO
ALTER TABLE [dbo].[auth_user_groups] CHECK CONSTRAINT [auth_user_groups_group_id_97559544_fk_auth_group_id]
GO
ALTER TABLE [dbo].[auth_user_groups]  WITH CHECK ADD  CONSTRAINT [auth_user_groups_user_id_6a12ed8b_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[auth_user_groups] CHECK CONSTRAINT [auth_user_groups_user_id_6a12ed8b_fk_auth_user_id]
GO
ALTER TABLE [dbo].[auth_user_user_permissions]  WITH CHECK ADD  CONSTRAINT [auth_user_user_permissions_permission_id_1fbb5f2c_fk_auth_permission_id] FOREIGN KEY([permission_id])
REFERENCES [dbo].[auth_permission] ([id])
GO
ALTER TABLE [dbo].[auth_user_user_permissions] CHECK CONSTRAINT [auth_user_user_permissions_permission_id_1fbb5f2c_fk_auth_permission_id]
GO
ALTER TABLE [dbo].[auth_user_user_permissions]  WITH CHECK ADD  CONSTRAINT [auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[auth_user_user_permissions] CHECK CONSTRAINT [auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_content_type_id_c4bce8eb_fk_django_content_type_id] FOREIGN KEY([content_type_id])
REFERENCES [dbo].[django_content_type] ([id])
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_content_type_id_c4bce8eb_fk_django_content_type_id]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_user_id_c564eba6_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_user_id_c564eba6_fk_auth_user_id]
GO
ALTER TABLE [dbo].[TbEmpleados]  WITH CHECK ADD  CONSTRAINT [FK_Empleado_Rol] FOREIGN KEY([Id_Roles])
REFERENCES [dbo].[TbRoles] ([Id_Roles])
GO
ALTER TABLE [dbo].[TbEmpleados] CHECK CONSTRAINT [FK_Empleado_Rol]
GO
ALTER TABLE [dbo].[TbPagos]  WITH CHECK ADD  CONSTRAINT [FK_Pagos_Empleado] FOREIGN KEY([Id_Empleados])
REFERENCES [dbo].[TbEmpleados] ([Id_Empleados])
GO
ALTER TABLE [dbo].[TbPagos] CHECK CONSTRAINT [FK_Pagos_Empleado]
GO
ALTER TABLE [dbo].[TbPermisos]  WITH CHECK ADD  CONSTRAINT [FK_Permisos_Rol] FOREIGN KEY([Id_Roles])
REFERENCES [dbo].[TbRoles] ([Id_Roles])
GO
ALTER TABLE [dbo].[TbPermisos] CHECK CONSTRAINT [FK_Permisos_Rol]
GO
ALTER TABLE [dbo].[TbRegistros]  WITH CHECK ADD  CONSTRAINT [FK_Registros_Rol] FOREIGN KEY([Id_Roles])
REFERENCES [dbo].[TbRoles] ([Id_Roles])
GO
ALTER TABLE [dbo].[TbRegistros] CHECK CONSTRAINT [FK_Registros_Rol]
GO
ALTER TABLE [dbo].[TbRegistros]  WITH CHECK ADD  CONSTRAINT [FK_Registros_Usuario] FOREIGN KEY([Id_Usuarios])
REFERENCES [dbo].[TbUsuarios] ([Id_Usuarios])
GO
ALTER TABLE [dbo].[TbRegistros] CHECK CONSTRAINT [FK_Registros_Usuario]
GO
ALTER TABLE [dbo].[TbUsuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_Empleado] FOREIGN KEY([Id_Empleados])
REFERENCES [dbo].[TbEmpleados] ([Id_Empleados])
GO
ALTER TABLE [dbo].[TbUsuarios] CHECK CONSTRAINT [FK_Usuarios_Empleado]
GO
ALTER TABLE [dbo].[TbUsuarios]  WITH CHECK ADD  CONSTRAINT [FK_Usuarios_Rol] FOREIGN KEY([Id_Roles])
REFERENCES [dbo].[TbRoles] ([Id_Roles])
GO
ALTER TABLE [dbo].[TbUsuarios] CHECK CONSTRAINT [FK_Usuarios_Rol]
GO
ALTER TABLE [dbo].[token_blacklist_blacklistedtoken]  WITH CHECK ADD  CONSTRAINT [token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk] FOREIGN KEY([token_id])
REFERENCES [dbo].[token_blacklist_outstandingtoken] ([id])
GO
ALTER TABLE [dbo].[token_blacklist_blacklistedtoken] CHECK CONSTRAINT [token_blacklist_blacklistedtoken_token_id_3cc7fe56_fk]
GO
ALTER TABLE [dbo].[token_blacklist_outstandingtoken]  WITH CHECK ADD  CONSTRAINT [token_blacklist_outstandingtoken_user_id_83bc629a_fk_auth_user_id] FOREIGN KEY([user_id])
REFERENCES [dbo].[auth_user] ([id])
GO
ALTER TABLE [dbo].[token_blacklist_outstandingtoken] CHECK CONSTRAINT [token_blacklist_outstandingtoken_user_id_83bc629a_fk_auth_user_id]
GO
ALTER TABLE [dbo].[django_admin_log]  WITH CHECK ADD  CONSTRAINT [django_admin_log_action_flag_a8637d59_check] CHECK  (([action_flag]>=(0)))
GO
ALTER TABLE [dbo].[django_admin_log] CHECK CONSTRAINT [django_admin_log_action_flag_a8637d59_check]
GO
/****** Object:  StoredProcedure [dbo].[InformeDepartamento]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InformeDepartamento]
AS
DECLARE @cmd nvarchar(4000),
        @columnas nvarchar(4000),
        @query    nvarchar(4000);

-- Hacemos una cadena con todas las columnas y nos aseguramos de que sea una sola linea
	SET @columnas = 'Departamento, Fecha_Pago, Total'


-- Solo incluimos el cabecero en la primer linea
	select @query = 'select CASE row_number() OVER(ORDER BY(SELECT 1)) WHEN 1 THEN '  
              -- Incluimos el resto de la instrucción en una solo linea
              + @columnas + 'FROM TbEmpleados AS A WITH (NOLOCK)
		INNER JOIN TbPagos AS B WITH (NOLOCK)
			ON A.Id_Empleados = B.Id_Empleados
				INNER JOIN TbRoles AS C WITH (NOLOCK)
					ON A.Id_Roles = C.Id_Roles
	WHERE CAST(GETDATE()-180 AS date) <= Fecha_Pago
	GROUP BY  A.Departamento, Fecha_Pago';

--Agregamos la consulta a la instrucción bcp
SET @cmd = 'bcp ' + @query + ' queryout C:\Users\grs\OneDrive\Desktop\Proyecto\Informe_por_Departamento.csv -t;';

--Ejecutamos el bcp
EXEC xp_cmdshell @cmd;

GO
/****** Object:  StoredProcedure [dbo].[InformeEmpleados]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InformeEmpleados]
AS
DECLARE @cmd nvarchar(4000),
        @columnas nvarchar(4000),
        @query    nvarchar(4000);

-- Hacemos una cadena con todas las columnas y nos aseguramos de que sea una sola linea
	SET @columnas = 'Id_Empleados,Cedula,Nombre,Descripcion_Rol,Direccion,Fecha_Ingreso,Cantidad,Fecha_Pago'


-- Solo incluimos el cabecero en la primer linea
	select @query = 'select CASE row_number() OVER(ORDER BY(SELECT 1)) WHEN 1 THEN '  
              -- Incluimos el resto de la instrucción en una solo linea
              + @columnas + 'FROM TbEmpleados AS A WITH (NOLOCK)
		INNER JOIN TbPagos AS B WITH (NOLOCK)
			ON A.Id_Empleados = B.Id_Empleados
				INNER JOIN TbRoles AS C WITH (NOLOCK)
					ON A.Id_Roles = C.Id_Roles
	GROUP BY  A.Id_Empleados,A.Cedula,A.Nombre,C.Descripcion_Rol,A.Direccion,A.Fecha_Ingreso,B.Cantidad';

--Agregamos la consulta a la instrucción bcp
SET @cmd = 'bcp ' + @query + ' queryout C:\Users\grs\OneDrive\Desktop\Proyecto\Informe_por_Empleado.csv -t;';

--Ejecutamos el bcp
EXEC xp_cmdshell @cmd;

GO
/****** Object:  StoredProcedure [dbo].[InformePeriodo]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[InformePeriodo]
AS
DECLARE @cmd nvarchar(4000),
        @columnas nvarchar(4000),
        @query    nvarchar(4000);

-- Hacemos una cadena con todas las columnas y nos aseguramos de que sea una sola linea
	SET @columnas = 'Cedula,Nombre, Fecha_Ingreso, Departamento, FechaInicial ,FechaFinal, Cantidad'


-- Solo incluimos el cabecero en la primer linea
	select @query = 'select CASE row_number() OVER(ORDER BY(SELECT 1)) WHEN 1 THEN '  
              -- Incluimos el resto de la instrucción en una solo linea
              + @columnas + 'FROM TbEmpleados AS A WITH (NOLOCK)
		,A.Cedula, A.Nombre, A.Fecha_Ingreso, A.Departamento,
	CASE WHEN DAY(Fecha_Pago) < 16 THEN DATEADD(MONTH, -1, DATEADD(day , 1 , EOMONTH(Fecha_Pago))) 
		ELSE DATEADD(MONTH, -1, DATEADD(day , 16 , EOMONTH(Fecha_Pago))) END AS FechaInicial 
	,Fecha_Pago AS FechaFinal, B.Cantidad
	INTO ##Datos
	FROM TbEmpleados AS A WITH (NOLOCK)
		INNER JOIN TbPagos AS B WITH (NOLOCK)
			ON A.Id_Empleados = B.Id_Empleados
				INNER JOIN TbRoles AS C WITH (NOLOCK)
					ON A.Id_Roles = C.Id_Roles
	GROUP BY A.Cedula, A.Nombre, A.Fecha_Ingreso, A.Departamento, Fecha_Pago, B.Cantidad';

--Agregamos la consulta a la instrucción bcp
SET @cmd = 'bcp ' + @query + ' queryout C:\Users\Yuly Villamil\Downloads\Prueba_Tecnica\Informe_por_Periodo.csv -t;';


--Ejecutamos el bcp
EXEC xp_cmdshell @cmd;

GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerEmpleados]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROCEDURE [dbo].[sp_ObtenerEmpleados]
    @usuario_id INT
AS
BEGIN
    IF (SELECT dbo.fn_VerificarAcceso(@usuario_id, 'TbEmpleados')) = 1
    BEGIN
        SELECT e.*
        FROM TbEmpleados e
        JOIN TbUsuarios u ON e.Id_Empleados = u.Id_Empleados
        WHERE u.Id_Usuarios = @usuario_id;
    END
    ELSE
    BEGIN
        RAISERROR ('Acceso denegado', 16, 1);
    END
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_ObtenerPagos]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   PROCEDURE [dbo].[sp_ObtenerPagos]
    @usuario_id INT
AS
BEGIN TRY
    IF (SELECT dbo.fn_VerificarAcceso(@usuario_id, 'TbPagos')) = 1
    BEGIN

        SELECT p.*
        FROM TbPagos p
        JOIN TbEmpleados e ON p.Id_Empleados = e.Id_Empleados
        JOIN TbUsuarios u ON e.Id_Empleados = u.Id_Empleados 
        WHERE u.Id_Usuarios = @usuario_id
		AND not exists (select 1 from TbEmpleados where Id_Usuarios = @usuario_id)
		
		
    END
    ELSE select 'NO_ACCESS' as Acceso

END TRY
	BEGIN CATCH
		SELECT ERROR_MESSAGE()
		SELECT ERROR_LINE()
	END CATCH
GO
/****** Object:  StoredProcedure [dbo].[sp_RegistrarAcceso]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_RegistrarAcceso]
    @usuario_id INT,
    @tabla VARCHAR(200)
AS
BEGIN
    DECLARE @id_roles INT;
    DECLARE @tipo_permiso VARCHAR(200);

    -- Obtener el Id_Roles desde la vista vw_pagos (Asegurar que solo devuelva 1 fila)
    SELECT TOP 1 @id_roles = Id_Roles, @tipo_permiso = Tipo_Permiso 
    FROM [dbo].[vw_pagos]
    WHERE Id_Empleados = @usuario_id;


    -- Insertar en la tabla TbRegistros
    INSERT INTO TbRegistros (Id_Usuarios, Id_Roles, Fecha_Acceso, Tabla, Tipo_Permiso)
    VALUES (@usuario_id, @id_roles, GETDATE(), @tabla, @tipo_permiso);
END;
GO
/****** Object:  StoredProcedure [dbo].[SpAlertInfo]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SpAlertInfo]

AS
-- Se declaran las variables a usar
DECLARE @owner varchar(max) = 'correo@gmail.com' -- Lista de correos a los que lesllega la alerta
DECLARE @client varchar(max)
DECLARE @tableHTML nvarchar(max);


-- Creación de temporales
IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total;

	CREATE TABLE #total (
		[Cantidad] VARCHAR(5)
	)

--LLENADO DE TEMPORALES
	insert into #total
	Select COUNT (A.Id_Empleados)
	FROM TbEmpleados AS A WITH (NOLOCK)
	INNER JOIN TbPagos AS B WITH (NOLOCK)
	ON A.Id_Empleados = B.Id_Empleados
	
	SELECT A.Id_Empleados,A.Cedula,A.Nombre,C.Descripcion_Rol,A.Direccion,A.Fecha_Ingreso,B.Cantidad, MAX(Fecha_Pago) AS Fecha_Pago
	INTO ##Datos
	FROM TbEmpleados AS A WITH (NOLOCK)
		INNER JOIN TbPagos AS B WITH (NOLOCK)
			ON A.Id_Empleados = B.Id_Empleados
				INNER JOIN TbRoles AS C WITH (NOLOCK)
					ON A.Id_Roles = C.Id_Roles
	GROUP BY  A.Id_Empleados,A.Cedula,A.Nombre,C.Descripcion_Rol,A.Direccion,A.Fecha_Ingreso,B.Cantidad

	
-- Inicia la lista para la creación del correo
DECLARE checkclient SCROLL CURSOR FOR
                             
  select Cantidad from #total

  OPEN checkclient 

  FETCH LAST FROM checkclient INTO @client
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN

-- Estructura y formatos que llevará el correo
	  SET @tableHTML =
	  '<head>
				<meta charset="UTF-8">
				<title>Reporte Pagos</title>
				<style>
					/* Estilos CSS (mantenemos los estilos anteriores) */
					body { font-family: Arial, sans-serif;margin: 30px; }
					h2 { color: #0066cc; border-bottom: 2px solid #0066cc; padding-bottom: 5px; font-size: 300%; }
					p { line-height: 1.6; }
					table { width: 100%; border-collapse: collapse; margin-top: 20px; }
					th,td { border: 1px solid #ddd; padding: 10px; text-align: left; }
					th { background-color: #333; color: #fff; }
					tr:nth-child(even) { background-color: #f2f2f2; }
					tr:hover { background-color: #e2e2e2; }
					.signature { font-style: italic; }
				</style>
			</head>' +
			'<body>' +
      N'<H2>Alerta</H2>' +
      N'<P>En el adjunto encontrarán la información del último reporte de pago de los empleados' 
	 +
      N'<table border="1">' +
      N'<tr><th>Información</th>'+ 
      CAST((SELECT 
	  --td = Cantidad,
	  --'',
	  td = 'La cantidad de empleados es: '+[Cantidad]
		FROM #total

      FOR xml PATH ('tr'), TYPE)
      AS nvarchar(max)) +
      N'</table>' +
      N'<br>' +
      N'<p>  Cordialmente,</p>' +
      N'<p>  Equipo Datos.</p>' +
	  '</body>';

	--Ejecución de la función enviar correo para tomar estructura y datos, agrega la información a un archivo excel
		EXEC msdb.dbo.sp_send_dbmail @profile_name = 'EquipoDatos',
		@recipients = @owner,
		@subject = 'Información Última Pago Empleados',
		@body = @tableHTML,
		@query = 'SELECT * FROM ##Datos',
		@attach_query_result_as_file = 1,
		@query_attachment_filename= 'Reporte.csv',
		@query_result_separator = ',',
        @query_result_no_padding = 1,
		@query_result_width = 400,
		@query_result_header = 1,
		@body_format = 'HTML',
		@importance = 'Low';
		--@query_no_truncate = 1;

								   
FETCH NEXT FROM checkclient INTO @client
  END
  CLOSE checkclient
  DEALLOCATE checkclient

  -- Cerramos el proceso de envío de correos y eliminamos temporales

  IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total;
    IF OBJECT_ID('tempdb..##Datos') IS NOT NULL DROP TABLE ##Datos;
GO
/****** Object:  StoredProcedure [dbo].[SpAlertInfoDepartamemto]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SpAlertInfoDepartamemto]

AS
DECLARE @owner varchar(max) = 'email@gmail.com'
DECLARE @client varchar(max)
DECLARE @tableHTML nvarchar(max);



IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total;

	CREATE TABLE #total (
		[Cantidad] VARCHAR(5)
	)


	insert into #total
	Select COUNT (A.Id_Empleados)
	FROM TbEmpleados AS A WITH (NOLOCK)
	INNER JOIN TbPagos AS B WITH (NOLOCK)
	ON A.Id_Empleados = B.Id_Empleados
	
	SELECT A.Departamento, Fecha_Pago, SUM(CAST(B.Cantidad AS decimal(16,2))) AS Total
	INTO ##Datos
	FROM TbEmpleados AS A WITH (NOLOCK)
		INNER JOIN TbPagos AS B WITH (NOLOCK)
			ON A.Id_Empleados = B.Id_Empleados
				INNER JOIN TbRoles AS C WITH (NOLOCK)
					ON A.Id_Roles = C.Id_Roles
	WHERE CAST(GETDATE()-180 AS date) <= Fecha_Pago
	GROUP BY  A.Departamento, Fecha_Pago
	

DECLARE checkclient SCROLL CURSOR FOR
                             
  select Cantidad from #total

  OPEN checkclient 

  FETCH LAST FROM checkclient INTO @client
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN


	  SET @tableHTML =
	  '<head>
				<meta charset="UTF-8">
				<title>Reporte Pagos por Departamento</title>
				<style>
					/* Estilos CSS (mantenemos los estilos anteriores) */
					body { font-family: Arial, sans-serif;margin: 30px; }
					h2 { color: #0066cc; border-bottom: 2px solid #0066cc; padding-bottom: 5px; font-size: 300%; }
					p { line-height: 1.6; }
					table { width: 100%; border-collapse: collapse; margin-top: 20px; }
					th,td { border: 1px solid #ddd; padding: 10px; text-align: left; }
					th { background-color: #333; color: #fff; }
					tr:nth-child(even) { background-color: #f2f2f2; }
					tr:hover { background-color: #e2e2e2; }
					.signature { font-style: italic; }
				</style>
			</head>' +
			'<body>' +
      N'<H2>Alerta</H2>' +
      N'<P>En el adjunto encontrarán la información por departamento del total pagado en los últimos 6 meses' 
	 +
      N'<table border="1">' +
      N'<tr><th>Información</th>'+ 
      CAST((SELECT 
	  --td = Cantidad,
	  --'',
	  td = 'El total de departamentos es: '+[Cantidad]
		FROM #total

      FOR xml PATH ('tr'), TYPE)
      AS nvarchar(max)) +
      N'</table>' +
      N'<br>' +
      N'<p>  Cordialmente,</p>' +
      N'<p>  Equipo Datos.</p>' +
	  '</body>';


		EXEC msdb.dbo.sp_send_dbmail @profile_name = 'EquipoDatos',
		@recipients = @owner,
		@subject = 'Información Total por Departamento',
		@body = @tableHTML,
		@query = 'SELECT * FROM ##Datos',
		@attach_query_result_as_file = 1,
		@query_attachment_filename= 'Informe.csv',
		@query_result_separator = ',',
        @query_result_no_padding = 1,
		@query_result_width = 400,
		@query_result_header = 1,
		@body_format = 'HTML',
		@importance = 'Low';
		--@query_no_truncate = 1;

								   
FETCH NEXT FROM checkclient INTO @client
  END
  CLOSE checkclient
  DEALLOCATE checkclient

  IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total;
  IF OBJECT_ID('tempdb..##Datos') IS NOT NULL DROP TABLE ##Datos;
GO
/****** Object:  StoredProcedure [dbo].[SpAlertInfoPeriodo]    Script Date: 16/02/2025 11:26:09 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SpAlertInfoPeriodo]

AS
DECLARE @owner varchar(max) = 'email@gmail.com'
DECLARE @client varchar(max)
DECLARE @tableHTML nvarchar(max);

DECLARE @FECHA_INICIO DATE


IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total;

	CREATE TABLE #total (
		[Cantidad] VARCHAR(5)
	)


	insert into #total
	Select COUNT (A.Id_Empleados)
	FROM TbEmpleados AS A WITH (NOLOCK)
	INNER JOIN TbPagos AS B WITH (NOLOCK)
	ON A.Id_Empleados = B.Id_Empleados

	SELECT A.Cedula, A.Nombre, A.Fecha_Ingreso, A.Departamento,
	CASE WHEN DAY(Fecha_Pago) < 16 THEN DATEADD(MONTH, -1, DATEADD(day , 1 , EOMONTH(Fecha_Pago))) 
		ELSE DATEADD(MONTH, -1, DATEADD(day , 16 , EOMONTH(Fecha_Pago))) END AS FechaInicial 
	,Fecha_Pago AS FechaFinal, B.Cantidad
	INTO ##Datos
	FROM TbEmpleados AS A WITH (NOLOCK)
		INNER JOIN TbPagos AS B WITH (NOLOCK)
			ON A.Id_Empleados = B.Id_Empleados
				INNER JOIN TbRoles AS C WITH (NOLOCK)
					ON A.Id_Roles = C.Id_Roles
	GROUP BY A.Cedula, A.Nombre, A.Fecha_Ingreso, A.Departamento, Fecha_Pago, B.Cantidad
	

DECLARE checkclient SCROLL CURSOR FOR
                             
  select Cantidad from #total

  OPEN checkclient 

  FETCH LAST FROM checkclient INTO @client
  
  WHILE @@FETCH_STATUS = 0  
  BEGIN


	  SET @tableHTML =
	  '<head>
				<meta charset="UTF-8">
				<title>Reporte Pagos por Periodo</title>
				<style>
					/* Estilos CSS (mantenemos los estilos anteriores) */
					body { font-family: Arial, sans-serif;margin: 30px; }
					h2 { color: #0066cc; border-bottom: 2px solid #0066cc; padding-bottom: 5px; font-size: 300%; }
					p { line-height: 1.6; }
					table { width: 100%; border-collapse: collapse; margin-top: 20px; }
					th,td { border: 1px solid #ddd; padding: 10px; text-align: left; }
					th { background-color: #333; color: #fff; }
					tr:nth-child(even) { background-color: #f2f2f2; }
					tr:hover { background-color: #e2e2e2; }
					.signature { font-style: italic; }
				</style>
			</head>' +
			'<body>' +
      N'<H2>Alerta</H2>' +
      N'<P>En el adjunto encontrarán la información por periodos para casa empleado' 
	 +
      --N'<table border="1">' +
      --N'<tr><th>Información</th>'+ 
      --CAST((SELECT 
	  --td = Cantidad,
	  --'',
	  --td = 'El total de departamentos es: '+[Cantidad]
		--FROM #total

      --FOR xml PATH ('tr'), TYPE)
      --AS nvarchar(max)) +
      N'</table>' +
      N'<br>' +
      N'<p>  Cordialmente,</p>' +
      N'<p>  Equipo Datos.</p>' +
	  '</body>';


		EXEC msdb.dbo.sp_send_dbmail @profile_name = 'EquipoDatos',
		@recipients = @owner,
		@subject = 'Información Total por Periodo',
		@body = @tableHTML,
		@query = 'SELECT * FROM ##Datos',
		@attach_query_result_as_file = 1,
		@query_attachment_filename= 'Informe.csv',
		@query_result_separator = ',',
        @query_result_no_padding = 1,
		@query_result_width = 400,
		@query_result_header = 1,
		@body_format = 'HTML',
		@importance = 'Low';
		--@query_no_truncate = 1;

								   
FETCH NEXT FROM checkclient INTO @client
  END
  CLOSE checkclient
  DEALLOCATE checkclient

  IF OBJECT_ID('tempdb..#total') IS NOT NULL DROP TABLE #total;
  IF OBJECT_ID('tempdb..##Datos') IS NOT NULL DROP TABLE ##Datos;
GO
/****** Object:  StoredProcedure [dbo].[SpCheckReadPermission]    Script Date: 16/02/2025 11:26:09 p. m. ******/
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
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "pag"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 136
               Right = 208
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 246
               Bottom = 136
               Right = 416
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "r"
            Begin Extent = 
               Top = 6
               Left = 454
               Bottom = 102
               Right = 627
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "u"
            Begin Extent = 
               Top = 6
               Left = 665
               Bottom = 136
               Right = 835
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_pagos'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_pagos'
GO
USE [master]
GO
ALTER DATABASE [Permisos] SET  READ_WRITE 
GO
