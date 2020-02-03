
_ADXL355_init:

;adxl355_spi.c,106 :: 		void ADXL355_init(short tMuestreo){
;adxl355_spi.c,107 :: 		ADXL355_write_byte(Reset,0x52);                                             //Resetea el dispositivo
	PUSH	W10
	PUSH	W11
	PUSH	W10
	MOV.B	#82, W11
	MOV.B	#47, W10
	CALL	_ADXL355_write_byte
;adxl355_spi.c,108 :: 		Delay_ms(10);
	MOV	#2, W8
	MOV	#14464, W7
L_ADXL355_init0:
	DEC	W7
	BRA NZ	L_ADXL355_init0
	DEC	W8
	BRA NZ	L_ADXL355_init0
	NOP
	NOP
;adxl355_spi.c,109 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|STANDBY);
	MOV.B	#5, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;adxl355_spi.c,110 :: 		ADXL355_write_byte(Range, _2G);
	MOV.B	#1, W11
	MOV.B	#44, W10
	CALL	_ADXL355_write_byte
	POP	W10
;adxl355_spi.c,111 :: 		switch (tMuestreo){
	GOTO	L_ADXL355_init2
;adxl355_spi.c,112 :: 		case 1:
L_ADXL355_init4:
;adxl355_spi.c,113 :: 		ADXL355_write_byte(Filter, NO_HIGH_PASS_FILTER|_62_5_Hz);       //ODR=250Hz 1
	MOV.B	#4, W11
	MOV.B	#40, W10
	CALL	_ADXL355_write_byte
;adxl355_spi.c,114 :: 		break;
	GOTO	L_ADXL355_init3
;adxl355_spi.c,115 :: 		case 2:
L_ADXL355_init5:
;adxl355_spi.c,116 :: 		ADXL355_write_byte(Filter, NO_HIGH_PASS_FILTER|_31_25_Hz);      //ODR=125Hz 2
	MOV.B	#5, W11
	MOV.B	#40, W10
	CALL	_ADXL355_write_byte
;adxl355_spi.c,117 :: 		break;
	GOTO	L_ADXL355_init3
;adxl355_spi.c,118 :: 		case 4:
L_ADXL355_init6:
;adxl355_spi.c,119 :: 		ADXL355_write_byte(Filter, NO_HIGH_PASS_FILTER|_15_625_Hz);     //ODR=62.5Hz 4
	MOV.B	#6, W11
	MOV.B	#40, W10
	CALL	_ADXL355_write_byte
;adxl355_spi.c,120 :: 		break;
	GOTO	L_ADXL355_init3
;adxl355_spi.c,121 :: 		case 8:
L_ADXL355_init7:
;adxl355_spi.c,122 :: 		ADXL355_write_byte(Filter, NO_HIGH_PASS_FILTER|_7_813_Hz );     //ODR=31.25Hz 8
	MOV.B	#7, W11
	MOV.B	#40, W10
	CALL	_ADXL355_write_byte
;adxl355_spi.c,123 :: 		break;
	GOTO	L_ADXL355_init3
;adxl355_spi.c,124 :: 		}
L_ADXL355_init2:
	CP.B	W10, #1
	BRA NZ	L__ADXL355_init92
	GOTO	L_ADXL355_init4
L__ADXL355_init92:
	CP.B	W10, #2
	BRA NZ	L__ADXL355_init93
	GOTO	L_ADXL355_init5
L__ADXL355_init93:
	CP.B	W10, #4
	BRA NZ	L__ADXL355_init94
	GOTO	L_ADXL355_init6
L__ADXL355_init94:
	CP.B	W10, #8
	BRA NZ	L__ADXL355_init95
	GOTO	L_ADXL355_init7
L__ADXL355_init95:
L_ADXL355_init3:
;adxl355_spi.c,125 :: 		}
L_end_ADXL355_init:
	POP	W11
	POP	W10
	RETURN
; end of _ADXL355_init

_ADXL355_write_byte:

;adxl355_spi.c,128 :: 		void ADXL355_write_byte(unsigned char address, unsigned char value){
;adxl355_spi.c,129 :: 		address = (address<<1)&0xFE;
	PUSH	W10
	ZE	W10, W0
	SL	W0, #1, W1
	MOV	#254, W0
	AND	W1, W0, W0
	MOV.B	W0, W10
;adxl355_spi.c,130 :: 		CS_ADXL355=0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,131 :: 		SPI2_Write(address);
	ZE	W0, W10
	CALL	_SPI2_Write
;adxl355_spi.c,132 :: 		SPI2_Write(value);
	ZE	W11, W10
	CALL	_SPI2_Write
;adxl355_spi.c,133 :: 		CS_ADXL355=1;
	BSET	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,134 :: 		}
L_end_ADXL355_write_byte:
	POP	W10
	RETURN
; end of _ADXL355_write_byte

_ADXL355_read_byte:

;adxl355_spi.c,137 :: 		unsigned char ADXL355_read_byte(unsigned char address){
;adxl355_spi.c,138 :: 		unsigned char value = 0x00;
	PUSH	W10
;adxl355_spi.c,139 :: 		address=(address<<1)|0x01;
	ZE	W10, W0
	SL	W0, #1, W0
	IOR	W0, #1, W0
	MOV.B	W0, W10
;adxl355_spi.c,140 :: 		CS_ADXL355=0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,141 :: 		SPI2_Write(address);
	ZE	W0, W10
	CALL	_SPI2_Write
;adxl355_spi.c,142 :: 		value=SPI2_Read(0);
	CLR	W10
	CALL	_SPI2_Read
;adxl355_spi.c,143 :: 		CS_ADXL355=1;
	BSET	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,144 :: 		return value;
;adxl355_spi.c,145 :: 		}
;adxl355_spi.c,144 :: 		return value;
;adxl355_spi.c,145 :: 		}
L_end_ADXL355_read_byte:
	POP	W10
	RETURN
; end of _ADXL355_read_byte

_ADXL355_read_data:

