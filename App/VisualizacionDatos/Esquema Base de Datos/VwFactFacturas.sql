/****** Object:  View [IM].[VwFactFacturas]    Script Date: 29/10/2021 3:28:04 p. m. ******/
DROP VIEW [IM].[VwFactFacturas]
GO

/****** Object:  View [IM].[VwFactFacturas]    Script Date: 29/10/2021 3:28:05 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [IM].[VwFactFacturas]
AS

SELECT FFAC.[IdDimEntidad]
      ,FFAC.[IdDimCliente]
      ,FFAC.[IdDimMedicamento]
      ,FFAC.[IdDimFechaFactura]
	  ,CONCAT(FFAC.[NumeroFactura],FFAC.[IdDimFechaFactura],FFAC.[IdDimMedicamento],FFAC.[CumplePrecioCircular]) [IdDimFactura]
	  ,CONCAT(FFAC.[NumeroFactura],FFAC.[IdDimFechaFactura]) [CodigoFactura]
      ,FFAC.[Cantidad] [CantidadProductosFuente]
      ,FFAC.[PrecioUnidad] [PrecioUnidadFuente]
      ,FFAC.[ValorDescuento] [ValorDescuentoFuente]
      ,FFAC.[PrecioTotal] [PrecioTotalFuente]
      ,FFAC.[DiferenciaPrecioCircular] [DiferenciaPrecioCircularFuente]
FROM [IM].[FactFacturas] FFAC

GO