#line 1 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/NodoAcelerometro/dsPIC502_V2/NodoAcelerometro.c"
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
unsigned long IncrementarFecha(unsigned long longFecha);
void AjustarTiempoSistema(unsigned long longHora, unsigned long longFecha, unsigned char *tramaTiempoSistema);





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

 anio = (short)(longFecha / 10000);
 mes = (short)((longFecha%10000) / 100);
 dia = (short)((longFecha%10000) % 100);

 hora = (short)(longHora / 3600);
 minuto = (short)((longHora%3600) / 60);
 segundo = (short)((longHora%3600) % 60);

 anio = Dec2Bcd(anio);
 dia = Dec2Bcd(dia);
 mes = Dec2Bcd(mes);
 segundo = Dec2Bcd(segundo);
 minuto = Dec2Bcd(minuto);
 hora = Dec2Bcd(hora);

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

 valueRead = DS3234_read_byte( 0x02 );
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

 fechaRTC = (anio*10000)+(mes*100)+(dia);

 SPI2_Init();

 return fechaRTC;

}


unsigned long IncrementarFecha(unsigned long longFecha){

 unsigned long dia;
 unsigned long mes;
 unsigned long anio;
 unsigned long fechaInc;

 anio = longFecha / 10000;
 mes = (longFecha%10000) / 100;
 dia = (longFecha%10000) % 100;

 if (dia<28){
 dia++;
 } else {
 if (mes==2){

 if (((anio-16)%4)==0){
 if (dia==29){
 dia = 1;
 mes++;
 } else {
 dia++;
 }
 } else {
 dia = 1;
 mes++;
 }
 } else {
 if (dia<30){
 dia++;
 } else {
 if (mes==4||mes==6||mes==9||mes==11){
 if (dia==30){
 dia = 1;
 mes++;
 } else {
 dia++;
 }
 }
 if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
 if (dia==31){
 dia = 1;
 mes++;
 } else {
 dia++;
 }
 }
 if ((dia!=1)&&(mes==12)){
 if (dia==31){
 dia = 1;
 mes = 1;
 anio++;
 } else {
 dia++;
 }
 }
 }
 }

 }

 fechaInc = (anio*10000)+(mes*100)+(dia);
 return fechaInc;

}


void AjustarTiempoSistema(unsigned long longHora, unsigned long longFecha, unsigned short *tramaTiempoSistema){

 unsigned short hora;
 unsigned short minuto;
 unsigned short segundo;
 unsigned short dia;
 unsigned short mes;
 unsigned short anio;

 anio = (short)(longFecha / 10000);
 mes = (short)((longFecha%10000) / 100);
 dia = (short)((longFecha%10000) % 100);

 hora = (short)(longHora / 3600);
 minuto = (short)((longHora%3600) / 60);
 segundo = (short)((longHora%3600) % 60);

 tramaTiempoSistema[0] = anio;
 tramaTiempoSistema[1] = mes;
 tramaTiempoSistema[2] = dia;
 tramaTiempoSistema[3] = hora;
 tramaTiempoSistema[4] = minuto;
 tramaTiempoSistema[5] = segundo;

}
#line 1 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/rs485.c"










extern sfr sbit MSRS485;
extern sfr sbit MSRS485_Direction;




void EnviarTramaRS485(unsigned short puertoUART, unsigned short direccion, unsigned short funcion, unsigned int numDatos, unsigned char *payload){

 unsigned int iDatos;
 unsigned char numDatosLSB;
 unsigned char numDatosMSB;
 unsigned char *ptrnumDatos;


 ptrnumDatos = (unsigned char *) & numDatos;
 numDatosLSB = *(ptrnumDatos);
 numDatosMSB = *(ptrnumDatos+1);


 if (puertoUART == 1){
 MSRS485 = 1;
 UART1_Write(0x3A);
 UART1_Write(direccion);
 UART1_Write(funcion);
 UART1_Write(numDatosLSB);
 UART1_Write(numDatosMSB);
 for (iDatos=0;iDatos<numDatos;iDatos++){
 UART1_Write(payload[iDatos]);
 }
 UART1_Write(0x0D);
 UART1_Write(0x0A);
 UART1_Write(0x00);
 while(UART1_Tx_Idle()==0);
 MSRS485 = 0;
 }

 if (puertoUART == 2){
 MSRS485 = 1;
 UART2_Write(0x3A);
 UART2_Write(direccion);
 UART2_Write(funcion);
 UART2_Write(numDatosLSB);
 UART2_Write(numDatosMSB);
 for (iDatos=0;iDatos<numDatos;iDatos++){
 UART2_Write(payload[iDatos]);
 }
 UART2_Write(0x0D);
 UART2_Write(0x0A);
 UART2_Write(0x00);
 while(UART2_Tx_Idle()==0);
 MSRS485 = 0;
 }

}
#line 1 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/tiempo_rpi.c"



