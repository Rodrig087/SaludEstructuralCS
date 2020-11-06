
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
	BRA NZ	L__ADXL355_init386
	GOTO	L_ADXL355_init4
L__ADXL355_init386:
	CP.B	W10, #2
	BRA NZ	L__ADXL355_init387
	GOTO	L_ADXL355_init5
L__ADXL355_init387:
	CP.B	W10, #4
	BRA NZ	L__ADXL355_init388
	GOTO	L_ADXL355_init6
L__ADXL355_init388:
	CP.B	W10, #8
	BRA NZ	L__ADXL355_init389
	GOTO	L_ADXL355_init7
L__ADXL355_init389:
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
	BRA Z	L__ADXL355_read_data393
	GOTO	L_ADXL355_read_data8
L__ADXL355_read_data393:
;adxl355_spi.c,152 :: 		CS_ADXL355=0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,153 :: 		for (j=0;j<9;j++){
; j start address is: 4 (W2)
	CLR	W2
; j end address is: 4 (W2)
L_ADXL355_read_data9:
; j start address is: 4 (W2)
	CP.B	W2, #9
	BRA LTU	L__ADXL355_read_data394
	GOTO	L_ADXL355_read_data10
L__ADXL355_read_data394:
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
	BRA LTU	L__ADXL355_read_data395
	GOTO	L_ADXL355_read_data14
L__ADXL355_read_data395:
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

_DS3234_init:

;tiempo_rtc.c,55 :: 		void DS3234_init(){
;tiempo_rtc.c,57 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI2_Init_Advanced
	SUB	#8, W15
;tiempo_rtc.c,58 :: 		DS3234_write_byte(Control,0x20);
	MOV.B	#32, W11
	MOV.B	#142, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,59 :: 		DS3234_write_byte(ControlStatus,0x08);
	MOV.B	#8, W11
	MOV.B	#143, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,60 :: 		SPI2_Init();
	CALL	_SPI2_Init
;tiempo_rtc.c,62 :: 		}
L_end_DS3234_init:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _DS3234_init

_DS3234_write_byte:

;tiempo_rtc.c,65 :: 		void DS3234_write_byte(unsigned char address, unsigned char value){
;tiempo_rtc.c,67 :: 		CS_DS3234 = 0;
	PUSH	W10
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;tiempo_rtc.c,68 :: 		SPI2_Write(address);
	ZE	W10, W10
	CALL	_SPI2_Write
;tiempo_rtc.c,69 :: 		SPI2_Write(value);
	ZE	W11, W10
	CALL	_SPI2_Write
;tiempo_rtc.c,70 :: 		CS_DS3234 = 1;
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;tiempo_rtc.c,72 :: 		}
L_end_DS3234_write_byte:
	POP	W10
	RETURN
; end of _DS3234_write_byte

_DS3234_read_byte:

;tiempo_rtc.c,75 :: 		unsigned char DS3234_read_byte(unsigned char address){
;tiempo_rtc.c,77 :: 		unsigned char value = 0x00;
	PUSH	W10
;tiempo_rtc.c,78 :: 		CS_DS3234 = 0;
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;tiempo_rtc.c,79 :: 		SPI2_Write(address);
	ZE	W10, W10
	CALL	_SPI2_Write
;tiempo_rtc.c,80 :: 		value = SPI2_Read(0);
	CLR	W10
	CALL	_SPI2_Read
;tiempo_rtc.c,81 :: 		CS_DS3234 = 1;
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;tiempo_rtc.c,82 :: 		return value;
;tiempo_rtc.c,84 :: 		}
;tiempo_rtc.c,82 :: 		return value;
;tiempo_rtc.c,84 :: 		}
L_end_DS3234_read_byte:
	POP	W10
	RETURN
; end of _DS3234_read_byte

_DS3234_setDate:
	LNK	#14

;tiempo_rtc.c,87 :: 		void DS3234_setDate(unsigned long longHora, unsigned long longFecha){
;tiempo_rtc.c,97 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);
	PUSH	W10
	PUSH	W11
	PUSH.D	W12
	PUSH.D	W10
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI2_Init_Advanced
	SUB	#8, W15
	POP.D	W10
	POP.D	W12
;tiempo_rtc.c,99 :: 		anio = (short)(longFecha / 10000);
	PUSH.D	W12
	PUSH.D	W10
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	POP.D	W12
	MOV.B	W0, [W14+4]
;tiempo_rtc.c,100 :: 		mes = (short)((longFecha%10000) / 100);
	PUSH.D	W10
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
	MOV.B	W0, [W14+3]
;tiempo_rtc.c,101 :: 		dia = (short)((longFecha%10000) % 100);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W10
	MOV.B	W0, [W14+2]
;tiempo_rtc.c,103 :: 		hora = (short)(longHora / 3600);
	PUSH.D	W10
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	MOV.B	W0, [W14+0]
;tiempo_rtc.c,104 :: 		minuto = (short)((longHora%3600) / 60);
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
;tiempo_rtc.c,105 :: 		segundo = (short)((longHora%3600) % 60);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
; segundo start address is: 8 (W4)
	MOV.B	W0, W4
;tiempo_rtc.c,107 :: 		anio = Dec2Bcd(anio);
	MOV.B	[W14+4], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+4]
;tiempo_rtc.c,108 :: 		dia = Dec2Bcd(dia);
	MOV.B	[W14+2], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+2]
;tiempo_rtc.c,109 :: 		mes = Dec2Bcd(mes);
	MOV.B	[W14+3], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+3]
;tiempo_rtc.c,110 :: 		segundo = Dec2Bcd(segundo);
	MOV.B	W4, W10
; segundo end address is: 8 (W4)
	CALL	_Dec2Bcd
; segundo start address is: 8 (W4)
	MOV.B	W0, W4
;tiempo_rtc.c,111 :: 		minuto = Dec2Bcd(minuto);
	MOV.B	[W14+1], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+1]
;tiempo_rtc.c,112 :: 		hora = Dec2Bcd(hora);
	MOV.B	[W14+0], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+0]
;tiempo_rtc.c,114 :: 		DS3234_write_byte(Segundos_Esc, segundo);
	MOV.B	W4, W11
; segundo end address is: 8 (W4)
	MOV.B	#128, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,115 :: 		DS3234_write_byte(Minutos_Esc, minuto);
	MOV.B	[W14+1], W11
	MOV.B	#129, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,116 :: 		DS3234_write_byte(Horas_Esc, hora);
	MOV.B	[W14+0], W11
	MOV.B	#130, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,117 :: 		DS3234_write_byte(DiaMes_Esc, dia);
	MOV.B	[W14+2], W11
	MOV.B	#132, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,118 :: 		DS3234_write_byte(Mes_Esc, mes);
	MOV.B	[W14+3], W11
	MOV.B	#133, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,119 :: 		DS3234_write_byte(Anio_Esc, anio);
	MOV.B	[W14+4], W11
	MOV.B	#134, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,121 :: 		SPI2_Init();
	CALL	_SPI2_Init
;tiempo_rtc.c,125 :: 		}
;tiempo_rtc.c,123 :: 		return;
;tiempo_rtc.c,125 :: 		}
L_end_DS3234_setDate:
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _DS3234_setDate

_RecuperarHoraRTC:
	LNK	#4

;tiempo_rtc.c,128 :: 		unsigned long RecuperarHoraRTC(){
;tiempo_rtc.c,136 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI2_Init_Advanced
	SUB	#8, W15
;tiempo_rtc.c,138 :: 		valueRead = DS3234_read_byte(Segundos_Lec);
	CLR	W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,139 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,140 :: 		segundo = (long)valueRead;
; segundo start address is: 12 (W6)
	ZE	W0, W6
	CLR	W7
;tiempo_rtc.c,141 :: 		valueRead = DS3234_read_byte(Minutos_Lec);
	MOV.B	#1, W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,142 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,143 :: 		minuto = (long)valueRead;
; minuto start address is: 16 (W8)
	ZE	W0, W8
	CLR	W9
;tiempo_rtc.c,145 :: 		valueRead = DS3234_read_byte(Horas_Lec);
	MOV.B	#2, W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,146 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,147 :: 		hora = (long)valueRead;
	ZE	W0, W0
	CLR	W1
;tiempo_rtc.c,149 :: 		horaRTC = (hora*3600)+(minuto*60)+(segundo);                               //Calcula el segundo actual = hh*3600 + mm*60 + ss
	MOV	#3600, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV.D	W8, W0
	MOV	#60, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
; minuto end address is: 16 (W8)
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	ADD	W2, W0, W0
	ADDC	W3, W1, W1
; horaRTC start address is: 4 (W2)
	ADD	W0, W6, W2
	ADDC	W1, W7, W3
; segundo end address is: 12 (W6)
;tiempo_rtc.c,151 :: 		SPI2_Init();
	CALL	_SPI2_Init
;tiempo_rtc.c,153 :: 		return horaRTC;
	MOV.D	W2, W0
; horaRTC end address is: 4 (W2)
;tiempo_rtc.c,155 :: 		}
;tiempo_rtc.c,153 :: 		return horaRTC;
;tiempo_rtc.c,155 :: 		}
L_end_RecuperarHoraRTC:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _RecuperarHoraRTC

_RecuperarFechaRTC:
	LNK	#4

;tiempo_rtc.c,158 :: 		unsigned long RecuperarFechaRTC(){
;tiempo_rtc.c,166 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CLR	W13
	MOV	#28, W12
	CLR	W11
	MOV	#32, W10
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CLR	W0
	PUSH	W0
	CALL	_SPI2_Init_Advanced
	SUB	#8, W15
;tiempo_rtc.c,168 :: 		valueRead = DS3234_read_byte(DiaMes_Lec);
	MOV.B	#4, W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,169 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,170 :: 		dia = (long)valueRead;
; dia start address is: 12 (W6)
	ZE	W0, W6
	CLR	W7
;tiempo_rtc.c,171 :: 		valueRead = 0x1F & DS3234_read_byte(Mes_Lec);
	MOV.B	#5, W10
	CALL	_DS3234_read_byte
	ZE	W0, W0
	AND	W0, #31, W0
;tiempo_rtc.c,172 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,173 :: 		mes = (long)valueRead;
; mes start address is: 16 (W8)
	ZE	W0, W8
	CLR	W9
;tiempo_rtc.c,174 :: 		valueRead = DS3234_read_byte(Anio_Lec);
	MOV.B	#6, W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,175 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,176 :: 		anio = (long)valueRead;
	ZE	W0, W0
	CLR	W1
;tiempo_rtc.c,178 :: 		fechaRTC = (anio*10000)+(mes*100)+(dia);                                   //10000*aa + 100*mm + dd
	MOV	#10000, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV.D	W8, W0
	MOV	#100, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
; mes end address is: 16 (W8)
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	ADD	W2, W0, W0
	ADDC	W3, W1, W1
; fechaRTC start address is: 4 (W2)
	ADD	W0, W6, W2
	ADDC	W1, W7, W3
; dia end address is: 12 (W6)
;tiempo_rtc.c,180 :: 		SPI2_Init();
	CALL	_SPI2_Init
;tiempo_rtc.c,182 :: 		return fechaRTC;
	MOV.D	W2, W0
; fechaRTC end address is: 4 (W2)
;tiempo_rtc.c,184 :: 		}
;tiempo_rtc.c,182 :: 		return fechaRTC;
;tiempo_rtc.c,184 :: 		}
L_end_RecuperarFechaRTC:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _RecuperarFechaRTC

_IncrementarFecha:
	LNK	#4

