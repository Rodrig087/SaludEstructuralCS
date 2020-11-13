//Compilar:
//gcc Tester.c -o /home/pi/Ejecutables/tester -lbcm2835 -lwiringPi 
//gcc Tester.c -o tester -lbcm2835 -lwiringPi 

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

	while(1){	
		
		    printf("Prueba numero: %d\n", contador); 
			//system("sudo ./inspeccionarevento 1 1768190");
			system("sudo ./leeraceleracion 1 201111 79200  5");
			delay (1000);
			system("sudo ./leeraceleracion 2 201111 79200  5");
			
			
			contador++;
			printf("\n");
			delay (1000);
	
	}

}

