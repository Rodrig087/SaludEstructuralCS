# -*- coding: utf-8 -*-
# Importante: abrir como administrador el IDLE de python para poder ejecutar
# Así mismo con cualquier editor que se desee ejecutar (Spyder - Anaconda)

# Programa para leer los datos directamente de los sectores de la SD
# Del programa de digitalizador

import sys, os
import time
import math

# Nombre del disco fisico externo, de la tarjeta SD
#VOLUME_PATH = r"\\.\E:"
VOLUME_PATH = r"\\.\PhysicalDrive1"
# Sector inicial en el que se han guardado datos
#sectorInicial = 100
# Numero de bytes por sector
numBytesSector = 512
# Coloca en un vector los datos constantes de la cabecera para poder comprobar
vectorCtesCabecera = [255, 253, 251]
# Primero van los datos de la cabecera
# | Cte1 | Cte2 | Ct3 | #Bytes/Muestra | MSB_fSample | LSB_fSample |
numDatosCabecera = 6
# Luego, los datos del tiempo
# | Año | Mes | Dia | Horas | Minutos | Segundos |
numDatosTiempo = 6

# Al inicio no se tiene un nombre de archivo, con la primera lectura del tiempo
# se cambia el nombre del archivo en el que se van a guardar los datos
nombreArchivo = "YYMMDDhhmmss.txt"
#isNombreArchivo = False

# Crea un diccionario para los datos de la cabecera, por ahora se coloca todo en 0
# El numTotalDatos y el numSectores se calculan
dicCabecera = {"numBytesPorMuestra": 0, "fSample": 0, "numTotalDatos": 0, "numSectores": 0}
# Asi mismo un diccionario para el tiempo. En dia se coloca un numero que no es
# posible porque interesa que la primera vez sea diferente
dicTiempo = {"anio": 0, "mes": 0, "dia": 100, "horas": 0, "minutos": 0, "segundos": 0}

vectorAceleracion = [0 for i in range(9)]


# Metodo para leer los 512 datos de un sector en particular
def leerTodosDatosSector (disk_fd, sector):
    # Se apunta a la direccion del sector
    disk_fd.seek(sector*numBytesSector)
    # Se leen todos los bytes del sector
    totalDataSector = disk_fd.read(numBytesSector)
    # Se almacenan estos datos en un vector
    vectorDatos = []
    for dato in totalDataSector:
        vectorDatos.append(dato)       
    return vectorDatos


# Obtiene los valores de la cabecera que son 
# | #Bytes/Muestra | MSB_fSample | LSB_fSample |
# Tienen que estar en este orden, caso contrario algo anda mal. Despues de 
# estos valores va el tiempo
# | Año | Mes | Dia | Horas | Minutos | Segundos |
def obtenerValoresCabecera(vectorDatos):
    #global isNombreArchivo
    global nombreArchivo
    
    # Comienza despues de las cabeceras, porque estas ya se analizaron
    indiceInicial = len(vectorCtesCabecera)
    # Numero de bytes por muestra, para el digitalizador son 7, uno de 
    # ganancia y 6 de valores de los 3 canales
    dicCabecera["numBytesPorMuestra"] = vectorDatos[indiceInicial]
    # Se obtiene la frecuencia de muestreo, que corresponde a los dos siguientes
    # bytes, primero el MSB y luego el LSB. Para el digitalizador es 100 asi
    # que el MSB = 0 y LSB = 100
    dicCabecera["fSample"] = vectorDatos[indiceInicial + 1] << 8 | vectorDatos[indiceInicial + 2]
    
    # Con estos dos valores se obtiene el numero total de datos en este segundo
    dicCabecera["numTotalDatos"] = dicCabecera["numBytesPorMuestra"]*dicCabecera["fSample"]
    # Asi mismo se obtiene el numero de sectores con los datos, redondeado al
    # entero superior
    dicCabecera["numSectores"] = math.ceil(dicCabecera["numTotalDatos"]/numBytesSector)
    
#    print (dicCabecera)

    # Siempre guarda los dias en una variable ant para comparar con los nuevos
    # dias, en caso de que sea diferente hay que crear un nuevo archivo
    diasAnt = dicTiempo["dia"]
    
    # Se obtiene el indice desde donde comienzan los datos de tiempo
    indiceInitTiempo = numDatosCabecera

    # Ahora se obtienen los valores de tiempo y se guardan en el diccionario
    dicTiempo["anio"] = vectorDatos[indiceInitTiempo]
    dicTiempo["mes"] = vectorDatos[indiceInitTiempo + 1]
    dicTiempo["dia"] = vectorDatos[indiceInitTiempo + 2]
    dicTiempo["horas"] = vectorDatos[indiceInitTiempo + 3]
    dicTiempo["minutos"] = vectorDatos[indiceInitTiempo + 4]
    dicTiempo["segundos"] = vectorDatos[indiceInitTiempo + 5]
    
    print (dicTiempo)
    
    # Compara si hay cambio de dia para cambiar el nombre y luego crear un nuevo 
    # archivo de texto
    
