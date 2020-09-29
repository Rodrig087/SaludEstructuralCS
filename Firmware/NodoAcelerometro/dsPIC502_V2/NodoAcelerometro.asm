
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
	BRA NZ	L__ADXL355_init376
	GOTO	L_ADXL355_init4
L__ADXL355_init376:
	CP.B	W10, #2
	BRA NZ	L__ADXL355_init377
	GOTO	L_ADXL355_init5
L__ADXL355_init377:
	CP.B	W10, #4
	BRA NZ	L__ADXL355_init378
	GOTO	L_ADXL355_init6
L__ADXL355_init378:
	CP.B	W10, #8
	BRA NZ	L__ADXL355_init379
	GOTO	L_ADXL355_init7
L__ADXL355_init379:
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
	BRA Z	L__ADXL355_read_data383
	GOTO	L_ADXL355_read_data8
L__ADXL355_read_data383:
;adxl355_spi.c,152 :: 		CS_ADXL355=0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,153 :: 		for (j=0;j<9;j++){
; j start address is: 4 (W2)
	CLR	W2
; j end address is: 4 (W2)
L_ADXL355_read_data9:
; j start address is: 4 (W2)
	CP.B	W2, #9
	BRA LTU	L__ADXL355_read_data384
	GOTO	L_ADXL355_read_data10
L__ADXL355_read_data384:
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
	BRA LTU	L__ADXL355_read_data385
	GOTO	L_ADXL355_read_data14
L__ADXL355_read_data385:
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
	BRA LTU	L__IncrementarFecha394
	GOTO	L_IncrementarFecha18
L__IncrementarFecha394:
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
	BRA Z	L__IncrementarFecha395
	GOTO	L_IncrementarFecha20
L__IncrementarFecha395:
;tiempo_rtc.c,203 :: 		if (((anio-16)%4)==0){
	SUB	W2, #16, W0
	SUBB	W3, #0, W1
	AND	W0, #3, W0
	AND	W1, #0, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__IncrementarFecha396
	GOTO	L_IncrementarFecha21
L__IncrementarFecha396:
;tiempo_rtc.c,204 :: 		if (dia==29){
	CP	W6, #29
	CPB	W7, #0
	BRA Z	L__IncrementarFecha397
	GOTO	L_IncrementarFecha22
L__IncrementarFecha397:
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
	BRA LTU	L__IncrementarFecha398
	GOTO	L_IncrementarFecha26
L__IncrementarFecha398:
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
	BRA NZ	L__IncrementarFecha399
	GOTO	L__IncrementarFecha323
L__IncrementarFecha399:
	CP	W4, #6
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha400
	GOTO	L__IncrementarFecha322
L__IncrementarFecha400:
	CP	W4, #9
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha401
	GOTO	L__IncrementarFecha321
L__IncrementarFecha401:
	CP	W4, #11
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha402
	GOTO	L__IncrementarFecha320
L__IncrementarFecha402:
	MOV.D	W4, W0
	MOV.D	W6, W4
	GOTO	L_IncrementarFecha30
L__IncrementarFecha323:
L__IncrementarFecha322:
L__IncrementarFecha321:
L__IncrementarFecha320:
;tiempo_rtc.c,219 :: 		if (dia==30){
	CP	W6, #30
	CPB	W7, #0
	BRA Z	L__IncrementarFecha403
	GOTO	L_IncrementarFecha31
L__IncrementarFecha403:
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
	BRA NZ	L__IncrementarFecha404
	GOTO	L__IncrementarFecha333
L__IncrementarFecha404:
	CP	W0, #1
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha405
	GOTO	L__IncrementarFecha329
L__IncrementarFecha405:
	CP	W0, #3
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha406
	GOTO	L__IncrementarFecha328
L__IncrementarFecha406:
	CP	W0, #5
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha407
	GOTO	L__IncrementarFecha327
L__IncrementarFecha407:
	CP	W0, #7
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha408
	GOTO	L__IncrementarFecha326
L__IncrementarFecha408:
	CP	W0, #8
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha409
	GOTO	L__IncrementarFecha325
L__IncrementarFecha409:
	CP	W0, #10
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha410
	GOTO	L__IncrementarFecha324
L__IncrementarFecha410:
	GOTO	L_IncrementarFecha37
L__IncrementarFecha329:
L__IncrementarFecha328:
L__IncrementarFecha327:
L__IncrementarFecha326:
L__IncrementarFecha325:
L__IncrementarFecha324:
L__IncrementarFecha317:
;tiempo_rtc.c,227 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha411
	GOTO	L_IncrementarFecha38
L__IncrementarFecha411:
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
	GOTO	L__IncrementarFecha330
L__IncrementarFecha333:
L__IncrementarFecha330:
;tiempo_rtc.c,234 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha412
	GOTO	L__IncrementarFecha334
L__IncrementarFecha412:
	CP	W0, #12
	CPB	W1, #0
	BRA Z	L__IncrementarFecha413
	GOTO	L__IncrementarFecha335
L__IncrementarFecha413:
L__IncrementarFecha316:
;tiempo_rtc.c,235 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha414
	GOTO	L_IncrementarFecha43
L__IncrementarFecha414:
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
	GOTO	L__IncrementarFecha332
L__IncrementarFecha334:
L__IncrementarFecha332:
; mes start address is: 0 (W0)
; anio start address is: 4 (W2)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha331
L__IncrementarFecha335:
L__IncrementarFecha331:
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
	BRA Z	L__EnviarTramaRS485417
	GOTO	L__EnviarTramaRS485336
L__EnviarTramaRS485417:
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
	BRA LTU	L__EnviarTramaRS485418
	GOTO	L_EnviarTramaRS48547
L__EnviarTramaRS485418:
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
	BRA Z	L__EnviarTramaRS485419
	GOTO	L_EnviarTramaRS48550
L__EnviarTramaRS485419:
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
L__EnviarTramaRS485336:
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
	BRA Z	L__EnviarTramaRS485420
	GOTO	L_EnviarTramaRS48551
L__EnviarTramaRS485420:
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
	BRA LTU	L__EnviarTramaRS485421
	GOTO	L_EnviarTramaRS48553
L__EnviarTramaRS485421:
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
	BRA Z	L__EnviarTramaRS485422
	GOTO	L_EnviarTramaRS48556
L__EnviarTramaRS485422:
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

;NodoAcelerometro.c,119 :: 		void main() {
;NodoAcelerometro.c,121 :: 		ConfiguracionPrincipal();
	PUSH	W10
	CALL	_ConfiguracionPrincipal
;NodoAcelerometro.c,122 :: 		TEST = 0;                                                                                                                                        //Pin de TEST
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,124 :: 		tasaMuestreo = 1;                                                          //1=250Hz, 2=125Hz, 4=62.5Hz, 8=31.25Hz
	MOV	#lo_addr(_tasaMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,125 :: 		ADXL355_init(tasaMuestreo);                                                //Inicializa el modulo ADXL con la tasa de muestreo requerida:
	MOV.B	#1, W10
	CALL	_ADXL355_init
;NodoAcelerometro.c,126 :: 		numTMR1 = (tasaMuestreo*10)-1;                                             //Calcula el numero de veces que tienen que desbordarse el TMR1 para cada tasa de muestreo
	MOV	#lo_addr(_tasaMuestreo), W0
	SE	[W0], W1
	MOV	#10, W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(_numTMR1), W0
	SUB.B	W2, #1, [W0]
;NodoAcelerometro.c,131 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;NodoAcelerometro.c,132 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;NodoAcelerometro.c,133 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;NodoAcelerometro.c,134 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;NodoAcelerometro.c,137 :: 		inicioSistema = 0;
	MOV	#lo_addr(_inicioSistema), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,140 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,141 :: 		horaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,142 :: 		fechaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,145 :: 		banCiclo = 0;
	MOV	#lo_addr(_banCiclo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,146 :: 		banInicioMuestreo = 0;
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,147 :: 		numFIFO = 0;
	MOV	#lo_addr(_numFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,148 :: 		numSetsFIFO = 0;
	MOV	#lo_addr(_numSetsFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,149 :: 		contTimer1 = 0;
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,150 :: 		contMuestras = 0;
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,151 :: 		contCiclos = 0;
	MOV	#lo_addr(_contCiclos), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,152 :: 		contFIFO = 0;
	CLR	W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,155 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,156 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,157 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,158 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,159 :: 		funcionRS485 = 0;
	MOV	#lo_addr(_funcionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,160 :: 		subFuncionRS485 = 0;
	MOV	#lo_addr(_subFuncionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,161 :: 		numDatosRS485 = 0;
	CLR	W0
	MOV	W0, _numDatosRS485
;NodoAcelerometro.c,162 :: 		ptrnumDatosRS485 = (unsigned char *) & numDatosRS485;
	MOV	#lo_addr(_numDatosRS485), W0
	MOV	W0, _ptrnumDatosRS485
;NodoAcelerometro.c,163 :: 		ptrsectorReq = (unsigned char *) & sectorReq;
	MOV	#lo_addr(_sectorReq), W0
	MOV	W0, _ptrsectorReq
;NodoAcelerometro.c,166 :: 		PSEC = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _PSEC
	MOV	W1, _PSEC+2
;NodoAcelerometro.c,167 :: 		sectorSD = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _sectorSD
	MOV	W1, _sectorSD+2
;NodoAcelerometro.c,168 :: 		sectorLec = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _sectorLec
	MOV	W1, _sectorLec+2
;NodoAcelerometro.c,169 :: 		checkEscSD = 0;
	MOV	#lo_addr(_checkEscSD), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,170 :: 		checkLecSD = 0;
	MOV	#lo_addr(_checkLecSD), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,171 :: 		MSRS485 = 0;                                                               //Establece el Max485 en modo lectura
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;NodoAcelerometro.c,172 :: 		banInsSec = 0;
	MOV	#lo_addr(_banInsSec), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,175 :: 		switch (SIZESD){
	GOTO	L_main57
;NodoAcelerometro.c,184 :: 		case 8:
L_main61:
;NodoAcelerometro.c,185 :: 		PSF = 2048;
	MOV	#2048, W0
	MOV	#0, W1
	MOV	W0, _PSF
	MOV	W1, _PSF+2
;NodoAcelerometro.c,187 :: 		USF = 16779263;
	MOV	#2047, W0
	MOV	#256, W1
	MOV	W0, _USF
	MOV	W1, _USF+2
;NodoAcelerometro.c,188 :: 		break;
	GOTO	L_main58
;NodoAcelerometro.c,193 :: 		}
L_main57:
	GOTO	L_main61
L_main58:
;NodoAcelerometro.c,194 :: 		infoPrimerSector = PSF+DELTASECTOR-2;                                      //Calcula el sector donde se alamcena la informacion del primer sector escrito
	MOV	_PSF, W2
	MOV	_PSF+2, W3
	MOV	#32416, W0
	MOV	#1, W1
	ADD	W2, W0, W2
	ADDC	W3, W1, W3
	MOV	#lo_addr(_infoPrimerSector), W0
	SUB	W2, #2, [W0++]
	SUBB	W3, #0, [W0--]
;NodoAcelerometro.c,195 :: 		infoUltimoSector = PSF+DELTASECTOR-1;                                      //Calcula el sector donde se alamcena la informacion del ultimo sector escrito
	MOV	#lo_addr(_infoUltimoSector), W0
	SUB	W2, #1, [W0++]
	SUBB	W3, #0, [W0--]
;NodoAcelerometro.c,196 :: 		PSE = PSF+DELTASECTOR;                                                     //Calcula el primer sector de escritura
	MOV	W2, _PSE
	MOV	W3, _PSE+2
;NodoAcelerometro.c,203 :: 		while (1) {
L_main63:
;NodoAcelerometro.c,204 :: 		if (SD_Detect() == DETECTED) {
	CALL	_SD_Detect
	MOV.B	#222, W1
	CP.B	W0, W1
	BRA Z	L__main426
	GOTO	L_main65
L__main426:
;NodoAcelerometro.c,206 :: 		sdflags.detected = true;
	MOV	#lo_addr(_sdflags), W0
	BSET.B	[W0], #1
;NodoAcelerometro.c,208 :: 		break;
	GOTO	L_main64
;NodoAcelerometro.c,209 :: 		} else {
L_main65:
;NodoAcelerometro.c,211 :: 		sdflags.detected = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #1
;NodoAcelerometro.c,212 :: 		sdflags.init_ok = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #0
;NodoAcelerometro.c,215 :: 		Delay_ms(100);
	MOV	#13, W8
	MOV	#13575, W7
L_main67:
	DEC	W7
	BRA NZ	L_main67
	DEC	W8
	BRA NZ	L_main67
;NodoAcelerometro.c,216 :: 		}
	GOTO	L_main63
L_main64:
;NodoAcelerometro.c,222 :: 		if (sdflags.detected && !sdflags.init_ok) {
	MOV	#lo_addr(_sdflags), W0
	MOV.B	[W0], W0
	BTSS.B	W0, #1
	GOTO	L__main339
	MOV	#lo_addr(_sdflags), W0
	MOV.B	[W0], W0
	BTSC.B	W0, #0
	GOTO	L__main338
L__main337:
;NodoAcelerometro.c,223 :: 		if (SD_Init_Try(10) == SUCCESSFUL_INIT) {
	MOV.B	#10, W10
	CALL	_SD_Init_Try
	MOV.B	#170, W1
	CP.B	W0, W1
	BRA Z	L__main427
	GOTO	L_main72
L__main427:
;NodoAcelerometro.c,224 :: 		sdflags.init_ok = true;
	MOV	#lo_addr(_sdflags), W0
	BSET.B	[W0], #0
;NodoAcelerometro.c,225 :: 		inicioSistema = 1;                                                //Activa la bandera para permitir el inicio del sistema
	MOV	#lo_addr(_inicioSistema), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,226 :: 		TEST = 1;
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,227 :: 		} else {
	GOTO	L_main73
L_main72:
;NodoAcelerometro.c,228 :: 		sdflags.init_ok = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #0
;NodoAcelerometro.c,229 :: 		INT1IE_bit = 0;                                                   //Desabilita la interrupcion externa INT1
	BCLR	INT1IE_bit, BitPos(INT1IE_bit+0)
;NodoAcelerometro.c,230 :: 		U1MODE.UARTEN = 0;                                                //Desabilita el UART
	BCLR	U1MODE, #15
;NodoAcelerometro.c,231 :: 		inicioSistema = 0;                                                //Apaga la bandera de inicio del sistema
	MOV	#lo_addr(_inicioSistema), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,232 :: 		TEST = 0;
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,233 :: 		}
L_main73:
;NodoAcelerometro.c,222 :: 		if (sdflags.detected && !sdflags.init_ok) {
L__main339:
L__main338:
;NodoAcelerometro.c,235 :: 		Delay_ms(2000);
	MOV	#245, W8
	MOV	#9362, W7
L_main74:
	DEC	W7
	BRA NZ	L_main74
	DEC	W8
	BRA NZ	L_main74
	NOP
;NodoAcelerometro.c,238 :: 		while(1){
L_main76:
;NodoAcelerometro.c,239 :: 		asm CLRWDT;         //Clear the watchdog timer
	CLRWDT
;NodoAcelerometro.c,240 :: 		Delay_ms(100);
	MOV	#13, W8
	MOV	#13575, W7
L_main78:
	DEC	W7
	BRA NZ	L_main78
	DEC	W8
	BRA NZ	L_main78
;NodoAcelerometro.c,241 :: 		}
	GOTO	L_main76
;NodoAcelerometro.c,243 :: 		}
L_end_main:
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;NodoAcelerometro.c,251 :: 		void ConfiguracionPrincipal(){
;NodoAcelerometro.c,254 :: 		CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	CLKDIVbits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, CLKDIVbits
;NodoAcelerometro.c,255 :: 		CLKDIVbits.PLLPOST = 0;                                                    //N2=2
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,256 :: 		CLKDIVbits.PLLPRE = 5;                                                     //N1=7
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,257 :: 		PLLFBDbits.PLLDIV = 150;                                                   //M=152
	MOV	#150, W0
	MOV	W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	#511, W0
	AND	W1, W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	W1, PLLFBDbits
;NodoAcelerometro.c,260 :: 		ANSELA = 0;                                                                //Configura PORTA como digital     *
	CLR	ANSELA
;NodoAcelerometro.c,261 :: 		ANSELB = 0;                                                                //Configura PORTB como digital     *
	CLR	ANSELB
;NodoAcelerometro.c,262 :: 		TEST_Direction = 0;                                                        //TEST
	BCLR	TRISA2_bit, BitPos(TRISA2_bit+0)
;NodoAcelerometro.c,263 :: 		CsADXL_Direction = 0;                                                      //CS ADXL
	BCLR	TRISA3_bit, BitPos(TRISA3_bit+0)
;NodoAcelerometro.c,264 :: 		sd_CS_tris = 0;                                                            //CS SD
	BCLR	TRISB0_bit, BitPos(TRISB0_bit+0)
;NodoAcelerometro.c,265 :: 		MSRS485_Direction = 0;                                                     //MAX485 MS
	BCLR	TRISB12_bit, BitPos(TRISB12_bit+0)
;NodoAcelerometro.c,266 :: 		sd_detect_tris = 1;                                                        //Pin detection SD
	BSET	TRISA4_bit, BitPos(TRISA4_bit+0)
;NodoAcelerometro.c,268 :: 		TRISB13_bit = 1;                                                           //Pin de interrupcion V2
	BSET	TRISB13_bit, BitPos(TRISB13_bit+0)
;NodoAcelerometro.c,271 :: 		INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales
	BSET	INTCON2, #15
;NodoAcelerometro.c,274 :: 		RPINR18bits.U1RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx1
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
;NodoAcelerometro.c,275 :: 		RPOR1bits.RP36R = 0x01;                                                    //Configura el Tx1 en el pin RB4/RP36
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
;NodoAcelerometro.c,276 :: 		U1RXIE_bit = 1;                                                            //Activa la interrupcion por UART1 RX
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;NodoAcelerometro.c,277 :: 		U1STAbits.URXISEL = 0x00;                                                  //Interrupt is set when any character is received and transferred from the UxRSR to the receive buffer; receive buffer has one or more characters
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,278 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;NodoAcelerometro.c,279 :: 		IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#16384, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;NodoAcelerometro.c,280 :: 		UART1_Init_Advanced(2000000, _UART_8BIT_NOPARITY, _UART_ONE_STOPBIT, _UART_HI_SPEED);                            //Inicializa el UART1 con una velocidad de 2Mbps
	CLR	W13
	CLR	W12
	MOV	#33920, W10
	MOV	#30, W11
	MOV	#1, W0
	PUSH	W0
	CALL	_UART1_Init_Advanced
	SUB	#2, W15
;NodoAcelerometro.c,283 :: 		RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
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
;NodoAcelerometro.c,284 :: 		RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
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
;NodoAcelerometro.c,285 :: 		RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
	MOV	#2304, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR1bits
;NodoAcelerometro.c,286 :: 		SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
	BSET	SPI2STAT, #15
;NodoAcelerometro.c,287 :: 		SPI2_Init();                                                               //Inicializa el modulo SPI2
	CALL	_SPI2_Init
;NodoAcelerometro.c,291 :: 		RPINR0 = 0x2D00;                                                           //Asigna INT1 al RB14/RPI46 V2
	MOV	#11520, W0
	MOV	WREG, RPINR0
;NodoAcelerometro.c,292 :: 		INT1IE_bit = 1;                                                            //Interrupcion externa INT1
	BSET	INT1IE_bit, BitPos(INT1IE_bit+0)
;NodoAcelerometro.c,293 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;NodoAcelerometro.c,294 :: 		IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,297 :: 		T1CON = 0x0020;
	MOV	#32, W0
	MOV	WREG, T1CON
;NodoAcelerometro.c,298 :: 		T1CON.TON = 0;                                                             //Apaga el Timer1
	BCLR	T1CON, #15
;NodoAcelerometro.c,299 :: 		T1IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR1
	BSET	T1IE_bit, BitPos(T1IE_bit+0)
;NodoAcelerometro.c,300 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR1
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;NodoAcelerometro.c,301 :: 		PR1 = 62500;                                                               //Car ga el preload para un tiempo de 100ms
	MOV	#62500, W0
	MOV	WREG, PR1
;NodoAcelerometro.c,302 :: 		IPC0bits.T1IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR1
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;NodoAcelerometro.c,305 :: 		T2CON = 0x0020;
	MOV	#32, W0
	MOV	WREG, T2CON
;NodoAcelerometro.c,306 :: 		T2CON.TON = 0;                                                             //Apaga el Timer2
	BCLR	T2CON, #15
;NodoAcelerometro.c,307 :: 		T2IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR2
	BSET	T2IE_bit, BitPos(T2IE_bit+0)
;NodoAcelerometro.c,308 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR2
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;NodoAcelerometro.c,309 :: 		PR2 = 62500;                                                               //Carga el preload para un tiempo de 100ms
	MOV	#62500, W0
	MOV	WREG, PR2
;NodoAcelerometro.c,310 :: 		IPC1bits.T2IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR2
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC1bits
;NodoAcelerometro.c,313 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|STANDBY);                           //Coloco el ADXL en modo STANDBY para pausar las conversiones y limpiar el FIFO
	MOV.B	#5, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;NodoAcelerometro.c,316 :: 		sdflags.detected = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #1
;NodoAcelerometro.c,317 :: 		sdflags.init_ok = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #0
;NodoAcelerometro.c,318 :: 		sdflags.saving = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #2
;NodoAcelerometro.c,320 :: 		Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#25, W8
	MOV	#27150, W7
L_ConfiguracionPrincipal80:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal80
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal80
	NOP
;NodoAcelerometro.c,322 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_Muestrear:

;NodoAcelerometro.c,327 :: 		void Muestrear(){
;NodoAcelerometro.c,329 :: 		if (banCiclo==0){
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__Muestrear431
	GOTO	L_Muestrear82
L__Muestrear431:
;NodoAcelerometro.c,331 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|MEASURING);                     //Coloca el ADXL en modo medicion
	MOV.B	#4, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;NodoAcelerometro.c,332 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,334 :: 		} else if (banCiclo==1) {
	GOTO	L_Muestrear83
L_Muestrear82:
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Muestrear432
	GOTO	L_Muestrear84
L__Muestrear432:
;NodoAcelerometro.c,336 :: 		banCiclo = 2;                                                          //Limpia la bandera de ciclo completo
	MOV	#lo_addr(_banCiclo), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,338 :: 		tramaAceleracion[0] = contCiclos;                                      //LLena el primer elemento de la tramaCompleta con el contador de ciclos
	MOV	#lo_addr(_tramaAceleracion), W1
	MOV	#lo_addr(_contCiclos), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,339 :: 		numFIFO = ADXL355_read_byte(FIFO_ENTRIES);
	MOV.B	#5, W10
	CALL	_ADXL355_read_byte
	MOV	#lo_addr(_numFIFO), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,340 :: 		numSetsFIFO = (numFIFO)/3;                                             //Lee el numero de sets disponibles en el FIFO
	ZE	W0, W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(_numSetsFIFO), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,343 :: 		for (x=0;x<numSetsFIFO;x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear85:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Muestrear433
	GOTO	L_Muestrear86
L__Muestrear433:
;NodoAcelerometro.c,344 :: 		ADXL355_read_FIFO(datosLeidos);                                    //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,345 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Muestrear88:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Muestrear434
	GOTO	L_Muestrear89
L__Muestrear434:
;NodoAcelerometro.c,346 :: 		datosFIFO[y+(x*9)] = datosLeidos[y];                           //LLena la trama datosFIFO
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
;NodoAcelerometro.c,345 :: 		for (y=0;y<9;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,347 :: 		}
	GOTO	L_Muestrear88
L_Muestrear89:
;NodoAcelerometro.c,343 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,348 :: 		}
	GOTO	L_Muestrear85
L_Muestrear86:
;NodoAcelerometro.c,351 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear91:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Muestrear435
	GOTO	L_Muestrear92
L__Muestrear435:
;NodoAcelerometro.c,352 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Muestrear436
	GOTO	L__Muestrear345
L__Muestrear436:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Muestrear437
	GOTO	L__Muestrear344
L__Muestrear437:
	GOTO	L_Muestrear96
L__Muestrear345:
L__Muestrear344:
;NodoAcelerometro.c,353 :: 		tramaAceleracion[contFIFO+contMuestras+x] = contMuestras;          //Funciona bien
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
;NodoAcelerometro.c,354 :: 		tramaAceleracion[contFIFO+contMuestras+x+1] = datosFIFO[x];
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
;NodoAcelerometro.c,355 :: 		contMuestras++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contMuestras), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,356 :: 		} else {
	GOTO	L_Muestrear97
L_Muestrear96:
;NodoAcelerometro.c,357 :: 		tramaAceleracion[contFIFO+contMuestras+x] = datosFIFO[x];
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
;NodoAcelerometro.c,358 :: 		}
L_Muestrear97:
;NodoAcelerometro.c,351 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,359 :: 		}
	GOTO	L_Muestrear91
L_Muestrear92:
;NodoAcelerometro.c,361 :: 		contMuestras = 0;                                                      //Limpia el contador de muestras
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,362 :: 		contFIFO = 0;                                                          //Limpia el contador de FIFOs
	CLR	W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,363 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,366 :: 		GuardarTramaSD(tiempo, tramaAceleracion);
	MOV	#lo_addr(_tramaAceleracion), W11
	MOV	#lo_addr(_tiempo), W10
	CALL	_GuardarTramaSD
;NodoAcelerometro.c,369 :: 		if (banInsSec==1){
	MOV	#lo_addr(_banInsSec), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Muestrear438
	GOTO	L_Muestrear98
L__Muestrear438:
;NodoAcelerometro.c,370 :: 		InspeccionarSector(1, sectorReq);
	MOV	_sectorReq, W11
	MOV	_sectorReq+2, W12
	MOV.B	#1, W10
	CALL	_InspeccionarSector
;NodoAcelerometro.c,371 :: 		}
L_Muestrear98:
;NodoAcelerometro.c,373 :: 		}
L_Muestrear84:
L_Muestrear83:
;NodoAcelerometro.c,375 :: 		contCiclos++;                                                              //Incrementa el contador de ciclos
	MOV.B	#1, W1
	MOV	#lo_addr(_contCiclos), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,377 :: 		}
L_end_Muestrear:
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _Muestrear

_GuardarBufferSD:

;NodoAcelerometro.c,382 :: 		void GuardarBufferSD(unsigned char* bufferLleno, unsigned long sector){
;NodoAcelerometro.c,384 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarBufferSD99:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__GuardarBufferSD440
	GOTO	L_GuardarBufferSD100
L__GuardarBufferSD440:
;NodoAcelerometro.c,385 :: 		checkEscSD = SD_Write_Block(bufferLleno,sector);
	PUSH	W11
	PUSH	W12
	PUSH	W10
	CALL	_SD_Write_Block
	POP	W10
	POP	W12
	POP	W11
	MOV	#lo_addr(_checkEscSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,386 :: 		if (checkEscSD == DATA_ACCEPTED){
	CP.B	W0, #22
	BRA Z	L__GuardarBufferSD441
	GOTO	L_GuardarBufferSD102
L__GuardarBufferSD441:
;NodoAcelerometro.c,387 :: 		break;
	GOTO	L_GuardarBufferSD100
;NodoAcelerometro.c,388 :: 		}
L_GuardarBufferSD102:
;NodoAcelerometro.c,389 :: 		Delay_us(10);
	MOV	#80, W7
L_GuardarBufferSD103:
	DEC	W7
	BRA NZ	L_GuardarBufferSD103
	NOP
	NOP
;NodoAcelerometro.c,384 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,390 :: 		}
	GOTO	L_GuardarBufferSD99
L_GuardarBufferSD100:
;NodoAcelerometro.c,391 :: 		}
L_end_GuardarBufferSD:
	RETURN
; end of _GuardarBufferSD

_GuardarTramaSD:

;NodoAcelerometro.c,396 :: 		void GuardarTramaSD(unsigned char* tiempoSD, unsigned char* aceleracionSD){
;NodoAcelerometro.c,403 :: 		for (x=0;x<6;x++){
	PUSH	W12
	PUSH	W13
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD105:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarTramaSD443
	GOTO	L_GuardarTramaSD106
L__GuardarTramaSD443:
;NodoAcelerometro.c,404 :: 		bufferSD[x] = cabeceraSD[x];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_cabeceraSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,403 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,405 :: 		}
	GOTO	L_GuardarTramaSD105
L_GuardarTramaSD106:
;NodoAcelerometro.c,407 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD108:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarTramaSD444
	GOTO	L_GuardarTramaSD109
L__GuardarTramaSD444:
;NodoAcelerometro.c,408 :: 		bufferSD[6+x] = tiempoSD[x];
	MOV	_x, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W10, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,407 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,409 :: 		}
	GOTO	L_GuardarTramaSD108
L_GuardarTramaSD109:
;NodoAcelerometro.c,411 :: 		for (x=0;x<500;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD111:
	MOV	_x, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD445
	GOTO	L_GuardarTramaSD112
L__GuardarTramaSD445:
;NodoAcelerometro.c,412 :: 		bufferSD[12+x] = aceleracionSD[x];
	MOV	_x, W0
	ADD	W0, #12, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W11, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,411 :: 		for (x=0;x<500;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,413 :: 		}
	GOTO	L_GuardarTramaSD111
L_GuardarTramaSD112:
;NodoAcelerometro.c,415 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,417 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,420 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD114:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD446
	GOTO	L_GuardarTramaSD115
L__GuardarTramaSD446:
;NodoAcelerometro.c,421 :: 		bufferSD[x] = aceleracionSD[x+500];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#500, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,420 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,422 :: 		}
	GOTO	L_GuardarTramaSD114
L_GuardarTramaSD115:
;NodoAcelerometro.c,423 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,424 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,427 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD117:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD447
	GOTO	L_GuardarTramaSD118
L__GuardarTramaSD447:
;NodoAcelerometro.c,428 :: 		bufferSD[x] = aceleracionSD[x+1012];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1012, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,427 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,429 :: 		}
	GOTO	L_GuardarTramaSD117
L_GuardarTramaSD118:
;NodoAcelerometro.c,430 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,431 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,434 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD120:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD448
	GOTO	L_GuardarTramaSD121
L__GuardarTramaSD448:
;NodoAcelerometro.c,435 :: 		bufferSD[x] = aceleracionSD[x+1524];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1524, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,434 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,436 :: 		}
	GOTO	L_GuardarTramaSD120
L_GuardarTramaSD121:
;NodoAcelerometro.c,437 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,438 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,441 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD123:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD449
	GOTO	L_GuardarTramaSD124
L__GuardarTramaSD449:
;NodoAcelerometro.c,442 :: 		if (x<464){
	MOV	_x, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD450
	GOTO	L_GuardarTramaSD126
L__GuardarTramaSD450:
;NodoAcelerometro.c,443 :: 		bufferSD[x] = aceleracionSD[x+2036];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#2036, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,444 :: 		} else {
	GOTO	L_GuardarTramaSD127
L_GuardarTramaSD126:
;NodoAcelerometro.c,445 :: 		bufferSD[x] = 0;
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,446 :: 		}
L_GuardarTramaSD127:
;NodoAcelerometro.c,441 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,447 :: 		}
	GOTO	L_GuardarTramaSD123
L_GuardarTramaSD124:
;NodoAcelerometro.c,448 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
;NodoAcelerometro.c,449 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,452 :: 		if (horaSistema%300==0){
	MOV	#300, W2
	MOV	#0, W3
	MOV	_horaSistema, W0
	MOV	_horaSistema+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W10
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__GuardarTramaSD451
	GOTO	L_GuardarTramaSD128
L__GuardarTramaSD451:
;NodoAcelerometro.c,453 :: 		GuardarInfoSector(sectorSD, infoUltimoSector);
	PUSH.D	W10
	MOV	_infoUltimoSector, W12
	MOV	_infoUltimoSector+2, W13
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarInfoSector
	POP.D	W10
;NodoAcelerometro.c,454 :: 		}
L_GuardarTramaSD128:
;NodoAcelerometro.c,456 :: 		TEST = 0;                                                               //Apaga el TEST cuando termina de gurdar la trama
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,458 :: 		}
L_end_GuardarTramaSD:
	POP	W13
	POP	W12
	RETURN
