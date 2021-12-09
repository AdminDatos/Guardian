/****** Object:  Table [IM].[FactFacturas]    Script Date: 19/10/2021 4:38:22 p. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[IM].[FactFacturas]') AND type in (N'U'))
DROP TABLE [IM].[FactFacturas]
GO

/****** Object:  Table [IM].[FactFacturas]    Script Date: 19/10/2021 4:38:22 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [IM].[FactFacturas]
(
	[IdDimEntidad] [varchar](100) NOT NULL,
	[IdDimCliente] [varchar](100) NOT NULL,
	[IdDimMedicamento] [varchar](100) NOT NULL,
	[IdDimFechaFactura] [int] NOT NULL,
	[NumeroFactura] [varchar](50) NOT NULL,
	[Cantidad] [int] NOT NULL,
	[PrecioUnidad] [money] NOT NULL,
	[ValorDescuento] [money] NOT NULL,
	[PrecioTotal] [money] NOT NULL,
	[DiferenciaPrecioCircular] [money] NULL,
	[CumplePrecioCircular] [bit] NOT NULL,
	[FechaCreacion] [datetime2](7) NOT NULL,
	[FechaModificacion] [datetime2](7) NULL,
 CONSTRAINT [Pk_Im_FactFacturas] PRIMARY KEY NONCLUSTERED 
	(
		[IdDimMedicamento] ASC,
		[IdDimFechaFactura] ASC,
		[NumeroFactura] ASC
	) NOT ENFORCED 
)
WITH
(
	DISTRIBUTION = HASH ( [IdDimMedicamento] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO