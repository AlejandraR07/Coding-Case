CREATE PROCEDURE InformeDepartamento
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