; end of _GuardarTramaSD

_GuardarInfoSector:
	LNK	#512

;NodoAcelerometro.c,463 :: 		void GuardarInfoSector(unsigned long datoSector, unsigned long localizacionSector){
;NodoAcelerometro.c,468 :: 		bufferSectores[0] = (datoSector>>24)&0xFF;                                     //MSB variable sector
	ADD	W14, #0, W5
	LSR	W11, #8, W2
	CLR	W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W5]
;NodoAcelerometro.c,469 :: 		bufferSectores[1] = (datoSector>>16)&0xFF;
	ADD	W5, #1, W4
	MOV	W11, W2
	CLR	W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W4]
;NodoAcelerometro.c,470 :: 		bufferSectores[2] = (datoSector>>8)&0xFF;
	ADD	W5, #2, W4
	LSR	W10, #8, W2
	SL	W11, #8, W3
	IOR	W2, W3, W2
	LSR	W11, #8, W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W4]
;NodoAcelerometro.c,471 :: 		bufferSectores[3] = (datoSector)&0xFF;                                         //LSD variable sector
	ADD	W5, #3, W2
	MOV	#255, W0
	MOV	#0, W1
	AND	W10, W0, W0
	MOV.B	W0, [W2]
;NodoAcelerometro.c,472 :: 		for (x=4;x<512;x++){
	MOV	#4, W0
	MOV	W0, _x
L_GuardarInfoSector129:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarInfoSector453
	GOTO	L_GuardarInfoSector130
L__GuardarInfoSector453:
;NodoAcelerometro.c,473 :: 		bufferSectores[x] = 0;                                                 //Rellena de ceros el resto del buffer
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,472 :: 		for (x=4;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,474 :: 		}
	GOTO	L_GuardarInfoSector129
L_GuardarInfoSector130:
;NodoAcelerometro.c,477 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarInfoSector132:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__GuardarInfoSector454
	GOTO	L_GuardarInfoSector133
L__GuardarInfoSector454:
;NodoAcelerometro.c,478 :: 		checkEscSD = SD_Write_Block(bufferSectores,localizacionSector);
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
;NodoAcelerometro.c,479 :: 		if (checkEscSD == DATA_ACCEPTED){
	CP.B	W0, #22
	BRA Z	L__GuardarInfoSector455
	GOTO	L_GuardarInfoSector135
L__GuardarInfoSector455:
;NodoAcelerometro.c,481 :: 		break;
	GOTO	L_GuardarInfoSector133
;NodoAcelerometro.c,482 :: 		}
L_GuardarInfoSector135:
;NodoAcelerometro.c,483 :: 		Delay_us(10);
	MOV	#80, W7
L_GuardarInfoSector136:
	DEC	W7
	BRA NZ	L_GuardarInfoSector136
	NOP
	NOP
;NodoAcelerometro.c,477 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,484 :: 		}
	GOTO	L_GuardarInfoSector132
