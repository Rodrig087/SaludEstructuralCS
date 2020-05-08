#line 1 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/NodoAcelerometro/NodoAcelerometro.c"
#line 1 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/adxl355_spi.c"
#line 96 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/adxl355_spi.c"
sbit CS_ADXL355 at LATA3_bit;
unsigned short axisAddresses[] = { 0x08 ,  0x09 ,  0x0A ,  0x0B ,  0x0C ,  0x0D ,  0x0E ,  0x0F ,  0x10 };

void ADXL355_init();
void ADXL355_write_byte(unsigned char address, unsigned char value);
unsigned char ADXL355_read_byte(unsigned char address);
unsigned int ADXL355_read_data(unsigned char *vectorMuestra);
unsigned int ADXL355_read_FIFO(unsigned char *vectorFIFO);


void ADXL355_init(short tMuestreo){
 ADXL355_write_byte( 0x2F ,0x52);
 Delay_ms(10);
 ADXL355_write_byte( 0x2D ,  0x04 | 0x01 );
 ADXL355_write_byte( 0x2C ,  0x01 );
 switch (tMuestreo){
 case 1:
 ADXL355_write_byte( 0x28 ,  0x00 | 0x04 );
 break;
 case 2:
 ADXL355_write_byte( 0x28 ,  0x00 | 0x05 );
 break;
 case 4:
 ADXL355_write_byte( 0x28 ,  0x00 | 0x06 );
 break;
 case 8:
 ADXL355_write_byte( 0x28 ,  0x00 | 0x07  );
 break;
 }
}


void ADXL355_write_byte(unsigned char address, unsigned char value){
 address = (address<<1)&0xFE;
 CS_ADXL355=0;
 SPI2_Write(address);
 SPI2_Write(value);
 CS_ADXL355=1;
}


unsigned char ADXL355_read_byte(unsigned char address){
 unsigned char value = 0x00;
 address=(address<<1)|0x01;
 CS_ADXL355=0;
 SPI2_Write(address);
 value=SPI2_Read(0);
 CS_ADXL355=1;
 return value;
}


unsigned int ADXL355_read_data(unsigned char *vectorMuestra){
 unsigned short j;
 unsigned short muestra;
 if((ADXL355_read_byte( 0x04 )&0x01)==1){
 CS_ADXL355=0;
 for (j=0;j<9;j++){
 muestra = ADXL355_read_byte(axisAddresses[j]);
 vectorMuestra[j] = muestra;
 }
 CS_ADXL355=1;
 } else {
 for (j=0;j<9;j++){
 vectorMuestra[j] = 0;
 }
 }
 return;
}


unsigned int ADXL355_read_FIFO(unsigned char *vectorFIFO){
 unsigned char add;
 add = ( 0x11 <<1)|0x01;
 CS_ADXL355 = 0;
 SPI2_Write(add);

 vectorFIFO[0] = SPI2_Read(0);
 vectorFIFO[1] = SPI2_Read(1);
 vectorFIFO[2] = SPI2_Read(2);

 vectorFIFO[3] = SPI2_Read(0);
 vectorFIFO[4] = SPI2_Read(1);
 vectorFIFO[5] = SPI2_Read(2);

 vectorFIFO[6] = SPI2_Read(0);
 vectorFIFO[7] = SPI2_Read(1);
 vectorFIFO[8] = SPI2_Read(2);
 CS_ADXL355 = 1;
 Delay_us(5);
 return;
}
#line 1 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/tiempo_rtc.c"
#line 37 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/tiempo_rtc.c"
sbit CS_DS3234 at LATA2_bit;




void DS3234_init();
void DS3234_write_byte(unsigned char address, unsigned char value);
void DS3234_read_byte(unsigned char address, unsigned char value);
void DS3234_setDate(unsigned long longHora, unsigned long longFecha);
unsigned long RecuperarFechaRTC();
unsigned long RecuperarHoraRTC();





void DS3234_init(){

 SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);
 DS3234_write_byte( 0x8E ,0x20);
 DS3234_write_byte( 0x8F ,0x08);
 SPI2_Init();

}


void DS3234_write_byte(unsigned char address, unsigned char value){

 CS_DS3234 = 0;
 SPI2_Write(address);
 SPI2_Write(value);
 CS_DS3234 = 1;

}