;adxl355_spi.c,148 :: 		unsigned int ADXL355_read_data(unsigned char *vectorMuestra){
;adxl355_spi.c,151 :: 		if((ADXL355_read_byte(Status)&0x01)==1){                                 //Verifica que el bit DATA_RDY del registro Status este en alto
	PUSH	W10
	MOV.B	#4, W10
	CALL	_ADXL355_read_byte
	POP	W10
	ZE	W0, W0
	AND	W0, #1, W0
	CP	W0, #1
	BRA Z	L__ADXL355_read_data99
	GOTO	L_ADXL355_read_data8
L__ADXL355_read_data99:
;adxl355_spi.c,152 :: 		CS_ADXL355=0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,153 :: 		for (j=0;j<9;j++){
; j start address is: 4 (W2)
	CLR	W2
; j end address is: 4 (W2)
L_ADXL355_read_data9:
; j start address is: 4 (W2)
	CP.B	W2, #9
	BRA LTU	L__ADXL355_read_data100
	GOTO	L_ADXL355_read_data10
L__ADXL355_read_data100:
;adxl355_spi.c,154 :: 		muestra = ADXL355_read_byte(axisAddresses[j]);
	ZE	W2, W1
	MOV	#lo_addr(_axisAddresses), W0
	ADD	W0, W1, W0
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_ADXL355_read_byte
	POP	W10
;adxl355_spi.c,155 :: 		vectorMuestra[j] = muestra;
	ZE	W2, W1
	ADD	W10, W1, W1
	MOV.B	W0, [W1]
;adxl355_spi.c,153 :: 		for (j=0;j<9;j++){
	INC.B	W2
;adxl355_spi.c,156 :: 		}
; j end address is: 4 (W2)
	GOTO	L_ADXL355_read_data9
L_ADXL355_read_data10:
;adxl355_spi.c,157 :: 		CS_ADXL355=1;
	BSET	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,158 :: 		} else {
	GOTO	L_ADXL355_read_data12
L_ADXL355_read_data8:
;adxl355_spi.c,159 :: 		for (j=0;j<9;j++){
; j start address is: 4 (W2)
	CLR	W2
; j end address is: 4 (W2)
L_ADXL355_read_data13:
; j start address is: 4 (W2)
	CP.B	W2, #9
	BRA LTU	L__ADXL355_read_data101
	GOTO	L_ADXL355_read_data14
L__ADXL355_read_data101:
;adxl355_spi.c,160 :: 		vectorMuestra[j] = 0;
	ZE	W2, W0
	ADD	W10, W0, W1
	CLR	W0
	MOV.B	W0, [W1]
;adxl355_spi.c,159 :: 		for (j=0;j<9;j++){
	INC.B	W2
;adxl355_spi.c,161 :: 		}
; j end address is: 4 (W2)
	GOTO	L_ADXL355_read_data13
L_ADXL355_read_data14:
;adxl355_spi.c,162 :: 		}
L_ADXL355_read_data12:
;adxl355_spi.c,163 :: 		return;
;adxl355_spi.c,164 :: 		}
L_end_ADXL355_read_data:
	RETURN
; end of _ADXL355_read_data

_ADXL355_read_FIFO:
	LNK	#2

;adxl355_spi.c,167 :: 		unsigned int ADXL355_read_FIFO(unsigned char *vectorFIFO){
;adxl355_spi.c,170 :: 		CS_ADXL355 = 0;
	PUSH	W10
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,171 :: 		SPI2_Write(add);
	PUSH	W10
	MOV	#35, W10
	CALL	_SPI2_Write
	POP	W10
;adxl355_spi.c,173 :: 		vectorFIFO[0] = SPI2_Read(0);
	MOV	W10, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CLR	W10
	CALL	_SPI2_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;adxl355_spi.c,174 :: 		vectorFIFO[1] = SPI2_Read(1);
	ADD	W10, #1, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV	#1, W10
	CALL	_SPI2_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;adxl355_spi.c,175 :: 		vectorFIFO[2] = SPI2_Read(2);
	ADD	W10, #2, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV	#2, W10
	CALL	_SPI2_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;adxl355_spi.c,177 :: 		vectorFIFO[3] = SPI2_Read(0);
	ADD	W10, #3, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CLR	W10
	CALL	_SPI2_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;adxl355_spi.c,178 :: 		vectorFIFO[4] = SPI2_Read(1);
	ADD	W10, #4, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV	#1, W10
	CALL	_SPI2_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;adxl355_spi.c,179 :: 		vectorFIFO[5] = SPI2_Read(2);
	ADD	W10, #5, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV	#2, W10
	CALL	_SPI2_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;adxl355_spi.c,181 :: 		vectorFIFO[6] = SPI2_Read(0);
	ADD	W10, #6, W0
	MOV	W0, [W14+0]
	PUSH	W10
	CLR	W10
	CALL	_SPI2_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;adxl355_spi.c,182 :: 		vectorFIFO[7] = SPI2_Read(1);
	ADD	W10, #7, W0
	MOV	W0, [W14+0]
	PUSH	W10
	MOV	#1, W10
	CALL	_SPI2_Read
	POP	W10
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;adxl355_spi.c,183 :: 		vectorFIFO[8] = SPI2_Read(2);
	ADD	W10, #8, W0
	MOV	W0, [W14+0]
	MOV	#2, W10
	CALL	_SPI2_Read
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;adxl355_spi.c,184 :: 		CS_ADXL355 = 1;
	BSET	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,185 :: 		Delay_us(5);
	MOV	#40, W7
L_ADXL355_read_FIFO16:
	DEC	W7
	BRA NZ	L_ADXL355_read_FIFO16
	NOP
	NOP
;adxl355_spi.c,187 :: 		}
;adxl355_spi.c,186 :: 		return;
;adxl355_spi.c,187 :: 		}
L_end_ADXL355_read_FIFO:
	POP	W10
	ULNK
	RETURN
; end of _ADXL355_read_FIFO

_ConfigurarGPS:

;tiempo_gps.c,5 :: 		void ConfigurarGPS(){
;tiempo_gps.c,6 :: 		UART1_Write_Text("$PMTK605*31\r\n");
	PUSH	W10
	PUSH	W11
	MOV	#lo_addr(?lstr1_NodoAcelerometro), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,7 :: 		UART1_Write_Text("$PMTK220,1000*1F\r\n");
	MOV	#lo_addr(?lstr2_NodoAcelerometro), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,8 :: 		UART1_Write_Text("$PMTK251,115200*1F\r\n");
	MOV	#lo_addr(?lstr3_NodoAcelerometro), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,9 :: 		Delay_ms(1000);                                                            //Tiempo necesario para que se de efecto el cambio de configuracion
	MOV	#123, W8
	MOV	#4681, W7
L_ConfigurarGPS18:
	DEC	W7
	BRA NZ	L_ConfigurarGPS18
	DEC	W8
	BRA NZ	L_ConfigurarGPS18
;tiempo_gps.c,10 :: 		UART1_Init(115200);
	MOV	#49664, W10
	MOV	#1, W11
	CALL	_UART1_Init
;tiempo_gps.c,11 :: 		UART1_Write_Text("$PMTK313,1*2E\r\n");
	MOV	#lo_addr(?lstr4_NodoAcelerometro), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,12 :: 		UART1_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29\r\n");
	MOV	#lo_addr(?lstr5_NodoAcelerometro), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,13 :: 		UART1_Write_Text("$PMTK319,1*24\r\n");
	MOV	#lo_addr(?lstr6_NodoAcelerometro), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,14 :: 		UART1_Write_Text("$PMTK413*34\r\n");
	MOV	#lo_addr(?lstr7_NodoAcelerometro), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,15 :: 		UART1_Write_Text("$PMTK513,1*28\r\n");
	MOV	#lo_addr(?lstr8_NodoAcelerometro), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,16 :: 		Delay_ms(1000);
	MOV	#123, W8
	MOV	#4681, W7
L_ConfigurarGPS20:
	DEC	W7
	BRA NZ	L_ConfigurarGPS20
	DEC	W8
	BRA NZ	L_ConfigurarGPS20
;tiempo_gps.c,17 :: 		}
L_end_ConfigurarGPS:
	POP	W11
	POP	W10
	RETURN
; end of _ConfigurarGPS

_RecuperarFechaGPS:
	LNK	#28

;tiempo_gps.c,22 :: 		unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS){
;tiempo_gps.c,27 :: 		char *ptrDatoStringF = &datoStringF;
	PUSH	W10
	ADD	W14, #16, W4
	MOV	W4, [W14+26]
; ptrDatoStringF start address is: 12 (W6)
	MOV	W4, W6
;tiempo_gps.c,28 :: 		datoStringF[2] = '\0';
	ADD	W4, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
;tiempo_gps.c,29 :: 		tramaFecha[3] = '\0';
	ADD	W14, #0, W3
	MOV	W3, [W14+24]
	ADD	W3, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;tiempo_gps.c,32 :: 		datoStringF[0] = tramaDatosGPS[6];
	ADD	W10, #6, W0
	MOV.B	[W0], [W4]
;tiempo_gps.c,33 :: 		datoStringF[1] = tramaDatosGPS[7];
	ADD	W4, #1, W1
	ADD	W10, #7, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,34 :: 		tramaFecha[0] =  atoi(ptrDatoStringF);
	MOV	W3, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,37 :: 		datoStringF[0] = tramaDatosGPS[8];
	ADD	W10, #8, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,38 :: 		datoStringF[1] = tramaDatosGPS[9];
	ADD	W0, #1, W1
	ADD	W10, #9, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,39 :: 		tramaFecha[1] = atoi(ptrDatoStringF);
	MOV	[W14+24], W0
	ADD	W0, #4, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,42 :: 		datoStringF[0] = tramaDatosGPS[10];
	ADD	W10, #10, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,43 :: 		datoStringF[1] = tramaDatosGPS[11];
	ADD	W0, #1, W1
	ADD	W10, #11, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,44 :: 		tramaFecha[2] = atoi(ptrDatoStringF);
	MOV	[W14+24], W0
	ADD	W0, #8, W0
	MOV	W0, [W14+20]
	MOV	W6, W10
; ptrDatoStringF end address is: 12 (W6)
	CALL	_atoi
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,46 :: 		fechaGPS = (tramaFecha[0]*10000)+(tramaFecha[1]*100)+(tramaFecha[2]);      //10000*dd + 100*mm + aa
	MOV	[W14+24], W2
	MOV.D	[W2], W0
	MOV	#10000, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+24], W2
	MOV	W0, [W14+20]
	MOV	W1, [W14+22]
	ADD	W2, #4, W2
	MOV.D	[W2], W0
	MOV	#100, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+20], W2
	MOV	[W14+22], W3
	ADD	W2, W0, W4
	ADDC	W3, W1, W5
	MOV	[W14+24], W0
	ADD	W0, #8, W2
	ADD	W4, [W2++], W0
	ADDC	W5, [W2--], W1
;tiempo_gps.c,48 :: 		return fechaGPS;
;tiempo_gps.c,50 :: 		}
;tiempo_gps.c,48 :: 		return fechaGPS;
;tiempo_gps.c,50 :: 		}
L_end_RecuperarFechaGPS:
	POP	W10
	ULNK
	RETURN
