//Compilar:
//gcc LeerAceleracion_V2.c -o /home/pi/Ejecutables/leeraceleracion -lbcm2835 -lwiringPi 
//gcc LeerAceleracion_V2.c -o leeraceleracion -lbcm2835 -lwiringPi 

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

int IDConcentrador, direccionNodo, horaReq, fechaReq, duracionSeg, sectorReq;
int horaSector, fechaSector;
unsigned short funcionNodo, subFuncionNodo, numDatosNodo;
unsigned short banInspeccion, banSolicitud, contInspeccion, contAceleracion;
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

//Declaracion de funciones
int ConfiguracionPrincipal();
void ObtenerOperacion();														                                                 //C:0xA0    F:0xF0
void EnviarSolicitudNodo(unsigned short direccion, unsigned short funcion, unsigned short numDatos, unsigned char* pyload);	     //C:0xA8	F:0xF8
void ObtenerPyloadRS485(unsigned int numBytesPyload, unsigned char* pyloadRS485);
long InformacionSectores(unsigned char* pyloadRS485);
void InspeccionarSector(unsigned char* pyloadRS485);							                     //C:0xAA	F:0xFA
void CalcularSector();
void ImprimirDatosSector(unsigned char* pyloadRS485);
void GuardarTrama(unsigned short banNewFile, unsigned short idConc, unsigned short idNodo, unsigned short duracionEvento, unsigned char* pyloadRS485);