L_GuardarInfoSector133:
;NodoAcelerometro.c,486 :: 		}
L_end_GuardarInfoSector:
	ULNK
	RETURN
; end of _GuardarInfoSector

_UbicarPrimerSectorEscrito:
	LNK	#516

;NodoAcelerometro.c,491 :: 		unsigned long UbicarPrimerSectorEscrito(){
;NodoAcelerometro.c,497 :: 		ptrPrimerSectorSD = (unsigned char *) & primerSectorSD;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#512, W0
	ADD	W14, W0, W0
; ptrPrimerSectorSD start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,499 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,501 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_UbicarPrimerSectorEscrito138:
; ptrPrimerSectorSD start address is: 6 (W3)
; ptrPrimerSectorSD end address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__UbicarPrimerSectorEscrito457
	GOTO	L_UbicarPrimerSectorEscrito139
L__UbicarPrimerSectorEscrito457:
; ptrPrimerSectorSD end address is: 6 (W3)
;NodoAcelerometro.c,503 :: 		checkLecSD = SD_Read_Block(bufferSectorInicio, infoPrimerSector);
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
;NodoAcelerometro.c,505 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__UbicarPrimerSectorEscrito458
	GOTO	L_UbicarPrimerSectorEscrito141
L__UbicarPrimerSectorEscrito458:
;NodoAcelerometro.c,507 :: 		*ptrPrimerSectorSD = bufferSectorInicio[3];                      //LSB
	ADD	W14, #0, W2
	ADD	W2, #3, W0
	MOV.B	[W0], [W3]
;NodoAcelerometro.c,508 :: 		*(ptrPrimerSectorSD+1) = bufferSectorInicio[2];
	ADD	W3, #1, W1
	ADD	W2, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,509 :: 		*(ptrPrimerSectorSD+2) = bufferSectorInicio[1];
	ADD	W3, #2, W1
	ADD	W2, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,510 :: 		*(ptrPrimerSectorSD+3) = bufferSectorInicio[0];                  //MSB
	ADD	W3, #3, W0
; ptrPrimerSectorSD end address is: 6 (W3)
	MOV.B	[W2], [W0]
;NodoAcelerometro.c,511 :: 		break;
	GOTO	L_UbicarPrimerSectorEscrito139
;NodoAcelerometro.c,513 :: 		} else {
L_UbicarPrimerSectorEscrito141:
;NodoAcelerometro.c,514 :: 		primerSectorSD = PSE;                                           //Si no pudo realizar la lectura devuelve el Primer Sector de Escritura
; ptrPrimerSectorSD start address is: 6 (W3)
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,501 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,516 :: 		}
; ptrPrimerSectorSD end address is: 6 (W3)
	GOTO	L_UbicarPrimerSectorEscrito138
L_UbicarPrimerSectorEscrito139:
;NodoAcelerometro.c,519 :: 		return primerSectorSD;
	MOV	[W14+512], W0
	MOV	[W14+514], W1
;NodoAcelerometro.c,521 :: 		}
;NodoAcelerometro.c,519 :: 		return primerSectorSD;
;NodoAcelerometro.c,521 :: 		}
L_end_UbicarPrimerSectorEscrito:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _UbicarPrimerSectorEscrito

_UbicarUltimoSectorEscrito:
	LNK	#516

;NodoAcelerometro.c,526 :: 		unsigned long UbicarUltimoSectorEscrito(unsigned short sobrescribirSD){
;NodoAcelerometro.c,532 :: 		ptrSectorInicioSD = (unsigned char *) & sectorInicioSD;
	PUSH	W11
	PUSH	W12
	MOV	#512, W0
	ADD	W14, W0, W0
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,535 :: 		if (sobrescribirSD==1){
	CP.B	W10, #1
	BRA Z	L__UbicarUltimoSectorEscrito460
	GOTO	L_UbicarUltimoSectorEscrito145
L__UbicarUltimoSectorEscrito460:
; ptrSectorInicioSD end address is: 6 (W3)
;NodoAcelerometro.c,536 :: 		sectorInicioSD = PSE;                                                  //Se escoje el PSE para sobrescribir la SD
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,537 :: 		} else {
	GOTO	L_UbicarUltimoSectorEscrito146
L_UbicarUltimoSectorEscrito145:
;NodoAcelerometro.c,538 :: 		checkLecSD = 1;
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,540 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_UbicarUltimoSectorEscrito147:
; ptrSectorInicioSD start address is: 6 (W3)
; ptrSectorInicioSD end address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__UbicarUltimoSectorEscrito461
	GOTO	L_UbicarUltimoSectorEscrito148
L__UbicarUltimoSectorEscrito461:
; ptrSectorInicioSD end address is: 6 (W3)
;NodoAcelerometro.c,542 :: 		checkLecSD = SD_Read_Block(bufferSectorFinal, infoUltimoSector);
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
;NodoAcelerometro.c,544 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__UbicarUltimoSectorEscrito462
	GOTO	L_UbicarUltimoSectorEscrito150
L__UbicarUltimoSectorEscrito462:
;NodoAcelerometro.c,546 :: 		*ptrSectorInicioSD = bufferSectorFinal[3];                      //LSB
	ADD	W14, #0, W2
	ADD	W2, #3, W0
	MOV.B	[W0], [W3]
;NodoAcelerometro.c,547 :: 		*(ptrSectorInicioSD+1) = bufferSectorFinal[2];
	ADD	W3, #1, W1
	ADD	W2, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,548 :: 		*(ptrSectorInicioSD+2) = bufferSectorFinal[1];
	ADD	W3, #2, W1
	ADD	W2, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,549 :: 		*(ptrSectorInicioSD+3) = bufferSectorFinal[0];                  //MSB
	ADD	W3, #3, W0
; ptrSectorInicioSD end address is: 6 (W3)
	MOV.B	[W2], [W0]
;NodoAcelerometro.c,550 :: 		break;
	GOTO	L_UbicarUltimoSectorEscrito148
;NodoAcelerometro.c,552 :: 		} else {
L_UbicarUltimoSectorEscrito150:
;NodoAcelerometro.c,553 :: 		sectorInicioSD = PSE;                                           //Si no pudo realizar la lectura procede a sobreescribir la SD
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,540 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,555 :: 		}
; ptrSectorInicioSD end address is: 6 (W3)
	GOTO	L_UbicarUltimoSectorEscrito147
L_UbicarUltimoSectorEscrito148:
;NodoAcelerometro.c,556 :: 		}
L_UbicarUltimoSectorEscrito146:
;NodoAcelerometro.c,558 :: 		return sectorInicioSD;
	MOV	[W14+512], W0
	MOV	[W14+514], W1
;NodoAcelerometro.c,560 :: 		}
;NodoAcelerometro.c,558 :: 		return sectorInicioSD;
;NodoAcelerometro.c,560 :: 		}
L_end_UbicarUltimoSectorEscrito:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _UbicarUltimoSectorEscrito

_InformacionSectores:
	LNK	#36

;NodoAcelerometro.c,565 :: 		void InformacionSectores(){
;NodoAcelerometro.c,579 :: 		infoPSF = PSF;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	_PSF, W0
	MOV	_PSF+2, W1
	MOV	W0, [W14+20]
	MOV	W1, [W14+22]
;NodoAcelerometro.c,580 :: 		infoPSE = PSE;
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+24]
	MOV	W1, [W14+26]
;NodoAcelerometro.c,583 :: 		ptrPSF = (unsigned char *) & infoPSF;
	ADD	W14, #20, W0
; ptrPSF start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,584 :: 		ptrPSE = (unsigned char *) & infoPSE;
	ADD	W14, #24, W0
; ptrPSE start address is: 8 (W4)
	MOV	W0, W4
;NodoAcelerometro.c,585 :: 		ptrPSEC = (unsigned char *) & infoPSEC;
	ADD	W14, #28, W0
; ptrPSEC start address is: 10 (W5)
	MOV	W0, W5
;NodoAcelerometro.c,586 :: 		ptrSA = (unsigned char *) & infoSA;
	MOV	#32, W0
	ADD	W14, W0, W0
; ptrSA start address is: 12 (W6)
	MOV	W0, W6
;NodoAcelerometro.c,589 :: 		if (banInicioMuestreo==0){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__InformacionSectores464
	GOTO	L_InformacionSectores154
L__InformacionSectores464:
;NodoAcelerometro.c,590 :: 		infoPSEC = UbicarPrimerSectorEscrito();                                 //Calcula el primer sector escrito
	PUSH	W6
	PUSH.D	W4
	PUSH	W3
	CALL	_UbicarPrimerSectorEscrito
	MOV	W0, [W14+28]
	MOV	W1, [W14+30]
;NodoAcelerometro.c,591 :: 		infoSA = UbicarUltimoSectorEscrito(0);                                  //Calcula el ultimo sector escrito
	CLR	W10
	CALL	_UbicarUltimoSectorEscrito
	POP	W3
	POP.D	W4
	POP	W6
	MOV	W0, [W14+32]
	MOV	W1, [W14+34]
;NodoAcelerometro.c,592 :: 		} else {
	GOTO	L_InformacionSectores155
L_InformacionSectores154:
;NodoAcelerometro.c,593 :: 		infoSA = sectorSD - 1;                                                  //Retorna el sector actual menos una posicion
	MOV	_sectorSD, W1
	MOV	_sectorSD+2, W2
	MOV	#32, W0
	ADD	W14, W0, W0
	SUB	W1, #1, [W0++]
	SUBB	W2, #0, [W0--]
;NodoAcelerometro.c,594 :: 		infoPSEC = PSEC;                                                        //Retorna el primer sector escrito en este ciclo de muestreo
	MOV	_PSEC, W0
	MOV	_PSEC+2, W1
	MOV	W0, [W14+28]
	MOV	W1, [W14+30]
;NodoAcelerometro.c,595 :: 		}
L_InformacionSectores155:
;NodoAcelerometro.c,597 :: 		tramaInfoSec[0] = 0xD1;                                                    //Subfuncion
	ADD	W14, #0, W2
	MOV.B	#209, W0
	MOV.B	W0, [W2]
;NodoAcelerometro.c,598 :: 		tramaInfoSec[1] = *ptrPSF;                                                 //LSB PSF
	ADD	W2, #1, W0
	MOV.B	[W3], [W0]
;NodoAcelerometro.c,599 :: 		tramaInfoSec[2] = *(ptrPSF+1);
	ADD	W2, #2, W1
	ADD	W3, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,600 :: 		tramaInfoSec[3] = *(ptrPSF+2);
	ADD	W2, #3, W1
	ADD	W3, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,601 :: 		tramaInfoSec[4] = *(ptrPSF+3);                                             //MSB PSF
	ADD	W2, #4, W1
	ADD	W3, #3, W0