unsigned long RecuperarFechaRPI(unsigned short *tramaTiempoRpi);
unsigned long RecuperarHoraRPI(unsigned short *tramaTiempoRpi);




unsigned long RecuperarFechaRPI(unsigned short *tramaTiempoRpi){

 unsigned long fechaRPi;

 fechaRPi = ((long)tramaTiempoRpi[0]*10000)+((long)tramaTiempoRpi[1]*100)+((long)tramaTiempoRpi[2]);

 return fechaRPi;

}


unsigned long RecuperarHoraRPI(unsigned short *tramaTiempoRpi){

 unsigned long horaRPi;

 horaRPi = ((long)tramaTiempoRpi[3]*3600)+((long)tramaTiempoRpi[4]*60)+((long)tramaTiempoRpi[5]);

 return horaRPi;

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
#line 29 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/NodoAcelerometro/dsPIC502_V2/NodoAcelerometro.c"
unsigned int i, j, x, y;


struct sdflags sdflags;
sbit TEST at LATA2_bit;
sbit TEST_Direction at TRISA2_bit;
sbit CsADXL at LATA3_bit;
sbit CsADXL_Direction at TRISA3_bit;
sbit sd_CS_lat at LATB0_bit;
sbit sd_CS_tris at TRISB0_bit;
sbit sd_detect_port at LATA4_bit;
sbit sd_detect_tris at TRISA4_bit;
sbit MSRS485 at LATB12_bit;
sbit MSRS485_Direction at TRISB12_bit;


unsigned short inicioSistema;


unsigned short tiempo[6];
unsigned short banSetReloj;
unsigned short fuenteReloj;
unsigned long horaSistema, fechaSistema;


unsigned short banCiclo, banInicioMuestreo;
unsigned char datosLeidos[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
unsigned char datosFIFO[243];
unsigned char tramaAceleracion[2500];
unsigned short numFIFO, numSetsFIFO;
unsigned short contTimer1;

unsigned short contMuestras;
unsigned short contCiclos;
unsigned int contFIFO;
short tasaMuestreo;
short numTMR1;


unsigned long BAUDRATE2, BRGVAL2;
unsigned short banRSI, banRSC;
unsigned char byteRS485;
unsigned int i_rs485;
unsigned char tramaCabeceraRS485[10];
unsigned char inputPyloadRS485[15];
unsigned char outputPyloadRS485[2600];
unsigned int numDatosRS485;
unsigned char *ptrnumDatosRS485;
unsigned short funcionRS485;
unsigned short subFuncionRS485;
unsigned char tramaPruebaRS485[10]= {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};
unsigned char *ptrsectorReq;
unsigned long sectorReq;


unsigned long PSF;
unsigned long PSE;
unsigned long USF;
unsigned long PSEC;
unsigned long sectorSD;
unsigned long sectorLec;
const unsigned int clusterSizeSD = 512;
unsigned long infoPrimerSector;
unsigned long infoUltimoSector;
unsigned char cabeceraSD[6] = {255, 253, 251, 10, 0, 250};
unsigned char bufferSD [clusterSizeSD];
unsigned char checkEscSD;
unsigned char checkLecSD;
unsigned short banInsSec;






void ConfiguracionPrincipal();
void Muestrear();
void GuardarBufferSD(unsigned char* bufferLleno, unsigned long sector);
void GuardarTramaSD(unsigned char* tiempoSD, unsigned char* aceleracionSD);
void GuardarInfoSector(unsigned long sector, unsigned long localizacionSector);
unsigned long UbicarPrimerSectorEscrito();
unsigned long UbicarUltimoSectorEscrito(unsigned short sobrescribirSD);
void InformacionSectores();
void InspeccionarSector(unsigned short estadoMuestreo, unsigned long sectorReq);
void RecuperarTramaAceleracion(unsigned long sectorReq);






void main() {

 ConfiguracionPrincipal();
 TEST = 0;

 tasaMuestreo = 1;
 ADXL355_init(tasaMuestreo);
 numTMR1 = (tasaMuestreo*10)-1;




 i = 0;
 j = 0;
 x = 0;
 y = 0;


 inicioSistema = 0;


 banSetReloj = 0;
 horaSistema = 0;
 fechaSistema = 0;
 fuenteReloj = 2;


 banCiclo = 0;
 banInicioMuestreo = 0;
 numFIFO = 0;
 numSetsFIFO = 0;
 contTimer1 = 0;
 contMuestras = 0;
 contCiclos = 0;
 contFIFO = 0;


 banRSI = 0;
 banRSC = 0;
 byteRS485 = 0;
 i_rs485 = 0;
 funcionRS485 = 0;
 subFuncionRS485 = 0;
 numDatosRS485 = 0;
 ptrnumDatosRS485 = (unsigned char *) & numDatosRS485;
 ptrsectorReq = (unsigned char *) & sectorReq;


 PSEC = 0;
 sectorSD = 0;
 sectorLec = 0;
 checkEscSD = 0;
 checkLecSD = 0;
 MSRS485 = 0;
 banInsSec = 0;


 switch ( 8 ){
 case 2:
 PSF = 2048;
 USF = 3911679;
 break;
 case 4:
 PSF = 2048;
 USF = 7772160;
 break;
 case 8:
 PSF = 2048;

 USF = 16779263;
 break;
 case 16:
 PSF = 2048;
 USF = 31115263;
 break;
 }
 infoPrimerSector = PSF+ 97952 -2;
 infoUltimoSector = PSF+ 97952 -1;
 PSE = PSF+ 97952 ;






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
 inicioSistema = 1;
 TEST = 1;
 } else {
 sdflags.init_ok =  0 ;
 INT1IE_bit = 0;
 U1MODE.UARTEN = 0;
 inicioSistema = 0;
 TEST = 0;
 }
 }
 Delay_ms(2000);


 while(1){
 asm CLRWDT;
 Delay_ms(100);
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
 MSRS485_Direction = 0;
 sd_detect_tris = 1;

 TRISB13_bit = 1;


 INTCON2.GIE = 1;


 RPINR18bits.U1RXR = 0x2F;
 RPOR1bits.RP36R = 0x01;
 U1RXIE_bit = 1;
 U1STAbits.URXISEL = 0x00;
 U1RXIF_bit = 0;
 IPC2bits.U1RXIP = 0x04;
 UART1_Init_Advanced(2000000, _UART_8BIT_NOPARITY, _UART_ONE_STOPBIT, _UART_HI_SPEED);


 RPINR22bits.SDI2R = 0x21;
 RPOR2bits.RP38R = 0x08;
 RPOR1bits.RP37R = 0x09;
 SPI2STAT.SPIEN = 1;
 SPI2_Init();



 RPINR0 = 0x2D00;
 INT1IE_bit = 1;
 INT1IF_bit = 0;
 IPC5bits.INT1IP = 0x01;


 T1CON = 0x0020;
 T1CON.TON = 0;
 T1IE_bit = 1;
 T1IF_bit = 0;
 PR1 = 62500;
 IPC0bits.T1IP = 0x02;


 T2CON = 0x0020;
 T2CON.TON = 0;
 T2IE_bit = 1;
 T2IF_bit = 0;
 PR2 = 62500;
 IPC1bits.T2IP = 0x02;


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

 tramaAceleracion[0] = fuenteReloj;
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
 tramaAceleracion[contFIFO+contMuestras+x] = contMuestras;
 tramaAceleracion[contFIFO+contMuestras+x+1] = datosFIFO[x];
 contMuestras++;
 } else {
 tramaAceleracion[contFIFO+contMuestras+x] = datosFIFO[x];
 }
 }

 contMuestras = 0;
 contFIFO = 0;
 T1CON.TON = 1;


 GuardarTramaSD(tiempo, tramaAceleracion);


 if (banInsSec==1){
 InspeccionarSector(1, sectorReq);
 }

 }

 contCiclos++;

}