unsigned char DS3234_read_byte(unsigned char address){

 unsigned char value = 0x00;
 CS_DS3234 = 0;
 SPI2_Write(address);
 value = SPI2_Read(0);
 CS_DS3234 = 1;
 return value;

}


void DS3234_setDate(unsigned long longHora, unsigned long longFecha){

 unsigned short valueSet;
 unsigned short hora;
 unsigned short minuto;
 unsigned short segundo;
 unsigned short dia;
 unsigned short mes;
 unsigned short anio;

 SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);

 hora = (short)(longHora / 3600);
 minuto = (short)((longHora%3600) / 60);
 segundo = (short)((longHora%3600) % 60);

 dia = (short)(longFecha / 10000);
 mes = (short)((longFecha%10000) / 100);
 anio = (short)((longFecha%10000) % 100);

 segundo = Dec2Bcd(segundo);
 minuto = Dec2Bcd(minuto);
 hora = Dec2Bcd(hora);
 dia = Dec2Bcd(dia);
 mes = Dec2Bcd(mes);
 anio = Dec2Bcd(anio);

 DS3234_write_byte( 0x80 , segundo);
 DS3234_write_byte( 0x81 , minuto);
 DS3234_write_byte( 0x82 , hora);
 DS3234_write_byte( 0x84 , dia);
 DS3234_write_byte( 0x85 , mes);
 DS3234_write_byte( 0x86 , anio);

 SPI2_Init();

 return;

}


unsigned long RecuperarHoraRTC(){

 unsigned short valueRead;
 unsigned long hora;
 unsigned long minuto;
 unsigned long segundo;
 unsigned long horaRTC;

 SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);

 valueRead = DS3234_read_byte( 0x00 );
 valueRead = Bcd2Dec(valueRead);
 segundo = (long)valueRead;
 valueRead = DS3234_read_byte( 0x01 );
 valueRead = Bcd2Dec(valueRead);
 minuto = (long)valueRead;
 valueRead = 0x1F & DS3234_read_byte( 0x02 );
 valueRead = Bcd2Dec(valueRead);
 hora = (long)valueRead;

 horaRTC = (hora*3600)+(minuto*60)+(segundo);

 SPI2_Init();

 return horaRTC;

}


unsigned long RecuperarFechaRTC(){

 unsigned short valueRead;
 unsigned long dia;
 unsigned long mes;
 unsigned long anio;
 unsigned long fechaRTC;

 SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);

 valueRead = DS3234_read_byte( 0x04 );
 valueRead = Bcd2Dec(valueRead);
 dia = (long)valueRead;
 valueRead = 0x1F & DS3234_read_byte( 0x05 );
 valueRead = Bcd2Dec(valueRead);
 mes = (long)valueRead;
 valueRead = DS3234_read_byte( 0x06 );
 valueRead = Bcd2Dec(valueRead);
 anio = (long)valueRead;

 fechaRTC = (dia*10000)+(mes*100)+(anio);

 SPI2_Init();

 return fechaRTC;

}


void AjustarTiempoSistema(unsigned long longHora, unsigned long longFecha, unsigned char *tramaTiempoSistema){

 unsigned char hora;
 unsigned char minuto;
 unsigned char segundo;
 unsigned char dia;
 unsigned char mes;
 unsigned char anio;

 hora = longHora / 3600;
 minuto = (longHora%3600) / 60;
 segundo = (longHora%3600) % 60;

 dia = longFecha / 10000;
 mes = (longFecha%10000) / 100;
 anio = (longFecha%10000) % 100;

 tramaTiempoSistema[0] = dia;
 tramaTiempoSistema[1] = mes;
 tramaTiempoSistema[2] = anio;
 tramaTiempoSistema[3] = hora;
 tramaTiempoSistema[4] = minuto;
 tramaTiempoSistema[5] = segundo;

}
#line 1 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/rs485.c"

sbit MSRS485 at LATB12_bit;
sbit MSRS485_Direction at TRISB12_bit;



