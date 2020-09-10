//Compilar:
//gcc Tester.c -o /home/pi/Ejecutables/tester -lbcm2835 -lwiringPi 
//gcc TestNodo.c -o testnodo -lbcm2835 -lwiringPi 

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

unsigned int contador;


int main(int argc, char *argv[]) {
	
	contador = 0;

	printf("\nActualizando tiempo del sistema...\n"); 
	system("sudo ./sincronizartiemposistema 1");
	delay (1000);
	printf("\nComprobando tiempo del nodo...\n"); 
	system("sudo ./leertiemponodo 1");
	delay (1000);
	printf("\nIniciando muestreo...\n"); 
	system("sudo ./muestrear 1 1 1");
	delay (5000);
	printf("\nRecuperando informacion de sectores..\n"); 
	system("sudo ./informacionsectores 1");
	delay (1000);
	//printf("\nInspeccionando sector..\n"); 
	//system("sudo ./inspeccionarsector 1 2170");
	
}