; ptrPSF end address is: 6 (W3)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,602 :: 		tramaInfoSec[5] = *ptrPSE;                                                 //LSB PSE
	ADD	W2, #5, W0
	MOV.B	[W4], [W0]
;NodoAcelerometro.c,603 :: 		tramaInfoSec[6] = *(ptrPSE+1);
	ADD	W2, #6, W1
	ADD	W4, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,604 :: 		tramaInfoSec[7] = *(ptrPSE+2);
	ADD	W2, #7, W1
	ADD	W4, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,605 :: 		tramaInfoSec[8] = *(ptrPSE+3);                                             //MSB PSE
	ADD	W2, #8, W1
	ADD	W4, #3, W0
; ptrPSE end address is: 8 (W4)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,606 :: 		tramaInfoSec[9] = *ptrPSEC;                                                //LSB PSEC
	ADD	W2, #9, W0
	MOV.B	[W5], [W0]
;NodoAcelerometro.c,607 :: 		tramaInfoSec[10] = *(ptrPSEC+1);
	ADD	W2, #10, W1
	ADD	W5, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,608 :: 		tramaInfoSec[11] = *(ptrPSEC+2);
	ADD	W2, #11, W1
	ADD	W5, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,609 :: 		tramaInfoSec[12] = *(ptrPSEC+3);                                           //MSB PSEC
	ADD	W2, #12, W1
	ADD	W5, #3, W0
; ptrPSEC end address is: 10 (W5)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,610 :: 		tramaInfoSec[13] = *ptrSA;                                                 //LSB SA
	ADD	W2, #13, W0
	MOV.B	[W6], [W0]
;NodoAcelerometro.c,611 :: 		tramaInfoSec[14] = *(ptrSA+1);
	ADD	W2, #14, W1
	ADD	W6, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,612 :: 		tramaInfoSec[15] = *(ptrSA+2);
	ADD	W2, #15, W1
	ADD	W6, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,613 :: 		tramaInfoSec[16] = *(ptrSA+3);                                             //MSB SA
	ADD	W2, #16, W1
	ADD	W6, #3, W0
; ptrSA end address is: 12 (W6)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,615 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, 17, tramaInfoSec);
	MOV	#17, W13
	MOV.B	#243, W12
	MOV.B	#2, W11
	MOV.B	#1, W10
	PUSH	W2
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;NodoAcelerometro.c,617 :: 		}
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

;NodoAcelerometro.c,622 :: 		void InspeccionarSector(unsigned short estadoMuestreo, unsigned long sectorReq){
;NodoAcelerometro.c,631 :: 		if (estadoMuestreo==0){
	PUSH	W10
	PUSH	W13
	CP.B	W10, #0
	BRA Z	L__InspeccionarSector466
	GOTO	L_InspeccionarSector156
L__InspeccionarSector466:
;NodoAcelerometro.c,632 :: 		USE = UbicarUltimoSectorEscrito(0);
	PUSH	W11
	PUSH	W12
	CLR	W10
	CALL	_UbicarUltimoSectorEscrito
	POP	W12
	POP	W11
; USE start address is: 4 (W2)
	MOV.D	W0, W2
;NodoAcelerometro.c,633 :: 		} else {
; USE end address is: 4 (W2)
	GOTO	L_InspeccionarSector157
L_InspeccionarSector156:
;NodoAcelerometro.c,634 :: 		USE = sectorSD - 1;
	MOV	_sectorSD, W0
	MOV	_sectorSD+2, W1
; USE start address is: 4 (W2)
	SUB	W0, #1, W2
	SUBB	W1, #0, W3
; USE end address is: 4 (W2)
;NodoAcelerometro.c,635 :: 		}
L_InspeccionarSector157:
;NodoAcelerometro.c,637 :: 		tramaDatosSec[0] = 0xD2;                                                   //Subfuncion
; USE start address is: 4 (W2)
	ADD	W14, #0, W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,640 :: 		if ((sectorReq>=PSE)&&(sectorReq<USF)){
	MOV	#lo_addr(_PSE), W0
	CP	W11, [W0++]
	CPB	W12, [W0--]
	BRA GEU	L__InspeccionarSector467
	GOTO	L__InspeccionarSector342
L__InspeccionarSector467:
	MOV	#lo_addr(_USF), W0
	CP	W11, [W0++]
	CPB	W12, [W0--]
	BRA LTU	L__InspeccionarSector468
	GOTO	L__InspeccionarSector341
L__InspeccionarSector468:
L__InspeccionarSector340:
;NodoAcelerometro.c,642 :: 		if (sectorReq<USE){
	CP	W11, W2
	CPB	W12, W3
	BRA LTU	L__InspeccionarSector469
	GOTO	L_InspeccionarSector161
L__InspeccionarSector469:
; USE end address is: 4 (W2)
;NodoAcelerometro.c,643 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,645 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_InspeccionarSector162:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__InspeccionarSector470
	GOTO	L_InspeccionarSector163
L__InspeccionarSector470:
;NodoAcelerometro.c,647 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, sectorReq);
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
;NodoAcelerometro.c,649 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__InspeccionarSector471
	GOTO	L_InspeccionarSector165
L__InspeccionarSector471:
;NodoAcelerometro.c,651 :: 		for (y=0;y<numDatosSec;y++){
	CLR	W0
	MOV	W0, _y
L_InspeccionarSector166:
	MOV	_y, W1
	MOV	#528, W0
	ADD	W14, W0, W0
	CP	W1, [W0]
	BRA LTU	L__InspeccionarSector472
	GOTO	L_InspeccionarSector167
L__InspeccionarSector472:
;NodoAcelerometro.c,652 :: 		tramaDatosSec[y+1] = bufferSectorReq[y];
	MOV	_y, W0
	ADD	W0, #1, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	ADD	W14, #15, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,651 :: 		for (y=0;y<numDatosSec;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,653 :: 		}
	GOTO	L_InspeccionarSector166
L_InspeccionarSector167:
;NodoAcelerometro.c,654 :: 		numDatosSec = 13;
	MOV	#13, W0
	MOV	W0, [W14+528]
;NodoAcelerometro.c,655 :: 		break;
	GOTO	L_InspeccionarSector163
;NodoAcelerometro.c,656 :: 		} else {
L_InspeccionarSector165:
;NodoAcelerometro.c,658 :: 		tramaDatosSec[1] = 0xEE;
	ADD	W14, #0, W2
	ADD	W2, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,659 :: 		tramaDatosSec[2] = 0xE3;
	ADD	W2, #2, W1
	MOV.B	#227, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,660 :: 		numDatosSec = 3;
	MOV	#3, W0
	MOV	W0, [W14+528]
;NodoAcelerometro.c,662 :: 		Delay_us(10);
	MOV	#80, W7
L_InspeccionarSector170:
	DEC	W7
	BRA NZ	L_InspeccionarSector170
	NOP
	NOP
;NodoAcelerometro.c,645 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,663 :: 		}
	GOTO	L_InspeccionarSector162
L_InspeccionarSector163:
;NodoAcelerometro.c,664 :: 		} else {
	GOTO	L_InspeccionarSector172
L_InspeccionarSector161:
;NodoAcelerometro.c,666 :: 		tramaDatosSec[1] = 0xEE;
	ADD	W14, #0, W2
	ADD	W2, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,667 :: 		tramaDatosSec[2] = 0xE2;
	ADD	W2, #2, W1
	MOV.B	#226, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,668 :: 		numDatosSec = 3;
	MOV	#3, W0
	MOV	W0, [W14+528]
;NodoAcelerometro.c,669 :: 		}
L_InspeccionarSector172:
;NodoAcelerometro.c,671 :: 		} else {
	GOTO	L_InspeccionarSector173
;NodoAcelerometro.c,640 :: 		if ((sectorReq>=PSE)&&(sectorReq<USF)){
L__InspeccionarSector342:
L__InspeccionarSector341:
;NodoAcelerometro.c,674 :: 		tramaDatosSec[1] = 0xEE;
	ADD	W14, #0, W2
	ADD	W2, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,675 :: 		tramaDatosSec[2] = 0xE1;
	ADD	W2, #2, W1
	MOV.B	#225, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,676 :: 		numDatosSec = 3;
	MOV	#3, W0
	MOV	W0, [W14+528]
;NodoAcelerometro.c,678 :: 		}
L_InspeccionarSector173:
;NodoAcelerometro.c,680 :: 		banInsSec = 0;
	MOV	#lo_addr(_banInsSec), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,681 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, numDatosSec, tramaDatosSec);
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
;NodoAcelerometro.c,683 :: 		}
L_end_InspeccionarSector:
	POP	W13
	POP	W10
	ULNK
	RETURN
; end of _InspeccionarSector

_RecuperarTramaAceleracion:
	LNK	#3028

;NodoAcelerometro.c,688 :: 		void RecuperarTramaAceleracion(unsigned long sectorReq){
;NodoAcelerometro.c,695 :: 		tramaAcelSeg[0] = 0xD3;                                                     //Subfuncion
	PUSH	W12
	PUSH	W13
	ADD	W14, #0, W1
	MOV.B	#211, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,696 :: 		contSector = 0;
; contSector start address is: 6 (W3)
	CLR	W3
	CLR	W4
;NodoAcelerometro.c,699 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,701 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion174:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion474
	GOTO	L__RecuperarTramaAceleracion346
L__RecuperarTramaAceleracion474:
;NodoAcelerometro.c,702 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	ADD	W10, W3, W1
	ADDC	W11, W4, W2
	MOV	#2510, W0
	ADD	W14, W0, W0
	PUSH	W3
	PUSH	W4
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	POP	W4
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,703 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion475
	GOTO	L_RecuperarTramaAceleracion177
L__RecuperarTramaAceleracion475:
;NodoAcelerometro.c,705 :: 		for (y=0;y<6;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion178:
; contSector start address is: 6 (W3)
	MOV	_y, W0
	CP	W0, #6
	BRA LTU	L__RecuperarTramaAceleracion476
	GOTO	L_RecuperarTramaAceleracion179
L__RecuperarTramaAceleracion476:
;NodoAcelerometro.c,706 :: 		tiempoAcel[y] = bufferSectorReq[y+6];
	MOV	#3022, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W2
	MOV	_y, W0
	ADD	W0, #6, W1
	MOV	#2510, W0
	ADD	W14, W0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,705 :: 		for (y=0;y<6;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,707 :: 		}
	GOTO	L_RecuperarTramaAceleracion178
L_RecuperarTramaAceleracion179:
;NodoAcelerometro.c,709 :: 		for (y=0;y<500;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion181:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion477
	GOTO	L_RecuperarTramaAceleracion182
L__RecuperarTramaAceleracion477:
;NodoAcelerometro.c,710 :: 		tramaAcelSeg[y+1] = bufferSectorReq[y+12];
	MOV	_y, W0
	ADD	W0, #1, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	_y, W0
	ADD	W0, #12, W1
	MOV	#2510, W0
	ADD	W14, W0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,709 :: 		for (y=0;y<500;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,711 :: 		}
	GOTO	L_RecuperarTramaAceleracion181
L_RecuperarTramaAceleracion182:
;NodoAcelerometro.c,712 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,713 :: 		break;
	GOTO	L_RecuperarTramaAceleracion175
;NodoAcelerometro.c,714 :: 		}
L_RecuperarTramaAceleracion177:
;NodoAcelerometro.c,715 :: 		Delay_us(10);
	MOV	#80, W7
L_RecuperarTramaAceleracion184:
	DEC	W7
	BRA NZ	L_RecuperarTramaAceleracion184
	NOP
	NOP
;NodoAcelerometro.c,701 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,716 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion174
L__RecuperarTramaAceleracion346:
;NodoAcelerometro.c,701 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,716 :: 		}
L_RecuperarTramaAceleracion175:
;NodoAcelerometro.c,719 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,721 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion186:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion478
	GOTO	L__RecuperarTramaAceleracion347
L__RecuperarTramaAceleracion478:
;NodoAcelerometro.c,722 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	ADD	W10, W3, W1
	ADDC	W11, W4, W2
	MOV	#2510, W0
	ADD	W14, W0, W0
	PUSH	W3
	PUSH	W4
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	POP	W4
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,723 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion479
	GOTO	L_RecuperarTramaAceleracion189
L__RecuperarTramaAceleracion479:
;NodoAcelerometro.c,725 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion190:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion480
	GOTO	L_RecuperarTramaAceleracion191
L__RecuperarTramaAceleracion480:
;NodoAcelerometro.c,726 :: 		tramaAcelSeg[y+501] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#501, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	#2510, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,725 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,727 :: 		}
	GOTO	L_RecuperarTramaAceleracion190
L_RecuperarTramaAceleracion191:
;NodoAcelerometro.c,728 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,729 :: 		break;
	GOTO	L_RecuperarTramaAceleracion187
;NodoAcelerometro.c,730 :: 		}
L_RecuperarTramaAceleracion189:
;NodoAcelerometro.c,731 :: 		Delay_us(10);
	MOV	#80, W7