void EnviarTramaRS485(unsigned short puertoUART, unsigned short direccion, unsigned short numDatos, unsigned short funcion, unsigned char *payload){

 unsigned int iDatos;

 if (puertoUART == 1){
 MSRS485 = 1;
 UART1_Write(0x3A);
 UART1_Write(direccion);
 UART1_Write(numDatos);
 UART1_Write(funcion);
 for (iDatos=0;iDatos<numDatos;iDatos++){
 UART1_Write(payload[iDatos]);
 }
 UART1_Write(0x0D);
 UART1_Write(0x0A);
 while(UART1_Tx_Idle()==0);
 MSRS485 = 0;
 }

 if (puertoUART == 2){
 MSRS485 = 1;
 UART2_Write(0x3A);
 UART2_Write(direccion);
 UART2_Write(numDatos);
 UART2_Write(funcion);
 for (iDatos=0;iDatos<numDatos;iDatos++){
 UART2_Write(payload[iDatos]);
 }
 UART2_Write(0x0D);
 UART2_Write(0x0A);
 while(UART1_Tx_Idle()==0);
 MSRS485 = 0;
 }

}
#line 1 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/spisd.h"
#line 13 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/spisd.h"
void SPISD_Init(unsigned char speed);
unsigned char SPISD_Write(unsigned char datos);
#line 1 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/sdcard.h"
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/stdbool.h"



 typedef char _Bool;
#line 13 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/sdcard.h"
struct sdflags {
 unsigned char init_ok:1;
 unsigned char detected:1;
 unsigned char saving:1;
};
#line 93 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/sdcard.h"
unsigned char SD_Init(void);
unsigned char SD_Init_Try(unsigned char);
unsigned char SD_Write_Block(unsigned char*,unsigned long);
unsigned char SD_Read_Block(unsigned char*,unsigned long);
unsigned char SD_Read(unsigned char*,unsigned int);
void SD_Send_Command(unsigned char, unsigned long, unsigned char);
unsigned char R1_Response(void);
unsigned int R2_Response(void);
unsigned long Response_32b(void);
unsigned char SD_Ready(void);
void Select_SD(void);
void Release_SD(void);
 _Bool  Detect_SD (void);
unsigned char SD_Detect(void);
void SD_Check(void);
#line 1 "c:/users/public/documents/mikroelektronika/mikroc pro for dspic/include/stdbool.h"
#line 23 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/NodoAcelerometro/NodoAcelerometro.c"
struct sdflags sdflags;

sbit TEST at LATA2_bit;
sbit TEST_Direction at TRISA2_bit;
sbit CsADXL at LATA3_bit;
sbit CsADXL_Direction at TRISA3_bit;

sbit sd_CS_lat at LATB0_bit;
sbit sd_CS_tris at TRISB0_bit;
sbit sd_detect_port at LATA4_bit;
sbit sd_detect_tris at TRISA4_bit;