;tiempo_rtc.c,187 :: 		unsigned long IncrementarFecha(unsigned long longFecha){
;tiempo_rtc.c,194 :: 		anio = longFecha / 10000;
	PUSH.D	W10
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
; anio start address is: 4 (W2)
	MOV.D	W0, W2
;tiempo_rtc.c,195 :: 		mes = (longFecha%10000) / 100;
	PUSH.D	W2
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Modulus_32x32
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W2
; mes start address is: 8 (W4)
	MOV.D	W0, W4
;tiempo_rtc.c,196 :: 		dia = (longFecha%10000) % 100;
	MOV	[W14+0], W0
	MOV	[W14+2], W1
	PUSH.D	W4
	PUSH.D	W2
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W2
	POP.D	W4
; dia start address is: 12 (W6)
	MOV.D	W0, W6
;tiempo_rtc.c,198 :: 		if (dia<28){
	CP	W0, #28
	CPB	W1, #0
	BRA LTU	L__IncrementarFecha404
	GOTO	L_IncrementarFecha18
L__IncrementarFecha404:
;tiempo_rtc.c,199 :: 		dia++;
; dia start address is: 16 (W8)
	ADD	W6, #1, W8
	ADDC	W7, #0, W9
; dia end address is: 12 (W6)
;tiempo_rtc.c,200 :: 		} else {
; dia end address is: 16 (W8)
	MOV.D	W4, W6
	GOTO	L_IncrementarFecha19
L_IncrementarFecha18:
;tiempo_rtc.c,201 :: 		if (mes==2){
; dia start address is: 12 (W6)
	CP	W4, #2
	CPB	W5, #0
	BRA Z	L__IncrementarFecha405
	GOTO	L_IncrementarFecha20
L__IncrementarFecha405:
;tiempo_rtc.c,203 :: 		if (((anio-16)%4)==0){
	SUB	W2, #16, W0
	SUBB	W3, #0, W1
	AND	W0, #3, W0
	AND	W1, #0, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__IncrementarFecha406
	GOTO	L_IncrementarFecha21
L__IncrementarFecha406:
;tiempo_rtc.c,204 :: 		if (dia==29){
	CP	W6, #29
	CPB	W7, #0
	BRA Z	L__IncrementarFecha407
	GOTO	L_IncrementarFecha22
L__IncrementarFecha407:
; dia end address is: 12 (W6)
;tiempo_rtc.c,205 :: 		dia = 1;
; dia start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,206 :: 		mes++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
;tiempo_rtc.c,207 :: 		} else {
; dia end address is: 0 (W0)
	GOTO	L_IncrementarFecha23
L_IncrementarFecha22:
;tiempo_rtc.c,208 :: 		dia++;
; dia start address is: 0 (W0)
; dia start address is: 12 (W6)
	ADD	W6, #1, W0
	ADDC	W7, #0, W1
; dia end address is: 12 (W6)
; mes end address is: 8 (W4)
; dia end address is: 0 (W0)
;tiempo_rtc.c,209 :: 		}
L_IncrementarFecha23:
;tiempo_rtc.c,210 :: 		} else {
; dia start address is: 0 (W0)
; mes start address is: 8 (W4)
	MOV.D	W0, W8
; dia end address is: 0 (W0)
	MOV.D	W4, W6
	GOTO	L_IncrementarFecha24
L_IncrementarFecha21:
;tiempo_rtc.c,211 :: 		dia = 1;
; dia start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,212 :: 		mes++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
	MOV.D	W0, W8
; mes end address is: 8 (W4)
; dia end address is: 0 (W0)
	MOV.D	W4, W6
;tiempo_rtc.c,213 :: 		}
L_IncrementarFecha24:
;tiempo_rtc.c,214 :: 		} else {
; mes start address is: 12 (W6)
; dia start address is: 16 (W8)
; mes end address is: 12 (W6)
; dia end address is: 16 (W8)
	GOTO	L_IncrementarFecha25
L_IncrementarFecha20:
;tiempo_rtc.c,215 :: 		if (dia<30){
; mes start address is: 8 (W4)
; dia start address is: 12 (W6)
	CP	W6, #30
	CPB	W7, #0
	BRA LTU	L__IncrementarFecha408
	GOTO	L_IncrementarFecha26
L__IncrementarFecha408:
;tiempo_rtc.c,216 :: 		dia++;
; dia start address is: 0 (W0)
	ADD	W6, #1, W0
	ADDC	W7, #0, W1
; dia end address is: 12 (W6)
;tiempo_rtc.c,217 :: 		} else {
	PUSH.D	W4
; dia end address is: 0 (W0)
	MOV.D	W2, W4
	MOV.D	W0, W2
	POP.D	W0
	GOTO	L_IncrementarFecha27
L_IncrementarFecha26:
;tiempo_rtc.c,218 :: 		if (mes==4||mes==6||mes==9||mes==11){
; dia start address is: 12 (W6)
	CP	W4, #4
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha409
	GOTO	L__IncrementarFecha337
L__IncrementarFecha409:
	CP	W4, #6
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha410
	GOTO	L__IncrementarFecha336
L__IncrementarFecha410:
	CP	W4, #9
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha411
	GOTO	L__IncrementarFecha335
L__IncrementarFecha411:
	CP	W4, #11
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha412
	GOTO	L__IncrementarFecha334
L__IncrementarFecha412:
	MOV.D	W4, W0
	MOV.D	W6, W4
	GOTO	L_IncrementarFecha30
L__IncrementarFecha337:
L__IncrementarFecha336:
L__IncrementarFecha335:
L__IncrementarFecha334:
;tiempo_rtc.c,219 :: 		if (dia==30){
	CP	W6, #30
	CPB	W7, #0
	BRA Z	L__IncrementarFecha413
	GOTO	L_IncrementarFecha31
L__IncrementarFecha413:
; dia end address is: 12 (W6)
;tiempo_rtc.c,220 :: 		dia = 1;
; dia start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,221 :: 		mes++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
;tiempo_rtc.c,222 :: 		} else {
	PUSH.D	W0
; dia end address is: 0 (W0)
	MOV.D	W4, W0
	POP.D	W4
	GOTO	L_IncrementarFecha32
L_IncrementarFecha31:
;tiempo_rtc.c,223 :: 		dia++;
; dia start address is: 0 (W0)
; dia start address is: 12 (W6)
	ADD	W6, #1, W0
	ADDC	W7, #0, W1
; dia end address is: 12 (W6)
	PUSH.D	W0
; mes end address is: 8 (W4)
; dia end address is: 0 (W0)
	MOV.D	W4, W0
	POP.D	W4
;tiempo_rtc.c,224 :: 		}
L_IncrementarFecha32:
;tiempo_rtc.c,225 :: 		}
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
L_IncrementarFecha30:
;tiempo_rtc.c,226 :: 		if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
; mes start address is: 0 (W0)
; dia start address is: 8 (W4)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha414
	GOTO	L__IncrementarFecha347
L__IncrementarFecha414:
	CP	W0, #1
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha415
	GOTO	L__IncrementarFecha343
L__IncrementarFecha415:
	CP	W0, #3
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha416
	GOTO	L__IncrementarFecha342
L__IncrementarFecha416:
	CP	W0, #5
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha417
	GOTO	L__IncrementarFecha341
L__IncrementarFecha417:
	CP	W0, #7
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha418
	GOTO	L__IncrementarFecha340
L__IncrementarFecha418:
	CP	W0, #8
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha419
	GOTO	L__IncrementarFecha339
L__IncrementarFecha419:
	CP	W0, #10
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha420
	GOTO	L__IncrementarFecha338
L__IncrementarFecha420:
	GOTO	L_IncrementarFecha37
L__IncrementarFecha343:
L__IncrementarFecha342:
L__IncrementarFecha341:
L__IncrementarFecha340:
L__IncrementarFecha339:
L__IncrementarFecha338:
L__IncrementarFecha331:
;tiempo_rtc.c,227 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha421
	GOTO	L_IncrementarFecha38
L__IncrementarFecha421:
;tiempo_rtc.c,228 :: 		dia = 1;
	MOV	#1, W4
	MOV	#0, W5
;tiempo_rtc.c,229 :: 		mes++;
	ADD	W0, #1, W0
	ADDC	W1, #0, W1
;tiempo_rtc.c,230 :: 		} else {
	GOTO	L_IncrementarFecha39
L_IncrementarFecha38:
;tiempo_rtc.c,231 :: 		dia++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
;tiempo_rtc.c,232 :: 		}
L_IncrementarFecha39:
;tiempo_rtc.c,233 :: 		}
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
L_IncrementarFecha37:
;tiempo_rtc.c,226 :: 		if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
; mes start address is: 0 (W0)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
	GOTO	L__IncrementarFecha344
L__IncrementarFecha347:
L__IncrementarFecha344:
;tiempo_rtc.c,234 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha422
	GOTO	L__IncrementarFecha348
L__IncrementarFecha422:
	CP	W0, #12
	CPB	W1, #0
	BRA Z	L__IncrementarFecha423
	GOTO	L__IncrementarFecha349
L__IncrementarFecha423:
L__IncrementarFecha330:
;tiempo_rtc.c,235 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha424
	GOTO	L_IncrementarFecha43
L__IncrementarFecha424:
; mes end address is: 0 (W0)
;tiempo_rtc.c,236 :: 		dia = 1;
	MOV	#1, W4
	MOV	#0, W5
;tiempo_rtc.c,237 :: 		mes = 1;
; mes start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,238 :: 		anio++;
	ADD	W2, #1, W2
	ADDC	W3, #0, W3
;tiempo_rtc.c,239 :: 		} else {
	GOTO	L_IncrementarFecha44
L_IncrementarFecha43:
;tiempo_rtc.c,240 :: 		dia++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
;tiempo_rtc.c,241 :: 		}
L_IncrementarFecha44:
;tiempo_rtc.c,234 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; anio start address is: 4 (W2)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha346
L__IncrementarFecha348:
L__IncrementarFecha346:
; mes start address is: 0 (W0)
; anio start address is: 4 (W2)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha345
L__IncrementarFecha349:
L__IncrementarFecha345:
;tiempo_rtc.c,243 :: 		}
; dia start address is: 8 (W4)
; anio start address is: 4 (W2)
; mes start address is: 0 (W0)
	PUSH.D	W2
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	MOV.D	W4, W2
	POP.D	W4
L_IncrementarFecha27:
;tiempo_rtc.c,244 :: 		}
; mes start address is: 0 (W0)
; anio start address is: 8 (W4)
; dia start address is: 4 (W2)
	MOV.D	W0, W6
; mes end address is: 0 (W0)
; anio end address is: 8 (W4)
; dia end address is: 4 (W2)
	MOV.D	W2, W8
	MOV.D	W4, W2
L_IncrementarFecha25:
;tiempo_rtc.c,246 :: 		}
; dia start address is: 16 (W8)
; anio start address is: 4 (W2)
; mes start address is: 12 (W6)
; mes end address is: 12 (W6)
; anio end address is: 4 (W2)
; dia end address is: 16 (W8)
L_IncrementarFecha19:
;tiempo_rtc.c,248 :: 		fechaInc = (anio*10000)+(mes*100)+(dia);                                   //10000*aa + 100*mm + dd
; mes start address is: 12 (W6)
; anio start address is: 4 (W2)
; dia start address is: 16 (W8)
	MOV	#10000, W0
	MOV	#0, W1
	CALL	__Multiply_32x32
; anio end address is: 4 (W2)
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
	MOV.D	W6, W0
	MOV	#100, W2
	MOV	#0, W3
	CALL	__Multiply_32x32
; mes end address is: 12 (W6)
	MOV	[W14+0], W2
	MOV	[W14+2], W3
	ADD	W2, W0, W0
	ADDC	W3, W1, W1
	ADD	W0, W8, W0
	ADDC	W1, W9, W1
; dia end address is: 16 (W8)
;tiempo_rtc.c,249 :: 		return fechaInc;
;tiempo_rtc.c,251 :: 		}
L_end_IncrementarFecha:
	ULNK
	RETURN
; end of _IncrementarFecha

_AjustarTiempoSistema:
	LNK	#14

;tiempo_rtc.c,254 :: 		void AjustarTiempoSistema(unsigned long longHora, unsigned long longFecha, unsigned short *tramaTiempoSistema){
	MOV	[W14-8], W0
	MOV	W0, [W14-8]
;tiempo_rtc.c,263 :: 		anio = (short)(longFecha / 10000);
	PUSH.D	W12
	PUSH.D	W10
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	POP.D	W12
	MOV.B	W0, [W14+4]
;tiempo_rtc.c,264 :: 		mes = (short)((longFecha%10000) / 100);
	PUSH.D	W10
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
	MOV.B	W0, [W14+3]
;tiempo_rtc.c,265 :: 		dia = (short)((longFecha%10000) % 100);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W10
	MOV.B	W0, [W14+2]
;tiempo_rtc.c,267 :: 		hora = (short)(longHora / 3600);
	PUSH.D	W10
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	MOV.B	W0, [W14+0]
;tiempo_rtc.c,268 :: 		minuto = (short)((longHora%3600) / 60);
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
;tiempo_rtc.c,269 :: 		segundo = (short)((longHora%3600) % 60);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
; segundo start address is: 4 (W2)
	MOV.B	W0, W2
;tiempo_rtc.c,271 :: 		tramaTiempoSistema[0] = anio;
	MOV	[W14-8], W1
	MOV.B	[W14+4], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,272 :: 		tramaTiempoSistema[1] = mes;
	MOV	[W14-8], W0
	ADD	W0, #1, W1
	MOV.B	[W14+3], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,273 :: 		tramaTiempoSistema[2] = dia;
	MOV	[W14-8], W0
	ADD	W0, #2, W1
	MOV.B	[W14+2], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,274 :: 		tramaTiempoSistema[3] = hora;
	MOV	[W14-8], W0
	ADD	W0, #3, W1
	MOV.B	[W14+0], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,275 :: 		tramaTiempoSistema[4] = minuto;
	MOV	[W14-8], W0
	ADD	W0, #4, W1
	MOV.B	[W14+1], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,276 :: 		tramaTiempoSistema[5] = segundo;
	MOV	[W14-8], W0
	ADD	W0, #5, W0
	MOV.B	W2, [W0]
; segundo end address is: 4 (W2)
;tiempo_rtc.c,278 :: 		}
L_end_AjustarTiempoSistema:
	ULNK
	RETURN
; end of _AjustarTiempoSistema

_EnviarTramaRS485:
	LNK	#0

;rs485.c,17 :: 		void EnviarTramaRS485(unsigned short puertoUART, unsigned short direccion, unsigned short funcion, unsigned int numDatos, unsigned char *payload){
; payload start address is: 4 (W2)
	MOV	[W14-8], W2
;rs485.c,25 :: 		ptrnumDatos = (unsigned char *) & numDatos;
	MOV	#lo_addr(W13), W0
;rs485.c,26 :: 		numDatosLSB = *(ptrnumDatos);                                              //LSB numDatos
; numDatosLSB start address is: 8 (W4)
	MOV.B	W13, W4
;rs485.c,27 :: 		numDatosMSB = *(ptrnumDatos+1);                                            //MSB numDatos
	INC	W0
; numDatosMSB start address is: 2 (W1)
	MOV.B	[W0], W1
;rs485.c,30 :: 		if (puertoUART == 1){
	CP.B	W10, #1
	BRA Z	L__EnviarTramaRS485427
	GOTO	L__EnviarTramaRS485350
L__EnviarTramaRS485427:
;rs485.c,31 :: 		MSRS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSET	MSRS485, BitPos(MSRS485+0)
;rs485.c,32 :: 		UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
	PUSH	W10
	MOV	#58, W10
	CALL	_UART1_Write
;rs485.c,33 :: 		UART1_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W11, W10
	CALL	_UART1_Write
;rs485.c,34 :: 		UART1_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W12, W10
	CALL	_UART1_Write
;rs485.c,35 :: 		UART1_Write(numDatosLSB);                                               //Envia el LSB del numero de datos
	ZE	W4, W10
	CALL	_UART1_Write
;rs485.c,36 :: 		UART1_Write(numDatosMSB);                                               //Envia el MSB del numero de datos
	ZE	W1, W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,37 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 6 (W3)
	CLR	W3
; numDatosMSB end address is: 2 (W1)
; numDatosLSB end address is: 8 (W4)
; payload end address is: 4 (W2)
; iDatos end address is: 6 (W3)
L_EnviarTramaRS48546:
; iDatos start address is: 6 (W3)
; numDatosMSB start address is: 2 (W1)
; numDatosLSB start address is: 8 (W4)
; payload start address is: 4 (W2)
	CP	W3, W13
	BRA LTU	L__EnviarTramaRS485428
	GOTO	L_EnviarTramaRS48547
L__EnviarTramaRS485428:
;rs485.c,38 :: 		UART1_Write(payload[iDatos]);
	ADD	W2, W3, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,37 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W3
;rs485.c,39 :: 		}
; iDatos end address is: 6 (W3)
	GOTO	L_EnviarTramaRS48546
L_EnviarTramaRS48547:
;rs485.c,40 :: 		UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART1_Write
;rs485.c,41 :: 		UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART1_Write
;rs485.c,42 :: 		UART1_Write(0x00);                                                      //Envia un byte adicional
	CLR	W10
	CALL	_UART1_Write
; numDatosMSB end address is: 2 (W1)
; numDatosLSB end address is: 8 (W4)
; payload end address is: 4 (W2)
	POP	W10
	MOV.B	W1, W3
	MOV	W2, W1
	MOV.B	W4, W2
;rs485.c,43 :: 		while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48549:
; payload start address is: 2 (W1)
; numDatosLSB start address is: 4 (W2)
; numDatosMSB start address is: 6 (W3)
	CALL	_UART1_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485429
	GOTO	L_EnviarTramaRS48550
L__EnviarTramaRS485429:
	GOTO	L_EnviarTramaRS48549
L_EnviarTramaRS48550:
;rs485.c,44 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
; numDatosMSB end address is: 6 (W3)
; numDatosLSB end address is: 4 (W2)
; payload end address is: 2 (W1)
	MOV.B	W3, W0
;rs485.c,45 :: 		}
	GOTO	L_EnviarTramaRS48545
L__EnviarTramaRS485350:
;rs485.c,30 :: 		if (puertoUART == 1){
	MOV.B	W1, W0
	MOV	W2, W1
	MOV.B	W4, W2
;rs485.c,45 :: 		}
L_EnviarTramaRS48545:
;rs485.c,47 :: 		if (puertoUART == 2){
; numDatosMSB start address is: 0 (W0)
; numDatosLSB start address is: 4 (W2)
; payload start address is: 2 (W1)
	CP.B	W10, #2
	BRA Z	L__EnviarTramaRS485430
	GOTO	L_EnviarTramaRS48551
L__EnviarTramaRS485430:
;rs485.c,48 :: 		MSRS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSET	MSRS485, BitPos(MSRS485+0)
;rs485.c,49 :: 		UART2_Write(0x3A);                                                      //Envia la cabecera de la trama
	PUSH	W10
	MOV	#58, W10
	CALL	_UART2_Write
;rs485.c,50 :: 		UART2_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W11, W10
	CALL	_UART2_Write
;rs485.c,51 :: 		UART2_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W12, W10
	CALL	_UART2_Write
;rs485.c,52 :: 		UART2_Write(numDatosLSB);                                               //Envia el LSB del numero de datos
; numDatosLSB end address is: 4 (W2)
	ZE	W2, W10
	CALL	_UART2_Write
;rs485.c,53 :: 		UART2_Write(numDatosMSB);                                               //Envia el MSB del numero de datos
; numDatosMSB end address is: 0 (W0)
	ZE	W0, W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,54 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 4 (W2)
	CLR	W2
; iDatos end address is: 4 (W2)
L_EnviarTramaRS48552:
; iDatos start address is: 4 (W2)
; payload start address is: 2 (W1)
; payload end address is: 2 (W1)
	CP	W2, W13
	BRA LTU	L__EnviarTramaRS485431
	GOTO	L_EnviarTramaRS48553
L__EnviarTramaRS485431:
; payload end address is: 2 (W1)
;rs485.c,55 :: 		UART2_Write(payload[iDatos]);
; payload start address is: 2 (W1)
	ADD	W1, W2, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,54 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W2
;rs485.c,56 :: 		}
; payload end address is: 2 (W1)
; iDatos end address is: 4 (W2)
	GOTO	L_EnviarTramaRS48552
L_EnviarTramaRS48553:
;rs485.c,57 :: 		UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART2_Write
;rs485.c,58 :: 		UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART2_Write
;rs485.c,59 :: 		UART2_Write(0x00);                                                      //Envia un byte adicional
	CLR	W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,60 :: 		while(UART2_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48555:
	CALL	_UART2_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485432
	GOTO	L_EnviarTramaRS48556
L__EnviarTramaRS485432:
	GOTO	L_EnviarTramaRS48555
L_EnviarTramaRS48556:
;rs485.c,61 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
;rs485.c,62 :: 		}
L_EnviarTramaRS48551:
;rs485.c,64 :: 		}
L_end_EnviarTramaRS485:
	ULNK
	RETURN
; end of _EnviarTramaRS485

_RecuperarFechaRPI:
	LNK	#4

;tiempo_rpi.c,10 :: 		unsigned long RecuperarFechaRPI(unsigned short *tramaTiempoRpi){
;tiempo_rpi.c,14 :: 		fechaRPi = ((long)tramaTiempoRpi[0]*10000)+((long)tramaTiempoRpi[1]*100)+((long)tramaTiempoRpi[2]);      //10000*aa + 100*mm + dd
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
;tiempo_rpi.c,16 :: 		return fechaRPi;
;tiempo_rpi.c,18 :: 		}
L_end_RecuperarFechaRPI:
	ULNK
	RETURN
; end of _RecuperarFechaRPI

_RecuperarHoraRPI:
	LNK	#4

;tiempo_rpi.c,21 :: 		unsigned long RecuperarHoraRPI(unsigned short *tramaTiempoRpi){
;tiempo_rpi.c,25 :: 		horaRPi = ((long)tramaTiempoRpi[3]*3600)+((long)tramaTiempoRpi[4]*60)+((long)tramaTiempoRpi[5]);      //Calcula el segundo actual = hh*3600 + mm*60 + ss
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
;tiempo_rpi.c,27 :: 		return horaRPi;
;tiempo_rpi.c,29 :: 		}
L_end_RecuperarHoraRPI:
	ULNK
	RETURN
; end of _RecuperarHoraRPI

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 50
	MOV	#4, W0
	IOR	68

;NodoAcelerometro.c,121 :: 		void main() {
;NodoAcelerometro.c,123 :: 		ConfiguracionPrincipal();
	PUSH	W10
	CALL	_ConfiguracionPrincipal
;NodoAcelerometro.c,124 :: 		TEST = 0;                                                                                                                                        //Pin de TEST
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,126 :: 		tasaMuestreo = 1;                                                          //1=250Hz, 2=125Hz, 4=62.5Hz, 8=31.25Hz
	MOV	#lo_addr(_tasaMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,127 :: 		ADXL355_init(tasaMuestreo);                                                //Inicializa el modulo ADXL con la tasa de muestreo requerida:
	MOV.B	#1, W10
	CALL	_ADXL355_init
;NodoAcelerometro.c,128 :: 		numTMR1 = (tasaMuestreo*10)-1;                                             //Calcula el numero de veces que tienen que desbordarse el TMR1 para cada tasa de muestreo
	MOV	#lo_addr(_tasaMuestreo), W0
	SE	[W0], W1
	MOV	#10, W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(_numTMR1), W0
	SUB.B	W2, #1, [W0]
;NodoAcelerometro.c,133 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;NodoAcelerometro.c,134 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;NodoAcelerometro.c,135 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;NodoAcelerometro.c,136 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;NodoAcelerometro.c,139 :: 		inicioSistema = 0;
	MOV	#lo_addr(_inicioSistema), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,142 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,143 :: 		horaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,144 :: 		fechaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,145 :: 		fuenteReloj = 2;
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,148 :: 		banCiclo = 0;
	MOV	#lo_addr(_banCiclo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,149 :: 		banInicioMuestreo = 0;
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,150 :: 		numFIFO = 0;
	MOV	#lo_addr(_numFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,151 :: 		numSetsFIFO = 0;
	MOV	#lo_addr(_numSetsFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,152 :: 		contTimer1 = 0;
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,153 :: 		contMuestras = 0;
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,154 :: 		contCiclos = 0;
	MOV	#lo_addr(_contCiclos), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,155 :: 		contFIFO = 0;
	CLR	W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,158 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,159 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,160 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,161 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,162 :: 		funcionRS485 = 0;
	MOV	#lo_addr(_funcionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,163 :: 		subFuncionRS485 = 0;
	MOV	#lo_addr(_subFuncionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,164 :: 		numDatosRS485 = 0;
	CLR	W0
	MOV	W0, _numDatosRS485
;NodoAcelerometro.c,165 :: 		ptrnumDatosRS485 = (unsigned char *) & numDatosRS485;
	MOV	#lo_addr(_numDatosRS485), W0
	MOV	W0, _ptrnumDatosRS485
;NodoAcelerometro.c,166 :: 		ptrsectorReq = (unsigned char *) & sectorReq;
	MOV	#lo_addr(_sectorReq), W0
	MOV	W0, _ptrsectorReq
;NodoAcelerometro.c,167 :: 		contTMR2 = 0;
	MOV	#lo_addr(_contTMR2), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,170 :: 		PSEC = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _PSEC
	MOV	W1, _PSEC+2
;NodoAcelerometro.c,171 :: 		sectorSD = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _sectorSD
	MOV	W1, _sectorSD+2
;NodoAcelerometro.c,172 :: 		sectorLec = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _sectorLec
	MOV	W1, _sectorLec+2
;NodoAcelerometro.c,173 :: 		checkEscSD = 0;
	MOV	#lo_addr(_checkEscSD), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,174 :: 		checkLecSD = 0;
	MOV	#lo_addr(_checkLecSD), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,175 :: 		MSRS485 = 0;                                                               //Establece el Max485 en modo lectura
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;NodoAcelerometro.c,176 :: 		banInsSec = 0;
	MOV	#lo_addr(_banInsSec), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,179 :: 		switch (SIZESD){
	GOTO	L_main57
;NodoAcelerometro.c,188 :: 		case 8:
L_main61:
;NodoAcelerometro.c,189 :: 		PSF = 2048;
	MOV	#2048, W0
	MOV	#0, W1
	MOV	W0, _PSF
	MOV	W1, _PSF+2
;NodoAcelerometro.c,191 :: 		USF = 16779263;
	MOV	#2047, W0
	MOV	#256, W1
	MOV	W0, _USF
	MOV	W1, _USF+2
;NodoAcelerometro.c,192 :: 		break;
	GOTO	L_main58
;NodoAcelerometro.c,197 :: 		}
L_main57:
	GOTO	L_main61
L_main58:
;NodoAcelerometro.c,198 :: 		infoPrimerSector = PSF+DELTASECTOR-2;                                      //Calcula el sector donde se alamcena la informacion del primer sector escrito
	MOV	_PSF, W2
	MOV	_PSF+2, W3
	MOV	#32416, W0
	MOV	#1, W1
	ADD	W2, W0, W2
	ADDC	W3, W1, W3
	MOV	#lo_addr(_infoPrimerSector), W0
	SUB	W2, #2, [W0++]
	SUBB	W3, #0, [W0--]
;NodoAcelerometro.c,199 :: 		infoUltimoSector = PSF+DELTASECTOR-1;                                      //Calcula el sector donde se alamcena la informacion del ultimo sector escrito
	MOV	#lo_addr(_infoUltimoSector), W0
	SUB	W2, #1, [W0++]
	SUBB	W3, #0, [W0--]
;NodoAcelerometro.c,200 :: 		PSE = PSF+DELTASECTOR;                                                     //Calcula el primer sector de escritura
	MOV	W2, _PSE
	MOV	W3, _PSE+2
;NodoAcelerometro.c,207 :: 		while (1) {
L_main63:
;NodoAcelerometro.c,208 :: 		if (SD_Detect() == DETECTED) {
	CALL	_SD_Detect
	MOV.B	#222, W1
	CP.B	W0, W1
	BRA Z	L__main436
	GOTO	L_main65
L__main436:
;NodoAcelerometro.c,210 :: 		sdflags.detected = true;
	MOV	#lo_addr(_sdflags), W0
	BSET.B	[W0], #1
;NodoAcelerometro.c,212 :: 		break;
	GOTO	L_main64
;NodoAcelerometro.c,213 :: 		} else {
L_main65:
;NodoAcelerometro.c,215 :: 		sdflags.detected = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #1
;NodoAcelerometro.c,216 :: 		sdflags.init_ok = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #0
;NodoAcelerometro.c,219 :: 		Delay_ms(100);
	MOV	#13, W8
	MOV	#13575, W7
L_main67:
	DEC	W7
	BRA NZ	L_main67
	DEC	W8
	BRA NZ	L_main67
;NodoAcelerometro.c,220 :: 		}
	GOTO	L_main63
L_main64:
;NodoAcelerometro.c,226 :: 		if (sdflags.detected && !sdflags.init_ok) {
	MOV	#lo_addr(_sdflags), W0
	MOV.B	[W0], W0
	BTSS.B	W0, #1
	GOTO	L__main353
	MOV	#lo_addr(_sdflags), W0
	MOV.B	[W0], W0
	BTSC.B	W0, #0
	GOTO	L__main352
L__main351:
;NodoAcelerometro.c,227 :: 		if (SD_Init_Try(10) == SUCCESSFUL_INIT) {
	MOV.B	#10, W10
	CALL	_SD_Init_Try
	MOV.B	#170, W1
	CP.B	W0, W1
	BRA Z	L__main437
	GOTO	L_main72
L__main437:
;NodoAcelerometro.c,228 :: 		sdflags.init_ok = true;
	MOV	#lo_addr(_sdflags), W0
	BSET.B	[W0], #0
;NodoAcelerometro.c,229 :: 		inicioSistema = 1;                                                //Activa la bandera para permitir el inicio del sistema
	MOV	#lo_addr(_inicioSistema), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,230 :: 		TEST = 1;
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,231 :: 		} else {
	GOTO	L_main73
L_main72:
;NodoAcelerometro.c,232 :: 		sdflags.init_ok = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #0
;NodoAcelerometro.c,233 :: 		INT1IE_bit = 0;                                                   //Desabilita la interrupcion externa INT1
	BCLR	INT1IE_bit, BitPos(INT1IE_bit+0)
;NodoAcelerometro.c,234 :: 		U1MODE.UARTEN = 0;                                                //Desabilita el UART
	BCLR	U1MODE, #15
;NodoAcelerometro.c,235 :: 		inicioSistema = 0;                                                //Apaga la bandera de inicio del sistema
	MOV	#lo_addr(_inicioSistema), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,236 :: 		TEST = 0;
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,237 :: 		}
L_main73:
;NodoAcelerometro.c,226 :: 		if (sdflags.detected && !sdflags.init_ok) {
L__main353:
L__main352:
;NodoAcelerometro.c,239 :: 		Delay_ms(2000);
	MOV	#245, W8
	MOV	#9362, W7
L_main74:
	DEC	W7
	BRA NZ	L_main74
	DEC	W8
	BRA NZ	L_main74
	NOP
;NodoAcelerometro.c,242 :: 		while(1){
L_main76:
;NodoAcelerometro.c,243 :: 		asm CLRWDT;         //Clear the watchdog timer
	CLRWDT
;NodoAcelerometro.c,244 :: 		Delay_ms(100);
	MOV	#13, W8
	MOV	#13575, W7
L_main78:
	DEC	W7
	BRA NZ	L_main78
	DEC	W8
	BRA NZ	L_main78
;NodoAcelerometro.c,245 :: 		}
	GOTO	L_main76
;NodoAcelerometro.c,247 :: 		}
L_end_main:
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;NodoAcelerometro.c,255 :: 		void ConfiguracionPrincipal(){
;NodoAcelerometro.c,258 :: 		CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	CLKDIVbits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, CLKDIVbits
;NodoAcelerometro.c,259 :: 		CLKDIVbits.PLLPOST = 0;                                                    //N2=2
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,260 :: 		CLKDIVbits.PLLPRE = 5;                                                     //N1=7
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,261 :: 		PLLFBDbits.PLLDIV = 150;                                                   //M=152
	MOV	#150, W0
	MOV	W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	#511, W0
	AND	W1, W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	W1, PLLFBDbits
;NodoAcelerometro.c,264 :: 		ANSELA = 0;                                                                //Configura PORTA como digital     *
	CLR	ANSELA
;NodoAcelerometro.c,265 :: 		ANSELB = 0;                                                                //Configura PORTB como digital     *
	CLR	ANSELB
;NodoAcelerometro.c,266 :: 		TEST_Direction = 0;                                                        //TEST
	BCLR	TRISA2_bit, BitPos(TRISA2_bit+0)
;NodoAcelerometro.c,267 :: 		CsADXL_Direction = 0;                                                      //CS ADXL
	BCLR	TRISA3_bit, BitPos(TRISA3_bit+0)
;NodoAcelerometro.c,268 :: 		sd_CS_tris = 0;                                                            //CS SD
	BCLR	TRISB0_bit, BitPos(TRISB0_bit+0)
;NodoAcelerometro.c,269 :: 		MSRS485_Direction = 0;                                                     //MAX485 MS
	BCLR	TRISB12_bit, BitPos(TRISB12_bit+0)
;NodoAcelerometro.c,270 :: 		sd_detect_tris = 1;                                                        //Pin detection SD
	BSET	TRISA4_bit, BitPos(TRISA4_bit+0)
;NodoAcelerometro.c,272 :: 		TRISB13_bit = 1;                                                           //Pin de interrupcion V2
	BSET	TRISB13_bit, BitPos(TRISB13_bit+0)
;NodoAcelerometro.c,275 :: 		INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales
	BSET	INTCON2, #15
;NodoAcelerometro.c,278 :: 		RPINR18bits.U1RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx1
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
;NodoAcelerometro.c,279 :: 		RPOR1bits.RP36R = 0x01;                                                    //Configura el Tx1 en el pin RB4/RP36
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
;NodoAcelerometro.c,280 :: 		U1RXIE_bit = 1;                                                            //Activa la interrupcion por UART1 RX
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;NodoAcelerometro.c,281 :: 		U1STAbits.URXISEL = 0x00;                                                  //Interrupt is set when any character is received and transferred from the UxRSR to the receive buffer; receive buffer has one or more characters
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,282 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;NodoAcelerometro.c,283 :: 		IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#16384, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;NodoAcelerometro.c,284 :: 		UART1_Init_Advanced(2000000, _UART_8BIT_NOPARITY, _UART_ONE_STOPBIT, _UART_HI_SPEED);                            //Inicializa el UART1 con una velocidad de 2Mbps
	CLR	W13
	CLR	W12
	MOV	#33920, W10
	MOV	#30, W11
	MOV	#1, W0
	PUSH	W0
	CALL	_UART1_Init_Advanced
	SUB	#2, W15
;NodoAcelerometro.c,287 :: 		RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
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
;NodoAcelerometro.c,288 :: 		RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
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
;NodoAcelerometro.c,289 :: 		RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
	MOV	#2304, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR1bits
;NodoAcelerometro.c,290 :: 		SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
	BSET	SPI2STAT, #15
;NodoAcelerometro.c,291 :: 		SPI2_Init();                                                               //Inicializa el modulo SPI2
	CALL	_SPI2_Init
;NodoAcelerometro.c,295 :: 		RPINR0 = 0x2D00;                                                           //Asigna INT1 al RB14/RPI46 V2
	MOV	#11520, W0
	MOV	WREG, RPINR0
;NodoAcelerometro.c,296 :: 		INT1IE_bit = 1;                                                            //Interrupcion externa INT1
	BSET	INT1IE_bit, BitPos(INT1IE_bit+0)
;NodoAcelerometro.c,297 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;NodoAcelerometro.c,298 :: 		IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,301 :: 		T1CON = 0x0020;
	MOV	#32, W0
	MOV	WREG, T1CON
;NodoAcelerometro.c,302 :: 		T1CON.TON = 0;                                                             //Apaga el Timer1
	BCLR	T1CON, #15
;NodoAcelerometro.c,303 :: 		T1IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR1
	BSET	T1IE_bit, BitPos(T1IE_bit+0)
;NodoAcelerometro.c,304 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR1
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;NodoAcelerometro.c,305 :: 		PR1 = 62500;                                                               //Car ga el preload para un tiempo de 100ms
	MOV	#62500, W0
	MOV	WREG, PR1
;NodoAcelerometro.c,306 :: 		IPC0bits.T1IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR1
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;NodoAcelerometro.c,309 :: 		T2CON = 0x0030;                                                            //Prescalador
	MOV	#48, W0
	MOV	WREG, T2CON
;NodoAcelerometro.c,310 :: 		T2CON.TON = 0;                                                             //Apaga el Timer2
	BCLR	T2CON, #15
;NodoAcelerometro.c,311 :: 		T2IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR2
	BSET	T2IE_bit, BitPos(T2IE_bit+0)
;NodoAcelerometro.c,312 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR2
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;NodoAcelerometro.c,313 :: 		PR2 = 46875;                                                               //Carga el preload para un tiempo de 300ms
	MOV	#46875, W0
	MOV	WREG, PR2
;NodoAcelerometro.c,314 :: 		IPC1bits.T2IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR2
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC1bits
;NodoAcelerometro.c,317 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|STANDBY);                           //Coloco el ADXL en modo STANDBY para pausar las conversiones y limpiar el FIFO
	MOV.B	#5, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;NodoAcelerometro.c,320 :: 		sdflags.detected = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #1
;NodoAcelerometro.c,321 :: 		sdflags.init_ok = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #0
;NodoAcelerometro.c,322 :: 		sdflags.saving = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #2
;NodoAcelerometro.c,324 :: 		Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#25, W8
	MOV	#27150, W7
L_ConfiguracionPrincipal80:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal80
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal80
	NOP
;NodoAcelerometro.c,326 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_Muestrear:

;NodoAcelerometro.c,331 :: 		void Muestrear(){
;NodoAcelerometro.c,333 :: 		if (banCiclo==0){
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__Muestrear441
	GOTO	L_Muestrear82
L__Muestrear441:
;NodoAcelerometro.c,335 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|MEASURING);                     //Coloca el ADXL en modo medicion
	MOV.B	#4, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;NodoAcelerometro.c,336 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,337 :: 		TMR1 = 0;                                                              //Encera el Timer1
	CLR	TMR1
;NodoAcelerometro.c,339 :: 		} else if (banCiclo==1) {
	GOTO	L_Muestrear83
L_Muestrear82:
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Muestrear442
	GOTO	L_Muestrear84
L__Muestrear442:
;NodoAcelerometro.c,341 :: 		banCiclo = 2;                                                          //Limpia la bandera de ciclo completo
	MOV	#lo_addr(_banCiclo), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,343 :: 		tramaAceleracion[0] = fuenteReloj;                                     //LLena el primer elemento de la tramaCompleta con la fuente de reloj
	MOV	#lo_addr(_tramaAceleracion), W1
	MOV	#lo_addr(_fuenteReloj), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,344 :: 		numFIFO = ADXL355_read_byte(FIFO_ENTRIES);
	MOV.B	#5, W10
	CALL	_ADXL355_read_byte
	MOV	#lo_addr(_numFIFO), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,345 :: 		numSetsFIFO = (numFIFO)/3;                                             //Lee el numero de sets disponibles en el FIFO
	ZE	W0, W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(_numSetsFIFO), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,348 :: 		for (x=0;x<numSetsFIFO;x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear85:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Muestrear443
	GOTO	L_Muestrear86
L__Muestrear443:
;NodoAcelerometro.c,349 :: 		ADXL355_read_FIFO(datosLeidos);                                    //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,350 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Muestrear88:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Muestrear444
	GOTO	L_Muestrear89
L__Muestrear444:
;NodoAcelerometro.c,351 :: 		datosFIFO[y+(x*9)] = datosLeidos[y];                           //LLena la trama datosFIFO
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
;NodoAcelerometro.c,350 :: 		for (y=0;y<9;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,352 :: 		}
	GOTO	L_Muestrear88
L_Muestrear89:
;NodoAcelerometro.c,348 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,353 :: 		}
	GOTO	L_Muestrear85
L_Muestrear86:
;NodoAcelerometro.c,356 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear91:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Muestrear445
	GOTO	L_Muestrear92
L__Muestrear445:
;NodoAcelerometro.c,357 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Muestrear446
	GOTO	L__Muestrear359
L__Muestrear446:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Muestrear447
	GOTO	L__Muestrear358
L__Muestrear447:
	GOTO	L_Muestrear96
L__Muestrear359:
L__Muestrear358:
;NodoAcelerometro.c,358 :: 		tramaAceleracion[contFIFO+contMuestras+x] = contMuestras;          //Funciona bien
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_tramaAceleracion), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_contMuestras), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,359 :: 		tramaAceleracion[contFIFO+contMuestras+x+1] = datosFIFO[x];
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaAceleracion), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_datosFIFO), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,360 :: 		contMuestras++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contMuestras), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,361 :: 		} else {
	GOTO	L_Muestrear97
L_Muestrear96:
;NodoAcelerometro.c,362 :: 		tramaAceleracion[contFIFO+contMuestras+x] = datosFIFO[x];
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_tramaAceleracion), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_datosFIFO), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,363 :: 		}
L_Muestrear97:
;NodoAcelerometro.c,356 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,364 :: 		}
	GOTO	L_Muestrear91
