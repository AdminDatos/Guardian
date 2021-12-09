/****** Object:  UserDefinedFunction [ETL].[FnCuatrienioMax]    Script Date: 16/10/2021 2:39:36 a. m. ******/
DROP FUNCTION [ETL].[FnCuatrienioMax]
GO

/****** Object:  UserDefinedFunction [ETL].[FnCuatrienioMax]    Script Date: 16/10/2021 2:39:36 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [ETL].[FnCuatrienioMax] (@Date [DATE]) RETURNS VARCHAR(4)
AS
BEGIN
    -- Declare the return variable here
    --Verifica Primer dia de la semana
	DECLARE @CuatrienioMax VARCHAR(4)

	--Calcula Cuatrenio
	SET @CuatrienioMax = CAST((((YEAR(@Date)-2)/4)*4)+5 AS VARCHAR(4))

	SET @CuatrienioMax = REPLICATE('0',4-LEN(@CuatrienioMax)) + @CuatrienioMax

	RETURN @CuatrienioMax
END

GO