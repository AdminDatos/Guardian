/****** Object:  View [IM].[VwFacturas]    Script Date: 21/10/2021 5:05:23 p. m. ******/
DROP VIEW [IM].[VwFacturas]
GO

/****** Object:  View [IM].[VwFacturas]    Script Date: 21/10/2021 5:05:28 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [IM].[VwFacturas]
AS

SELECT FAC.[IdFactura] [Id Factura]
	  ,FFAC.[NumeroFactura] [Numero Factura]
	  ,DFFACT.[Fecha] [Fecha Factura]
	  ,DENT.[IdEntidad] [Id Entidad]
	  ,DENT.[Nit] [Nit Entidad]
	  ,DENT.[RazonSocial] [Razon Social Entidad]
	  ,DCLI.[IdCliente] [Id Cliente]
	  ,DCLI.[Nit] [Nit Cliente]
	  ,DCLI.[RazonSocial] [Razon Social Cliente]
	  ,DMED.[CUM]
      ,DMED.[Nombre] [Nombre Medicamento Circular]
      ,DMED.[Precio] [Precio Medicamento Circular]
      ,DMED.[Circular]
      ,DMED.[TipoPrecio] [Tipo Precio Medicamento Circular]
      ,DMED.[FechaInicioCircular] [Fecha Inicio Circular]
      ,DMED.[FechaFinCircular] [Fecha Fin Circular]
      ,DMED.[EsCircularActual] [Es Circular Actual]
      ,FFAC.[Cantidad] [Cantidad Factura]
      ,FFAC.[PrecioUnidad] [Precio Unidad Factura]
      ,FFAC.[ValorDescuento] [Valor Descuento Factura]
      ,FFAC.[PrecioTotal] [Precio Total Factura]
      ,FFAC.[DiferenciaPrecioCircular] [Diferencia Precio Circular]
      ,FFAC.[CumplePrecioCircular] [Cumple Precio Circular]
	  ,CASE WHEN FFAC.[IdDimMedicamento] <> '1NUM 1' THEN 'SI' ELSE 'NO' END [Es Medicamento Controlado]
	  ,FFAC.[FechaCreacion] [Fecha Creacion]
      ,FFAC.[FechaModificacion] [Fecha Modificacion]
FROM [IM].[FactFacturas] FFAC

INNER JOIN [IM].[DimMedicamento] DMED
ON FFAC.[IdDimMedicamento] = DMED.[IdDimMedicamento]

INNER JOIN [IM].[DimFecha] DFFACT
ON FFAC.[IdDimFechaFactura] = DFFACT.[IdDimFecha]

INNER JOIN
(
	SELECT *, ROW_NUMBER() OVER(ORDER BY [Nit] ASC) [IdEntidad]
	FROM [IM].[DimEntidad]
) DENT
ON FFAC.[IdDimEntidad] = DENT.[IdDimEntidad]

INNER JOIN
(
	SELECT *, ROW_NUMBER() OVER(ORDER BY [Nit] ASC) [IdCliente]
	FROM [IM].[DimCliente]
) DCLI
ON FFAC.[IdDimCliente] = DCLI.[IdDimCliente]

INNER JOIN
(
	SELECT *, ROW_NUMBER() OVER(ORDER BY [NumeroFactura] ASC) [IdFactura]
	FROM
	(
		SELECT DISTINCT [NumeroFactura], [IdDimFechaFactura]
		FROM [IM].[FactFacturas] 
	) FAC
) FAC
ON FFAC.[NumeroFactura] = FAC.[NumeroFactura]
AND FFAC.[IdDimFechaFactura] = FAC.[IdDimFechaFactura]

GO