/****** Object:  UserDefinedFunction [ETL].[FnDecadaMax]    Script Date: 16/10/2021 2:39:36 a. m. ******/
DROP FUNCTION [ETL].[FnDecadaMax]
GO

/****** Object:  UserDefinedFunction [ETL].[FnDecadaMax]    Script Date: 16/10/2021 2:39:36 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [ETL].[FnDecadaMax] (@Date [DATE]) RETURNS VARCHAR(4)
AS
BEGIN
    -- Declare the return variable here
    --Verifica Primer dia de la semana
	DECLARE @DecadaMax VARCHAR(4),
	@Año INT = DATEPART(yy, @Date)

	--Calcula Cuatrenio
	SET @DecadaMax = CAST(@Año/10 AS VARCHAR(4)) + '9'

	SET @DecadaMax = REPLICATE('0',4-LEN(@DecadaMax)) + @DecadaMax

	RETURN @DecadaMax
END

GO