/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz, email: miltonrodrigomunoz@gmail.com
Fecha de creacion: 16/01/2020
Configuracion: dsPIC33EP256MC202, XT=80MHz
---------------------------------------------------------------------------------------------------------------------------*/

////////////////////////////////////////////////////         Librerias         /////////////////////////////////////////////////////////////

#include <ADXL355_SPI.c>
#include <TIEMPO_RTC.c>
#include <RS485.c>

#include <spiSD.h>
#include <sdcard.h>
#include <stdbool.h>

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////// Declaracion de variables //////////////////////////////////////////////////////////////

//Variables y contantes para la peticion y respuesta de datos
struct sdflags sdflags;                                                         //Variable y estructura que se utiliza en el archivo sdcard.c

sbit TEST at LATA2_bit;                                                         //Definicion del pin TEST
sbit TEST_Direction at TRISA2_bit;
sbit CsADXL at LATA3_bit;                                                       //Definicion del pin CS del Acelerometro
sbit CsADXL_Direction at TRISA3_bit;

sbit sd_CS_lat at LATB0_bit;                                                    //ChipSelect SD
sbit sd_CS_tris at TRISB0_bit;
sbit sd_detect_port at LATA4_bit;                                               //PinDetection SD
sbit sd_detect_tris at TRISA4_bit;

