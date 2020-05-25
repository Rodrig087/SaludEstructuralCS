/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz, email: miltonrodrigomunoz@gmail.com, github: https://github.com/Rodrig087/SaludEstructuralCS.git
Fecha de creacion: 16/01/2020
Configuracion: dsPIC33EP256MC202, XT=80MHz
---------------------------------------------------------------------------------------------------------------------------*/


////////////////////////////////////////////////////         Librerias         /////////////////////////////////////////////////////////////

#include <TIEMPO_RTC.c>
#include <TIEMPO_GPS.c>
#include <TIEMPO_RPI.c>
#include <RS485.c>

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////// Declaracion de variables y costantes ///////////////////////////////////////////////////////

//Subindices:
unsigned int i, j, x, y;

//Definicion de pines:
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

//Constantes para el UART:
#define FP 80000000
#define BAUDRATE 115200
#define BRGVAL ((FP/BAUDRATE)/16)-1

//Variables para manejo del GPS:
unsigned int i_gps;
unsigned char byteGPS, banTIGPS, banTFGPS, banTCGPS;
unsigned short banSetGPS;
unsigned char tramaGPS[70];
unsigned char datosGPS[13];

//Variables para manejo del tiempo:
unsigned short tiempo[6];                                                       //Vector de datos de tiempo del sistema
unsigned short tiempoRPI[6];                                                    //Vector para recuperar el tiempo enviado desde la RPi
unsigned short banSetReloj;
unsigned short fuenteReloj;                                                     //Indica la fuente de reloj: 1 = GPS, 2 = RTC, 3 = RPi
unsigned long horaSistema, fechaSistema;

//Variables para la comunicacion SPI:
unsigned short bufferSPI;
unsigned short banLec, banEsc;
unsigned char tramaCompleta[2506];                                              //Vector para almacenar 10 vectores datosFIFO, 250 cabeceras de muestras y el vector tiempo
unsigned char tramaPrueba[10];                                                  //Trama de 10 elementos para probar la comunicacion RS485
unsigned short banInicio;
unsigned short banOperacion, tipoOperacion;
unsigned short banCheckRS485;

