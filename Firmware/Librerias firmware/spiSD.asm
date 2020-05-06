
_SPISD_Init:

;spiSD.c,13 :: 		void SPISD_Init(unsigned char speed) {
;spiSD.c,14 :: 		SPI1STAT.SPIEN = 0;                                                         //Desabilita el SPI1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	SPI1STAT, #15
;spiSD.c,17 :: 		if(speed == FAST) {
	CP.B	W10, #1
	BRA Z	L__SPISD_Init7
	GOTO	L_SPISD_Init0
L__SPISD_Init7:
;spiSD.c,19 :: 		SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_2, _SPI_PRESCALE_PRI_16, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
	MOV	#1, W13
	MOV	#24, W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	MOV	#64, W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI1_Init_Advanced
	SUB	#8, W15
;spiSD.c,20 :: 		} else {
	GOTO	L_SPISD_Init1
L_SPISD_Init0:
;spiSD.c,22 :: 		SPI1_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	MOV	#64, W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI1_Init_Advanced
	SUB	#8, W15
;spiSD.c,23 :: 		}
L_SPISD_Init1:
;spiSD.c,25 :: 		SPI1STAT.SPIEN = 1;                                                         //Habilita el SPI1
	BSET	SPI1STAT, #15
;spiSD.c,29 :: 		}
L_end_SPISD_Init:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _SPISD_Init

_SPISD_Write:

;spiSD.c,38 :: 		unsigned char SPISD_Write(unsigned char datos) {
;spiSD.c,39 :: 		SPI1BUF = datos;
	ZE	W10, W0
	MOV	WREG, SPI1BUF
;spiSD.c,40 :: 		while(SPI1STATbits.SPITBF);          // Transmitting
L_SPISD_Write2:
	BTSS	SPI1STATbits, #1
	GOTO	L_SPISD_Write3
	GOTO	L_SPISD_Write2
L_SPISD_Write3:
;spiSD.c,41 :: 		while(SPI1STATbits.SPIRBF == 0);     // Receiving
L_SPISD_Write4:
	BTSC	SPI1STATbits, #0
	GOTO	L_SPISD_Write5
	GOTO	L_SPISD_Write4
L_SPISD_Write5:
;spiSD.c,42 :: 		return SPI1BUF;
	MOV.B	SPI1BUF, WREG
;spiSD.c,43 :: 		}
L_end_SPISD_Write:
	RETURN
; end of _SPISD_Write
