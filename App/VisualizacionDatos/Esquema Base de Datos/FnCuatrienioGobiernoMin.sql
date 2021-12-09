/****** Object:  UserDefinedFunction [ETL].[FnCuatrienioGobiernoMin]    Script Date: 16/10/2021 2:39:36 a. m. ******/
DROP FUNCTION [ETL].[FnCuatrienioGobiernoMin]
GO

/****** Object:  UserDefinedFunction [ETL].[FnCuatrienioGobiernoMin]    Script Date: 16/10/2021 2:39:36 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [ETL].[FnCuatrienioGobiernoMin] (@Date [DATE]) RETURNS VARCHAR(4)
AS
BEGIN
    -- Declare the return variable here
    --Verifica Primer dia de la semana
	DECLARE @PrimerDiaSemana INT = [ETL].[FnPrimerDiasemana](@Date),
	@CuatrienioGobiernoMin VARCHAR(4)

	--Calcula Cuatrenio Gobierno
	IF @Date > '00010806'
	BEGIN
		SET @CuatrienioGobiernoMin = CAST((((YEAR(DATEADD(dd,-218,@Date))-2)/4)*4)+2 AS VARCHAR(4))

		SET @CuatrienioGobiernoMin = REPLICATE('0',4-LEN(@CuatrienioGobiernoMin)) + @CuatrienioGobiernoMin
	END
	ELSE
	BEGIN
		SET @CuatrienioGobiernoMin = '0000'
	END
	RETURN @CuatrienioGobiernoMin
END

GO