/*-------------------------------------------------------------------------------------------------------------------------
Autor: Milton Munoz, email: miltonrodrigomunoz@gmail.com
Fecha de creacion: 14/03/2019
Configuracion: dsPIC33EP256MC202, XT=80MHz
---------------------------------------------------------------------------------------------------------------------------*/

////////////////////////////////////////////////////         Librerias         /////////////////////////////////////////////////////////////

#include <TIEMPO_GPS.c>

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////// Declaracion de variables //////////////////////////////////////////////////////////////

//Variables y contantes para la peticion y respuesta de datos
sbit RP1 at LATA4_bit;                                                          //Definicion del pin P1
sbit RP1_Direction at TRISA4_bit;
sbit TEST at LATB12_bit;                                                        //Definicion del pin P2
sbit TEST_Direction at TRISB12_bit;

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

unsigned int i, x, y, i_gps, j;
unsigned short buffer;
unsigned short contMuestras;
unsigned short contCiclos;
unsigned int contFIFO;
short tasaMuestreo;
short numTMR1;

unsigned short banUTI, banUTC;                                                  //Banderas de control de la trama UART
unsigned short banLec, banEsc, banCiclo, banInicio, banSetReloj, banSetGPS;
unsigned short banMuestrear, banLeer, banConf;

unsigned char byteGPS, banTIGPS, banTFGPS, banTCGPS;
unsigned long horaSistema, fechaSistema;

unsigned char byteUART2;
unsigned char tramaUART2[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
unsigned int i_uart;

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////////////////////////////  Declaracion de funciones  /////////////////////////////////////////////////////////
void ConfiguracionPrincipal();
void Muestrear();
void ConfigurarGPS();
unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS);
unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS);
unsigned long RecuperarFechaRPI(unsigned short *tramaTiempoRpi);
unsigned long RecuperarHoraRPI(unsigned short *tramaTiempoRpi);
void AjustarTiempoSistema(unsigned long hGPS, unsigned long fGPS, unsigned char *tramaTiempoSistema);
void InterrupcionP2();
void EnviarTramaUART(unsigned short puertoUART, unsigned short direccion, unsigned short numDatos, unsigned short funcion, unsigned char *payload);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////      Main      ////////////////////////////////////////////////////////////////
void main() {

     ConfiguracionPrincipal();
     //ConfigurarGPS();
     
     //Banderas de control de la trama UART:
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
     horaSistema = 0;
     i_uart = 0;

     contMuestras = 0;
     contCiclos = 0;
     contFIFO = 0;
     numFIFO = 0;
     numSetsFIFO = 0;
     contTimer1 = 0;

     byteGPS = 0;

     RP1 = 0;
     TEST = 1;

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
     TRISA3_bit = 0;                                                            //Configura el pin A3 como salida  *
     TRISA4_bit = 0;                                                            //Configura el pin A4 como salida  *
     TRISB12_bit = 0;                                                           //Configura el pin B12 como salida *
     TRISB10_bit = 1;                                                           //Configura el pin B10 como entrada *
     TRISB11_bit = 1;                                                           //Configura el pin B11 como entrada *
     TRISB13_bit = 1;                                                           //Configura el pin B13 como entrada *
     INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales *
     
     //Configuracion del puerto UART1
     RPINR18bits.U1RXR = 0x22;                                                  //Configura el pin RB2/RPI34 como Rx1
     RPOR0bits.RP35R = 0x01;                                                    //Configura el Tx1 en el pin RB3/RP35
     UART1_Init(9600);                                                          //Inicializa el UART1 con una velocidad de 9600 baudios
     U1RXIE_bit = 0;                                                            //Desabilita la interrupcion por UART1 RX
     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
     IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
     U1STAbits.URXISEL = 0x00;

     //Configuracion del puerto UART2
     RPINR19bits.U2RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx2
     RPOR1bits.RP36R = 0x03;                                                    //Configura el Tx2 en el pin RB4/RP36
     UART2_Init_Advanced(2000000, 2, 1, 1);                                     //Inicializa el UART2 con una velocidad de 2Mbps
     U2RXIE_bit = 0;                                                            //Desabilita la interrupcion por UART2 RX
     U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
     IPC7bits.U2RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
     U2STAbits.URXISEL = 0x00;

     /*//Configuracion del puerto UART1
     RPINR18bits.U1RXR = 0x25;
     RPOR0bits.RP35R = 0x01;
     UART1_Init_Advanced(2000000, 2, 1, 1);
     U1RXIE_bit = 0;
     U1RXIF_bit = 0;
     IPC2bits.U1RXIP = 0x04;
     U1STAbits.URXISEL = 0x00;*/

     //Configuracion del puerto SPI1 en modo Esclavo
     SPI1STAT.SPIEN = 1;                                                        //Habilita el SPI1 *
     SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);        //*
     SPI1IE_bit = 1;                                                            //Habilita la interrupcion por SPI1  *
     SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
     IPC2bits.SPI1IP = 0x03;                                                    //Prioridad de la interrupcion SPI1

     //Configuracion de la interrupcion externa INT1
     RPINR0 = 0x2E00;                                                           //Asigna INT1 al RB14/RPI46
     INT1IE_bit = 0;                                                            //Habilita la interrupcion externa INT1
     INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
     IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1

     Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Funcion para realizar la interrupcion en la RPi
 void InterrupcionP2(){
     //Habilita la interrupcion INT1 para incrementar la hora del sistema con cada pulso PPS
     if (INT1IE_bit==0){
        INT1IE_bit = 1;
     }
     //Apaga la interrupcion por UARTRx
     if (U1RXIE_bit==1){
        U1RXIE_bit = 0;
     }
     //Genera el pulso P2 para producir la interrupcion externa en la RPi
     RP1 = 1;
     Delay_us(20);
     RP1 = 0;
}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Funcion para enviar una trama de n datos a travez del UART
void EnviarTramaUART(unsigned short puertoUART, unsigned short direccion, unsigned short numDatos, unsigned short funcion, unsigned char *payload){
     
     unsigned int iDatos;
     
     if (puertoUART == 1){
        UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
        UART1_Write(direccion);                                                 //Envia la direccion del destinatario
        UART1_Write(numDatos);                                                  //Envia el numero de datos
        UART1_Write(funcion);                                                   //Envia el codigo de la funcion
        for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
            UART1_Write(payload[iDatos]);
        }
        UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
        UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
     }
     
     if (puertoUART == 2){
        UART2_Write(0x3A);                                                      //Envia la cabecera de la trama
        UART2_Write(direccion);                                                 //Envia la direccion del destinatario
        UART2_Write(numDatos);                                                  //Envia el numero de datos
        UART2_Write(funcion);                                                   //Envia el codigo de la funcion
        for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
            UART2_Write(payload[iDatos]);
        }
        UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
        UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
     }

}