; end of _RecuperarFechaGPS

_RecuperarHoraGPS:
	LNK	#28

;tiempo_gps.c,55 :: 		unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS){
;tiempo_gps.c,60 :: 		char *ptrDatoString = &datoString;
	PUSH	W10
	ADD	W14, #16, W4
	MOV	W4, [W14+26]
; ptrDatoString start address is: 12 (W6)
	MOV	W4, W6
;tiempo_gps.c,61 :: 		datoString[2] = '\0';
	ADD	W4, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
;tiempo_gps.c,62 :: 		tramaTiempo[3] = '\0';
	ADD	W14, #0, W3
	MOV	W3, [W14+24]
	ADD	W3, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;tiempo_gps.c,65 :: 		datoString[0] = tramaDatosGPS[0];
	MOV.B	[W10], [W4]
;tiempo_gps.c,66 :: 		datoString[1] = tramaDatosGPS[1];
	ADD	W4, #1, W1
	ADD	W10, #1, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,67 :: 		tramaTiempo[0] = atoi(ptrDatoString);
	MOV	W3, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,70 :: 		datoString[0] = tramaDatosGPS[2];
	ADD	W10, #2, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,71 :: 		datoString[1] = tramaDatosGPS[3];
	ADD	W0, #1, W1
	ADD	W10, #3, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,72 :: 		tramaTiempo[1] = atoi(ptrDatoString);
	MOV	[W14+24], W0
	ADD	W0, #4, W0
	MOV	W0, [W14+20]
	PUSH	W10
	MOV	W6, W10
	CALL	_atoi
	POP	W10
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,75 :: 		datoString[0] = tramaDatosGPS[4];
	ADD	W10, #4, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,76 :: 		datoString[1] = tramaDatosGPS[5];
	ADD	W0, #1, W1
	ADD	W10, #5, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,77 :: 		tramaTiempo[2] = atoi(ptrDatoString);
	MOV	[W14+24], W0
	ADD	W0, #8, W0
	MOV	W0, [W14+20]
	MOV	W6, W10
; ptrDatoString end address is: 12 (W6)
	CALL	_atoi
	MOV	W0, W1
	ASR	W1, #15, W2
	MOV	[W14+20], W0
	MOV	W1, [W0++]
	MOV	W2, [W0--]
;tiempo_gps.c,79 :: 		horaGPS = (tramaTiempo[0]*3600)+(tramaTiempo[1]*60)+(tramaTiempo[2]);      //Calcula el segundo actual = hh*3600 + mm*60 + ss
	MOV	[W14+24], W2
	MOV.D	[W2], W0
	MOV	#3600, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+24], W2
	MOV	W0, [W14+20]
	MOV	W1, [W14+22]
	ADD	W2, #4, W2
	MOV.D	[W2], W0
	MOV	#60, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+20], W2
	MOV	[W14+22], W3
	ADD	W2, W0, W4
	ADDC	W3, W1, W5
	MOV	[W14+24], W0
	ADD	W0, #8, W2
	ADD	W4, [W2++], W0
	ADDC	W5, [W2--], W1
;tiempo_gps.c,80 :: 		return horaGPS;
;tiempo_gps.c,82 :: 		}
;tiempo_gps.c,80 :: 		return horaGPS;
;tiempo_gps.c,82 :: 		}
L_end_RecuperarHoraGPS:
	POP	W10
	ULNK
	RETURN
