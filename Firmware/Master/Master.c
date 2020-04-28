/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz, email: miltonrodrigomunoz@gmail.com, github: https://github.com/Rodrig087/SaludEstructuralCS.git
Fecha de creacion: 16/01/2020
Configuracion: dsPIC33EP256MC202, XT=80MHz
---------------------------------------------------------------------------------------------------------------------------*/

/////////////////////// /// Formato de la trama de datos //////////////////////////
//|  Cabecera  |                        PDU                        |      Fin     |
//|   1 byte   |   1 byte  |  1 byte  |  1 byte  |     n bytes     |    2 bytes   |
//|    0x3A    | Dirección |  #Datos  | Función  |      DataN      |  0Dh  |  0Ah |


////////////////////////////////////////////////////         Librerias         /////////////////////////////////////////////////////////////

#include <TIEMPO_RTC.c>
#include <TIEMPO_GPS.c>
#include <TIEMPO_RPI.c>
#include <ADXL355_SPI.c>

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////// Declaracion de variables //////////////////////////////////////////////////////////////

//Variables y constantes para la peticion y respuesta de datos
sbit RP1 at LATA4_bit;                                                          //Definicion del pin P1
sbit RP1_Direction at TRISA4_bit;
sbit MSRS485 at LATB11_bit;                                                     //Definicion del pin MS RS485
sbit MSRS485_Direction at TRISB11_bit;
//Pines de interrupcion para manejar los nodos:
sbit INT_SINC at LATA1_bit;                                                     //Comparte con el pin TEST
sbit INT_SINC_Direction at TRISA1_bit;
sbit INT_SINC1 at LATA0_bit;
sbit INT_SINC1_Direction at TRISA0_bit;
sbit INT_SINC2 at LATA3_bit;
sbit INT_SINC2_Direction at TRISA3_bit;
sbit INT_SINC3 at LATB10_bit;
sbit INT_SINC3_Direction at TRISB10_bit;
sbit INT_SINC4 at LATB12_bit;
sbit INT_SINC4_Direction at TRISB12_bit;

