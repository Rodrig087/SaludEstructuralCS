//Compilar:
//gcc SincronizarTiempoSistema.c -o /home/pi/Ejecutables/sincronizartiemposistema -lbcm2835 -lwiringPi 
//gcc SincronizarTiempoSistema.c -o sincronizartiemposistema -lbcm2835 -lwiringPi 

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
int fuenteTiempo;
unsigned short errorSinc;

//Declaracion de funciones
int ConfiguracionPrincipal();
void ObtenerOperacion();														//C:0xA0    F:0xF0
void EnviarTiempoLocal();														//C:0xA4	F:0xF4
void ObtenerTiempoMaster();														//C:0xA5	F:0xF5    P:0xB1
void ObtenerReferenciaTiempo(unsigned short referencia);						//C:0xA6	F:0xF6
void SetRelojLocal(unsigned char* tramaTiempo);


int main(int argc, char *argv[]) {

	//printf("Iniciando...\n");
  
	//Inicializa las variables:
	i = 0;
	x = 0;
	fuenteTiempo = atoi(argv[1]);
	
	errorSinc = 0;
	
	//Configuracion principal:
	ConfiguracionPrincipal();
	
	//Obtencion de fuente de reloj:
	if (fuenteTiempo!=0){
		ObtenerReferenciaTiempo(fuenteTiempo);
	} else {
		EnviarTiempoLocal();
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
	
	switch (funcionSPI){                                                                     
          case 0xB1:
		       //Respuesta de la sincronizacion:
			   if (subFuncionSPI==0xD1){
			       ObtenerTiempoMaster(); 
			   }
			   //Tiempo del nodo:
			   if (subFuncionSPI==0xD2){
				   
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

//C:0xA4	F:0xF4
void EnviarTiempoLocal(){
	
	//Obtiene la hora y la fecha del sistema:
	printf("Enviando hora local...\n");
	time_t t;
	struct tm *tm;
	t=time(NULL);
	tm=localtime(&t);
	
	tiempoLocal[0] = tm->tm_year-100;											//Anio (contado desde 1900)
	tiempoLocal[1] = tm->tm_mon+1;												//Mes desde Enero (0-11)
	tiempoLocal[2] = tm->tm_mday;												//Dia del mes (0-31)
	tiempoLocal[3] = tm->tm_hour;												//Hora
	tiempoLocal[4] = tm->tm_min;												//Minuto
	tiempoLocal[5] = tm->tm_sec;												//Segundo 
		
	printf("%0.2d/",tiempoLocal[0]);		//aa
	printf("%0.2d/",tiempoLocal[1]);		//MM
	printf("%0.2d ",tiempoLocal[2]);		//dd
	printf("%0.2d:",tiempoLocal[3]);		//hh
	printf("%0.2d:",tiempoLocal[4]);		//mm
	printf("%0.2d\n",tiempoLocal[5]);		//ss
		
	bcm2835_spi_transfer(0xA4);                                                 //Envia el delimitador de inicio de trama
    bcm2835_delayMicroseconds(TIEMPO_SPI); 
	for (i=0;i<6;i++){
        bcm2835_spi_transfer(tiempoLocal[i]);							        //Envia los 6 datos de la trama tiempoLocal al dsPIC
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
	bcm2835_spi_transfer(0xF4);                                                 //Envia el delimitador de final de trama
    bcm2835_delayMicroseconds(TIEMPO_SPI);
	
	tiempoInicial = (tiempoLocal[3]*3600)+(tiempoLocal[4]*60)+tiempoLocal[5];
	banPrueba = 1;

}

//C:0xA5	F:0xF5 
void ObtenerTiempoMaster(){
	
	printf("Hora dsPIC: ");	
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
	
	switch (fuenteTiempoPic){
			case 0: 
					printf("RPi ");
					break;
			case 1:
					printf("GPS ");
					break;
			case 2:
					printf("RTC ");
					break;			
			default:
					errorSinc = fuenteTiempoPic;
					printf("E%d ", errorSinc);
					break;
	}
		
	printf("%0.2d/",tiempoPIC[0]);		//aa
	printf("%0.2d/",tiempoPIC[1]);		//MM
	printf("%0.2d ",tiempoPIC[2]);		//dd
	printf("%0.2d:",tiempoPIC[3]);		//hh
	printf("%0.2d:",tiempoPIC[4]);		//mm
	printf("%0.2d\n",tiempoPIC[5]);		//ss
	
	if (errorSinc!=0){
		switch (errorSinc){
				case 5: 
						printf("**Error 5: Problemas al recuperar la trama GPRMC del GPS\n");
						break;
				case 6:
						printf("**Error 6: La hora del GPS es invalida\n");
						break;
				case 7:
						printf("**Error 7: El GPS tarda en responder\n");
						break;			
		}
	}
		
	//Configura el tiempo local si se escogio la opcion GPS:
	if (fuenteTiempoPic==1){
		SetRelojLocal(tiempoPIC);		
	}

	exit (-1);
	
}

//C:0xA6	F:0xF6
void ObtenerReferenciaTiempo(unsigned short referencia){ 
	//referencia = 1 -> GPS
	//referencia = 2 -> RTC
	if (referencia==1){
		printf("Obteniendo hora del GPS...\n");	
	} else {
		printf("Obteniendo hora del RTC...\n");	
	}
	
	bcm2835_spi_transfer(0xA6);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(referencia);								
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	bcm2835_spi_transfer(0xF6);
	bcm2835_delayMicroseconds(TIEMPO_SPI);
}
//**************************************************************************************************************************************

//**************************************************************************************************************************************
//Procesos locales:

void SetRelojLocal(unsigned char* tramaTiempo){
	
	printf("Sincronizando hora local...\n");
	char datePIC[22];
	char comando[40];	
	//Configura el reloj interno de la RPi con la hora recuperada del PIC:
	strcpy(comando, "sudo date --set ");	//strcpy( <variable_destino>, <cadena_fuente> )
	//Ejemplo: '2019-09-13 17:45:00':
	datePIC[0] = 0x27;						//'
	datePIC[1] = '2';
	datePIC[2] = '0';
	datePIC[3] = (tramaTiempo[0]/10)+48;		//aa: (19/10)+48 = 49 = '1'
	datePIC[4] = (tramaTiempo[0]%10)+48;		//    (19%10)+48 = 57 = '9'
	datePIC[5] = '-';	
	datePIC[6] = (tramaTiempo[1]/10)+48;		//MM
	datePIC[7] = (tramaTiempo[1]%10)+48;
	datePIC[8] = '-';
	datePIC[9] = (tramaTiempo[2]/10)+48;		//dd
	datePIC[10] = (tramaTiempo[2]%10)+48;
	datePIC[11] = ' ';
	datePIC[12] = (tramaTiempo[3]/10)+48;		//hh
	datePIC[13] = (tramaTiempo[3]%10)+48;
	datePIC[14] = ':';
	datePIC[15] = (tramaTiempo[4]/10)+48;		//mm
	datePIC[16] = (tramaTiempo[4]%10)+48;
	datePIC[17] = ':';
	datePIC[18] = (tramaTiempo[5]/10)+48;		//ss
	datePIC[19] = (tramaTiempo[5]%10)+48;
	datePIC[20] = 0x27;
	datePIC[21] = '\0';
	
	strcat(comando, datePIC);
	
	system(comando);
	system("date");
	
}

//**************************************************************************************************************************************

//Fuenrtes de reloj: 
//0->Red, 1->GPS, 2->RTC
//Configurar reloj: sudo date --set '2020-09-08 16:10:00'



