
// *****************************************************************************
// Libreria para iniciar, leer y escribir en una tarjeta SD en formato FAT32 de
// 512 bytes tipo primaria. Lo especial de esta libreria es que se escriben o se
// leen los sectores de la SD, cada sector tiene 512 bytes, por lo tanto se
// escriben o se leen todos los 512 bytes correspondientes al sector. En la compu 
// no se puede leer la SD de la forma normal, no se crean archivos, solo se 
// guarda en los sectores, incluso si se formatea la SD no se borran los datos 
// de estos sectores, a menos que se coloque un archivo y justo coincida que 
// esta guardado en tal sector. Un programa de Windows para leer los sectores de 
// la SD se llama HxD

// En el programa hay que incluir la libreria de la SD, del SPI y de Booleano
// #include <spi.h>
// #include <sdcard.h>
// #include <stdbool.h>

// En el programa hay que declarar los pines del Chip Select y el pin para
// detectar la SD (depende si tiene o no el adaptador de la SD este pin)

// Ejemplo de declaracion del CS en el RF1
// sbit sd_CS_lat at LATF1_bit;
// sbit sd_CS_tris at TRISF1_bit;
// Importante declarar como salida el sd_CS_tris en el programa
// sd_CS_tris = 0;

// Ejemplo de declaracion del pin para detectar la SD en el RB9
// sbit detect_SD_port at RB9_bit;
// sbit detect_SD_tris at TRISB9_bit;
// Importante declarar como entrada el sd_detect_tris en el programa
// sd_detect_tris = 1;

// Tambien hay que declarar la estructura sdflags
// struct sdflags sdflags;
// Luego, inicializarla
// sdflags.detected = false;
// sdflags.init_ok = false;
// sdflags.saving = false;

// Funciones principales:
// SD_Detect(): Permite detectar si esta o no conectada la SD, en caso afirmativo
// devuelve el valor DETECTED

// SD_Init_Try(10): Intenta iniciar la SD hasta 10 veces (10 en este caso) y si
// se inicia correctamente devuelve SUCCESSFUL_INIT

// Una vez iniciada la SD se pueden escribir o leer los datos por sector
// SD_Write_Block(buffer,sector): Permite escribir los datos que se encuentran
// en el vector buffer (que debe ser de 512 bytes) en el sector que se envia. Si
// la escritura es correcta devuelve DATA_ACCEPTED

// SD_Read_Block(buffer,sector): Permite leer los datos del sector, se guardan en
// el vector buffer y son los 512 bytes del sector
// *****************************************************************************

// Incluye la libreria del SPI, las definiciones del archivo sdcard.h
#include "spiSD.h"
#include "sdcard.h"
// Y la libreria para utilizar variables tipo bool, true and false
#include <stdbool.h>
//#define SD_TIME_OUT 100

// *****************************************************************************
// Declaracion de variables
// *****************************************************************************
// Definicion de pines del chip select, en el programa que se va a utilizar la
// libreria hay que declarar este pin del CS
extern sfr sbit sd_CS_lat;
extern sfr sbit sd_CS_tris;

// Definicion del pin para detectar si esta o no conectada la SD, pin_detect_SD
// En el programa que se va a utilizar la libreria hay que declarar este pin
// unicamente el tris y el port xq es como entrada y se desea leer
extern sfr sbit sd_detect_port;
extern sfr sbit sd_detect_tris;

// Variable tipo estructura sdflags, en el archivo sdcard.h esta su formato, tiene
// tres variables: sdflags.init_ok, sdflags.detected, sdflags.saving
// Se declara como externa xq se debe declarar en el programa que se desea utilizar
// y tambien se inicializa en ese programa
extern struct sdflags sdflags;

// Variable Card Capacity Status, se lee al iniciar la SD y luego se utiliza su
// valor
unsigned char ccs;

