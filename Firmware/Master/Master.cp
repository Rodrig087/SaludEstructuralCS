#line 1 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/Master/Master.c"
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

 hora = (short)(longHora / 3600);
 minuto = (short)((longHora%3600) / 60);
 segundo = (short)((longHora%3600) % 60);

 anio = (short)(longFecha / 10000);
 mes = (short)((longFecha%10000) / 100);
 dia = (short)((longFecha%10000) % 100);

 tramaTiempoSistema[0] = anio;
 tramaTiempoSistema[1] = mes;
 tramaTiempoSistema[2] = dia;
 tramaTiempoSistema[3] = hora;
 tramaTiempoSistema[4] = minuto;
 tramaTiempoSistema[5] = segundo;

}
#line 1 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/tiempo_gps.c"




void GPS_init(short conf,short NMA);
unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS);
unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS);





void GPS_init(short conf,short NMA){
#line 45 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/tiempo_gps.c"
 UART1_Write_Text("$PMTK605*31\r\n");
 UART1_Write_Text("$PMTK220,1000*1F\r\n");
 UART1_Write_Text("$PMTK251,115200*1F\r\n");
 Delay_ms(1000);
 UART1_Init(115200);
 UART1_Write_Text("$PMTK313,1*2E\r\n");
 UART1_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29\r\n");
 UART1_Write_Text("$PMTK319,1*24\r\n");
 UART1_Write_Text("$PMTK413*34\r\n");
 UART1_Write_Text("$PMTK513,1*28\r\n");
 Delay_ms(1000);
}




unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS){

 unsigned long tramaFecha[4];
 unsigned long fechaGPS;
 char datoStringF[3];
 char *ptrDatoStringF = &datoStringF;
 datoStringF[2] = '\0';
 tramaFecha[3] = '\0';


 datoStringF[0] = tramaDatosGPS[6];
 datoStringF[1] = tramaDatosGPS[7];
 tramaFecha[0] = atoi(ptrDatoStringF);


 datoStringF[0] = tramaDatosGPS[8];
 datoStringF[1] = tramaDatosGPS[9];
 tramaFecha[1] = atoi(ptrDatoStringF);


 datoStringF[0] = tramaDatosGPS[10];
 datoStringF[1] = tramaDatosGPS[11];
 tramaFecha[2] = atoi(ptrDatoStringF);

 fechaGPS = (tramaFecha[0]*10000)+(tramaFecha[1]*100)+(tramaFecha[2]);

 return fechaGPS;

}


unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS){

 unsigned long tramaTiempo[4];
 unsigned long horaGPS;
 char datoString[3];
 char *ptrDatoString = &datoString;
 datoString[2] = '\0';
 tramaTiempo[3] = '\0';


 datoString[0] = tramaDatosGPS[0];
 datoString[1] = tramaDatosGPS[1];
 tramaTiempo[0] = atoi(ptrDatoString);


 datoString[0] = tramaDatosGPS[2];
 datoString[1] = tramaDatosGPS[3];
 tramaTiempo[1] = atoi(ptrDatoString);


 datoString[0] = tramaDatosGPS[4];
 datoString[1] = tramaDatosGPS[5];
 tramaTiempo[2] = atoi(ptrDatoString);

 horaGPS = (tramaTiempo[0]*3600)+(tramaTiempo[1]*60)+(tramaTiempo[2]);
 return horaGPS;

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
#line 1 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/rs485.c"










extern sfr sbit MSRS485;
extern sfr sbit MSRS485_Direction;




void EnviarTramaRS485(unsigned short puertoUART, unsigned short direccion, unsigned short funcion, unsigned short numDatos, unsigned char *payload){

 unsigned int iDatos;

 if (puertoUART == 1){
 MSRS485 = 1;
 UART1_Write(0x3A);
 UART1_Write(direccion);
 UART1_Write(funcion);
 UART1_Write(numDatos);
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
 UART2_Write(funcion);
 UART2_Write(numDatos);
 for (iDatos=0;iDatos<numDatos;iDatos++){
 UART2_Write(payload[iDatos]);
 }
 UART2_Write(0x0D);
 UART2_Write(0x0A);
 while(UART2_Tx_Idle()==0);
 MSRS485 = 0;
 }

}
#line 21 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/Master/Master.c"
unsigned int i, j, x, y;


sbit RP1 at LATA4_bit;
sbit RP1_Direction at TRISA4_bit;
sbit MSRS485 at LATB11_bit;
sbit MSRS485_Direction at TRISB11_bit;

sbit INT_SINC at LATA1_bit;
sbit INT_SINC_Direction at TRISA1_bit;
sbit INT_SINC1 at LATA0_bit;
sbit INT_SINC1_Direction at TRISA0_bit;
sbit INT_SINC2 at LATA3_bit;
sbit INT_SINC2_Direction at TRISA3_bit;
sbit INT_SINC3 at LATB10_bit;
sbit INT_SINC3_Direction at TRISB10_bit;
sbit INT_SINC4 at LATB12_bit;
sbit INT_SINC4_Direction at TRISB12_bit;







unsigned int i_gps;
unsigned char byteGPS, banTIGPS, banTFGPS, banTCGPS;
unsigned short banSetGPS;
unsigned char tramaGPS[70];
unsigned char datosGPS[13];


unsigned short tiempo[6];
unsigned short tiempoRPI[6];
unsigned short banSetReloj;
unsigned short fuenteReloj;
unsigned long horaSistema, fechaSistema;
unsigned short referenciaTiempo;


unsigned short bufferSPI;
unsigned short banLec, banEsc;
unsigned char *ptrnumBytesSPI;
unsigned char tramaSolicitudSPI[10];
unsigned char tramaCompleta[2506];
unsigned char tramaPrueba[10];
unsigned short banInicio;
unsigned short banOperacion;
unsigned short banCheckRS485;
unsigned short banSPI0, banSPI1, banSPI2, banSPI3, banSPI4, banSPI5, banSPI6, banSPI7, banSPI8, banSPI9, banSPIA;


unsigned short banRSI, banRSC;
unsigned char byteRS485;
unsigned int i_rs485;
unsigned char tramaCabeceraRS485[4];
unsigned char inputPyloadRS485[512];
unsigned char outputPyloadRS485[10];
unsigned short direccionRS485;
unsigned short funcionRS485;
unsigned short subFuncionRS485;
unsigned int numDatosRS485;
unsigned char tramaPruebaRS485[10]= {10, 11, 12, 13, 14, 15, 16, 17, 18, 19};


unsigned short banInicioMuestreo;







void ConfiguracionPrincipal();
void Muestrear();
void InterrupcionP1(unsigned short funcionSPI, unsigned short subFuncionSPI, unsigned int numBytesSPI);





void main() {

 ConfiguracionPrincipal();
 DS3234_init();





 i = 0;
 j = 0;
 x = 0;
 y = 0;


 banSPI0 = 0;
 banSPI1 = 0;
 banSPI2 = 0;
 banSPI3 = 0;
 banSPI4 = 0;
 banSPI5 = 0;
 banSPI6 = 0;
 banSPI7 = 0;
 banSPI8 = 0;
 banSPI9 = 0;
 banSPIA = 0;


 i_gps = 0;
 byteGPS = 0;
 banTIGPS = 0;
 banTFGPS = 0;
 banTCGPS = 0;
 banSetGPS = 0;


 banSetReloj = 0;
 horaSistema = 0;
 fechaSistema = 0;
 fuenteReloj = 0;
 referenciaTiempo = 0;


 banRSI = 0;
 banRSC = 0;
 byteRS485 = 0;
 i_rs485 = 0;
 numDatosRS485 = 0;
 funcionRS485 = 0;
 subFuncionRS485 = 0;


 banInicioMuestreo = 0;


 RP1 = 0;
 INT_SINC = 1;
 INT_SINC1 = 0;
 INT_SINC2 = 0;
 INT_SINC3 = 0;
 INT_SINC4 = 0;

 MSRS485 = 0;

 SPI1BUF = 0x00;

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

 TRISA2_bit = 0;
 INT_SINC_Direction = 0;
 INT_SINC1_Direction = 0;
 INT_SINC2_Direction = 0;
 INT_SINC3_Direction = 0;
 INT_SINC4_Direction = 0;
 RP1_Direction = 0;
 MSRS485_Direction = 0;

 TRISB13_bit = 1;
 TRISB14_bit = 1;

 INTCON2.GIE = 1;


 RPINR18bits.U1RXR = 0x22;
 RPOR0bits.RP35R = 0x01;
 U1RXIE_bit = 0;
 U1RXIF_bit = 0;
 IPC2bits.U1RXIP = 0x04;
 U1STAbits.URXISEL = 0x00;
 UART1_Init(9600);


 RPINR19bits.U2RXR = 0x2F;
 RPOR1bits.RP36R = 0x03;
 U2RXIE_bit = 1;
 U2STAbits.URXISEL = 0x00;
 IPC7bits.U2RXIP = 0x04;
 U2STAbits.URXISEL = 0x00;
 UART2_Init_Advanced(2000000, _UART_8BIT_NOPARITY, _UART_ONE_STOPBIT, _UART_HI_SPEED);


 SPI1STAT.SPIEN = 1;
 SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
 SPI1IF_bit = 0;
 IPC2bits.SPI1IP = 0x03;


 RPINR22bits.SDI2R = 0x21;
 RPOR2bits.RP38R = 0x08;
 RPOR1bits.RP37R = 0x09;
 SPI2STAT.SPIEN = 1;
 SPI2_Init();
 CS_DS3234 = 1;


 RPINR0 = 0x2D00;

 INT1IF_bit = 0;
 IPC5bits.INT1IP = 0x01;


 SPI1IE_bit = 1;
 INT1IE_bit = 0;

 Delay_ms(200);

}




 void InterrupcionP1(unsigned short funcionSPI, unsigned short subFuncionSPI, unsigned int numBytesSPI){


 if ((funcionSPI==0xB1)&&(subFuncionSPI==0xD1)){
 if (INT1IE_bit==0){
 INT1IE_bit = 1;
 }

 outputPyloadRS485[0] = 0xD1;
 for (x=1;x<7;x++){
 outputPyloadRS485[x] = tiempo[x-1];
 }
 EnviarTramaRS485(2, 255, 0xF1, 7, outputPyloadRS485);
 }


 ptrnumBytesSPI = (unsigned char *) & numBytesSPI;


 tramaSolicitudSPI[0] = funcionSPI;
 tramaSolicitudSPI[1] = subFuncionSPI;
 tramaSolicitudSPI[2] = *(ptrnumBytesSPI);
 tramaSolicitudSPI[3] = *(ptrnumBytesSPI+1);


 RP1 = 1;
 Delay_us(20);
 RP1 = 0;

}









void spi_1() org IVT_ADDR_SPI1INTERRUPT {

 SPI1IF_bit = 0;
 bufferSPI = SPI1BUF;



 if ((banSPI0==0)&&(bufferSPI==0xA0)) {
 banSPI0 = 1;
 i = 1;
 SPI1BUF = tramaSolicitudSPI[0];
 }
 if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
 SPI1BUF = tramaSolicitudSPI[i];
 i++;
 }
 if ((banSPI0==1)&&(bufferSPI==0xF0)){
 banSPI0 = 0;
 }






 if ((banSPI1==0)&&(bufferSPI==0xA1)){
 banSPI1 = 1;
 i = 0;
 }
 if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
 tramaSolicitudSPI[i] = bufferSPI;
 i++;
 }
 if ((banSPI1==1)&&(bufferSPI==0xF1)){
 direccionRS485 = tramaSolicitudSPI[0];
 outputPyloadRS485[0] = 0xD1;
 outputPyloadRS485[1] = tramaSolicitudSPI[1];
 EnviarTramaRS485(2, direccionRS485, 0xF2, 2, outputPyloadRS485);
 banSPI1 = 0;
 }


 if ((banSPI2==0)&&(bufferSPI==0xA2)){
 banSPI2 = 1;
 i = 0;
 }
 if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
 tramaSolicitudSPI[i] = bufferSPI;
 }
 if ((banSPI2==1)&&(bufferSPI==0xF2)){
 direccionRS485 = tramaSolicitudSPI[0];
 outputPyloadRS485[0] = 0xD2;
 EnviarTramaRS485(2, direccionRS485, 0xF2, 1, outputPyloadRS485);
 banSPI2 = 0;
 }


 if ((banLec==1)&&(bufferSPI==0xA3)){
 banLec = 2;
 i = 0;
 SPI1BUF = tramaCompleta[i];
 }
 if ((banLec==2)&&(bufferSPI!=0xF3)){
 SPI1BUF = tramaCompleta[i];
 i++;
 }
 if ((banLec==2)&&(bufferSPI==0xF3)){
 banLec = 0;
 SPI1BUF = 0xFF;
 }







 if ((banSetReloj==0)&&(bufferSPI==0xA4)){
 banSPI4 = 1;
 j = 0;
 }
 if ((banSPI4==1)&&(bufferSPI!=0xA4)&&(bufferSPI!=0xF4)){
 tiempoRPI[j] = bufferSPI;
 j++;
 }
 if ((banSPI4==1)&&(bufferSPI==0xF4)){
 horaSistema = RecuperarHoraRPI(tiempoRPI);
 fechaSistema = RecuperarFechaRPI(tiempoRPI);




 AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
 banSPI4 = 0;
 banSetReloj = 1;
 InterrupcionP1(0xB1,0xD1,6);
 }



 if ((banSetReloj==1)&&(bufferSPI==0xA5)){
 banSPI5 = 1;
 j = 0;
 SPI1BUF = fuenteReloj;
 }
 if ((banSPI5==1)&&(bufferSPI!=0xA5)&&(bufferSPI!=0xF5)){
 SPI1BUF = tiempo[j];
 j++;
 }
 if ((banSPI5==1)&&(bufferSPI==0xF5)){
 banSPI5 = 0;
 banSetReloj = 0;
 }



 if ((banSetReloj==0)&&(bufferSPI==0xA6)){
 banSPI6 = 1;
 }
 if ((banSPI6==1)&&(bufferSPI!=0xA6)&&(bufferSPI!=0xF6)){
 referenciaTiempo = bufferSPI;
 }
 if ((banSPI6==1)&&(bufferSPI==0xF6)){
 banSPI6 = 0;
 if (referenciaTiempo==1){

 banTIGPS = 0;
 banTCGPS = 0;
 i_gps = 0;

 if (U1RXIE_bit==0){
 U1RXIE_bit = 1;
 }
 } else {

 horaSistema = RecuperarHoraRTC();
 fechaSistema = RecuperarFechaRTC();
 AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
 fuenteReloj = 0;
 banSetReloj = 1;
 InterrupcionP1(0xB1,0xD1,6);
 }
 }



 if ((banSetReloj==0)&&(bufferSPI==0xA7)){
 banSPI7 = 1;
 }
 if ((banSPI7==1)&&(bufferSPI!=0xA7)&&(bufferSPI!=0xF7)){
 direccionRS485 = bufferSPI;
 }
 if ((banSPI7==1)&&(bufferSPI==0xF7)){
 outputPyloadRS485[0] = 0xD2;
 EnviarTramaRS485(2, direccionRS485, 0xF1, 1, outputPyloadRS485);
 }



 if ((banSPIA==0)&&(bufferSPI==0xAA)){
 banSPIA = 1;
 SPI1BUF = inputPyloadRS485[0];
 i = 1;
 }
 if ((banSPIA==1)&&(bufferSPI!=0xAA)&&(bufferSPI!=0xFA)){
 SPI1BUF = inputPyloadRS485[i];
 i++;
 }
 if ((banSPIA==1)&&(bufferSPI==0xFA)){
 banSPIA = 0;
 }







 if ((banCheckRS485==0)&&(bufferSPI==0xA8)){

 banCheckRS485 = 1;
#line 481 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/Master/Master.c"
 }


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
#line 499 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/Master/Master.c"
 }



}




