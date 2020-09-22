//Compilar:
//gcc InformacionSectores.c -o /home/pi/Ejecutables/informacionsectores -lbcm2835 -lwiringPi 
//gcc InformacionSectores.c -o informacionsectores -lbcm2835 -lwiringPi 

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
unsigned short funcionNodo, subFuncionNodo, numDatosNodo;
unsigned char pyloadNodo[10];

//Declaracion de funciones
int ConfiguracionPrincipal();
void ObtenerOperacion();														                                                 //C:0xA0    F:0xF0
void EnviarSolicitudNodo(unsigned short direccion, unsigned short funcion, unsigned short numDatos, unsigned char* pyload);	     //C:0xA8	F:0xF8
void ObtenerPyloadRS485(unsigned int numBytesPyload, unsigned char* pyloadRS485);							                     //C:0xAA	F:0xFA
void ImprimirInformacionSectores(unsigned char* pyloadRS485);


int main(int argc, char *argv[]) {

	//printf("Iniciando...\n");
  
	//Inicializa las variables:
	i = 0;
	x = 0;
	
	direccionNodo = (short)(atoi(argv[1]));
	funcionNodo = 0xF3;
	numDatosNodo = 1;
	
	subFuncionNodo = 0xD1;
	pyloadNodo[0] = subFuncionNodo;
	
	//Configuracion principal:
	ConfiguracionPrincipal();
	
	//Muestra la hora del sistema:
	system("date");
	
	
	if (direccionNodo>0&&direccionNodo<=5){
		EnviarSolicitudNodo(direccionNodo, funcionNodo, numDatosNodo, pyloadNodo);	
	} 
	if (direccionNodo>5){
		EnviarSolicitudNodo(5, funcionNodo, numDatosNodo, pyloadNodo);
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
	
	
	printf("Configuracion completa\n");
	
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
	
	delay(1);
	
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
          //Funciones de tiempo:
		  case 0xB1:
		       printf("Opcion no disponible"); 
			   break;
		  //Funciones de lectura de sectores:
          case 0xB3:
		       //Tiempo del nodo:
			   if (subFuncionSPI==0xD1){
				   ObtenerPyloadRS485(numBytesSPI,tramaPyloadRS485);
				   ImprimirInformacionSectores(tramaPyloadRS485);
			   }		   
               break;
          default:
               printf("Error: Operacion invalida\n");  
               break;
    }
	
	digitalWrite (TEST, LOW);	
	delay (500);
	digitalWrite (TEST, HIGH);
	
}

//C:0xA8	F:0xF8
void EnviarSolicitudNodo(unsigned short direccion, unsigned short funcion, unsigned short numDatos, unsigned char* pyload){
	
	printf("Enviando solicitud al nodo: %d\n", direccion);
		
	bcm2835_spi_transfer(0xA8);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	bcm2835_spi_transfer(direccion);								
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(funcion);								
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(numDatos);								
	bcm2835_delayMicroseconds(TIEMPO_SPI);
		
	for (i=0;i<numDatos;i++){
		bcm2835_spi_transfer(pyload[i]);								
		bcm2835_delayMicroseconds(TIEMPO_SPI);
	}
	
	bcm2835_spi_transfer(0xF8);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
}


//C:0xAA	F:0xFA
void ObtenerPyloadRS485(unsigned int numBytesPyload, unsigned char* pyloadRS485){
	
	bcm2835_spi_transfer(0xAA);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	for (i=0;i<numBytesPyload;i++){
        buffer = bcm2835_spi_transfer(0x00);
        pyloadRS485[i] = buffer;
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
	bcm2835_spi_transfer(0xFA);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	
}		

//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Procesamiento pyload trama RS485:

void ImprimirInformacionSectores(unsigned char* pyloadRS485){
	
	unsigned char *ptrPSF;                                                      //Puntero primer sector fisico
	unsigned char *ptrPSE;                                                      //Puntero primer sector de escritura
	unsigned char *ptrPSEC;                                                     //Puntero primer sector escrito en el ciclo actual 
	unsigned char *ptrSA;                                                       //Puntero sector actual
	
	unsigned long PSF;
	unsigned long PSE;
	unsigned long PSEC;
	unsigned long SA;
	
	//Asociacion de los punteros a las variables:	
	ptrPSF = (unsigned char *) & PSF;
	ptrPSE = (unsigned char *) & PSE;
	ptrPSEC = (unsigned char *) & PSEC;
	ptrSA = (unsigned char *) & SA;
	
	*ptrPSF = pyloadRS485[1];                                                  //LSB PSF
	*(ptrPSF+1) = pyloadRS485[2];
	*(ptrPSF+2) = pyloadRS485[3];
	*(ptrPSF+3) = pyloadRS485[4];                                              //MSB PSF
	*ptrPSE = pyloadRS485[5];                                                  //LSB PSE
	*(ptrPSE+1) = pyloadRS485[6];
	*(ptrPSE+2) = pyloadRS485[7];
	*(ptrPSE+3) = pyloadRS485[8];                                              //MSB PSE
	*ptrPSEC = pyloadRS485[9];                                                 //LSB PSEC
	*(ptrPSEC+1) = pyloadRS485[10];
	*(ptrPSEC+2) = pyloadRS485[11];
	*(ptrPSEC+3) = pyloadRS485[12];                                            //MSB PSEC
	*ptrSA = pyloadRS485[13];                                                  //LSB SA
	*(ptrSA+1) = pyloadRS485[14];
	*(ptrSA+2) = pyloadRS485[15];
	*(ptrSA+3) = pyloadRS485[16];                                              //MSB SA
	
	printf("Primer sector fisico: %d\n", PSF);
	printf("Primer sector de escritura: %d\n", PSE);
	printf("Primer sector escrito en el ciclo actual: %d\n", PSEC);
	printf("Sector actual: %d\n", SA);
	
	exit (-1);
	
}

//**************************************************************************************************************************************