void GuardarBufferSD(unsigned char* bufferLleno, unsigned long sector){

 for (x=0;x<5;x++){
 checkEscSD = SD_Write_Block(bufferLleno,sector);
 if (checkEscSD ==  22 ){
 break;
 }
 Delay_us(10);
 }
}




void GuardarTramaSD(unsigned char* tiempoSD, unsigned char* aceleracionSD){






 for (x=0;x<6;x++){
 bufferSD[x] = cabeceraSD[x];
 }

 for (x=0;x<6;x++){
 bufferSD[6+x] = tiempoSD[x];
 }

 for (x=0;x<500;x++){
 bufferSD[12+x] = aceleracionSD[x];
 }

 GuardarBufferSD(bufferSD, sectorSD);

 sectorSD++;


 for (x=0;x<512;x++){
 bufferSD[x] = aceleracionSD[x+500];
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 for (x=0;x<512;x++){
 bufferSD[x] = aceleracionSD[x+1012];
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 for (x=0;x<512;x++){
 bufferSD[x] = aceleracionSD[x+1524];
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 for (x=0;x<512;x++){
 if (x<464){
 bufferSD[x] = aceleracionSD[x+2036];
 } else {
 bufferSD[x] = 0;
 }
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 if (horaSistema%300==0){
 GuardarInfoSector(sectorSD, infoUltimoSector);
 }

 TEST = 0;

}




void GuardarInfoSector(unsigned long datoSector, unsigned long localizacionSector){



 unsigned char bufferSectores[512];
 bufferSectores[0] = (datoSector>>24)&0xFF;
 bufferSectores[1] = (datoSector>>16)&0xFF;
 bufferSectores[2] = (datoSector>>8)&0xFF;
 bufferSectores[3] = (datoSector)&0xFF;
 for (x=4;x<512;x++){
 bufferSectores[x] = 0;
 }


 for (x=0;x<5;x++){
 checkEscSD = SD_Write_Block(bufferSectores,localizacionSector);
 if (checkEscSD ==  22 ){

 break;
 }
 Delay_us(10);
 }

}




unsigned long UbicarPrimerSectorEscrito(){

 unsigned char bufferSectorInicio[512];
 unsigned long primerSectorSD;
 unsigned char *ptrPrimerSectorSD;

 ptrPrimerSectorSD = (unsigned char *) & primerSectorSD;

 checkLecSD = 1;

 for (x=0;x<5;x++){

 checkLecSD = SD_Read_Block(bufferSectorInicio, infoPrimerSector);

 if (checkLecSD==0) {

 *ptrPrimerSectorSD = bufferSectorInicio[3];
 *(ptrPrimerSectorSD+1) = bufferSectorInicio[2];
 *(ptrPrimerSectorSD+2) = bufferSectorInicio[1];
 *(ptrPrimerSectorSD+3) = bufferSectorInicio[0];
 break;
 Delay_ms(5);
 } else {
 primerSectorSD = PSE;
 }
 }


 return primerSectorSD;

}




unsigned long UbicarUltimoSectorEscrito(unsigned short sobrescribirSD){

 unsigned char bufferSectorFinal[512];
 unsigned long sectorInicioSD;
 unsigned char *ptrSectorInicioSD;

 ptrSectorInicioSD = (unsigned char *) & sectorInicioSD;


 if (sobrescribirSD==1){
 sectorInicioSD = PSE;
 } else {
 checkLecSD = 1;

 for (x=0;x<5;x++){

 checkLecSD = SD_Read_Block(bufferSectorFinal, infoUltimoSector);

 if (checkLecSD==0) {

 *ptrSectorInicioSD = bufferSectorFinal[3];
 *(ptrSectorInicioSD+1) = bufferSectorFinal[2];
 *(ptrSectorInicioSD+2) = bufferSectorFinal[1];
 *(ptrSectorInicioSD+3) = bufferSectorFinal[0];
 break;
 Delay_ms(5);
 } else {
 sectorInicioSD = PSE;
 }
 }
 }

 return sectorInicioSD;

}




void InformacionSectores(){

 unsigned char tramaInfoSec[20];

 unsigned long infoPSF;
 unsigned long infoPSE;
 unsigned long infoPSEC;
 unsigned long infoSA;

 unsigned char *ptrPSF;
 unsigned char *ptrPSE;
 unsigned char *ptrPSEC;
 unsigned char *ptrSA;

 infoPSF = PSF;
 infoPSE = PSE;


 ptrPSF = (unsigned char *) & infoPSF;
 ptrPSE = (unsigned char *) & infoPSE;
 ptrPSEC = (unsigned char *) & infoPSEC;
 ptrSA = (unsigned char *) & infoSA;


 if (banInicioMuestreo==0){
 infoPSEC = UbicarPrimerSectorEscrito();
 infoSA = UbicarUltimoSectorEscrito(0);
 } else {
 infoSA = sectorSD - 1;
 infoPSEC = PSEC;
 }

 tramaInfoSec[0] = 0xD1;
 tramaInfoSec[1] = *ptrPSF;
 tramaInfoSec[2] = *(ptrPSF+1);
 tramaInfoSec[3] = *(ptrPSF+2);
 tramaInfoSec[4] = *(ptrPSF+3);
 tramaInfoSec[5] = *ptrPSE;
 tramaInfoSec[6] = *(ptrPSE+1);
 tramaInfoSec[7] = *(ptrPSE+2);
 tramaInfoSec[8] = *(ptrPSE+3);
 tramaInfoSec[9] = *ptrPSEC;
 tramaInfoSec[10] = *(ptrPSEC+1);
 tramaInfoSec[11] = *(ptrPSEC+2);
 tramaInfoSec[12] = *(ptrPSEC+3);
 tramaInfoSec[13] = *ptrSA;
 tramaInfoSec[14] = *(ptrSA+1);
 tramaInfoSec[15] = *(ptrSA+2);
 tramaInfoSec[16] = *(ptrSA+3);

 EnviarTramaRS485(1,  2 , 0xF3, 17, tramaInfoSec);

}




void InspeccionarSector(unsigned short estadoMuestreo, unsigned long sectorReq){

 unsigned char tramaDatosSec[15];
 unsigned char bufferSectorReq[512];
 unsigned int numDatosSec;
 unsigned int contadorSector;
 unsigned long USE;


 if (estadoMuestreo==0){
 USE = UbicarUltimoSectorEscrito(0);
 } else {
 USE = sectorSD - 1;
 }

 tramaDatosSec[0] = 0xD2;


 if ((sectorReq>=PSE)&&(sectorReq<USF)){

 if (sectorReq<USE){
 checkLecSD = 1;

 for (x=0;x<5;x++){

 checkLecSD = SD_Read_Block(bufferSectorReq, sectorReq);

 if (checkLecSD==0) {

 numDatosSec = 14;
 for (y=0;y<numDatosSec;y++){
 tramaDatosSec[y+1] = bufferSectorReq[y];
 }
 break;
 } else {

 numDatosSec = 3;
 tramaDatosSec[1] = 0xEE;
 tramaDatosSec[2] = 0xE3;
 }
 Delay_us(10);
 }
 } else {

 numDatosSec = 3;
 tramaDatosSec[1] = 0xEE;
 tramaDatosSec[2] = 0xE2;
 }

 } else {


 numDatosSec = 3;
 tramaDatosSec[1] = 0xEE;
 tramaDatosSec[2] = 0xE1;

 }

 banInsSec = 0;
 EnviarTramaRS485(1,  2 , 0xF3, numDatosSec, tramaDatosSec);

}




void RecuperarTramaAceleracion(unsigned long sectorReq){

 unsigned char tramaAcelSeg[2515];
 unsigned char bufferSectorReq[512];
 unsigned short tiempoAcel[6];
 unsigned long contSector;
 unsigned int numDatosTramaAcel;
 unsigned short banLecturaCorrecta;

 tramaAcelSeg[0] = 0xD3;
 contSector = 0;
 banLecturaCorrecta = 0;
 numDatosTramaAcel = 2513;


 checkLecSD = 1;

 for (x=0;x<5;x++){
 checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
 if (checkLecSD==0) {

 for (y=0;y<6;y++){
 tiempoAcel[y] = bufferSectorReq[y+6];
 }

 for (y=0;y<6;y++){
 tramaAcelSeg[y+1] = bufferSectorReq[y];
 }

 for (y=0;y<500;y++){
 tramaAcelSeg[y+7] = bufferSectorReq[y+12];
 }
 banLecturaCorrecta = 1;
 contSector++;
 break;
 } else {

 tramaAcelSeg[1] = 0xEE;
 tramaAcelSeg[2] = 0xE3;
 numDatosTramaAcel = 3;
 banLecturaCorrecta = 2;
 }
 Delay_us(10);
 }


 if (banLecturaCorrecta==1){
 checkLecSD = 1;

 for (x=0;x<5;x++){
 checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
 if (checkLecSD==0) {

 for (y=0;y<512;y++){
 tramaAcelSeg[y+507] = bufferSectorReq[y];
 }
 banLecturaCorrecta = 1;
 contSector++;
 break;
 } else {

 tramaAcelSeg[1] = 0xEE;
 tramaAcelSeg[2] = 0xE3;
 numDatosTramaAcel = 3;
 banLecturaCorrecta = 2;
 }
 Delay_us(10);
 }
 }


 if (banLecturaCorrecta==1){
 checkLecSD = 1;

 for (x=0;x<5;x++){
 checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
 if (checkLecSD==0) {

 for (y=0;y<512;y++){
 tramaAcelSeg[y+1019] = bufferSectorReq[y];
 }
 banLecturaCorrecta = 1;
 contSector++;
 break;
 } else {

 tramaAcelSeg[1] = 0xEE;
 tramaAcelSeg[2] = 0xE3;
 numDatosTramaAcel = 3;
 banLecturaCorrecta = 2;
 }
 Delay_us(10);
 }
 }


 if (banLecturaCorrecta==1){
 checkLecSD = 1;

 for (x=0;x<5;x++){
 checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
 if (checkLecSD==0) {

 for (y=0;y<512;y++){
 tramaAcelSeg[y+1531] = bufferSectorReq[y];
 }
 banLecturaCorrecta = 1;
 contSector++;
 break;
 } else {

 tramaAcelSeg[1] = 0xEE;
 tramaAcelSeg[2] = 0xE3;
 numDatosTramaAcel = 3;
 banLecturaCorrecta = 2;
 }
 Delay_us(10);
 }
 }


 if (banLecturaCorrecta==1){
 checkLecSD = 1;

 for (x=0;x<5;x++){
 checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
 if (checkLecSD==0) {

 for (y=0;y<464;y++){
 tramaAcelSeg[y+2043] = bufferSectorReq[y];
 }
 banLecturaCorrecta = 1;
 break;
 } else {

 tramaAcelSeg[1] = 0xEE;
 tramaAcelSeg[2] = 0xE3;
 numDatosTramaAcel = 3;
 banLecturaCorrecta = 2;
 }
 Delay_us(10);
 }
 }


 if (banLecturaCorrecta==1){
 for (x=0;x<6;x++){
 tramaAcelSeg[2507+x] = tiempoAcel[x];
 }
 TEST = ~TEST;
 }


 EnviarTramaRS485(1,  2 , 0xF3, numDatosTramaAcel, tramaAcelSeg);

}




void GuardarPruebaSD(unsigned char* tiempoSD){

 unsigned short contadorEjemploSD;
 unsigned char aceleracionSD[2506];





 contadorEjemploSD = 0;
 for (x=0;x<2500;x++){
 aceleracionSD[x] = contadorEjemploSD;
 contadorEjemploSD ++;
 if (contadorEjemploSD >= 255){
 contadorEjemploSD = 0;
 }
 }


 for (x=0;x<6;x++){
 bufferSD[x] = cabeceraSD[x];
 }

 for (x=0;x<6;x++){
 bufferSD[6+x] = tiempoSD[x];
 }

 for (x=0;x<500;x++){
 bufferSD[12+x] = aceleracionSD[x];
 }

 GuardarBufferSD(bufferSD, sectorSD);

 sectorSD++;


 for (x=0;x<512;x++){
 bufferSD[x] = aceleracionSD[x+500];
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 for (x=0;x<512;x++){
 bufferSD[x] = aceleracionSD[x+1012];
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 for (x=0;x<512;x++){
 bufferSD[x] = aceleracionSD[x+1524];
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 for (x=0;x<512;x++){
 if (x<464){
 bufferSD[x] = aceleracionSD[x+2036];
 } else {
 bufferSD[x] = 0;
 }
 }
 GuardarBufferSD(bufferSD, sectorSD);
 sectorSD++;


 if (horaSistema%300==0){
 GuardarInfoSector(sectorSD, infoUltimoSector);
 }

 TEST = 0;

}










void int_1() org IVT_ADDR_INT1INTERRUPT {

 INT1IF_bit = 0;


 if ((horaSistema==0)&&(banInicioMuestreo==1)){
 PSEC = sectorSD;
 GuardarInfoSector(PSEC, infoPrimerSector);
 }

 if (banSetReloj==1){
 horaSistema++;
 if (horaSistema==86400){
 horaSistema = 0;
 fechaSistema = IncrementarFecha(fechaSistema);
 }
 AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
 TEST = ~TEST;
 }

 if (banInicioMuestreo==1){
 Muestrear();

 }

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
 tramaAceleracion[contFIFO+contMuestras+x] = contMuestras;
 tramaAceleracion[contFIFO+contMuestras+x+1] = datosFIFO[x];
 contMuestras++;
 } else {
 tramaAceleracion[contFIFO+contMuestras+x] = datosFIFO[x];
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




void Timer2Int() org IVT_ADDR_T2INTERRUPT{

 T2IF_bit = 0;
 T2CON.TON = 0;


 banRSI = 0;
 banRSC = 0;
 i_rs485 = 0;

}




void urx_1() org IVT_ADDR_U1RXINTERRUPT {


 U1RXIF_bit = 0;
 byteRS485 = U1RXREG;
 OERR_bit = 0;


 if (banRSI==2){

 if (i_rs485<(numDatosRS485)){
 inputPyloadRS485[i_rs485] = byteRS485;
 i_rs485++;
 } else {
 T2CON.TON = 0;
 banRSI = 0;
 banRSC = 1;
 }
 }


 if ((banRSI==0)&&(banRSC==0)){
 if (byteRS485==0x3A){

 banRSI = 1;
 i_rs485 = 0;
 }
 }
 if ((banRSI==1)&&(i_rs485<5)){
 tramaCabeceraRS485[i_rs485] = byteRS485;
 i_rs485++;
 }
 if ((banRSI==1)&&(i_rs485==5)){

 if ((tramaCabeceraRS485[1]== 2 )||(tramaCabeceraRS485[1]==255)){
 funcionRS485 = tramaCabeceraRS485[2];
 *(ptrnumDatosRS485) = tramaCabeceraRS485[3];
 *(ptrnumDatosRS485+1) = tramaCabeceraRS485[4];
 banRSI = 2;
 i_rs485 = 0;
 } else {
 banRSI = 0;
 banRSC = 0;
 i_rs485 = 0;
 }
 }


 if (banRSC==1){
 subFuncionRS485 = inputPyloadRS485[0];
 switch (funcionRS485){

 case 0xF1:


 if (subFuncionRS485==0xD1){
 for (x=0;x<6;x++) {
 tiempo[x] = inputPyloadRS485[x+1];
 }
 horaSistema = RecuperarHoraRPI(tiempo);
 fechaSistema = RecuperarFechaRPI(tiempo);
 fuenteReloj = inputPyloadRS485[7];
 banSetReloj = 1;
 }

 if (subFuncionRS485==0xD2){

 outputPyloadRS485[0] = 0xD2;
 for (x=0;x<6;x++){
 outputPyloadRS485[x+1] = tiempo[x];
 }
 outputPyloadRS485[7] = fuenteReloj;
 EnviarTramaRS485(1,  2 , 0xF1, 8, outputPyloadRS485);
 }
 break;

 case 0xF2:


 if ((subFuncionRS485==0xD1)&&(banInicioMuestreo==0)){
 sectorSD = UbicarUltimoSectorEscrito(inputPyloadRS485[1]);
 PSEC = sectorSD;
 GuardarInfoSector(PSEC, infoPrimerSector);
 banInicioMuestreo = 1;
 }

 if ((subFuncionRS485==0xD2)&&(banInicioMuestreo==1)){
 GuardarInfoSector(sectorSD, infoUltimoSector);
 banInicioMuestreo = 0;
 }
 break;

 case 0xF3:


 *ptrsectorReq = inputPyloadRS485[1];
 *(ptrsectorReq+1) = inputPyloadRS485[2];
 *(ptrsectorReq+2) = inputPyloadRS485[3];
 *(ptrsectorReq+3) = inputPyloadRS485[4];


 if (subFuncionRS485==0xD1){

 InformacionSectores();
 }

 if (subFuncionRS485==0xD2){

 if (banInicioMuestreo==0){

 InspeccionarSector(0, sectorReq);
 } else {

 banInsSec=1;
 }
 }

 if (subFuncionRS485==0xD3){


 if (banInicioMuestreo==0){
 RecuperarTramaAceleracion(sectorReq);
 }
 }
 break;

 }

 banRSC = 0;
 banRSI = 0;

 }

}