// *****************************************************************************
// Funcion para leer N datos de la SD, recibe como parametros el buffer donde se
// desea guardar los datos y el numero de bytes a leer
// *****************************************************************************
unsigned char SD_Read(unsigned char *Buffer, unsigned int nbytes){
    unsigned int i;
    unsigned char temp;
    for(i = 0; i < SD_TIME_OUT; i++){
        temp = SPISD_Write(0xFF);
        if(temp == 0xFE) break;
        if(i == SD_TIME_OUT-1) return TOKEN_NOT_RECEIVED;
		//if(i == SD_TIME_OUT-1) return 0xEE;
    }
    for(i = 0; i < nbytes; i++){
        Buffer[i] = SPISD_Write(0xFF);
    }
    temp = SPISD_Write(0xFF);     // Read 16bits of CRC
    temp = SPISD_Write(0xFF);     //
    return 0x00;                // Successful read                
}
// *****************************************************************************
// **************************** Fin SD_Read ************************************
// *****************************************************************************



// *****************************************************************************
// Metodo que permite leer todo un sector de datos, es decir 512 bytes que
// corresponden al sector con la direccion que se envia como parametro
// *****************************************************************************
unsigned char SD_Read_Block(unsigned char *Buffer, unsigned long Address){
    unsigned char temp;
    Select_SD();
    
    if(ccs == 0x02) Address<<=9;        // Address * 512 for SDSC cards
    if(SD_Ready() == 0) return SD_NOT_READY;
    SD_Send_Command(READ_SINGLE_BLOCK,Address,0xFF);
    temp = R1_Response();
    if(temp != 0x00) return temp;
    temp = SD_Read(Buffer,512);
    
    Release_SD();
    return temp;
}
// *****************************************************************************
// ********************** Fin metodo SD_Read_Block *****************************
// *****************************************************************************



// *****************************************************************************
// Metodo que permite escribir datos en todo un sector, es decir 512 bytes se
// deben pasar en el parametro Buffer y se debe indicar la direccion del sector
// *****************************************************************************
unsigned char SD_Write_Block(unsigned char *Buffer, unsigned long Address){
    unsigned char temp;
    unsigned int i;
    
    // Llama al metodo para colocar en 0 el CS
    Select_SD();
        
    if(ccs == 0x02) Address<<=9;        // Address * 512 for SDSC cards
    if(SD_Ready() == 0) return SD_NOT_READY;
    SD_Send_Command(WRITE_BLOCK,Address,0xFF);
    temp = R1_Response();
    if(temp != 0x00) return temp;
    temp = SPISD_Write(0xFE);    // Send Start Block Token;
    for(i = 0; i < 512; i++){
        temp = SPISD_Write(Buffer[i]);
    }
    temp = SPISD_Write(0xFF);        // Send dummy 16bits CRC
    temp = SPISD_Write(0xFF);
    temp = SPISD_Write(0xFF); // Read Response token (xxx0:status(3b):1)
    temp = (temp&0x0E)>>1;
    if(SD_Ready() == 0) return SD_NOT_READY;
    
    // Llama al metodo para colocar en 1 el CS
    Release_SD();
    if(temp == 0x02) return DATA_ACCEPTED;
    else if(temp == 0x05) return DATA_REJECTED_CRC_ERROR;
    else if(temp == 0x06) return DATA_REJECTED_WR_ERROR;
    else return ERROR;
}
// *****************************************************************************
// ********************* Fin metodo SD_Write_Block *****************************
// *****************************************************************************



// *****************************************************************************
// Metodo para intentar iniciar la SD n veces, recibe como parametro el numero
// de veces que se desea iniciar la SD y basta que se inicie correctamente una
// vez, devuelve SUCCESSFUL_INIT. Llamar a este metodo en lugar de SD_Init
// *****************************************************************************
unsigned char SD_Init_Try(unsigned char try_value){
    unsigned char i,init_status;
    if(try_value == 0) try_value = 1;
    for(i = 0; i < try_value; i++){
        init_status = SD_Init();
        if(init_status == SUCCESSFUL_INIT) break;
        Release_SD();
        Delay_ms(10);
    }
    return init_status;
}
// *****************************************************************************
// ************************ Fin metodo SD_Init_Try *****************************
// *****************************************************************************