L_RecuperarTramaAceleracion193:
	DEC	W7
	BRA NZ	L_RecuperarTramaAceleracion193
	NOP
	NOP
;NodoAcelerometro.c,721 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,732 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion186
L__RecuperarTramaAceleracion347:
;NodoAcelerometro.c,721 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,732 :: 		}
L_RecuperarTramaAceleracion187:
;NodoAcelerometro.c,735 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,737 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion195:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion481
	GOTO	L__RecuperarTramaAceleracion348
L__RecuperarTramaAceleracion481:
;NodoAcelerometro.c,738 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	ADD	W10, W3, W1
	ADDC	W11, W4, W2
	MOV	#2510, W0
	ADD	W14, W0, W0
	PUSH	W3
	PUSH	W4
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	POP	W4
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,739 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion482
	GOTO	L_RecuperarTramaAceleracion198
L__RecuperarTramaAceleracion482:
;NodoAcelerometro.c,741 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion199:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion483
	GOTO	L_RecuperarTramaAceleracion200
L__RecuperarTramaAceleracion483:
;NodoAcelerometro.c,742 :: 		tramaAcelSeg[y+1013] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#1013, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	#2510, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,741 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,743 :: 		}
	GOTO	L_RecuperarTramaAceleracion199
L_RecuperarTramaAceleracion200:
;NodoAcelerometro.c,744 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,745 :: 		break;
	GOTO	L_RecuperarTramaAceleracion196
;NodoAcelerometro.c,746 :: 		}
L_RecuperarTramaAceleracion198:
;NodoAcelerometro.c,747 :: 		Delay_us(10);
	MOV	#80, W7
L_RecuperarTramaAceleracion202:
	DEC	W7
	BRA NZ	L_RecuperarTramaAceleracion202
	NOP
	NOP
;NodoAcelerometro.c,737 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,748 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion195
L__RecuperarTramaAceleracion348:
;NodoAcelerometro.c,737 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,748 :: 		}
L_RecuperarTramaAceleracion196:
;NodoAcelerometro.c,751 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,753 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion204:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion484
	GOTO	L__RecuperarTramaAceleracion349
L__RecuperarTramaAceleracion484:
;NodoAcelerometro.c,754 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	ADD	W10, W3, W1
	ADDC	W11, W4, W2
	MOV	#2510, W0
	ADD	W14, W0, W0
	PUSH	W3
	PUSH	W4
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	POP	W4
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,755 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion485
	GOTO	L_RecuperarTramaAceleracion207
L__RecuperarTramaAceleracion485:
;NodoAcelerometro.c,757 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion208:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion486
	GOTO	L_RecuperarTramaAceleracion209
L__RecuperarTramaAceleracion486:
;NodoAcelerometro.c,758 :: 		tramaAcelSeg[y+1525] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#1525, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	#2510, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,757 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,759 :: 		}
	GOTO	L_RecuperarTramaAceleracion208
L_RecuperarTramaAceleracion209:
;NodoAcelerometro.c,760 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,761 :: 		break;
	GOTO	L_RecuperarTramaAceleracion205
;NodoAcelerometro.c,762 :: 		}
L_RecuperarTramaAceleracion207:
;NodoAcelerometro.c,763 :: 		Delay_us(10);
	MOV	#80, W7
L_RecuperarTramaAceleracion211:
	DEC	W7
	BRA NZ	L_RecuperarTramaAceleracion211
	NOP
	NOP
;NodoAcelerometro.c,753 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,764 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion204
L__RecuperarTramaAceleracion349:
;NodoAcelerometro.c,753 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,764 :: 		}
L_RecuperarTramaAceleracion205:
;NodoAcelerometro.c,767 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,769 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion213:
; contSector start address is: 6 (W3)
; contSector end address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion487
	GOTO	L_RecuperarTramaAceleracion214
L__RecuperarTramaAceleracion487:
; contSector end address is: 6 (W3)
;NodoAcelerometro.c,770 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
; contSector start address is: 6 (W3)
	ADD	W10, W3, W1
	ADDC	W11, W4, W2
	MOV	#2510, W0
	ADD	W14, W0, W0
	PUSH	W3
	PUSH	W4
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	POP	W4
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,771 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion488
	GOTO	L_RecuperarTramaAceleracion216
L__RecuperarTramaAceleracion488:
; contSector end address is: 6 (W3)
;NodoAcelerometro.c,773 :: 		for (y=0;y<464;y++){
	CLR	W0
	MOV	W0, _y
L_RecuperarTramaAceleracion217:
	MOV	_y, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion489
	GOTO	L_RecuperarTramaAceleracion218
L__RecuperarTramaAceleracion489:
;NodoAcelerometro.c,774 :: 		tramaAcelSeg[y+2037] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#2037, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	#2510, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,773 :: 		for (y=0;y<464;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,775 :: 		}
	GOTO	L_RecuperarTramaAceleracion217
L_RecuperarTramaAceleracion218:
;NodoAcelerometro.c,777 :: 		break;
	GOTO	L_RecuperarTramaAceleracion214
;NodoAcelerometro.c,778 :: 		}
L_RecuperarTramaAceleracion216:
;NodoAcelerometro.c,779 :: 		Delay_us(10);
; contSector start address is: 6 (W3)
	MOV	#80, W7
L_RecuperarTramaAceleracion220:
	DEC	W7
	BRA NZ	L_RecuperarTramaAceleracion220
	NOP
	NOP
;NodoAcelerometro.c,769 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,780 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion213
L_RecuperarTramaAceleracion214:
;NodoAcelerometro.c,783 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion222:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__RecuperarTramaAceleracion490
	GOTO	L_RecuperarTramaAceleracion223
L__RecuperarTramaAceleracion490:
;NodoAcelerometro.c,784 :: 		tramaAcelSeg[2501+x] = tiempoAcel[x];
	MOV	#2501, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	ADD	W14, #0, W0
	ADD	W0, W1, W2
	MOV	#3022, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,783 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,785 :: 		}
	GOTO	L_RecuperarTramaAceleracion222
L_RecuperarTramaAceleracion223:
;NodoAcelerometro.c,788 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, 2507, tramaAcelSeg);
	ADD	W14, #0, W0
	PUSH.D	W10
	MOV	#2507, W13
	MOV.B	#243, W12
	MOV.B	#2, W11
	MOV.B	#1, W10
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
	POP.D	W10
;NodoAcelerometro.c,790 :: 		}
L_end_RecuperarTramaAceleracion:
	POP	W13
	POP	W12
	ULNK
	RETURN
; end of _RecuperarTramaAceleracion

_GuardarPruebaSD:
	LNK	#2506

;NodoAcelerometro.c,795 :: 		void GuardarPruebaSD(unsigned char* tiempoSD){
;NodoAcelerometro.c,804 :: 		contadorEjemploSD = 0;
	PUSH	W11
	PUSH	W12
	PUSH	W13
; contadorEjemploSD start address is: 4 (W2)
	CLR	W2
;NodoAcelerometro.c,805 :: 		for (x=0;x<2500;x++){
	CLR	W0
	MOV	W0, _x
; contadorEjemploSD end address is: 4 (W2)
L_GuardarPruebaSD225:
; contadorEjemploSD start address is: 4 (W2)
	MOV	_x, W1
	MOV	#2500, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD492
	GOTO	L_GuardarPruebaSD226
L__GuardarPruebaSD492:
;NodoAcelerometro.c,806 :: 		aceleracionSD[x] = contadorEjemploSD;
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
;NodoAcelerometro.c,807 :: 		contadorEjemploSD ++;
	ADD.B	W2, #1, W1
	MOV.B	W1, W2
;NodoAcelerometro.c,808 :: 		if (contadorEjemploSD >= 255){
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA GEU	L__GuardarPruebaSD493
	GOTO	L__GuardarPruebaSD350
L__GuardarPruebaSD493:
;NodoAcelerometro.c,809 :: 		contadorEjemploSD = 0;
	CLR	W2
; contadorEjemploSD end address is: 4 (W2)
;NodoAcelerometro.c,810 :: 		}
	GOTO	L_GuardarPruebaSD228
L__GuardarPruebaSD350:
;NodoAcelerometro.c,808 :: 		if (contadorEjemploSD >= 255){
;NodoAcelerometro.c,810 :: 		}
L_GuardarPruebaSD228:
;NodoAcelerometro.c,805 :: 		for (x=0;x<2500;x++){
; contadorEjemploSD start address is: 4 (W2)
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,811 :: 		}
; contadorEjemploSD end address is: 4 (W2)
	GOTO	L_GuardarPruebaSD225
L_GuardarPruebaSD226:
;NodoAcelerometro.c,814 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD229:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarPruebaSD494
	GOTO	L_GuardarPruebaSD230
L__GuardarPruebaSD494:
;NodoAcelerometro.c,815 :: 		bufferSD[x] = cabeceraSD[x];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_cabeceraSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,814 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,816 :: 		}
	GOTO	L_GuardarPruebaSD229
L_GuardarPruebaSD230:
;NodoAcelerometro.c,818 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD232:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarPruebaSD495
	GOTO	L_GuardarPruebaSD233
L__GuardarPruebaSD495:
;NodoAcelerometro.c,819 :: 		bufferSD[6+x] = tiempoSD[x];
	MOV	_x, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W10, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,818 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,820 :: 		}
	GOTO	L_GuardarPruebaSD232
L_GuardarPruebaSD233:
;NodoAcelerometro.c,822 :: 		for (x=0;x<500;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD235:
	MOV	_x, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD496
	GOTO	L_GuardarPruebaSD236
L__GuardarPruebaSD496:
;NodoAcelerometro.c,823 :: 		bufferSD[12+x] = aceleracionSD[x];
	MOV	_x, W0
	ADD	W0, #12, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,822 :: 		for (x=0;x<500;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,824 :: 		}
	GOTO	L_GuardarPruebaSD235
L_GuardarPruebaSD236:
;NodoAcelerometro.c,826 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,828 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,831 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD238:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD497
	GOTO	L_GuardarPruebaSD239
L__GuardarPruebaSD497:
;NodoAcelerometro.c,832 :: 		bufferSD[x] = aceleracionSD[x+500];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#500, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,831 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,833 :: 		}
	GOTO	L_GuardarPruebaSD238
L_GuardarPruebaSD239:
;NodoAcelerometro.c,834 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,835 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,838 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD241:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD498
	GOTO	L_GuardarPruebaSD242
L__GuardarPruebaSD498:
;NodoAcelerometro.c,839 :: 		bufferSD[x] = aceleracionSD[x+1012];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1012, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,838 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,840 :: 		}
	GOTO	L_GuardarPruebaSD241