; end of _RecuperarHoraGPS

_RecuperarFechaRPI:
	LNK	#4

;tiempo_gps.c,87 :: 		unsigned long RecuperarFechaRPI(unsigned short *tramaTiempoRpi){
;tiempo_gps.c,91 :: 		fechaRPi = ((long)tramaTiempoRpi[0]*10000)+((long)tramaTiempoRpi[1]*100)+((long)tramaTiempoRpi[2]);      //10000*dd + 100*mm + aa
	ZE	[W10], W0
	CLR	W1
	MOV	#10000, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	ADD	W10, #1, W0
	ZE	[W0], W0
	CLR	W1
	MOV	#100, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	ADD	W2, W0, W2
	ADDC	W3, W1, W3
	ADD	W10, #2, W0
	ZE	[W0], W0
	CLR	W1
	ADD	W2, W0, W0
	ADDC	W3, W1, W1
;tiempo_gps.c,94 :: 		return fechaRPi;
;tiempo_gps.c,96 :: 		}
L_end_RecuperarFechaRPI:
	ULNK
	RETURN
; end of _RecuperarFechaRPI

_RecuperarHoraRPI:
	LNK	#4

;tiempo_gps.c,101 :: 		unsigned long RecuperarHoraRPI(unsigned short *tramaTiempoRpi){
;tiempo_gps.c,105 :: 		horaRPi = ((long)tramaTiempoRpi[3]*3600)+((long)tramaTiempoRpi[4]*60)+((long)tramaTiempoRpi[5]);      //Calcula el segundo actual = hh*3600 + mm*60 + ss      //10000*dd + 100*mm + aa
	ADD	W10, #3, W0
	ZE	[W0], W0
	CLR	W1
	MOV	#3600, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	ADD	W10, #4, W0
	ZE	[W0], W0
	CLR	W1
	MOV	#60, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	ADD	W2, W0, W2
	ADDC	W3, W1, W3
	ADD	W10, #5, W0
	ZE	[W0], W0
	CLR	W1
	ADD	W2, W0, W0
	ADDC	W3, W1, W1
;tiempo_gps.c,108 :: 		return horaRPi;
;tiempo_gps.c,110 :: 		}
L_end_RecuperarHoraRPI:
	ULNK
	RETURN
; end of _RecuperarHoraRPI

_AjustarTiempoSistema:
	LNK	#14

;tiempo_gps.c,115 :: 		void AjustarTiempoSistema(unsigned long longHora, unsigned long longFecha, unsigned char *tramaTiempoSistema){
	MOV	[W14-8], W0
	MOV	W0, [W14-8]
;tiempo_gps.c,124 :: 		hora = longHora / 3600;
	PUSH.D	W12
	PUSH.D	W10
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	MOV.B	W0, [W14+0]
;tiempo_gps.c,125 :: 		minuto = (longHora%3600) / 60;
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Modulus_32x32
	MOV	W0, [W14+10]
	MOV	W1, [W14+12]
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	MOV.B	W0, [W14+1]
;tiempo_gps.c,126 :: 		segundo = (longHora%3600) % 60;
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W12
	MOV.B	W0, [W14+2]
;tiempo_gps.c,128 :: 		dia = longFecha / 10000;
	PUSH.D	W12
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W12
	MOV.B	W0, [W14+3]
;tiempo_gps.c,129 :: 		mes = (longFecha%10000) / 100;
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Modulus_32x32
	MOV	W0, [W14+10]
	MOV	W1, [W14+12]
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	MOV.B	W0, [W14+4]
;tiempo_gps.c,130 :: 		anio = (longFecha%10000) % 100;
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
; anio start address is: 4 (W2)
	MOV.B	W0, W2
;tiempo_gps.c,132 :: 		tramaTiempoSistema[0] = dia;
	MOV	[W14-8], W1
	MOV.B	[W14+3], W0
	MOV.B	W0, [W1]
;tiempo_gps.c,133 :: 		tramaTiempoSistema[1] = mes;
	MOV	[W14-8], W0
	ADD	W0, #1, W1
	MOV.B	[W14+4], W0
	MOV.B	W0, [W1]
;tiempo_gps.c,134 :: 		tramaTiempoSistema[2] = anio;
	MOV	[W14-8], W0
	INC2	W0
	MOV.B	W2, [W0]
; anio end address is: 4 (W2)
;tiempo_gps.c,135 :: 		tramaTiempoSistema[3] = hora;
	MOV	[W14-8], W0
	ADD	W0, #3, W1
	MOV.B	[W14+0], W0
	MOV.B	W0, [W1]
;tiempo_gps.c,136 :: 		tramaTiempoSistema[4] = minuto;
	MOV	[W14-8], W0
	ADD	W0, #4, W1
	MOV.B	[W14+1], W0
	MOV.B	W0, [W1]
;tiempo_gps.c,137 :: 		tramaTiempoSistema[5] = segundo;
	MOV	[W14-8], W0
	ADD	W0, #5, W1
	MOV.B	[W14+2], W0
	MOV.B	W0, [W1]
;tiempo_gps.c,140 :: 		}
L_end_AjustarTiempoSistema:
	ULNK
	RETURN
; end of _AjustarTiempoSistema

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 50
	MOV	#4, W0
	IOR	68

