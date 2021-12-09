/****** Object:  View [IM].[VwDimFactura]    Script Date: 29/10/2021 3:28:04 p. m. ******/
DROP VIEW [IM].[VwDimFactura]
GO

/****** Object:  View [IM].[VwDimFactura]    Script Date: 29/10/2021 3:28:05 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [IM].[VwDimFactura]
AS

SELECT DISTINCT CONCAT(FFAC.[NumeroFactura],FFAC.[IdDimFechaFactura],FFAC.[IdDimMedicamento],FFAC.[CumplePrecioCircular]) [IdDimFactura]
      ,FFAC.[NumeroFactura]
	  ,FFAC.[CumplePrecioCircular] [CodigoCumplePrecioCircular]
	  ,CASE WHEN FFAC.[CumplePrecioCircular] = 1 THEN 'SI' ELSE 'NO' END [CumplePrecioCircular]
	  ,CASE WHEN FFAC.[IdDimMedicamento] <> '1NUM 1' THEN 'SI' ELSE 'NO' END [EsMedicamentoRegulado]
FROM [IM].[FactFacturas] FFAC

GO