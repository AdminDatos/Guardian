/****** Object:  Table [IM].[DimMedicamento]    Script Date: 19/10/2021 4:34:39 p. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[IM].[DimMedicamento]') AND type in (N'U'))
DROP TABLE [IM].[DimMedicamento]
GO

/****** Object:  Table [IM].[DimMedicamento]    Script Date: 19/10/2021 4:34:39 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [IM].[DimMedicamento]
(
	[IdDimMedicamento] [varchar](100) NOT NULL,
	[CUM] [varchar](50) NOT NULL,
	[Nombre] [varchar](300) NOT NULL,
	[Precio] [money] NOT NULL,
	[Circular] [varchar](100) NOT NULL,
	[TipoPrecio] [varchar](100) NOT NULL,
	[FechaInicioCircular] [date] NOT NULL,
	[FechaFinCircular] [date] NULL,
	[EsCircularActual] [bit] NOT NULL,
	[FechaCreacion] [datetime2](7) NOT NULL,
	[FechaModificacion] [datetime2](7) NULL,
 CONSTRAINT [Pk_Im_DimMedicamento] PRIMARY KEY NONCLUSTERED 
	(
		[IdDimMedicamento] ASC
	) NOT ENFORCED 
)
WITH
(
	DISTRIBUTION = HASH ( [IdDimMedicamento] ),
	CLUSTERED INDEX
	(
		[IdDimMedicamento] ASC
	)
)
GO