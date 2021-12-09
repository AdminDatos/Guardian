/****** Object:  View [IM].[VwDimCliente]    Script Date: 29/10/2021 3:28:04 p. m. ******/
DROP VIEW [IM].[VwDimCliente]
GO

/****** Object:  View [IM].[VwDimCliente]    Script Date: 29/10/2021 3:28:05 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [IM].[VwDimCliente]
AS

SELECT DCLI.[IdDimCliente]
      ,DCLI.[Nit]
      ,DCLI.[RazonSocial]
FROM [IM].[DimCliente] DCLI

GO