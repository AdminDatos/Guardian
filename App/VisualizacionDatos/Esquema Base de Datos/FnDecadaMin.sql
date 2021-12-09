/****** Object:  UserDefinedFunction [ETL].[FnDecadaMin]    Script Date: 16/10/2021 2:39:36 a. m. ******/
DROP FUNCTION [ETL].[FnDecadaMin]
GO

/****** Object:  UserDefinedFunction [ETL].[FnDecadaMin]    Script Date: 16/10/2021 2:39:36 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [ETL].[FnDecadaMin] (@Date [DATE]) RETURNS VARCHAR(4)
AS
BEGIN
    -- Declare the return variable here
    --Verifica Primer dia de la semana
	DECLARE @DecadaMin VARCHAR(4),
	@Año INT = DATEPART(yy, @Date)

	--Calcula Cuatrenio
	SET @DecadaMin = CAST(@Año/10 AS VARCHAR(4)) + '0'

	SET @DecadaMin = REPLICATE('0',4-LEN(@DecadaMin)) + @DecadaMin

	RETURN @DecadaMin
END

GO