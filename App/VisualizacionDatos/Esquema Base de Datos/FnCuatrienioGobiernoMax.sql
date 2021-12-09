/****** Object:  UserDefinedFunction [ETL].[FnCuatrienioGobiernoMax]    Script Date: 16/10/2021 2:39:36 a. m. ******/
DROP FUNCTION [ETL].[FnCuatrienioGobiernoMax]
GO

/****** Object:  UserDefinedFunction [ETL].[FnCuatrienioGobiernoMax]    Script Date: 16/10/2021 2:39:36 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [ETL].[FnCuatrienioGobiernoMax] (@Date [DATE]) RETURNS VARCHAR(4)
AS
BEGIN
    -- Declare the return variable here
    --Verifica Primer dia de la semana
	DECLARE @PrimerDiaSemana INT = [ETL].[FnPrimerDiasemana](@Date),
	@CuatrienioGobiernoMax VARCHAR(4)

	--Calcula Cuatrenio Gobierno
	IF @Date > '00010806'
	BEGIN
		SET @CuatrienioGobiernoMax = CAST((((YEAR(DATEADD(dd,-218,@Date))-2)/4)*4)+6 AS VARCHAR(4))

		SET @CuatrienioGobiernoMax = REPLICATE('0',4-LEN(@CuatrienioGobiernoMax)) + @CuatrienioGobiernoMax
	END
	ELSE
	BEGIN
		SET @CuatrienioGobiernoMax = '0002'
	END
	RETURN @CuatrienioGobiernoMax
END

GO