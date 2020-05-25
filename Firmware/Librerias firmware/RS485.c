//Libreria para la comunicacion a travez de RS485

/////////////////////// /// Formato de la trama de datos //////////////////////////
//|                     Cabecera                 |       PDU       |      Fin     |
//|   1 byte   |   1 byte  |  1 byte   | 1 byte  |     n bytes     |    2 bytes   |
//|    0x3A    | Dirección |  Funcion  | #Datos  |     Payload     |  0Dh  |  0Ah |


// Definicion de pines del chip select, en el programa que se va a utilizar la
// libreria hay que declarar este pin del CS
extern sfr sbit MSRS485;
extern sfr sbit MSRS485_Direction;

//*****************************************************************************************************************************************

//Funcion para enviar una trama de n datos a travez del MAX485
void EnviarTramaRS485(unsigned short puertoUART, unsigned short direccion, unsigned short funcion, unsigned short numDatos, unsigned char *payload){

     unsigned int iDatos;
     
     if (puertoUART == 1){
        MSRS485 = 1;                                                            //Establece el Max485 en modo escritura
        UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
        UART1_Write(direccion);                                                 //Envia la direccion del destinatario
        UART1_Write(funcion);                                                   //Envia el codigo de la funcion
        UART1_Write(numDatos);                                                  //Envia el numero de datos
        for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
            UART1_Write(payload[iDatos]);
        }
        UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
        UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
        while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
        MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
     }

     if (puertoUART == 2){
        MSRS485 = 1;                                                            //Establece el Max485 en modo escritura
        UART2_Write(0x3A);                                                      //Envia la cabecera de la trama
        UART2_Write(direccion);                                                 //Envia la direccion del destinatario
        UART2_Write(funcion);                                                   //Envia el codigo de la funcion
        UART2_Write(numDatos);                                                  //Envia el numero de datos
        for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
            UART2_Write(payload[iDatos]);
        }
        UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
        UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
        while(UART2_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
        MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
     }

}

//*****************************************************************************************************************************************