int main(int argc, char *argv[]) {

	//printf("Iniciando...\n");
	
	//Guarda los parametros de entrada:
	IDConcentrador = (short)(atoi(argv[1]));
	direccionNodo = (short)(atoi(argv[2]));
	horaReq = atoi(argv[3]);
	fechaReq = atoi(argv[4]);
	duracionSeg = (short)(atoi(argv[5])); 
	
	//Provisional
	//sectorReq = atoi(argv[6]);
  
	//Inicializa las variables:
	i = 0;
	x = 0;
	banInspeccion = 0;
	banSolicitud = 0;
	contInspeccion = 0;
	contAceleracion = 0;
	banNewFile = 0;
	sectorReq  = 0;
	
	horaSector = 0;
	fechaSector = 0;
	
	funcionNodo = 0xF3;
	numDatosNodo = 5;
		
	//Llena el pyload con el dato del sector requerido:
    ptrSectorReq = (unsigned char *) & sectorReq;
		
	//Configuracion principal:
	ConfiguracionPrincipal();
		
	//Recupera el primer sector del dia:
	subFuncionNodo = 0xD1;
	pyloadNodo[0] = subFuncionNodo;
	EnviarSolicitudNodo(direccionNodo, funcionNodo, numDatosNodo, pyloadNodo);
	while(sectorReq==0);                                                        //Espera hasta que reciba el sector requerido
	
	//Inspecciona el sector recuperado:
	subFuncionNodo = 0xD2;
	pyloadNodo[0] = subFuncionNodo;
	pyloadNodo[1] = *ptrSectorReq;
	pyloadNodo[2] = *(ptrSectorReq+1);
	pyloadNodo[3] = *(ptrSectorReq+2);
	pyloadNodo[4] = *(ptrSectorReq+3);
	while((contInspeccion<6)&&(banInspeccion!=2)){		
		if (banInspeccion==0){
			banInspeccion = 1;
			//Envia la solicitud al nodo:
			EnviarSolicitudNodo(direccionNodo, funcionNodo, numDatosNodo, pyloadNodo);
			contInspeccion++;
		}
	}	
		
	//Calcula el sector que tiene los datos de la hora y fecha requeridos:
	CalcularSector();
	
	//Inspecciona de nuevo el sector:
	contInspeccion = 0;
	banInspeccion = 0;
	subFuncionNodo = 0xD2;
	pyloadNodo[0] = subFuncionNodo;
	pyloadNodo[1] = *ptrSectorReq;
	pyloadNodo[2] = *(ptrSectorReq+1);
	pyloadNodo[3] = *(ptrSectorReq+2);
	pyloadNodo[4] = *(ptrSectorReq+3);
	while((contInspeccion<6)&&(banInspeccion!=2)){		
		if (banInspeccion==0){
			banInspeccion = 1;
			//Envia la solicitud al nodo:
			EnviarSolicitudNodo(direccionNodo, funcionNodo, numDatosNodo, pyloadNodo);
			contInspeccion++;
		}
	}
		
	//Recupera la trama de aceleracion
	subFuncionNodo = 0xD3;
	pyloadNodo[0] = subFuncionNodo;
	pyloadNodo[1] = *ptrSectorReq;
	pyloadNodo[2] = *(ptrSectorReq+1);
	pyloadNodo[3] = *(ptrSectorReq+2);
	pyloadNodo[4] = *(ptrSectorReq+3);
	while(contAceleracion<duracionSeg){
		if (banSolicitud==0){	
			if (contAceleracion==1){
				banNewFile = 1;
			}
			if (contAceleracion==duracionSeg-1){
				banNewFile = 2;
			}
			banSolicitud = 1;
			printf("\nLectura: %d\n", contAceleracion);
			//Envia la solicitud al nodo:
			EnviarSolicitudNodo(direccionNodo, funcionNodo, numDatosNodo, pyloadNodo);
			//Incrementa el sector:
			sectorReq = sectorReq + 5;
			pyloadNodo[0] = subFuncionNodo;
			pyloadNodo[1] = *ptrSectorReq;
			pyloadNodo[2] = *(ptrSectorReq+1);
			pyloadNodo[3] = *(ptrSectorReq+2);
			pyloadNodo[4] = *(ptrSectorReq+3);
			//Incrementa el contador de solicitudes:
			contAceleracion++;
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
		  //Funciones de lectura de sectores:
          case 0xB3:
			   //Informacion de sectores:
			   if (subFuncionSPI==0xD1){
				   ObtenerPyloadRS485(numBytesSPI,tramaPyloadRS485);
				   sectorReq = InformacionSectores(tramaPyloadRS485);
			   }
		  
			   //Inspeccion de sector:
			   if (subFuncionSPI==0xD2){
				   ObtenerPyloadRS485(numBytesSPI,tramaPyloadRS485);
				   InspeccionarSector(tramaPyloadRS485);
			   }
		  
		       //Lectura de datos de aceleracion:
			   if (subFuncionSPI==0xD3){
				   ObtenerPyloadRS485(numBytesSPI,tramaPyloadRS485);
				   ImprimirDatosSector(tramaPyloadRS485);
				   GuardarTrama(banNewFile, IDConcentrador, direccionNodo, duracionSeg, tramaPyloadRS485);
			   }		   
               break;
          default:
               printf("Error: Operacion invalida\n");  
               break;
    }
		
}

//C:0xA8	F:0xF8
void EnviarSolicitudNodo(unsigned short direccion, unsigned short funcion, unsigned short numDatos, unsigned char* pyload){
	
	printf("\nEnviando solicitud al nodo...\n");
	printf("Dir: %d, Funcion: %X, #Datos: %d, Subfuncion: %X, Sector: %d\n", direccion, funcion, numDatos, pyload[0], sectorReq);
		
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
	
	printf("termino solicitud al nodo...\n");
	
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

long InformacionSectores(unsigned char* pyloadRS485){
	
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
	
	return PSEC+1;     //**Por lo general el primer sector guarda mal la fecha por lo que es mejor saltar al siguiente
	
}

void InspeccionarSector(unsigned char* pyloadRS485){
		
	//Verifica los datos de cabecera:
	
	if ((pyloadRS485[1]==0xFF)&&(pyloadRS485[2]==0xFD)&&(pyloadRS485[3]==0xFB)){
		tiempoSector[0] = pyloadRS485[9];
		tiempoSector[1] = pyloadRS485[8];
		tiempoSector[2] = pyloadRS485[7];
		tiempoSector[3] = pyloadRS485[10];
		tiempoSector[4] = pyloadRS485[11];
		tiempoSector[5] = pyloadRS485[12];
		sprintf(tiempoSecStr, "%d/%d/%d %d:%d:%d", tiempoSector[0], tiempoSector[1], tiempoSector[2], tiempoSector[3], tiempoSector[4], tiempoSector[5]);
		printf("\n");
		printf("Sector inspeccionado: %d\n", sectorReq); 
		printf("Tiempo: ");
		printf(tiempoSecStr);
		printf("\n");
		banInspeccion = 2;
	} else {
		if (contInspeccion==5){
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
				exit(-1);
			}
		}
		//Incrementa el sector:
		sectorReq++;
		pyloadNodo[0] = subFuncionNodo;
		pyloadNodo[1] = *ptrSectorReq;
		pyloadNodo[2] = *(ptrSectorReq+1);
		pyloadNodo[3] = *(ptrSectorReq+2);
		pyloadNodo[4] = *(ptrSectorReq+3);
		banInspeccion = 0;
	}
		
}

void CalcularSector(){
	
	printf("\nCalculando el sector de datos de aceleracion..\n");
	sprintf(tiempoReqStr, "%d/%d/%d %d:%d:%d", (fechaReq/10000), ((fechaReq%10000)/100), ((fechaReq%10000)%100), (horaReq/3600), ((horaReq%3600)/60), ((horaReq%3600)%60));
	
	strptime(tiempoReqStr, "%y/%m/%d %H:%M:%S", &dateReq);
	strptime(tiempoSecStr, "%y/%m/%d %H:%M:%S", &dateSec);
	
	strftime(buffReqUNIX, sizeof(buffReqUNIX), "%s", &dateReq);
	strftime(buffSecUNIX, sizeof(buffSecUNIX), "%s", &dateSec);
	
	deltaTiempo = atoi(buffReqUNIX) - atoi(buffSecUNIX);
	deltaSector = deltaTiempo * 5;
	sectorReq = sectorReq + deltaSector - 2;
	
	printf("Tiempo requerido: ");
	printf(tiempoReqStr);
	printf("\n");
	printf("Tiempo del sector: ");
	printf(tiempoSecStr);
	printf("\n");
	printf("Delta tiempo: %d\n" , deltaTiempo);
	printf("Delta sector: %d\n" , deltaSector);
	printf("Sector calculado: %d\n", sectorReq); 

}


//Funcion para imprimir informacion relevante de las tramas recuperadas:
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
		
}