L_GuardarPruebaSD242:
;NodoAcelerometro.c,841 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,842 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,845 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD244:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD499
	GOTO	L_GuardarPruebaSD245
L__GuardarPruebaSD499:
;NodoAcelerometro.c,846 :: 		bufferSD[x] = aceleracionSD[x+1524];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1524, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,845 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,847 :: 		}
	GOTO	L_GuardarPruebaSD244
L_GuardarPruebaSD245:
;NodoAcelerometro.c,848 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,849 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,852 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD247:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD500
	GOTO	L_GuardarPruebaSD248
L__GuardarPruebaSD500:
;NodoAcelerometro.c,853 :: 		if (x<464){
	MOV	_x, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD501
	GOTO	L_GuardarPruebaSD250
L__GuardarPruebaSD501:
;NodoAcelerometro.c,854 :: 		bufferSD[x] = aceleracionSD[x+2036];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#2036, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,855 :: 		} else {
	GOTO	L_GuardarPruebaSD251
L_GuardarPruebaSD250:
;NodoAcelerometro.c,856 :: 		bufferSD[x] = 0;
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,857 :: 		}
L_GuardarPruebaSD251:
;NodoAcelerometro.c,852 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,858 :: 		}
	GOTO	L_GuardarPruebaSD247
L_GuardarPruebaSD248:
;NodoAcelerometro.c,859 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
;NodoAcelerometro.c,860 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,863 :: 		if (horaSistema%300==0){
	MOV	#300, W2
	MOV	#0, W3
	MOV	_horaSistema, W0
	MOV	_horaSistema+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	POP	W10
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__GuardarPruebaSD502
	GOTO	L_GuardarPruebaSD252
L__GuardarPruebaSD502:
;NodoAcelerometro.c,864 :: 		GuardarInfoSector(sectorSD, infoUltimoSector);
	PUSH	W10
	MOV	_infoUltimoSector, W12
	MOV	_infoUltimoSector+2, W13
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarInfoSector
	POP	W10
;NodoAcelerometro.c,865 :: 		}
L_GuardarPruebaSD252:
;NodoAcelerometro.c,867 :: 		TEST = 0;                                                               //Apaga el TEST cuando termina de gurdar la trama
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,869 :: 		}
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

;NodoAcelerometro.c,880 :: 		void int_1() org IVT_ADDR_INT1INTERRUPT {
;NodoAcelerometro.c,882 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;NodoAcelerometro.c,885 :: 		if ((horaSistema==0)&&(banInicioMuestreo==1)){
	MOV	_horaSistema, W0
	MOV	_horaSistema+2, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__int_1504
	GOTO	L__int_1353
L__int_1504:
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1505
	GOTO	L__int_1352
L__int_1505:
L__int_1351:
;NodoAcelerometro.c,886 :: 		PSEC = sectorSD;
	MOV	_sectorSD, W0
	MOV	_sectorSD+2, W1
	MOV	W0, _PSEC
	MOV	W1, _PSEC+2
;NodoAcelerometro.c,887 :: 		GuardarInfoSector(PSEC, infoPrimerSector);
	MOV	_infoPrimerSector, W12
	MOV	_infoPrimerSector+2, W13
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarInfoSector
;NodoAcelerometro.c,885 :: 		if ((horaSistema==0)&&(banInicioMuestreo==1)){
L__int_1353:
L__int_1352:
;NodoAcelerometro.c,890 :: 		if (banSetReloj==1){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1506
	GOTO	L_int_1256
L__int_1506:
;NodoAcelerometro.c,891 :: 		horaSistema++;                                                          //Incrementa el reloj del sistema
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaSistema), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,892 :: 		if (horaSistema==86400){                                                //(24*3600)+(0*60)+(0) = 86400
	MOV	_horaSistema, W2
	MOV	_horaSistema+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__int_1507
	GOTO	L_int_1257
L__int_1507:
;NodoAcelerometro.c,893 :: 		horaSistema = 0;                                                     //Reinicia el reloj al llegar a las 24:00:00 horas
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,894 :: 		fechaSistema = IncrementarFecha(fechaSistema);                       //Incrementa la fecha del sistema
	MOV	_fechaSistema, W10
	MOV	_fechaSistema+2, W11
	CALL	_IncrementarFecha
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,895 :: 		}
L_int_1257:
;NodoAcelerometro.c,896 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza la trama de tiempo
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;NodoAcelerometro.c,897 :: 		TEST = ~TEST;
	BTG	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,898 :: 		}
L_int_1256:
;NodoAcelerometro.c,900 :: 		if (banInicioMuestreo==1){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1508
	GOTO	L_int_1258
L__int_1508:
;NodoAcelerometro.c,901 :: 		Muestrear();                                                          //Inicia el muestreo
	CALL	_Muestrear
;NodoAcelerometro.c,903 :: 		}
L_int_1258:
;NodoAcelerometro.c,905 :: 		}
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

;NodoAcelerometro.c,910 :: 		void Timer1Int() org IVT_ADDR_T1INTERRUPT{
;NodoAcelerometro.c,912 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer1
	PUSH	W10
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;NodoAcelerometro.c,914 :: 		numFIFO = ADXL355_read_byte(FIFO_ENTRIES); //75                            //Lee el numero de muestras disponibles en el FIFO
	MOV.B	#5, W10
	CALL	_ADXL355_read_byte
	MOV	#lo_addr(_numFIFO), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,915 :: 		numSetsFIFO = (numFIFO)/3;                 //25                            //Lee el numero de sets disponibles en el FIFO
	ZE	W0, W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(_numSetsFIFO), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,918 :: 		for (x=0;x<numSetsFIFO;x++){
	CLR	W0
	MOV	W0, _x
L_Timer1Int259:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Timer1Int510
	GOTO	L_Timer1Int260
L__Timer1Int510:
;NodoAcelerometro.c,919 :: 		ADXL355_read_FIFO(datosLeidos);                                        //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,920 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Timer1Int262:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Timer1Int511
	GOTO	L_Timer1Int263
L__Timer1Int511:
;NodoAcelerometro.c,921 :: 		datosFIFO[y+(x*9)] = datosLeidos[y];                               //LLena la trama datosFIFO
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
;NodoAcelerometro.c,920 :: 		for (y=0;y<9;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,922 :: 		}
	GOTO	L_Timer1Int262
L_Timer1Int263:
;NodoAcelerometro.c,918 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,923 :: 		}
	GOTO	L_Timer1Int259
L_Timer1Int260:
;NodoAcelerometro.c,926 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	CLR	W0
	MOV	W0, _x
L_Timer1Int265:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Timer1Int512
	GOTO	L_Timer1Int266
L__Timer1Int512:
;NodoAcelerometro.c,927 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int513
	GOTO	L__Timer1Int356
L__Timer1Int513:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int514
	GOTO	L__Timer1Int355
L__Timer1Int514:
	GOTO	L_Timer1Int270
L__Timer1Int356:
L__Timer1Int355:
;NodoAcelerometro.c,928 :: 		tramaAceleracion[contFIFO+contMuestras+x] = contMuestras;
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
;NodoAcelerometro.c,929 :: 		tramaAceleracion[contFIFO+contMuestras+x+1] = datosFIFO[x];
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
;NodoAcelerometro.c,930 :: 		contMuestras++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contMuestras), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,931 :: 		} else {
	GOTO	L_Timer1Int271
L_Timer1Int270:
;NodoAcelerometro.c,932 :: 		tramaAceleracion[contFIFO+contMuestras+x] = datosFIFO[x];
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
;NodoAcelerometro.c,933 :: 		}
L_Timer1Int271:
;NodoAcelerometro.c,926 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,934 :: 		}
	GOTO	L_Timer1Int265
L_Timer1Int266:
;NodoAcelerometro.c,936 :: 		contFIFO = (contMuestras*9);                                               //Incrementa el contador de FIFOs
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,938 :: 		contTimer1++;                                                              //Incrementa una unidad cada vez que entra a la interrupcion por Timer1
	MOV.B	#1, W1
	MOV	#lo_addr(_contTimer1), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,940 :: 		if (contTimer1==numTMR1){                                                  //Verifica si se cumplio el numero de interrupciones por TMR1 para la tasa de muestreo seleccionada
	MOV	#lo_addr(_contTimer1), W0
	ZE	[W0], W1
	MOV	#lo_addr(_numTMR1), W0
	SE	[W0], W0
	CP	W1, W0
	BRA Z	L__Timer1Int515
	GOTO	L_Timer1Int272
L__Timer1Int515:
;NodoAcelerometro.c,941 :: 		T1CON.TON = 0;                                                          //Apaga el Timer1
	BCLR	T1CON, #15
;NodoAcelerometro.c,942 :: 		banCiclo = 1;                                                           //Activa la bandera que indica que se completo un ciclo de medicion
	MOV	#lo_addr(_banCiclo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,943 :: 		contTimer1 = 0;                                                         //Limpia el contador de interrupciones por Timer1
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,944 :: 		}
L_Timer1Int272:
;NodoAcelerometro.c,946 :: 		}
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

;NodoAcelerometro.c,951 :: 		void Timer2Int() org IVT_ADDR_T2INTERRUPT{
;NodoAcelerometro.c,953 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer2
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;NodoAcelerometro.c,956 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,957 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,958 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,960 :: 		}
L_end_Timer2Int:
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

