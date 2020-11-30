//Autor: Milton Muñoz
//Fecha: 28/11/2019
//Version OS: Windows 10
//Compilar W10: cmd /C cd $(CURRENT_DIRECTORY) & g++ -o $(NAME_PART).exe $(FILE_NAME) & pause 
//Compilar y ejecutar W10: cmd /C cd $(CURRENT_DIRECTORY) & g++ -o $(NAME_PART).exe $(FILE_NAME) & cmd /C start $(CURRENT_DIRECTORY)\$(NAME_PART).exe & pause
//Descripcion: 


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <conio.h>

#include <windows.h>

//Declaracion de constantes
#define P2 0
#define P1 2
#define NUM_MUESTRAS 249
#define TIEMPO_SPI 100

//Declaracion de variables
unsigned short i, k;
signed short j;
unsigned short contEje;
unsigned int x;
unsigned short banGuardar;
unsigned int contMuestras;
unsigned int numCiclos;
unsigned int tiempoInicial;
unsigned int factorDiezmado;
unsigned long periodoMuestreo;
unsigned char tramaInSPI[20];
unsigned char tramaDatos[16+(NUM_MUESTRAS*10)];
unsigned short axisData[3];
int axisValue;
double aceleracion, acelX, acelY, acelZ;
unsigned short tiempoSPI;
unsigned short tramaSize;
char rutaEntrada[35];
char rutaSalidaInfo[30];
char rutaSalidaX[30];
char rutaSalidaY[30];
char rutaSalidaZ[30];
char ext1[8];
char ext2[8];
char ext3[8];
char nombreArchivo[16];
char nombreArchivoEvento[16];
char nombreRed[8];
char nombreEstacion[8];
char ejeX[3];
char ejeY[3];
char ejeZ[3];

unsigned int duracionEvento;
unsigned int horaEvento;
unsigned int tiempoInicio;
unsigned int tiempoEvento;
unsigned int tiempoTranscurrido;
unsigned int fechaEventoTrama;
unsigned int horaEventoTrama;
unsigned int tiempoEventoTrama;
int tiempo;

unsigned short banExtraer;
unsigned char opcionExtraer;

FILE *lf;
FILE *fileInfo;
FILE *fileX;
FILE *fileY;
FILE *fileZ;


//Declaracion de funciones
void RecuperarVector();


int main(void) {
  
  i = 0;
  x = 0;
  j = 0;
  k = 0;
  
  factorDiezmado = 1;
  banGuardar = 0;
  periodoMuestreo = 4;
  
  axisValue = 0;
  aceleracion = 0.0;
  acelX = 0.0;
  acelY = 0.0;
  acelZ = 0.0;
  contMuestras = 0;
  tramaSize = 16+(NUM_MUESTRAS*10);			//16+(249*10) = 2506
  
  banExtraer = 0;
     
  RecuperarVector();
 
  return 0;
  
 }
 


