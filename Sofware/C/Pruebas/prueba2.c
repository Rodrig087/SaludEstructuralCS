//Compilar: 
//gcc prueba2.c -o prueba -lbcm2835 -lwiringPi 

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

unsigned int contador;




int main() {
	
	
	int sectorReq, horaReq, fechaReq;
	struct tm dateSec;
	struct tm dateReq;
	char buffFechaSector[5];
	char buffReqUNIX[15];
	char buffSecUNIX[15];
	unsigned char tiempoSector[8];
	
	char tiempoReqStr[20];
	char tiempoSecStr[20];
	
	char formatted_date_req[40];
	char formatted_date_sec[40];
	
	long deltaTiempo;
	long deltaSector;
	
	//horaReq = 43932;	   //12:12:12
	horaReq = 8211;	   //02:16:51
	fechaReq = 200801;	   //20/08/01
	//sectorReq = 10003;
	sectorReq = 188608;
	
	/*
	tiempoSector[0] = 20;
	tiempoSector[1] = 8;
	tiempoSector[2] = 1;
	tiempoSector[3] = 2;
	tiempoSector[4] = 16;
	tiempoSector[5] = 51;
	*/
	
	tiempoSector[0] = 20;
	tiempoSector[1] = 8;
	tiempoSector[2] = 1;
	tiempoSector[3] = 12;
	tiempoSector[4] = 12;
	tiempoSector[5] = 12;
	
	sprintf(tiempoReqStr, "%d/%d/%d %d:%d:%d", (fechaReq/10000), ((fechaReq%10000)/100), ((fechaReq%10000)%100), (horaReq/3600), ((horaReq%3600)/60), ((horaReq%3600)%60));	
	sprintf(tiempoSecStr, "%d/%d/%d %d:%d:%d", tiempoSector[0], tiempoSector[1], tiempoSector[2], tiempoSector[3], tiempoSector[4], tiempoSector[5]);
    	
	//strptime("20/8/18 23:31:01", "%y/%m/%d %H:%M:%S", &dateSector);
	strptime(tiempoReqStr, "%y/%m/%d %H:%M:%S", &dateReq);
	strptime(tiempoSecStr, "%y/%m/%d %H:%M:%S", &dateSec);
		
    //strftime(buffFechaSector, sizeof(buffFechaSector), "%j", &dateSector);
	strftime(buffReqUNIX, sizeof(buffReqUNIX), "%s", &dateReq);
	strftime(buffSecUNIX, sizeof(buffSecUNIX), "%s", &dateSec);
		
	strftime(formatted_date_req, 40, "%d %b %Y %H:%M:%S", &dateReq );
	strftime(formatted_date_sec, 40, "%d %b %Y %H:%M:%S", &dateSec );
	
	puts(formatted_date_req);
	puts(formatted_date_sec);
	//puts(buffFechaSector);
	puts(buffReqUNIX);
	puts(buffSecUNIX);
	
	printf("Sector inicial: %d\n" , sectorReq);
	
	deltaTiempo = atoi(buffReqUNIX) - atoi(buffSecUNIX);
	deltaSector = deltaTiempo * 5;
	sectorReq = sectorReq + deltaSector;
	
	printf("Delta tiempo: %d\n" , deltaTiempo);
	printf("Delta sector: %d\n" , deltaSector);
	printf("Sector aceleracion: %d\n" , sectorReq);
	
	//printf("Dia anio: %d\n", atoi(buffFechaSector)+1);
	//printf("Tiempo UNIX: %d\n", atoi(buffTiempoUNIX)+1);
}