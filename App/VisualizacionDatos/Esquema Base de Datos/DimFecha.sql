/****** Object:  Table [IM].[DimFecha]    Script Date: 29/09/2021 4:24:08 p. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[IM].[DimFecha]') AND type in (N'U'))
DROP TABLE [IM].[DimFecha]
GO

/****** Object:  Table [IM].[DimFecha]    Script Date: 29/09/2021 4:24:08 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [IM].[DimFecha]
(
	[IdDimFecha] [int] NOT NULL,
	[Fecha] [date] NULL,
	[CodigoEsDiaNoHabil] [int] NOT NULL,
	[EsDiaNoHabil] [varchar](20) NOT NULL,
	[CodigoEsFestivo] [int] NOT NULL,
	[EsFestivo] [varchar](20) NOT NULL,
	[Festivo] [varchar](100) NOT NULL,
	[Año] [int] NOT NULL,
	[Semestre] [int] NOT NULL,
	[NombreSemestre] [varchar](100) NOT NULL,
	[Trimeste] [int] NOT NULL,
	[NombreTrimestre] [varchar](100) NOT NULL,
	[Mes] [int] NOT NULL,
	[NombreMes] [varchar](100) NOT NULL,
	[Semana] [int] NOT NULL,
	[NombreSemana] [varchar](100) NOT NULL,
	[Dia] [int] NOT NULL,
	[DiaSemana] [int] NOT NULL,
	[NombreDiaSemana] [varchar](100) NOT NULL,
	[NombreInicioSemana] [varchar](100) NOT NULL,
	[Quincena] [int] NOT NULL,
	[NombreQuincena] [varchar](100) NOT NULL,
	[CuatrienioGobierno] [varchar](100) NOT NULL,
	[Cuatrienio] [varchar](100) NOT NULL,
	[Decada] [varchar](100) NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [Pk_Im_DimFecha] PRIMARY KEY NONCLUSTERED 
	(
		[IdDimFecha] ASC
	) NOT ENFORCED 
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX ( [IdDimFecha] )
)
GO