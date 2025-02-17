CREATE PROCEDURE InformePeriodo
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
SET @cmd = 'bcp ' + @query + ' queryout C:\Users\grs\OneDrive\Desktop\Proyecto\Informe_por_Periodo.csv -t;';

--Ejecutamos el bcp
EXEC xp_cmdshell @cmd;

GO