;NodoAcelerometro.c,965 :: 		void urx_1() org  IVT_ADDR_U1RXINTERRUPT {
;NodoAcelerometro.c,968 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;NodoAcelerometro.c,969 :: 		byteRS485 = U1RXREG;
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	U1RXREG, WREG
	MOV.B	W0, [W1]
;NodoAcelerometro.c,970 :: 		OERR_bit = 0;                                                              //Limpia este bit para limpiar el FIFO UART
	BCLR	OERR_bit, BitPos(OERR_bit+0)
;NodoAcelerometro.c,973 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_1518
	GOTO	L_urx_1273
L__urx_1518:
;NodoAcelerometro.c,975 :: 		if (i_rs485<(numDatosRS485)){
	MOV	_i_rs485, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__urx_1519
	GOTO	L_urx_1274
L__urx_1519:
;NodoAcelerometro.c,976 :: 		inputPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,977 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,978 :: 		} else {
	GOTO	L_urx_1275
L_urx_1274:
;NodoAcelerometro.c,979 :: 		T2CON.TON = 0;                                                       //Apaga el Timer2
	BCLR	T2CON, #15
;NodoAcelerometro.c,980 :: 		banRSI = 0;                                                          //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,981 :: 		banRSC = 1;                                                          //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,982 :: 		}
L_urx_1275:
;NodoAcelerometro.c,983 :: 		}
L_urx_1273:
;NodoAcelerometro.c,986 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1520
	GOTO	L__urx_1364
L__urx_1520:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1521
	GOTO	L__urx_1363
L__urx_1521:
L__urx_1362:
;NodoAcelerometro.c,987 :: 		if (byteRS485==0x3A){                                                   //Verifica si el primer byte recibido sea la cabecera de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__urx_1522
	GOTO	L_urx_1279
L__urx_1522:
;NodoAcelerometro.c,988 :: 		T2CON.TON = 1;                                                       //Enciende el Timer2
	BSET	T2CON, #15
;NodoAcelerometro.c,989 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,990 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,991 :: 		}
L_urx_1279:
;NodoAcelerometro.c,986 :: 		if ((banRSI==0)&&(banRSC==0)){
L__urx_1364:
L__urx_1363:
;NodoAcelerometro.c,993 :: 		if ((banRSI==1)&&(i_rs485<5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1523
	GOTO	L__urx_1366
L__urx_1523:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA LTU	L__urx_1524
	GOTO	L__urx_1365
L__urx_1524:
L__urx_1361:
;NodoAcelerometro.c,994 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                                //Recupera los datos de cabecera de la trama UART: [0x3A, Direccion, Funcion, NumeroDatosLSB, NumeroDatosMSB]
	MOV	#lo_addr(_tramaCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,995 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,993 :: 		if ((banRSI==1)&&(i_rs485<5)){
L__urx_1366:
L__urx_1365:
;NodoAcelerometro.c,997 :: 		if ((banRSI==1)&&(i_rs485==5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1525
	GOTO	L__urx_1370
L__urx_1525:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA Z	L__urx_1526
	GOTO	L__urx_1369
L__urx_1526:
L__urx_1360:
;NodoAcelerometro.c,999 :: 		if ((tramaCabeceraRS485[1]==IDNODO)||(tramaCabeceraRS485[1]==255)){
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__urx_1527
	GOTO	L__urx_1368
L__urx_1527:
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W1
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1528
	GOTO	L__urx_1367
L__urx_1528:
	GOTO	L_urx_1288
L__urx_1368:
L__urx_1367:
;NodoAcelerometro.c,1000 :: 		funcionRS485 = tramaCabeceraRS485[2];
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_tramaCabeceraRS485+2), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1001 :: 		*(ptrnumDatosRS485) = tramaCabeceraRS485[3];                         //LSB numDatosRS485
	MOV	#lo_addr(_tramaCabeceraRS485+3), W1
	MOV	_ptrnumDatosRS485, W0
	MOV.B	[W1], [W0]
;NodoAcelerometro.c,1002 :: 		*(ptrnumDatosRS485+1) = tramaCabeceraRS485[4];                       //MSB numDatosRS485
	MOV	_ptrnumDatosRS485, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaCabeceraRS485+4), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1003 :: 		banRSI = 2;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1004 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,1005 :: 		} else {
	GOTO	L_urx_1289
L_urx_1288:
;NodoAcelerometro.c,1006 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1007 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1008 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,1009 :: 		}
L_urx_1289:
;NodoAcelerometro.c,997 :: 		if ((banRSI==1)&&(i_rs485==5)){
L__urx_1370:
L__urx_1369:
;NodoAcelerometro.c,1013 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1529
	GOTO	L_urx_1290
L__urx_1529:
;NodoAcelerometro.c,1014 :: 		subFuncionRS485 = inputPyloadRS485[0];
	MOV	#lo_addr(_subFuncionRS485), W1
	MOV	#lo_addr(_inputPyloadRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1015 :: 		switch (funcionRS485){
	GOTO	L_urx_1291
;NodoAcelerometro.c,1017 :: 		case 0xF1:
L_urx_1293:
;NodoAcelerometro.c,1020 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1530
	GOTO	L_urx_1294
L__urx_1530:
;NodoAcelerometro.c,1021 :: 		for (x=0;x<6;x++) {
	CLR	W0
	MOV	W0, _x
L_urx_1295:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1531
	GOTO	L_urx_1296
L__urx_1531:
;NodoAcelerometro.c,1022 :: 		tiempo[x] = inputPyloadRS485[x+1];                       //LLena la trama tiempo con el payload de la trama recuperada
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_inputPyloadRS485), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,1021 :: 		for (x=0;x<6;x++) {
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,1023 :: 		}
	GOTO	L_urx_1295
L_urx_1296:
;NodoAcelerometro.c,1024 :: 		horaSistema = RecuperarHoraRPI(tiempo);                      //Recupera la hora de la RPi
	MOV	#lo_addr(_tiempo), W10
	CALL	_RecuperarHoraRPI
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,1025 :: 		fechaSistema = RecuperarFechaRPI(tiempo);                    //Recupera la fecha de la RPi
	MOV	#lo_addr(_tiempo), W10
	CALL	_RecuperarFechaRPI
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,1026 :: 		banSetReloj = 1;                                             //Activa la bandera para indicar que se establecio la hora y fecha
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1027 :: 		}
L_urx_1294:
;NodoAcelerometro.c,1029 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1532
	GOTO	L_urx_1298
L__urx_1532:
;NodoAcelerometro.c,1031 :: 		outputPyloadRS485[0] = 0xD2;
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1032 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_urx_1299:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1533
	GOTO	L_urx_1300
L__urx_1533:
;NodoAcelerometro.c,1033 :: 		outputPyloadRS485[x+1] = tiempo[x];
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_outputPyloadRS485), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,1032 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,1034 :: 		}
	GOTO	L_urx_1299
L_urx_1300:
;NodoAcelerometro.c,1035 :: 		EnviarTramaRS485(1, IDNODO, 0xF1, 7, outputPyloadRS485);     //Envia la hora local al Master
	MOV	#7, W13
	MOV.B	#241, W12
	MOV.B	#2, W11
	MOV.B	#1, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;NodoAcelerometro.c,1036 :: 		}
L_urx_1298:
;NodoAcelerometro.c,1037 :: 		break;
	GOTO	L_urx_1292
;NodoAcelerometro.c,1039 :: 		case 0xF2:
L_urx_1302:
;NodoAcelerometro.c,1042 :: 		if ((subFuncionRS485==0xD1)&&(banInicioMuestreo==0)){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1534
	GOTO	L__urx_1372
L__urx_1534:
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1535
	GOTO	L__urx_1371
L__urx_1535:
L__urx_1358:
;NodoAcelerometro.c,1043 :: 		sectorSD = UbicarUltimoSectorEscrito(inputPyloadRS485[1]);   //inputPyloadRS485[1] = sobrescribir (0=no, 1=si)
	MOV	#lo_addr(_inputPyloadRS485+1), W0
	MOV.B	[W0], W10
	CALL	_UbicarUltimoSectorEscrito
	MOV	W0, _sectorSD
	MOV	W1, _sectorSD+2
;NodoAcelerometro.c,1044 :: 		PSEC = sectorSD;                                             //Guarda el numero del primer sector escrito en este ciclo de muestreo
	MOV	W0, _PSEC
	MOV	W1, _PSEC+2
;NodoAcelerometro.c,1045 :: 		GuardarInfoSector(PSEC, infoPrimerSector);
	MOV	_infoPrimerSector, W12
	MOV	_infoPrimerSector+2, W13
	MOV.D	W0, W10
	CALL	_GuardarInfoSector
;NodoAcelerometro.c,1046 :: 		banInicioMuestreo = 1;                                       //Activa la bandera para iniciar el muestreo
	MOV	#lo_addr(_banInicioMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1042 :: 		if ((subFuncionRS485==0xD1)&&(banInicioMuestreo==0)){
L__urx_1372:
L__urx_1371:
;NodoAcelerometro.c,1049 :: 		if ((subFuncionRS485==0xD2)&&(banInicioMuestreo==1)){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1536
	GOTO	L__urx_1374
L__urx_1536:
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1537
	GOTO	L__urx_1373
L__urx_1537:
L__urx_1357:
;NodoAcelerometro.c,1050 :: 		GuardarInfoSector(sectorSD, infoUltimoSector);                //Guarda la posicion del ultimo sector escrito
	MOV	_infoUltimoSector, W12
	MOV	_infoUltimoSector+2, W13
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarInfoSector
;NodoAcelerometro.c,1051 :: 		banInicioMuestreo = 0;                                        //Limpia la bandera para detener el muestreo
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1049 :: 		if ((subFuncionRS485==0xD2)&&(banInicioMuestreo==1)){
L__urx_1374:
L__urx_1373:
;NodoAcelerometro.c,1053 :: 		break;
	GOTO	L_urx_1292
;NodoAcelerometro.c,1055 :: 		case 0xF3:
L_urx_1309:
;NodoAcelerometro.c,1058 :: 		*ptrsectorReq = inputPyloadRS485[1];                             //LSB sectorReq
	MOV	#lo_addr(_inputPyloadRS485+1), W1
	MOV	_ptrsectorReq, W0
	MOV.B	[W1], [W0]
;NodoAcelerometro.c,1059 :: 		*(ptrsectorReq+1) = inputPyloadRS485[2];
	MOV	_ptrsectorReq, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_inputPyloadRS485+2), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1060 :: 		*(ptrsectorReq+2) = inputPyloadRS485[3];
	MOV	_ptrsectorReq, W0
	ADD	W0, #2, W1
	MOV	#lo_addr(_inputPyloadRS485+3), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1061 :: 		*(ptrsectorReq+3) = inputPyloadRS485[4];                         //MSB sectorReq
	MOV	_ptrsectorReq, W0
	ADD	W0, #3, W1
	MOV	#lo_addr(_inputPyloadRS485+4), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1064 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1538
	GOTO	L_urx_1310
L__urx_1538:
;NodoAcelerometro.c,1066 :: 		InformacionSectores();
	CALL	_InformacionSectores
;NodoAcelerometro.c,1067 :: 		}
L_urx_1310:
;NodoAcelerometro.c,1069 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1539
	GOTO	L_urx_1311
L__urx_1539:
;NodoAcelerometro.c,1071 :: 		if (banInicioMuestreo==0){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1540
	GOTO	L_urx_1312
L__urx_1540:
;NodoAcelerometro.c,1073 :: 		InspeccionarSector(0, sectorReq);
	MOV	_sectorReq, W11
	MOV	_sectorReq+2, W12
	CLR	W10
	CALL	_InspeccionarSector
;NodoAcelerometro.c,1074 :: 		} else {
	GOTO	L_urx_1313
L_urx_1312:
;NodoAcelerometro.c,1076 :: 		banInsSec=1;
	MOV	#lo_addr(_banInsSec), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1077 :: 		}
L_urx_1313:
;NodoAcelerometro.c,1078 :: 		}
L_urx_1311:
;NodoAcelerometro.c,1080 :: 		if (subFuncionRS485==0xD3){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#211, W0
	CP.B	W1, W0
	BRA Z	L__urx_1541
	GOTO	L_urx_1314
L__urx_1541:
;NodoAcelerometro.c,1083 :: 		if (banInicioMuestreo==0){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1542
	GOTO	L_urx_1315
L__urx_1542:
;NodoAcelerometro.c,1084 :: 		RecuperarTramaAceleracion(sectorReq);
	MOV	_sectorReq, W10
	MOV	_sectorReq+2, W11
	CALL	_RecuperarTramaAceleracion
;NodoAcelerometro.c,1085 :: 		}
L_urx_1315:
;NodoAcelerometro.c,1086 :: 		}
L_urx_1314:
;NodoAcelerometro.c,1087 :: 		break;
	GOTO	L_urx_1292
;NodoAcelerometro.c,1089 :: 		}
L_urx_1291:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1543
	GOTO	L_urx_1293
L__urx_1543:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1544
	GOTO	L_urx_1302
L__urx_1544:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1545
	GOTO	L_urx_1309
L__urx_1545:
L_urx_1292:
;NodoAcelerometro.c,1091 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1092 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1094 :: 		}
L_urx_1290:
;NodoAcelerometro.c,1096 :: 		}
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
