/****** Object:  View [IM].[VwDimEntidad]    Script Date: 29/10/2021 3:28:04 p. m. ******/
DROP VIEW [IM].[VwDimEntidad]
GO

/****** Object:  View [IM].[VwDimEntidad]    Script Date: 29/10/2021 3:28:05 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [IM].[VwDimEntidad]
AS

SELECT DENT.[IdDimEntidad]
      ,DENT.[Nit]
      ,DENT.[RazonSocial]
FROM [IM].[DimEntidad] DENT

GO