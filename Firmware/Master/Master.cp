#line 1 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/SaludEstructuralCS/Firmware/Master/Master.c"
#line 1 "c:/users/ivan/desktop/milton muñoz/proyectos/git/saludestructuralcs/firmware/master/tiempo_gps.c"




void ConfigurarGPS(){
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
#line 23 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/SaludEstructuralCS/Firmware/Master/Master.c"
sbit RP1 at LATA4_bit;
sbit RP1_Direction at TRISA4_bit;
sbit TEST at LATB12_bit;
sbit TEST_Direction at TRISB12_bit;

unsigned char tramaGPS[70];
unsigned char datosGPS[13];
unsigned short tiempo[6];
unsigned short tiempoRPI[6];
unsigned char datosLeidos[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
unsigned char datosFIFO[243];
unsigned short numFIFO, numSetsFIFO;
unsigned short contTimer1;

unsigned int i, x, y, i_gps, j;
unsigned short buffer;
unsigned short contMuestras;
unsigned short contCiclos;
unsigned int contFIFO;
short tasaMuestreo;
short numTMR1;

unsigned short banUTI, banUTF, banUTC;
unsigned short banLec, banEsc, banCiclo, banInicio, banSetReloj, banSetGPS;
unsigned short banMuestrear, banLeer, banConf;

unsigned char byteGPS, banTIGPS, banTFGPS, banTCGPS;
unsigned long horaSistema, fechaSistema;

unsigned char byteUART2;
unsigned char tramaCabeceraUART[4];
unsigned char tramaPyloadUART[2506];
unsigned int i_uart;
unsigned int numDatosPyload;






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





void main() {

 ConfiguracionPrincipal();



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

 banMuestrear = 0;
 banInicio = 0;
 banLeer = 0;
 banConf = 0;

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
 TEST = 1;

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
 TRISA3_bit = 0;
 TRISA4_bit = 0;
 TRISB12_bit = 0;
 TRISB10_bit = 1;
 TRISB11_bit = 1;
 TRISB13_bit = 1;
 INTCON2.GIE = 1;


 RPINR18bits.U1RXR = 0x22;
 RPOR0bits.RP35R = 0x01;
 UART1_Init(9600);
 U1RXIE_bit = 0;
 U1RXIF_bit = 0;
 IPC2bits.U1RXIP = 0x04;
 U1STAbits.URXISEL = 0x00;


 RPINR19bits.U2RXR = 0x2F;
 RPOR1bits.RP36R = 0x03;
 UART2_Init_Advanced(2000000, 2, 1, 1);
 U2RXIE_bit = 0;
 U2RXIF_bit = 0;
 IPC7bits.U2RXIP = 0x04;
 U2STAbits.URXISEL = 0x00;


 SPI1STAT.SPIEN = 1;
 SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
 SPI1IE_bit = 1;
 SPI1IF_bit = 0;
 IPC2bits.SPI1IP = 0x03;


 RPINR0 = 0x2E00;
 INT1IE_bit = 0;
 INT1IF_bit = 0;
 IPC5bits.INT1IP = 0x01;

 Delay_ms(200);

}




 void InterrupcionP2(){

 if (INT1IE_bit==0){
 INT1IE_bit = 1;
 }

 if (U1RXIE_bit==1){
 U1RXIE_bit = 0;
 }

 RP1 = 1;
 Delay_us(20);
 RP1 = 0;
}




void EnviarTramaUART(unsigned short puertoUART, unsigned short direccion, unsigned short numDatos, unsigned short funcion, unsigned char *payload){

 unsigned int iDatos;

 if (puertoUART == 1){
 UART1_Write(0x3A);
 UART1_Write(direccion);
 UART1_Write(numDatos);
 UART1_Write(funcion);
 for (iDatos=0;iDatos<numDatos;iDatos++){
 UART1_Write(payload[iDatos]);
 }
 UART1_Write(0x0D);
 UART1_Write(0x0A);
 }

 if (puertoUART == 2){
 UART2_Write(0x3A);
 UART2_Write(direccion);
 UART2_Write(numDatos);
 UART2_Write(funcion);
 for (iDatos=0;iDatos<numDatos;iDatos++){
 UART2_Write(payload[iDatos]);
 }
 UART2_Write(0x0D);
 UART2_Write(0x0A);
 }

}










void spi_1() org IVT_ADDR_SPI1INTERRUPT {

 SPI1IF_bit = 0;
 buffer = SPI1BUF;


 if ((banSetReloj==0)){
 if (buffer==0xC0){
 banTIGPS = 0;
 banTCGPS = 0;
 i_gps = 0;

 if (U1RXIE_bit==0){
 U1RXIE_bit = 1;
 }
 }
 }


 if ((banSetReloj==0)&&(buffer==0xC3)){
 banEsc = 1;
 j = 0;
 }
 if ((banEsc==1)&&(buffer!=0xC3)&&(buffer!=0xC4)){
 tiempoRPI[j] = buffer;
 j++;
 }
 if ((banEsc==1)&&(buffer==0xC4)){
 horaSistema = RecuperarHoraRPI(tiempoRPI);
 fechaSistema = RecuperarFechaRPI(tiempoRPI);
 AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
 banEsc = 0;


 EnviarTramaUART(2, 255, 6, 2, tiempo);
 U2RXIE_bit = 1;

 }


 if (banSetReloj==1){
 banSetReloj = 2;
 j = 0;
 SPI1BUF = tiempo[j];
 }
 if ((banSetReloj==2)&&(buffer!=0xC1)){
 SPI1BUF = tiempo[j];
 j++;
 }
 if ((banSetReloj==2)&&(buffer==0xC1)){
 banSetReloj = 0;

 }


 if ((banLec==1)&&(buffer==0xB0)){
 banLec = 2;
 i = 0;
 SPI1BUF = tramaPyloadUART[i];
 }
 if ((banLec==2)&&(buffer!=0xB1)){
 SPI1BUF = tramaPyloadUART[i];
 i++;
 }
 if ((banLec==2)&&(buffer==0xB1)){
 banLec = 0;
 SPI1BUF = 0xFF;
 }

}




void int_1() org IVT_ADDR_INT1INTERRUPT {

 INT1IF_bit = 0;


 horaSistema++;

 if (horaSistema==86400){
 horaSistema = 0;
 }

 if (banInicio==1){

 }

}
#line 430 "C:/Users/Ivan/Desktop/Milton Muñoz/Proyectos/Git/SaludEstructuralCS/Firmware/Master/Master.c"
void urx_2() org IVT_ADDR_U2RXINTERRUPT {

 U2RXIF_bit = 0;

 byteUART2 = U2RXREG;
 U2STA.OERR = 0;

 if (banUTI==2){
 if (i_uart<numDatosPyload){
 tramaPyloadUART[i_uart] = byteUART2;
 i_uart++;
 } else {
 banUTI = 0;
 banUTC = 1;
 }
 }

 if ((banUTI==0)&&(banUTC==0)){
 if (byteUART2==0x3A){
 banUTI = 1;
 i_uart = 0;
 }
 }
 if ((banUTI==1)&&(i_uart<4)){
 tramaCabeceraUART[i_uart] = byteUART2;
 i_uart++;
 }
 if ((banUTI==1)&&(i_uart==4)){
 numDatosPyload = tramaCabeceraUART[2];
 banUTI = 2;
 i_uart = 0;
 }

 if (banUTC==1){

 TEST = ~TEST;
 for (x=0;x<6;x++) {
 tiempo[x] = tramaPyloadUART[x];
 }

 banSetReloj=1;

 RP1 = 1;
 Delay_us(20);
 RP1 = 0;

 banUTC = 0;
 }

}