;NodoAcelerometro.c,75 :: 		void main() {
;NodoAcelerometro.c,77 :: 		ConfiguracionPrincipal();
	PUSH	W10
	CALL	_ConfiguracionPrincipal
;NodoAcelerometro.c,80 :: 		tasaMuestreo = 1;                                                          //1=250Hz, 2=125Hz, 4=62.5Hz, 8=31.25Hz
	MOV	#lo_addr(_tasaMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,81 :: 		ADXL355_init(tasaMuestreo);                                                //Inicializa el modulo ADXL con la tasa de muestreo requerida:
	MOV.B	#1, W10
	CALL	_ADXL355_init
;NodoAcelerometro.c,82 :: 		numTMR1 = (tasaMuestreo*10)-1;                                             //Calcula el numero de veces que tienen que desbordarse el TMR1 para cada tasa de muestreo
	MOV	#lo_addr(_tasaMuestreo), W0
	SE	[W0], W1
	MOV	#10, W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(_numTMR1), W0
	SUB.B	W2, #1, [W0]
;NodoAcelerometro.c,84 :: 		banUTI = 0;
	MOV	#lo_addr(_banUTI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,85 :: 		banUTC = 0;
	MOV	#lo_addr(_banUTC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,87 :: 		banLec = 0;
	MOV	#lo_addr(_banLec), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,88 :: 		banEsc = 0;
	MOV	#lo_addr(_banEsc), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,89 :: 		banCiclo = 0;
	MOV	#lo_addr(_banCiclo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,90 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,91 :: 		banSetGPS = 0;
	MOV	#lo_addr(_banSetGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,92 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,93 :: 		banTFGPS = 0;
	MOV	#lo_addr(_banTFGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,94 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,96 :: 		banMuestrear = 0;                                                          //Inicia el programa con esta bandera en bajo para permitir que la RPi envie la peticion de inicio de muestreo
	MOV	#lo_addr(_banMuestrear), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,97 :: 		banInicio = 0;                                                             //Bandera de inicio de muestreo
	MOV	#lo_addr(_banInicio), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,98 :: 		banLeer = 0;
	MOV	#lo_addr(_banLeer), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,99 :: 		banConf = 0;
	MOV	#lo_addr(_banConf), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,101 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;NodoAcelerometro.c,102 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;NodoAcelerometro.c,103 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;NodoAcelerometro.c,104 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;NodoAcelerometro.c,105 :: 		i_uart = 0;
	CLR	W0
	MOV	W0, _i_uart
;NodoAcelerometro.c,106 :: 		horaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,108 :: 		contMuestras = 0;
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,109 :: 		contCiclos = 0;
	MOV	#lo_addr(_contCiclos), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,110 :: 		contFIFO = 0;
	CLR	W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,111 :: 		numFIFO = 0;
	MOV	#lo_addr(_numFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,112 :: 		numSetsFIFO = 0;
	MOV	#lo_addr(_numSetsFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,113 :: 		contTimer1 = 0;
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,115 :: 		byteUART = 0;
	MOV	#lo_addr(_byteUART), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,117 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;NodoAcelerometro.c,118 :: 		RP2 = 0;
	BCLR	LATB4_bit, BitPos(LATB4_bit+0)
;NodoAcelerometro.c,119 :: 		TEST = 1;
	BSET	LATB12_bit, BitPos(LATB12_bit+0)
;NodoAcelerometro.c,121 :: 		SPI1BUF = 0x00;
	CLR	SPI1BUF
;NodoAcelerometro.c,123 :: 		while(1){
L_main22:
;NodoAcelerometro.c,125 :: 		}
	GOTO	L_main22
;NodoAcelerometro.c,127 :: 		}
L_end_main:
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;NodoAcelerometro.c,136 :: 		void ConfiguracionPrincipal(){
;NodoAcelerometro.c,139 :: 		CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	CLKDIVbits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, CLKDIVbits
;NodoAcelerometro.c,140 :: 		CLKDIVbits.PLLPOST = 0;                                                    //N2=2
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,141 :: 		CLKDIVbits.PLLPRE = 5;                                                     //N1=7
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,142 :: 		PLLFBDbits.PLLDIV = 150;                                                   //M=152
	MOV	#150, W0
	MOV	W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	#511, W0
	AND	W1, W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	W1, PLLFBDbits
;NodoAcelerometro.c,145 :: 		ANSELA = 0;                                                                //Configura PORTA como digital     *
	CLR	ANSELA
;NodoAcelerometro.c,146 :: 		ANSELB = 0;                                                                //Configura PORTB como digital     *
	CLR	ANSELB
;NodoAcelerometro.c,147 :: 		TRISA3_bit = 0;                                                            //Configura el pin A3 como salida  *
	BCLR	TRISA3_bit, BitPos(TRISA3_bit+0)
;NodoAcelerometro.c,148 :: 		TRISA4_bit = 0;                                                            //Configura el pin A4 como salida  *
	BCLR	TRISA4_bit, BitPos(TRISA4_bit+0)
;NodoAcelerometro.c,149 :: 		TRISB4_bit = 0;                                                            //Configura el pin B4 como salida  *
	BCLR	TRISB4_bit, BitPos(TRISB4_bit+0)
;NodoAcelerometro.c,150 :: 		TRISB12_bit = 0;                                                           //Configura el pin B12 como salida *
	BCLR	TRISB12_bit, BitPos(TRISB12_bit+0)
;NodoAcelerometro.c,151 :: 		TRISB10_bit = 1;                                                           //Configura el pin B10 como entrada *
	BSET	TRISB10_bit, BitPos(TRISB10_bit+0)
;NodoAcelerometro.c,152 :: 		TRISB11_bit = 1;                                                           //Configura el pin B11 como entrada *
	BSET	TRISB11_bit, BitPos(TRISB11_bit+0)
;NodoAcelerometro.c,153 :: 		TRISB13_bit = 1;                                                           //Configura el pin B13 como entrada *
	BSET	TRISB13_bit, BitPos(TRISB13_bit+0)
;NodoAcelerometro.c,154 :: 		INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales *
	BSET	INTCON2, #15
;NodoAcelerometro.c,157 :: 		RPINR18bits.U1RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx1 *
	MOV.B	#47, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#127, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPINR18bits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,158 :: 		RPOR1bits.RP36R = 0x01;                                                    //Configura el Tx1 en el pin RB4/RP36 *
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPOR1bits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,159 :: 		UART1_Init_Advanced(2000000, 2, 1, 1);                                     //Inicializa el UART1 con una velocidad de 2Mbps
	MOV	#1, W13
	MOV	#2, W12
	MOV	#33920, W10
	MOV	#30, W11
	MOV	#1, W0
	PUSH	W0
	CALL	_UART1_Init_Advanced
	SUB	#2, W15
;NodoAcelerometro.c,160 :: 		U1RXIE_bit = 1;                                                            //Habilita la interrupcion por UART1 RX *
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;NodoAcelerometro.c,161 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX *
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;NodoAcelerometro.c,162 :: 		IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#16384, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;NodoAcelerometro.c,163 :: 		U1STAbits.URXISEL = 0x00;
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,166 :: 		RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
	MOV.B	#33, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPINR22bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#127, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPINR22bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPINR22bits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,167 :: 		RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
	MOV.B	#8, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPOR2bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPOR2bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPOR2bits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,168 :: 		RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
	MOV	#2304, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR1bits
;NodoAcelerometro.c,169 :: 		SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
	BSET	SPI2STAT, #15
;NodoAcelerometro.c,170 :: 		SPI2_Init();                                                               //Inicializa el modulo SPI2
	CALL	_SPI2_Init
;NodoAcelerometro.c,173 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|STANDBY);                           //Coloco el ADXL en modo STANDBY para pausar las conversiones y limpiar el FIFO
	MOV.B	#5, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;NodoAcelerometro.c,176 :: 		RPINR0 = 0x2E00;                                                           //Asigna INT1 al RB14/RPI46
	MOV	#11776, W0
	MOV	WREG, RPINR0
;NodoAcelerometro.c,177 :: 		INT1IE_bit = 0;                                                            //Habilita la interrupcion externa INT1
	BCLR	INT1IE_bit, BitPos(INT1IE_bit+0)
;NodoAcelerometro.c,178 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;NodoAcelerometro.c,179 :: 		IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,182 :: 		T1CON = 0x0020;
	MOV	#32, W0
	MOV	WREG, T1CON
;NodoAcelerometro.c,183 :: 		T1CON.TON = 0;                                                             //Apaga el Timer1
	BCLR	T1CON, #15