L_Muestrear92:
;NodoAcelerometro.c,366 :: 		contMuestras = 0;                                                      //Limpia el contador de muestras
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,367 :: 		contFIFO = 0;                                                          //Limpia el contador de FIFOs
	CLR	W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,368 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,369 :: 		TMR1 = 0;                                                              //Encera el Timer1
	CLR	TMR1
;NodoAcelerometro.c,372 :: 		GuardarTramaSD(tiempo, tramaAceleracion);
	MOV	#lo_addr(_tramaAceleracion), W11
	MOV	#lo_addr(_tiempo), W10
	CALL	_GuardarTramaSD
;NodoAcelerometro.c,375 :: 		if (banInsSec==1){
	MOV	#lo_addr(_banInsSec), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Muestrear448
	GOTO	L_Muestrear98
L__Muestrear448:
;NodoAcelerometro.c,376 :: 		InspeccionarSector(1, sectorReq);
	MOV	_sectorReq, W11
	MOV	_sectorReq+2, W12
	MOV.B	#1, W10
	CALL	_InspeccionarSector
;NodoAcelerometro.c,377 :: 		}
L_Muestrear98:
;NodoAcelerometro.c,379 :: 		}
L_Muestrear84:
L_Muestrear83:
;NodoAcelerometro.c,381 :: 		contCiclos++;                                                              //Incrementa el contador de ciclos
	MOV.B	#1, W1
	MOV	#lo_addr(_contCiclos), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,383 :: 		}
L_end_Muestrear:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Muestrear

_GuardarBufferSD:

;NodoAcelerometro.c,388 :: 		void GuardarBufferSD(unsigned char* bufferLleno, unsigned long sector){
;NodoAcelerometro.c,390 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarBufferSD99:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__GuardarBufferSD450
	GOTO	L_GuardarBufferSD100
L__GuardarBufferSD450:
;NodoAcelerometro.c,391 :: 		checkEscSD = SD_Write_Block(bufferLleno,sector);
	PUSH	W11
	PUSH	W12
	PUSH	W10
	CALL	_SD_Write_Block
	POP	W10
	POP	W12
	POP	W11
	MOV	#lo_addr(_checkEscSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,392 :: 		if (checkEscSD == DATA_ACCEPTED){
	CP.B	W0, #22
	BRA Z	L__GuardarBufferSD451
	GOTO	L_GuardarBufferSD102
L__GuardarBufferSD451:
;NodoAcelerometro.c,393 :: 		break;
	GOTO	L_GuardarBufferSD100
;NodoAcelerometro.c,394 :: 		}
L_GuardarBufferSD102:
;NodoAcelerometro.c,395 :: 		Delay_us(10);
	MOV	#80, W7
L_GuardarBufferSD103:
	DEC	W7
	BRA NZ	L_GuardarBufferSD103
	NOP
	NOP
;NodoAcelerometro.c,390 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,396 :: 		}
	GOTO	L_GuardarBufferSD99
L_GuardarBufferSD100:
;NodoAcelerometro.c,397 :: 		}
L_end_GuardarBufferSD:
	RETURN
; end of _GuardarBufferSD

_GuardarTramaSD:

;NodoAcelerometro.c,402 :: 		void GuardarTramaSD(unsigned char* tiempoSD, unsigned char* aceleracionSD){
;NodoAcelerometro.c,409 :: 		for (x=0;x<6;x++){
	PUSH	W12
	PUSH	W13
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD105:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarTramaSD453
	GOTO	L_GuardarTramaSD106
L__GuardarTramaSD453:
;NodoAcelerometro.c,410 :: 		bufferSD[x] = cabeceraSD[x];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_cabeceraSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,409 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,411 :: 		}
	GOTO	L_GuardarTramaSD105
L_GuardarTramaSD106:
;NodoAcelerometro.c,413 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD108:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarTramaSD454
	GOTO	L_GuardarTramaSD109
L__GuardarTramaSD454:
;NodoAcelerometro.c,414 :: 		bufferSD[6+x] = tiempoSD[x];
	MOV	_x, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W10, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,413 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,415 :: 		}
	GOTO	L_GuardarTramaSD108
L_GuardarTramaSD109:
;NodoAcelerometro.c,417 :: 		for (x=0;x<500;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD111:
	MOV	_x, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD455
	GOTO	L_GuardarTramaSD112
L__GuardarTramaSD455:
;NodoAcelerometro.c,418 :: 		bufferSD[12+x] = aceleracionSD[x];
	MOV	_x, W0
	ADD	W0, #12, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W11, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,417 :: 		for (x=0;x<500;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,419 :: 		}
	GOTO	L_GuardarTramaSD111
L_GuardarTramaSD112:
;NodoAcelerometro.c,421 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,423 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,426 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD114:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD456
	GOTO	L_GuardarTramaSD115
L__GuardarTramaSD456:
;NodoAcelerometro.c,427 :: 		bufferSD[x] = aceleracionSD[x+500];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#500, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,426 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,428 :: 		}
	GOTO	L_GuardarTramaSD114
L_GuardarTramaSD115:
;NodoAcelerometro.c,429 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,430 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,433 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD117:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD457
	GOTO	L_GuardarTramaSD118
L__GuardarTramaSD457:
;NodoAcelerometro.c,434 :: 		bufferSD[x] = aceleracionSD[x+1012];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1012, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,433 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,435 :: 		}
	GOTO	L_GuardarTramaSD117
L_GuardarTramaSD118:
;NodoAcelerometro.c,436 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,437 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,440 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD120:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD458
	GOTO	L_GuardarTramaSD121
L__GuardarTramaSD458:
;NodoAcelerometro.c,441 :: 		bufferSD[x] = aceleracionSD[x+1524];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1524, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,440 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,442 :: 		}
	GOTO	L_GuardarTramaSD120
L_GuardarTramaSD121:
;NodoAcelerometro.c,443 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,444 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,447 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD123:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD459
	GOTO	L_GuardarTramaSD124
L__GuardarTramaSD459:
;NodoAcelerometro.c,448 :: 		if (x<464){
	MOV	_x, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD460
	GOTO	L_GuardarTramaSD126
L__GuardarTramaSD460:
;NodoAcelerometro.c,449 :: 		bufferSD[x] = aceleracionSD[x+2036];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#2036, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,450 :: 		} else {
	GOTO	L_GuardarTramaSD127
L_GuardarTramaSD126:
;NodoAcelerometro.c,451 :: 		bufferSD[x] = 0;
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,452 :: 		}
L_GuardarTramaSD127:
;NodoAcelerometro.c,447 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,453 :: 		}
	GOTO	L_GuardarTramaSD123
L_GuardarTramaSD124:
;NodoAcelerometro.c,454 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
;NodoAcelerometro.c,455 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,458 :: 		if (horaSistema%300==0){
	MOV	#300, W2
	MOV	#0, W3
	MOV	_horaSistema, W0
	MOV	_horaSistema+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W10
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__GuardarTramaSD461
	GOTO	L_GuardarTramaSD128
L__GuardarTramaSD461:
;NodoAcelerometro.c,459 :: 		GuardarInfoSector(sectorSD, infoUltimoSector);
	PUSH.D	W10
	MOV	_infoUltimoSector, W12
	MOV	_infoUltimoSector+2, W13
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarInfoSector
	POP.D	W10
;NodoAcelerometro.c,460 :: 		}
L_GuardarTramaSD128:
;NodoAcelerometro.c,462 :: 		TEST = 0;                                                               //Apaga el TEST cuando termina de gurdar la trama
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,464 :: 		}
L_end_GuardarTramaSD:
	POP	W13
	POP	W12
	RETURN
; end of _GuardarTramaSD

_GuardarInfoSector:
	LNK	#512

;NodoAcelerometro.c,469 :: 		void GuardarInfoSector(unsigned long datoSector, unsigned long localizacionSector){
;NodoAcelerometro.c,474 :: 		bufferSectores[0] = (datoSector>>24)&0xFF;                                     //MSB variable sector
	ADD	W14, #0, W5
	LSR	W11, #8, W2
	CLR	W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W5]
;NodoAcelerometro.c,475 :: 		bufferSectores[1] = (datoSector>>16)&0xFF;
	ADD	W5, #1, W4
	MOV	W11, W2
	CLR	W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W4]
;NodoAcelerometro.c,476 :: 		bufferSectores[2] = (datoSector>>8)&0xFF;
	ADD	W5, #2, W4
	LSR	W10, #8, W2
	SL	W11, #8, W3
	IOR	W2, W3, W2
	LSR	W11, #8, W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W4]
;NodoAcelerometro.c,477 :: 		bufferSectores[3] = (datoSector)&0xFF;                                         //LSD variable sector
	ADD	W5, #3, W2
	MOV	#255, W0
	MOV	#0, W1
	AND	W10, W0, W0
	MOV.B	W0, [W2]
;NodoAcelerometro.c,478 :: 		for (x=4;x<512;x++){
	MOV	#4, W0
	MOV	W0, _x
L_GuardarInfoSector129:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarInfoSector463
	GOTO	L_GuardarInfoSector130
L__GuardarInfoSector463:
;NodoAcelerometro.c,479 :: 		bufferSectores[x] = 0;                                                 //Rellena de ceros el resto del buffer
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,478 :: 		for (x=4;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,480 :: 		}
	GOTO	L_GuardarInfoSector129
L_GuardarInfoSector130:
;NodoAcelerometro.c,483 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarInfoSector132:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__GuardarInfoSector464
	GOTO	L_GuardarInfoSector133
L__GuardarInfoSector464:
;NodoAcelerometro.c,484 :: 		checkEscSD = SD_Write_Block(bufferSectores,localizacionSector);
	ADD	W14, #0, W0
	PUSH.D	W12
	PUSH.D	W10
	MOV	W12, W11
	MOV	W13, W12
	MOV	W0, W10
	CALL	_SD_Write_Block
	POP.D	W10
	POP.D	W12
	MOV	#lo_addr(_checkEscSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,485 :: 		if (checkEscSD == DATA_ACCEPTED){
	CP.B	W0, #22
	BRA Z	L__GuardarInfoSector465
	GOTO	L_GuardarInfoSector135
L__GuardarInfoSector465:
;NodoAcelerometro.c,487 :: 		break;
	GOTO	L_GuardarInfoSector133
;NodoAcelerometro.c,488 :: 		}
L_GuardarInfoSector135:
;NodoAcelerometro.c,489 :: 		Delay_us(10);
	MOV	#80, W7
L_GuardarInfoSector136:
	DEC	W7
	BRA NZ	L_GuardarInfoSector136
	NOP
	NOP
;NodoAcelerometro.c,483 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,490 :: 		}
	GOTO	L_GuardarInfoSector132
L_GuardarInfoSector133:
;NodoAcelerometro.c,492 :: 		}
L_end_GuardarInfoSector:
	ULNK
	RETURN
; end of _GuardarInfoSector

_UbicarPrimerSectorEscrito:
	LNK	#516

;NodoAcelerometro.c,497 :: 		unsigned long UbicarPrimerSectorEscrito(){
;NodoAcelerometro.c,503 :: 		ptrPrimerSectorSD = (unsigned char *) & primerSectorSD;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#512, W0
	ADD	W14, W0, W0
; ptrPrimerSectorSD start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,505 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,507 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_UbicarPrimerSectorEscrito138:
; ptrPrimerSectorSD start address is: 6 (W3)
; ptrPrimerSectorSD end address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__UbicarPrimerSectorEscrito467
	GOTO	L_UbicarPrimerSectorEscrito139
L__UbicarPrimerSectorEscrito467:
; ptrPrimerSectorSD end address is: 6 (W3)
;NodoAcelerometro.c,509 :: 		checkLecSD = SD_Read_Block(bufferSectorInicio, infoPrimerSector);
; ptrPrimerSectorSD start address is: 6 (W3)
	ADD	W14, #0, W0
	PUSH	W3
	MOV	_infoPrimerSector, W11
	MOV	_infoPrimerSector+2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,511 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__UbicarPrimerSectorEscrito468
	GOTO	L_UbicarPrimerSectorEscrito141
L__UbicarPrimerSectorEscrito468:
;NodoAcelerometro.c,513 :: 		*ptrPrimerSectorSD = bufferSectorInicio[3];                      //LSB
	ADD	W14, #0, W2
	ADD	W2, #3, W0
	MOV.B	[W0], [W3]
;NodoAcelerometro.c,514 :: 		*(ptrPrimerSectorSD+1) = bufferSectorInicio[2];
	ADD	W3, #1, W1
	ADD	W2, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,515 :: 		*(ptrPrimerSectorSD+2) = bufferSectorInicio[1];
	ADD	W3, #2, W1
	ADD	W2, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,516 :: 		*(ptrPrimerSectorSD+3) = bufferSectorInicio[0];                  //MSB
	ADD	W3, #3, W0
; ptrPrimerSectorSD end address is: 6 (W3)
	MOV.B	[W2], [W0]
;NodoAcelerometro.c,517 :: 		break;
	GOTO	L_UbicarPrimerSectorEscrito139
;NodoAcelerometro.c,519 :: 		} else {
L_UbicarPrimerSectorEscrito141:
;NodoAcelerometro.c,520 :: 		primerSectorSD = PSE;                                           //Si no pudo realizar la lectura devuelve el Primer Sector de Escritura
; ptrPrimerSectorSD start address is: 6 (W3)
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,507 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,522 :: 		}
; ptrPrimerSectorSD end address is: 6 (W3)
	GOTO	L_UbicarPrimerSectorEscrito138