//Variables para manejo del RS485:
unsigned short banRSI, banRSC;                                                  //Banderas de control de inicio de trama y trama completa
unsigned char byteRS485;
unsigned int i_rs485;                                                           //Indice
unsigned char tramaCabeceraRS485[4];                                            //Vector para almacenar los datos de cabecera de la trama RS485: [0x3A, Direccion, Funcion, NumeroDatos]
unsigned char tramaPyloadRS485[512];                                            //Vector para almacenar el pyload de la trama RS485
unsigned short direccionRS485;                                                  //Varaible para la direccion del nodo. Broadcast = 255
unsigned short funcionRS485;                                                    //Funcion requerida: 0xF1 = Muestrear, 0xF2 = Actualizar tiempo, 0xF3 = Probar comunicacion
unsigned int numDatosRS485;                                                     //Numero de datos en el pyload de la trama RS485
unsigned char tramaPruebaRS485[10]= {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};   //Trama de 10 elementos para probar la comunicacion RS485


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void Muestrear();
void InterrupcionP1();
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////      Main      ////////////////////////////////////////////////////////////////
void main() {

     ConfiguracionPrincipal();
     //DS3234_init();
     //GPS_init(1,1);

     //Inicializacion de variables:
         
     //Subindices:
     i = 0;
     j = 0;
     x = 0;
     y = 0;
     
     //GPS:
     i_gps = 0;
     byteGPS = 0;
     banTIGPS = 0;
     banTFGPS = 0;
     banTCGPS = 0;
     banSetGPS = 0;
         
     //Tiempo:
     banSetReloj = 0;
     horaSistema = 0;
     fechaSistema = 0;
         
     //RS485:
     banRSI = 0;
     banRSC = 0;
     byteRS485 = 0;
     i_rs485 = 0;
     numDatosRS485 = 0;
     funcionRS485 = 0;
        
     //Puertos:
     RP1 = 0;
     INT_SINC = 1;                                                              //Enciende el pin TEST
     INT_SINC1 = 0;                                                             //Inicializa los pines de sincronizacion en 0
     INT_SINC2 = 0;
     INT_SINC3 = 0;
     INT_SINC4 = 0;

     MSRS485 = 0;                                                               //Establece el Max485 en modo de lectura;
     
     SPI1BUF = 0x00;

     while(1){
              EnviarTramaRS485(2, 255, 0xF3, 10, tramaPruebaRS485);
              Delay_ms(100);
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
     
     TRISA2_bit = 0;                                                            //RTC_CS
     INT_SINC_Direction = 0;                                                    //INT_SINC
     INT_SINC1_Direction = 0;                                                   //INT_SINC1
     INT_SINC2_Direction = 0;                                                   //INT_SINC2
     INT_SINC3_Direction = 0;                                                   //INT_SINC3
     INT_SINC4_Direction = 0;                                                   //INT_SINC4
     RP1_Direction = 0;                                                         //RP1
     MSRS485_Direction = 0;                                                     //MSRS485
     
     TRISB13_bit = 1;                                                           //SQW
     TRISB14_bit = 1;                                                           //PPS

     INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales *

    //Configuracion del puerto UART1
     RPINR18bits.U1RXR = 0x22;                                                  //Configura el pin RB2/RPI34 como Rx1
     RPOR0bits.RP35R = 0x01;                                                    //Configura el Tx1 en el pin RB3/RP35
     UART1_Init(9600);                                                          //Inicializa el UART1 con una velocidad de 9600 baudios
     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
     IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
     U1STAbits.URXISEL = 0x00;

     //Configuracion del puerto UART2
     RPINR19bits.U2RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx2
     RPOR1bits.RP36R = 0x03;                                                    //Configura el Tx2 en el pin RB4/RP36
     //UART2_Init(9600);
     UART2_Init_Advanced(2000000, _UART_8BIT_NOPARITY, _UART_ONE_STOPBIT, _UART_HI_SPEED);
     /*U2MODEbits.STSEL = 0;                                                      // 1-Stop bit
     U2MODEbits.PDSEL = 0;                                                      // No Parity, 8-Data bits
     U2MODEbits.ABAUD = 0;                                                      // Auto-Baud disabled
     U2MODEbits.BRGH = 0;                                                       // Standard-Speed mode
     U2BRG = BRGVAL;                                                            // Baud Rate setting for 9600
     */
     U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
     IPC7bits.U2RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
     U2STAbits.URXISEL = 0x00;

     //Configuracion del puerto SPI1 en modo Esclavo
     SPI1STAT.SPIEN = 1;                                                        //Habilita el SPI1 *
     SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
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
     RPINR0 = 0x2D00;                                                           //Asigna INT1 al RB13/RPI45 (SQW)
     //RPINR0 = 0x2E00;                                                           //Asigna INT1 al RB14/RPI46 (PPS)
     INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
     IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1
     
     //Habilitacion de interrupciones
     U1RXIE_bit = 0;                                                            //UART1 RX
     U2RXIE_bit = 1;                                                            //UART2 RX
     SPI1IE_bit = 0;                                                            //SPI1
     INT1IE_bit = 0;                                                            //INT1

     Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Funcion para realizar la interrupcion en la RPi
 void InterrupcionP1(unsigned short operacion){
     //Si se ejecuta una operacion de tiempo, habilita la interrupcion INT1 para incrementar la hora del sistema con cada pulso PPS y envia la hora local a los nodos:
     if (operacion==0xB2){
        if (INT1IE_bit==0){
           INT1IE_bit = 1;
        }
        //Envia la hora local a los nodos:
        EnviarTramaRS485(2, 255, 0xF2, 6, tiempo);
     }
     banOperacion = 0;                                                          //Encera la bandera para permitir una nueva peticion de operacion
     tipoOperacion = operacion;                                                 //Carga en la variable el tipo de operacion requerido
     //Genera el pulso P1 para producir la interrupcion externa en la RPi:
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
     bufferSPI = SPI1BUF;                                                       //Guarda el contenido del bufeer (lectura)

     //************************************************************************************************************************************
     //Rutina para enviar la peticion de operacion a la RPi  (C:0xA0   F:0xF0)
     if ((banOperacion==0)&&(bufferSPI==0xA0)) {
        banOperacion = 1;                                                       //Activa la bandera para enviar el tipo de operacion requerido a la RPi
        SPI1BUF = tipoOperacion;                                                //Carga en el buffer el tipo de operacion requerido
     }
     if ((banOperacion==1)&&(bufferSPI==0xF0)){
        banOperacion = 0;                                                       //Limpia la bandera
        tipoOperacion = 0;                                                      //Limpia la variable de tipo de operacion
     }
     //************************************************************************************************************************************
     
     //************************************************************************************************************************************
     //Rutinas de control del acelerometro:
     
     //Rutina de lectura de los datos del acelerometro (C:0xA3   F:0xF3):
     if ((banLec==1)&&(bufferSPI==0xA3)){                                       //Verifica si la bandera de inicio de trama esta activa
        banLec = 2;                                                             //Activa la bandera de lectura
        i = 0;
        SPI1BUF = tramaCompleta[i];                                             //**Aqui envio a la RPi la trama de aceleracion recuperada de los nodos
     }
     if ((banLec==2)&&(bufferSPI!=0xF3)){
        SPI1BUF = tramaCompleta[i];
        i++;
     }
     if ((banLec==2)&&(bufferSPI==0xF3)){                                          //Si detecta el delimitador de final de trama:
        banLec = 0;                                                             //Limpia la bandera de lectura                        ****AQUI Me QUEDE
        SPI1BUF = 0xFF;
     }
     //************************************************************************************************************************************

     //************************************************************************************************************************************
     //Rutinas de manejo de tiempo:
     
     //Rutina para obtener la hora de la RPi (C:0xA4   F:0xF4):
     if ((banSetReloj==0)&&(bufferSPI==0xA4)){
         banEsc = 1;
         j = 0;
     }
     if ((banEsc==1)&&(bufferSPI!=0xA4)&&(bufferSPI!=0xF4)){
        tiempoRPI[j] = bufferSPI;
        j++;
     }
     if ((banEsc==1)&&(bufferSPI==0xF4)){
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

     //Rutina para enviar la hora local a la RPi y a los nodos(C:0xA5   F:0xF5):
     if ((banSetReloj==1)&&(bufferSPI==0xA5)){
        banSetReloj = 2;
        j = 0;
        SPI1BUF = fuenteReloj;                                                  //Envia el indicador de fuente de reloj (0:RTC, 1:GPS)
     }
     if ((banSetReloj==2)&&(bufferSPI!=0xA5)&&(bufferSPI!=0xF5)){
        SPI1BUF = tiempo[j];
        j++;
     }
     if ((banSetReloj==2)&&(bufferSPI==0xF5)){                                     //Si detecta el delimitador de final de trama:
        banSetReloj = 0;                                                        //Limpia la bandera de lectura
        SPI1BUF = 0xFF;
     }

     //Rutina para obtener la hora del GPS(C:0xA6   F:0xF6):
     if ((banSetReloj==0)&&(bufferSPI==0xA6)){
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
     if ((banSetReloj==0)&&(bufferSPI==0xA7)){
        horaSistema = RecuperarHoraRTC();                                       //Recupera la hora del RTC
        fechaSistema = RecuperarFechaRTC();                                     //Recupera la fecha del RTC
        AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
        fuenteReloj = 0;
        banSetReloj = 1;
        InterrupcionP1(0xB2);                                                   //Envia la hora local a la RPi
     }
     //************************************************************************************************************************************
     
     //************************************************************************************************************************************
     //Rutinas de prueba de la comunicacion RS485:
     
     //Rutina para testeo de la comunicacion RS485 (C:0xA8   F:0xF8):
     if ((banCheckRS485==0)&&(bufferSPI==0xA8)){
        //InterrupcionP1(0xB3);                                                   //Envia una solicitud de prueba
        banCheckRS485 = 1;
        //**Aqui debo incluir la rutina de peticion de la trama de prueba al nodo por medio de RS485
        /*for (x=0;x<10;x++){
            tramaPrueba[x] = x;
        }*/
     }
     
     //Rutina para enviar la trama de prueba (C:0xA9   F:0xF9):
     if ((banCheckRS485==1)&&(bufferSPI==0xA9)){
        j = 0;
        SPI1BUF = tramaPrueba[j];
        j++;
     }
     if ((banCheckRS485==1)&&(bufferSPI!=0xA9)&&(bufferSPI!=0xF9)){
        SPI1BUF = tramaPrueba[j];
        j++;
     }
     if ((banCheckRS485==1)&&(bufferSPI==0xF9)){
        banCheckRS485 = 0;
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
     INT_SINC = ~INT_SINC;                                                      //TEST
     
     //Genera los pulsos de interrupcion en los nodos:
     //INT_SINC = 1;
     INT_SINC1 = 1;
     INT_SINC2 = 1;
     INT_SINC3 = 1;
     INT_SINC4 = 1;
     Delay_us(20);
     //INT_SINC = 0;
     INT_SINC1 = 0;
     INT_SINC2 = 0;
     INT_SINC3 = 0;
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
/*
//*****************************************************************************************************************************************
//Interrupcion UART1
void urx_1() org  IVT_ADDR_U1RXINTERRUPT {

     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
     INT_SINC = ~INT_SINC;

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
*/
/*
//*****************************************************************************************************************************************
//Interrupcion UART2
void urx_2() org  IVT_ADDR_U2RXINTERRUPT {

     //Recupera el byte recibido en cada interrupcion:
     U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART2
     byteRS485 = U2RXREG;                                                       //Lee el byte de la trama enviada por el GPS
     U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART2
     
     //Recupera el pyload de la trama RS485:                                    //Aqui deberia entrar despues de recuperar la cabecera de trama
     if (banRSI==2){
        if (i_rs485<numDatosRS485){
           tramaPyloadRS485[i_rs485] = byteRS485;
           i_rs485++;
        } else {
           banRSI = 0;                                                          //Limpia la bandera de inicio de trama
           banRSC = 1;                                                          //Activa la bandera de trama completa
        }
     }

     //Recupera la cabecera de la trama RS485:                                  //Aqui deberia entrar primero cada vez que se recibe una trama nueva
     if ((banRSI==0)&&(banRSC==0)){
        if (byteRS485==0x3A){                                                   //Verifica si el primer byte recibido sea la cabecera de trama
           banRSI = 1;
           i_rs485 = 0;
        }
     }
     if ((banRSI==1)&&(i_rs485<3)){
        tramaCabeceraRS485[i_rs485] = byteRS485;                                 //Recupera los datos de cabecera de la trama UART: [0x3A, Direccion, Funcion, NumeroDatos]
        i_rs485++;
     }
     if ((banRSI==1)&&(i_rs485==4)){
        //Comprueba la direccion:
        if ((tramaCabeceraRS485[1]==direccionRS485)||(tramaCabeceraRS485[1]==255)){
           banRSI = 2;
           i_rs485 = 0;
        } else {
           banRSI = 0;
           banRSC = 0;
        }
     }

     //Realiza el procesamiento de la informacion del  pyload:                  //Aqui se realiza cualquier accion con el pyload recuperado
     if (banRSC==1){

        funcionRS485 = tramaCabeceraRS485[2];
        numDatosRS485 = tramaCabeceraRS485[3];
                
        switch (funcionRS485){
               case 0xF1:
                    //Inicia el muestreo:
                    
                    break;
               case 0xF2:
                    //Recupera el tiempo de la trama RS485:
                    
                    break;
               case 0xF3:
                    //Envia una trama de prueba:
                  
                    break;
                }
                
         banRSC = 0;
         
     }
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
/*
///////////////// PRUEBAS ////////////////////
//Interrupcion UART1
void urx_1() org  IVT_ADDR_U1RXINTERRUPT {
     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
     byteGPS = U1RXREG;                                                         //Lee el byte de la trama enviada por el GPS
     U1STAbits.OERR = 0;                                                        //Limpia este bit para limpiar el FIFO UART
     //INT_SINC = ~INT_SINC;                                                      //TEST
}
*/
/*
//Interrupcion UART2
void urx_2() org  IVT_ADDR_U2RXINTERRUPT {
     //Recupera el byte recibido en cada interrupcion:
     U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART2
     byteRS485 = U2RXREG;                                                       //Lee el byte de la trama enviada por el GPS
     U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART2
     
     if (byteRS485==0x3A){
        INT_SINC = ~INT_SINC;
     }
     
}
*/