;NodoAcelerometro.c,184 :: 		T1IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR1
	BSET	T1IE_bit, BitPos(T1IE_bit+0)
;NodoAcelerometro.c,185 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR1
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;NodoAcelerometro.c,186 :: 		PR1 = 62500;                                                               //Car ga el preload para un tiempo de 100ms
	MOV	#62500, W0
	MOV	WREG, PR1
;NodoAcelerometro.c,187 :: 		IPC0bits.T1IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR1
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;NodoAcelerometro.c,189 :: 		Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#25, W8
	MOV	#27150, W7
L_ConfiguracionPrincipal24:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal24
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal24
	NOP
;NodoAcelerometro.c,191 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_Muestrear:

;NodoAcelerometro.c,196 :: 		void Muestrear(){
;NodoAcelerometro.c,198 :: 		if (banCiclo==0){
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__Muestrear113
	GOTO	L_Muestrear26
L__Muestrear113:
;NodoAcelerometro.c,200 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|MEASURING);                     //Coloca el ADXL en modo medicion
	MOV.B	#4, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;NodoAcelerometro.c,201 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,203 :: 		} else if (banCiclo==1) {
	GOTO	L_Muestrear27
L_Muestrear26:
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Muestrear114
	GOTO	L_Muestrear28
L__Muestrear114:
;NodoAcelerometro.c,205 :: 		banCiclo = 2;                                                          //Limpia la bandera de ciclo completo
	MOV	#lo_addr(_banCiclo), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,207 :: 		tramaCompleta[0] = contCiclos;                                         //LLena el primer elemento de la tramaCompleta con el contador de ciclos
	MOV	#lo_addr(_tramaCompleta), W1
	MOV	#lo_addr(_contCiclos), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,208 :: 		numFIFO = ADXL355_read_byte(FIFO_ENTRIES);
	MOV.B	#5, W10
	CALL	_ADXL355_read_byte
	MOV	#lo_addr(_numFIFO), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,209 :: 		numSetsFIFO = (numFIFO)/3;                                             //Lee el numero de sets disponibles en el FIFO
	ZE	W0, W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(_numSetsFIFO), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,212 :: 		for (x=0;x<numSetsFIFO;x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear29:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Muestrear115
	GOTO	L_Muestrear30
L__Muestrear115:
;NodoAcelerometro.c,213 :: 		ADXL355_read_FIFO(datosLeidos);                                    //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,214 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Muestrear32:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Muestrear116
	GOTO	L_Muestrear33
L__Muestrear116:
;NodoAcelerometro.c,215 :: 		datosFIFO[y+(x*9)] = datosLeidos[y];                           //LLena la trama datosFIFO
	MOV	_x, W1
	MOV	#9, W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(_y), W0
	ADD	W2, [W0], W1
	MOV	#lo_addr(_datosFIFO), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_datosLeidos), W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,214 :: 		for (y=0;y<9;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,216 :: 		}
	GOTO	L_Muestrear32
L_Muestrear33:
;NodoAcelerometro.c,212 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,217 :: 		}
	GOTO	L_Muestrear29
L_Muestrear30:
;NodoAcelerometro.c,220 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear35:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Muestrear117
	GOTO	L_Muestrear36
L__Muestrear117:
;NodoAcelerometro.c,221 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Muestrear118
	GOTO	L__Muestrear83
L__Muestrear118:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Muestrear119
	GOTO	L__Muestrear82
L__Muestrear119:
	GOTO	L_Muestrear40
L__Muestrear83:
L__Muestrear82:
;NodoAcelerometro.c,222 :: 		tramaCompleta[contFIFO+contMuestras+x] = contMuestras;          //Funciona bien
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_tramaCompleta), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_contMuestras), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,223 :: 		tramaCompleta[contFIFO+contMuestras+x+1] = datosFIFO[x];
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaCompleta), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_datosFIFO), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,224 :: 		contMuestras++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contMuestras), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,225 :: 		} else {
	GOTO	L_Muestrear41
L_Muestrear40:
;NodoAcelerometro.c,226 :: 		tramaCompleta[contFIFO+contMuestras+x] = datosFIFO[x];
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_tramaCompleta), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_datosFIFO), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,227 :: 		}
L_Muestrear41:
;NodoAcelerometro.c,220 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,228 :: 		}
	GOTO	L_Muestrear35
L_Muestrear36:
;NodoAcelerometro.c,231 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;NodoAcelerometro.c,232 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear42:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__Muestrear120
	GOTO	L_Muestrear43
L__Muestrear120:
;NodoAcelerometro.c,233 :: 		tramaCompleta[2500+x] = tiempo[x];
	MOV	#2500, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_tramaCompleta), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,232 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,234 :: 		}
	GOTO	L_Muestrear42
L_Muestrear43:
;NodoAcelerometro.c,236 :: 		contMuestras = 0;                                                      //Limpia el contador de muestras
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,237 :: 		contFIFO = 0;                                                          //Limpia el contador de FIFOs
	CLR	W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,238 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,240 :: 		banLec = 1;                                                            //Activa la bandera de lectura para enviar la trama
	MOV	#lo_addr(_banLec), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,242 :: 		RP1 = 1;                                                               //Genera el pulso P1 para producir la interrupcion en la RPi
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;NodoAcelerometro.c,243 :: 		Delay_us(20);
	MOV	#160, W7
L_Muestrear45:
	DEC	W7
	BRA NZ	L_Muestrear45
	NOP
	NOP
;NodoAcelerometro.c,244 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;NodoAcelerometro.c,246 :: 		}
L_Muestrear28:
L_Muestrear27:
;NodoAcelerometro.c,248 :: 		contCiclos++;                                                              //Incrementa el contador de ciclos
	MOV.B	#1, W1
	MOV	#lo_addr(_contCiclos), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,250 :: 		}
L_end_Muestrear:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Muestrear

_EnviarTramaUART:
	LNK	#0