// *****************************************************************************
// Metodo para iniciar la SD, en caso de que se inicie correctamente devuelve
// SUCCESSFUL_INIT, caso contrario devuelve un valor en funcion del error
// *****************************************************************************
unsigned char SD_Init(void){
    // Local variables required
    unsigned int i;
    unsigned char temp;
    unsigned long temp_long;  

    // Coloca como salida el Chip Select, en 0
    sd_CS_tris = 0;
    
    // Llama al metodo para colocar en 1 el CS
    Release_SD();
  
    // Initialize SPI interface at slow speed
    SPISD_Init(SLOW);
    
    // Toggle CLK for 80 cycles with SDO high
    for(i = 0; i < 80; i++) SPISD_Write(0xFF);
    
    // Llama al metodo para colocar en 0 el CS
    Select_SD();
    for(i = 0; i < SD_TIME_OUT; i++){
        SD_Send_Command(GO_IDLE_STATE,0x00000000,0x4A);     // CMD0
        temp = R1_Response();
        if(temp == (1<<IDLE_STATE)) break;
        if(i==(SD_TIME_OUT-1)) return CARD_NOT_INSERTED;
    }   
   
    // Send CMD8 Command (2.7-3.6V range = 0x01. Check pattern = 0xAA)
    if(SD_Ready() == 0) return SD_NOT_READY;
    SD_Send_Command(SEND_IF_COND,0x000001AA,0x43);          // CMD8
    temp = R1_Response();
    if(temp != (1<<IDLE_STATE)){
        // Possible old card. Send CMD1
        for(i = 0; i < SD_TIME_OUT; i++){
            if(SD_Ready() == 0) return SD_NOT_READY;
            SD_Send_Command(SEND_OP_COND,0x00000000,0x7C);  // CMD1
            temp = R1_Response();
            if(temp == 0x00) break;
            if(i==(SD_TIME_OUT-1)) return UNUSABLE_CARD;
        }
    } else if (temp == (1<<IDLE_STATE)) {
        temp_long = Response_32b();
        temp = (temp_long & ECHO_BACK_MASK);
        if(temp != 0xAA) return ECHO_BACK_ERROR;
        temp = ((temp_long & VOLTAGE_ACCEPTED_MASK)>>8);
        if(temp != 0x01) return INCOMPATIBLE_VOLTAGE;
        
        // Read OCR
        if(SD_Ready() == 0) return SD_NOT_READY;
        SD_Send_Command(READ_OCR,0x00000000,0x7E);          // CMD58
        temp = R1_Response();
        if(temp != (1<<IDLE_STATE)) return temp;
        temp_long = Response_32b();
        if((temp_long & VOLTAGE_RANGE_MASK) != VOLTAGE_RANGE_MASK) 
            return INCOMPATIBLE_VOLTAGE;
        
        // Activate CRC before issuing ACMD41
        if(SD_Ready() == 0) return SD_NOT_READY;
        SD_Send_Command(CRC_ON_OFF,0x00000001,0x41);        // CMD59
        temp = R1_Response();
        if(temp != (1<<IDLE_STATE)) return temp;
        
        // Check if card initialization is done
        for(i = 0; i < SD_TIME_OUT; i++){
            if(SD_Ready() == 0) return SD_NOT_READY;
            SD_Send_Command(APP_CMD,0x00000000,0x32);           // CMD55
            temp = R1_Response();
            if(SD_Ready() == 0) return SD_NOT_READY;
            SD_Send_Command(SD_SEND_OP_COND,0x40000000,0x3B);   // ACMD41
            temp = R1_Response();
            if(temp == 0x00) break;  // Initialization done
            if(i==(SD_TIME_OUT-1)) return UNUSABLE_CARD;
        }
    }
    else return temp;   // Some error of the R1 response type
    
    // Disable CRC verification. CRC7 is ignored in subsequent commands.
    if(SD_Ready() == 0) return SD_NOT_READY;
    SD_Send_Command(CRC_ON_OFF,0x00000000,0x48);        // CMD59
    temp = R1_Response();
    if(temp != 0x00) return temp;
    
    // Set Block to 512 bytes for read/write operations
    if(SD_Ready() == 0) return SD_NOT_READY;
    SD_Send_Command(SET_BLOCKLEN,0x00000200,0x0A);      // CMD16
    temp = R1_Response();
    if(temp != 0x00) return temp;
    
    // Read Card Capacity Status (CCS)
    if(SD_Ready() == 0) return SD_NOT_READY;
    SD_Send_Command(READ_OCR,0x00000000,0x7E);          // CMD58
    temp = R1_Response();
    if(temp != 0x00) return temp;
    temp_long = Response_32b();
    ccs = (long)(temp_long >> 30);
    
    // Llama al metodo para colocar en 1 el CS
    Release_SD();
    // Configure SPI to maximum speed
    SPISD_Init(FAST);
    
    return SUCCESSFUL_INIT;
}
// *****************************************************************************
// ************************** Fin metodo SD_Init *******************************
// *****************************************************************************



