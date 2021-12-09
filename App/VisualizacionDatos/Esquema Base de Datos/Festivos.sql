/****** Object:  Table [REF].[Festivos]    Script Date: 29/09/2021 4:24:08 p. m. ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[REF].[Festivos]') AND type in (N'U'))
DROP TABLE [REF].[Festivos]
GO

/****** Object:  Table [REF].[Festivos]    Script Date: 29/09/2021 4:24:08 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [REF].[Festivos]
(
	[IdFestivos] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [date] NULL,
	[Festivo] [varchar](100) NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[FechaModificacion] [datetime] NULL,
 CONSTRAINT [Pk_Ref_Festivos] PRIMARY KEY NONCLUSTERED 
	(
		[IdFestivos] ASC
	) NOT ENFORCED 
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX ( [IdFestivos] )
)
GO