#    if diasAnt != dicTiempo["dia"]:
    if diasAnt != dicTiempo["dia"]:
        
        diasAnt = dicTiempo["dia"]
        print ('Cambia dia')
        time.sleep(1)
        # Guarda el nombre del archivo, todos los valores de tiempo con 2 digitos
        nombreArchivo = "%02d%02d%02d%02d%02d%02d.txt" % (dicTiempo["anio"], dicTiempo["mes"], dicTiempo["dia"], dicTiempo["horas"], dicTiempo["minutos"], dicTiempo["segundos"])        
        
        # Tambien muestra la frecuencia de muestreo
        print ('Frecuencia de muestreo: ', str(dicCabecera["fSample"]))
               
    # Finalmente devuelve el indice en el que comienzan los datos
    indiceInicial = numDatosCabecera + numDatosTiempo
    return indiceInicial


# Metodo para leer los datos validos de un sector y guardarlos en el archivo 
# de texto. Se reciben los indices, el vector de datos y el tiempo en segundos 
def leerGuardarGrupoDatos (indiceInicial, indiceFinal, vectorDatos, tiempoSeg):
    global fileTxt, numDatosPorLeer, contadorBytesPorMuestra, indiceAceleracion
    axisValue = 0
    aceleracion = 0
        
    # Recorre todos los datos de el sector enviado en vectorDatos desde el 
    # indiceInicial hasta el final
    for indiceDatos in range(indiceInicial, indiceFinal):
        
        # Si estamos al inicio se guarda el tiempo y el dato, ademas aumentar el contador
        #**Guarda el tiempo y el indicador de numero de muestra: 
        if contadorBytesPorMuestra == 1:
            fileTxt.write("%d\t%d\t\t" %(tiempoSeg, vectorDatos[indiceDatos]))
            contadorBytesPorMuestra = contadorBytesPorMuestra + 1
                
        # Si es el ultimo dato de los bytesPorMuestra, hay que guardar el dato, 
        # reiniciar el contador a 1 y agregar un salto de linea
        elif  contadorBytesPorMuestra == dicCabecera["numBytesPorMuestra"]:        
            #fileTxt.write("%d\t\r" %(vectorDatos[indiceDatos]))
            #fileTxt.write("%d\t\r" %(indiceAceleracion))
            vectorAceleracion[indiceAceleracion] = vectorDatos[indiceDatos]
            for x in range(3):
                axisValue = ((vectorAceleracion[0+(x*3)]<<12)&0xFF000)+((vectorAceleracion[1+(x*3)]<<4)&0xFF0)+((vectorAceleracion[2+(x*3)]>>4)&0xF)
                #Aplica el complemento a 2:
                if axisValue >= 0x80000:
                    axisValue = axisValue & 0x7FFFF		                   
                    axisValue = -1*(((~axisValue)+1)& 0x7FFFF)
                aceleracion = axisValue * (9.8/pow(2,18))
                if x == 2:
                    fileTxt.write("%2.8f\t\r" %(aceleracion))
                else:
                    fileTxt.write("%2.8f\t" %(aceleracion))           
            indiceAceleracion = 0
            contadorBytesPorMuestra = 1
            
        
        # Caso contrario se van guardando los datos y se aumenta el contador
        #**Almacena los datos de aceleracion en un vector:
        else:   
            #fileTxt.write("%d\t" %(vectorDatos[indiceDatos]))
            #fileTxt.write("%d\t" %(indiceAceleracion))
            vectorAceleracion[indiceAceleracion] = vectorDatos[indiceDatos]            
            indiceAceleracion = indiceAceleracion + 1           
            contadorBytesPorMuestra = contadorBytesPorMuestra + 1
            
        # Actualiza los datos por leer, resta 1
        numDatosPorLeer = numDatosPorLeer - 1
        
#Metodo para convertir los datos de aceleracion del vector de datos a gales

                  
                
