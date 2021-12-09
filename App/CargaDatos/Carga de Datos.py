
#LECTURA INICIAL DE LAS TABLAS QUE VAN A SER UTILIZADAS DE SYNAPSE

df_Entidad=spark.read.format("com.databricks.spark.sqldw").option("url", jdbcUrl).option("tempdir", tempDir).option("forwardSparkAzureStorageCredentials", "true").option("dbTable", "IM.DimEntidad").load()
df_Cliente=spark.read.format("com.databricks.spark.sqldw").option("url", jdbcUrl).option("tempdir", tempDir).option("forwardSparkAzureStorageCredentials", "true").option("dbTable", "IM.DimCliente").load()
df_Fecha=spark.read.format("com.databricks.spark.sqldw").option("url", jdbcUrl).option("tempdir", tempDir).option("forwardSparkAzureStorageCredentials", "true").option("dbTable", "IM.DimFecha").load()
df_Medicamentos=spark.read.format("com.databricks.spark.sqldw").option("url", jdbcUrl).option("tempdir", tempDir).option("forwardSparkAzureStorageCredentials", "true").option("dbTable", "IM.DimMedicamento").load()
display(df_Entidad)
display(df_Fecha)
display(df_Cliente)
display(df_Medicamentos)

df_Ent=df_Entidad.toPandas()
df_Cliente=df_Cliente.toPandas()
df_Fecha=df_Fecha.toPandas()
df_Medicamento=df_Medicamentos.toPandas()

#LISTAS Y PARAMETROS INICIALES

DfEntidad2= []
DfCliente2=[]
DfMedicamentos=[]
context=decimal.getcontext()
context.prec,context.Emax,=4,2

#DATOS QUEMADOS PARA EL PRIMER REGISTRO DE TAL FORMA QUE SE OBTENGA EXACTAMENTE EL MISMO FORMATO PARA TODOS LOS CAMPOS

#SOLO SE REALIZA LA PRIMERA VEZ


id_Entidad='1'
id_Cliente='1'
id_Med='1NUM 1'
id_Fecha=int(-1)
No_Factura='111'
Cantidad=int(0)
PrecioUnidad=float(100000000000000)
PrecioU=format(PrecioUnidad, '.4f')
PrecioUnidad=decimal.Decimal(PrecioU)
PrecioTotal=PrecioUnidad
ValorDescuento=PrecioUnidad
DiferenciaPrecioCircular=PrecioUnidad
CumplePrecioCircular=True
FechaCreacion=datetime.now()
FechaModificacion=datetime.now()
Medicamentos={'IdDimEntidad':id_Entidad,'IdDimCliente':id_Cliente,'IdDimMedicamento':id_Med,'IdDimFechaFactura':id_Fecha,'NumeroFactura':No_Factura,'Cantidad':Cantidad,'PrecioUnidad':PrecioUnidad,'ValorDescuento':ValorDescuento,'PrecioTotal':PrecioTotal,'DiferenciaPrecioCircular':DiferenciaPrecioCircular,'CumplePrecioCircular':CumplePrecioCircular,'FechaCreacion':FechaCreacion,'FechaModificacion':FechaModificacion}
DfMedicamentos.append(Medicamentos)
    

#FUNCION QUE RECIBE LOS ARCHIVOS DE PARQUET CON LA INFORMACION DE LAS FACTURAS Y CARGA LOS DATOS AL SYNAPSE

def cargaDatos(Resultado):
    for index, row in Resultado.iterrows():