L_UbicarPrimerSectorEscrito139:
;NodoAcelerometro.c,525 :: 		return primerSectorSD;
	MOV	[W14+512], W0
	MOV	[W14+514], W1
;NodoAcelerometro.c,527 :: 		}
;NodoAcelerometro.c,525 :: 		return primerSectorSD;
;NodoAcelerometro.c,527 :: 		}
L_end_UbicarPrimerSectorEscrito:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _UbicarPrimerSectorEscrito

_UbicarUltimoSectorEscrito:
	LNK	#516

;NodoAcelerometro.c,532 :: 		unsigned long UbicarUltimoSectorEscrito(unsigned short sobrescribirSD){
;NodoAcelerometro.c,538 :: 		ptrSectorInicioSD = (unsigned char *) & sectorInicioSD;
	PUSH	W11
	PUSH	W12
	MOV	#512, W0
	ADD	W14, W0, W0
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,541 :: 		if (sobrescribirSD==1){
	CP.B	W10, #1
	BRA Z	L__UbicarUltimoSectorEscrito470
	GOTO	L_UbicarUltimoSectorEscrito145
L__UbicarUltimoSectorEscrito470:
; ptrSectorInicioSD end address is: 6 (W3)
;NodoAcelerometro.c,542 :: 		sectorInicioSD = PSE;                                                  //Se escoje el PSE para sobrescribir la SD
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,543 :: 		} else {
	GOTO	L_UbicarUltimoSectorEscrito146
L_UbicarUltimoSectorEscrito145:
;NodoAcelerometro.c,544 :: 		checkLecSD = 1;
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,546 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_UbicarUltimoSectorEscrito147:
; ptrSectorInicioSD start address is: 6 (W3)
; ptrSectorInicioSD end address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__UbicarUltimoSectorEscrito471
	GOTO	L_UbicarUltimoSectorEscrito148
L__UbicarUltimoSectorEscrito471:
; ptrSectorInicioSD end address is: 6 (W3)
;NodoAcelerometro.c,548 :: 		checkLecSD = SD_Read_Block(bufferSectorFinal, infoUltimoSector);
; ptrSectorInicioSD start address is: 6 (W3)
	ADD	W14, #0, W0
	PUSH	W3
	PUSH	W10
	MOV	_infoUltimoSector, W11
	MOV	_infoUltimoSector+2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP	W10
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,550 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__UbicarUltimoSectorEscrito472
	GOTO	L_UbicarUltimoSectorEscrito150
L__UbicarUltimoSectorEscrito472:
;NodoAcelerometro.c,552 :: 		*ptrSectorInicioSD = bufferSectorFinal[3];                      //LSB
	ADD	W14, #0, W2
	ADD	W2, #3, W0
	MOV.B	[W0], [W3]
;NodoAcelerometro.c,553 :: 		*(ptrSectorInicioSD+1) = bufferSectorFinal[2];
	ADD	W3, #1, W1
	ADD	W2, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,554 :: 		*(ptrSectorInicioSD+2) = bufferSectorFinal[1];
	ADD	W3, #2, W1
	ADD	W2, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,555 :: 		*(ptrSectorInicioSD+3) = bufferSectorFinal[0];                  //MSB
	ADD	W3, #3, W0
; ptrSectorInicioSD end address is: 6 (W3)
	MOV.B	[W2], [W0]
;NodoAcelerometro.c,556 :: 		break;
	GOTO	L_UbicarUltimoSectorEscrito148
;NodoAcelerometro.c,558 :: 		} else {
L_UbicarUltimoSectorEscrito150:
;NodoAcelerometro.c,559 :: 		sectorInicioSD = PSE;                                           //Si no pudo realizar la lectura procede a sobreescribir la SD
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,546 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,561 :: 		}
; ptrSectorInicioSD end address is: 6 (W3)
	GOTO	L_UbicarUltimoSectorEscrito147
L_UbicarUltimoSectorEscrito148:
;NodoAcelerometro.c,562 :: 		}
L_UbicarUltimoSectorEscrito146:
;NodoAcelerometro.c,564 :: 		return sectorInicioSD;
	MOV	[W14+512], W0
	MOV	[W14+514], W1
;NodoAcelerometro.c,566 :: 		}
;NodoAcelerometro.c,564 :: 		return sectorInicioSD;
;NodoAcelerometro.c,566 :: 		}
L_end_UbicarUltimoSectorEscrito:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _UbicarUltimoSectorEscrito

_InformacionSectores:
	LNK	#36

;NodoAcelerometro.c,571 :: 		void InformacionSectores(){
;NodoAcelerometro.c,585 :: 		infoPSF = PSF;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	_PSF, W0
	MOV	_PSF+2, W1
	MOV	W0, [W14+20]
	MOV	W1, [W14+22]
;NodoAcelerometro.c,586 :: 		infoPSE = PSE;
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+24]
	MOV	W1, [W14+26]
;NodoAcelerometro.c,589 :: 		ptrPSF = (unsigned char *) & infoPSF;
	ADD	W14, #20, W0
; ptrPSF start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,590 :: 		ptrPSE = (unsigned char *) & infoPSE;
	ADD	W14, #24, W0
; ptrPSE start address is: 8 (W4)
	MOV	W0, W4
;NodoAcelerometro.c,591 :: 		ptrPSEC = (unsigned char *) & infoPSEC;
	ADD	W14, #28, W0
; ptrPSEC start address is: 10 (W5)
	MOV	W0, W5
;NodoAcelerometro.c,592 :: 		ptrSA = (unsigned char *) & infoSA;
	MOV	#32, W0
	ADD	W14, W0, W0
; ptrSA start address is: 12 (W6)
	MOV	W0, W6
;NodoAcelerometro.c,595 :: 		if (banInicioMuestreo==0){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__InformacionSectores474
	GOTO	L_InformacionSectores154
L__InformacionSectores474:
;NodoAcelerometro.c,596 :: 		infoPSEC = UbicarPrimerSectorEscrito();                                 //Calcula el primer sector escrito
	PUSH	W6
	PUSH.D	W4
	PUSH	W3
	CALL	_UbicarPrimerSectorEscrito
	MOV	W0, [W14+28]
	MOV	W1, [W14+30]
;NodoAcelerometro.c,597 :: 		infoSA = UbicarUltimoSectorEscrito(0);                                  //Calcula el ultimo sector escrito
	CLR	W10
	CALL	_UbicarUltimoSectorEscrito
	POP	W3
	POP.D	W4
	POP	W6
	MOV	W0, [W14+32]
	MOV	W1, [W14+34]
;NodoAcelerometro.c,598 :: 		} else {
	GOTO	L_InformacionSectores155
L_InformacionSectores154:
;NodoAcelerometro.c,599 :: 		infoSA = sectorSD - 1;                                                  //Retorna el sector actual menos una posicion
	MOV	_sectorSD, W1
	MOV	_sectorSD+2, W2
	MOV	#32, W0
	ADD	W14, W0, W0
	SUB	W1, #1, [W0++]
	SUBB	W2, #0, [W0--]
;NodoAcelerometro.c,600 :: 		infoPSEC = PSEC;                                                        //Retorna el primer sector escrito en este ciclo de muestreo
	MOV	_PSEC, W0
	MOV	_PSEC+2, W1
	MOV	W0, [W14+28]
	MOV	W1, [W14+30]
;NodoAcelerometro.c,601 :: 		}
L_InformacionSectores155:
;NodoAcelerometro.c,603 :: 		tramaInfoSec[0] = 0xD1;                                                    //Subfuncion
	ADD	W14, #0, W2
	MOV.B	#209, W0
	MOV.B	W0, [W2]
;NodoAcelerometro.c,604 :: 		tramaInfoSec[1] = *ptrPSF;                                                 //LSB PSF
	ADD	W2, #1, W0
	MOV.B	[W3], [W0]
;NodoAcelerometro.c,605 :: 		tramaInfoSec[2] = *(ptrPSF+1);
	ADD	W2, #2, W1
	ADD	W3, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,606 :: 		tramaInfoSec[3] = *(ptrPSF+2);
	ADD	W2, #3, W1
	ADD	W3, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,607 :: 		tramaInfoSec[4] = *(ptrPSF+3);                                             //MSB PSF
	ADD	W2, #4, W1
	ADD	W3, #3, W0
; ptrPSF end address is: 6 (W3)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,608 :: 		tramaInfoSec[5] = *ptrPSE;                                                 //LSB PSE
	ADD	W2, #5, W0
	MOV.B	[W4], [W0]
;NodoAcelerometro.c,609 :: 		tramaInfoSec[6] = *(ptrPSE+1);
	ADD	W2, #6, W1
	ADD	W4, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,610 :: 		tramaInfoSec[7] = *(ptrPSE+2);
	ADD	W2, #7, W1
	ADD	W4, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,611 :: 		tramaInfoSec[8] = *(ptrPSE+3);                                             //MSB PSE
	ADD	W2, #8, W1
	ADD	W4, #3, W0
; ptrPSE end address is: 8 (W4)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,612 :: 		tramaInfoSec[9] = *ptrPSEC;                                                //LSB PSEC
	ADD	W2, #9, W0
	MOV.B	[W5], [W0]
;NodoAcelerometro.c,613 :: 		tramaInfoSec[10] = *(ptrPSEC+1);
	ADD	W2, #10, W1
	ADD	W5, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,614 :: 		tramaInfoSec[11] = *(ptrPSEC+2);
	ADD	W2, #11, W1
	ADD	W5, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,615 :: 		tramaInfoSec[12] = *(ptrPSEC+3);                                           //MSB PSEC
	ADD	W2, #12, W1
	ADD	W5, #3, W0
; ptrPSEC end address is: 10 (W5)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,616 :: 		tramaInfoSec[13] = *ptrSA;                                                 //LSB SA
	ADD	W2, #13, W0
	MOV.B	[W6], [W0]
;NodoAcelerometro.c,617 :: 		tramaInfoSec[14] = *(ptrSA+1);
	ADD	W2, #14, W1
	ADD	W6, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,618 :: 		tramaInfoSec[15] = *(ptrSA+2);
	ADD	W2, #15, W1
	ADD	W6, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,619 :: 		tramaInfoSec[16] = *(ptrSA+3);                                             //MSB SA
	ADD	W2, #16, W1
	ADD	W6, #3, W0
; ptrSA end address is: 12 (W6)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,621 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, 17, tramaInfoSec);
	MOV	#17, W13
	MOV.B	#243, W12
	MOV.B	#2, W11
	MOV.B	#1, W10
	PUSH	W2
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;NodoAcelerometro.c,623 :: 		}
L_end_InformacionSectores:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _InformacionSectores

_InspeccionarSector:
	LNK	#530

