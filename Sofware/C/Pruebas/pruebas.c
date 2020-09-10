//Compilar: 
//gcc pruebas.c -o pruebas -lbcm2835 -lwiringPi 

#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>
#include <bcm2835.h>
#include <time.h>
#include <string.h>
#include <unistd.h>


//Declaracion de constantes
#define P1 0																	//Pin 11 GPIO
#define MCLR 28																	//Pin 38 GPIO
#define TEST 29 																//Pin 40 GPIO																						
#define TIEMPO_SPI 10
#define FreqSPI 2000000

#define IDConcentrador 1

unsigned int contador;




int main(int argc, char *argv[]) {
	
	contador = 0;

	FILE *fp;
	
	//unsigned short idConcentrador;
	unsigned short idNodo;
	unsigned short duracionEvento;
	
	char tiempoNodo[6];
	
	char nombreArchivo[50];
	char idArchivo[8];
	char tiempoNodoStr[13];
	char duracionEventoStr[4];
	char ext[5];
		
	//Extrae el tiempo de la trama pyload:	
	tiempoNodo[0] = 20;                                    //aa
	tiempoNodo[1] = 7;                                    //mm
	tiempoNodo[2] = 30;                                    //dd
	tiempoNodo[3] = 18;                                    //hh
	tiempoNodo[4] = 9;                                    //mm
	tiempoNodo[5] = 3;                                    //ss
	
	//idConcentrador = 1;
	idNodo = 4;
	duracionEvento = 60;
	
	strcpy(nombreArchivo, "/home/pi/Resultados/");
	sprintf(idArchivo, "C%0.2dN%0.2d_", IDConcentrador, idNodo); 
	sprintf(tiempoNodoStr, "%0.2d%0.2d%0.2d%0.2d%0.2d%0.2d_", tiempoNodo[0], tiempoNodo[1], tiempoNodo[2], tiempoNodo[3], tiempoNodo[4], tiempoNodo[5]);
	sprintf(duracionEventoStr, "%0.3d", duracionEvento); 
	strcpy(ext, ".dat");
	
	strcat(nombreArchivo, idArchivo);
	strcat(nombreArchivo, tiempoNodoStr);
	strcat(nombreArchivo, duracionEventoStr);
	strcat(nombreArchivo, ext);
	
	printf("%s\n", nombreArchivo); 
	
	//Abre o crea el archivo binario
	fp = fopen (nombreArchivo, "ab+");	
	printf("Archivo abierto\n");
	fclose (fp);
	

}


///home/pi/Resultados/C01N04_200730180903_060.dat
