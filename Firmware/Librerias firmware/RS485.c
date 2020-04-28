//**Revisar esto para poder enviar como parametro a la libreria
sbit MSRS485 at LATB12_bit;                                                     //Definicion del pin CS RS485
sbit MSRS485_Direction at TRISB12_bit;

//*****************************************************************************************************************************************
//Funcion para enviar una trama de n datos a travez del MAX485
void EnviarTramaRS485(unsigned short puertoUART, unsigned short direccion, unsigned short numDatos, unsigned short funcion, unsigned char *payload){

     unsigned int iDatos;
     
     if (puertoUART == 1){
        MSRS485 = 1;                                                            //Establece el Max485 en modo escritura
        UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
        UART1_Write(direccion);                                                 //Envia la direccion del destinatario
        UART1_Write(numDatos);                                                  //Envia el numero de datos
        UART1_Write(funcion);                                                   //Envia el codigo de la funcion
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
        UART2_Write(numDatos);                                                  //Envia el numero de datos
        UART2_Write(funcion);                                                   //Envia el codigo de la funcion
        for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
            UART2_Write(payload[iDatos]);
        }
        UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
        UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
        while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
        MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
     }

}
//*****************************************************************************************************************************************