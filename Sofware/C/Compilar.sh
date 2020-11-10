#!/bin/bash

echo "Iniciando compilacion"

gcc /home/pi/Programas/CalcularSector_V01.c -o /home/pi/Ejecutables/calcularsector -lbcm2835 -lwiringPi
gcc /home/pi/Programas/InformacionSectores.c -o /home/pi/Ejecutables/informacionsectores -lbcm2835 -lwiringPi 
gcc /home/pi/Programas/InspeccionarSector_V2.c -o /home/pi/Ejecutables/inspeccionarsector -lbcm2835 -lwiringPi
gcc /home/pi/Programas/LeerAceleracion_V30.c -o /home/pi/Ejecutables/leeraceleracion -lbcm2835 -lwiringPi 
gcc /home/pi/Programas/LeerTiempoNodo_V2.c -o /home/pi/Ejecutables/leertiemponodo -lbcm2835 -lwiringPi 
gcc /home/pi/Programas/Muestrear.c -o /home/pi/Ejecutables/muestrear -lbcm2835 -lwiringPi
gcc /home/pi/Programas/ResetMaster.c -o /home/pi/Ejecutables/resetmaster -lbcm2835 -lwiringPi
gcc /home/pi/Programas/SincronizarTiempoSistema.c -o /home/pi/Ejecutables/sincronizartiemposistema -lbcm2835 -lwiringPi
gcc /home/pi/Programas/TestSectores.c -o /home/pi/Ejecutables/testsectores -lbcm2835 -lwiringPi 

echo "Compilacion completa"

exit 0