# Metodo para leer los datos de los sectores y guardar la informacion
def programaPrincipal ():
    #global isNombreArchivo
    global nombreArchivo, fileTxt, numDatosPorLeer, contadorBytesPorMuestra, indiceAceleracion
    # Intenta abrir la tarjeta SD
    try:
        # Se abre la tarjeta SD para lectura
        disk_fd = open(VOLUME_PATH, 'rb')
        print('Tarjeta SD abierta correctamente')
    except:
        # Si no se puede abrir la SD, muestra un mensaje y sale del programa
        sys.exit('Error al abrir tarjeta SD')
    
    # Si se ha leido correctamente, comienza la lectura de datos desde el 
    # sector inicial
    isData = True
    
    #Puedo utilizar este dato para indicar donde quiero iniciar
    sector = sectorInicial
    
    while isData:
        # Llama al metodo para leer los datos del sector, se recibe un vector
        vectorDatos = leerTodosDatosSector(disk_fd, sector)
            
        # Analiza los tres primeros datos de la cabecera, si estos estan bien 
        # significa que hay que continuar con la lectura
        if vectorDatos[0:len(vectorCtesCabecera)] == vectorCtesCabecera:
            print ('Data Sector ', sector, ' Ok')
            # Llama al metodo para obtener los valores de la cabecera y del 
            # tiempo, estos datos se guardan en los respectivos diccionarios,
            # adicionalmente devuelve el indice inicial para leer los datos
            indiceInicial = obtenerValoresCabecera(vectorDatos)
            # Abre el archivo de texto en modo append para no borrar los datos
            # anteriores
            fileTxt = open(nombreArchivo, "a+")
            # Pasa el tiempo de horas y minutos a segundos
            tiempoSeg = dicTiempo["horas"]*3600 + dicTiempo["minutos"]*60 + dicTiempo["segundos"]
            # Actualiza el valor de datos a leer durante este segundo
            numDatosPorLeer = dicCabecera["numTotalDatos"]
            # Actualiza la variable contadorBytesPorMuestra, como es el
            # primer sector, siempre comienza con 1. Se utiliza en el metodo
            contadorBytesPorMuestra = 1
            
            indiceAceleracion = 0
            
            # Llama al metodo para recorrer los datos desde un cierto indice 
            # inicial hasta un final y hacer las transformaciones para guardar
            # en el archivo de texto. Esto corresponde al primer sector del 
            # grupo del segundo que se esta analizando
            leerGuardarGrupoDatos(indiceInicial, numBytesSector, vectorDatos, tiempoSeg)
#            print ("Datos restantes ", numDatosPorLeer)
            
            # Una vez que recorre el primer sector con datos, recorre los siguientes
            # Coloca desde 1 xq el primer sector ya se leyo
            for indiceSector in range(1, dicCabecera["numSectores"]):
                sectorNuevo = sector + indiceSector
                # llama al metodo para leer los datos del sector
                vectorDatos = leerTodosDatosSector(disk_fd, sectorNuevo)
                # Dependiendo cuantos datos falten por leer, los recorre en el 
                # sector. Si faltan mas datos que los 512 que tiene un sector, 
                # lee todos, caso contrario lee solo los que faltan
                if numDatosPorLeer > numBytesSector:
                    indiceFinal = numBytesSector
                else:
                    indiceFinal = numDatosPorLeer

                # Llama al metodo para recorrer los datos desde un cierto indice 
                # inicial hasta un final y hacer las transformaciones para guardar
                # en el archivo de texto. Esto corresponde al resto de sectores 
                # del grupo del segundo que se esta analizando
                leerGuardarGrupoDatos(0, indiceFinal, vectorDatos, tiempoSeg)
#                print ("Datos restantes ", numDatosPorLeer)
              
            # Cierra el archivo de texto    
            fileTxt.close()
            # Aumenta el sector de acuerdo al numero de sectores con datos
            sector = sector + dicCabecera["numSectores"]
            
            if sector == sectorFinal:
                print ('Fin lectura de datos')
                isData = False
            
        else:
            print ('Fin lectura de datos')
            isData = False
        
        #time.sleep(0.01)
    
    # Al final cierra la tarjeta SD
    os.close(disk_fd.fileno())
    del disk_fd


# Metodo que se ejecuta al iniciar el programa  
if __name__ == "__main__":
    print('Inicio Programa Lectura Sectores SD')
    
    sectorInicial = int(input("Ingrese el sector inicial: "))
    sectorFinal = int(input("Ingrese el sector final: "))
    
    # Llama al metodo para leer los datos de los sectores y guardar la informacion
    programaPrincipal()