;NodoAcelerometro.c,255 :: 		void EnviarTramaUART(unsigned short puertoUART, unsigned short direccion, unsigned short numDatos, unsigned short funcion, unsigned char *payload){
; payload start address is: 4 (W2)
	MOV	[W14-8], W2
;NodoAcelerometro.c,259 :: 		if (puertoUART == 1){
	CP.B	W10, #1
	BRA Z	L__EnviarTramaUART122
	GOTO	L__EnviarTramaUART84
L__EnviarTramaUART122:
;NodoAcelerometro.c,260 :: 		UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
	PUSH	W10
	MOV	#58, W10
	CALL	_UART1_Write
;NodoAcelerometro.c,261 :: 		UART1_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W11, W10
	CALL	_UART1_Write
;NodoAcelerometro.c,262 :: 		UART1_Write(numDatos);                                                  //Envia el numero de datos
	ZE	W12, W10
	CALL	_UART1_Write
;NodoAcelerometro.c,263 :: 		UART1_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W13, W10
	CALL	_UART1_Write
	POP	W10
;NodoAcelerometro.c,264 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 2 (W1)
	CLR	W1
; payload end address is: 4 (W2)
; iDatos end address is: 2 (W1)
L_EnviarTramaUART48:
; iDatos start address is: 2 (W1)
; payload start address is: 4 (W2)
	ZE	W12, W0
	CP	W1, W0
	BRA LTU	L__EnviarTramaUART123
	GOTO	L_EnviarTramaUART49
L__EnviarTramaUART123:
;NodoAcelerometro.c,265 :: 		UART1_Write(payload[iDatos]);
	ADD	W2, W1, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;NodoAcelerometro.c,264 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W1
;NodoAcelerometro.c,266 :: 		}
; iDatos end address is: 2 (W1)
	GOTO	L_EnviarTramaUART48
L_EnviarTramaUART49:
;NodoAcelerometro.c,267 :: 		UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART1_Write
;NodoAcelerometro.c,268 :: 		UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART1_Write
; payload end address is: 4 (W2)
	POP	W10
	MOV	W2, W1
;NodoAcelerometro.c,269 :: 		}
	GOTO	L_EnviarTramaUART47
L__EnviarTramaUART84:
;NodoAcelerometro.c,259 :: 		if (puertoUART == 1){
	MOV	W2, W1
;NodoAcelerometro.c,269 :: 		}
L_EnviarTramaUART47:
;NodoAcelerometro.c,271 :: 		if (puertoUART == 2){
; payload start address is: 2 (W1)
	CP.B	W10, #2
	BRA Z	L__EnviarTramaUART124
	GOTO	L_EnviarTramaUART51
L__EnviarTramaUART124:
;NodoAcelerometro.c,272 :: 		UART2_Write(0x3A);                                                      //Envia la cabecera de la trama
	PUSH	W10
	MOV	#58, W10
	CALL	_UART2_Write
;NodoAcelerometro.c,273 :: 		UART2_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W11, W10
	CALL	_UART2_Write
;NodoAcelerometro.c,274 :: 		UART2_Write(numDatos);                                                  //Envia el numero de datos
	ZE	W12, W10
	CALL	_UART2_Write
;NodoAcelerometro.c,275 :: 		UART2_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W13, W10
	CALL	_UART2_Write
	POP	W10
;NodoAcelerometro.c,276 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 4 (W2)
	CLR	W2
; iDatos end address is: 4 (W2)
L_EnviarTramaUART52:
; iDatos start address is: 4 (W2)
; payload start address is: 2 (W1)
; payload end address is: 2 (W1)
	ZE	W12, W0
	CP	W2, W0
	BRA LTU	L__EnviarTramaUART125
	GOTO	L_EnviarTramaUART53
L__EnviarTramaUART125:
; payload end address is: 2 (W1)
;NodoAcelerometro.c,277 :: 		UART2_Write(payload[iDatos]);
; payload start address is: 2 (W1)
	ADD	W1, W2, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART2_Write
	POP	W10
;NodoAcelerometro.c,276 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W2
;NodoAcelerometro.c,278 :: 		}
; payload end address is: 2 (W1)
; iDatos end address is: 4 (W2)
	GOTO	L_EnviarTramaUART52
L_EnviarTramaUART53:
;NodoAcelerometro.c,279 :: 		UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART2_Write
;NodoAcelerometro.c,280 :: 		UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART2_Write
	POP	W10
;NodoAcelerometro.c,281 :: 		}
L_EnviarTramaUART51:
;NodoAcelerometro.c,283 :: 		}
L_end_EnviarTramaUART:
	ULNK
	RETURN
; end of _EnviarTramaUART

_int_1:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;NodoAcelerometro.c,293 :: 		void int_1() org IVT_ADDR_INT1INTERRUPT {
;NodoAcelerometro.c,295 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;NodoAcelerometro.c,298 :: 		horaSistema++;                                                             //Incrementa el reloj del sistema
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaSistema), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,300 :: 		if (horaSistema==86400){                                                   //(24*3600)+(0*60)+(0) = 86400
	MOV	_horaSistema, W2
	MOV	_horaSistema+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__int_1127
	GOTO	L_int_155
L__int_1127:
;NodoAcelerometro.c,301 :: 		horaSistema = 0;                                                        //Reinicia el reloj al llegar a las 24:00:00 horas
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,302 :: 		}
L_int_155:
;NodoAcelerometro.c,304 :: 		if (banInicio==1){
	MOV	#lo_addr(_banInicio), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1128
	GOTO	L_int_156
L__int_1128:
;NodoAcelerometro.c,305 :: 		Muestrear();
	CALL	_Muestrear
;NodoAcelerometro.c,306 :: 		}
L_int_156:
;NodoAcelerometro.c,308 :: 		}
L_end_int_1:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	50
	POP	DSWPAG
	RETFIE
; end of _int_1

_Timer1Int:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;NodoAcelerometro.c,313 :: 		void Timer1Int() org IVT_ADDR_T1INTERRUPT{
;NodoAcelerometro.c,315 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer1
	PUSH	W10
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;NodoAcelerometro.c,317 :: 		numFIFO = ADXL355_read_byte(FIFO_ENTRIES); //75                            //Lee el numero de muestras disponibles en el FIFO
	MOV.B	#5, W10
	CALL	_ADXL355_read_byte
	MOV	#lo_addr(_numFIFO), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,318 :: 		numSetsFIFO = (numFIFO)/3;                 //25                            //Lee el numero de sets disponibles en el FIFO
	ZE	W0, W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(_numSetsFIFO), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,321 :: 		for (x=0;x<numSetsFIFO;x++){
	CLR	W0
	MOV	W0, _x
L_Timer1Int57:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Timer1Int130
	GOTO	L_Timer1Int58
L__Timer1Int130:
;NodoAcelerometro.c,322 :: 		ADXL355_read_FIFO(datosLeidos);                                        //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,323 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Timer1Int60:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Timer1Int131
	GOTO	L_Timer1Int61
L__Timer1Int131:
;NodoAcelerometro.c,324 :: 		datosFIFO[y+(x*9)] = datosLeidos[y];                               //LLena la trama datosFIFO
	MOV	_x, W1
	MOV	#9, W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(_y), W0
	ADD	W2, [W0], W1
	MOV	#lo_addr(_datosFIFO), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_datosLeidos), W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,323 :: 		for (y=0;y<9;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,325 :: 		}
	GOTO	L_Timer1Int60
L_Timer1Int61:
;NodoAcelerometro.c,321 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,326 :: 		}
	GOTO	L_Timer1Int57
L_Timer1Int58:
;NodoAcelerometro.c,329 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	CLR	W0
	MOV	W0, _x
L_Timer1Int63:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Timer1Int132
	GOTO	L_Timer1Int64
L__Timer1Int132:
;NodoAcelerometro.c,330 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int133
	GOTO	L__Timer1Int87
L__Timer1Int133:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int134
	GOTO	L__Timer1Int86
L__Timer1Int134:
	GOTO	L_Timer1Int68
L__Timer1Int87:
L__Timer1Int86:
;NodoAcelerometro.c,331 :: 		tramaCompleta[contFIFO+contMuestras+x] = contMuestras;
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_tramaCompleta), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_contMuestras), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,332 :: 		tramaCompleta[contFIFO+contMuestras+x+1] = datosFIFO[x];
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaCompleta), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_datosFIFO), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,333 :: 		contMuestras++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contMuestras), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,334 :: 		} else {
	GOTO	L_Timer1Int69
L_Timer1Int68:
;NodoAcelerometro.c,335 :: 		tramaCompleta[contFIFO+contMuestras+x] = datosFIFO[x];
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_tramaCompleta), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_datosFIFO), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,336 :: 		}
L_Timer1Int69:
;NodoAcelerometro.c,329 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,337 :: 		}
	GOTO	L_Timer1Int63