unsigned char tramaGPS[70];
unsigned char datosGPS[13];
unsigned short tiempo[6];
unsigned short tiempoRPI[6];
unsigned char datosLeidos[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
unsigned char datosFIFO[243];
unsigned char tramaCompleta[2506];
unsigned char tramaSalida[2506];
unsigned short numFIFO, numSetsFIFO;
unsigned short contTimer1;
unsigned char tramaPruebaRS485[10]= {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};

unsigned int i, x, y, i_gps, j;
unsigned short buffer;
unsigned short contMuestras;
unsigned short contCiclos;
unsigned int contFIFO;
short tasaMuestreo;
short numTMR1;

unsigned short banUTI, banUTC;
unsigned short banLec, banEsc, banCiclo, banInicio, banSetReloj, banSetGPS;
unsigned short banMuestrear, banLeer, banConf;

unsigned char byteUART, banTIGPS, banTFGPS, banTCGPS;
unsigned long horaSistema, fechaSistema;

unsigned char byteUART1;
unsigned char tramaCabeceraUART[4];
unsigned char tramaPyloadUART[2506];
unsigned int i_uart;
unsigned int numDatosPyload;

const unsigned int clusterSizeSD = 512;
unsigned int sectorSave = 99;
unsigned long sectorSD = 100;
unsigned char cabeceraSD[6] = {255, 253, 251, 10, 0, 250};
unsigned char bufferSD [clusterSizeSD];
unsigned char contadorEjemploSD = 0;
unsigned char resultSD;

unsigned char tramaCompletaEjemplo[2500];







void ConfiguracionPrincipal();
void Muestrear();
void GuardarBufferSD(unsigned char* bufferLleno, unsigned long sector);
void GuardarTramaSD();
void GuardarSectorSD(unsigned long sector);
void LeerSectorSD();





void main() {

 ConfiguracionPrincipal();

 tasaMuestreo = 1;
 ADXL355_init(tasaMuestreo);
 numTMR1 = (tasaMuestreo*10)-1;

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

 banMuestrear = 0;
 banInicio = 0;
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

 MSRS485 = 0;

 TEST = 0;

 SPI1BUF = 0x00;


 horaSistema = 62700;
 fechaSistema = 60520;


 while (1) {
 if (SD_Detect() ==  0xDE ) {

 sdflags.detected =  1 ;

 break;
 } else {

 sdflags.detected =  0 ;
 sdflags.init_ok =  0 ;

 }
 Delay_ms(100);
 }


 if (sdflags.detected && !sdflags.init_ok) {
 if (SD_Init_Try(10) ==  0xAA ) {
 sdflags.init_ok =  1 ;
 TEST = 1;
 INT1IE_bit = 1;

 } else {
 sdflags.init_ok =  0 ;

 }
 }
 Delay_ms(2000);


 while(1){
 }

}







void ConfiguracionPrincipal(){


 CLKDIVbits.FRCDIV = 0;
 CLKDIVbits.PLLPOST = 0;
 CLKDIVbits.PLLPRE = 5;
 PLLFBDbits.PLLDIV = 150;


 ANSELA = 0;
 ANSELB = 0;
 TEST_Direction = 0;
 CsADXL_Direction = 0;
 sd_CS_tris = 0;
 TRISB12_bit = 0;
 sd_detect_tris = 1;
 TRISB14_bit = 1;


 INTCON2.GIE = 1;


 RPINR18bits.U1RXR = 0x2F;
 RPOR1bits.RP36R = 0x01;
 UART1_Init_Advanced(2000000, 2, 1, 1);
 U1RXIF_bit = 0;
 IPC2bits.U1RXIP = 0x04;
 U1STAbits.URXISEL = 0x00;


 RPINR22bits.SDI2R = 0x21;
 RPOR2bits.RP38R = 0x08;
 RPOR1bits.RP37R = 0x09;
 SPI2STAT.SPIEN = 1;
 SPI2_Init();


 RPINR0 = 0x2E00;
 INT1IF_bit = 0;
 IPC5bits.INT1IP = 0x01;


 T1CON = 0x0020;
 T1CON.TON = 0;
 T1IF_bit = 0;
 PR1 = 62500;
 IPC0bits.T1IP = 0x02;


 U1RXIE_bit = 0;
 INT1IE_bit = 0;
 T1IE_bit = 1;


 ADXL355_write_byte( 0x2D ,  0x04 | 0x01 );


 sdflags.detected =  0 ;
 sdflags.init_ok =  0 ;
 sdflags.saving =  0 ;

 Delay_ms(200);

}




void Muestrear(){

 if (banCiclo==0){

 ADXL355_write_byte( 0x2D ,  0x04 | 0x00 );
 T1CON.TON = 1;

 } else if (banCiclo==1) {

 banCiclo = 2;

 tramaCompleta[0] = contCiclos;
 numFIFO = ADXL355_read_byte( 0x05 );
 numSetsFIFO = (numFIFO)/3;


 for (x=0;x<numSetsFIFO;x++){
 ADXL355_read_FIFO(datosLeidos);
 for (y=0;y<9;y++){
 datosFIFO[y+(x*9)] = datosLeidos[y];
 }
 }


 for (x=0;x<(numSetsFIFO*9);x++){
 if ((x==0)||(x%9==0)){
 tramaCompleta[contFIFO+contMuestras+x] = contMuestras;
 tramaCompleta[contFIFO+contMuestras+x+1] = datosFIFO[x];
 contMuestras++;
 } else {
 tramaCompleta[contFIFO+contMuestras+x] = datosFIFO[x];
 }
 }


 AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
 for (x=0;x<6;x++){
 tramaCompleta[2500+x] = tiempo[x];
 }

 contMuestras = 0;
 contFIFO = 0;
 T1CON.TON = 1;

 banLec = 1;



 }

 contCiclos++;

}




void GuardarBufferSD(unsigned char* bufferLleno, unsigned long sector){

 for (x=0;x<5;x++){
 resultSD = SD_Write_Block(bufferLleno,sector);
 if (resultSD ==  22 ){
 TEST = ~TEST;
 break;
 }
 Delay_us(10);
 }
}




void GuardarTramaSD(){


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





 for (x=0;x<6;x++){
 bufferSD[x] = cabeceraSD[x];
 }

 for (x=0;x<6;x++){
 bufferSD[6+x] = tiempo[x];
 }

 for (x=0;x<500;x++){
 bufferSD[12+x] = tramaSalida[x];
 }

 GuardarBufferSD(bufferSD, sectorSD);

 sectorSD++;


 for (x=0;x<512;x++){
 bufferSD[x] = tramaSalida[x+500];
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 for (x=0;x<512;x++){
 bufferSD[x] = tramaSalida[x+1012];
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 for (x=0;x<512;x++){
 bufferSD[x] = tramaSalida[x+1524];
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 for (x=0;x<512;x++){
 if (x<464){
 bufferSD[x] = tramaSalida[x+2036];
 } else {
 bufferSD[x] = 0;
 }
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 GuardarSectorSD(sectorSD);



}




void GuardarSectorSD(unsigned long sector){



 unsigned char bufferSectores[512];
 bufferSectores[0] = (sector>>24)&0xFF;
 bufferSectores[1] = (sector>>16)&0xFF;
 bufferSectores[2] = (sector>>8)&0xFF;
 bufferSectores[3] = (sector)&0xFF;
 for (x=4;x<512;x++){
 bufferSectores[x] = 0;
 }


 for (x=0;x<5;x++){
 resultSD = SD_Write_Block(bufferSectores,sectorSave);
 if (resultSD ==  22 ){
 TEST = ~TEST;
 break;
 }
 Delay_us(10);
 }

}









void int_1() org IVT_ADDR_INT1INTERRUPT {

 INT1IF_bit = 0;

 TEST = ~TEST;
 horaSistema++;

 EnviarTramaRS485(1, 1, 10, 2, tramaPruebaRS485);

 if (horaSistema==86400){
 horaSistema = 0;
 }

 GuardarTramaSD();
#line 459 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/NodoAcelerometro/NodoAcelerometro.c"
}




void Timer1Int() org IVT_ADDR_T1INTERRUPT{

 T1IF_bit = 0;

 numFIFO = ADXL355_read_byte( 0x05 );
 numSetsFIFO = (numFIFO)/3;


 for (x=0;x<numSetsFIFO;x++){
 ADXL355_read_FIFO(datosLeidos);
 for (y=0;y<9;y++){
 datosFIFO[y+(x*9)] = datosLeidos[y];
 }
 }


 for (x=0;x<(numSetsFIFO*9);x++){
 if ((x==0)||(x%9==0)){
 tramaCompleta[contFIFO+contMuestras+x] = contMuestras;
 tramaCompleta[contFIFO+contMuestras+x+1] = datosFIFO[x];
 contMuestras++;
 } else {
 tramaCompleta[contFIFO+contMuestras+x] = datosFIFO[x];
 }
 }

 contFIFO = (contMuestras*9);

 contTimer1++;

 if (contTimer1==numTMR1){
 T1CON.TON = 0;
 banCiclo = 1;
 contTimer1 = 0;
 }

}




void urx_1() org IVT_ADDR_U1RXINTERRUPT {


 U1RXIF_bit = 0;
 byteUART = U1RXREG;
 OERR_bit = 0;


 if (banUTI==2){
 if (i_uart<numDatosPyload){
 tramaPyloadUART[i_uart] = byteUART;
 i_uart++;
 } else {
 banUTI = 0;
 banUTC = 1;
 }
 }


 if ((banUTI==0)&&(banUTC==0)){
 if (byteUART==0x3A){
 banUTI = 1;
 i_uart = 0;
 }
 }
 if ((banUTI==1)&&(i_uart<4)){
 tramaCabeceraUART[i_uart] = byteUART;
 i_uart++;
 }
 if ((banUTI==1)&&(i_uart==4)){
 numDatosPyload = tramaCabeceraUART[2];
 banUTI = 2;
 i_uart = 0;
 }


 if (banUTC==1){


 for (x=0;x<6;x++) {
 tiempo[x] = tramaPyloadUART[x];
 if (tiempo[x]<59){
 tiempo[x] = tiempo[x]+1;
 }
 }
 banSetReloj=1;



 banUTC = 0;
 }

}
