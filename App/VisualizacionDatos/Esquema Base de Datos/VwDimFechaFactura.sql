/****** Object:  View [IM].[VwDimFechaFactura]    Script Date: 29/10/2021 3:28:04 p. m. ******/
DROP VIEW [IM].[VwDimFechaFactura]
GO

/****** Object:  View [IM].[VwDimFechaFactura]    Script Date: 29/10/2021 3:28:05 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [IM].[VwDimFechaFactura]
AS

SELECT DFEC.[IdDimFecha]
      ,DFEC.[Fecha]
      ,DFEC.[CodigoEsDiaNoHabil]
      ,DFEC.[EsDiaNoHabil]
      ,DFEC.[CodigoEsFestivo]
      ,DFEC.[EsFestivo]
      ,DFEC.[Festivo]
      ,CAST(DFEC.[Año] AS CHAR(4)) [Año]
      ,DFEC.[Semestre] [SemestreNumero]
      ,DFEC.[NombreSemestre] [SemestreNombre]
      ,DFEC.[Trimeste] [TrimesteNumero]
      ,DFEC.[NombreTrimestre] [TrimesteNombre]
      ,DFEC.[Mes] [MesNumero]
      ,DFEC.[NombreMes] [MesNombre]
      ,DFEC.[Semana] [SemanaNumero]
      ,DFEC.[NombreSemana] [SemanaNombre]
      ,CAST(DFEC.[Dia] AS VARCHAR(2)) [Dia]
      ,DFEC.[DiaSemana] [DiaSemanaNumero]
      ,DFEC.[NombreDiaSemana] [DiaSemanaNombre]
      ,DFEC.[NombreInicioSemana] [InicioSemanaNombre]
      ,DFEC.[Quincena] [QuincenaNumero]
      ,DFEC.[NombreQuincena] [QuincenaNombre]
      ,DFEC.[CuatrienioGobierno]
      ,DFEC.[Cuatrienio]
      ,DFEC.[Decada]
FROM [IM].[DimFecha] DFEC

WHERE DFEC.[IdDimFecha] IN (SELECT DISTINCT IVFF.[IdDimFechaFactura] FROM [IM].[VwFactFacturas] IVFF)

GO