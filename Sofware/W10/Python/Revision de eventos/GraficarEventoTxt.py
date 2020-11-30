# -*- coding: utf-8 -*-
"""
Created on Wed Apr 22 21:33:17 2020

@author: milto
"""

from matplotlib.widgets import Cursor
import matplotlib.pyplot as plt
import numpy as np
import time

tramaSize = 2506
banGuardar = 0
banExtraer = 0
contEje = 0
axisValue = 0
contMuestras = 0

axisData = [0 for i in range(4)]
xData = [0 for i in range(4)]
yData = [0 for i in range(4)]
zData = [0 for i in range(4)]

xTrama = []                                                                    #Vector para guardar los datos del eje X
yTrama = []                                                                    #Vector para guardar los datos del eje Y
zTrama = []                                                                    #Vector para guardar los datos del eje Z

#Constantes:
offLong = 0
offTran = 0
offVert = 0

#Ingreso de datos:
#nombreEstacion = input("Ingrese el nombre del directorio: ")
nombreArchivo = input("Ingrese el nombre del archivo: ")
#factorDiezmado = int(input("Ingrese el factor de diezmado: "))
#horaEvento = int(input("Ingrese la hora del evento (hhmmss): "))
#fechaEvento = (input("Ingrese la fecha del evento (mmdd): "))
#duracionEvento = int(input("Ingrese la duracion (horas): "))
factorDiezmado = 1
#duracionEvento = (24 * 3600)

nombreEstacion = "Hora Evento"
#nombreArchivo = "202003260001"
#nombreArchivo = "2020" + fechaEvento + "0001"
#horaEvento = 114845
#duracionEvento = 60

#Abre el archivo de datos y el archivo de informacion:
pathInfo = nombreEstacion + "/" + str(nombreArchivo) + ".INFO"
pathDatos = nombreEstacion + "/" + str(nombreArchivo) + ".txt"

datosInformacion = np.loadtxt(pathInfo,delimiter=",", skiprows=1)
datosAceleracion = np.loadtxt(pathDatos, delimiter = "\t")

print("Dimension array informacion:", datosInformacion.shape)
print("Dimension array datos:", datosAceleracion.shape)

FechaInfo = int(datosInformacion[0]) 
HoraInfo = int(datosInformacion[2])
DuracionInfo = int(datosInformacion[3])

print(FechaInfo)
print(HoraInfo)
print(DuracionInfo)

horaInicioSeg = HoraInfo
horaInicio = str('%0.2d' % (int(horaInicioSeg/3600))) + ":" + str('%0.2d' % (int((horaInicioSeg%3600)/60))) + ":" + str('%0.2d' %((horaInicioSeg%3600)%60))
fechaEvento = str('%0.2d' % (int(FechaInfo/10000))) + "/" + str('%0.2d' % (int((FechaInfo%10000)/100))) + "/" + str('%0.2d' %((FechaInfo%10000)%100))
duracionEvento = DuracionInfo

print(horaInicio)
print(fechaEvento)
       
#Vector de muestras en milisegundos
x_ms = np.linspace(0, duracionEvento*1000, int(250/factorDiezmado)*duracionEvento)
banExtraer = 1

#Vectores de datos de aceleracion:
xTrama = datosAceleracion[:,0]
yTrama = datosAceleracion[:,1]
zTrama = datosAceleracion[:,2]

class Cursor(object):
    def __init__(self, ax):
        self.ax = ax
        #self.lx = ax.axhline(color='red', linewidth=1)  # the horiz line
        #self.ly = ax.axvline(color='red', linewidth=1)  # the vert line

        # text location in axes coords
        self.txt = ax.text(0.7, 0.9, '', transform=ax.transAxes)

    def mouse_move(self, event):
        if not event.inaxes:
            return

        #xtime = (horaInicioSeg)+(event.xdata/1000)      #tiempo en segundos
        xtime = (event.xdata/1000)
        #xtime = (10000*int(xtime/3600)) + (100*int((xtime%3600)/60)) + ((xtime%3600)%60)  #Formato hhmmss
        #xtime = "T = " + str('%0.2d' % (int(xtime/3600))) + ":" + str('%0.2d' % (int((xtime%3600)/60))) + ":" + str('%0.2d' %((xtime%3600)%60))  #Formato hhmmss
        #xtime = "T = " + str(int(xtime)) + " seg"
        xtime = "T = " + str('%1.2f' % (xtime)) + " seg"
        
        x, y = xtime, event.ydata
        # update the line positions
        #self.lx.set_ydata(y)
        #self.ly.set_xdata(x)

        #self.txt.set_text('x=%d, y=%1.2f' % (x, y))
        #self.txt.set_text('x=%0.6d' % (x))
        self.txt.set_text(xtime)
        self.ax.figure.canvas.draw()
 

fig = plt.figure()
ax1 = fig.add_subplot(311)
#ax1=plt.subplot(311)
plt.plot(x_ms, yTrama)
plt.setp(ax1.get_xticklabels(), visible=False)
plt.title('Eje Longitudinal')
plt.ylabel('Aceleracion [cm/seg2]')

ax2=plt.subplot(312, sharex=ax1)
plt.plot(x_ms, xTrama)
plt.setp(ax2.get_xticklabels(), visible=False)
plt.title('Eje Transversal')
plt.ylabel('Aceleracion [cm/seg2]')

ax3=plt.subplot(313, sharex=ax1)
plt.plot(x_ms, zTrama)
plt.title('Eje Vertical')
infoTiempo = "Tiempo [ms]\n" "\n" + "Fecha: " + fechaEvento + "   Tiempo de inicio: " + horaInicio 
plt.xlabel(infoTiempo)
plt.ylabel('Aceleracion [cm/seg2]')

cursor1 = Cursor(ax1)
cursor2 = Cursor(ax2)
cursor3 = Cursor(ax3)

fig.canvas.mpl_connect('motion_notify_event', cursor1.mouse_move)
plt.show()

