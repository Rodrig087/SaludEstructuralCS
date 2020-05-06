
// *****************************************************************************
// ********************* SPI Function Prototyping ******************************
// ******************************************************************************

#ifndef SPI_H
#define SPI_H

#define FAST    1
#define SLOW    0

// Metodos del archivo spi.c
void SPISD_Init(unsigned char speed);
unsigned char SPISD_Write(unsigned char datos);

#endif      // SPI_H