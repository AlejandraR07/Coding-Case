USE [Data]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE SpAlertInfo

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
