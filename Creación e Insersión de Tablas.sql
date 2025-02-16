-- 1.Creación de Tablas
	-- Tabla Empleados que almacena los datos básiocos de las personas
		CREATE TABLE TbEmpleados (
		Id_Empleados INT PRIMARY KEY IDENTITY (1,1),
		Cedula INT,
		Nombre VARCHAR(300),
		Direccion VARCHAR(150),
		Fecha_Ingreso Date,
		Id_Roles INT
		CONSTRAINT [UC_TbEmpleados] UNIQUE NONCLUSTERED 
(
	Id_Empleados ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
		
	-- Tabla Pagos que almacena los datos de salario
		CREATE TABLE TbPagos (
		Id_Pagos INT PRIMARY KEY IDENTITY (1,1),
		Id_Empleados INT,
		Cantidad DECIMAL(16,6),
		Fecha_Pago Date
		CONSTRAINT [UC_TbPagos] UNIQUE NONCLUSTERED 
(
	Id_Pagos ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

	-- Tabla Roles guarda los roles que existen
		CREATE TABLE TbRoles (
		Id_Roles INT PRIMARY KEY IDENTITY (1,1),
		Descripcion_Rol VARCHAR(250)
		CONSTRAINT [UC_TbRoles] UNIQUE NONCLUSTERED 
(
	Id_Roles ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

-- Tabla Usuarios almacena el usuario de cada empleado
		CREATE TABLE TbUsuarios (
		Id_Usuarios INT PRIMARY KEY IDENTITY (1,1),
		Usuario VARCHAR(250),
		Id_Empleados INT,
		Id_Roles INT,
		Departamento VARCHAR(250),
		CONSTRAINT [UC_TbUsuarios] UNIQUE NONCLUSTERED 
(
	Id_Usuarios ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

	-- Tabla Persisos el tipo de permiso para cada rol
		CREATE TABLE TbPermisos (
		Id_Permisos INT PRIMARY KEY IDENTITY (1,1),
		Id_Roles INT,
		Tabla VARCHAR(200),
		Tipo_Permiso VARCHAR(200)
		CONSTRAINT [UC_TbPermisos] UNIQUE NONCLUSTERED 
(
	Id_Permisos ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

	-- Tabla de Registros para llevar un control de las consultas
		CREATE TABLE TbRegistros (
		Id_Registros INT PRIMARY KEY IDENTITY (1,1),
		Id_Roles INT,
		Fecha_Acceso DATE,
		Id_Usuarios INT,
		Tabla VARCHAR(200),
		CONSTRAINT [UC_TbRegistros] UNIQUE NONCLUSTERED 
(
	Id_Registros ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO



-- Agregar relaciones a la tabla de empleados
ALTER TABLE TbEmpleados ADD CONSTRAINT FK_Empleado_Rol FOREIGN KEY (Id_Roles) REFERENCES TbRoles(Id_Roles);

-- Relacionar pagos con empleados
ALTER TABLE TbPagos ADD CONSTRAINT FK_Pagos_Empleado FOREIGN KEY (Id_Empleados) REFERENCES TbEmpleados(Id_Empleados);

-- Relacionar usuarios con empleados y roles
ALTER TABLE TbUsuarios 
ADD CONSTRAINT FK_Usuarios_Empleado FOREIGN KEY (Id_Empleados) REFERENCES TbEmpleados(Id_Empleados),
    CONSTRAINT FK_Usuarios_Rol FOREIGN KEY (Id_Roles) REFERENCES TbRoles(Id_Roles);

-- Relacionar permisos con roles
ALTER TABLE TbPermisos ADD CONSTRAINT FK_Permisos_Rol FOREIGN KEY (Id_Roles) REFERENCES TbRoles(Id_Roles);

-- Relacionar registros con roles y usuarios
ALTER TABLE TbRegistros 
ADD CONSTRAINT FK_Registros_Rol FOREIGN KEY (Id_Roles) REFERENCES TbRoles(Id_Roles),
    CONSTRAINT FK_Registros_Usuario FOREIGN KEY (Id_Usuarios) REFERENCES TbUsuarios(Id_Usuarios);



-- 2. Insert Datos Prueba
	-- TbRoles
		INSERT INTO TbRoles VALUES
		('UserSpecific')
		('Supervisor'),
		('Gerente')

	--TbEmpleados
		INSERT INTO TbEmpleados VALUES
		(56487,'Dario Feria','Calle 1 N 1- 1','2025-03-03',4),
		(2545652,'Carlos Padilla','Calle 1 N 1- 1','2024-06-12',3),
		(546528,'Sara Cortez','Calle 1 N 1- 1','2025-12-15',1)

	-- TbPagos
		INSERT INTO TbPagos VALUES
		(3,2564852,'2025-02-15'),
		(4,158484,'2025-02-17')


	-- TbUsuarios
		INSERT INTO TbUsuarios VALUES 
		('DFeria',4,4, 'RH')


	-- TbUsuarios
		INSERT INTO TbPermisos VALUES 
		(3,'TbPagos','ACCESO')