L_Timer1Int64:
;NodoAcelerometro.c,339 :: 		contFIFO = (contMuestras*9);                                               //Incrementa el contador de FIFOs
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,341 :: 		contTimer1++;                                                              //Incrementa una unidad cada vez que entra a la interrupcion por Timer1
	MOV.B	#1, W1
	MOV	#lo_addr(_contTimer1), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,343 :: 		if (contTimer1==numTMR1){                                                  //Verifica si se cumplio el numero de interrupciones por TMR1 para la tasa de muestreo seleccionada
	MOV	#lo_addr(_contTimer1), W0
	ZE	[W0], W1
	MOV	#lo_addr(_numTMR1), W0
	SE	[W0], W0
	CP	W1, W0
	BRA Z	L__Timer1Int135
	GOTO	L_Timer1Int70
L__Timer1Int135:
;NodoAcelerometro.c,344 :: 		T1CON.TON = 0;                                                          //Apaga el Timer1
	BCLR	T1CON, #15
;NodoAcelerometro.c,345 :: 		banCiclo = 1;                                                           //Activa la bandera que indica que se completo un ciclo de medicion
	MOV	#lo_addr(_banCiclo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,346 :: 		contTimer1 = 0;                                                         //Limpia el contador de interrupciones por Timer1
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,347 :: 		}
L_Timer1Int70:
;NodoAcelerometro.c,349 :: 		}
L_end_Timer1Int:
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	50
	POP	DSWPAG
	RETFIE
; end of _Timer1Int

_urx_1:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;NodoAcelerometro.c,354 :: 		void urx_1() org  IVT_ADDR_U1RXINTERRUPT {
;NodoAcelerometro.c,356 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;NodoAcelerometro.c,358 :: 		byteUART = U1RXREG;
	MOV	#lo_addr(_byteUART), W1
	MOV.B	U1RXREG, WREG
	MOV.B	W0, [W1]
;NodoAcelerometro.c,359 :: 		OERR_bit = 0;                                                              //Limpia este bit para limpiar el FIFO UART
	BCLR	OERR_bit, BitPos(OERR_bit+0)
;NodoAcelerometro.c,361 :: 		if ((banUTI==0)&&(byteUART==0x3A)){                                        //Verifica si el primer byte recibido sea la cabecera de trama
	MOV	#lo_addr(_banUTI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1137
	GOTO	L__urx_190
L__urx_1137:
	MOV	#lo_addr(_byteUART), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__urx_1138
	GOTO	L__urx_189
L__urx_1138:
L__urx_188:
;NodoAcelerometro.c,362 :: 		banUTI = 1;
	MOV	#lo_addr(_banUTI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,363 :: 		i_uart = 0;
	CLR	W0
	MOV	W0, _i_uart
;NodoAcelerometro.c,361 :: 		if ((banUTI==0)&&(byteUART==0x3A)){                                        //Verifica si el primer byte recibido sea la cabecera de trama
L__urx_190:
L__urx_189:
;NodoAcelerometro.c,365 :: 		if (banUTI==1){
	MOV	#lo_addr(_banUTI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1139
	GOTO	L_urx_174
L__urx_1139:
;NodoAcelerometro.c,366 :: 		if (byteUART!=0x0A){
	MOV	#lo_addr(_byteUART), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA NZ	L__urx_1140
	GOTO	L_urx_175
L__urx_1140:
;NodoAcelerometro.c,367 :: 		tramaUART1[i_uart] = byteUART;                                       //Almacena el byte recibido en la trama, mientras este sea diferente del segundo byte del delimitador de final de trama
	MOV	#lo_addr(_tramaUART1), W1
	MOV	#lo_addr(_i_uart), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteUART), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,368 :: 		i_uart++;
	MOV	#1, W1
	MOV	#lo_addr(_i_uart), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,369 :: 		} else {
	GOTO	L_urx_176
L_urx_175:
;NodoAcelerometro.c,370 :: 		banUTI = 0;                                                          //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banUTI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,371 :: 		banUTC = 1;                                                          //Activa la bandera de trama completa
	MOV	#lo_addr(_banUTC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,372 :: 		}
L_urx_176:
;NodoAcelerometro.c,373 :: 		}
L_urx_174:
;NodoAcelerometro.c,375 :: 		if (banUTC==1){
	MOV	#lo_addr(_banUTC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1141
	GOTO	L_urx_177
L__urx_1141:
;NodoAcelerometro.c,377 :: 		TEST = ~TEST;                                                          //Indica si se completo la trama
	BTG	LATB12_bit, BitPos(LATB12_bit+0)
;NodoAcelerometro.c,378 :: 		for (x=0;x<6;x++) {
	CLR	W0
	MOV	W0, _x
L_urx_178:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1142
	GOTO	L_urx_179
L__urx_1142:
;NodoAcelerometro.c,379 :: 		tiempo[x] = tramaUART1[x+4];                                       //LLeno la trama tiempo con el payload de la trama recuperada
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	ADD	W0, #4, W1
	MOV	#lo_addr(_tramaUART1), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,378 :: 		for (x=0;x<6;x++) {
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,380 :: 		}
	GOTO	L_urx_178
L_urx_179:
;NodoAcelerometro.c,381 :: 		banSetReloj=1;                                                         //Activa la bandera para enviar la hora a la RPI por SPI
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,390 :: 		EnviarTramaUART(1, 255, 6, 2, tiempo);
	MOV.B	#2, W13
	MOV.B	#6, W12
	MOV.B	#255, W11
	MOV.B	#1, W10
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_EnviarTramaUART
	SUB	#2, W15
;NodoAcelerometro.c,393 :: 		banUTC = 0;
	MOV	#lo_addr(_banUTC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,394 :: 		}
L_urx_177:
;NodoAcelerometro.c,397 :: 		}
L_end_urx_1:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	50
	POP	DSWPAG
	RETFIE
; end of _urx_1
