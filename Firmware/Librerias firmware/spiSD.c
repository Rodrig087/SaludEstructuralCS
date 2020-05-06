
// *****************************************************************************
// **************** Libreria para iniciar y escribir en el SPI *****************
// *****************************************************************************

// Incluye el archivo header
#include "spiSD.h"

// *****************************************************************************
// Metodo para iniciar el SPI, recibe como parametro la velocidad, que puede ser
// rapida (FAST = 1) o lenta (SLOW = 0)
// *****************************************************************************
void SPISD_Init(unsigned char speed) {
    SPI1STAT.SPIEN = 0;                                                         //Desabilita el SPI1

// Configuring SPI speed considering a 80MHz crystal = 40MIPS
    if(speed == FAST) {
        // SPI Clock Speed = 5MHz
        SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_2, _SPI_PRESCALE_PRI_16, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
    } else {
        // SPI Clock Speed = 625KHz
        SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
    }

    SPI1STAT.SPIEN = 1;                                                         //Habilita el SPI1
    
    
    
}
// *****************************************************************************
// **************************** Fin SPI_Init ***********************************
// *****************************************************************************


// *****************************************************************************
// * Metodo para escribir en el SPI, solo recibe el dato que se desea escribir *
// *****************************************************************************
unsigned char SPISD_Write(unsigned char datos) {
    SPI1BUF = datos;
    while(SPI1STATbits.SPITBF);          // Transmitting     
    while(SPI1STATbits.SPIRBF == 0);     // Receiving
    return SPI1BUF;
}
// *****************************************************************************
// **************************** Fin SPI_Write **********************************
// *****************************************************************************