//*****************************************************************************************************************************************

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////// Interrupciones /////////////////////////////////////////////////////////////

//*****************************************************************************************************************************************
//Interrupcion SPI1
void spi_1() org  IVT_ADDR_SPI1INTERRUPT {

     SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI
     buffer = SPI1BUF;                                                          //Guarda el contenido del bufeer (lectura)

     //Rutina para obtener la hora del GPS
     if ((banSetReloj==0)){
        if (buffer==0xC0){
           banTIGPS = 0;                                                        //Limpia la bandera de inicio de trama  del GPS
           banTCGPS = 0;                                                        //Limpia la bandera de trama completa
           i_gps = 0;                                                           //Limpia el subindice de la trama GPS
           //Habilita interrupcion por UART1Rx si esta desabilitada:
           if (U1RXIE_bit==0){
              U1RXIE_bit = 1;
           }
        }
     }
     
     //Rutina para obtener la hora de la RPi
     if ((banSetReloj==0)&&(buffer==0xC3)){
         banEsc = 1;
         j = 0;
     }
     if ((banEsc==1)&&(buffer!=0xC3)&&(buffer!=0xC4)){
        tiempoRPI[j] = buffer;
        j++;
     }
     if ((banEsc==1)&&(buffer==0xC4)){
        horaSistema = RecuperarHoraRPI(tiempoRPI);                              //Recupera la hora de la RPi
        fechaSistema = RecuperarFechaRPI(tiempoRPI);                            //Recupera la fecha de la RPi
        AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
        banEsc = 0;
        
        //TEST = ~TEST;
        EnviarTramaUART(2, 255, 6, 2, tiempo);                                  //puerto = UART1, direccion = broadcast, numBytes = 6 bytes, funcion = setTiempo, trama = tiempo
        U2RXIE_bit = 1;                                                         //Activa la interrupcion por UART1
     
     }
     
     //Rutina para enviar la hora local a la RPi
     if (banSetReloj==1){
        banSetReloj = 2;
        j = 0;
        SPI1BUF = tiempo[j];
     }
     if ((banSetReloj==2)&&(buffer!=0xC1)){
        SPI1BUF = tiempo[j];
        j++;
     }
     if ((banSetReloj==2)&&(buffer==0xC1)){                                     //Si detecta el delimitador de final de trama:
        banSetReloj = 0;                                                        //Limpia la bandera de lectura
        //SPI1BUF = 0xFF;
     }
     
     //Rutina de lectura de los datos del acelerometro
     if ((banLec==1)&&(buffer==0xB0)){                                          //Verifica si la bandera de inicio de trama esta activa
        banLec = 2;                                                             //Activa la bandera de lectura
        i = 0;
        SPI1BUF = tramaCompleta[i];
     }
     if ((banLec==2)&&(buffer!=0xB1)){
        SPI1BUF = tramaCompleta[i];
        i++;
     }
     if ((banLec==2)&&(buffer==0xB1)){                                          //Si detecta el delimitador de final de trama:
        banLec = 0;                                                             //Limpia la bandera de lectura
        SPI1BUF = 0xFF;
     }
     
}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Interrupcion INT1
void int_1() org IVT_ADDR_INT1INTERRUPT {
     
     INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
     
     //TEST = ~TEST;
     horaSistema++;                                                             //Incrementa el reloj del sistema

     if (horaSistema==86400){                                                   //(24*3600)+(0*60)+(0) = 86400
        horaSistema = 0;                                                        //Reinicia el reloj al llegar a las 24:00:00 horas
     }
     
     if (banInicio==1){
        //Muestrear();
     }
     
}
//*****************************************************************************************************************************************