;NodoAcelerometro.c,628 :: 		void InspeccionarSector(unsigned short estadoMuestreo, unsigned long sectorReq){
;NodoAcelerometro.c,637 :: 		if (estadoMuestreo==0){
	PUSH	W10
	PUSH	W13
	CP.B	W10, #0
	BRA Z	L__InspeccionarSector476
	GOTO	L_InspeccionarSector156
L__InspeccionarSector476:
;NodoAcelerometro.c,638 :: 		USE = UbicarUltimoSectorEscrito(0);
	PUSH	W11
	PUSH	W12
	CLR	W10
	CALL	_UbicarUltimoSectorEscrito
	POP	W12
	POP	W11
; USE start address is: 4 (W2)
	MOV.D	W0, W2
;NodoAcelerometro.c,639 :: 		} else {
; USE end address is: 4 (W2)
	GOTO	L_InspeccionarSector157
L_InspeccionarSector156:
;NodoAcelerometro.c,640 :: 		USE = sectorSD - 1;
	MOV	_sectorSD, W0
	MOV	_sectorSD+2, W1
; USE start address is: 4 (W2)
	SUB	W0, #1, W2
	SUBB	W1, #0, W3
; USE end address is: 4 (W2)
;NodoAcelerometro.c,641 :: 		}
L_InspeccionarSector157:
;NodoAcelerometro.c,643 :: 		tramaDatosSec[0] = 0xD2;                                                   //Subfuncion
; USE start address is: 4 (W2)
	ADD	W14, #0, W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,646 :: 		if ((sectorReq>=PSE)&&(sectorReq<USF)){
	MOV	#lo_addr(_PSE), W0
	CP	W11, [W0++]
	CPB	W12, [W0--]
	BRA GEU	L__InspeccionarSector477
	GOTO	L__InspeccionarSector356
L__InspeccionarSector477:
	MOV	#lo_addr(_USF), W0
	CP	W11, [W0++]
	CPB	W12, [W0--]
	BRA LTU	L__InspeccionarSector478
	GOTO	L__InspeccionarSector355
L__InspeccionarSector478:
L__InspeccionarSector354:
;NodoAcelerometro.c,648 :: 		if (sectorReq<USE){
	CP	W11, W2
	CPB	W12, W3
	BRA LTU	L__InspeccionarSector479
	GOTO	L_InspeccionarSector161
L__InspeccionarSector479:
; USE end address is: 4 (W2)
;NodoAcelerometro.c,649 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,651 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_InspeccionarSector162:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__InspeccionarSector480
	GOTO	L_InspeccionarSector163
L__InspeccionarSector480:
;NodoAcelerometro.c,653 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, sectorReq);
	ADD	W14, #15, W0
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP	W10
	POP	W12
	POP	W11
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,655 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__InspeccionarSector481
	GOTO	L_InspeccionarSector165
L__InspeccionarSector481:
;NodoAcelerometro.c,657 :: 		numDatosSec = 14;
	MOV	#14, W0
	MOV	W0, [W14+528]
;NodoAcelerometro.c,658 :: 		for (y=0;y<numDatosSec;y++){
	CLR	W0
	MOV	W0, _y
L_InspeccionarSector166:
	MOV	_y, W1
	MOV	#528, W0
	ADD	W14, W0, W0
	CP	W1, [W0]
	BRA LTU	L__InspeccionarSector482
	GOTO	L_InspeccionarSector167
L__InspeccionarSector482:
;NodoAcelerometro.c,659 :: 		tramaDatosSec[y+1] = bufferSectorReq[y];
	MOV	_y, W0
	ADD	W0, #1, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	ADD	W14, #15, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,658 :: 		for (y=0;y<numDatosSec;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,660 :: 		}
	GOTO	L_InspeccionarSector166
L_InspeccionarSector167:
;NodoAcelerometro.c,661 :: 		break;
	GOTO	L_InspeccionarSector163
;NodoAcelerometro.c,662 :: 		} else {
L_InspeccionarSector165:
;NodoAcelerometro.c,664 :: 		numDatosSec = 3;
	MOV	#3, W0
	MOV	W0, [W14+528]
;NodoAcelerometro.c,665 :: 		tramaDatosSec[1] = 0xEE;
	ADD	W14, #0, W2
	ADD	W2, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,666 :: 		tramaDatosSec[2] = 0xE3;
	ADD	W2, #2, W1
	MOV.B	#227, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,668 :: 		Delay_us(10);
	MOV	#80, W7
L_InspeccionarSector170:
	DEC	W7
	BRA NZ	L_InspeccionarSector170
	NOP
	NOP
;NodoAcelerometro.c,651 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,669 :: 		}
	GOTO	L_InspeccionarSector162
L_InspeccionarSector163:
;NodoAcelerometro.c,670 :: 		} else {
	GOTO	L_InspeccionarSector172
L_InspeccionarSector161:
;NodoAcelerometro.c,672 :: 		numDatosSec = 3;
	MOV	#3, W0
	MOV	W0, [W14+528]
;NodoAcelerometro.c,673 :: 		tramaDatosSec[1] = 0xEE;
	ADD	W14, #0, W2
	ADD	W2, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,674 :: 		tramaDatosSec[2] = 0xE2;
	ADD	W2, #2, W1
	MOV.B	#226, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,675 :: 		}
L_InspeccionarSector172:
;NodoAcelerometro.c,677 :: 		} else {
	GOTO	L_InspeccionarSector173
;NodoAcelerometro.c,646 :: 		if ((sectorReq>=PSE)&&(sectorReq<USF)){
L__InspeccionarSector356:
L__InspeccionarSector355:
;NodoAcelerometro.c,680 :: 		numDatosSec = 3;
	MOV	#3, W0
	MOV	W0, [W14+528]
;NodoAcelerometro.c,681 :: 		tramaDatosSec[1] = 0xEE;
	ADD	W14, #0, W2
	ADD	W2, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,682 :: 		tramaDatosSec[2] = 0xE1;
	ADD	W2, #2, W1
	MOV.B	#225, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,684 :: 		}
L_InspeccionarSector173:
;NodoAcelerometro.c,686 :: 		banInsSec = 0;
	MOV	#lo_addr(_banInsSec), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,687 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, numDatosSec, tramaDatosSec);
	ADD	W14, #0, W0
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV	[W14+528], W13
	MOV.B	#243, W12
	MOV.B	#2, W11
	MOV.B	#1, W10
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
	POP	W10
	POP	W12
	POP	W11
;NodoAcelerometro.c,689 :: 		}
L_end_InspeccionarSector:
	POP	W13
	POP	W10
	ULNK
	RETURN
; end of _InspeccionarSector

_RecuperarTramaAceleracion:
	LNK	#3042

;NodoAcelerometro.c,694 :: 		void RecuperarTramaAceleracion(unsigned long sectorReq){
;NodoAcelerometro.c,703 :: 		tramaAcelSeg[0] = 0xD3;                                                     //Subfuncion
	PUSH	W12
	PUSH	W13
	ADD	W14, #0, W1
	MOV.B	#211, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,704 :: 		contSector = 0;
	MOV	#3034, W2
	ADD	W14, W2, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;NodoAcelerometro.c,705 :: 		banLecturaCorrecta = 0;
	MOV	#3040, W1
	ADD	W14, W1, W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,706 :: 		numDatosTramaAcel = 2513;
	MOV	#3038, W1
	ADD	W14, W1, W1
	MOV	#2513, W0
	MOV	W0, [W1]
;NodoAcelerometro.c,709 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,711 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion174:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion484
	GOTO	L_RecuperarTramaAceleracion175
L__RecuperarTramaAceleracion484:
;NodoAcelerometro.c,712 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	MOV	#3034, W0
	ADD	W14, W0, W0
	ADD	W10, [W0++], W1
	ADDC	W11, [W0--], W2
	MOV	#2515, W0
	ADD	W14, W0, W0
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,713 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion485
	GOTO	L_RecuperarTramaAceleracion177
L__RecuperarTramaAceleracion485:
;NodoAcelerometro.c,715 :: 		for (y=0;y<6;y++){
	CLR	W0
	MOV	W0, _y
L_RecuperarTramaAceleracion178:
	MOV	_y, W0
	CP	W0, #6
	BRA LTU	L__RecuperarTramaAceleracion486
	GOTO	L_RecuperarTramaAceleracion179
L__RecuperarTramaAceleracion486:
;NodoAcelerometro.c,716 :: 		tiempoAcel[y] = bufferSectorReq[y+6];
	MOV	#3027, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W2
	MOV	_y, W0
	ADD	W0, #6, W1
	MOV	#2515, W0
	ADD	W14, W0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,715 :: 		for (y=0;y<6;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,717 :: 		}
	GOTO	L_RecuperarTramaAceleracion178
L_RecuperarTramaAceleracion179:
;NodoAcelerometro.c,719 :: 		for (y=0;y<6;y++){
	CLR	W0
	MOV	W0, _y
L_RecuperarTramaAceleracion181:
	MOV	_y, W0
	CP	W0, #6
	BRA LTU	L__RecuperarTramaAceleracion487
	GOTO	L_RecuperarTramaAceleracion182
L__RecuperarTramaAceleracion487:
;NodoAcelerometro.c,720 :: 		tramaAcelSeg[y+1] = bufferSectorReq[y];
	MOV	_y, W0
	ADD	W0, #1, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	#2515, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,719 :: 		for (y=0;y<6;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,721 :: 		}
	GOTO	L_RecuperarTramaAceleracion181
L_RecuperarTramaAceleracion182:
;NodoAcelerometro.c,723 :: 		for (y=0;y<500;y++){
	CLR	W0
	MOV	W0, _y
L_RecuperarTramaAceleracion184:
	MOV	_y, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion488
	GOTO	L_RecuperarTramaAceleracion185
L__RecuperarTramaAceleracion488:
;NodoAcelerometro.c,724 :: 		tramaAcelSeg[y+7] = bufferSectorReq[y+12];
	MOV	_y, W0
	ADD	W0, #7, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	_y, W0
	ADD	W0, #12, W1
	MOV	#2515, W0
	ADD	W14, W0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,723 :: 		for (y=0;y<500;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,725 :: 		}
	GOTO	L_RecuperarTramaAceleracion184
L_RecuperarTramaAceleracion185:
;NodoAcelerometro.c,726 :: 		banLecturaCorrecta = 1;
	MOV	#3040, W1
	ADD	W14, W1, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,727 :: 		contSector++;
	MOV	#3034, W3
	ADD	W14, W3, W3
	MOV	#3034, W2
	ADD	W14, W2, W2
	MOV.D	[W3], W0
	ADD	W0, #1, [W2++]
	ADDC	W1, #0, [W2--]
;NodoAcelerometro.c,728 :: 		break;
	GOTO	L_RecuperarTramaAceleracion175
;NodoAcelerometro.c,729 :: 		} else {
L_RecuperarTramaAceleracion177:
;NodoAcelerometro.c,731 :: 		tramaAcelSeg[1] = 0xEE;
	ADD	W14, #0, W2
	ADD	W2, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,732 :: 		tramaAcelSeg[2] = 0xE3;
	ADD	W2, #2, W1
	MOV.B	#227, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,733 :: 		numDatosTramaAcel = 3;
	MOV	#3038, W1
	ADD	W14, W1, W1
	MOV	#3, W0
	MOV	W0, [W1]
;NodoAcelerometro.c,734 :: 		banLecturaCorrecta = 2;
	MOV	#3040, W1
	ADD	W14, W1, W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,736 :: 		Delay_us(10);
	MOV	#80, W7
L_RecuperarTramaAceleracion188:
	DEC	W7
	BRA NZ	L_RecuperarTramaAceleracion188
	NOP
	NOP
;NodoAcelerometro.c,711 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,737 :: 		}
	GOTO	L_RecuperarTramaAceleracion174
L_RecuperarTramaAceleracion175:
;NodoAcelerometro.c,740 :: 		if (banLecturaCorrecta==1){
	MOV	#3040, W0
	ADD	W14, W0, W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__RecuperarTramaAceleracion489
	GOTO	L_RecuperarTramaAceleracion190
L__RecuperarTramaAceleracion489:
;NodoAcelerometro.c,741 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,743 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion191:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion490
	GOTO	L_RecuperarTramaAceleracion192
L__RecuperarTramaAceleracion490:
;NodoAcelerometro.c,744 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	MOV	#3034, W0
	ADD	W14, W0, W0
	ADD	W10, [W0++], W1
	ADDC	W11, [W0--], W2
	MOV	#2515, W0
	ADD	W14, W0, W0
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,745 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion491
	GOTO	L_RecuperarTramaAceleracion194
L__RecuperarTramaAceleracion491:
;NodoAcelerometro.c,747 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
L_RecuperarTramaAceleracion195:
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion492
	GOTO	L_RecuperarTramaAceleracion196
L__RecuperarTramaAceleracion492:
;NodoAcelerometro.c,748 :: 		tramaAcelSeg[y+507] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#507, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	#2515, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,747 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,749 :: 		}
	GOTO	L_RecuperarTramaAceleracion195
L_RecuperarTramaAceleracion196:
;NodoAcelerometro.c,750 :: 		banLecturaCorrecta = 1;
	MOV	#3040, W1
	ADD	W14, W1, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,751 :: 		contSector++;
	MOV	#3034, W3
	ADD	W14, W3, W3
	MOV	#3034, W2
	ADD	W14, W2, W2
	MOV.D	[W3], W0
	ADD	W0, #1, [W2++]
	ADDC	W1, #0, [W2--]
;NodoAcelerometro.c,752 :: 		break;
	GOTO	L_RecuperarTramaAceleracion192
;NodoAcelerometro.c,753 :: 		} else {
L_RecuperarTramaAceleracion194:
;NodoAcelerometro.c,755 :: 		tramaAcelSeg[1] = 0xEE;
	ADD	W14, #0, W2
	ADD	W2, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,756 :: 		tramaAcelSeg[2] = 0xE3;
	ADD	W2, #2, W1
	MOV.B	#227, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,757 :: 		numDatosTramaAcel = 3;
	MOV	#3038, W1
	ADD	W14, W1, W1
	MOV	#3, W0
	MOV	W0, [W1]
;NodoAcelerometro.c,758 :: 		banLecturaCorrecta = 2;
	MOV	#3040, W1
	ADD	W14, W1, W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,760 :: 		Delay_us(10);
	MOV	#80, W7
L_RecuperarTramaAceleracion199:
	DEC	W7
	BRA NZ	L_RecuperarTramaAceleracion199
	NOP
	NOP
;NodoAcelerometro.c,743 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,761 :: 		}
	GOTO	L_RecuperarTramaAceleracion191
L_RecuperarTramaAceleracion192:
;NodoAcelerometro.c,762 :: 		}
L_RecuperarTramaAceleracion190:
;NodoAcelerometro.c,765 :: 		if (banLecturaCorrecta==1){
	MOV	#3040, W0
	ADD	W14, W0, W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__RecuperarTramaAceleracion493
	GOTO	L_RecuperarTramaAceleracion201
L__RecuperarTramaAceleracion493:
;NodoAcelerometro.c,766 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,768 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion202:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion494
	GOTO	L_RecuperarTramaAceleracion203
L__RecuperarTramaAceleracion494:
;NodoAcelerometro.c,769 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	MOV	#3034, W0
	ADD	W14, W0, W0
	ADD	W10, [W0++], W1
	ADDC	W11, [W0--], W2
	MOV	#2515, W0
	ADD	W14, W0, W0
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,770 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion495
	GOTO	L_RecuperarTramaAceleracion205
L__RecuperarTramaAceleracion495:
;NodoAcelerometro.c,772 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
L_RecuperarTramaAceleracion206:
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion496
	GOTO	L_RecuperarTramaAceleracion207
L__RecuperarTramaAceleracion496:
;NodoAcelerometro.c,773 :: 		tramaAcelSeg[y+1019] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#1019, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	#2515, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,772 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,774 :: 		}
	GOTO	L_RecuperarTramaAceleracion206
L_RecuperarTramaAceleracion207:
;NodoAcelerometro.c,775 :: 		banLecturaCorrecta = 1;
	MOV	#3040, W1
	ADD	W14, W1, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,776 :: 		contSector++;
	MOV	#3034, W3
	ADD	W14, W3, W3
	MOV	#3034, W2
	ADD	W14, W2, W2
	MOV.D	[W3], W0
	ADD	W0, #1, [W2++]
	ADDC	W1, #0, [W2--]
;NodoAcelerometro.c,777 :: 		break;
	GOTO	L_RecuperarTramaAceleracion203
;NodoAcelerometro.c,778 :: 		} else {
L_RecuperarTramaAceleracion205:
;NodoAcelerometro.c,780 :: 		tramaAcelSeg[1] = 0xEE;
	ADD	W14, #0, W2
	ADD	W2, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,781 :: 		tramaAcelSeg[2] = 0xE3;
	ADD	W2, #2, W1
	MOV.B	#227, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,782 :: 		numDatosTramaAcel = 3;
	MOV	#3038, W1
	ADD	W14, W1, W1
	MOV	#3, W0
	MOV	W0, [W1]
;NodoAcelerometro.c,783 :: 		banLecturaCorrecta = 2;
	MOV	#3040, W1
	ADD	W14, W1, W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,785 :: 		Delay_us(10);
	MOV	#80, W7
L_RecuperarTramaAceleracion210:
	DEC	W7
	BRA NZ	L_RecuperarTramaAceleracion210
	NOP
	NOP
;NodoAcelerometro.c,768 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,786 :: 		}
	GOTO	L_RecuperarTramaAceleracion202
L_RecuperarTramaAceleracion203:
;NodoAcelerometro.c,787 :: 		}
L_RecuperarTramaAceleracion201:
;NodoAcelerometro.c,790 :: 		if (banLecturaCorrecta==1){
	MOV	#3040, W0
	ADD	W14, W0, W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__RecuperarTramaAceleracion497
	GOTO	L_RecuperarTramaAceleracion212
L__RecuperarTramaAceleracion497:
;NodoAcelerometro.c,791 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,793 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion213:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion498
	GOTO	L_RecuperarTramaAceleracion214
L__RecuperarTramaAceleracion498:
;NodoAcelerometro.c,794 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	MOV	#3034, W0
	ADD	W14, W0, W0
	ADD	W10, [W0++], W1
	ADDC	W11, [W0--], W2
	MOV	#2515, W0
	ADD	W14, W0, W0
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,795 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion499
	GOTO	L_RecuperarTramaAceleracion216
L__RecuperarTramaAceleracion499:
;NodoAcelerometro.c,797 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
L_RecuperarTramaAceleracion217:
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion500
	GOTO	L_RecuperarTramaAceleracion218
L__RecuperarTramaAceleracion500:
;NodoAcelerometro.c,798 :: 		tramaAcelSeg[y+1531] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#1531, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	#2515, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,797 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,799 :: 		}
	GOTO	L_RecuperarTramaAceleracion217
L_RecuperarTramaAceleracion218:
;NodoAcelerometro.c,800 :: 		banLecturaCorrecta = 1;
	MOV	#3040, W1
	ADD	W14, W1, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,801 :: 		contSector++;
	MOV	#3034, W3
	ADD	W14, W3, W3
	MOV	#3034, W2
	ADD	W14, W2, W2
	MOV.D	[W3], W0
	ADD	W0, #1, [W2++]
	ADDC	W1, #0, [W2--]
;NodoAcelerometro.c,802 :: 		break;
	GOTO	L_RecuperarTramaAceleracion214
;NodoAcelerometro.c,803 :: 		} else {
L_RecuperarTramaAceleracion216:
;NodoAcelerometro.c,805 :: 		tramaAcelSeg[1] = 0xEE;
	ADD	W14, #0, W2
	ADD	W2, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,806 :: 		tramaAcelSeg[2] = 0xE3;
	ADD	W2, #2, W1
	MOV.B	#227, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,807 :: 		numDatosTramaAcel = 3;
	MOV	#3038, W1
	ADD	W14, W1, W1
	MOV	#3, W0
	MOV	W0, [W1]
;NodoAcelerometro.c,808 :: 		banLecturaCorrecta = 2;
	MOV	#3040, W1
	ADD	W14, W1, W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,810 :: 		Delay_us(10);
	MOV	#80, W7
L_RecuperarTramaAceleracion221:
	DEC	W7
	BRA NZ	L_RecuperarTramaAceleracion221
	NOP
	NOP
;NodoAcelerometro.c,793 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,811 :: 		}
	GOTO	L_RecuperarTramaAceleracion213
L_RecuperarTramaAceleracion214:
;NodoAcelerometro.c,812 :: 		}
L_RecuperarTramaAceleracion212:
;NodoAcelerometro.c,815 :: 		if (banLecturaCorrecta==1){
	MOV	#3040, W0
	ADD	W14, W0, W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__RecuperarTramaAceleracion501
	GOTO	L_RecuperarTramaAceleracion223
L__RecuperarTramaAceleracion501:
;NodoAcelerometro.c,816 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,818 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion224:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion502
	GOTO	L_RecuperarTramaAceleracion225
L__RecuperarTramaAceleracion502:
;NodoAcelerometro.c,819 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	MOV	#3034, W0
	ADD	W14, W0, W0
	ADD	W10, [W0++], W1
	ADDC	W11, [W0--], W2
	MOV	#2515, W0
	ADD	W14, W0, W0
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,820 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion503
	GOTO	L_RecuperarTramaAceleracion227
L__RecuperarTramaAceleracion503:
;NodoAcelerometro.c,822 :: 		for (y=0;y<464;y++){
	CLR	W0
	MOV	W0, _y
L_RecuperarTramaAceleracion228:
	MOV	_y, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion504
	GOTO	L_RecuperarTramaAceleracion229
L__RecuperarTramaAceleracion504:
;NodoAcelerometro.c,823 :: 		tramaAcelSeg[y+2043] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#2043, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	#2515, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,822 :: 		for (y=0;y<464;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,824 :: 		}
	GOTO	L_RecuperarTramaAceleracion228
L_RecuperarTramaAceleracion229:
;NodoAcelerometro.c,825 :: 		banLecturaCorrecta = 1;
	MOV	#3040, W1
	ADD	W14, W1, W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,826 :: 		break;
	GOTO	L_RecuperarTramaAceleracion225
;NodoAcelerometro.c,827 :: 		} else {
L_RecuperarTramaAceleracion227:
;NodoAcelerometro.c,829 :: 		tramaAcelSeg[1] = 0xEE;
	ADD	W14, #0, W2
	ADD	W2, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,830 :: 		tramaAcelSeg[2] = 0xE3;
	ADD	W2, #2, W1
	MOV.B	#227, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,831 :: 		numDatosTramaAcel = 3;
	MOV	#3038, W1
	ADD	W14, W1, W1
	MOV	#3, W0
	MOV	W0, [W1]
;NodoAcelerometro.c,832 :: 		banLecturaCorrecta = 2;
	MOV	#3040, W1
	ADD	W14, W1, W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,834 :: 		Delay_us(10);
	MOV	#80, W7
L_RecuperarTramaAceleracion232:
	DEC	W7
	BRA NZ	L_RecuperarTramaAceleracion232
	NOP
	NOP
;NodoAcelerometro.c,818 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,835 :: 		}
	GOTO	L_RecuperarTramaAceleracion224
L_RecuperarTramaAceleracion225:
;NodoAcelerometro.c,836 :: 		}
L_RecuperarTramaAceleracion223:
;NodoAcelerometro.c,839 :: 		if (banLecturaCorrecta==1){
	MOV	#3040, W0
	ADD	W14, W0, W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__RecuperarTramaAceleracion505
	GOTO	L_RecuperarTramaAceleracion234
L__RecuperarTramaAceleracion505:
;NodoAcelerometro.c,840 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion235:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__RecuperarTramaAceleracion506
	GOTO	L_RecuperarTramaAceleracion236
L__RecuperarTramaAceleracion506:
;NodoAcelerometro.c,841 :: 		tramaAcelSeg[2507+x] = tiempoAcel[x];
	MOV	#2507, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	#3027, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,840 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,842 :: 		}
	GOTO	L_RecuperarTramaAceleracion235
L_RecuperarTramaAceleracion236:
;NodoAcelerometro.c,843 :: 		TEST = ~TEST;
	BTG	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,844 :: 		}
L_RecuperarTramaAceleracion234:
;NodoAcelerometro.c,847 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, numDatosTramaAcel, tramaAcelSeg);
	ADD	W14, #0, W1
	MOV	#3038, W0
	ADD	W14, W0, W0
	PUSH.D	W10
	MOV	[W0], W13
	MOV.B	#243, W12
	MOV.B	#2, W11
	MOV.B	#1, W10
	PUSH	W1
	CALL	_EnviarTramaRS485
	SUB	#2, W15
	POP.D	W10
