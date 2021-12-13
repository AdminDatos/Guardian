## GUARDIÁN

# SIC: Superintendencia de Industria y Comercio

# OBJETIVO

Mejorar el proceso de vigilancia de los precios de medicamentos controlados, que efectúa la delegatura de Metrología Legal de la Superintendencia de Industria y Comercio (SIC), en virtud de la normatividad vigente.

# CONTEXTO

La ley 100 de 1993 y la ley 1438 de 2011, confieren a la Comisión Nacional de Precios de
Medicamentos y Dispositivos Médicos – CNPMDM, la formulación y regulación de la
política de precios de medicamentos
La ley 1438 de 2011, faculta a la Superintendencia de Industria y Comercio para multar
a cualquier entidad, agente o actor en la cadena de producción, distribución,
comercialización u otras formas de intermediación de medicamentos, dispositivos
médicos o bienes del sector salud, cuando infrinjan el régimen aplicable al control de
precios de medicamentos o dispositivos médicos.

La Superintendencia de Industria y Comercio tiene asignada la competencia de
inspección, vigilancia y control del cumplimiento de los regímenes de control de
precios establecidos para los siguientes productos:

✓ Agroquímicos: según las disposiciones del Ministerio de Agricultura y Desarrollo
Rural bajo el régimen de libertad vigilada (reporte de precios).

✓ Compra de leche cruda: según las disposiciones del Ministerio de Agricultura y
Desarrollo Rural bajo el régimen de libertad regulada (todas las personas naturales o
jurídicas que adquieran leche cruda con fines industriales o comerciales deben
aplicar el sistema de pago establecido por el Gobierno Nacional).

✓ Medicamentos y dispositivos médicos: según las disposiciones del Ministerio de
Salud y Protección Social bajo dos (2) regímenes: (i) libertad vigilada (reporte de
precios) y (ii) Control Directo (precio máximo).

# PROBLEMATICA

La inspección, vigilancia y control se realizan actualmente mediante un proceso de
análisis y comparaciones realizados por los expertos de la delegatura de metrología de
la SIC en forma manual y puntual:
SISMED

Este proceso tiene posibilidades de mejora:

1. La cantidad de medicamentos que se pueden vigilar esta limitada por la capacidad
de los expertos que revisan en SISMED

2. La cantidad de facturas que se pueden revisar se reduce a las que se piden cuando
se encuentra una alerta, y en la cantidad que pueden revisar los expertos de la
delegatura de forma manual

3. La cantidad de información disponible para revisar puede aumentar notoriamente si
se cambia el proceso con la ayuda de herramientas de analítica

# POSIBILIDADES DE MEJORA

1. Fuentes de información:

   • Revisar posibilidad de acceder a SISMED mediante servicios y traer información
   directamente del sistema, lo cual permitiría aumentar la cantidad de medicamentos
   inspeccionados

   • Acceder a facturas mediante sistemas interoperabilidad con los actores del mercado
   a los cuales pedimos facturas

2. Inspección de precios:

   • La revisión de precios en SISMED se puede hacer automáticamente si logramos
   interoperabilidad con SISMED y con software que optimice el proceso

   • La revisión de las facturas se puede mejorar con herramientas de analítica para
   procesar un número mucho mayor mediante componentes para análisis de imágenes
   y texto

# BENEFICIOS 

1) Mayor capacidad y rigurosidad en el proceso de vigilancia de precios de
medicamentos controlados realizado por la delegatura de metrología de la SIC.

2) Dará más herramientas a la entidad para encontrar los infractores, y por tanto,
beneficio al país en sus sistema de salud y sus finanzas debido al control mas
riguroso de los precios.

3) Se demostrará que el proceso puede ser optimizado y así se convertirá en una
caso de éxito para buscar alternativas de mejora en otros procesos de la
entidad y del país.

# EQUIPO DE TRABAJO

• Líder del proyecto: Javier Andres Arias Sanabria – Ing. Sistemas, Magister tecnología, Certificado Big Data, PMP

• Científico de datos: Fredy Gomez – Ing. Sistemas, especialista en Explotación de Datos y Descubrimiento de 
conocimiento, experiencia en herramientas Microsoft, curso en programación estadística con R

• Ingeniero de Datos: William Enciso – Ing. Sistemas, certificado como: Ing. Datos Asociado de Azure, Analista de 
datos de Microsoft, y en Fundamentos de Datos con Azure

• Analistas de datos: 1) Mónica Marquinez – Ing. Industrial con amplio conocimiento del proceso de vigilancia de los 
precios de medicamentos 2) Julián Zabala – Ing. Industrial experto en programación en Phyton

• Artista de datos: Jhefferson Mora – Ing. Sistemas, Especialista en Inteligencia de Negocios, Cursos en Phyton

• Estadístico: 1) Daniela López – Economista con experiencia en medición e interpretación de datos estadísticos y 
metodologías cuantitativas. 2) Julián Zabala – Ing. Industrial experto en programación en Phyton

• Administrador de bases de datos: Diego Angarita – Ing. Sistemas, Magister en Tecnología, Especialista en BI. En 
este rol también se tendrá el apoyo del DBA que presta servicios para la SIC a través de los servicios contratados 
con CARVAJAL.

• Rol Adicional: Product Owner

