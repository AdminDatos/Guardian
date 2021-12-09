/****** Object:  UserDefinedFunction [ETL].[FnPrimerDiasemana]    Script Date: 16/10/2021 2:39:36 a. m. ******/
DROP FUNCTION [ETL].[FnPrimerDiasemana]
GO

/****** Object:  UserDefinedFunction [ETL].[FnPrimerDiasemana]    Script Date: 16/10/2021 2:39:36 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [ETL].[FnPrimerDiasemana] (@Date [DATE]) RETURNS INT
AS
BEGIN
    -- Declare the return variable here
    --Verifica Primer dia de la semana
	DECLARE @PrimerDiaSemana INT
	DECLARE @PrimeraFecha DATE = '00010101'

	IF (DATEPART(dw, @Date) = 2)
	BEGIN
		IF @Date = @PrimeraFecha
		BEGIN
			SET @PrimerDiaSemana = DATEPART(dd,DATEADD(wk,DATEDIFF(wk,@PrimeraFecha,@Date),@PrimeraFecha))
		END
		ELSE
		BEGIN 
			SET @PrimerDiaSemana = DATEPART(dd,DATEADD(wk,DATEDIFF(wk,@PrimeraFecha,DATEADD(dd,-1,@Date)),@PrimeraFecha))
		END
	END
	ELSE
	BEGIN
		IF @Date = @PrimeraFecha
		BEGIN
			SET @PrimerDiaSemana = DATEPART(dd,DATEADD(wk,DATEDIFF(wk,@PrimeraFecha,@Date),@PrimeraFecha))
		END
		ELSE
		BEGIN 
			SET @PrimerDiaSemana = DATEPART(dd,DATEADD(wk,DATEDIFF(wk,@PrimeraFecha,DATEADD(dd,-1,@Date)),@PrimeraFecha))
		END
	END
	RETURN @PrimerDiaSemana
END

GO