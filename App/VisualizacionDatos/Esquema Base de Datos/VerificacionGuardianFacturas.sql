

SELECT TB.*,ROW_NUMBER() OVER(PARTITION BY TB.[IdDimCliente],TB.[Nit],TB.[RazonSocial] ORDER BY TB.[Nit]) [Id]
--INTO [IM].[DimCliente2]
FROM [IM].[DimCliente] TB
INNER JOIN
(
	SELECT [Nit],COUNT(*) [Cantidad]
	FROM [IM].[DimCliente]
	GROUP BY [Nit]
	HAVING COUNT(*) > 1
) REP
ON TB.[Nit] = REP.[Nit]
ORDER BY 1


--UPDATE TB
--	SET [RazonSocial] = 'DROGUERIAS RIVERA'
----SELECT TB.*
--FROM [IM].[DimCliente] TB
--WHERE TB.[Nit] = '80844502'


----Elimina Duplicados
--DECLARE @Esquema VARCHAR(128) = 'IM'
--DECLARE @Tabla VARCHAR(128) = 'DimCliente'
--DECLARE @Campos VARCHAR(MAX) = NULL
--DECLARE @CamposOrden VARCHAR(MAX) = 'Nit'
--DECLARE @ExceptoCampos VARCHAR(MAX) = 'FechaCreacion,FechaModificacion'
--DECLARE @Texto BIT = 0

--EXECUTE [ETL].[SpEliminaRegistrosDuplicados]
--	 @Esquema
--    ,@Tabla
--	,@Campos
--	,@CamposOrden
--	,@ExceptoCampos
--	,@Texto


SELECT TB.*
FROM [IM].[DimEntidad] TB
INNER JOIN
(
	SELECT [Nit],COUNT(*) [Cantidad]
	FROM [IM].[DimEntidad]
	GROUP BY [Nit]
	HAVING COUNT(*) > 1
) REP
ON TB.[Nit] = REP.[Nit]
ORDER BY 1


SELECT TB.*,ROW_NUMBER() OVER(PARTITION BY TB.[IdDimMedicamento],TB.[CUM],TB.[Circular] ORDER BY TB.[Precio]) [Id]
--INTO [IM].[DimMedicamento2]
FROM [IM].[DimMedicamento] TB
INNER JOIN
(
	SELECT [CUM],[Circular],COUNT(*) [Cantidad]
	FROM [IM].[DimMedicamento]
	GROUP BY [CUM],[Circular]
	HAVING COUNT(*) > 1
) REP
ON TB.[CUM] = REP.[CUM]
AND TB.[Circular] = REP.[Circular]
ORDER BY 1


SELECT TB.*
FROM [IM].[FactFacturas] TB
INNER JOIN
(
	--SELECT [NumeroFactura],[IdDimFechaFactura],[IdDimMedicamento],COUNT(*) [Cantidad]
	SELECT CONCAT([NumeroFactura],[IdDimFechaFactura],[IdDimMedicamento]) [Id],COUNT(*) [Cantidad]
	FROM [IM].[FactFacturas]
	--GROUP BY [NumeroFactura],[IdDimFechaFactura],[IdDimMedicamento]
	GROUP BY CONCAT([NumeroFactura],[IdDimFechaFactura],[IdDimMedicamento])
	HAVING COUNT(*) > 1
) REP
--ON TB.[NumeroFactura] = REP.[NumeroFactura]
--AND TB.[IdDimFechaFactura] = REP.[IdDimFechaFactura]
--AND TB.[IdDimMedicamento] = REP.[IdDimMedicamento]
ON CONCAT(TB.[NumeroFactura],TB.[IdDimFechaFactura],TB.[IdDimMedicamento]) = REP.[Id]
ORDER BY 1


SELECT FFAC.[DiferenciaPrecioCircular], (FFAC.[PrecioUnidad] - DMED.[Precio]) [DiferenciaCalculada],*
FROM [IM].[FactFacturas] FFAC
INNER JOIN [IM].[DimMedicamento] DMED
ON FFAC.[IdDimMedicamento] = DMED.[IdDimMedicamento]
WHERE FFAC.[IdDimMedicamento] <> '1NUM 1'
AND FFAC.[DiferenciaPrecioCircular] <> (FFAC.[PrecioUnidad] - DMED.[Precio])


SELECT COUNT(DISTINCT CONCAT([NumeroFactura],[IdDimFechaFactura])), SUM([Cantidad])
FROM [IM].[FactFacturas] FFAC