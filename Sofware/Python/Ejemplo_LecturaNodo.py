

import subprocess

#Datos necesarios para utilizar el metodo de lectura de datos de aceleracion
idCon = 6           #Id del concentrador
idNod = 2           #Id del nodo requerido (Para leer varios nodos es necesario hacer un barrido)
horaEvt = 21600     #Hora del evento en segundos
fechaEvt = 200820   #Fecha del evento en AAMMDD
duracionEvt = 10    #Duracion del evento en segundos


#Funcion para leer los datos de aceleracion de los nodos:
def LeerAceleracion (idConcentrador, idNodo, horaEvento, fechaEvento, duracionEvento):
    
    #En esta version preliminar es necesario definir un sector para que empiece a realizar el calculo,
    #en la version final el programa empieza recuperando el sector de inicio de datos del dia
    sectorInicial = "2148"
        
    idConcentradorStr = str(idConcentrador)
    idNodoStr = str(idNodo)
    horaEventoStr = str(horaEvento)
    fechaEventoStr = str(fechaEvento)
    duracionEventoStr = str(duracionEvento)

    subprocess.call(["sudo", "/home/pi/Ejecutables/leeraceleracion", idConcentradorStr, idNodoStr, horaEventoStr, fechaEventoStr, duracionEventoStr, sectorInicial])


#Funcion para sincronizar el sistema (Fuentes de reloj: 0>Hora de red, 1>GPS, 2>RTC)
#Para las pruebas te recomiendo utilizar la hora de red
def sincronizarSistema (fuenteReloj): 
    fuenteRelojStr = str(fuenteReloj)
    subprocess.call(["sudo", "/home/pi/Ejecutables/sincronizartiemposistema", fuenteRelojStr)

#Funciones para iniciar y detener el muestreo (direccion = 255 -> todos los nodos)
def IniciarMuestreo(dirNodo):
    dirNodoStr = str(dirNodo)
    subprocess.call(["sudo", "/home/pi/Ejecutables/muestrear", dirNodoStr, "1", "1")
    #Ojo: El tercer parametro de la funcion indica si se sobrescribe o no la SD. 
    #Para las pruebas por ahora es mejor que se sobrescriba hasta solucionar el problema de ubicar el primer sector de lectura

def DetenerMuestreo(dirNodo):
    dirNodoStr = str(dirNodo)
    subprocess.call(["sudo", "/home/pi/Ejecutables/muestrear", dirNodoStr, "0", "0")

#Inicio
if __name__ == "__main__":
    print('Inicio Programa Lectura Datos de Aceleracion de los Nodos')
    #Forma de utilizar el metodo:
    LeerAceleracion(idCon, idNod, horaEvt, fechaEvt, duracionEvt)
    
    
##IMPORTANTE##
#Para que los programas funcionen correctamente es muy importante que los archivos compilados de C esten en la siguiente ruta:
#/home/pi/Ejecutables/
#Para asegurar de que asi sea utiliza estas instrucciones para compilar los programas en C:
#gcc LeerAceleracion_V2.c -o /home/pi/Ejecutables/leeraceleracion -lbcm2835 -lwiringPi
#gcc SincronizarTiempoSistema.c -o /home/pi/Ejecutables/sincronizartiemposistema -lbcm2835 -lwiringPi
#gcc Muestrear.c -o /home/pi/Ejecutables/muestrear -lbcm2835 -lwiringPi 