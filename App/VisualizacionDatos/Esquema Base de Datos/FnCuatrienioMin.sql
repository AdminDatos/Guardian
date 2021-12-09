/****** Object:  UserDefinedFunction [ETL].[FnCuatrienioMin]    Script Date: 16/10/2021 2:39:36 a. m. ******/
DROP FUNCTION [ETL].[FnCuatrienioMin]
GO

/****** Object:  UserDefinedFunction [ETL].[FnCuatrienioMin]    Script Date: 16/10/2021 2:39:36 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [ETL].[FnCuatrienioMin] (@Date [DATE]) RETURNS VARCHAR(4)
AS
BEGIN
    -- Declare the return variable here
    --Verifica Primer dia de la semana
	DECLARE @CuatrienioMin VARCHAR(4)

	--Calcula Cuatrenio
	SET @CuatrienioMin = CAST((((YEAR(@Date)-2)/4)*4)+2 AS VARCHAR(4))

	SET @CuatrienioMin = REPLICATE('0',4-LEN(@CuatrienioMin)) + @CuatrienioMin

	RETURN @CuatrienioMin
END

GO