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

	DECLARE
	@StartDate DATE,
	@EndDate DATE,
	@Date DATE,
	@Trimestre INT,
	@Año INT,
	@AñoT VARCHAR(4),
	@PrimerDiaSemana INT,
	@DecadaMin VARCHAR(4),
	@DecadaMax VARCHAR(4),
	@CuatrienioMin VARCHAR(4),
	@CuatrienioMax VARCHAR(4),
	@CuatrienioGobiernoMin VARCHAR(4),
	@CuatrienioGobiernoMax VARCHAR(4),

	@PrimeraFecha DATE = '00010101'
 
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
	
	--Itera sobre las Fechas
	WHILE @Date <= @EndDate
	BEGIN
		--Check for leap year
		DECLARE @IsLeapYear BIT
		IF ((Year(@Date) % 4 = 0) AND (Year(@Date) % 100 != 0 OR Year(@Date) % 400 = 0))
		BEGIN
			SELECT @IsLeapYear = 1
		END
		ELSE
		BEGIN
			SELECT @IsLeapYear = 0
		END
 
		--Verifica si es Fin de Semana
		DECLARE @IsWeekend BIT
		IF (DATEPART(dw, @Date) = 6 OR DATEPART(dw, @Date) = 7)
		BEGIN
			SELECT @IsWeekend = 1
		END
		ELSE
		BEGIN
			SELECT @IsWeekend = 0
		END

		--Verifica Primer dia de la semana
		DECLARE @IsFirstDayWeekend BIT
		IF (DATEPART(dw, @Date) = 2)
		BEGIN
			IF @Date = @PrimeraFecha
			BEGIN
				SELECT @IsFirstDayWeekend = 1, @PrimerDiaSemana = DATEPART(dd,DATEADD(wk,DATEDIFF(wk,@PrimeraFecha,@Date),@PrimeraFecha))
			END
			ELSE
			BEGIN 
				SELECT @IsFirstDayWeekend = 1, @PrimerDiaSemana = DATEPART(dd,DATEADD(wk,DATEDIFF(wk,@PrimeraFecha,DATEADD(dd,-1,@Date)),@PrimeraFecha))
			END
		END
		ELSE
		BEGIN
			IF @Date = @PrimeraFecha
			BEGIN
				SELECT @IsFirstDayWeekend = 0, @PrimerDiaSemana = DATEPART(dd,DATEADD(wk,DATEDIFF(wk,@PrimeraFecha,@Date),@PrimeraFecha))
			END
			ELSE
			BEGIN 
				SELECT @IsFirstDayWeekend = 0, @PrimerDiaSemana = DATEPART(dd,DATEADD(wk,DATEDIFF(wk,@PrimeraFecha,DATEADD(dd,-1,@Date)),@PrimeraFecha))
			END
		END

		SET @Trimestre = DATENAME(qq, @Date)
		SET @Año = DATEPART(yy, @Date)
		SET @AñoT = CAST(@Año AS VARCHAR(4))
		SET @AñoT = CASE WHEN LEN(@AñoT) < 4 THEN REPLICATE('0',4-LEN(@AñoT))+@AñoT ELSE @AñoT END

		--Calcula Cuatrenio Gobierno
		IF @Date > '00010806'
		BEGIN
			SET @CuatrienioGobiernoMin = CAST((((YEAR(DATEADD(dd,-218,@Date))-2)/4)*4)+2 AS VARCHAR(4))
			SET @CuatrienioGobiernoMax = CAST((((YEAR(DATEADD(dd,-218,@Date))-2)/4)*4)+6 AS VARCHAR(4))

			SET @CuatrienioGobiernoMin = REPLICATE('0',4-LEN(@CuatrienioGobiernoMin)) + @CuatrienioGobiernoMin
			SET @CuatrienioGobiernoMax = REPLICATE('0',4-LEN(@CuatrienioGobiernoMax)) + @CuatrienioGobiernoMax
		END
		ELSE
		BEGIN
			SET @CuatrienioGobiernoMin = '0000'
			SET @CuatrienioGobiernoMax = '0002'
		END


		--Calcula Cuatrenio
		SET @CuatrienioMin = CAST((((YEAR(@Date)-2)/4)*4)+2 AS VARCHAR(4))
		SET @CuatrienioMax = CAST((((YEAR(@Date)-2)/4)*4)+5 AS VARCHAR(4))

		SET @CuatrienioMin = REPLICATE('0',4-LEN(@CuatrienioMin)) + @CuatrienioMin
		SET @CuatrienioMax = REPLICATE('0',4-LEN(@CuatrienioMax)) + @CuatrienioMax


		--Calcula Decada
		SET @DecadaMin = CAST(@Año/10 AS VARCHAR(4)) + '0'
		SET @DecadaMax = CAST(@Año/10 AS VARCHAR(4)) + '9'

		SET @DecadaMin = REPLICATE('0',4-LEN(@DecadaMin)) + @DecadaMin
		SET @DecadaMax = REPLICATE('0',4-LEN(@DecadaMax)) + @DecadaMax


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
		FROM
		(
			SELECT CAST(CONVERT(VARCHAR(10), @Date, 112) AS INT) [IdDimFecha]
				  ,CAST(@Date AS DATE) [Fecha]
				  ,@IsWeekend [CodigoEsDiaNoHabil]
				  ,CASE WHEN @IsWeekend = 1 THEN 'Si' WHEN @IsWeekend = 0 THEN 'No' ELSE 'Sin Información' END [EsDiaNoHabil]
				  ,-1 [CodigoEsFestivo]
				  ,'Sin Información' [EsFestivo]
				  ,'Sin Información' [Festivo]
				  ,@Año [Año]
				  ,CASE WHEN @Trimestre IN (1,2) THEN 1 ELSE 2 END [Semestre]
				  ,CASE WHEN @Trimestre IN (1,2) THEN 'S1'+ '/' + @AñoT ELSE 'S2'+ '/' + @AñoT END [NombreSemestre]
				  ,@Trimestre [Trimeste]
				  ,'T' + CAST(@Trimestre AS VARCHAR(1)) + '/' + @AñoT [NombreTrimestre]
				  ,DATEPART(mm, @Date) [Mes]
				  ,DATENAME(mm, @Date) [NombreMes]
				  ,DATEPART(wk, @Date) [Semana]
				  ,'Sem' + CAST(DATEPART(wk, @Date) AS VARCHAR(20)) [NombreSemana]
				  ,DATEPART(dd, @Date) [Dia]
				  ,DATEPART(dw, @Date) [DiaSemana]
				  ,DATENAME(dw, @Date) [NombreDiaSemana]
				  ,LEFT(DATENAME(mm, @Date),3) + ' ' + CAST(@PrimerDiaSemana AS VARCHAR(2)) + '/' + @AñoT [NombreInicioSemana]
				  ,CASE WHEN DATEPART(wk, @Date) % 2 = 0 THEN DATEPART(wk, @Date)/2 ELSE (DATEPART(wk, @Date)+1)/2 END [Quincena]
				  ,LEFT(DATENAME(mm, @Date),3) + ' ' + (CASE WHEN DATEPART(dd, @Date) <= 15 THEN '15' ELSE CAST(DATEPART(dd, EOMONTH(@Date))  AS VARCHAR(2)) END) + '/' + @AñoT [NombreQuincena]
				  ,@CuatrienioGobiernoMin + '-' + @CuatrienioGobiernoMax [CuatrienioGobierno]
				  ,@CuatrienioMin + '-' + @CuatrienioMax [Cuatrienio]
				  ,@DecadaMin + '-' + @DecadaMax [Decada]
				  ,GETDATE() [FechaCreacion]
				  ,GETDATE() [FechaModificacion]
				--,@IsLeapYear
		) FEC
		LEFT JOIN [IM].[DimFecha] DF
		ON FEC.[IdDimFecha] = DF.[IdDimFecha]
		WHERE DF.[IdDimFecha] IS NULL

		--Ir al Siguiente Dia
		SET @Date = DATEADD(dd,1,@Date)
	END

	
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