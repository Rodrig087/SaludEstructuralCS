
import subprocess
#from subprocess import call


#call(["sudo", "./leeraceleracion", "args", "5", "2148", "100"])

# reloj = 2
# fuenteReloj = str(reloj)
# call(["sudo", "./sincronizartiemposistema", "args", fuenteReloj])


sectorInicial = "1289461"

idConcentrador = 3
idNodo = 1
horaEvento = 54000
fechaEvento = 200818 
duracionEvento = 10

idConcentradorStr = str(idConcentrador)
idNodoStr = str(idNodo)
horaEventoStr = str(horaEvento)
fechaEventoStr = str(fechaEvento)
duracionEventoStr = str(duracionEvento)

subprocess.call(["sudo", "/home/pi/Ejecutables/leeraceleracion", idConcentradorStr, idNodoStr, horaEventoStr, fechaEventoStr, duracionEventoStr, sectorInicial])


#subprocess.call(["sudo", "./inspeccionarsector", "1", "1289461"])