/*//*****************************************************************************************************************************************
//Interrupcion UART1
void urx_1() org  IVT_ADDR_U1RXINTERRUPT {

     U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART

     byteGPS = U1RXREG;                                                         //Lee el byte de la trama enviada por el GPS
     U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART

     if (banTIGPS==0){
        if ((byteGPS==0x24)&&(i_gps==0)){                                       //Verifica si el primer byte recibido es el simbolo "$" que indica el inicio de una trama GPS
           banTIGPS = 1;                                                        //Activa la bandera de inicio de trama
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
        if ( tramaGPS[1]==0x47 && tramaGPS[2]==0x50 && tramaGPS[3]==0x52 && tramaGPS[4]==0x4D && tramaGPS[5]==0x43 && tramaGPS[18]==0x41 ){      //"GPRMC" y "A"
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
           AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);             //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del gps
           InterrupcionP2();                                                    //Genera el pulso P2 para producir la interrupcion en la RPi
           banSetReloj = 1;                                                     //Activa la bandera para hacer uso de la hora GPS
        } else {
           InterrupcionP2();                                                    //Genera el pulso P2 para producir la interrupcion en la RPi
           banSetReloj = 0;                                                     //Limpia la bandera para permitir otra peticion de toma de datos del GPS
        }
     }

}
//*****************************************************************************************************************************************

//*****************************************************************************************************************************************
//Interrupcion UART2
void urx_2() org  IVT_ADDR_U2RXINTERRUPT {

     U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART2

     byteUART2 = U2RXREG;                                                       //Lee el byte de la trama enviada por el GPS
     U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART

     tramaUART2[i_uart] = byteUART2;
     i_uart++;

     if (i_uart==6){                                                            //Verifica si se recibieron los 6 bytes de tiempo
        U2RXIE_bit = 0;
        banSetReloj = 1;
        TEST = ~TEST;
        i_uart = 0;
        RP2 = 1;
        Delay_us(20);
        RP2 = 0;
     }

}*/
//*****************************************************************************************************************************************


//Interrupcion UART2
void urx_2() org  IVT_ADDR_U2RXINTERRUPT {

     U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART2

     byteUART2 = U2RXREG;                                                       //Lee el byte de la trama enviada por el GPS
     U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART2

     if ((banUTI==0)&&(byteUART2==0x3A)){                                       //Verifica si el primer byte recibido sea la cabecera de trama
        banUTI = 1;
        i_uart = 0;
     }
     if (banUTI==1){
        if (byteUART2!=0x0A){
           tramaUART2[i_uart] = byteUART2;                                      //Almacena el byte recibido en la trama, mientras este sea diferente del segundo byte del delimitador de final de trama
           i_uart++;
        } else {
           banUTI = 0;                                                          //Limpia la bandera de inicio de trama
           banUTC = 1;                                                          //Activa la bandera de trama completa
        }
     }
     
     if (banUTC==1){
         //PRUEBA//
         TEST = ~TEST;                                                          //Indica si se completo la trama
         for (x=0;x<6;x++) {
             tiempo[x] = tramaUART2[x+4];                                       //LLeno la trama tiempo con el payload de la trama recuperada
         }
         banSetReloj=1;                                                         //Activa la bandera para enviar la hora a la RPI por SPI
         //Genera el pulso P2 para producir la interrupcion externa en la RPi:
         RP1 = 1;
         Delay_us(20);
         RP1 = 0;
         //FIN PRUEBA//
         banUTC = 0;
     }

}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////