// *****************************************************************************
// ************************** Metodo R1_Response *******************************
// *****************************************************************************
unsigned char R1_Response(void){
    unsigned char temp;
    temp = SPISD_Write(0xFF);
    temp = SPISD_Write(0xFF);
    return temp;
}
// *****************************************************************************
// ************************* Fin metodo R1_Response ****************************
// *****************************************************************************



// *****************************************************************************
// ************************** Metodo R2_Response *******************************
// *****************************************************************************
unsigned int R2_Response(void){
    unsigned char temp;
    unsigned int response;
    temp = SPISD_Write(0xFF);
    response = SPISD_Write(0xFF);
    temp = SPISD_Write(0xFF);
    response = (response<<8)|temp;
    return response;
}
// *****************************************************************************
// ************************* Fin metodo R2_Response ****************************
// *****************************************************************************



// *****************************************************************************
// ************************** Metodo Response_32b ******************************
// *****************************************************************************
unsigned long Response_32b(void){
    unsigned char temp;
    unsigned long response;
    response = SPISD_Write(0xFF);
    temp = SPISD_Write(0xFF);
    response = (response<<8)|temp;
    temp = SPISD_Write(0xFF);
    response = (response<<8)|temp;
    temp = SPISD_Write(0xFF);
    response = (response<<8)|temp;
    return response;
}
// *****************************************************************************
// *********************** Fin metodo Response_32b *****************************
// *****************************************************************************



// *****************************************************************************
// ****************** Metodo para enviar un comando a la SD ********************
// *****************************************************************************
void SD_Send_Command(unsigned char command,unsigned long argument, unsigned char crc){
    SPISD_Write(command |= 0x40);
    SPISD_Write((unsigned char)(argument>>24));
    SPISD_Write((unsigned char)(argument>>16));
    SPISD_Write((unsigned char)(argument>>8));
    SPISD_Write((unsigned char)(argument));
    SPISD_Write((crc<<1)|0x01);
}
// *****************************************************************************
// ************************** Fin SD_Send_Command ******************************
// *****************************************************************************



// *****************************************************************************
// Metodo que devuelve un valor igual a 0 si la SD tiene algun problema y no
// esta lista para usar. Si la SD esta lista devuelve un valor distinto de 0
// *****************************************************************************
unsigned char SD_Ready(void){
    unsigned int i;
    unsigned char temp;
    for(i = 0; i < SD_TIME_OUT; i++){
        temp = SPISD_Write(0xFF);
        if(temp == 0xFF) break;
        if(i == (SD_TIME_OUT-1)) return 0x00;
    }
    return temp;
}
// *****************************************************************************
// ****************************** Fin SD_Ready *********************************
// *****************************************************************************



// *****************************************************************************
// Metodo que coloca el pin Chip Select en 1, cuando se llama a este metodo no
// es posible ni leer ni escribir en la SD
// *****************************************************************************
void Release_SD(void){
    // Coloca en 1 el pin del Chip Select
    sd_CS_lat = 1;
    asm nop;
}
// *****************************************************************************
// ****************************** Fin Release_SD *******************************
// *****************************************************************************



// *****************************************************************************
// Metodo para colocar el pin del Chip Select en 0 , para activar la lectura y
// escritura de la SD
// *****************************************************************************
void Select_SD(void){
    // Coloca el Chip Select en 0
    sd_CS_lat = 0;
    asm nop;
}
// *****************************************************************************
// ***************************** Fin Select_SD *********************************
// *****************************************************************************



// *****************************************************************************
// Metodo que permite detectar si esta o no conectada la tarjeta SD, en el caso
// de que este conectada devuelve DETECTED (valor 0xDE), caso contrario 0x00
// En funcion del pin
// *****************************************************************************
unsigned char SD_Detect(void) {
    // Si es 0 significa que la SD esta conectada
    if (sd_detect_port == 0) {
         return DETECTED;
    // Si es 1 significa que no esta conectada la SD y devuelve 0
    } else {
         return 0;
    }
}
// *****************************************************************************
// ***************************** Fin SD_Detect *********************************
// *****************************************************************************