;NodoAcelerometro.c,849 :: 		}
L_end_RecuperarTramaAceleracion:
	POP	W13
	POP	W12
	ULNK
	RETURN
; end of _RecuperarTramaAceleracion

_GuardarPruebaSD:
	LNK	#2506

;NodoAcelerometro.c,854 :: 		void GuardarPruebaSD(unsigned char* tiempoSD){
;NodoAcelerometro.c,863 :: 		contadorEjemploSD = 0;
	PUSH	W11
	PUSH	W12
	PUSH	W13
; contadorEjemploSD start address is: 4 (W2)
	CLR	W2
;NodoAcelerometro.c,864 :: 		for (x=0;x<2500;x++){
	CLR	W0
	MOV	W0, _x
; contadorEjemploSD end address is: 4 (W2)
L_GuardarPruebaSD238:
; contadorEjemploSD start address is: 4 (W2)
	MOV	_x, W1
	MOV	#2500, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD508
	GOTO	L_GuardarPruebaSD239
L__GuardarPruebaSD508:
;NodoAcelerometro.c,865 :: 		aceleracionSD[x] = contadorEjemploSD;
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
;NodoAcelerometro.c,866 :: 		contadorEjemploSD ++;
	ADD.B	W2, #1, W1
	MOV.B	W1, W2
;NodoAcelerometro.c,867 :: 		if (contadorEjemploSD >= 255){
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA GEU	L__GuardarPruebaSD509
	GOTO	L__GuardarPruebaSD360
L__GuardarPruebaSD509:
;NodoAcelerometro.c,868 :: 		contadorEjemploSD = 0;
	CLR	W2
; contadorEjemploSD end address is: 4 (W2)
;NodoAcelerometro.c,869 :: 		}
	GOTO	L_GuardarPruebaSD241
L__GuardarPruebaSD360:
;NodoAcelerometro.c,867 :: 		if (contadorEjemploSD >= 255){
;NodoAcelerometro.c,869 :: 		}
L_GuardarPruebaSD241:
;NodoAcelerometro.c,864 :: 		for (x=0;x<2500;x++){
; contadorEjemploSD start address is: 4 (W2)
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,870 :: 		}
; contadorEjemploSD end address is: 4 (W2)
	GOTO	L_GuardarPruebaSD238
L_GuardarPruebaSD239:
;NodoAcelerometro.c,873 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD242:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarPruebaSD510
	GOTO	L_GuardarPruebaSD243
L__GuardarPruebaSD510:
;NodoAcelerometro.c,874 :: 		bufferSD[x] = cabeceraSD[x];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_cabeceraSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,873 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,875 :: 		}
	GOTO	L_GuardarPruebaSD242
L_GuardarPruebaSD243:
;NodoAcelerometro.c,877 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD245:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarPruebaSD511
	GOTO	L_GuardarPruebaSD246
L__GuardarPruebaSD511:
;NodoAcelerometro.c,878 :: 		bufferSD[6+x] = tiempoSD[x];
	MOV	_x, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W10, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,877 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,879 :: 		}
	GOTO	L_GuardarPruebaSD245
L_GuardarPruebaSD246:
;NodoAcelerometro.c,881 :: 		for (x=0;x<500;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD248:
	MOV	_x, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD512
	GOTO	L_GuardarPruebaSD249
L__GuardarPruebaSD512:
;NodoAcelerometro.c,882 :: 		bufferSD[12+x] = aceleracionSD[x];
	MOV	_x, W0
	ADD	W0, #12, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,881 :: 		for (x=0;x<500;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,883 :: 		}
	GOTO	L_GuardarPruebaSD248
L_GuardarPruebaSD249:
;NodoAcelerometro.c,885 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,887 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,890 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD251:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD513
	GOTO	L_GuardarPruebaSD252
L__GuardarPruebaSD513:
;NodoAcelerometro.c,891 :: 		bufferSD[x] = aceleracionSD[x+500];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#500, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,890 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,892 :: 		}
	GOTO	L_GuardarPruebaSD251
L_GuardarPruebaSD252:
;NodoAcelerometro.c,893 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,894 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,897 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD254:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD514
	GOTO	L_GuardarPruebaSD255
L__GuardarPruebaSD514:
;NodoAcelerometro.c,898 :: 		bufferSD[x] = aceleracionSD[x+1012];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1012, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,897 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,899 :: 		}
	GOTO	L_GuardarPruebaSD254
L_GuardarPruebaSD255:
;NodoAcelerometro.c,900 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,901 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,904 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD257:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD515
	GOTO	L_GuardarPruebaSD258
L__GuardarPruebaSD515:
;NodoAcelerometro.c,905 :: 		bufferSD[x] = aceleracionSD[x+1524];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1524, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,904 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,906 :: 		}
	GOTO	L_GuardarPruebaSD257
L_GuardarPruebaSD258:
;NodoAcelerometro.c,907 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,908 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,911 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD260:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD516
	GOTO	L_GuardarPruebaSD261
L__GuardarPruebaSD516:
;NodoAcelerometro.c,912 :: 		if (x<464){
	MOV	_x, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD517
	GOTO	L_GuardarPruebaSD263
L__GuardarPruebaSD517:
;NodoAcelerometro.c,913 :: 		bufferSD[x] = aceleracionSD[x+2036];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#2036, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,914 :: 		} else {
	GOTO	L_GuardarPruebaSD264
L_GuardarPruebaSD263:
;NodoAcelerometro.c,915 :: 		bufferSD[x] = 0;
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,916 :: 		}
L_GuardarPruebaSD264:
;NodoAcelerometro.c,911 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,917 :: 		}
	GOTO	L_GuardarPruebaSD260
L_GuardarPruebaSD261:
;NodoAcelerometro.c,918 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
;NodoAcelerometro.c,919 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,922 :: 		if (horaSistema%300==0){
	MOV	#300, W2
	MOV	#0, W3
	MOV	_horaSistema, W0
	MOV	_horaSistema+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	POP	W10
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__GuardarPruebaSD518
	GOTO	L_GuardarPruebaSD265
L__GuardarPruebaSD518:
;NodoAcelerometro.c,923 :: 		GuardarInfoSector(sectorSD, infoUltimoSector);
	PUSH	W10
	MOV	_infoUltimoSector, W12
	MOV	_infoUltimoSector+2, W13
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarInfoSector
	POP	W10
;NodoAcelerometro.c,924 :: 		}
L_GuardarPruebaSD265:
;NodoAcelerometro.c,926 :: 		TEST = 0;                                                               //Apaga el TEST cuando termina de gurdar la trama
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,928 :: 		}
L_end_GuardarPruebaSD:
	POP	W13
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _GuardarPruebaSD

_int_1:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;NodoAcelerometro.c,939 :: 		void int_1() org IVT_ADDR_INT1INTERRUPT {
;NodoAcelerometro.c,941 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;NodoAcelerometro.c,944 :: 		if ((horaSistema==0)&&(banInicioMuestreo==1)){
	MOV	_horaSistema, W0
	MOV	_horaSistema+2, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__int_1520
	GOTO	L__int_1363
L__int_1520:
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1521
	GOTO	L__int_1362
L__int_1521:
L__int_1361:
;NodoAcelerometro.c,945 :: 		PSEC = sectorSD;
	MOV	_sectorSD, W0
	MOV	_sectorSD+2, W1
	MOV	W0, _PSEC
	MOV	W1, _PSEC+2
;NodoAcelerometro.c,946 :: 		GuardarInfoSector(PSEC, infoPrimerSector);
	MOV	_infoPrimerSector, W12
	MOV	_infoPrimerSector+2, W13
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarInfoSector
;NodoAcelerometro.c,944 :: 		if ((horaSistema==0)&&(banInicioMuestreo==1)){
L__int_1363:
L__int_1362:
;NodoAcelerometro.c,949 :: 		if (banSetReloj==1){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1522
	GOTO	L_int_1269
L__int_1522:
;NodoAcelerometro.c,950 :: 		horaSistema++;                                                          //Incrementa el reloj del sistema
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaSistema), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,951 :: 		if (horaSistema==86400){                                                //(24*3600)+(0*60)+(0) = 86400
	MOV	_horaSistema, W2
	MOV	_horaSistema+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__int_1523
	GOTO	L_int_1270
L__int_1523:
;NodoAcelerometro.c,952 :: 		horaSistema = 0;                                                     //Reinicia el reloj al llegar a las 24:00:00 horas
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,953 :: 		fechaSistema = IncrementarFecha(fechaSistema);                       //Incrementa la fecha del sistema
	MOV	_fechaSistema, W10
	MOV	_fechaSistema+2, W11
	CALL	_IncrementarFecha
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,954 :: 		}
L_int_1270:
;NodoAcelerometro.c,955 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza la trama de tiempo
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;NodoAcelerometro.c,956 :: 		TEST = ~TEST;
	BTG	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,957 :: 		}
L_int_1269:
;NodoAcelerometro.c,959 :: 		if (banInicioMuestreo==1){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1524
	GOTO	L_int_1271
L__int_1524:
;NodoAcelerometro.c,960 :: 		Muestrear();                                                          //Inicia el muestreo
	CALL	_Muestrear
;NodoAcelerometro.c,962 :: 		}
L_int_1271:
;NodoAcelerometro.c,964 :: 		}
L_end_int_1:
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
; end of _int_1

_Timer1Int:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;NodoAcelerometro.c,969 :: 		void Timer1Int() org IVT_ADDR_T1INTERRUPT{
;NodoAcelerometro.c,971 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer1
	PUSH	W10
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;NodoAcelerometro.c,973 :: 		numFIFO = ADXL355_read_byte(FIFO_ENTRIES); //75                            //Lee el numero de muestras disponibles en el FIFO
	MOV.B	#5, W10
	CALL	_ADXL355_read_byte
	MOV	#lo_addr(_numFIFO), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,974 :: 		numSetsFIFO = (numFIFO)/3;                 //25                            //Lee el numero de sets disponibles en el FIFO
	ZE	W0, W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(_numSetsFIFO), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,977 :: 		for (x=0;x<numSetsFIFO;x++){
	CLR	W0
	MOV	W0, _x
L_Timer1Int272:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Timer1Int526
	GOTO	L_Timer1Int273
L__Timer1Int526:
;NodoAcelerometro.c,978 :: 		ADXL355_read_FIFO(datosLeidos);                                        //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,979 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Timer1Int275:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Timer1Int527
	GOTO	L_Timer1Int276
L__Timer1Int527:
;NodoAcelerometro.c,980 :: 		datosFIFO[y+(x*9)] = datosLeidos[y];                               //LLena la trama datosFIFO
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
;NodoAcelerometro.c,979 :: 		for (y=0;y<9;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,981 :: 		}
	GOTO	L_Timer1Int275
L_Timer1Int276:
;NodoAcelerometro.c,977 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,982 :: 		}
	GOTO	L_Timer1Int272
L_Timer1Int273:
;NodoAcelerometro.c,985 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	CLR	W0
	MOV	W0, _x
L_Timer1Int278:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Timer1Int528
	GOTO	L_Timer1Int279
L__Timer1Int528:
;NodoAcelerometro.c,986 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int529
	GOTO	L__Timer1Int366
L__Timer1Int529:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int530
	GOTO	L__Timer1Int365
L__Timer1Int530:
	GOTO	L_Timer1Int283
L__Timer1Int366:
L__Timer1Int365:
;NodoAcelerometro.c,987 :: 		tramaAceleracion[contFIFO+contMuestras+x] = contMuestras;
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_tramaAceleracion), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_contMuestras), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,988 :: 		tramaAceleracion[contFIFO+contMuestras+x+1] = datosFIFO[x];
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaAceleracion), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_datosFIFO), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,989 :: 		contMuestras++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contMuestras), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,990 :: 		} else {
	GOTO	L_Timer1Int284
L_Timer1Int283:
;NodoAcelerometro.c,991 :: 		tramaAceleracion[contFIFO+contMuestras+x] = datosFIFO[x];
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#lo_addr(_contFIFO), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_tramaAceleracion), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_datosFIFO), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,992 :: 		}
L_Timer1Int284:
;NodoAcelerometro.c,985 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,993 :: 		}
	GOTO	L_Timer1Int278