//Funcion para crear el archivo binario que almacenara los datos:
void GuardarTrama(unsigned short banNewFile, unsigned short idConc, unsigned short idNodo, unsigned short duracionEvento, unsigned char* pyloadRS485){
		
	unsigned int outFwrite;
	unsigned char tramaAceleracion[2506];
	
	//banNewFile = 0;
	
	//Crea el archivo binario:
	if (banNewFile==0){
		
		//Variables para manejo del archivo binario:
		char tiempoNodo[6];
		char nombreArchivo[50];
		char idArchivo[8];
		char tiempoNodoStr[13];
		char duracionEventoStr[4];
		char ext[5];
	
				
		//Extrae el tiempo de la trama pyload:	
		tiempoNodo[0] = pyloadRS485[2501];                                    //dd
		tiempoNodo[1] = pyloadRS485[2502];                                    //mm
		tiempoNodo[2] = pyloadRS485[2503];                                    //aa
		tiempoNodo[3] = pyloadRS485[2504];                                    //hh
		tiempoNodo[4] = pyloadRS485[2505];                                    //mm
		tiempoNodo[5] = pyloadRS485[2506];                                    //ss		
		//Realiza la concatenacion para obtner el nombre del archivo:			
		strcpy(nombreArchivo, "/home/pi/Resultados/");
		sprintf(idArchivo, "C%0.2dN%0.2d_", idConc, idNodo); 
		sprintf(tiempoNodoStr, "%0.2d%0.2d%0.2d%0.2d%0.2d%0.2d_", tiempoNodo[2], tiempoNodo[1], tiempoNodo[0], tiempoNodo[3], tiempoNodo[4], tiempoNodo[5]);
		sprintf(duracionEventoStr, "%0.3d", duracionEvento); 
		strcpy(ext, ".dat");
		strcat(nombreArchivo, idArchivo);
		strcat(nombreArchivo, tiempoNodoStr);
		strcat(nombreArchivo, duracionEventoStr);
		strcat(nombreArchivo, ext);
		printf("Se ha creado el archivo: %s\n", nombreArchivo); 
		//Crea el archivo binario:
		fp = fopen (nombreArchivo, "ab+");
		
	}
	
	//Llena la trama de aceleracion con lo valores del pyload:
	for (x=0;x<2506;x++){
		tramaAceleracion[x] = pyloadRS485[x+1];
	}
	
	//Guarda la trama en el archivo binario:
	if (fp!=NULL){
		do{
		outFwrite = fwrite(tramaAceleracion, sizeof(char), 2506, fp);
		} while (outFwrite!=2506);
		fflush(fp);
	}

	//Cierra el archivo binario:
	if (banNewFile==2){
		
		fclose (fp);
		
	}
	
	banSolicitud = 0;
	
}


//**************************************************************************************************************************************