## CARGAR ENTIDADES Y CLIENTES

        df_Entidad=spark.read.format("com.databricks.spark.sqldw").option("url", jdbcUrl).option("tempdir", tempDir).option("forwardSparkAzureStorageCredentials", "true").option("dbTable", "IM.DimEntidad").load()
        df_Cliente=spark.read.format("com.databricks.spark.sqldw").option("url", jdbcUrl).option("tempdir", tempDir).option("forwardSparkAzureStorageCredentials", "true").option("dbTable", "IM.DimCliente").load()
        df_Ent=df_Entidad.toPandas()
        df_Cliente=df_Cliente.toPandas()

    #######CARGAR ENTIDADES
        if row["NitEntidad"] in df_Ent.values or row["RazonSocialEntidad"] in df_Ent.values:
            print("NIT ENCONTRADO",row["NitEntidad"])
            if row["NitEntidad"] in df_Ent.values:
                reqd_Index = df_Ent[df_Ent['Nit']==row["NitEntidad"]].index.tolist()
                Index=reqd_Index[0]
                id_Entidad=(df_Ent.loc[Index, 'IdDimEntidad'])
            elif row["RazonSocialEntidad"] in df_Ent.values:
                reqd_Index = df_Ent[df_Ent['RazonSocial']==row["RazonSocialEntidad"]].index.tolist()
                Index=reqd_Index[0]
                id_Entidad=(df_Ent.loc[Index, 'IdDimEntidad'])
        else:    
            NitEntidad=str(row["NitEntidad"])
            id_Entidad=NitEntidad
            RazonSocialEntidad=row["RazonSocialEntidad"]
            FechaCreacion=datetime.now()
            FechaModificacion=datetime.now()
            Entidad={'IdDimEntidad':id_Entidad,'Nit':NitEntidad,'RazonSocial':RazonSocialEntidad,'FechaCreacion':FechaCreacion,'FechaModificacion':FechaModificacion}
            DfEntidad2= []
            DfEntidad2.append(Entidad)
            dfEntidad=pd.DataFrame(DfEntidad2)
            df_CargaE = spark.createDataFrame(dfEntidad)
            df_CargaE.write.format("com.databricks.spark.sqldw").option("url", jdbcUrl).option("tempdir", tempDir).option("forwardSparkAzureStorageCredentials", "true").option("dbTable", "IM.DimEntidad").mode("Append").save()

    #######CARGAR CLIENTES 

        if row["NitCliente"] in df_Cliente.values or row["RazonSocialCliente"] in df_Cliente.values:
            print("CLIENTE ENCONTRADO",row["NitCliente"])
            if row["NitCliente"] in df_Cliente.values:
                reqd_Index = df_Cliente[df_Cliente['Nit']==row["NitCliente"]].index.tolist()
                Index=reqd_Index[0]
                Id_Cliente=(df_Cliente.loc[Index, 'IdDimCliente'])
            elif row["RazonSocialCliente"] in df_Cliente.values:
                reqd_Index = df_Cliente[df_Cliente['RazonSocial']==row["RazonSocialCliente"]].index.tolist()
                Index=reqd_Index[0]
                id_Cliente=(df_Cliente.loc[Index, 'IdDimCliente'])
        else:    
            NitCliente=str(row["NitCliente"])
            id_Cliente=NitCliente
            RazonSocialCliente=row["RazonSocialCliente"]
            FechaCreacion=datetime.now()
            FechaModificacion=datetime.now()
            Cliente={'IdDimCliente':id_Cliente,'Nit':NitCliente,'RazonSocial':RazonSocialCliente,'FechaCreacion':FechaCreacion,'FechaModificacion':FechaModificacion}
            DfCliente2=[]
            DfCliente2.append(Cliente)
            dfCliente=pd.DataFrame(DfCliente2)
            df_CargaC = spark.createDataFrame(dfCliente)
            df_CargaC.write.format("com.databricks.spark.sqldw").option("url", jdbcUrl).option("tempdir", tempDir).option("forwardSparkAzureStorageCredentials", "true").option("dbTable", "IM.DimCliente").mode("Append").save()

    #######LEER FECHA 

        Fecha=datetime.strptime(row["FechaFact"], '%Y/%m/%d').date()
        if Fecha in df_Fecha.values:
            reqd_Index = df_Fecha[df_Fecha['Fecha']==Fecha].index.tolist()
            Index=reqd_Index[0]
            id_Fecha=int((df_Fecha.loc[Index, 'IdDimFecha']))
        else:
            id_Fecha=int(-1)
    ######MEDICAMENTOS

        if row["CUM"] in df_Medicamento.values or row["Nombre"] in df_Medicamento.values:
            if row["CUM"] in df_Medicamento.values:
                reqd_Index = df_Medicamento[df_Medicamento['CUM']==row["CUM"]].index.tolist()
                Index=reqd_Index[0]
                id_Med=(df_Medicamento.loc[Index, 'IdDimMedicamento'])
            elif row["Nombre"] in df_Medicamento.values:
                reqd_Index = df_Medicamento[df_Medicamento['Nombre']==row["Nombre"]].index.tolist()
                Index=reqd_Index[0]
                id_Med=(df_Medicamento.loc[Index, 'IdDimMedicamento'])
        else:   
              id_Med='1NUM 1'
    ##### CONSOLIDA TABLA DE HECHOS

        No_Factura=str(row["NFactura"])
        reqd_Index = df_Medicamento[df_Medicamento['IdDimMedicamento']==id_Med].index.tolist()
        Index=reqd_Index[0]

        Cantidad=int(row["Cantidad"])
        PrecioMed=float((df_Medicamento.loc[Index, 'Precio']))
        PrecioFactU=float(row["PrecioUnidad"])

        PrecioFactT=float(row["PrecioTotal"])
        if Cantidad!=0:
            Descuento=float((PrecioFactT/Cantidad)-PrecioFactU)
        if id_Med!='1NUM 1':
            DifPrecios=float(PrecioFactU-PrecioMed)
        else:
            DifPrecios=0
        if DifPrecios>0:
            CumplePrecioCircular=False
        else:
            CumplePrecioCircular=True

        PrecioU=format(PrecioFactU, '.4f')
        PrecioUnidad=decimal.Decimal(PrecioU)
        Desc=format(Descuento, '.4f')
        ValorDescuento=decimal.Decimal(Desc)
        PrecioT=format(PrecioFactT, '.4f')
        PrecioTotal=decimal.Decimal(PrecioT)
        DifP=format(DifPrecios,'.4f')
        DiferenciaPrecioCircular=decimal.Decimal(DifP)
        FechaCreacion=datetime.now()
        FechaModificacion=datetime.now()
        Medicamentos={'IdDimEntidad':id_Entidad,'IdDimCliente':id_Cliente,'IdDimMedicamento':id_Med,'IdDimFechaFactura':id_Fecha,'NumeroFactura':No_Factura,'Cantidad':Cantidad,'PrecioUnidad':PrecioUnidad,'ValorDescuento':ValorDescuento,'PrecioTotal':PrecioTotal,'DiferenciaPrecioCircular':DiferenciaPrecioCircular,'CumplePrecioCircular':CumplePrecioCircular,'FechaCreacion':FechaCreacion,'FechaModificacion':FechaModificacion}
        DfMedicamentos.append(Medicamentos)


    

    dfMed=pd.DataFrame(DfMedicamentos)
    print(dfMed)
    print(dfMed["Cantidad"].max())

    print(spark.createDataFrame(dfMed))
    df_CargaM=spark.createDataFrame(dfMed)
    df_CargaM2 = df_CargaM.withColumn("Cantidad", df_CargaM["Cantidad"].cast(IntegerType()))
    df_CargaM3 = df_CargaM2.withColumn("IdDimFechaFactura", df_CargaM2["IdDimFechaFactura"].cast(IntegerType()))
    df_CargaM3.write.format("com.databricks.spark.sqldw").option("url", jdbcUrl).option("tempdir", tempDir).option("forwardSparkAzureStorageCredentials", "true").option("dbTable", "IM.FactFacturas").mode("Append").save()

  

