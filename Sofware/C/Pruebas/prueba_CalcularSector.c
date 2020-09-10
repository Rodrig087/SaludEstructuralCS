//Compilar: 
//gcc prueba_CalcularSector.c -o prueba -lbcm2835 -lwiringPi 

#define _XOPEN_SOURCE

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

//Vatiables nuevas:
unsigned char tiempoSector[6];
struct tm dateReq;
struct tm dateSec;
char tiempoReqStr[20];
char tiempoSecStr[20];
char buffReqUNIX[15];
char buffSecUNIX[15];
long deltaTiempo;
long deltaSector;

//Variables de prueba:
char formatted_date[40];

//Variables existentes:
int sectorReq, horaReq, fechaReq;

//Declaracion de funciones
void CalcularSector();

int main() {
	
	//Datos requeridos:
	horaReq = 43932;	   //12:12:12
	fechaReq = 200801;	   //20/08/01
	
	//Resultado de la funcion InspeccionarSector:
	sectorReq = 10003;      		
	tiempoSector[0] = 20;
	tiempoSector[1] = 8;
	tiempoSector[2] = 1;
	tiempoSector[3] = 2;
	tiempoSector[4] = 16;
	tiempoSector[5] = 51;
	sprintf(tiempoSecStr, "%d/%d/%d %d:%d:%d", tiempoSector[0], tiempoSector[1], tiempoSector[2], tiempoSector[3], tiempoSector[4], tiempoSector[5]);
	printf(tiempoSecStr);
	printf("\n");	
	CalcularSector();
}

void CalcularSector(){
	
	sprintf(tiempoReqStr, "%d/%d/%d %d:%d:%d", (fechaReq/10000), ((fechaReq%10000)/100), ((fechaReq%10000)%100), (horaReq/3600), ((horaReq%3600)/60), ((horaReq%3600)%60));
	printf(tiempoReqStr);
	printf("\n");
	
	strptime(tiempoReqStr, "%y/%m/%d %H:%M:%S", &dateReq);
	strptime(tiempoSecStr, "%y/%m/%d %H:%M:%S", &dateSec);
	
	strftime(buffReqUNIX, sizeof(buffReqUNIX), "%s", &dateReq);
	strftime(buffSecUNIX, sizeof(buffSecUNIX), "%s", &dateSec);
	
	deltaTiempo = atoi(buffReqUNIX) - atoi(buffSecUNIX);
	deltaSector = deltaTiempo * 5;
	sectorReq = sectorReq + deltaSector;
	
	printf("Delta tiempo: %d\n" , deltaTiempo);
	printf("Delta sector: %d\n" , deltaSector);
	printf("Sector aceleracion: %d\n" , sectorReq);
	
}