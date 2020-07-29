//Compilar:
//gcc LeerAceleracion.c -o /home/pi/Ejecutables/leeraceleracion -lbcm2835 -lwiringPi 
//gcc LeerAceleracion.c -o leeraceleracion -lbcm2835 -lwiringPi 

#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>
#include <bcm2835.h>
#include <time.h>
#include <string.h>
#include <unistd.h>
#include <math.h>

#include <sys/time.h>

//Declaracion de constantes
#define P1 0																	//Pin 11 GPIO
#define MCLR 28																	//Pin 38 GPIO
#define TEST 29 																//Pin 40 GPIO																						
#define TIEMPO_SPI 10
#define FreqSPI 2000000


//Declaracion de variables
unsigned int i, x;
unsigned short buffer;
unsigned char tiempoPIC[8];
unsigned char tiempoLocal[8];
unsigned char tramaPyloadRS485[2600];

short fuenteTiempoPic;

unsigned int tiempoInicial;
unsigned int tiempoFinal;
unsigned int duracionPrueba;
unsigned short banPrueba;

int direccionNodo,sectorReq;
unsigned short funcionNodo, subFuncionNodo, numDatosNodo;
unsigned char *ptrSectorReq; 
unsigned char pyloadNodo[10];

struct timeval  tv1, tv2;

//Declaracion de funciones
int ConfiguracionPrincipal();
void ObtenerOperacion();														                                                 //C:0xA0    F:0xF0
void EnviarSolicitudNodo(unsigned short direccion, unsigned short funcion, unsigned short numDatos, unsigned char* pyload);	     //C:0xA8	F:0xF8
void ObtenerPyloadRS485(unsigned int numBytesPyload, unsigned char* pyloadRS485);							                     //C:0xAA	F:0xFA
void ImprimirDatosSector(unsigned char* pyloadRS485);


int main(int argc, char *argv[]) {

	//printf("Iniciando...\n");
  
	//Inicializa las variables:
	i = 0;
	x = 0;
	
	direccionNodo = (short)(atoi(argv[1]));
	sectorReq = atoi(argv[2]);
	//Asociacion de los punteros a las variables:
    ptrSectorReq = (unsigned char *) & sectorReq;
	
	funcionNodo = 0xF3;
	numDatosNodo = 5;
	
	subFuncionNodo = 0xD3;
	pyloadNodo[0] = subFuncionNodo;
	
	pyloadNodo[1] = *ptrSectorReq;
	pyloadNodo[2] = *(ptrSectorReq+1);
	pyloadNodo[3] = *(ptrSectorReq+2);
	pyloadNodo[4] = *(ptrSectorReq+3);
	
	//prueba
	for (i=0;i<numDatosNodo;i++){
		printf("%X ", pyloadNodo[i]);
	}
	printf("\n");
	//fin prueba
	
	//Configuracion principal:
	ConfiguracionPrincipal();
	
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
			   if (subFuncionSPI==0xD3){
				   ObtenerPyloadRS485(numBytesSPI,tramaPyloadRS485);
				   ImprimirDatosSector(tramaPyloadRS485);
			   }		   
               break;
          default:
               printf("Error: Operacion invalida\n");  
               break;
    }
		
}

//C:0xA8	F:0xF8
void EnviarSolicitudNodo(unsigned short direccion, unsigned short funcion, unsigned short numDatos, unsigned char* pyload){
	
	printf("Enviando solicitud al nodo: %d\n", direccion);
		
	gettimeofday(&tv1, NULL);
	
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
	
	printf("Recuperando pyload...\n");
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

void ImprimirDatosSector(unsigned char* pyloadRS485){
	
	unsigned short xData[3];
	unsigned short yData[3];
	unsigned short zData[3];
	
	int xValue;
	int yValue;
	int zValue;
	double xAceleracion;
	double yAceleracion;
	double zAceleracion;
		
	//Verifica los datos de cabecera:
	printf("Imprimiendo datos...\n");
	
	//Imprime la hora y fecha recuperada de la trama de datos:
	printf("Datos de la trama:\n");
	printf("| ");
	printf("%0.2d:", pyloadRS485[2507-3]);			//hh
	printf("%0.2d:", pyloadRS485[2507-2]);			//mm
	printf("%0.2d ", pyloadRS485[2507-1]);			//ss
	printf("%0.2d/", pyloadRS485[2507-6]);			//aa
	printf("%0.2d/", pyloadRS485[2507-5]);			//mm
	printf("%0.2d ", pyloadRS485[2507-4]);			//dd
	printf("| ");
	
	//Imprime los primeros datos de aceleracion:
	for (x=0;x<3;x++){
		xData[x] = pyloadRS485[x+2];	
		yData[x] = pyloadRS485[x+5];	
		zData[x] = pyloadRS485[x+8];	
	}
	
	//Calculo aceleracion eje x:
	xValue = ((xData[0]<<12)&0xFF000)+((xData[1]<<4)&0xFF0)+((xData[2]>>4)&0xF);
	// Apply two complement
	if (xValue >= 0x80000) {
		xValue = xValue & 0x7FFFF;		 //Se descarta el bit 20 que indica el signo (1=negativo)
		xValue = -1*(((~xValue)+1)& 0x7FFFF);
	}
	xAceleracion = xValue * (9.8/pow(2,18));
	
	//Calculo aceleracion eje y:
	yValue = ((yData[0]<<12)&0xFF000)+((yData[1]<<4)&0xFF0)+((yData[2]>>4)&0xF);
	// Apply two complement
	if (yValue >= 0x80000) {
		yValue = yValue & 0x7FFFF;		 //Se descarta el bit 20 que indica el signo (1=negativo)
		yValue = -1*(((~yValue)+1)& 0x7FFFF);
	}
	yAceleracion = yValue * (9.8/pow(2,18));
	
	//Calculo aceleracion eje z:
	zValue = ((zData[0]<<12)&0xFF000)+((zData[1]<<4)&0xFF0)+((zData[2]>>4)&0xF);
	// Apply two complement
	if (zValue >= 0x80000) {
		zValue = zValue & 0x7FFFF;		 //Se descarta el bit 20 que indica el signo (1=negativo)
		zValue = -1*(((~zValue)+1)& 0x7FFFF);
	}
	zAceleracion = zValue * (9.8/pow(2,18));	
			
	printf("X: ");
	printf("%2.8f ", xAceleracion);
	printf("Y: ");
	printf("%2.8f ", yAceleracion);
	printf("Z: ");
	printf("%2.8f ", zAceleracion); 
	printf("|\n"); 
	
	
	gettimeofday(&tv2, NULL);
	//printf ("Total time = %f seconds\n",(double) (tv2.tv_usec - tv1.tv_usec) / 1000000 + (double) (tv2.tv_sec - tv1.tv_sec));
	printf ("Tiempo total = %f ms\n",(double) (tv2.tv_usec - tv1.tv_usec) / 1000);
	
	exit (-1);
	
}

//**************************************************************************************************************************************









