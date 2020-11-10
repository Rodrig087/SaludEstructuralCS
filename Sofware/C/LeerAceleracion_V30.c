//Compilar:
//gcc LeerAceleracion_V30.c -o leeraceleracion -lbcm2835 -lwiringPi -lm 

#define _XOPEN_SOURCE
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
#define IDConcentrador 1

//Declaracion de variables
unsigned int i, x;
unsigned short buffer;
unsigned char tiempoPIC[8];
unsigned char tiempoLocal[8];
unsigned char tramaPyloadRS485[2600];

unsigned int tiempoInicial;
unsigned int tiempoFinal;
unsigned int duracionPrueba;
unsigned short banPrueba;

int direccionNodo, horaReq, fechaReq, duracionSeg, sectorReq;
int horaSector, fechaSector;
unsigned short funcionNodo, subFuncionNodo, numDatosNodo;
unsigned short banInformacion, banInspeccion, banSolicitud, contSolicitud, contInspeccion, contAceleracion, contSegundos, contTimeOut;
unsigned char *ptrSectorReq; 
unsigned char pyloadNodo[10];
unsigned short banNewFile;

unsigned char tiempoSector[6];
struct tm dateReq;
struct tm dateSec;
char tiempoReqStr[20];
char tiempoSecStr[20];
char buffReqUNIX[15];
char buffSecUNIX[15];
long deltaTiempo;
long deltaSector;

FILE *fp;

//variables para recuperar sectores clave:
unsigned long PSF;																//Primer Sector Fisico
unsigned long PSE;																//Primer Sector Escrito
unsigned long PSEC;																//Pimer Sector Escrito en el Ciclo actual
unsigned long USE;																//Ultimo Sector Escrito
unsigned long PSC;																//Primer Sector Calculado
unsigned char *ptrPSF;                                                      	//Puntero primer sector fisico
unsigned char *ptrPSC;                                                      	//Puntero primer sector calculado
unsigned char *ptrPSE;                                                      	//Puntero primer sector de escritura
unsigned char *ptrPSEC;                                                     	//Puntero primer sector escrito en el ciclo actual 
unsigned char *ptrUSE;                                                      	//Puntero ultimo sector escrito
unsigned short banPSE, banPSEC, banUSE, banPSC, banSSC;							//Banderas para recuperar el tiempo de cada sector
unsigned short banBusquedaCompleta, banCalculoCompleto;

//Variables para calcular el tiempo de los sectores:
struct tm dateReq;
struct tm datePSE;
struct tm datePSEC;
struct tm dateUSE;
struct tm datePSC;
char dateReqStr[20];
char datePSEStr[20];
char datePSECStr[20];
char dateUSEStr[20];
char datePSCStr[20];
char buffReqUNIX[15];
char buffPSEUNIX[15];
char buffPSECUNIX[15];
char buffUSEUNIX[15];
char buffPSCUNIX[15];
long ReqUNIX, PSEUNIX, PSECUNIX, USEUNIX, PSCUNIX;

//Variables para manejo del archivo binario:
FILE *fp;

//Variables para calcular la velocidad de descarga de datos:
struct timeval  tv1, tv2;
double tiempoEjecucion, velocidadTransmision;
unsigned long totalBytesTransmitidos;


//Declaracion de funciones
int ConfiguracionPrincipal();
void ObtenerOperacion();														                                                 //C:0xA0    F:0xF0
void EnviarSolicitudNodo(unsigned short direccion, unsigned short funcion, unsigned short numDatos, unsigned char* pyload);	     //C:0xA8	F:0xF8
void ObtenerPyloadRS485(unsigned int numBytesPyload, unsigned char* pyloadRS485);
void InformacionSectores(unsigned char* pyloadRS485);
void InspeccionarSector(unsigned char* pyloadRS485);							                     
void CalcularSector();
void RecuperarEvento(unsigned char* pyloadRS485);
void CrearArchivo(unsigned short idConc, unsigned short idNodo, unsigned short duracionEvento, unsigned char* pyloadRS485);
void GuardarTrama(unsigned char* pyloadRS485);

