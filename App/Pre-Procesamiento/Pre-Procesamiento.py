
Directorio=r'"direcorio"' #DIRECTORIO LOCAL CON LAS FACTURAS EN PDF
Directorio_Output=r'"direcorio"' #DIRECTORIO LOCAL EN EL QUE SE GUARDARÁN LOS ARCHIVOS PROCESADOS 
os.chdir(Directorio) #Cambio de escritorio
facturas=os.listdir(Directorio) #listado de facturas

text='(.*).pdf'
name_re=re.compile(text)

NumeroF=0

for n in (facturas):
    os.chdir(Directorio) #Cambio de escritorio
    print(n)
    print("factura NO: ",NumeroF,"  ",n)
    NumeroF=NumeroF+1
    dpi=75 #Se ajusta con respecto al objetivo con el que se quieren transformar los archivos (Entrenamiento o Extraccion) 
    pages = convert_from_path(n,75,fmt='jpg',poppler_path=r'C:\Program Files (x86)\poppler-0.68.0\bin',grayscale='true')  #POPPLER_PATH Ruta en la cual se instaló el programa Poppler
    
    name=name_re.search(n)
    if name:
        nombre=name.group(1)
        print(nombre)
    conta=1
    DirectorioF=Directorio_Output +'\ '+ nombre
    print(DirectorioF)
    os.chdir(Directorio_Output)
    os.mkdir(DirectorioF)
    os.chdir(DirectorioF)
    for page in pages:
        jpg=nombre+' page '+str(conta)+'.jpg'
        conta=conta+1
        print(jpg)
        page.save(jpg,"JPEG")

