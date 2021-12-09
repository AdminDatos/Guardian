/****** Object:  Table [IM].[DimEntidad]    Script Date: 19/10/2021 4:32:59 p. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[IM].[DimEntidad]') AND type in (N'U'))
DROP TABLE [IM].[DimEntidad]
GO

/****** Object:  Table [IM].[DimEntidad]    Script Date: 19/10/2021 4:32:59 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [IM].[DimEntidad]
(
	[IdDimEntidad] [varchar](100) NOT NULL,
	[Nit] [varchar](50) NOT NULL,
	[RazonSocial] [varchar](100) NOT NULL,
	[FechaCreacion] [datetime2](7) NOT NULL,
	[FechaModificacion] [datetime2](7) NULL,
 CONSTRAINT [Pk_Im_DimEntidad] PRIMARY KEY NONCLUSTERED 
	(
		[IdDimEntidad] ASC
	) NOT ENFORCED 
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[IdDimEntidad] ASC
	)
)
GO