int main(int argc, char *argv[]) {

	//printf("Iniciando...\n");
	
	//Guarda los parametros de entrada:
	//IDConcentrador = (short)(atoi(argv[1]));
	direccionNodo = (short)(atoi(argv[1]));
	fechaReq = atoi(argv[2]);
	horaReq = atoi(argv[3]);
	duracionSeg = (short)(atoi(argv[4])); 
  
	//Inicializa las variables:
	i = 0;
	x = 0;
	banInspeccion = 0;
	banSolicitud = 0;
	contSolicitud = 0;
	contAceleracion = 0;
	banNewFile = 0;
	sectorReq  = 0;
	
	banInformacion = 0;
	banPSE = 0;
	banPSEC = 0;
	banUSE = 0;
	
	banPSC = 0;
	banSSC = 0;
	banBusquedaCompleta = 0;
	banCalculoCompleto = 0;
	
	horaSector = 0;
	fechaSector = 0;
	
	funcionNodo = 0xF3;
		
	//Asociacion de los punteros a las variables:
    ptrSectorReq = (unsigned char *) & sectorReq;
	
	//Calcula el tiempo requerido en formato aa/mm/dd hh:mm:ss:
	sprintf(dateReqStr, "%d/%d/%d %d:%d:%d", (fechaReq/10000), ((fechaReq%10000)/100), ((fechaReq%10000)%100), (horaReq/3600), ((horaReq%3600)/60), ((horaReq%3600)%60));
	printf("Tiempo requerido: %s\n", dateReqStr);	
	
	//Configuracion principal:
	ConfiguracionPrincipal();
	
	//Validacion de datos de entrada:
	if (horaReq>86400){
		printf("Error: La hora del evento debe ser expresada en segundos\n");
		exit(-1);
	}
	
	//Recupera la informacion de los sectores de la SD:
	if (banInformacion==0){
		banInformacion = 1;
		subFuncionNodo = 0xD1;
		numDatosNodo = 1;
		pyloadNodo[0] = subFuncionNodo;
		EnviarSolicitudNodo(direccionNodo, funcionNodo, numDatosNodo, pyloadNodo);
	}
	
	//Inspecciona los sectores recuperados:
	while (banBusquedaCompleta!=1){
		while((contSolicitud<6)&&(banBusquedaCompleta==0)){
			//Envia una solicitud de inspeccion del sector:
			if (banInspeccion==1){
				printf("\nBusqueda:\n");
				banInspeccion = 0;
				EnviarSolicitudNodo(direccionNodo, funcionNodo, numDatosNodo, pyloadNodo);
			}			
		}
	}
	
	//Calcula el sector deseado:
	CalcularSector();
	
	//Comprueba el sector calculado:
	contSolicitud = 0;
	while (banCalculoCompleto!=1){
		while((contSolicitud<6)&&(banCalculoCompleto==0)){
			if (banInspeccion==1){
				printf("\nComprobacion:\n");
				banInspeccion = 0;
				EnviarSolicitudNodo(direccionNodo, funcionNodo, numDatosNodo, pyloadNodo);
			}
		}
	}
	
	//Recupera el evento deseado:
	subFuncionNodo = 0xD3;
	numDatosNodo = 5;
	pyloadNodo[0] = subFuncionNodo;
	contSolicitud = 0;
	gettimeofday(&tv1, NULL);
	if (banCalculoCompleto==1){
		while(contSolicitud<6){
			if (banSolicitud==0){
				banSolicitud = 1;
				//Envia la solicitud al nodo:
				EnviarSolicitudNodo(direccionNodo, funcionNodo, numDatosNodo, pyloadNodo);
			}
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
	wiringPiISR (P1, INT_EDGE_RISING, ObtenerOperacion);

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
	
	//printf("Funcion: %X\n", funcionSPI);
	//printf("Subfuncion: %X\n", subFuncionSPI);
	//printf("Numero de bytes: %d\n", numBytesSPI);
	delay(25); //**Este retardo es muy importante**
	
	switch (funcionSPI){                                                                     
		  //Funciones de lectura de sectores:
          case 0xB3:
			   //Informacion de sectores:
			   if (subFuncionSPI==0xD1){
				   ObtenerPyloadRS485(numBytesSPI,tramaPyloadRS485);
				   InformacionSectores(tramaPyloadRS485);
			   }
			   //Inspeccion de sector:
			   if (subFuncionSPI==0xD2){
				   ObtenerPyloadRS485(numBytesSPI,tramaPyloadRS485);
				   InspeccionarSector(tramaPyloadRS485);
			   }
			   //Recuperar evento:
			   if (subFuncionSPI==0xD3){
				   ObtenerPyloadRS485(numBytesSPI,tramaPyloadRS485);
				   RecuperarEvento(tramaPyloadRS485);
			   }			   
               break;
          default:
               printf("Error: Operacion invalida\n");  
			   exit (-1);
               break;
    }
		
}

//C:0xA8	F:0xF8
void EnviarSolicitudNodo(unsigned short direccion, unsigned short funcion, unsigned short numDatos, unsigned char* pyload){
	
	printf("\nEnviando solicitud al nodo...\n");
			
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
	
	//printf("termino solicitud al nodo...\n");
	
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

void InformacionSectores(unsigned char* pyloadRS485){
		
	//Asociacion de los punteros a las variables:	
	ptrPSF = (unsigned char *) & PSF;
	ptrPSE = (unsigned char *) & PSE;
	ptrPSEC = (unsigned char *) & PSEC;
	ptrUSE = (unsigned char *) & USE;
	
	//Recuperacion de datos del pyload:
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
	*ptrUSE = pyloadRS485[13];                                                  //LSB USE
	*(ptrUSE+1) = pyloadRS485[14];
	*(ptrUSE+2) = pyloadRS485[15];
	*(ptrUSE+3) = pyloadRS485[16];                                              //MSB USE
	
	//Situacion especial cuando PSEC = USE:
	if (PSEC = USE){
		PSEC = PSEC-5;
	}
	
	//Calcula el ultimo sector escrito
	USE = USE-5;															   
	
	printf("Primer sector fisico: %d\n", PSF);
	printf("Primer sector de escritura: %d\n", PSE);
	printf("Primer sector escrito en el ciclo actual: %d\n", PSEC);
	printf("Ultimo sector escrito: %d\n", USE);
	
	banPSE = 1; //Activa la bandera para recuperar el tiempo del sector PSE
	subFuncionNodo = 0xD2;
	numDatosNodo = 5;
	sectorReq = PSE;
	pyloadNodo[0] = subFuncionNodo;
	pyloadNodo[1] = *ptrSectorReq;
	pyloadNodo[2] = *(ptrSectorReq+1);
	pyloadNodo[3] = *(ptrSectorReq+2);
	pyloadNodo[4] = *(ptrSectorReq+3);
	banInspeccion = 1;
		
}

void InspeccionarSector(unsigned char* pyloadRS485){
	
	printf("Inspeccionando sector: %d\n", sectorReq);
		
	//Verifica los datos de cabecera:
	if ((pyloadRS485[1]==0xFF)&&(pyloadRS485[2]==0xFD)&&(pyloadRS485[3]==0xFB)){
		//Comprobacion:
		if (banSSC==1){
			banSSC = 0;
			printf("\nSector Calculado: %d\n", sectorReq); 
			printf("Tiempo Sector Calculado: ");
			printf("%0.2d/", pyloadRS485[7]);
			printf("%0.2d/", pyloadRS485[8]);
			printf("%0.2d ", pyloadRS485[9]);
			printf("%0.2d:", pyloadRS485[10]);
			printf("%0.2d:", pyloadRS485[11]);
			printf("%0.2d ", pyloadRS485[12]);
			printf("seg: %d\n", (3600*pyloadRS485[10])+(60*pyloadRS485[11])+(pyloadRS485[12]));
			banCalculoCompleto = 1;
			//exit(-1);
		}
		if (banPSC==1){
			banPSC = 0;
			PSC = sectorReq;
			sprintf(datePSCStr, "%d/%d/%d %d:%d:%d", pyloadRS485[7], pyloadRS485[8], pyloadRS485[9], pyloadRS485[10], pyloadRS485[11], pyloadRS485[12]);
			strptime(datePSCStr, "%y/%m/%d %H:%M:%S", &datePSC);
			strftime(buffPSCUNIX, sizeof(buffPSCUNIX), "%s", &datePSC);
			PSCUNIX = atoi(buffPSCUNIX);
			if (ReqUNIX==PSCUNIX){
				printf("\nSector Calculado: %d\n", sectorReq);
				printf("Tiempo Sector Calculado: %s", datePSCStr);
				printf(" seg: %d\n", (3600*pyloadRS485[10])+(60*pyloadRS485[11])+(pyloadRS485[12]));
				banCalculoCompleto = 1;
				//exit(-1);
			} else {
				printf("Tiempo Primer Sector Calculado: %s\n", datePSCStr);
				deltaTiempo = ReqUNIX - PSCUNIX;
				deltaSector = deltaTiempo * 5;
				sectorReq = PSC + deltaSector;	
				banSSC = 1;
			}	
		}
		//Busqueda:
		if (banUSE==1){
			banPSE = 0;
			banPSEC = 0;
			banUSE = 0;
			sprintf(dateUSEStr, "%d/%d/%d %d:%d:%d", pyloadRS485[7], pyloadRS485[8], pyloadRS485[9], pyloadRS485[10], pyloadRS485[11], pyloadRS485[12]);
			printf("Tiempo USE: %s\n", dateUSEStr);
			//Cambia estos valores para salir del bucle de busqueda:
			banBusquedaCompleta = 1;
		}
		if (banPSEC==1){
			banPSE = 0;
			banPSEC = 0;
			banUSE = 1;
			sectorReq = USE;
			sprintf(datePSECStr, "%d/%d/%d %d:%d:%d", pyloadRS485[7], pyloadRS485[8], pyloadRS485[9], pyloadRS485[10], pyloadRS485[11], pyloadRS485[12]);
			printf("Tiempo PSEC: %s\n", datePSECStr);
		}
		if (banPSE==1){
			banPSE = 0;
			banPSEC = 1;
			banUSE = 0;
			sectorReq = PSEC;
			sprintf(datePSEStr, "%d/%d/%d %d:%d:%d", pyloadRS485[7], pyloadRS485[8], pyloadRS485[9], pyloadRS485[10], pyloadRS485[11], pyloadRS485[12]);
			printf("Tiempo PSE: %s\n", datePSEStr);
		}
		
		contSolicitud = 0;
					
	} else {
		
		if (pyloadRS485[1]==0xEE){
			if (pyloadRS485[2]==0xE1){ 
				printf("Error %X: Sector fuera de rango\n", pyloadRS485[2]);
				sectorReq++;
			} 
			if (pyloadRS485[2]==0xE2){
				printf("Error %X: Sector sin datos\n", pyloadRS485[2]);
				sectorReq++;
			}
			if (pyloadRS485[2]==0xE3){
				printf("Error %X: Error al leer la SD\n", pyloadRS485[2]);
				sectorReq++;
			}
			if (pyloadRS485[2]==0xE4){
				printf("Error %X: Timeout expiro al recuperar la trama RS485\n", pyloadRS485[2]);
				delay(200);
			}
		} else {
			printf("No se pudo realizar la lectura. Revise el sector seleccionado.\n");
			exit(-1);
		}
		
		contSolicitud++;
		if (contSolicitud==5){
			exit(-1);
		}
		
	}
	
	
		
	//Guarda el sector en el pyload de peticion:
	pyloadNodo[0] = subFuncionNodo;
	pyloadNodo[1] = *ptrSectorReq;
	pyloadNodo[2] = *(ptrSectorReq+1);
	pyloadNodo[3] = *(ptrSectorReq+2);
	pyloadNodo[4] = *(ptrSectorReq+3);
	banInspeccion = 1;	
	
}


void CalcularSector(){
	
	//Calcula el tiempo UNIX:
	strptime(dateReqStr, "%y/%m/%d %H:%M:%S", &dateReq);
	strptime(datePSEStr, "%y/%m/%d %H:%M:%S", &datePSE);
	strptime(datePSECStr, "%y/%m/%d %H:%M:%S", &datePSEC);
	strptime(dateUSEStr, "%y/%m/%d %H:%M:%S", &dateUSE);
	
	strftime(buffReqUNIX, sizeof(buffReqUNIX), "%s", &dateReq);
	strftime(buffPSEUNIX, sizeof(buffPSEUNIX), "%s", &datePSE);
	strftime(buffPSECUNIX, sizeof(buffPSECUNIX), "%s", &datePSEC);
	strftime(buffUSEUNIX, sizeof(buffUSEUNIX), "%s", &dateUSE);
	
	ReqUNIX = atoi(buffReqUNIX);
	PSEUNIX = atoi(buffPSEUNIX);
	PSECUNIX = atoi(buffPSECUNIX);
	USEUNIX = atoi(buffUSEUNIX);
	
	printf("\nTiempo UNIX requerido: %d\n", ReqUNIX);
	printf("Tiempo UNIX PSE: %d\n", PSEUNIX);
	printf("Tiempo UNIX PSEC: %d\n", PSECUNIX);
	printf("Tiempo UNIX USE: %d\n", USEUNIX);
	
	
	if ((ReqUNIX<PSEUNIX)||(ReqUNIX>USEUNIX)){
		printf("\nEl tiempo requerido esta fuera de rango\n");
		exit(-1);
	} else {
		if ((ReqUNIX>=PSEUNIX)&&(ReqUNIX<=PSECUNIX)){
			deltaTiempo = ReqUNIX - PSEUNIX;
			deltaSector = deltaTiempo * 5;
			sectorReq = PSE + deltaSector;	//En la version anterior resto 2 posiciones a este sector
		}
		//Busca el sector a partir de la ultima vez que se 
		if ((ReqUNIX>PSECUNIX)&&(ReqUNIX<=USEUNIX)){
			deltaTiempo = ReqUNIX - PSECUNIX;
			deltaSector = deltaTiempo * 5;
			sectorReq = PSEC + deltaSector;
		}
		
		banPSC = 1;							//Activa la bandera de Primer Sector Calculado
		pyloadNodo[0] = subFuncionNodo;
		pyloadNodo[1] = *ptrSectorReq;
		pyloadNodo[2] = *(ptrSectorReq+1);
		pyloadNodo[3] = *(ptrSectorReq+2);
		pyloadNodo[4] = *(ptrSectorReq+3);
		printf("Sector Calculado: %d\n", sectorReq);
	}

}

void RecuperarEvento(unsigned char* pyloadRS485){
		
	unsigned short xData[3];
	unsigned short yData[3];
	unsigned short zData[3];
	
	int xValue;
	int yValue;
	int zValue;
	double xAceleracion;
	double yAceleracion;
	double zAceleracion;
	
	char fuenteTiempoNodo[10];
	
	//printf("Imprimiendo datos de la trama...\n");
	
	//Verifica los datos de cabecera:
	if ((pyloadRS485[1]==0xFF)&&(pyloadRS485[2]==0xFD)&&(pyloadRS485[3]==0xFB)){
						
		//Calcula los primeros datos de aceleracion:
		for (x=0;x<3;x++){
			xData[x] = pyloadRS485[x+8];	
			yData[x] = pyloadRS485[x+11];	
			zData[x] = pyloadRS485[x+14];	
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

		//Imprime el segundo actual:
		printf("Segundo: %d\n", contSegundos);
		
		//Extrae la fuente de reloj:
		switch (pyloadRS485[7]){                                                                     
			  //Funciones de lectura de sectores:
			  case 0:
				   strcpy(fuenteTiempoNodo,"RPi");   
				   break;
			  case 1:
				   strcpy(fuenteTiempoNodo,"GPS");   
				   break;
			  case 2:
				   strcpy(fuenteTiempoNodo,"RTC");   
				   break;
			  case 5:
				   strcpy(fuenteTiempoNodo,"RTC_E5");   
				   break;
			  case 6:
				   strcpy(fuenteTiempoNodo,"RTC_E6");   
				   break;
			  case 7:
				   strcpy(fuenteTiempoNodo,"RTC_E7");   
				   break;
			  default:
				   strcpy(fuenteTiempoNodo,"indet");
				   break;
		}
		
		//Imprime la hora y fecha recuperada de la trama de datos:
		printf("| ");
		printf("%s ", fuenteTiempoNodo);                //Fuente reloj nodo
		printf("%0.2d/", pyloadRS485[2513-6]);			//aa
		printf("%0.2d/", pyloadRS485[2513-5]);			//mm
		printf("%0.2d ", pyloadRS485[2513-4]);			//dd
		printf("%0.2d:", pyloadRS485[2513-3]);			//hh
		printf("%0.2d:", pyloadRS485[2513-2]);			//mm
		printf("%0.2d ", pyloadRS485[2513-1]);			//ss
		printf("| ");
		//Imprime los primeros datos de aceleracion:
		printf("X: ");
		printf("%2.8f ", xAceleracion);
		printf("Y: ");
		printf("%2.8f ", yAceleracion);
		printf("Z: ");
		printf("%2.8f ", zAceleracion); 
		printf("|\n");
					
		if (contSegundos==0){
			CrearArchivo(IDConcentrador, direccionNodo, duracionSeg, pyloadRS485);
		}
		GuardarTrama(pyloadRS485);
		
		contSolicitud = 0;
		contSegundos++;
		sectorReq = sectorReq + 5;
				
	} else {
		
		if (pyloadRS485[1]==0xEE){
			if (pyloadRS485[2]==0xE3){
				printf("Error %X: Error al leer la SD\n", pyloadRS485[2]);
				sectorReq = sectorReq + 1;
			}
			if (pyloadRS485[2]==0xE4){
				printf("Error %X: Timeout expiro al recuperar la trama RS485\n", pyloadRS485[2]);
				delay(200);
				contTimeOut++;
			}
			
		} else {
			printf("No se pudo realizar la lectura. Revise el sector seleccionado.\n");			
		}
		
		contSolicitud++;
		
	}
	
	if ((contSegundos==duracionSeg)||(contSolicitud==5)){
		gettimeofday(&tv2, NULL);
		tiempoEjecucion = (double)(tv2.tv_sec - tv1.tv_sec)+((double)(tv2.tv_usec - tv1.tv_usec)/1000000);
		totalBytesTransmitidos = (contSegundos + contSolicitud) *2513;
		velocidadTransmision = (double)totalBytesTransmitidos / tiempoEjecucion / 1000 * 8;
				
		printf ("\nTiempo de descarga = %0.3f segundos", tiempoEjecucion);
		printf ("\nTotal de bytes descargados = %d bytes", totalBytesTransmitidos);
		printf ("\nVelocidad de descarga promedio = %0.3f Kbps\n", velocidadTransmision);
		printf ("\nNumero de TimeOust detectados = %d \n\n", contTimeOut);
		
		//Cierra el archivo binario:
		fclose (fp);
		exit(-1);
	}
	
	
	printf("\nInspeccionando sector: %d\n", sectorReq);
	pyloadNodo[0] = subFuncionNodo;
	pyloadNodo[1] = *ptrSectorReq;
	pyloadNodo[2] = *(ptrSectorReq+1);
	pyloadNodo[3] = *(ptrSectorReq+2);
	pyloadNodo[4] = *(ptrSectorReq+3);
	banSolicitud = 0;
	
}


//**************************************************************************************************************************************
//Manejo de archivos binarios:

void CrearArchivo(unsigned short idConc, unsigned short idNodo, unsigned short duracionEvento, unsigned char* pyloadRS485){

	char fuenteTiempoNodo[10];
	char tiempoNodo[6];
	char nombreArchivo[50];
	char idArchivo[8];
	char tiempoNodoStr[20];
	char duracionEventoStr[4];
	char ext[5];
	
	//Extrae la fuente de reloj:
	switch (pyloadRS485[7]){                                                                     
		  //Funciones de lectura de sectores:
          case 0:
			   strcpy(fuenteTiempoNodo,"RPi");   
               break;
		  case 1:
			   strcpy(fuenteTiempoNodo,"GPS");   
               break;
		  case 2:
			   strcpy(fuenteTiempoNodo,"RTC");   
               break;
	      case 5:
			   strcpy(fuenteTiempoNodo,"RTC_E5");   
               break;
		  case 6:
			   strcpy(fuenteTiempoNodo,"RTC_E6");   
               break;
		  case 7:
			   strcpy(fuenteTiempoNodo,"RTC_E7");   
               break;
          default:
               strcpy(fuenteTiempoNodo,"indet");
               break;
    }
	
	//Extrae el tiempo de la trama pyload:	
	tiempoNodo[0] = pyloadRS485[2507];                                    //aa
	tiempoNodo[1] = pyloadRS485[2508];                                    //mm
	tiempoNodo[2] = pyloadRS485[2509];                                    //dd
	tiempoNodo[3] = pyloadRS485[2510];                                    //hh
	tiempoNodo[4] = pyloadRS485[2511];                                    //mm
	tiempoNodo[5] = pyloadRS485[2512];                                    //ss		
	
	//Realiza la concatenacion para obtner el nombre del archivo:			
	strcpy(nombreArchivo, "/home/pi/Resultados/");
	sprintf(idArchivo, "C%0.2dN%0.2d_", idConc, idNodo); 
	sprintf(tiempoNodoStr, "%0.2d%0.2d%0.2d-%0.2d%0.2d%0.2d-%s_", tiempoNodo[0], tiempoNodo[1], tiempoNodo[2], tiempoNodo[3], tiempoNodo[4], tiempoNodo[5], fuenteTiempoNodo);
	sprintf(duracionEventoStr, "%0.3d", duracionEvento); 
	strcpy(ext, ".dat");
	strcat(nombreArchivo, idArchivo);
	strcat(nombreArchivo, tiempoNodoStr);
	strcat(nombreArchivo, duracionEventoStr);
	strcat(nombreArchivo, ext); 
	
	//Crea el archivo binario:
	printf("Se ha creado el archivo: %s\n", nombreArchivo);
	fp = fopen (nombreArchivo, "ab+");
	
}

void GuardarTrama(unsigned char* pyloadRS485_2){
		
	unsigned int outFwrite;
	unsigned char tramaAceleracion[2506];
	//char fuenteTiempoNodo[10];
		
	//Llena la trama de aceleracion con lo valores del pyload:
	for (x=0;x<2506;x++){
		tramaAceleracion[x] = pyloadRS485_2[x+7];
	}
	
	/*
	//prueba
	printf("Contenido de la trama guardada: ");
	printf("| Fuente de reloj: ");
	if (tramaAceleracion[0]==0){
		//printf("RPi");
		strcpy(fuenteTiempoNodo,"RPi");
	} 
	if (tramaAceleracion[0]==1){
		//printf("GPS");
		strcpy(fuenteTiempoNodo,"GPS");
	}
	if (tramaAceleracion[0]==2){
		//printf("RTC");
		strcpy(fuenteTiempoNodo,"RTC");
	}
	if (tramaAceleracion[0]==5){
		//printf("RTC_E5");
		strcpy(fuenteTiempoNodo,"RTC_E5");
	}
	if (tramaAceleracion[0]==6){
		//printf("RTC_E6");
		strcpy(fuenteTiempoNodo,"RTC_E6");
	}
	if (tramaAceleracion[0]==7){
		//printf("RTC_E7");
		strcpy(fuenteTiempoNodo,"RTC_E7");
	}
	
	printf("%s", fuenteTiempoNodo);
	
	printf(" | ");
	printf("%0.2d/", tramaAceleracion[2500]);			//hh
	printf("%0.2d/", tramaAceleracion[2501]);			//mm
	printf("%0.2d ", tramaAceleracion[2502]);			//dd
	printf("%0.2d:", tramaAceleracion[2503]);			//hh
	printf("%0.2d:", tramaAceleracion[2504]);			//mm
	printf("%0.2d", tramaAceleracion[2505]);			//ss
	printf(" |\n");
	*/
		
	//Guarda la trama en el archivo binario:
	if (fp!=NULL){
		do{
		outFwrite = fwrite(tramaAceleracion, sizeof(char), 2506, fp);
		} while (outFwrite!=2506);
		fflush(fp);
	} else {
		printf("No se pudo escribir el archivo binario\n");
	}
		
}

//**************************************************************************************************************************************







