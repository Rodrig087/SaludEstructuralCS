//Compilar:
//gcc EnviarHoraRPi.c -o enviarhorapi -lbcm2835 -lwiringPi 

#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>
#include <bcm2835.h>
#include <time.h>
#include <string.h>
#include <unistd.h>


//Declaracion de constantes
#define P2 2
#define P1 0
#define MCLR 28
#define NUM_MUESTRAS 199
#define NUM_ELEMENTOS 2506
#define TIEMPO_SPI 10
#define NUM_CICLOS 1
#define FreqSPI 2000000


//Declaracion de variables
unsigned short i;
unsigned int x;
unsigned short buffer;
unsigned short banFile;
unsigned short banNewFile;
unsigned short numBytes;
unsigned short contMuestras;
unsigned char tiempoGPS[8];
unsigned char tiempoLocal[8];
unsigned char tramaDatos[NUM_ELEMENTOS];

FILE *fp;
char path[30];
char ext[8];
char nombreArchivo[16];
char comando[40];
char dateGPS[22];
//unsigned int timeNewFile[2] = {17, 30};											//Variable para configurar la hora a la que se desea generar un archivo nuevo	
unsigned int timeNewFile[2] = {0, 0};	
unsigned short banNewFile;

unsigned short contCiclos;
unsigned short contador;
pthread_t h1;

//Declaracion de funciones
int ConfiguracionPrincipal();
void MostrarTiempoRemoto();
void EnviarTiempoLocal();

int main(void) {

  printf("Iniciando...\n");
  
  //Inicializa las variables:
  i = 0;
  x = 0;
  contMuestras = 0;
  banFile = 0;
  banNewFile = 0;
  numBytes = 0;
  contCiclos = 0;
  contador = 0;  
  
  ConfiguracionPrincipal(); 
  digitalWrite (MCLR,  LOW); 
  delay (100) ;
  digitalWrite (MCLR, HIGH);
  sleep(2);
    
  while(1){	
	EnviarTiempoLocal();
	sleep(2);
  }
  
  bcm2835_spi_end();
  bcm2835_close();
 
  return 0;

 }


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
	bcm2835_spi_setClockDivider(BCM2835_SPI_CLOCK_DIVIDER_32);					//Clock divider RPi 2		
    bcm2835_spi_set_speed_hz(FreqSPI);
    bcm2835_spi_chipSelect(BCM2835_SPI_CS0);
    bcm2835_spi_setChipSelectPolarity(BCM2835_SPI_CS0, LOW);
		
	//Configuracion libreria WiringPi:
    wiringPiSetup();
    pinMode(P1, INPUT);
    pinMode(P2, INPUT);
	pinMode(MCLR, OUTPUT);
	wiringPiISR (P2, INT_EDGE_RISING, MostrarTiempoRemoto);
	digitalWrite (MCLR, HIGH);
	
	printf("Configuracion completa\n");
	
}


void MostrarTiempoRemoto(){
	printf("Hora dsPIC: ");	
	
	bcm2835_spi_transfer(0x00); 				                                //Recupero el ultimo byte remanente en el buffer del dsPIC 
	bcm2835_delayMicroseconds(TIEMPO_SPI);
	for (i=0;i<6;i++){
        buffer = bcm2835_spi_transfer(0x00);
        tiempoGPS[i] = buffer;													//Guarda la hora y fecha devuelta por el dsPIC
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
    bcm2835_spi_transfer(0xC1);                                                 //Envia el delimitador de final de trama
    bcm2835_delayMicroseconds(TIEMPO_SPI);
							
	printf("%0.2d/",tiempoGPS[0]);		//dd
	printf("%0.2d/",tiempoGPS[1]);		//MM
	printf("%0.2d ",tiempoGPS[2]);		//aa
	printf("%0.2d:",tiempoGPS[3]);		//hh
	printf("%0.2d:",tiempoGPS[4]);		//mm
	printf("%0.2d\n",tiempoGPS[5]);		//ss
	
	//Configura el reloj interno de la RPi con la hora recuperada del GPS:
	strcpy(comando, "sudo date --set ");	//strcpy( <variable_destino>, <cadena_fuente> )
	//'2019-09-13 17:45:00':
	dateGPS[0] = 0x27;						//'
	dateGPS[1] = '2';
	dateGPS[2] = '0';
	dateGPS[3] = (tiempoGPS[2]/10)+48;		//aa: (19/10)+48 = 49 = '1'
	dateGPS[4] = (tiempoGPS[2]%10)+48;		//    (19%10)+48 = 57 = '9'
	dateGPS[5] = '-';	
	dateGPS[6] = (tiempoGPS[1]/10)+48;		//MM
	dateGPS[7] = (tiempoGPS[1]%10)+48;
	dateGPS[8] = '-';
	dateGPS[9] = (tiempoGPS[0]/10)+48;		//dd
	dateGPS[10] = (tiempoGPS[0]%10)+48;
	dateGPS[11] = ' ';
	dateGPS[12] = (tiempoGPS[3]/10)+48;		//hh
	dateGPS[13] = (tiempoGPS[3]%10)+48;
	dateGPS[14] = ':';
	dateGPS[15] = (tiempoGPS[4]/10)+48;		//mm
	dateGPS[16] = (tiempoGPS[4]%10)+48;
	dateGPS[17] = ':';
	dateGPS[18] = (tiempoGPS[5]/10)+48;		//ss
	dateGPS[19] = (tiempoGPS[5]%10)+48;
	dateGPS[20] = 0x27;
	dateGPS[21] = '\0';
	
	strcat(comando, dateGPS);
	
	system(comando);
	system("date");
		
}

void EnviarTiempoLocal(){
	
	//Obtiene la hora y la fecha del sistema:
	time_t t;
	struct tm *tm;
	t=time(NULL);
	tm=localtime(&t);
		
	tiempoLocal[0] = tm->tm_mday;												//Dia del mes (0-31)
	tiempoLocal[1] = tm->tm_mon+1;												//Mes desde Enero (0-11)
	tiempoLocal[2] = tm->tm_year-100;											//Anio (contado desde 1900)
	tiempoLocal[3] = tm->tm_hour;												//Hora
	tiempoLocal[4] = tm->tm_min;												//Minuto
	tiempoLocal[5] = tm->tm_sec;												//Segundo 
	
	printf("\n");
	for (i=0;i<6;i++){
		printf("%0.2d ",tiempoLocal[i]);	
	}
	printf("\n");	
	
	bcm2835_spi_transfer(0xC3);                                                 //Envia el delimitador de inicio de trama
    bcm2835_delayMicroseconds(TIEMPO_SPI); 
		
	for (i=0;i<6;i++){
        buffer = bcm2835_spi_transfer(tiempoLocal[i]);							//Envia los 6 datos de la trama tiempoLocal al dsPIC
        bcm2835_delayMicroseconds(TIEMPO_SPI);
    }
	
	bcm2835_spi_transfer(0xC4);                                                 //Envia el delimitador de final de trama
    bcm2835_delayMicroseconds(TIEMPO_SPI);
	
}