void RecuperarVector() {
	
	char numPisoChar[2] = "\0";
	char numNodoChar[2] = "\0";
	short numPiso, numNodo;
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Ingreso de datos
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Pide como parametros el nombre del archivo binario (sin extencion) y la hora del evento (UTC):
	printf("Ingrese el nombre del archivo:\n");
	scanf("%s", nombreArchivo);
	printf("Ingrese la hora del evento (segundo del dia):\n");
	scanf("%d", &horaEvento);
	printf("Ingrese la duracion (segundos):\n");
	scanf("%d", &duracionEvento);
	//Extrae el numero del piso y del nodo a partir del nombre del archivo:
	numPisoChar[0] = nombreArchivo[2];
	numNodoChar[0] = nombreArchivo[5];
	numPiso = atoi(numPisoChar);
	numNodo = atoi(numNodoChar);
	printf("Piso:%0.2d Nodo:%0.2d", numPiso, numNodo);	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Abre el archivo binario
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Asigna espacio en la memoria para el nombre completo de la ruta:
	char *rutaEntrada = (char*)malloc(strlen(nombreArchivo)+5+20);
	//Asignacion del nombre de la ruta y la extencion a los array de caracteres:
	strcpy(rutaEntrada, "./Eventos/");
	strcpy(ext1, ".dat");
	strcat(rutaEntrada, nombreArchivo);
	strcat(rutaEntrada, ext1);
	//Abre el archivo binario de entrada y crea el archivo de texto de salida:
	lf = fopen (rutaEntrada, "rb");	
	free(rutaEntrada);
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Obtiene y calcula los tiempos de inicio del muestreo 
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	fread(tramaDatos, sizeof(char), tramaSize, lf);	
	tiempoInicio = (tramaDatos[tramaSize-3]*3600)+(tramaDatos[tramaSize-2]*60)+(tramaDatos[tramaSize-1]);
	//tiempoEvento = ((horaEvento/10000)*3600)+(((horaEvento%10000)/100)*60)+(horaEvento%100);
	tiempoEvento = horaEvento;
	tiempoTranscurrido = tiempoEvento - tiempoInicio;
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Comprueba el estado de la trama de datos para continuar con el proceso
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Se salta el numero de segundos que indique la variable tiempoTranscurrido:
	for (x=0;x<(tiempoTranscurrido);x++){
		fread(tramaDatos, sizeof(char), tramaSize, lf);								
	}
	//Calcula la fecha de la trama recuperada en formato aammdd:
	fechaEventoTrama = ((int)tramaDatos[tramaSize-6]*10000)+((int)tramaDatos[tramaSize-5]*100)+((int)tramaDatos[tramaSize-4]);
	//Calcula la hora de la trama recuperada en formato hhmmss:
	horaEventoTrama = ((int)tramaDatos[tramaSize-3]*10000)+((int)tramaDatos[tramaSize-2]*100)+((int)tramaDatos[tramaSize-1]);
	//Calcula el tiempo de la trama recuperada en formato segundos:
	tiempoEventoTrama = ((int)tramaDatos[tramaSize-3]*3600)+((int)tramaDatos[tramaSize-2]*60)+((int)tramaDatos[tramaSize-1]);
	//Verifica si el minuto del tiempo local es diferente del minuto del tiempo de la trama recuperada:
	if ((tiempoEventoTrama)==(tiempoEvento)){
		printf("\nTrama OK\n");
		banExtraer = 1;
	} else {
		printf("\nError: El tiempo de la trama no concuerda\n");
		//Imprime la hora y fecha recuperada de la trama de datos
		printf("| ");
		printf("%0.2d:", tramaDatos[tramaSize-3]);			//hh
		printf("%0.2d:", tramaDatos[tramaSize-2]);			//mm
		printf("%0.2d ", tramaDatos[tramaSize-1]);			//ss
		printf("%0.2d/", tramaDatos[tramaSize-6]);			//aa
		printf("%0.2d/", tramaDatos[tramaSize-5]);			//mm
		printf("%0.2d ", tramaDatos[tramaSize-4]);			//dd
		printf("|\n");	
		printf("Desea continuar? (s/n)\n");
		opcionExtraer=getch();
		//scanf("%c", &opcionExtraer);
		if (opcionExtraer=='s'){
			banExtraer = 1;	
		} 
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
	
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Inicia el proceso de extraccion y almacenamieto del evento 
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	if (banExtraer==1){
		
		printf("\nExtrayendo...\n");
		
		//Crea una carpeta con el nombre de la fecha del evento
		
		//Asigna espacio en la memoria para el nombre completo de la ruta:
		char *rutaSalidaInfo = (char*)malloc(strlen(nombreArchivo)+14+6);
		char *rutaSalidaX = (char*)malloc(strlen(nombreArchivo)+14+3+5);
		char *rutaSalidaY = (char*)malloc(strlen(nombreArchivo)+14+3+5);
		char *rutaSalidaZ = (char*)malloc(strlen(nombreArchivo)+14+3+5);
	
		//Asignacion del nombre de la ruta y la extencion a los array de caracteres:
		strcpy(rutaSalidaInfo, "./Hora Evento/");
		strcpy(rutaSalidaX, "./Hora Evento/");
		strcpy(rutaSalidaY, "./Hora Evento/");
		strcpy(rutaSalidaZ, "./Hora Evento/");
	
		strcpy(ejeX, "_X");
		strcpy(ejeY, "_Y");
		strcpy(ejeZ, "_Z");
		
		strcpy(ext2, ".txt");
		strcpy(ext3, ".INFO");
	
		//Realiza la concatenacion de array de caracteres:
		strcat(rutaSalidaInfo, nombreArchivo);
		//sprintf(nombreArchivoEvento, "%d%d", fechaEventoTrama,tiempoEventoTrama); 
		//strcat(rutaSalidaInfo, nombreArchivoEvento);
		strcat(rutaSalidaInfo, ext3);
		
		strcat(rutaSalidaX, nombreArchivo);
		//sprintf(nombreArchivoEvento, "%d%d", fechaEventoTrama,tiempoEventoTrama); 
		//strcat(rutaSalidaX, nombreArchivoEvento);
		strcat(rutaSalidaX, ext2);
		
		//Abre el archivo binario de entrada y crea el archivo de texto de salida:
		fileInfo = fopen (rutaSalidaInfo, "wb");
		fileX = fopen (rutaSalidaX, "wb");
		fileY = fopen (rutaSalidaY, "wb");
		fileZ = fopen (rutaSalidaZ, "wb");
		free(rutaSalidaInfo);
		free(rutaSalidaX);
		free(rutaSalidaY);
		free(rutaSalidaZ);
		
		//Escritura de datos en el archivo de informacion:
		fprintf(fileInfo, "Fecha(aammdd),Tiempo(hhmmss),Tiempo(segundos),Duracion(segundos),Periodo(ms)\n");
		fprintf(fileInfo, "%d,%d,%d,%d,%d\n", fechaEventoTrama, horaEventoTrama, tiempoEventoTrama, duracionEvento, periodoMuestreo);
		fclose (fileInfo);
					
		//Escritura de datos en los archivo de aceleracion:
		while (contMuestras<duracionEvento){											//Se almacena el numero de muestras que indique la variable duracionEvento
			fread(tramaDatos, sizeof(char), tramaSize, lf);				 				//Leo la cantidad establecida en la variable tramaSize del contenido del archivo lf y lo guardo en el vector tramaDatos 
			for (i=0;i<tramaSize-5;i++){								 				//Recorro las 2005 muestras del vector tramaDatos, omitiendo los 5 ultimos que corresponden a la fecha y hora del modulo gps
				if ((i%(10)==0)){						 								//Indica el inicio de un nuevo set de muestras
					banGuardar = 1;									 	 				//Cambia el estado de la bandera para permitir guardar la muestra 
					j = 0;
					contEje = 0;
				} else {
					if (banGuardar==1){
						if (j<2){
							axisData[j] = tramaDatos[i];				 				//axisData guarda la informacion de los 3 bytes correspondientes a un eje
						} else {
							axisData[2] = tramaDatos[i];				 				//Termina de llenar el vector axisData
							axisValue = ((axisData[0]<<12)&0xFF000)+((axisData[1]<<4)&0xFF0)+((axisData[2]>>4)&0xF);
							// Apply two complement:
							if (axisValue >= 0x80000) {
								axisValue = axisValue & 0x7FFFF;		 				//Se descarta el bit 20 que indica el signo (1=negativo)
								axisValue = -1*(((~axisValue)+1)& 0x7FFFF);
							}
							aceleracion = axisValue * (9.8/pow(2,18))*100;				//Aceleracion en gals (cm/seg2)
							tiempo = (tramaDatos[tramaSize-3]*3600)+(tramaDatos[tramaSize-2]*60)+(tramaDatos[tramaSize-1]);
							
							if (contEje==0){
								acelX = aceleracion;									//Guarda el valor de la aceleracion del eje x del nodo						
							}
							if (contEje==1){
								acelY = aceleracion;									//Guarda el valor de la aceleracion del eje y del nodo							
							}
							if (contEje==2){
								acelZ = aceleracion;									//Guarda el valor de la aceleracion del eje z del nodo											
								
								//Guarda los valores de aceleracion en el archivo con el orden y signo determinado por el nodo especifico:
								if (numPiso==0){
									if (numNodo==1||numNodo==2){
										//YnZnXn:
										fprintf(fileX, "%2.5f\t%2.5f\t%2.5f\n", acelY, acelZ, acelX);
									}
									if (numNodo==3){
										//ZnYn-Xn:
										fprintf(fileX, "%2.5f\t%2.5f\t%2.5f\n", acelZ, acelY, acelZ*-1);
									}
									if (numNodo==4){
										//-ZnYnXn:
										fprintf(fileX, "%2.5f\t%2.5f\t%2.5f\n", acelZ*-1, acelY, acelX);
									}
								} else {
									//Yn-ZnXn:
									fprintf(fileX, "%2.5f\t%2.5f\t%2.5f\n", acelY, acelZ*-1, acelX);
								}
								
								banGuardar = 0;							 				//Despues de terminar de guardar todas la muestras limpia la bandera banGuardar
							
							}	
							
							j = -1;
							contEje++;
						}
						j++;	
					}
				}
							
			}
			contMuestras++;
		}
		
		fclose (fileX);
		//fclose (fileY);
		//fclose (fileZ);
		
		////////////////////////////////////////////////////////////////////////////////////////////////////////////////
			
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	//Final 
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	fclose (lf);
	printf("\nTerminado\n");
	printf("Pulse cualquier tecla para continuar...");
	getch();
	////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}

