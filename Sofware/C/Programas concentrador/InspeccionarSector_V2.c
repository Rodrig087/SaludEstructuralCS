//Compilar:
//gcc InspeccionarSector.c -o /home/pi/Ejecutables/inspeccionarsector -lbcm2835 -lwiringPi 
//gcc InspeccionarSector_V2.c -o inspeccionarsector -lbcm2835 -lwiringPi 

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
unsigned int i, x;
unsigned short buffer;
unsigned char tiempoPIC[8];
unsigned char tiempoLocal[8];
unsigned char tramaPyloadRS485[515];

short fuenteTiempoNodo;

unsigned int tiempoInicial;
unsigned int tiempoFinal;
unsigned int duracionPrueba;
unsigned short banPrueba;

int direccionNodo,sectorReq;
unsigned short funcionNodo, subFuncionNodo, numDatosNodo;
unsigned short banSolicitud, contSolicitud;
unsigned char *ptrSectorReq; 
unsigned char pyloadNodo[10];

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
	banSolicitud = 0;
	contSolicitud = 0;
	fuenteTiempoNodo = 2;
	
	direccionNodo = (short)(atoi(argv[1]));
	sectorReq = atoi(argv[2]);
	//Asociacion de los punteros a las variables:
    ptrSectorReq = (unsigned char *) & sectorReq;
	
	funcionNodo = 0xF3;
	numDatosNodo = 5;
	
	subFuncionNodo = 0xD2;
	pyloadNodo[0] = subFuncionNodo;
	
	pyloadNodo[1] = *ptrSectorReq;
	pyloadNodo[2] = *(ptrSectorReq+1);
	pyloadNodo[3] = *(ptrSectorReq+2);
	pyloadNodo[4] = *(ptrSectorReq+3);
	
	//Configuracion principal:
	ConfiguracionPrincipal();
	printf("Inspeccionando sector: %d\n", sectorReq);
	
	while(contSolicitud<6){
		
		if (banSolicitud==0){
			banSolicitud = 1;
			//Envia la solicitud al nodo:
			EnviarSolicitudNodo(direccionNodo, funcionNodo, numDatosNodo, pyloadNodo);
			contSolicitud++;
		}
		
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
	
	bcm2835_delayMicroseconds(200);
	
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
	
	//printf("Funcion: %X\n", funcionSPI);
	//printf("Subfuncion: %X\n", subFuncionSPI);
	//printf("Numero de bytes: %d\n", numBytesSPI);
	delay(50);
	
	switch (funcionSPI){                                                                     
          //Funciones de tiempo:
		  case 0xB1:
		       printf("Opcion no disponible"); 
			   break;
		  //Funciones de lectura de sectores:
          case 0xB3:
		       //Tiempo del nodo:
			   if (subFuncionSPI==0xD2){
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
	
	//printf("Enviando solicitud al nodo: %d\n", direccion);
		
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

void ImprimirDatosSector(unsigned char* pyloadRS485){
		
	//Verifica los datos de cabecera:
	
	if ((pyloadRS485[1]==0xFF)&&(pyloadRS485[2]==0xFD)&&(pyloadRS485[3]==0xFB)){
		printf("Sector: %d\n", sectorReq); 
		printf("Tiempo: ");
		fuenteTiempoNodo = pyloadRS485[13];
		if (fuenteTiempoNodo==0){
			printf("RPi ");
		} 
		if (fuenteTiempoNodo==1){
			printf("GPS ");
		}
		if (fuenteTiempoNodo==2){
			printf("RTC ");
		} 
		if (fuenteTiempoNodo==5){
			printf("RTC_E5 ");
		}
		if (fuenteTiempoNodo==6){
			printf("RTC_E6 ");
		}
		if (fuenteTiempoNodo==7){
			printf("RTC_E7 ");
		}
		printf("%0.2d/", pyloadRS485[7]);
		printf("%0.2d/", pyloadRS485[8]);
		printf("%0.2d ", pyloadRS485[9]);
		printf("%0.2d:", pyloadRS485[10]);
		printf("%0.2d:", pyloadRS485[11]);
		printf("%0.2d ", pyloadRS485[12]);
		printf("%d\n", (3600*pyloadRS485[10])+(60*pyloadRS485[11])+(pyloadRS485[12]));
		exit(-1);
	} else {
		if (pyloadRS485[1]==0xEE){
			if (pyloadRS485[2]==0xE1){ 
				printf("Error %X: Sector fuera de rango\n", pyloadRS485[2]);
			} 
			if (pyloadRS485[2]==0xE2){
				printf("Error %X: Sector sin datos\n", pyloadRS485[2]);
			}
			if (pyloadRS485[2]==0xE3){
				printf("Error %X: Error al leer la SD\n", pyloadRS485[2]);
			}
		}
		if (contSolicitud==5){
			exit(-1);
		}
		//Incrementa el sector:
		sectorReq++;
		printf("Inspeccionando sector: %d\n", sectorReq);
		pyloadNodo[0] = subFuncionNodo;
		pyloadNodo[1] = *ptrSectorReq;
		pyloadNodo[2] = *(ptrSectorReq+1);
		pyloadNodo[3] = *(ptrSectorReq+2);
		pyloadNodo[4] = *(ptrSectorReq+3);
		banSolicitud = 0;
		
	}
		
}

//**************************************************************************************************************************************

/*
Nota: Esta funcion lee unicamente el primer sector donde estan los datos de cabecera (6bytes de cabecera y 6 bytes de tiempo)
y los primeros datos de aceleracion incluido el primer byte que indica la fuente de reloj
*/







