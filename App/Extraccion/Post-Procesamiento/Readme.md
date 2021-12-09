# POST-PROCESAMIENTO

Funcion que toma la información del archivo ".json" consolidado en la primera parte de la extracción, realiza algunos cálculos y ajustes, y la estructura en un formato parquet para que pueda ser cargada al synapse

# Parametros

JSON se refiere al archivo ".json" con la información extraida por el FormRecognizer

factura se refiere al número de la factura que está siendo procesada
pag se refiere al número de la página de la "factura" que está siendo procesada