- Francisco Andres Rodríguez Erazo – Jefe de la Oficina de Tecnología e Informática
- Luis Fernando López – Coordinador Delegatura de Metrología

# CONTENIDO DEL REPOSITORIO

   1. [App](https://github.com/AdminDatos/Guardian/tree/main/App): Contiene los archivos con los cuales se desarrollo el proyecto.
   
      • [CargaDatos](https://github.com/AdminDatos/Guardian/tree/main/App/CargaDatos): Esta funcion es la encargada de ajustar los formatos de cada uno de los campos de acuerdo          a lo definido en el modelo de datos y de realizar el cargue al synapse.
      
      • [Entrenamiento](https://github.com/AdminDatos/Guardian/tree/main/App/Entrenamiento): El entrenamiento de los modelos se realiza en la página de la api de FormRecognizer,          se adjunta un modelo de ejemplo.
      
      • [Extracción](https://github.com/AdminDatos/Guardian/tree/main/App/Extraccion): El proceso de extracción se divide en 2 partes:
         
         • [Extracción Datos](https://github.com/AdminDatos/Guardian/tree/main/App/Extraccion/Extraccion%20Datos): Esta es la función con la cual se consume el servicio de                  FormRecognizer, se extrae la información y se consolida en archivos ".json".
         
         • [Post-Procesamiento](https://github.com/AdminDatos/Guardian/tree/main/App/Extraccion/Post-Procesamiento): Funcion que toma la información del archivo ".json"                     consolidado en la primera parte de la extracción, realiza algunos cálculos y ajustes, y la estructura en un formato parquet para que pueda ser cargada al synapse.
         
      • [Pre-Procesamiento](https://github.com/AdminDatos/Guardian/tree/main/App/Pre-Procesamiento): Esta función realiza el pre-procesamiento de las facturas, transformandolas          de archivo ".pdf" a ".jpg" con las condiciones necesarias para entrenamiento y extracción.
      
      • [Visualizacion de los Datos](https://github.com/AdminDatos/Guardian/tree/main/App/VisualizacionDatos): El proceso de visualizacion de los datos se dividio en 2 partes:
      
         • [Esquema Base de Datos](https://github.com/AdminDatos/Guardian/tree/main/App/VisualizacionDatos/Esquema%20Base%20de%20Datos): Archivos de creación en lenguaje "tsql"             de cada una de los objetos de la bodega de datos (tablas, vistas, procedimientos almacenados y funciones).
         
         • [Modelado Tabular](https://github.com/AdminDatos/Guardian/tree/main/App/VisualizacionDatos/Modelado%20Tabular): Proyecto de Visual Studio que contiene el modelo                  tabular (cubo) y que a su vez consume información de la bodega de datos.

   2. [Datos-Ejemplo](https://github.com/AdminDatos/Guardian/tree/main/Datos-Ejemplo): Contiene archivos de ejemplo para cada uno de los componentes de la App.

      • [CargaDatos](https://github.com/AdminDatos/Guardian/tree/main/Datos-Ejemplo/CargaDatos): Se encuentran los archivos en formato ".parquet" obtenidos del post-                      procesamiento y los cuales son recibidos por la función "Carga de Datos"
      
      • [Entrenamiento](https://github.com/AdminDatos/Guardian/tree/main/Datos-Ejemplo/Entrenamiento): Se encuentran los archivos en formato ".jpg" que deben ser cargados en la          página de la api de FormRecognizer para el entrenamiento de los modelos.
      
      • [Extracción](https://github.com/AdminDatos/Guardian/tree/main/Datos-Ejemplo/Extraccion): 
         
        • En la carpeta [Facturas](https://github.com/AdminDatos/Guardian/tree/main/Datos-Ejemplo/Extraccion/Facturas): se encuentran los archivos en formato ".jpg" que                   corresponden a las facturas listas para ser procesadas

        • En la carpeta [JSON](https://github.com/AdminDatos/Guardian/tree/main/Datos-Ejemplo/Extraccion/JSON) se encuentran los archivos extraídos por el FormRecognizer y que a            su vez son recibidos por la función "post-procesamiento"

        • En la carpeta [Parquet](https://github.com/AdminDatos/Guardian/tree/main/Datos-Ejemplo/Extraccion/Parquet) se encuentran los archivos obtenidos luego del post-                    procesamiento.

      • [Pre-Procesamiento](https://github.com/AdminDatos/Guardian/tree/main/Datos-Ejemplo/Pre-Procesamiento): Archivos en formato ".pdf" que corresponden a las facturas médicas         que van a ser procesadas y que son recibidas por la función "Pre-Procesamiento".
      
      • [Visualizacion de los Datos](https://github.com/AdminDatos/Guardian/tree/main/Datos-Ejemplo/VisualizacionDatos): Archivo en formato ".pbix" el cual contiene el tablero           de control con los indicadores requeridos para el proyecto, y que a su vez consume la información del modelo tabular.
         
   3. [Documentacion](https://github.com/AdminDatos/Guardian/tree/main/Documentacion): Contiene los documentos relacionados con el proyecto.
   
      • En el archivo "Documentacion Data Sandbox - Guardian" se encuentran los detalles técnicos de la app y del proyecto en general.

      • En el archivo "SIC - Proyecto_Piloto_DataSandbox Guardian" se encuentra la información general del proyecto.
      