L_Timer1Int279:
;NodoAcelerometro.c,995 :: 		contFIFO = (contMuestras*9);                                               //Incrementa el contador de FIFOs
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,997 :: 		contTimer1++;                                                              //Incrementa una unidad cada vez que entra a la interrupcion por Timer1
	MOV.B	#1, W1
	MOV	#lo_addr(_contTimer1), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,999 :: 		if (contTimer1==numTMR1){                                                  //Verifica si se cumplio el numero de interrupciones por TMR1 para la tasa de muestreo seleccionada
	MOV	#lo_addr(_contTimer1), W0
	ZE	[W0], W1
	MOV	#lo_addr(_numTMR1), W0
	SE	[W0], W0
	CP	W1, W0
	BRA Z	L__Timer1Int531
	GOTO	L_Timer1Int285
L__Timer1Int531:
;NodoAcelerometro.c,1000 :: 		T1CON.TON = 0;                                                          //Apaga el Timer1
	BCLR	T1CON, #15
;NodoAcelerometro.c,1001 :: 		banCiclo = 1;                                                           //Activa la bandera que indica que se completo un ciclo de medicion
	MOV	#lo_addr(_banCiclo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1002 :: 		contTimer1 = 0;                                                         //Limpia el contador de interrupciones por Timer1
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1003 :: 		}
L_Timer1Int285:
;NodoAcelerometro.c,1005 :: 		}
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

_Timer2Int:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;NodoAcelerometro.c,1010 :: 		void Timer2Int() org IVT_ADDR_T2INTERRUPT{
;NodoAcelerometro.c,1012 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer2
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;NodoAcelerometro.c,1013 :: 		contTMR2++;                                                                //Incrementa el contador de TMR2
	MOV.B	#1, W1
	MOV	#lo_addr(_contTMR2), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,1016 :: 		if (contTMR2==4){
	MOV	#lo_addr(_contTMR2), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA Z	L__Timer2Int533
	GOTO	L_Timer2Int286
L__Timer2Int533:
;NodoAcelerometro.c,1017 :: 		T2CON.TON = 0;
	BCLR	T2CON, #15
;NodoAcelerometro.c,1018 :: 		TMR2 = 0;
	CLR	TMR2
;NodoAcelerometro.c,1019 :: 		contTMR2 = 0;
	MOV	#lo_addr(_contTMR2), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1025 :: 		UART1_Init_Advanced(2000000, _UART_8BIT_NOPARITY, _UART_ONE_STOPBIT, _UART_HI_SPEED); //**
	CLR	W13
	CLR	W12
	MOV	#33920, W10
	MOV	#30, W11
	MOV	#1, W0
	PUSH	W0
	CALL	_UART1_Init_Advanced
	SUB	#2, W15
;NodoAcelerometro.c,1026 :: 		}
L_Timer2Int286:
;NodoAcelerometro.c,1029 :: 		}
L_end_Timer2Int:
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
; end of _Timer2Int

_urx_1:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;NodoAcelerometro.c,1035 :: 		void urx_1() org  IVT_ADDR_U1RXINTERRUPT {
;NodoAcelerometro.c,1038 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;NodoAcelerometro.c,1039 :: 		byteRS485 = U1RXREG;
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	U1RXREG, WREG
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1040 :: 		OERR_bit = 0;                                                              //Limpia este bit para limpiar el FIFO UART
	BCLR	OERR_bit, BitPos(OERR_bit+0)
;NodoAcelerometro.c,1043 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_1535
	GOTO	L_urx_1287
L__urx_1535:
;NodoAcelerometro.c,1045 :: 		if (i_rs485<(numDatosRS485)){
	MOV	_i_rs485, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__urx_1536
	GOTO	L_urx_1288
L__urx_1536:
;NodoAcelerometro.c,1046 :: 		inputPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1047 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,1048 :: 		} else {
	GOTO	L_urx_1289
L_urx_1288:
;NodoAcelerometro.c,1050 :: 		banRSI = 0;                                                          //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1051 :: 		banRSC = 1;                                                          //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1052 :: 		}
L_urx_1289:
;NodoAcelerometro.c,1053 :: 		}
L_urx_1287:
;NodoAcelerometro.c,1056 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1537
	GOTO	L__urx_1374
L__urx_1537:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1538
	GOTO	L__urx_1373
L__urx_1538:
L__urx_1372:
;NodoAcelerometro.c,1057 :: 		if (byteRS485==0x3A){                                                   //Verifica si el primer byte recibido sea la cabecera de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__urx_1539
	GOTO	L_urx_1293
L__urx_1539:
;NodoAcelerometro.c,1058 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1059 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,1060 :: 		}
L_urx_1293:
;NodoAcelerometro.c,1056 :: 		if ((banRSI==0)&&(banRSC==0)){
L__urx_1374:
L__urx_1373:
;NodoAcelerometro.c,1062 :: 		if ((banRSI==1)&&(i_rs485<5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1540
	GOTO	L__urx_1376
L__urx_1540:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA LTU	L__urx_1541
	GOTO	L__urx_1375
L__urx_1541:
L__urx_1371:
;NodoAcelerometro.c,1063 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                                //Recupera los datos de cabecera de la trama UART: [0x3A, Direccion, Funcion, NumeroDatosLSB, NumeroDatosMSB]
	MOV	#lo_addr(_tramaCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1064 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,1062 :: 		if ((banRSI==1)&&(i_rs485<5)){
L__urx_1376:
L__urx_1375:
;NodoAcelerometro.c,1066 :: 		if ((banRSI==1)&&(i_rs485==5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1542
	GOTO	L__urx_1380
L__urx_1542:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA Z	L__urx_1543
	GOTO	L__urx_1379
L__urx_1543:
L__urx_1370:
;NodoAcelerometro.c,1068 :: 		if ((tramaCabeceraRS485[1]==IDNODO)||(tramaCabeceraRS485[1]==255)){
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__urx_1544
	GOTO	L__urx_1378
L__urx_1544:
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W1
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1545
	GOTO	L__urx_1377
L__urx_1545:
	GOTO	L_urx_1302
L__urx_1378:
L__urx_1377:
;NodoAcelerometro.c,1069 :: 		funcionRS485 = tramaCabeceraRS485[2];
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_tramaCabeceraRS485+2), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1070 :: 		*(ptrnumDatosRS485) = tramaCabeceraRS485[3];                         //LSB numDatosRS485
	MOV	#lo_addr(_tramaCabeceraRS485+3), W1
	MOV	_ptrnumDatosRS485, W0
	MOV.B	[W1], [W0]
;NodoAcelerometro.c,1071 :: 		*(ptrnumDatosRS485+1) = tramaCabeceraRS485[4];                       //MSB numDatosRS485
	MOV	_ptrnumDatosRS485, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaCabeceraRS485+4), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1072 :: 		banRSI = 2;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1073 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,1074 :: 		} else {
	GOTO	L_urx_1303
L_urx_1302:
;NodoAcelerometro.c,1075 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1076 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1077 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,1078 :: 		T2CON.TON = 1;                                                       //Enciende el Timer2
	BSET	T2CON, #15
;NodoAcelerometro.c,1079 :: 		TMR2 = 0;                                                            //Encera el Timer2
	CLR	TMR2
;NodoAcelerometro.c,1080 :: 		contTMR2 = 0;
	MOV	#lo_addr(_contTMR2), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1081 :: 		U1MODE.UARTEN = 0;                                                   //Desactiva el UART1
	BCLR	U1MODE, #15
;NodoAcelerometro.c,1082 :: 		}
L_urx_1303:
;NodoAcelerometro.c,1066 :: 		if ((banRSI==1)&&(i_rs485==5)){
L__urx_1380:
L__urx_1379:
;NodoAcelerometro.c,1086 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1546
	GOTO	L_urx_1304
L__urx_1546:
;NodoAcelerometro.c,1087 :: 		subFuncionRS485 = inputPyloadRS485[0];
	MOV	#lo_addr(_subFuncionRS485), W1
	MOV	#lo_addr(_inputPyloadRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1088 :: 		switch (funcionRS485){
	GOTO	L_urx_1305
;NodoAcelerometro.c,1090 :: 		case 0xF1:
L_urx_1307:
;NodoAcelerometro.c,1093 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1547
	GOTO	L_urx_1308
L__urx_1547:
;NodoAcelerometro.c,1094 :: 		for (x=0;x<6;x++) {
	CLR	W0
	MOV	W0, _x
L_urx_1309:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1548
	GOTO	L_urx_1310
L__urx_1548:
;NodoAcelerometro.c,1095 :: 		tiempo[x] = inputPyloadRS485[x+1];                       //LLena la trama tiempo con el payload de la trama recuperada
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_inputPyloadRS485), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,1094 :: 		for (x=0;x<6;x++) {
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,1096 :: 		}
	GOTO	L_urx_1309
L_urx_1310:
;NodoAcelerometro.c,1097 :: 		horaSistema = RecuperarHoraRPI(tiempo);                      //Recupera la hora de la RPi
	MOV	#lo_addr(_tiempo), W10
	CALL	_RecuperarHoraRPI
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,1098 :: 		fechaSistema = RecuperarFechaRPI(tiempo);                    //Recupera la fecha de la RPi
	MOV	#lo_addr(_tiempo), W10
	CALL	_RecuperarFechaRPI
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,1099 :: 		fuenteReloj =  inputPyloadRS485[7];                          //Recupera la fuente de reloj
	MOV	#lo_addr(_fuenteReloj), W1
	MOV	#lo_addr(_inputPyloadRS485+7), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1100 :: 		banSetReloj = 1;                                             //Activa la bandera para indicar que se establecio la hora y fecha
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1101 :: 		}
L_urx_1308:
;NodoAcelerometro.c,1103 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1549
	GOTO	L_urx_1312
L__urx_1549:
;NodoAcelerometro.c,1105 :: 		outputPyloadRS485[0] = 0xD2;
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1106 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_urx_1313:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1550
	GOTO	L_urx_1314
L__urx_1550:
;NodoAcelerometro.c,1107 :: 		outputPyloadRS485[x+1] = tiempo[x];
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_outputPyloadRS485), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,1106 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,1108 :: 		}
	GOTO	L_urx_1313
L_urx_1314:
;NodoAcelerometro.c,1109 :: 		outputPyloadRS485[7] = fuenteReloj;
	MOV	#lo_addr(_outputPyloadRS485+7), W1
	MOV	#lo_addr(_fuenteReloj), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1110 :: 		EnviarTramaRS485(1, IDNODO, 0xF1, 8, outputPyloadRS485);     //Envia la hora local al Master
	MOV	#8, W13
	MOV.B	#241, W12
	MOV.B	#2, W11
	MOV.B	#1, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;NodoAcelerometro.c,1111 :: 		}
L_urx_1312:
;NodoAcelerometro.c,1112 :: 		break;
	GOTO	L_urx_1306
;NodoAcelerometro.c,1114 :: 		case 0xF2:
L_urx_1316:
;NodoAcelerometro.c,1117 :: 		if ((subFuncionRS485==0xD1)&&(banInicioMuestreo==0)){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1551
	GOTO	L__urx_1382
L__urx_1551:
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1552
	GOTO	L__urx_1381
L__urx_1552:
L__urx_1368:
;NodoAcelerometro.c,1118 :: 		sectorSD = UbicarUltimoSectorEscrito(inputPyloadRS485[1]);   //inputPyloadRS485[1] = sobrescribir (0=no, 1=si)
	MOV	#lo_addr(_inputPyloadRS485+1), W0
	MOV.B	[W0], W10
	CALL	_UbicarUltimoSectorEscrito
	MOV	W0, _sectorSD
	MOV	W1, _sectorSD+2
;NodoAcelerometro.c,1119 :: 		PSEC = sectorSD;                                             //Guarda el numero del primer sector escrito en este ciclo de muestreo
	MOV	W0, _PSEC
	MOV	W1, _PSEC+2
;NodoAcelerometro.c,1120 :: 		GuardarInfoSector(PSEC, infoPrimerSector);
	MOV	_infoPrimerSector, W12
	MOV	_infoPrimerSector+2, W13
	MOV.D	W0, W10
	CALL	_GuardarInfoSector
;NodoAcelerometro.c,1121 :: 		banInicioMuestreo = 1;                                       //Activa la bandera para iniciar el muestreo
	MOV	#lo_addr(_banInicioMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1117 :: 		if ((subFuncionRS485==0xD1)&&(banInicioMuestreo==0)){
L__urx_1382:
L__urx_1381:
;NodoAcelerometro.c,1124 :: 		if ((subFuncionRS485==0xD2)&&(banInicioMuestreo==1)){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1553
	GOTO	L__urx_1384
L__urx_1553:
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1554
	GOTO	L__urx_1383
L__urx_1554:
L__urx_1367:
;NodoAcelerometro.c,1125 :: 		GuardarInfoSector(sectorSD, infoUltimoSector);                //Guarda la posicion del ultimo sector escrito
	MOV	_infoUltimoSector, W12
	MOV	_infoUltimoSector+2, W13
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarInfoSector
;NodoAcelerometro.c,1126 :: 		banInicioMuestreo = 0;                                        //Limpia la bandera para detener el muestreo
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1124 :: 		if ((subFuncionRS485==0xD2)&&(banInicioMuestreo==1)){
L__urx_1384:
L__urx_1383:
;NodoAcelerometro.c,1128 :: 		break;
	GOTO	L_urx_1306
;NodoAcelerometro.c,1130 :: 		case 0xF3:
L_urx_1323:
;NodoAcelerometro.c,1133 :: 		*ptrsectorReq = inputPyloadRS485[1];                             //LSB sectorReq
	MOV	#lo_addr(_inputPyloadRS485+1), W1
	MOV	_ptrsectorReq, W0
	MOV.B	[W1], [W0]
;NodoAcelerometro.c,1134 :: 		*(ptrsectorReq+1) = inputPyloadRS485[2];
	MOV	_ptrsectorReq, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_inputPyloadRS485+2), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1135 :: 		*(ptrsectorReq+2) = inputPyloadRS485[3];
	MOV	_ptrsectorReq, W0
	ADD	W0, #2, W1
	MOV	#lo_addr(_inputPyloadRS485+3), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1136 :: 		*(ptrsectorReq+3) = inputPyloadRS485[4];                         //MSB sectorReq
	MOV	_ptrsectorReq, W0
	ADD	W0, #3, W1
	MOV	#lo_addr(_inputPyloadRS485+4), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1139 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1555
	GOTO	L_urx_1324
L__urx_1555:
;NodoAcelerometro.c,1141 :: 		InformacionSectores();
	CALL	_InformacionSectores
;NodoAcelerometro.c,1142 :: 		}
L_urx_1324:
;NodoAcelerometro.c,1144 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1556
	GOTO	L_urx_1325
L__urx_1556:
;NodoAcelerometro.c,1146 :: 		if (banInicioMuestreo==0){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1557
	GOTO	L_urx_1326
L__urx_1557:
;NodoAcelerometro.c,1148 :: 		InspeccionarSector(0, sectorReq);
	MOV	_sectorReq, W11
	MOV	_sectorReq+2, W12
	CLR	W10
	CALL	_InspeccionarSector
;NodoAcelerometro.c,1149 :: 		} else {
	GOTO	L_urx_1327
L_urx_1326:
;NodoAcelerometro.c,1151 :: 		banInsSec=1;
	MOV	#lo_addr(_banInsSec), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1152 :: 		}
L_urx_1327:
;NodoAcelerometro.c,1153 :: 		}
L_urx_1325:
;NodoAcelerometro.c,1155 :: 		if (subFuncionRS485==0xD3){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#211, W0
	CP.B	W1, W0
	BRA Z	L__urx_1558
	GOTO	L_urx_1328
L__urx_1558:
;NodoAcelerometro.c,1158 :: 		if (banInicioMuestreo==0){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1559
	GOTO	L_urx_1329
L__urx_1559:
;NodoAcelerometro.c,1159 :: 		RecuperarTramaAceleracion(sectorReq);
	MOV	_sectorReq, W10
	MOV	_sectorReq+2, W11
	CALL	_RecuperarTramaAceleracion
;NodoAcelerometro.c,1160 :: 		}
L_urx_1329:
;NodoAcelerometro.c,1161 :: 		}
L_urx_1328:
;NodoAcelerometro.c,1162 :: 		break;
	GOTO	L_urx_1306
;NodoAcelerometro.c,1164 :: 		}
L_urx_1305:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1560
	GOTO	L_urx_1307
L__urx_1560:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1561
	GOTO	L_urx_1316
L__urx_1561:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1562
	GOTO	L_urx_1323
L__urx_1562:
L_urx_1306:
;NodoAcelerometro.c,1166 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1167 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1169 :: 		}
L_urx_1304:
;NodoAcelerometro.c,1171 :: 		}
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
