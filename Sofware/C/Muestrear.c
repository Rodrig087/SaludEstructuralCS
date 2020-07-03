//Compilar:
//gcc Muestrear.c -o /home/pi/Ejecutables/muestrear -lbcm2835 -lwiringPi 
//gcc Muestrear.c -o muestrear -lbcm2835 -lwiringPi 

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


//Declaracion de variables
unsigned short i;
unsigned int x;
unsigned short buffer;
unsigned char tiempoPIC[8];
unsigned char tiempoLocal[8];

short fuenteTiempoPic;

unsigned int tiempoInicial;
unsigned int tiempoFinal;
unsigned int duracionPrueba;
unsigned short banPrueba;

int direccionNodo;
int muestrear;
int sobrescribir;

//Declaracion de funciones
int ConfiguracionPrincipal();
void IniciarMuestreo(unsigned short direccion, unsigned short sobrescribirSD);							//C:0xA1	F:0xF1
void DetenerMuestreo(unsigned short direccion);															//C:0xA2	F:0xF2


int main(int argc, char *argv[]) {

	//printf("Iniciando...\n");
  
	//Inicializa las variables:
	i = 0;
	x = 0;
	direccionNodo = (short)(atoi(argv[1]));
	muestrear = (short)(atoi(argv[2]));
	sobrescribir = (short)(atoi(argv[3]));
	
	//Configuracion principal:
	ConfiguracionPrincipal();
	
	//Obtencion de fuente de reloj:
	if (muestrear==0){
		DetenerMuestreo(direccionNodo);
	} 
	if (muestrear==1){
		if (sobrescribir==1){
			IniciarMuestreo(direccionNodo, 1);									//Sobrescribe la SD solo cuando este valor es igual a 1
		} else {
			IniciarMuestreo(direccionNodo, 0);	
		}
			
	} 
	
	sleep(1);
	bcm2835_spi_end();
	bcm2835_close();
 
	return 0;

}

//**************************************************************************************************************************************
//Configuracion:

int ConfiguracionPrincipal(){
	
	//Reinicia el modulo SPI
	system("sudo rmmod  spi_bcm2835");
	bcm2835_delayMicroseconds(500);
	system("sudo modprobe spi_bcm2835");

    //Configuracion libreria bcm2835:
	if (!bcm2835_init()){
		printf("bcm2835_init fallo. Ejecuto el programa como root?\n");
		return 1;
    }
    if (!bcm2835_spi_begin()){
		printf("bcm2835_spi_begin fallo. Ejecuto el programa como root?\n");
		return 1;
    }

    bcm2835_spi_setBitOrder(BCM2835_SPI_BIT_ORDER_MSBFIRST);
    bcm2835_spi_setDataMode(BCM2835_SPI_MODE3);
	//bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_32);					//Clock divider RPi 2
	bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_64);					//Clock divider RPi 3		
    bcm2835_spi_set_speed_hz(FreqSPI);
    bcm2835_spi_chipSelect(BCM2835_SPI_CS0);
    bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0, LOW);
		
	//Configuracion libreria WiringPi:
    wiringPiSetup();
    pinMode(P1, INPUT);
	pinMode(MCLR, OUTPUT);
	pinMode(TEST, OUTPUT);
	//wiringPiISR (P1, INT_EDGE_RISING, ObtenerOperacion);
	
	//Genera un pulso para resetear el dsPIC:
	digitalWrite (MCLR, HIGH);
	delay (100) ;
	digitalWrite (MCLR,  LOW); 
	delay (100) ;
	digitalWrite (MCLR, HIGH);
	
	//printf("Configuracion completa\n");
	
}
//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Comunicacion RPi-dsPIC:

void IniciarMuestreo(unsigned short direccion, unsigned short sobrescribirSD){
	printf("Iniciando el muestreo del nodo %d\n", direccion);
	if (sobrescribirSD==1){
		printf("ADVERTENCIA: Se ha sobreescrito la SD\n");	
	}
	bcm2835_spi_transfer(0xA1);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(direccion);											//Envia la direccion del nodo
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(sobrescribirSD);                                       //sobrescribirSD=1: Sobrescribe la SD
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(0xF1);	
}

void DetenerMuestreo(unsigned short direccion){
	printf("Deteniendo el muestreo del nodo: %d\n", direccion);
	bcm2835_spi_transfer(0xA2);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(direccion);											//Envia la direccion del nodo
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(0xF2);	
}

//**************************************************************************************************************************************