unsigned char tramaGPS[70];
unsigned char datosGPS[13];
unsigned short tiempo[6];                                                       //Vector de datos de tiempo del sistema
unsigned short tiempoRPI[6];                                                    //Vector para recuperar el tiempo enviado desde la RPi
unsigned char datosLeidos[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
unsigned char datosFIFO[243];                                                   //Vector para almacenar 27 muestras de 3 ejes del vector FIFO
unsigned char tramaCompleta[2506];                                              //Vector para almacenar 10 vectores datosFIFO, 250 cabeceras de muestras y el vector tiempo
unsigned char tramaSalida[2506];
unsigned short numFIFO, numSetsFIFO;                                            //Variablea para almacenar el numero de muestras y sets recuperados del buffer FIFO
unsigned short contTimer1;                                                      //Variable para contar el numero de veces que entra a la interrupcion por Timer 1
unsigned char tramaPruebaRS485[10]= {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};   //Trama de 10 elementos para probar la comunicacion RS485

unsigned int i, x, y, i_gps, j;
unsigned short buffer;
unsigned short contMuestras;
unsigned short contCiclos;
unsigned int contFIFO;
short tasaMuestreo;
short numTMR1;

unsigned short banUTI, banUTC;                                                  //Banderas de control de trama inicio y completa
unsigned short banLec, banEsc, banCiclo, banInicio, banSetReloj, banSetGPS;
unsigned short banMuestrear, banLeer, banConf;

unsigned char byteUART, banTIGPS, banTFGPS, banTCGPS;
unsigned long horaSistema, fechaSistema;

unsigned char byteUART1;
unsigned char tramaCabeceraUART[4];
unsigned char tramaPyloadUART[2506];
unsigned int i_uart;
unsigned int numDatosPyload;

const unsigned int clusterSizeSD = 512;                                         //Tama�o del cluster de la SD de 512 bytes
unsigned int sectorSave = 99;                                                   //Sector de la SD donde se graba el ultimo sector que se escribio antes de apagar
unsigned long sectorSD = 100;                                                   //Comienza en el sector 100, para escribir en la SD
unsigned char cabeceraSD[6] = {255, 253, 251, 10, 0, 250};                      //Cabecera del bufferSD: | Cte1 | Cte2 | Ct3 | #Bytes/Muestra | MSB_fSample | LSB_fSample |
unsigned char bufferSD [clusterSizeSD];                                         //Buffer del tama�o del cluster, siempre se guarda este numero de datos en la SD
unsigned char contadorEjemploSD = 0;                                            //Este es un contador para el ejemplo
unsigned char resultSD;                                                         //Esta variable indica si la escritura en la SD se completo correctamente
//unsigned char temp;                                                             //**Cambiar el nombre. Es una variable temporal. Temp=0, significa que la lectura fue exitosa
unsigned char tramaCompletaEjemplo[2500];


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void Muestrear();
void GuardarBufferSD(unsigned char* bufferLleno, unsigned long sector);
void GuardarTramaSD();
void GuardarSectorSD(unsigned long sector);
void LeerSectorSD();
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////      Main      ////////////////////////////////////////////////////////////////
void main() {

     ConfiguracionPrincipal();

     tasaMuestreo = 1;                                                          //1=250Hz, 2=125Hz, 4=62.5Hz, 8=31.25Hz
     ADXL355_init(tasaMuestreo);                                                //Inicializa el modulo ADXL con la tasa de muestreo requerida:
     numTMR1 = (tasaMuestreo*10)-1;                                             //Calcula el numero de veces que tienen que desbordarse el TMR1 para cada tasa de muestreo

     banUTI = 0;
     banUTC = 0;

     banLec = 0;
     banEsc = 0;
     banCiclo = 0;
     banSetReloj = 0;
     banSetGPS = 0;
     banTIGPS = 0;
     banTFGPS = 0;
     banTCGPS = 0;

     banMuestrear = 0;                                                          //Inicia el programa con esta bandera en bajo para permitir que la RPi envie la peticion de inicio de muestreo
     banInicio = 0;                                                             //Bandera de inicio de muestreo
     banLeer = 0;
     banConf = 0;

     i = 0;
     x = 0;
     y = 0;
     i_gps = 0;
     i_uart = 0;
     horaSistema = 0;
     numDatosPyload = 0;

     contMuestras = 0;
     contCiclos = 0;
     contFIFO = 0;
     numFIFO = 0;
     numSetsFIFO = 0;
     contTimer1 = 0;

     byteUART = 0;

     MSRS485 = 0;                                                               //Estabkece el Max485 en modo lectura
     
     TEST = 0;
     
     SPI1BUF = 0x00;
     
     //datos de tiempo de prueba
     horaSistema = 62700;       //17:25:00
     fechaSistema = 60520;      //20/12/16

     //Comprueba si esta conectada la SD:
     while (1) {
           if (SD_Detect() == DETECTED) {
              //En el caso de que este conectada activa la bandera
              sdflags.detected = true;
              //TEST = 1;
              break;
           } else {
              // Caso contrario si no esta conectada la SD, coloca las banderas en false
              sdflags.detected = false;
              sdflags.init_ok = false;
              //TEST = 0;
           }
           Delay_ms(100);
     }

     //Inicializa la SD:
     if (sdflags.detected && !sdflags.init_ok) {
          if (SD_Init_Try(10) == SUCCESSFUL_INIT) {
              sdflags.init_ok = true;
              TEST = 1;
              INT1IE_bit = 1;                                                   //Habilita la interrupcion externa INT1
              //banInicio = 1;                                                    //Activa la bandera para permitir el muestreo
           } else {
              sdflags.init_ok = false;
              //TEST = 0;
           }
     }
     Delay_ms(2000);

     //Entra al bucle princial del programa:
     while(1){
     }

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////// Funciones ////////////////////////////////////////////////////////////////

//*****************************************************************************************************************************************
// Funcion para realizar la configuracion principal
void ConfiguracionPrincipal(){

     //configuracion del oscilador:                                             //FPLLO = FIN*(M/(N1+N2)) = 80.017MHz
     CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
     CLKDIVbits.PLLPOST = 0;                                                    //N2=2
     CLKDIVbits.PLLPRE = 5;                                                     //N1=7
     PLLFBDbits.PLLDIV = 150;                                                   //M=152

     //Configuracion de puertos:
     ANSELA = 0;                                                                //Configura PORTA como digital     *
     ANSELB = 0;                                                                //Configura PORTB como digital     *
     TEST_Direction = 0;                                                        //TEST
     CsADXL_Direction = 0;                                                      //CS ADXL
     sd_CS_tris = 0;                                                            //CS SD
     TRISB12_bit = 0;                                                           //MAX485 MS
     sd_detect_tris = 1;                                                        //Pin detection SD
     TRISB14_bit = 1;                                                           //Pin de interrupcion

     //Habilita las interrupciones globales:
     INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales

     //Configuracion del puerto UART1:
     RPINR18bits.U1RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx1
     RPOR1bits.RP36R = 0x01;                                                    //Configura el Tx1 en el pin RB4/RP36
     UART1_Init_Advanced(2000000, 2, 1, 1);                                     //Inicializa el UART1 con una velocidad de 2Mbps
     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
     IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
     U1STAbits.URXISEL = 0x00;

     //Configuracion del puerto SPI2 en modo Master:
     RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
     RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
     RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
     SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
     SPI2_Init();                                                               //Inicializa el modulo SPI2

     //Configuracion de la interrupcion externa INT1
     RPINR0 = 0x2E00;                                                           //Asigna INT1 al RB14/RPI46
     INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
     IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1

     //Configuracion del TMR1 con un tiempo de 100ms
     T1CON = 0x0020;
     T1CON.TON = 0;                                                             //Apaga el Timer1
     T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR1
     PR1 = 62500;                                                               //Car ga el preload para un tiempo de 100ms
     IPC0bits.T1IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR1
     
     //Habilitacion de interrupciones:
     U1RXIE_bit = 0;                                                            //Interrupcion por UART1 RX
     INT1IE_bit = 0;                                                            //Interrupcion externa INT1
     T1IE_bit = 1;                                                              //Interrupci�n de desbordamiento TMR1

     //Configuracion del acelerometro:
     ADXL355_write_byte(POWER_CTL, DRDY_OFF|STANDBY);                           //Coloco el ADXL en modo STANDBY para pausar las conversiones y limpiar el FIFO

     //Limpia las banderas de la SD:
     sdflags.detected = false;
     sdflags.init_ok = false;
     sdflags.saving = false;

     Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Funcion para relizar el muesteo
void Muestrear(){

     if (banCiclo==0){

         ADXL355_write_byte(POWER_CTL, DRDY_OFF|MEASURING);                     //Coloca el ADXL en modo medicion
         T1CON.TON = 1;                                                         //Enciende el Timer1

     } else if (banCiclo==1) {

         banCiclo = 2;                                                          //Limpia la bandera de ciclo completo

         tramaCompleta[0] = contCiclos;                                         //LLena el primer elemento de la tramaCompleta con el contador de ciclos
         numFIFO = ADXL355_read_byte(FIFO_ENTRIES);
         numSetsFIFO = (numFIFO)/3;                                             //Lee el numero de sets disponibles en el FIFO

         //Este bucle recupera tantos sets de mediciones del buffer FIFO como indique la variable anterior
         for (x=0;x<numSetsFIFO;x++){
             ADXL355_read_FIFO(datosLeidos);                                    //Lee una sola posicion del FIFO
             for (y=0;y<9;y++){
                 datosFIFO[y+(x*9)] = datosLeidos[y];                           //LLena la trama datosFIFO
             }
         }

         //Este bucle rellena la trama completa intercalando el numero de muestra correspondientes
         for (x=0;x<(numSetsFIFO*9);x++){
             if ((x==0)||(x%9==0)){
                tramaCompleta[contFIFO+contMuestras+x] = contMuestras;          //Funciona bien
                tramaCompleta[contFIFO+contMuestras+x+1] = datosFIFO[x];
                contMuestras++;
             } else {
                tramaCompleta[contFIFO+contMuestras+x] = datosFIFO[x];
             }
         }

         //LLena la trama tiempo con el valor del tiempo actual del sistema y luega rellena la tramaCompleta con los valores de esta trama
         AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
         for (x=0;x<6;x++){
             tramaCompleta[2500+x] = tiempo[x];
         }

         contMuestras = 0;                                                      //Limpia el contador de muestras
         contFIFO = 0;                                                          //Limpia el contador de FIFOs
         T1CON.TON = 1;                                                         //Enciende el Timer1

         banLec = 1;                                                            //Activa la bandera de lectura para enviar la trama
         
         //GuardarTramaSD();                                                      //Prueba

     }

     contCiclos++;                                                              //Incrementa el contador de ciclos

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Funcion para guardar el buffer de 512 datos en la SD
void GuardarBufferSD(unsigned char* bufferLleno, unsigned long sector){
     // Intenta escribir los datos en la SD como maximo 5 veces:
     for (x=0;x<5;x++){
         resultSD = SD_Write_Block(bufferLleno,sector);
         if (resultSD == DATA_ACCEPTED){
             TEST = ~TEST;
             break;
         }
         Delay_us(10);
     }
}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Funcion para guardar los datos de la trama de aceleracion en la SD
void GuardarTramaSD(){

        //DATOS DE PRUEBA:
        contadorEjemploSD = 0;
        for (x=0;x<2500;x++){
            tramaSalida[x] = contadorEjemploSD;
            contadorEjemploSD ++;
            if (contadorEjemploSD >= 255){
                contadorEjemploSD = 0;
            }
        }
        AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
        for (x=0;x<6;x++){
            tramaSalida[2500+x] = tiempo[x];
        }

        //**Informacion: [Cabecera + tiempo + datos aceleracion] = 2512 bytes = 5 sectores
        //Por lo tanto se graban 4 buffers completos y 1 un buffer con 464 bytes de aceleracion y 48 ceros
        
        //Agrega los datos de cabecera al buffer:
        for (x=0;x<6;x++){
            bufferSD[x] = cabeceraSD[x];
        }
        //Agrega los datos de tiempo al buffer:
        for (x=0;x<6;x++){
            bufferSD[6+x] = tiempo[x];
        }
        //Agrega los primeros 500 bytes de la trama de datos al buffer:
        for (x=0;x<500;x++){
            bufferSD[12+x] = tramaSalida[x];
        }
        //Guarda el buffer en la SD:
        GuardarBufferSD(bufferSD, sectorSD);
        //Aumenta el indice del sector:
        sectorSD++;

        //Guarda en la SD los bytes de la trama de datos desde la posicion 500 - 1011:
        for (x=0;x<512;x++){
            bufferSD[x] = tramaSalida[x+500];
        }
        GuardarBufferSD(bufferSD, sectorSD);
        sectorSD++;
        
        //Guarda en la SD los bytes de la trama de datos desde la posicion 1012 - 1523:
        for (x=0;x<512;x++){
            bufferSD[x] = tramaSalida[x+1012];
        }
        GuardarBufferSD(bufferSD, sectorSD);
        sectorSD++;
        
        //Guarda en la SD los bytes de la trama de datos desde la posicion 1524 - 2035:
        for (x=0;x<512;x++){
            bufferSD[x] = tramaSalida[x+1524];
        }
        GuardarBufferSD(bufferSD, sectorSD);
        sectorSD++;
        
        //Guarda en la SD los bytes de la trama de datos desde la posicion 2036 - 2499:
        for (x=0;x<512;x++){
            if (x<464){
               bufferSD[x] = tramaSalida[x+2036];
            } else {
               bufferSD[x] = 0;
            }
        }
        GuardarBufferSD(bufferSD, sectorSD);
        sectorSD++;

        //Guarda en la SD el ultimo sector donde se guardo la trama:
        GuardarSectorSD(sectorSD);
        
        //TEST = 0;                                                               //Apaga el TEST cuando termina de gurdar la trama
        
}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Funcion para guardar el ultimo sector que se escribio
void GuardarSectorSD(unsigned long sector){

     //Crea un buffer para pasarle a la funcion que graba la informacion en la SD por sectores
     //Es muy ineficiente pero no quiero manipular la libreria
     unsigned char bufferSectores[512];
     bufferSectores[0] = (sector>>24)&0xFF;                                     //MSB variable sector
     bufferSectores[1] = (sector>>16)&0xFF;
     bufferSectores[2] = (sector>>8)&0xFF;
     bufferSectores[3] = (sector)&0xFF;                                         //LSD variable sector
     for (x=4;x<512;x++){
         bufferSectores[x] = 0;                                                 //Rellena de ceros el resto del buffer
     }

     // Intenta escribir los datos en la SD como maximo 5 veces:
     for (x=0;x<5;x++){
         resultSD = SD_Write_Block(bufferSectores,sectorSave);
         if (resultSD == DATA_ACCEPTED){
             TEST = ~TEST;
             break;
         }
         Delay_us(10);
     }
     
}
//*****************************************************************************************************************************************

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////// Interrupciones /////////////////////////////////////////////////////////////

//*****************************************************************************************************************************************
//Interrupcion INT1
void int_1() org IVT_ADDR_INT1INTERRUPT {

     INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1

     TEST = ~TEST;
     horaSistema++;                                                             //Incrementa el reloj del sistema

     EnviarTramaRS485(1, 1, 10, 2, tramaPruebaRS485);                                //Envia la trama de prueba por RS485

     if (horaSistema==86400){                                                   //(24*3600)+(0*60)+(0) = 86400
        horaSistema = 0;                                                        //Reinicia el reloj al llegar a las 24:00:00 horas
     }
     
     GuardarTramaSD();                                                          //Prueba

     /*if (banInicio==1){
        Muestrear();
     }*/

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Interrupcion por desbordamiento del Timer1
void Timer1Int() org IVT_ADDR_T1INTERRUPT{

     T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer1

     numFIFO = ADXL355_read_byte(FIFO_ENTRIES); //75                            //Lee el numero de muestras disponibles en el FIFO
     numSetsFIFO = (numFIFO)/3;                 //25                            //Lee el numero de sets disponibles en el FIFO

     //Este bucle recupera tantos sets de mediciones del buffer FIFO como indique la variable anterior
     for (x=0;x<numSetsFIFO;x++){
         ADXL355_read_FIFO(datosLeidos);                                        //Lee una sola posicion del FIFO
         for (y=0;y<9;y++){
             datosFIFO[y+(x*9)] = datosLeidos[y];                               //LLena la trama datosFIFO
         }
     }

     //Este bucle rellena la trama completa intercalando el numero de muestra correspondientes
     for (x=0;x<(numSetsFIFO*9);x++){      //0-224
         if ((x==0)||(x%9==0)){
            tramaCompleta[contFIFO+contMuestras+x] = contMuestras;
            tramaCompleta[contFIFO+contMuestras+x+1] = datosFIFO[x];
            contMuestras++;
         } else {
            tramaCompleta[contFIFO+contMuestras+x] = datosFIFO[x];
         }
     }

     contFIFO = (contMuestras*9);                                               //Incrementa el contador de FIFOs

     contTimer1++;                                                              //Incrementa una unidad cada vez que entra a la interrupcion por Timer1

     if (contTimer1==numTMR1){                                                  //Verifica si se cumplio el numero de interrupciones por TMR1 para la tasa de muestreo seleccionada
        T1CON.TON = 0;                                                          //Apaga el Timer1
        banCiclo = 1;                                                           //Activa la bandera que indica que se completo un ciclo de medicion
        contTimer1 = 0;                                                         //Limpia el contador de interrupciones por Timer1
     }

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Interrupcion UART1
void urx_1() org  IVT_ADDR_U1RXINTERRUPT {

     //Recupera el byte recibido en cada interrupcion:
     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
     byteUART = U1RXREG;
     OERR_bit = 0;                                                              //Limpia este bit para limpiar el FIFO UART

     //Recupera el pyload de la trama UART:                                     //Aqui deberia entrar despues de recuperar la cabecera de trama
     if (banUTI==2){
        if (i_uart<numDatosPyload){
           tramaPyloadUART[i_uart] = byteUART;
           i_uart++;
        } else {
           banUTI = 0;                                                          //Limpia la bandera de inicio de trama
           banUTC = 1;                                                          //Activa la bandera de trama completa
        }
     }

     //Recupera la cabecera de la trama UART:                                   //Aqui deberia entrar primero cada vez que se recibe una trama nueva
     if ((banUTI==0)&&(banUTC==0)){
        if (byteUART==0x3A){                                                    //Verifica si el primer byte recibido sea la cabecera de trama
           banUTI = 1;
           i_uart = 0;
        }
     }
     if ((banUTI==1)&&(i_uart<4)){
        tramaCabeceraUART[i_uart] = byteUART;                                   //Recupera los datos de cabecera de la trama UART
        i_uart++;
     }
     if ((banUTI==1)&&(i_uart==4)){
        numDatosPyload = tramaCabeceraUART[2];
        banUTI = 2;
        i_uart = 0;
     }

     //Realiza el procesamiento de la informacion del  pyload:                  //Aqui se realiza cualquier accion con el pyload recuperado
     if (banUTC==1){

         //PRUEBA//
         for (x=0;x<6;x++) {
             tiempo[x] = tramaPyloadUART[x];                                    //LLeno la trama tiempo con el payload de la trama recuperada
             if (tiempo[x]<59){
                tiempo[x] = tiempo[x]+1;                                        //prueba para distinguir los datos
             }
         }
         banSetReloj=1;                                                         //Activa la bandera para enviar la hora a la RPI por SPI
         //EnviarTramaUART(1, 255, 6, 2, tiempo);
         //FIN PRUEBA//

         banUTC = 0;
     }

}
//*****************************************************************************************************************************************

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////