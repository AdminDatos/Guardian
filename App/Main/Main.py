
#LIBRERIAS NECESARIAS
import json
import time
import getopt
import uuid, sys
import os
from requests import get, post
from datetime import datetime #manejo formato fechas
import pandas as pd
import re
import shutil
from pyspark.sql.types import IntegerType
import decimal
from collections import namedtuple #módulo que permite crear subclases de tuplas con campos con nombre
import numpy as np
from pdf2image import convert_from_path


#PARAMETROS FORM-RECOGNIZER-REEMPLAZAR DATOS POR LOS QUE CORRESPONDAN

# Endpoint URL
endpoint = r""  
# Subscription Key
apim_key = ""
# Model ID
model_id = ""
# API version
API_version = "v2.1-preview.3"

post_url = endpoint + "/formrecognizer/%s/custom/models/%s/analyze" % (API_version, model_id)
params = {
  "includeTextDetails": True
}


#PARAMETROS CONEXION SYNAPSE-REEMPLAZAR DATOS POR LOS QUE CORRESPONDAN

#Definición de variables de conexión a datalake
storageAccountName = ''
storageAccountKey = ''
folder=''
blobContainer = 'synapse'
#Dirección del Storage Acoount, contenedor en el Data Lake
tempDir = "wasbs://{}@{}.blob.core.windows.net/".format(blobContainer, storageAccountName,folder)
#Password de acceso al Storage account
sparkConfigKey = "fs.azure.account.key.{}.blob.core.windows.net".format(storageAccountName)
sparkConfigValue = storageAccountKey

spark.conf.set(sparkConfigKey, sparkConfigValue)
sc._jsc.hadoopConfiguration().set(
  "",
  storageAccountKey)
jdbcUrl = ""


def main(argv):
    Corrida=[0,1]
    Inicio="" #CAMBIAR POR EL DIRECTORIO EN EL QUE SE ENCUENTREN LAS FACTURAS A PROCESAR
    Fin="/tmp" #DIRECTORIO TEMPORAL PARA GUARDAR LOS RESULTADOS DE LA EXTRACCIÓN
    Carpeta_Facturas=os.listdir(Inicio)
    cantC=0
    cantF=0
    print("carpetas",Carpeta_Facturas)
    for C in Carpeta_Facturas:
        cantC=cantC+1
        cantF=0
        inicio=Inicio+"/"+C
        facturas=os.listdir(inicio)
        for factura in facturas:
            cantF=cantF+1
            print("FACTURA #",cantC,"PAG #",cantF,factura)
            origen_Datos=Inicio+"/"+C+"/"+factura  #SE RECORREN LAS CARPETAS Y LAS PAGINAS PREPROCESADAS COMO IMAGENES
            fin_Datos=Fin+"/"+C+".json" #FORMATO DE SALIDA JSON
            print(origen_Datos)
            print("   ")
            print(fin_Datos)
            file_type='image/jpeg'
            os.chdir("/databricks/driver")
            input_file=origen_Datos 
            output_file=fin_Datos
            runAnalysis(input_file, output_file, file_type,cantC,cantF) 
            lectura(fin_Datos,cantC,cantF)
            Resultados=""  #CAMBIAR POR EL DIRECTORIO EN EL QUE SE ENCUENTREN LOS RESULTADOS
            os.chdir(Resultados)
            Carpeta_Resultados=os.listdir(Resultados)
            print(Carpeta_Resultados)
            for Carpeta in Carpeta_Resultados:
                Entidad=Resultados+"/"+Carpeta
                print(Entidad)
                os.chdir(Entidad)
                resultados=os.listdir(Entidad)
                print(resultados)
                for resultado in resultados:   
                    database=Entidad+"/"+resultado
                    df_Resultado=pd.read_parquet(database, engine='pyarrow') 
                    cargaDatos(df_Resultado)

