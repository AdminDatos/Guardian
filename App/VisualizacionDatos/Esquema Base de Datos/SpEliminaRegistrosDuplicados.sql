/****** Object:  StoredProcedure [ETL].[SpEliminaRegistrosDuplicados]    Script Date: 16/11/2021 4:54:22 p. m. ******/
DROP PROCEDURE [ETL].[SpEliminaRegistrosDuplicados]
GO

/****** Object:  StoredProcedure [ETL].[SpEliminaRegistrosDuplicados]    Script Date: 16/11/2021 4:54:22 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [ETL].[SpEliminaRegistrosDuplicados]
	@Esquema AS VARCHAR(128),
	@Tabla AS VARCHAR(128),
	@Campos AS VARCHAR(MAX),
	@CamposOrden AS VARCHAR(MAX),
	@ExceptoCampos AS VARCHAR(MAX),
	@Texto AS BIT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON
	
	---------------------------------------------------------------
	--Crea Tabla Temporal con los campos modificados para insertar en la tabla de calidad
	IF OBJECT_ID('tempdb..#ExceptoCampos') IS NOT NULL 
		DROP TABLE #ExceptoCampos


	---------------------------------------------------------------
	--Split Variable
	EXEC [ETL].[SpSplit] @ExceptoCampos,','

	SELECT * INTO #ExceptoCampos FROM #Split

	---------------------------------------------------------------
	--Crea Tabla Temporal con campos de tabla por defecto
	IF @Campos IS NULL
	BEGIN

		IF OBJECT_ID('tempdb..#Campos') IS NOT NULL 
			DROP TABLE #Campos

		SELECT [column_id], [Columna]
		INTO #Campos
		FROM
		(
			SELECT SCH.[schema_id]
					,SCH.[name] [Esquema]
					,OBJ.[object_id]
					,OBJ.[name] [NombreObjeto]
					,COL.[column_id]
					,COL.[name] [Columna]
					,TP.[name] [Tipo]
			FROM sys.all_objects OBJ
			INNER JOIN sys.schemas SCH
			ON OBJ.[schema_id] = SCH.[schema_id]
			INNER JOIN sys.all_columns COL
			ON OBJ.[object_id] = COL.[object_id]
			INNER JOIN sys.systypes TP
			ON COL.[system_type_id] = TP.[xtype]
		) OBJET
		WHERE OBJET.[Tipo] <> 'sysname'
		AND OBJET.[Esquema] = @Esquema
		AND OBJET.[NombreObjeto] = @Tabla
		AND OBJET.[Columna] NOT IN (SELECT * FROM #ExceptoCampos)


		DECLARE @MaxColumnId INT = (SELECT MAX([column_id]) FROM #Campos)
		DECLARE @Cont INT = 1

		SET @Campos = ''

		WHILE @Cont <= @MaxColumnId
		BEGIN
			SET @Campos = @Campos + (SELECT '[' + [Columna] + '],' FROM #Campos WHERE [column_id] = @Cont)
			SET @Cont = @Cont + 1
		END

		SET @Campos = LEFT(@Campos,LEN(@Campos)-1)

	END

	-------------------------------------------------------------------------
	
	DECLARE @Sql AS VARCHAR(MAX)
    
	IF @Texto = 1
	BEGIN
		SET @Sql = 
		'DELETE [Tabla] FROM (SELECT [Fila] = ROW_NUMBER() OVER(PARTITION BY ' + @Campos + ' 
		ORDER BY ' + @CamposOrden + ') FROM [' + @Esquema + '].[' + @Tabla + ']) AS [Tabla] WHERE [Fila] <> 1
		
		SELECT * FROM (SELECT [Fila] = ROW_NUMBER() OVER(PARTITION BY ' + @Campos + ' 
		ORDER BY ' + @CamposOrden + '), * FROM [' + @Esquema + '].[' + @Tabla + ']) AS [Tabla] WHERE [Fila] <> 1'

		PRINT(@Sql)
	END
	ELSE
	BEGIN
		SET @Sql = 
		'DELETE [Tabla] FROM (SELECT [Fila] = ROW_NUMBER() OVER(PARTITION BY ' + @Campos + ' 
		ORDER BY ' + @CamposOrden + ') FROM [' + @Esquema + '].[' + @Tabla + ']) AS [Tabla] WHERE [Fila] <> 1'

		EXEC(@Sql)
	END

END

GO