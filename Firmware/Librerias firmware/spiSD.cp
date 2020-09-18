#line 1 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/Librerias firmware/spiSD.c"
#line 1 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/spisd.h"
#line 13 "c:/users/milto/milton/rsa/git/salud estructural/saludestructuralcs/firmware/librerias firmware/spisd.h"
void SPISD_Init(unsigned char speed);
unsigned char SPISD_Write(unsigned char datos);
#line 13 "C:/Users/milto/Milton/RSA/Git/Salud Estructural/SaludEstructuralCS/Firmware/Librerias firmware/spiSD.c"
void SPISD_Init(unsigned char speed) {
 SPI1STAT.SPIEN = 0;


 if(speed ==  1 ) {

 SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_4, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);






 } else {

 SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
 }

 SPI1STAT.SPIEN = 1;



}








unsigned char SPISD_Write(unsigned char datos) {
 SPI1BUF = datos;
 while(SPI1STATbits.SPITBF);
 while(SPI1STATbits.SPIRBF == 0);
 return SPI1BUF;
}
