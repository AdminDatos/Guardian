/****** Object:  View [IM].[VwDimMedicamento]    Script Date: 29/10/2021 3:28:04 p. m. ******/
DROP VIEW [IM].[VwDimMedicamento]
GO

/****** Object:  View [IM].[VwDimMedicamento]    Script Date: 29/10/2021 3:28:05 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [IM].[VwDimMedicamento]
AS

SELECT DMED.[IdDimMedicamento]
      ,DMED.[CUM]
      ,DMED.[Nombre]
      ,DMED.[Precio]
      ,DMED.[Circular]
      ,DMED.[TipoPrecio]
      ,DMED.[FechaInicioCircular]
      ,DMED.[FechaFinCircular]
      ,DMED.[EsCircularActual] [CodigoEsCircularActual]
	  ,CASE WHEN DMED.[EsCircularActual] = 1 THEN 'SI' ELSE 'NO' END [EsCircularActual]
FROM [IM].[DimMedicamento] DMED

WHERE DMED.[IdDimMedicamento] IN (SELECT DISTINCT IVFF.[IdDimMedicamento] FROM [IM].[VwFactFacturas] IVFF)

GO