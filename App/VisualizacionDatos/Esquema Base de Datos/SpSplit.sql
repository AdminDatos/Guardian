/****** Object:  StoredProcedure [ETL].[SpSplit]    Script Date: 16/11/2021 4:54:22 p. m. ******/
DROP PROCEDURE [ETL].[SpSplit]
GO

/****** Object:  StoredProcedure [ETL].[SpSplit]    Script Date: 16/11/2021 4:54:22 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [ETL].[SpSplit]
	@sInputList VARCHAR(MAX),
	@sDelimiter VARCHAR(8000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON

	---------------------------------------------------------------
	--Crea Tabla Temporal para el Split
	IF OBJECT_ID('tempdb..#Split') IS NOT NULL 
		DROP TABLE #Split

	CREATE TABLE #Split ([item] VARCHAR(8000))

	DECLARE @sItem VARCHAR(8000)
	
	WHILE CHARINDEX(@sDelimiter,@sInputList,0) <> 0
	BEGIN
		SET @sItem=RTRIM(LTRIM(SUBSTRING(@sInputList,1,CHARINDEX(@sDelimiter,@sInputList,0)-1)))
		SET @sInputList=RTRIM(LTRIM(SUBSTRING(@sInputList,CHARINDEX(@sDelimiter,@sInputList,0)+LEN(@sDelimiter),LEN(@sInputList))))
 
		IF LEN(@sItem) > 0
			INSERT INTO #Split SELECT @sItem
	END
	
	IF LEN(@sInputList) > 0
		INSERT INTO #Split SELECT @sInputList -- Put the last item in

	--SELECT * FROM #Split

END

GO