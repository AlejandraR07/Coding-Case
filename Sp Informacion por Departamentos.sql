USE [DataCalculate]
GO

/****** Object:  StoredProcedure [dbo].[spAlertEmail]    Script Date: 2025-02-15 08:46:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author: <>
-- Create date: <>
-- Description: <Envio de Correos>
-- =============================================
ALTER PROCEDURE SpAlertInfoDepartamemto

AS
DECLARE @owner varchar(max) = 'Gineth.RicoSabogal@teleperformance.com'
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


		EXEC msdb.dbo.sp_send_dbmail @profile_name = 'MasterData',
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