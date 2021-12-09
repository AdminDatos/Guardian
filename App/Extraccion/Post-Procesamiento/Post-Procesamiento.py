#!/usr/bin/env python
# coding: utf-8

# In[ ]:


#FUNCION QUE TOMA LA INFORMACION DEL JSON Y LA ESTRUCTURA EN UN FORMATO PARQUET PARA CARGARLA AL SYNAPSE

def lectura(JSON,factura,pag):
    listaFactura=[]
 
    with open(JSON) as file:

        data = json.load(file)

        print(data["analyzeResult"]["documentResults"][0]["fields"])
        if str(data["analyzeResult"]["documentResults"][0]["fields"]["RazonSocialCliente"])!="None":
            RazonSocialCliente=data["analyzeResult"]["documentResults"][0]["fields"]["RazonSocialCliente"]["text"]
            print(RazonSocialCliente)
        else:
            RazonSocialCliente=data["analyzeResult"]["documentResults"][0]["fields"]["RazonSocialCliente"]
            print("RazonSocialCliente None")
        if str(data["analyzeResult"]["documentResults"][0]["fields"]["RazonSocialEntidad"])!="None":
            RazonSocialEntidad=data["analyzeResult"]["documentResults"][0]["fields"]["RazonSocialEntidad"]["text"]
            print(RazonSocialEntidad)
        else:
            RazonSocialEntidad=data["analyzeResult"]["documentResults"][0]["fields"]["RazonSocialEntidad"]
            print("RazonSocialEntidad None")
        if str(data["analyzeResult"]["documentResults"][0]["fields"]["NitCliente"]["text"])!="None": 
            NitCliente=data["analyzeResult"]["documentResults"][0]["fields"]["NitCliente"]["text"]
            print(NitCliente)
        else:
            NitCliente=data["analyzeResult"]["documentResults"][0]["fields"]["NitCliente"]
            print("NitCliente None")
        if str(data["analyzeResult"]["documentResults"][0]["fields"]["NitEntidad"]["text"])!="None":
            NitEntidad=data["analyzeResult"]["documentResults"][0]["fields"]["NitEntidad"]["text"]
            print(NitEntidad)
        else:
            NitEntidad=data["analyzeResult"]["documentResults"][0]["fields"]["NitEntidad"]
            print("NitEntidad None")
        if str(data["analyzeResult"]["documentResults"][0]["fields"]["No.Factura"]["text"])!="None":  
            No_Factura=data["analyzeResult"]["documentResults"][0]["fields"]["No.Factura"]["text"]
            print(No_Factura)
        else:
            No_Factura=data["analyzeResult"]["documentResults"][0]["fields"]["No.Factura"]
            print("No_Factura None")

        if str(data["analyzeResult"]["documentResults"][0]["fields"]["FechaFactura"]["text"])!="None":  
            Fecha_Factura=data["analyzeResult"]["documentResults"][0]["fields"]["FechaFactura"]["text"]
            print(No_Factura)
        else:
            Fecha_Factura=data["analyzeResult"]["documentResults"][0]["fields"]["FechaFactura"]
            print("No_Factura None")

        print("LineasFacturas")
        for linea in data["analyzeResult"]["documentResults"][0]["fields"]["LineasFacturas"]["valueArray"]:
            caso=0
            VnoneL=0
            VnoneM=0
            precioUAj=111
            print("linea",linea["valueObject"]["CUM"],linea["valueObject"]["Nombre"],linea["valueObject"]["Cantidad"],linea["valueObject"]["PrecioUnidad"],linea["valueObject"]["PrecioTotal"])
            if str(linea["valueObject"]["CUM"])!="None":
                CUM=str(linea["valueObject"]["CUM"]["text"])
                CumAjustado = re.sub("\s","",CUM)
                CUM=CumAjustado
                print(CUM)
            else:
                print("CUM NONE")
            if str(linea["valueObject"]["Nombre"])!="None":
                Nombre=str(linea["valueObject"]["Nombre"]["text"])
            else:
                print("Nombre NONE")
            if str(linea["valueObject"]["Cantidad"])!="None": 
                Cantidad=str(linea["valueObject"]["Cantidad"]["text"])
                CantAj=re.sub("\D","",Cantidad)  
                print("Cantidad",CantAJ)

            else:
                caso=1
                Vnone=VnoneL+1
                print("Cantidad NONE")
            if str(linea["valueObject"]["PrecioUnidad"])!="None":
                PrecioUnidad=str(linea["valueObject"]["PrecioUnidad"]["text"])
                PrecioUAj=re.sub("\D","",PrecioUnidad)
                print("Precio Unitario",PrecioUAJ)
            else:
                caso=2
                VnoneL=VnoneL+1
                print("PrecioUnidad None")
            if str(linea["valueObject"]["PrecioTotal"])!="None": 
                PrecioTotal=str(linea["valueObject"]["PrecioTotal"]["text"])
                PrecioTAj=re.sub("\D","",PrecioTotal)
                print("PrecioTotal",PrecioTAJ)
            else:
                caso=3
                VnoneL=VnoneL+1
                print("PrecioTotal None")
            if VnoneL<=1:
                if caso==1:
                    Cantidad=float(PrecioTotal/PrecioUnidad)
                elif caso==2:
                    print(Cantidad)
                    PrecioUnidad=float(PrecioTotal/Cantidad)
                elif caso==3:
                    PrecioTotal=float(PrecioUnidad*Cantidad)
                    Descuento=float(PrecioUnidad-(PrecioTotal/Cantidad))
            if CUM!="None":          
                LineasFactura={'NitCliente':NitCliente,'NitEntidad':NitEntidad,'RazonSocialEntidad':RazonSocialEntidad,'RazonSocialCliente':RazonSocialCliente,'NFactura'No_Factura,'FechaFact':FechaFactura'CUM':CUM,'Nombre':Nombre,'Cantidad':CantAj,'PrecioUnidad':PrecioUAj,'Descuento':Descuento,'PrecioTotal':PrecioTAj}
                listaFactura.append(LineasFactura)


      
    dfDATA=pd.DataFrame(listaFactura)
    os.chdir("/databricks/driver")
    dfDATA.to_excel('/databricks/driver/DATA.xlsx')
    Carpet_DATA="/"+"/FACTURA "+str(factura)+"PAG "+str(pag)+"ParquetDATA.xlsx"
    shutil.copy("/databricks/driver/DATA.xlsx", Carpet_DATA)

