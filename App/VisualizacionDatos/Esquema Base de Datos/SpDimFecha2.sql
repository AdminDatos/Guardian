/****** Object:  StoredProcedure [ETL].[SpDimFecha]    Script Date: 15/10/2021 10:45:50 p. m. ******/
DROP PROCEDURE [ETL].[SpDimFecha]
GO

/****** Object:  StoredProcedure [ETL].[SpDimFecha]    Script Date: 15/10/2021 10:45:50 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [ETL].[SpDimFecha]
	@FechaInicio DATE, 
	@FechaFin DATE,
	@RegistroDefecto BIT
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON

    SET LANGUAGE Español

	--DECLARE @FechaInicio DATE = '20000101', 
	--@FechaFin DATE = '20251231'

	DECLARE
	@StartDate DATE,
	@EndDate DATE,
	@Date DATE
 
	SET @StartDate = @FechaInicio
	SET @EndDate = @FechaFin
	SET @Date = @StartDate
	
	--Inserta Registro por Defecto en la Dimension de Fecha
	IF @RegistroDefecto = 1
	BEGIN
		INSERT INTO [IM].[DimFecha]
					([IdDimFecha]
					,[Fecha]
					,[CodigoEsDiaNoHabil]
					,[EsDiaNoHabil]
					,[CodigoEsFestivo]
					,[EsFestivo]
					,[Festivo]
					,[Año]
					,[Semestre]
					,[NombreSemestre]
					,[Trimeste]
					,[NombreTrimestre]
					,[Mes]
					,[NombreMes]
					,[Semana]
					,[NombreSemana]
					,[Dia]
					,[DiaSemana]
					,[NombreDiaSemana]
					,[NombreInicioSemana]
					,[Quincena]
					,[NombreQuincena]
					,[CuatrienioGobierno]
					,[Cuatrienio]
					,[Decada]
					,[FechaCreacion]
					,[FechaModificacion])
		SELECT FEC.[IdDimFecha]
			  ,FEC.[Fecha]
			  ,FEC.[CodigoEsDiaNoHabil]
			  ,FEC.[EsDiaNoHabil]
			  ,FEC.[CodigoEsFestivo]
			  ,FEC.[EsFestivo]
			  ,FEC.[Festivo]
			  ,FEC.[Año]
			  ,FEC.[Semestre]
			  ,FEC.[NombreSemestre]
			  ,FEC.[Trimeste]
			  ,FEC.[NombreTrimestre]
			  ,FEC.[Mes]
			  ,FEC.[NombreMes]
			  ,FEC.[Semana]
			  ,FEC.[NombreSemana]
			  ,FEC.[Dia]
			  ,FEC.[DiaSemana]
			  ,FEC.[NombreDiaSemana]
			  ,FEC.[NombreInicioSemana]
			  ,FEC.[Quincena]
			  ,FEC.[NombreQuincena]
			  ,FEC.[CuatrienioGobierno]
			  ,FEC.[Cuatrienio]
			  ,FEC.[Decada]
			  ,FEC.[FechaCreacion]
			  ,FEC.[FechaModificacion]
		FROM
		(
			SELECT -1 [IdDimFecha]
				  ,NULL [Fecha]
				  ,-1 [CodigoEsDiaNoHabil]
				  ,'Sin Información' [EsDiaNoHabil]
				  ,-1 [CodigoEsFestivo]
				  ,'Sin Información' [EsFestivo]
				  ,'Sin Información' [Festivo]
				  ,-1 [Año]
				  ,-1 [Semestre]
				  ,'-1' [NombreSemestre]
				  ,-1 [Trimeste]
				  ,'-1' [NombreTrimestre]
				  ,-1 [Mes]
				  ,'-1' [NombreMes]
				  ,-1 [Semana]
				  ,'-1' [NombreSemana]
				  ,-1 [Dia]
				  ,-1 [DiaSemana]
				  ,'-1' [NombreDiaSemana]
				  ,'-1' [NombreInicioSemana]
				  ,-1 [Quincena]
				  ,'-1' [NombreQuincena]
				  ,'-1' [CuatrienioGobierno]
				  ,'-1' [Cuatrienio]
				  ,'-1' [Decada]
				  ,GETDATE() [FechaCreacion]
				  ,GETDATE() [FechaModificacion]
				--,@IsLeapYear
		) FEC
		LEFT JOIN [IM].[DimFecha] DF
		ON FEC.[IdDimFecha] = DF.[IdDimFecha]
		WHERE DF.[IdDimFecha] IS NULL
	END


	------------------------------------------------
	--temporal FechasTally
	IF OBJECT_ID('tempdb..#FechasTally') IS NOT NULL
		DROP TABLE #FechasTally

	CREATE TABLE #FechasTally
	WITH
	(   
		DISTRIBUTION = HASH ( [AutoNumerico] ),
		CLUSTERED COLUMNSTORE INDEX
	)
	AS

	WITH 
	  E1([N]) AS (
				SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
				SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL 
				SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL
				SELECT 1
			   ),                          -- 1*10^1 or 10 rows
	  E2([N]) AS (SELECT 1 FROM E1 a, E1 b), -- 1*10^2 or 100 rows
	  E4([N]) AS (SELECT 1 FROM E2 a, E2 b), -- 1*10^2 or 10000 rows
	  E8([N]) AS (SELECT 1 FROM E4 a, E4 b) -- 1*10^2 or 100000000 rows

	SELECT TOP 1000000 ROW_NUMBER() OVER(ORDER BY [N]) [AutoNumerico]
	FROM E8

	--SELECT * FROM #FechasTally


	-----------------------------------------------
	--temporal Fechas
	IF OBJECT_ID('tempdb..#Fechas') IS NOT NULL
		DROP TABLE #Fechas

	CREATE TABLE #Fechas
	WITH
	(   
		DISTRIBUTION = HASH ( [Fecha] ),
		CLUSTERED COLUMNSTORE INDEX
	)
	AS

	SELECT CONVERT(DATE,CONVERT(DATETIME,CONVERT(INT,[AutoNumerico]))) [Fecha]
	FROM #FechasTally
	WHERE CONVERT(DATE,CONVERT(DATETIME,CONVERT(INT,[AutoNumerico]))) BETWEEN @StartDate AND @EndDate
	

	-----------------------------------------------
	--temporal TDimFechas
	IF OBJECT_ID('tempdb..#TDimFechas') IS NOT NULL
		DROP TABLE #TDimFechas

	CREATE TABLE #TDimFechas
	WITH
	(   
		DISTRIBUTION = HASH ( [Fecha] ),
		CLUSTERED COLUMNSTORE INDEX
	)
	AS

	SELECT CAST(CONVERT(VARCHAR(10), [Fecha], 112) AS INT) [IdDimFecha]
		  ,CAST([Fecha] AS DATE) [Fecha]
		  ,CASE WHEN (DATEPART(dw, [Fecha]) = 6 OR DATEPART(dw, [Fecha]) = 7) THEN 1 ELSE 0 END [CodigoEsDiaNoHabil]
		  ,CASE WHEN (CASE WHEN (DATEPART(dw, [Fecha]) = 6 OR DATEPART(dw, [Fecha]) = 7) THEN 1 ELSE 0 END) = 1 THEN 'Si' WHEN (CASE WHEN (DATEPART(dw, [Fecha]) = 6 OR DATEPART(dw, [Fecha]) = 7) THEN 1 ELSE 0 END) = 0 THEN 'No' ELSE 'Sin Información' END [EsDiaNoHabil]
		  ,-1 [CodigoEsFestivo]
		  ,'Sin Información' [EsFestivo]
		  ,'Sin Información' [Festivo]
		  ,DATEPART(yy, [Fecha]) [Año]
		  ,CASE WHEN DATENAME(qq, [Fecha]) IN (1,2) THEN 1 ELSE 2 END [Semestre]
		  ,CASE WHEN DATENAME(qq, [Fecha]) IN (1,2) THEN 'S1'+ '/' + CAST(DATEPART(yy, [Fecha]) AS VARCHAR(4)) ELSE 'S2'+ '/' +  CAST(DATEPART(yy, [Fecha]) AS VARCHAR(4)) END [NombreSemestre]
		  ,DATENAME(qq, [Fecha]) [Trimeste]
		  ,'T' + CAST(DATENAME(qq, [Fecha]) AS VARCHAR(1)) + '/' + CAST(DATEPART(yy, [Fecha]) AS VARCHAR(4)) [NombreTrimestre]
		  ,DATEPART(mm, [Fecha]) [Mes]
		  ,DATENAME(mm, [Fecha]) [NombreMes]
		  ,DATEPART(wk, [Fecha]) [Semana]
		  ,'Sem' + CAST(DATEPART(wk, [Fecha]) AS VARCHAR(20)) [NombreSemana]
		  ,DATEPART(dd, [Fecha]) [Dia]
		  ,DATEPART(dw, [Fecha]) [DiaSemana]
		  ,DATENAME(dw, [Fecha]) [NombreDiaSemana]
		  ,LEFT(DATENAME(mm, [Fecha]),3) + ' ' + CAST([ETL].[FnPrimerDiasemana]([Fecha]) AS VARCHAR(2)) + '/' + CAST(DATEPART(yy, [Fecha]) AS VARCHAR(4)) [NombreInicioSemana]
		  ,CASE WHEN DATEPART(wk, [Fecha]) % 2 = 0 THEN DATEPART(wk, [Fecha])/2 ELSE (DATEPART(wk, [Fecha])+1)/2 END [Quincena]
		  ,LEFT(DATENAME(mm, [Fecha]),3) + ' ' + (CASE WHEN DATEPART(dd, [Fecha]) <= 15 THEN '15' ELSE CAST(DATEPART(dd, EOMONTH([Fecha]))  AS VARCHAR(2)) END) + '/' + CAST(DATEPART(yy, [Fecha]) AS VARCHAR(4)) [NombreQuincena]
		  ,[ETL].[FnCuatrienioGobiernoMin]([Fecha]) + '-' + [ETL].[FnCuatrienioGobiernoMax]([Fecha]) [CuatrienioGobierno]
		  ,[ETL].[FnCuatrienioMin]([Fecha]) + '-' + [ETL].[FnCuatrienioMax]([Fecha]) [Cuatrienio]
		  ,[ETL].[FnDecadaMin]([Fecha]) + '-' + [ETL].[FnDecadaMax]([Fecha]) [Decada]
		  ,GETDATE() [FechaCreacion]
		  ,GETDATE() [FechaModificacion]
	FROM #Fechas


	--Inserta Registro en la Dimension de Fecha
	INSERT INTO [IM].[DimFecha]
			   ([IdDimFecha]
			   ,[Fecha]
			   ,[CodigoEsDiaNoHabil]
			   ,[EsDiaNoHabil]
			   ,[CodigoEsFestivo]
			   ,[EsFestivo]
			   ,[Festivo]
			   ,[Año]
			   ,[Semestre]
			   ,[NombreSemestre]
			   ,[Trimeste]
			   ,[NombreTrimestre]
			   ,[Mes]
			   ,[NombreMes]
			   ,[Semana]
			   ,[NombreSemana]
			   ,[Dia]
			   ,[DiaSemana]
			   ,[NombreDiaSemana]
			   ,[NombreInicioSemana]
			   ,[Quincena]
			   ,[NombreQuincena]
			   ,[CuatrienioGobierno]
			   ,[Cuatrienio]
			   ,[Decada]
			   ,[FechaCreacion]
			   ,[FechaModificacion])
	SELECT FEC.[IdDimFecha]
		  ,FEC.[Fecha]
		  ,FEC.[CodigoEsDiaNoHabil]
		  ,FEC.[EsDiaNoHabil]
		  ,FEC.[CodigoEsFestivo]
		  ,FEC.[EsFestivo]
		  ,FEC.[Festivo]
		  ,FEC.[Año]
		  ,FEC.[Semestre]
		  ,FEC.[NombreSemestre]
		  ,FEC.[Trimeste]
		  ,FEC.[NombreTrimestre]
		  ,FEC.[Mes]
		  ,FEC.[NombreMes]
		  ,FEC.[Semana]
		  ,FEC.[NombreSemana]
		  ,FEC.[Dia]
		  ,FEC.[DiaSemana]
		  ,FEC.[NombreDiaSemana]
		  ,FEC.[NombreInicioSemana]
		  ,FEC.[Quincena]
		  ,FEC.[NombreQuincena]
		  ,FEC.[CuatrienioGobierno]
		  ,FEC.[Cuatrienio]
		  ,FEC.[Decada]
		  ,FEC.[FechaCreacion]
		  ,FEC.[FechaModificacion]
	FROM #TDimFechas FEC
	LEFT JOIN [IM].[DimFecha] DF
	ON FEC.[IdDimFecha] = DF.[IdDimFecha]
	WHERE DF.[IdDimFecha] IS NULL

	
	--Actualiza festivos en el rango de fechas
	UPDATE DF
	SET [CodigoEsFestivo] = 1,
		[EsFestivo] = 'Si',
		[Festivo] = FES.[Festivo]
	FROM [IM].[DimFecha] DF
	INNER JOIN [REF].[Festivos] FES
	ON DF.[Fecha] = FES.[Fecha]
	WHERE DF.[Fecha] BETWEEN @StartDate AND @EndDate


	--Actualiza los dias no festivos en el rango de fechas
	UPDATE DF
		SET [CodigoEsFestivo] = 0,
			[EsFestivo] = 'No',
			[Festivo] = 'Dia No Festivo'
	FROM [IM].[DimFecha] DF
	INNER JOIN
	(
		SELECT DISTINCT YEAR(DF.[Fecha]) [Año]
		FROM [IM].[DimFecha] DF
		INNER JOIN [REF].[Festivos] FES
		ON DF.[Fecha] = FES.[Fecha]
		WHERE DF.[Fecha] BETWEEN @StartDate AND @EndDate
		AND DF.[CodigoEsFestivo] = 1
	) AF
	ON YEAR(DF.[Fecha]) = AF.[Año]
	WHERE DF.[CodigoEsFestivo] = -1

END

GO