void int_1() org IVT_ADDR_INT1INTERRUPT {

 INT1IF_bit = 0;

 horaSistema++;
 INT_SINC = ~INT_SINC;



 INT_SINC1 = 1;
 INT_SINC2 = 1;
 INT_SINC3 = 1;
 INT_SINC4 = 1;
 Delay_us(20);

 INT_SINC1 = 0;
 INT_SINC2 = 0;
 INT_SINC3 = 0;
 INT_SINC4 = 0;

 if (horaSistema==86400){
 horaSistema = 0;
 }
 if (banInicio==1){


 }

}
#line 623 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/Master/Master.c"
void urx_2() org IVT_ADDR_U2RXINTERRUPT {


 U2RXIF_bit = 0;
 byteRS485 = U2RXREG;
 U2STA.OERR = 0;


 if (banRSI==2){
 if (i_rs485<numDatosRS485){
 inputPyloadRS485[i_rs485] = byteRS485;
 i_rs485++;
 } else {
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
 if ((banRSI==1)&&(i_rs485<4)){
 tramaCabeceraRS485[i_rs485] = byteRS485;
 i_rs485++;
 }
 if ((banRSI==1)&&(i_rs485==4)){

 if (tramaCabeceraRS485[1]==direccionRS485){
 funcionRS485 = tramaCabeceraRS485[2];
 numDatosRS485 = tramaCabeceraRS485[3];
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
#line 680 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/Master/Master.c"
 InterrupcionP1(0xB1,subFuncionRS485,numDatosRS485);
 break;
 case 0xF2:


 break;
 case 0xF3:


 break;
 }

 banRSC = 0;

 }
}
