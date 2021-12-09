/****** Object:  Table [IM].[DimCliente]    Script Date: 19/10/2021 4:31:41 p. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[IM].[DimCliente]') AND type in (N'U'))
DROP TABLE [IM].[DimCliente]
GO

/****** Object:  Table [IM].[DimCliente]    Script Date: 19/10/2021 4:31:41 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [IM].[DimCliente]
(
	[IdDimCliente] [varchar](100) NOT NULL,
	[Nit] [varchar](50) NOT NULL,
	[RazonSocial] [varchar](100) NOT NULL,
	[FechaCreacion] [datetime2](7) NOT NULL,
	[FechaModificacion] [datetime2](7) NULL,
 CONSTRAINT [Pk_Im_DimCliente] PRIMARY KEY NONCLUSTERED 
	(
		[IdDimCliente] ASC
	) NOT ENFORCED 
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[IdDimCliente] ASC
	)
)
GO