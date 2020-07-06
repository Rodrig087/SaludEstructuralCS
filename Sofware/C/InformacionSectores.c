//Compilar:
//gcc LeerTiempoNodo.c -o /home/pi/Ejecutables/leertiemponodo -lbcm2835 -lwiringPi 
//gcc LeerTiempoNodo.c -o leertiemponodo -lbcm2835 -lwiringPi 

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
unsigned char tramaPyloadRS485[512];

short fuenteTiempoPic;

unsigned int tiempoInicial;
unsigned int tiempoFinal;
unsigned int duracionPrueba;
unsigned short banPrueba;
int direccionNodo;

//Declaracion de funciones
int ConfiguracionPrincipal();
void ObtenerOperacion();														//C:0xA0    F:0xF0
void ObtenerTiempoMaster();														//C:0xA5	F:0xF5    P:0xB1
void ObtenerTiempoNodo(unsigned short direccion);								//C:0xA7	F:0xF7
void ObtenerPyloadRS485(unsigned int numBytesPyload);							//C:0xAA	F:0xFA



int main(int argc, char *argv[]) {

	//printf("Iniciando...\n");
  
	//Inicializa las variables:
	i = 0;
	x = 0;
	direccionNodo = (short)(atoi(argv[1]));
	
	//Configuracion principal:
	ConfiguracionPrincipal();
	
	//Muestra la hora del sistema:
	system("date");
	
	//Obtencion de fuente de reloj:
	if (direccionNodo==255){
		//EnviarTiempoLocal();
	} 
	if (direccionNodo>0&&direccionNodo<=5){
		ObtenerTiempoNodo(direccionNodo);	
	} 
	if (direccionNodo>5){
		ObtenerTiempoNodo(5);
	}
	
	sleep(5);
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
	wiringPiISR (P1, INT_EDGE_RISING, ObtenerOperacion);
	
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

//C:0xA0    F:0xF0
void ObtenerOperacion(){
	
	unsigned short funcionSPI;
	unsigned short subFuncionSPI;
	unsigned short numBytesMSB;
	unsigned short numBytesLSB;
	unsigned int numBytesSPI; 
    unsigned char *ptrnumBytesSPI;
	ptrnumBytesSPI = (unsigned char *) & numBytesSPI;
	
	//Recupera: [operacion, byteLSB, byteMSB]
	bcm2835_spi_transfer(0xA0);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	funcionSPI = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	subFuncionSPI = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	numBytesLSB = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	numBytesMSB = bcm2835_spi_transfer(0x00);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(0xF0);	

	*ptrnumBytesSPI = numBytesLSB;
	*(ptrnumBytesSPI+1) = numBytesMSB;
	
	printf("Funcion: %X\n", funcionSPI);
	printf("Subfuncion: %X\n", subFuncionSPI);
	printf("Numero de bytes: %d\n", numBytesSPI);
	
	switch (funcionSPI){                                                                     
          case 0xB1:
		       //Respuesta de la sincronizacion:
			   if (subFuncionSPI==0xD1){
			       ObtenerTiempoMaster(); 
			   }
			   //Tiempo del nodo:
			   if (subFuncionSPI==0xD2){
				   ObtenerPyloadRS485(numBytesSPI);
			   }
			   break;
          case 0xB2:
		       printf("Opcion no disponible");			   
               break;
		  case 0xB3:
		       printf("Opcion no disponible");  
               break;
          default:
               printf("Error: Operacion invalida\n");  
               break;
    }
	
	digitalWrite (TEST, LOW);	
	delay (500);
	digitalWrite (TEST, HIGH);
	
}

//C:0xA5	F:0xF5 
void ObtenerTiempoMaster(){
	
	printf("Hora Master: ");	
	bcm2835_spi_transfer(0xA5);                                                 //Envia el delimitador de final de trama
    bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	fuenteTiempoPic = bcm2835_spi_transfer(0x00);								//Recibe el byte que indica la fuente de tiempo del PIC
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	for (i=0;i<6;i++){
        buffer = bcm2835_spi_transfer(0x00);
        tiempoPIC[i] = buffer;													//Guarda la hora y fecha devuelta por el dsPIC
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }

	bcm2835_spi_transfer(0xF5);                                                 //Envia el delimitador de final de trama
    bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	if (fuenteTiempoPic==0){
		printf("RTC ");
	} 
	if (fuenteTiempoPic==1){
		printf("GPS ");
	}
	
	printf("%0.2d:",tiempoPIC[3]);		//hh
	printf("%0.2d:",tiempoPIC[4]);		//mm
	printf("%0.2d ",tiempoPIC[5]);		//ss
	printf("%0.2d/",tiempoPIC[0]);		//dd
	printf("%0.2d/",tiempoPIC[1]);		//MM
	printf("%0.2d\n",tiempoPIC[2]);		//aa
				
}

//C:0xA7	F:0xF7
void ObtenerTiempoNodo(unsigned short direccion){
	printf("Obteniendo fecha/hora del nodo: %d\n", direccion);
	bcm2835_spi_transfer(0xA7);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(direccion);								
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(0xF7);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
}		

//C:0xAA	F:0xFA
void ObtenerPyloadRS485(unsigned int numBytesPyload){
	
	printf("Contenido del pyload de la trama RS485:\n");
	
	bcm2835_spi_transfer(0xAA);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	for (i=0;i<numBytesPyload;i++){
        buffer = bcm2835_spi_transfer(0x00);
        tramaPyloadRS485[i] = buffer;
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
	bcm2835_spi_transfer(0xFA);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	for (i=0;i<numBytesPyload;i++){
		printf("%d ",tramaPyloadRS485[i]);
	}
	printf("\n");
	exit (-1);
}						

//**************************************************************************************************************************************