unsigned char tramaGPS[70];
unsigned char datosGPS[13];
unsigned short tiempo[6];                                                       //Vector de datos de tiempo del sistema
unsigned short tiempoRPI[6];                                                    //Vector para recuperar el tiempo enviado desde la RPi
unsigned char datosLeidos[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
unsigned char datosFIFO[243];                                                   //Vector para almacenar 27 muestras de 3 ejes del vector FIFO
unsigned short numFIFO, numSetsFIFO;                                            //Variablea para almacenar el numero de muestras y sets recuperados del buffer FIFO
unsigned short contTimer1;
unsigned char tramaCompleta[2506];                                              //Vector para almacenar 10 vectores datosFIFO, 250 cabeceras de muestras y el vector tiempo
unsigned char tramaSalida[2506];                                                //Variable para contar el numero de veces que entra a la interrupcion por Timer 1
unsigned char tramaPrueba[10];                                                  //Trama de 10 elementos para probar la comunicacion RS485

unsigned int i, x, y, i_gps, j;
unsigned short buffer;
unsigned short contMuestras;
unsigned short contCiclos;
unsigned int contFIFO;
short tasaMuestreo;
short numTMR1;

unsigned short banUTI, banUTF, banUTC;                                                  //Banderas de control de la trama UART
unsigned short banLec, banEsc, banCiclo, banInicio, banSetReloj, banSetGPS;
unsigned short banMuestrear, banLeer, banConf;
unsigned short banOperacion, tipoOperacion;
unsigned short banCheck;

unsigned char byteGPS, banTIGPS, banTFGPS, banTCGPS;
unsigned short fuenteReloj;
unsigned long horaSistema, fechaSistema;

unsigned char byteUART2;
unsigned char tramaCabeceraUART[4];
unsigned char tramaPyloadUART[2506];
unsigned int i_uart;
unsigned int numDatosPyload;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void Muestrear();
void InterrupcionP1();
void EnviarTramaUART(unsigned short puertoUART, unsigned short direccion, unsigned short numDatos, unsigned short funcion, unsigned char *payload);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////      Main      ////////////////////////////////////////////////////////////////
void main() {

     ConfiguracionPrincipal();
     DS3234_init();
     //GPS_init(1,1);

     //Banderas de control de la trama UART:
     banOperacion = 0;
     tipoOperacion = 0;
     
     banUTI = 0;
     banUTF = 0;
     banUTC = 0;

     banLec = 0;
     banEsc = 0;
     banCiclo = 0;
     banSetReloj = 0;
     banSetGPS = 0;
     banTIGPS = 0;
     banTFGPS = 0;
     banTCGPS = 0;
     fuenteReloj = 0;

     banMuestrear = 0;                                                          //Inicia el programa con esta bandera en bajo para permitir que la RPi envie la peticion de inicio de muestreo
     banInicio = 0;                                                             //Bandera de inicio de muestreo
     banLeer = 0;
     banConf = 0;

     banCheck = 0;

     i = 0;
     x = 0;
     y = 0;
     i_gps = 0;
     horaSistema = 0;
     i_uart = 0;
     numDatosPyload = 0;

     contMuestras = 0;
     contCiclos = 0;
     contFIFO = 0;
     numFIFO = 0;
     numSetsFIFO = 0;
     contTimer1 = 0;

     byteGPS = 0;

     RP1 = 0;
     INT_SINC = 1;                                                              //Enciende el pin TEST
     INT_SINC1 = 0;                                                             //Inicializa los pines de sincronizacion en 0
     INT_SINC2 = 0;
     INT_SINC3 = 0;
     INT_SINC4 = 0;

     MSRS485 = 0;                                                               //Establece el Max485 en modo de lectura;
     
     SPI1BUF = 0x00;

     while(1){

     }

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////// Funciones ////////////////////////////////////////////////////////////////

//*****************************************************************************************************************************************
// Funcion para realizar la configuracion principal
void ConfiguracionPrincipal(){
     
     //configuracion del oscilador                                              //FPLLO = FIN*(M/(N1+N2)) = 80.017MHz
     CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
     CLKDIVbits.PLLPOST = 0;                                                    //N2=2
     CLKDIVbits.PLLPRE = 5;                                                     //N1=7
     PLLFBDbits.PLLDIV = 150;                                                   //M=152
     
     //Configuracion de puertos
     ANSELA = 0;                                                                //Configura PORTA como digital     *
     ANSELB = 0;                                                                //Configura PORTB como digital     *
     
     TRISA0_bit = 0;
     TRISA1_bit = 0;
     TRISA2_bit = 0;
     TRISA3_bit = 0;
     TRISA4_bit = 0;
     TRISB4_bit = 0;
     TRISB10_bit = 0;
     TRISB11_bit = 0;
     TRISB12_bit = 0;
     
     TRISB10_bit = 1;                                                           //Configura el pin B10 como entrada *
     TRISB13_bit = 1;                                                           //Configura el pin B13 como entrada *
     TRISB14_bit = 1;
     //TRISB15_bit = 1;                                                           //Configura el pin B15 como entrada *

     INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales *
     /*
    //Configuracion del puerto UART1
     RPINR18bits.U1RXR = 0x22;                                                  //Configura el pin RB2/RPI34 como Rx1
     RPOR0bits.RP35R = 0x01;                                                    //Configura el Tx1 en el pin RB3/RP35
     UART1_Init(9600);                                                        //Inicializa el UART1 con una velocidad de 115200 baudios
     U1RXIE_bit = 0;                                                            //Desabilita la interrupcion por UART1 RX
     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
     IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
     U1STAbits.URXISEL = 0x00;
     */
     //Configuracion del puerto UART2
     RPINR19bits.U2RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx2
     RPOR1bits.RP36R = 0x03;                                                    //Configura el Tx2 en el pin RB4/RP36
     UART2_Init_Advanced(2000000, 2, 1, 1);                                     //Inicializa el UART2 con una velocidad de 2Mbps
     U2RXIE_bit = 1;                                                            //Desabilita la interrupcion por UART2 RX
     U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
     IPC7bits.U2RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
     U2STAbits.URXISEL = 0x00;

     //Configuracion del puerto SPI1 en modo Esclavo
     SPI1STAT.SPIEN = 1;                                                        //Habilita el SPI1 *
     SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
     SPI1IE_bit = 1;                                                            //Habilita la interrupcion por SPI1  *
     SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
     IPC2bits.SPI1IP = 0x03;                                                    //Prioridad de la interrupcion SPI1
     
     //Configuracion del puerto SPI2 en modo Master
     RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
     RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
     RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
     SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
     SPI2_Init();                                                               //Inicializa el modulo SPI2
     CS_DS3234 = 1;                                                             //Pone en alto el CS del RTC

     //Configuracion de la interrupcion externa INT1
     RPINR0 = 0x2E00;                                                           //Asigna INT1 al RB14/RPI46
     INT1IE_bit = 0;                                                            //Desabilita la interrupcion externa INT1
     INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
     IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1

     Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Funcion para realizar la interrupcion en la RPi
 void InterrupcionP1(unsigned short operacion){
     //Si se ejecuta una operacion de tiempo, habilita la interrupcion INT1 para incrementar la hora del sistema con cada pulso PPS
     if (operacion==0xB2){
        if (INT1IE_bit==0){
           INT1IE_bit = 1;
        }
     }
     banOperacion = 0;                                                          //Encera la bandera para permitir una nueva peticion de operacion
     tipoOperacion = operacion;                                                 //Carga en la variable el tipo de operacion requerido
     //Genera el pulso P1 para producir la interrupcion externa en la RPi
     RP1 = 1;
     Delay_us(20);
     RP1 = 0;
}
//*****************************************************************************************************************************************

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////// Interrupciones /////////////////////////////////////////////////////////////

//*****************************************************************************************************************************************
//Interrupcion SPI1
void spi_1() org  IVT_ADDR_SPI1INTERRUPT {

     SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI
     buffer = SPI1BUF;                                                          //Guarda el contenido del bufeer (lectura)

     //************************************************************************************************************************************
     //Rutina para enviar la peticion de operacion a la RPi  (C:0xA0   F:0xF0)
     if ((banOperacion==0)&&(buffer==0xA0)) {
        banOperacion = 1;                                                       //Activa la bandera para enviar el tipo de operacion requerido a la RPi
        SPI1BUF = tipoOperacion;                                                //Carga en el buffer el tipo de operacion requerido
     }
     if ((banOperacion==1)&&(buffer==0xF0)){
        banOperacion = 0;                                                       //Limpia la bandera
        tipoOperacion = 0;                                                      //Limpia la variable de tipo de operacion
     }
     //************************************************************************************************************************************
     
     //************************************************************************************************************************************
     //Rutinas de control del acelerometro:
     
     //Rutina de lectura de los datos del acelerometro (C:0xA3   F:0xF3):
     if ((banLec==1)&&(buffer==0xA3)){                                          //Verifica si la bandera de inicio de trama esta activa
        banLec = 2;                                                             //Activa la bandera de lectura
        i = 0;
        SPI1BUF = tramaCompleta[i];                                             //**Duda
     }
     if ((banLec==2)&&(buffer!=0xF3)){
        SPI1BUF = tramaCompleta[i];
        i++;
     }
     if ((banLec==2)&&(buffer==0xF3)){                                          //Si detecta el delimitador de final de trama:
        banLec = 0;                                                             //Limpia la bandera de lectura                        ****AQUI Me QUEDE
        SPI1BUF = 0xFF;
     }
     //************************************************************************************************************************************

     //************************************************************************************************************************************
     //Rutinas de manejo de tiempo:
     
     //Rutina para obtener la hora de la RPi (C:0xA4   F:0xF4):
     if ((banSetReloj==0)&&(buffer==0xA4)){
         banEsc = 1;
         j = 0;
     }
     if ((banEsc==1)&&(buffer!=0xA4)&&(buffer!=0xF4)){
        tiempoRPI[j] = buffer;
        j++;
     }
     if ((banEsc==1)&&(buffer==0xF4)){
        horaSistema = RecuperarHoraRPI(tiempoRPI);                              //Recupera la hora de la RPi
        fechaSistema = RecuperarFechaRPI(tiempoRPI);                            //Recupera la fecha de la RPi
        //**Esta fallando de nuevo el chip DS3234
        //DS3234_setDate(horaSistema, fechaSistema);                              //Configura la hora en el RTC
        //horaSistema = RecuperarHoraRTC();                                       //Recupera la hora del RTC
        //fechaSistema = RecuperarFechaRTC();                                     //Recupera la fecha del RTC
        AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
        banEsc = 0;
        banSetReloj = 1;
        InterrupcionP1(0XB2);                                                   //Envia la hora local a la RPi
     }

     //Rutina para enviar la hora local a la RPi (C:0xA5   F:0xF5):
     if ((banSetReloj==1)&&(buffer==0xA5)){
        banSetReloj = 2;
        j = 0;
        SPI1BUF = fuenteReloj;                                                  //Envia el indicador de fuente de reloj (0:RTC, 1:GPS)
     }
     if ((banSetReloj==2)&&(buffer!=0xA5)&&(buffer!=0xF5)){
        SPI1BUF = tiempo[j];
        j++;
     }
     if ((banSetReloj==2)&&(buffer==0xF5)){                                     //Si detecta el delimitador de final de trama:
        banSetReloj = 0;                                                        //Limpia la bandera de lectura
        SPI1BUF = 0xFF;
     }

     //Rutina para obtener la hora del GPS(C:0xA6   F:0xF6):
     if ((banSetReloj==0)&&(buffer==0xA6)){
        //ConfigurarGPS(confGPS[0],confGPS[1]);                                   //Configura el GPS (Configurar,NMA)
        GPS_init(1,1);
        banTIGPS = 0;                                                           //Limpia la bandera de inicio de trama  del GPS
        banTCGPS = 0;                                                           //Limpia la bandera de trama completa
        i_gps = 0;                                                              //Limpia el subindice de la trama GPS
        //Habilita interrupcion por UART1Rx si esta desabilitada:
        if (U1RXIE_bit==0){
           U1RXIE_bit = 1;
        }

     }

     //Rutina para obtener la hora del RTC (C:0xA7   F:0xF7):
     if ((banSetReloj==0)&&(buffer==0xA7)){
        horaSistema = RecuperarHoraRTC();                                       //Recupera la hora del RTC
        fechaSistema = RecuperarFechaRTC();                                     //Recupera la fecha del RTC
        AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
        fuenteReloj = 0;
        banSetReloj = 1;
        InterrupcionP1(0xB2);                                                   //Envia la hora local a la RPi
     }
     //************************************************************************************************************************************
     
     //************************************************************************************************************************************
     //Rutinas de testeo:
     
     //Rutina para testeo de la comunicacion RS485 (C:0xA8   F:0xF8):
     if ((banCheck==0)&&(buffer==0xA8)){
        //InterrupcionP1(0xB3);                                                   //Envia una solicitud de prueba
        banCheck = 1;
        //**Aqui debo incluir la rutina de peticion de la trama de prueba al nodo por medio de RS485
        /*for (x=0;x<10;x++){
            tramaPrueba[x] = x;
        }*/
     }
     
     //Rutina para enviar la trama de prueba (C:0xA9   F:0xF9):
     if ((banCheck==1)&&(buffer==0xA9)){
        j = 0;
        SPI1BUF = tramaPrueba[j];
        j++;
     }
     if ((banCheck==1)&&(buffer!=0xA9)&&(buffer!=0xF9)){
        SPI1BUF = tramaPrueba[j];
        j++;
     }
     if ((banCheck==1)&&(buffer==0xF9)){
        banCheck = 0;
        //limpia la trama de prueba
        /*for (x=0;x<10;x++){
            tramaPrueba[x] = 0;
        }*/
     }
     
     //************************************************************************************************************************************
     
}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Interrupcion INT1
void int_1() org IVT_ADDR_INT1INTERRUPT {
     
     INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
     //U2RXIE_bit = 1;                                                            //Activa interrupcion U2
     
     horaSistema++;                                                             //Incrementa el reloj del sistema
     //INT_SINC = ~INT_SINC;                                                      //TEST
     
     //Genera el pulso de interrupcion en el nodo:
     INT_SINC4 = 1;
     Delay_us(20);
     INT_SINC4 = 0;

     if (horaSistema==86400){                                                   //(24*3600)+(0*60)+(0) = 86400
        horaSistema = 0;                                                        //Reinicia el reloj al llegar a las 24:00:00 horas
     }
     if (banInicio==1){
        //Muestrear();
        //Aqui se generan los pulsos para iniciar el muestreo en los nodos
     }
     
}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Interrupcion UART1
void urx_1() org  IVT_ADDR_U1RXINTERRUPT {

     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART

     byteGPS = U1RXREG;                                                         //Lee el byte de la trama enviada por el GPS
     OERR_bit = 0;                                                              //Limpia este bit para limpiar el FIFO UART

    if (banTIGPS==0){
        if ((byteGPS==0x24)&&(i_gps==0)){                                       //Verifica si el primer byte recibido es el simbolo "$" que indica el inicio de una trama GPS
           banTIGPS = 1;                                                        //Activa la bandera de inicio de trama
        } else {
           //Recupera la hora del RTC:
           horaSistema = RecuperarHoraRTC();                                    //Recupera la hora del RTC
           fechaSistema = RecuperarFechaRTC();                                  //Recupera la fecha del RTC
           AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);             //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del RTC
           //fuenteReloj = 0;
           fuenteReloj = 2;                                                     //Se queda aqui
           banSetReloj = 1;                                                     //Activa la bandera para hacer uso de la hora GPS
           InterrupcionP1(0xB2);                                                //Envia la hora local a la RPi
           U1RXIE_bit = 0;
        }
     }

     if (banTIGPS==1){
        if (byteGPS!=0x2A){                                                     //0x2A = "*"
           tramaGPS[i_gps] = byteGPS;                                           //LLena la tramaGPS hasta recibir el ultimo simbolo ("*") de la trama GPS
           banTFGPS = 0;                                                        //Limpia la bandera de final de trama
           if (i_gps<70){
              i_gps++;                                                          //Incrementa el valor del subindice mientras sea menor a 70
           }
           if ((i_gps>1)&&(tramaGPS[1]!=0x47)){                                 //Verifica si el segundo elemento guardado es diferente de G
              i_gps = 0;                                                        //Limpia el subindice para almacenar la trama desde el principio
              banTIGPS = 0;                                                     //Limpia la bandera de inicio de trama
              banTCGPS = 0;                                                     //Limpia la bandera de trama completa
           }
        } else {
           tramaGPS[i_gps] = byteGPS;
           banTIGPS = 2;                                                        //Cambia el estado de la bandera de inicio de trama para no permitir que se almacene mas datos en la trama
           banTCGPS = 1;                                                        //Activa la bandera de trama completa
        }
     }


     if (banTCGPS==1){
        if (tramaGPS[18]==0x41) {                                               //Verifica que el caracter 18 sea igual a "A" lo cual comprueba que los datos son validos
           for (x=0;x<6;x++){
               datosGPS[x] = tramaGPS[7+x];                                     //Guarda los datos de hhmmss
           }

           for (x=50;x<60;x++){
               if (tramaGPS[x]==0x2C){                                          //Busca el simbolo "," a partir de la posicion 50
                   for (y=0;y<6;y++){
                       datosGPS[6+y] = tramaGPS[x+y+1];                         //Guarda los datos de DDMMAA en la trama datosGPS
                   }
               }
           }

           horaSistema = RecuperarHoraGPS(datosGPS);                            //Recupera la hora del GPS
           fechaSistema = RecuperarFechaGPS(datosGPS);                          //Recupera la fecha del GPS
           DS3234_setDate(horaSistema, fechaSistema);                           //Configura la hora en el RTC con la hora recuperada de la RPi
           AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);             //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del gps
           fuenteReloj = 1;                                                     //Indica que se obtuvo la hora del GPS
        } else {
           //Recupera la hora del RTC:
           horaSistema = RecuperarHoraRTC();                                    //Recupera la hora del RTC
           fechaSistema = RecuperarFechaRTC();                                  //Recupera la fecha del RTC
           AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);             //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del RTC
           fuenteReloj = 0;                                                     //Indica que se obtuvo la hora del RTC
        }

        banSetReloj = 1;                                                        //Activa la bandera para hacer uso de la hora
        InterrupcionP1(0xB2);                                                   //Envia la hora local a la RPi
        U1RXIE_bit = 0;
     }

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Interrupcion UART2
void urx_2() org  IVT_ADDR_U2RXINTERRUPT {

     //Recupera el byte recibido en cada interrupcion:
     U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART2
     byteUART2 = U2RXREG;                                                       //Lee el byte de la trama enviada por el GPS
     U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART2
     //OERR_bit = 0;
     //INT_SINC = ~INT_SINC;                                                  //TEST

     //Recupera el pyload de la trama UART:                                     //Aqui deberia entrar despues de recuperar la cabecera de trama
     if (banUTI==2){
        if (i_uart<numDatosPyload){
           tramaPyloadUART[i_uart] = byteUART2;
           i_uart++;
        } else {
           banUTI = 0;                                                          //Limpia la bandera de inicio de trama
           banUTC = 1;                                                          //Activa la bandera de trama completa
        }
     }

     //Recupera la cabecera de la trama UART:                                   //Aqui deberia entrar primero cada vez que se recibe una trama nueva
     if ((banUTI==0)&&(banUTC==0)){
        if (byteUART2==0x3A){                                                   //Verifica si el primer byte recibido sea la cabecera de trama
           banUTI = 1;
           i_uart = 0;
        }
     }
     if ((banUTI==1)&&(i_uart<4)){
        tramaCabeceraUART[i_uart] = byteUART2;                                  //Recupera los datos de cabecera de la trama UART
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
         INT_SINC = ~INT_SINC;                                                  //TEST
         for (x=0;x<10;x++) {
             tramaPrueba[x] = tramaPyloadUART[x];                               //LLeno la trama de prueba con el payload de la trama recuperada
         }
         InterrupcionP1(0xB3);                                                  //Envia una solicitud de prueba
         //FIN PRUEBA//
         
         banUTC = 0;
     }

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

