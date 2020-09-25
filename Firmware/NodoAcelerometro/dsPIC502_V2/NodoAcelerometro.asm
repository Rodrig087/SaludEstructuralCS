
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
	BRA NZ	L__ADXL355_init343
	GOTO	L_ADXL355_init4
L__ADXL355_init343:
	CP.B	W10, #2
	BRA NZ	L__ADXL355_init344
	GOTO	L_ADXL355_init5
L__ADXL355_init344:
	CP.B	W10, #4
	BRA NZ	L__ADXL355_init345
	GOTO	L_ADXL355_init6
L__ADXL355_init345:
	CP.B	W10, #8
	BRA NZ	L__ADXL355_init346
	GOTO	L_ADXL355_init7
L__ADXL355_init346:
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
	BRA Z	L__ADXL355_read_data350
	GOTO	L_ADXL355_read_data8
L__ADXL355_read_data350:
;adxl355_spi.c,152 :: 		CS_ADXL355=0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,153 :: 		for (j=0;j<9;j++){
; j start address is: 4 (W2)
	CLR	W2
; j end address is: 4 (W2)
L_ADXL355_read_data9:
; j start address is: 4 (W2)
	CP.B	W2, #9
	BRA LTU	L__ADXL355_read_data351
	GOTO	L_ADXL355_read_data10
L__ADXL355_read_data351:
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
	BRA LTU	L__ADXL355_read_data352
	GOTO	L_ADXL355_read_data14
L__ADXL355_read_data352:
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
	BRA LTU	L__IncrementarFecha361
	GOTO	L_IncrementarFecha18
L__IncrementarFecha361:
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
	BRA Z	L__IncrementarFecha362
	GOTO	L_IncrementarFecha20
L__IncrementarFecha362:
;tiempo_rtc.c,203 :: 		if (((anio-16)%4)==0){
	SUB	W2, #16, W0
	SUBB	W3, #0, W1
	AND	W0, #3, W0
	AND	W1, #0, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__IncrementarFecha363
	GOTO	L_IncrementarFecha21
L__IncrementarFecha363:
;tiempo_rtc.c,204 :: 		if (dia==29){
	CP	W6, #29
	CPB	W7, #0
	BRA Z	L__IncrementarFecha364
	GOTO	L_IncrementarFecha22
L__IncrementarFecha364:
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
	BRA LTU	L__IncrementarFecha365
	GOTO	L_IncrementarFecha26
L__IncrementarFecha365:
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
	BRA NZ	L__IncrementarFecha366
	GOTO	L__IncrementarFecha296
L__IncrementarFecha366:
	CP	W4, #6
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha367
	GOTO	L__IncrementarFecha295
L__IncrementarFecha367:
	CP	W4, #9
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha368
	GOTO	L__IncrementarFecha294
L__IncrementarFecha368:
	CP	W4, #11
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha369
	GOTO	L__IncrementarFecha293
L__IncrementarFecha369:
	MOV.D	W4, W0
	MOV.D	W6, W4
	GOTO	L_IncrementarFecha30
L__IncrementarFecha296:
L__IncrementarFecha295:
L__IncrementarFecha294:
L__IncrementarFecha293:
;tiempo_rtc.c,219 :: 		if (dia==30){
	CP	W6, #30
	CPB	W7, #0
	BRA Z	L__IncrementarFecha370
	GOTO	L_IncrementarFecha31
L__IncrementarFecha370:
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
	BRA NZ	L__IncrementarFecha371
	GOTO	L__IncrementarFecha306
L__IncrementarFecha371:
	CP	W0, #1
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha372
	GOTO	L__IncrementarFecha302
L__IncrementarFecha372:
	CP	W0, #3
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha373
	GOTO	L__IncrementarFecha301
L__IncrementarFecha373:
	CP	W0, #5
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha374
	GOTO	L__IncrementarFecha300
L__IncrementarFecha374:
	CP	W0, #7
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha375
	GOTO	L__IncrementarFecha299
L__IncrementarFecha375:
	CP	W0, #8
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha376
	GOTO	L__IncrementarFecha298
L__IncrementarFecha376:
	CP	W0, #10
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha377
	GOTO	L__IncrementarFecha297
L__IncrementarFecha377:
	GOTO	L_IncrementarFecha37
L__IncrementarFecha302:
L__IncrementarFecha301:
L__IncrementarFecha300:
L__IncrementarFecha299:
L__IncrementarFecha298:
L__IncrementarFecha297:
L__IncrementarFecha290:
;tiempo_rtc.c,227 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha378
	GOTO	L_IncrementarFecha38
L__IncrementarFecha378:
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
	GOTO	L__IncrementarFecha303
L__IncrementarFecha306:
L__IncrementarFecha303:
;tiempo_rtc.c,234 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha379
	GOTO	L__IncrementarFecha307
L__IncrementarFecha379:
	CP	W0, #12
	CPB	W1, #0
	BRA Z	L__IncrementarFecha380
	GOTO	L__IncrementarFecha308
L__IncrementarFecha380:
L__IncrementarFecha289:
;tiempo_rtc.c,235 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha381
	GOTO	L_IncrementarFecha43
L__IncrementarFecha381:
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
	GOTO	L__IncrementarFecha305
L__IncrementarFecha307:
L__IncrementarFecha305:
; mes start address is: 0 (W0)
; anio start address is: 4 (W2)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha304
L__IncrementarFecha308:
L__IncrementarFecha304:
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
	BRA Z	L__EnviarTramaRS485384
	GOTO	L__EnviarTramaRS485309
L__EnviarTramaRS485384:
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
	BRA LTU	L__EnviarTramaRS485385
	GOTO	L_EnviarTramaRS48547
L__EnviarTramaRS485385:
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
	BRA Z	L__EnviarTramaRS485386
	GOTO	L_EnviarTramaRS48550
L__EnviarTramaRS485386:
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
L__EnviarTramaRS485309:
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
	BRA Z	L__EnviarTramaRS485387
	GOTO	L_EnviarTramaRS48551
L__EnviarTramaRS485387:
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
	BRA LTU	L__EnviarTramaRS485388
	GOTO	L_EnviarTramaRS48553
L__EnviarTramaRS485388:
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
	BRA Z	L__EnviarTramaRS485389
	GOTO	L_EnviarTramaRS48556
L__EnviarTramaRS485389:
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
;NodoAcelerometro.c,174 :: 		switch (SIZESD){
	GOTO	L_main57
;NodoAcelerometro.c,183 :: 		case 8:
L_main61:
;NodoAcelerometro.c,184 :: 		PSF = 2048;
	MOV	#2048, W0
	MOV	#0, W1
	MOV	W0, _PSF
	MOV	W1, _PSF+2
;NodoAcelerometro.c,186 :: 		USF = 16779263;
	MOV	#2047, W0
	MOV	#256, W1
	MOV	W0, _USF
	MOV	W1, _USF+2
;NodoAcelerometro.c,187 :: 		break;
	GOTO	L_main58
;NodoAcelerometro.c,192 :: 		}
L_main57:
	GOTO	L_main61
L_main58:
;NodoAcelerometro.c,193 :: 		infoPrimerSector = PSF+DELTASECTOR-2;                                      //Calcula el sector donde se alamcena la informacion del primer sector escrito
	MOV	#1000, W3
	MOV	#0, W4
	MOV	#lo_addr(_PSF), W0
	ADD	W3, [W0++], W1
	ADDC	W4, [W0--], W2
	MOV	#lo_addr(_infoPrimerSector), W0
	SUB	W1, #2, [W0++]
	SUBB	W2, #0, [W0--]
;NodoAcelerometro.c,194 :: 		infoUltimoSector = PSF+DELTASECTOR-1;                                      //Calcula el sector donde se alamcena la informacion del ultimo sector escrito
	MOV	#lo_addr(_infoUltimoSector), W0
	SUB	W1, #1, [W0++]
	SUBB	W2, #0, [W0--]
;NodoAcelerometro.c,195 :: 		PSE = PSF+DELTASECTOR;                                                     //Calcula el primer sector de escritura
	MOV	W1, _PSE
	MOV	W2, _PSE+2
;NodoAcelerometro.c,218 :: 		sdflags.detected = true;
	MOV	#lo_addr(_sdflags), W0
	BSET.B	[W0], #1
;NodoAcelerometro.c,221 :: 		if (sdflags.detected && !sdflags.init_ok) {
	MOV	#lo_addr(_sdflags), W0
	MOV.B	[W0], W0
	BTSS.B	W0, #1
	GOTO	L__main312
	MOV	#lo_addr(_sdflags), W0
	MOV.B	[W0], W0
	BTSC.B	W0, #0
	GOTO	L__main311
L__main310:
;NodoAcelerometro.c,222 :: 		if (SD_Init_Try(10) == SUCCESSFUL_INIT) {
	MOV.B	#10, W10
	CALL	_SD_Init_Try
	MOV.B	#170, W1
	CP.B	W0, W1
	BRA Z	L__main393
	GOTO	L_main66
L__main393:
;NodoAcelerometro.c,223 :: 		sdflags.init_ok = true;
	MOV	#lo_addr(_sdflags), W0
	BSET.B	[W0], #0
;NodoAcelerometro.c,224 :: 		inicioSistema = 1;                                                //Activa la bandera para permitir el inicio del sistema
	MOV	#lo_addr(_inicioSistema), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,225 :: 		TEST = 1;
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,226 :: 		} else {
	GOTO	L_main67
L_main66:
;NodoAcelerometro.c,227 :: 		sdflags.init_ok = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #0
;NodoAcelerometro.c,228 :: 		INT1IE_bit = 0;                                                   //Desabilita la interrupcion externa INT1
	BCLR	INT1IE_bit, BitPos(INT1IE_bit+0)
;NodoAcelerometro.c,229 :: 		U1MODE.UARTEN = 0;                                                //Desabilita el UART
	BCLR	U1MODE, #15
;NodoAcelerometro.c,230 :: 		inicioSistema = 0;                                                //Apaga la bandera de inicio del sistema
	MOV	#lo_addr(_inicioSistema), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,231 :: 		TEST = 0;
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,232 :: 		}
L_main67:
;NodoAcelerometro.c,221 :: 		if (sdflags.detected && !sdflags.init_ok) {
L__main312:
L__main311:
;NodoAcelerometro.c,234 :: 		Delay_ms(2000);
	MOV	#245, W8
	MOV	#9362, W7
L_main68:
	DEC	W7
	BRA NZ	L_main68
	DEC	W8
	BRA NZ	L_main68
	NOP
;NodoAcelerometro.c,237 :: 		while(1){
L_main70:
;NodoAcelerometro.c,239 :: 		asm CLRWDT;         //Clear the watchdog timer
	CLRWDT
;NodoAcelerometro.c,240 :: 		Delay_ms(100);
	MOV	#13, W8
	MOV	#13575, W7
L_main72:
	DEC	W7
	BRA NZ	L_main72
	DEC	W8
	BRA NZ	L_main72
;NodoAcelerometro.c,242 :: 		}
	GOTO	L_main70
;NodoAcelerometro.c,244 :: 		}
L_end_main:
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;NodoAcelerometro.c,252 :: 		void ConfiguracionPrincipal(){
;NodoAcelerometro.c,255 :: 		CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	CLKDIVbits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, CLKDIVbits
;NodoAcelerometro.c,256 :: 		CLKDIVbits.PLLPOST = 0;                                                    //N2=2
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,257 :: 		CLKDIVbits.PLLPRE = 5;                                                     //N1=7
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,258 :: 		PLLFBDbits.PLLDIV = 150;                                                   //M=152
	MOV	#150, W0
	MOV	W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	#511, W0
	AND	W1, W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	W1, PLLFBDbits
;NodoAcelerometro.c,261 :: 		ANSELA = 0;                                                                //Configura PORTA como digital     *
	CLR	ANSELA
;NodoAcelerometro.c,262 :: 		ANSELB = 0;                                                                //Configura PORTB como digital     *
	CLR	ANSELB
;NodoAcelerometro.c,263 :: 		TEST_Direction = 0;                                                        //TEST
	BCLR	TRISA2_bit, BitPos(TRISA2_bit+0)
;NodoAcelerometro.c,264 :: 		CsADXL_Direction = 0;                                                      //CS ADXL
	BCLR	TRISA3_bit, BitPos(TRISA3_bit+0)
;NodoAcelerometro.c,265 :: 		sd_CS_tris = 0;                                                            //CS SD
	BCLR	TRISB0_bit, BitPos(TRISB0_bit+0)
;NodoAcelerometro.c,266 :: 		MSRS485_Direction = 0;                                                     //MAX485 MS
	BCLR	TRISB12_bit, BitPos(TRISB12_bit+0)
;NodoAcelerometro.c,267 :: 		sd_detect_tris = 1;                                                        //Pin detection SD
	BSET	TRISA4_bit, BitPos(TRISA4_bit+0)
;NodoAcelerometro.c,268 :: 		TRISB13_bit = 1;                                                           //Pin de interrupcion
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
;NodoAcelerometro.c,284 :: 		RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
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
;NodoAcelerometro.c,285 :: 		RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
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
;NodoAcelerometro.c,286 :: 		RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
	MOV	#2304, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR1bits
;NodoAcelerometro.c,287 :: 		SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
	BSET	SPI2STAT, #15
;NodoAcelerometro.c,288 :: 		SPI2_Init();                                                               //Inicializa el modulo SPI2
	CALL	_SPI2_Init
;NodoAcelerometro.c,291 :: 		RPINR0 = 0x2D00;                                                           //Asigna INT1 al RB14/RPI46
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
L_ConfiguracionPrincipal74:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal74
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal74
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
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__Muestrear397
	GOTO	L_Muestrear76
L__Muestrear397:
;NodoAcelerometro.c,331 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|MEASURING);                     //Coloca el ADXL en modo medicion
	MOV.B	#4, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;NodoAcelerometro.c,332 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,334 :: 		} else if (banCiclo==1) {
	GOTO	L_Muestrear77
L_Muestrear76:
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Muestrear398
	GOTO	L_Muestrear78
L__Muestrear398:
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
L_Muestrear79:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Muestrear399
	GOTO	L_Muestrear80
L__Muestrear399:
;NodoAcelerometro.c,344 :: 		ADXL355_read_FIFO(datosLeidos);                                    //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,345 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Muestrear82:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Muestrear400
	GOTO	L_Muestrear83
L__Muestrear400:
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
	GOTO	L_Muestrear82
L_Muestrear83:
;NodoAcelerometro.c,343 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,348 :: 		}
	GOTO	L_Muestrear79
L_Muestrear80:
;NodoAcelerometro.c,351 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear85:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Muestrear401
	GOTO	L_Muestrear86
L__Muestrear401:
;NodoAcelerometro.c,352 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Muestrear402
	GOTO	L__Muestrear315
L__Muestrear402:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Muestrear403
	GOTO	L__Muestrear314
L__Muestrear403:
	GOTO	L_Muestrear90
L__Muestrear315:
L__Muestrear314:
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
	GOTO	L_Muestrear91
L_Muestrear90:
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
L_Muestrear91:
;NodoAcelerometro.c,351 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,359 :: 		}
	GOTO	L_Muestrear85
L_Muestrear86:
;NodoAcelerometro.c,363 :: 		contMuestras = 0;                                                      //Limpia el contador de muestras
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,364 :: 		contFIFO = 0;                                                          //Limpia el contador de FIFOs
	CLR	W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,365 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,367 :: 		GuardarTramaSD(tiempo, tramaAceleracion);
	MOV	#lo_addr(_tramaAceleracion), W11
	MOV	#lo_addr(_tiempo), W10
	CALL	_GuardarTramaSD
;NodoAcelerometro.c,370 :: 		}
L_Muestrear78:
L_Muestrear77:
;NodoAcelerometro.c,372 :: 		contCiclos++;                                                              //Incrementa el contador de ciclos
	MOV.B	#1, W1
	MOV	#lo_addr(_contCiclos), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,374 :: 		}
L_end_Muestrear:
	POP	W11
	POP	W10
	RETURN
; end of _Muestrear

_GuardarBufferSD:

;NodoAcelerometro.c,379 :: 		void GuardarBufferSD(unsigned char* bufferLleno, unsigned long sector){
;NodoAcelerometro.c,381 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarBufferSD92:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__GuardarBufferSD405
	GOTO	L_GuardarBufferSD93
L__GuardarBufferSD405:
;NodoAcelerometro.c,382 :: 		checkEscSD = SD_Write_Block(bufferLleno,sector);
	PUSH	W11
	PUSH	W12
	PUSH	W10
	CALL	_SD_Write_Block
	POP	W10
	POP	W12
	POP	W11
	MOV	#lo_addr(_checkEscSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,383 :: 		if (checkEscSD == DATA_ACCEPTED){
	CP.B	W0, #22
	BRA Z	L__GuardarBufferSD406
	GOTO	L_GuardarBufferSD95
L__GuardarBufferSD406:
;NodoAcelerometro.c,385 :: 		break;
	GOTO	L_GuardarBufferSD93
;NodoAcelerometro.c,386 :: 		}
L_GuardarBufferSD95:
;NodoAcelerometro.c,387 :: 		Delay_us(10);
	MOV	#80, W7
L_GuardarBufferSD96:
	DEC	W7
	BRA NZ	L_GuardarBufferSD96
	NOP
	NOP
;NodoAcelerometro.c,381 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,388 :: 		}
	GOTO	L_GuardarBufferSD92
L_GuardarBufferSD93:
;NodoAcelerometro.c,389 :: 		}
L_end_GuardarBufferSD:
	RETURN
; end of _GuardarBufferSD

_GuardarTramaSD:

;NodoAcelerometro.c,394 :: 		void GuardarTramaSD(unsigned char* tiempoSD, unsigned char* aceleracionSD){
;NodoAcelerometro.c,401 :: 		for (x=0;x<6;x++){
	PUSH	W12
	PUSH	W13
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD98:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarTramaSD408
	GOTO	L_GuardarTramaSD99
L__GuardarTramaSD408:
;NodoAcelerometro.c,402 :: 		bufferSD[x] = cabeceraSD[x];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_cabeceraSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,401 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,403 :: 		}
	GOTO	L_GuardarTramaSD98
L_GuardarTramaSD99:
;NodoAcelerometro.c,405 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD101:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarTramaSD409
	GOTO	L_GuardarTramaSD102
L__GuardarTramaSD409:
;NodoAcelerometro.c,406 :: 		bufferSD[6+x] = tiempoSD[x];
	MOV	_x, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W10, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,405 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,407 :: 		}
	GOTO	L_GuardarTramaSD101
L_GuardarTramaSD102:
;NodoAcelerometro.c,409 :: 		for (x=0;x<500;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD104:
	MOV	_x, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD410
	GOTO	L_GuardarTramaSD105
L__GuardarTramaSD410:
;NodoAcelerometro.c,410 :: 		bufferSD[12+x] = aceleracionSD[x];
	MOV	_x, W0
	ADD	W0, #12, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W11, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,409 :: 		for (x=0;x<500;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,411 :: 		}
	GOTO	L_GuardarTramaSD104
L_GuardarTramaSD105:
;NodoAcelerometro.c,413 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,415 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,418 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD107:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD411
	GOTO	L_GuardarTramaSD108
L__GuardarTramaSD411:
;NodoAcelerometro.c,419 :: 		bufferSD[x] = aceleracionSD[x+500];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#500, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,418 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,420 :: 		}
	GOTO	L_GuardarTramaSD107
L_GuardarTramaSD108:
;NodoAcelerometro.c,421 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,422 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,425 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD110:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD412
	GOTO	L_GuardarTramaSD111
L__GuardarTramaSD412:
;NodoAcelerometro.c,426 :: 		bufferSD[x] = aceleracionSD[x+1012];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1012, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,425 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,427 :: 		}
	GOTO	L_GuardarTramaSD110
L_GuardarTramaSD111:
;NodoAcelerometro.c,428 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,429 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,432 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD113:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD413
	GOTO	L_GuardarTramaSD114
L__GuardarTramaSD413:
;NodoAcelerometro.c,433 :: 		bufferSD[x] = aceleracionSD[x+1524];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1524, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,432 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,434 :: 		}
	GOTO	L_GuardarTramaSD113
L_GuardarTramaSD114:
;NodoAcelerometro.c,435 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,436 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,439 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD116:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD414
	GOTO	L_GuardarTramaSD117
L__GuardarTramaSD414:
;NodoAcelerometro.c,440 :: 		if (x<464){
	MOV	_x, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD415
	GOTO	L_GuardarTramaSD119
L__GuardarTramaSD415:
;NodoAcelerometro.c,441 :: 		bufferSD[x] = aceleracionSD[x+2036];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#2036, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,442 :: 		} else {
	GOTO	L_GuardarTramaSD120
L_GuardarTramaSD119:
;NodoAcelerometro.c,443 :: 		bufferSD[x] = 0;
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,444 :: 		}
L_GuardarTramaSD120:
;NodoAcelerometro.c,439 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,445 :: 		}
	GOTO	L_GuardarTramaSD116
L_GuardarTramaSD117:
;NodoAcelerometro.c,446 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
;NodoAcelerometro.c,447 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,450 :: 		GuardarInfoSector(sectorSD, infoUltimoSector);
	MOV	_infoUltimoSector, W12
	MOV	_infoUltimoSector+2, W13
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarInfoSector
	POP.D	W10
;NodoAcelerometro.c,452 :: 		TEST = 0;                                                               //Apaga el TEST cuando termina de gurdar la trama
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,454 :: 		}
L_end_GuardarTramaSD:
	POP	W13
	POP	W12
	RETURN
; end of _GuardarTramaSD

_GuardarInfoSector:
	LNK	#512

;NodoAcelerometro.c,459 :: 		void GuardarInfoSector(unsigned long datoSector, unsigned long localizacionSector){
;NodoAcelerometro.c,464 :: 		bufferSectores[0] = (datoSector>>24)&0xFF;                                     //MSB variable sector
	ADD	W14, #0, W5
	LSR	W11, #8, W2
	CLR	W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W5]
;NodoAcelerometro.c,465 :: 		bufferSectores[1] = (datoSector>>16)&0xFF;
	ADD	W5, #1, W4
	MOV	W11, W2
	CLR	W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W4]
;NodoAcelerometro.c,466 :: 		bufferSectores[2] = (datoSector>>8)&0xFF;
	ADD	W5, #2, W4
	LSR	W10, #8, W2
	SL	W11, #8, W3
	IOR	W2, W3, W2
	LSR	W11, #8, W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W4]
;NodoAcelerometro.c,467 :: 		bufferSectores[3] = (datoSector)&0xFF;                                         //LSD variable sector
	ADD	W5, #3, W2
	MOV	#255, W0
	MOV	#0, W1
	AND	W10, W0, W0
	MOV.B	W0, [W2]
;NodoAcelerometro.c,468 :: 		for (x=4;x<512;x++){
	MOV	#4, W0
	MOV	W0, _x
L_GuardarInfoSector121:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarInfoSector417
	GOTO	L_GuardarInfoSector122
L__GuardarInfoSector417:
;NodoAcelerometro.c,469 :: 		bufferSectores[x] = 0;                                                 //Rellena de ceros el resto del buffer
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,468 :: 		for (x=4;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,470 :: 		}
	GOTO	L_GuardarInfoSector121
L_GuardarInfoSector122:
;NodoAcelerometro.c,473 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarInfoSector124:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__GuardarInfoSector418
	GOTO	L_GuardarInfoSector125
L__GuardarInfoSector418:
;NodoAcelerometro.c,474 :: 		checkEscSD = SD_Write_Block(bufferSectores,localizacionSector);
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
;NodoAcelerometro.c,475 :: 		if (checkEscSD == DATA_ACCEPTED){
	CP.B	W0, #22
	BRA Z	L__GuardarInfoSector419
	GOTO	L_GuardarInfoSector127
L__GuardarInfoSector419:
;NodoAcelerometro.c,477 :: 		break;
	GOTO	L_GuardarInfoSector125
;NodoAcelerometro.c,478 :: 		}
L_GuardarInfoSector127:
;NodoAcelerometro.c,479 :: 		Delay_us(10);
	MOV	#80, W7
L_GuardarInfoSector128:
	DEC	W7
	BRA NZ	L_GuardarInfoSector128
	NOP
	NOP
;NodoAcelerometro.c,473 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,480 :: 		}
	GOTO	L_GuardarInfoSector124
L_GuardarInfoSector125:
;NodoAcelerometro.c,482 :: 		}
L_end_GuardarInfoSector:
	ULNK
	RETURN
; end of _GuardarInfoSector

_UbicarPrimerSectorEscrito:
	LNK	#516

;NodoAcelerometro.c,487 :: 		unsigned long UbicarPrimerSectorEscrito(){
;NodoAcelerometro.c,493 :: 		ptrPrimerSectorSD = (unsigned char *) & primerSectorSD;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	MOV	#512, W0
	ADD	W14, W0, W0
; ptrPrimerSectorSD start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,495 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,497 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_UbicarPrimerSectorEscrito130:
; ptrPrimerSectorSD start address is: 6 (W3)
; ptrPrimerSectorSD end address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__UbicarPrimerSectorEscrito421
	GOTO	L_UbicarPrimerSectorEscrito131
L__UbicarPrimerSectorEscrito421:
; ptrPrimerSectorSD end address is: 6 (W3)
;NodoAcelerometro.c,499 :: 		checkLecSD = SD_Read_Block(bufferSectorInicio, infoPrimerSector);
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
;NodoAcelerometro.c,501 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__UbicarPrimerSectorEscrito422
	GOTO	L_UbicarPrimerSectorEscrito133
L__UbicarPrimerSectorEscrito422:
;NodoAcelerometro.c,503 :: 		*ptrPrimerSectorSD = bufferSectorInicio[3];                      //LSB
	ADD	W14, #0, W2
	ADD	W2, #3, W0
	MOV.B	[W0], [W3]
;NodoAcelerometro.c,504 :: 		*(ptrPrimerSectorSD+1) = bufferSectorInicio[2];
	ADD	W3, #1, W1
	ADD	W2, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,505 :: 		*(ptrPrimerSectorSD+2) = bufferSectorInicio[1];
	ADD	W3, #2, W1
	ADD	W2, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,506 :: 		*(ptrPrimerSectorSD+3) = bufferSectorInicio[0];                  //MSB
	ADD	W3, #3, W0
; ptrPrimerSectorSD end address is: 6 (W3)
	MOV.B	[W2], [W0]
;NodoAcelerometro.c,507 :: 		break;
	GOTO	L_UbicarPrimerSectorEscrito131
;NodoAcelerometro.c,509 :: 		} else {
L_UbicarPrimerSectorEscrito133:
;NodoAcelerometro.c,510 :: 		primerSectorSD = PSE;                                           //Si no pudo realizar la lectura devuelve el Primer Sector de Escritura
; ptrPrimerSectorSD start address is: 6 (W3)
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,497 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,512 :: 		}
; ptrPrimerSectorSD end address is: 6 (W3)
	GOTO	L_UbicarPrimerSectorEscrito130
L_UbicarPrimerSectorEscrito131:
;NodoAcelerometro.c,515 :: 		return primerSectorSD;
	MOV	[W14+512], W0
	MOV	[W14+514], W1
;NodoAcelerometro.c,517 :: 		}
;NodoAcelerometro.c,515 :: 		return primerSectorSD;
;NodoAcelerometro.c,517 :: 		}
L_end_UbicarPrimerSectorEscrito:
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _UbicarPrimerSectorEscrito

_UbicarUltimoSectorEscrito:
	LNK	#516

;NodoAcelerometro.c,522 :: 		unsigned long UbicarUltimoSectorEscrito(unsigned short sobrescribirSD){
;NodoAcelerometro.c,528 :: 		ptrSectorInicioSD = (unsigned char *) & sectorInicioSD;
	PUSH	W11
	PUSH	W12
	MOV	#512, W0
	ADD	W14, W0, W0
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,531 :: 		if (sobrescribirSD==1){
	CP.B	W10, #1
	BRA Z	L__UbicarUltimoSectorEscrito424
	GOTO	L_UbicarUltimoSectorEscrito137
L__UbicarUltimoSectorEscrito424:
; ptrSectorInicioSD end address is: 6 (W3)
;NodoAcelerometro.c,532 :: 		sectorInicioSD = PSE;                                                  //Se escoje el PSE para sobrescribir la SD
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,533 :: 		} else {
	GOTO	L_UbicarUltimoSectorEscrito138
L_UbicarUltimoSectorEscrito137:
;NodoAcelerometro.c,534 :: 		checkLecSD = 1;
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,536 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_UbicarUltimoSectorEscrito139:
; ptrSectorInicioSD start address is: 6 (W3)
; ptrSectorInicioSD end address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__UbicarUltimoSectorEscrito425
	GOTO	L_UbicarUltimoSectorEscrito140
L__UbicarUltimoSectorEscrito425:
; ptrSectorInicioSD end address is: 6 (W3)
;NodoAcelerometro.c,538 :: 		checkLecSD = SD_Read_Block(bufferSectorFinal, infoUltimoSector);
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
;NodoAcelerometro.c,540 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__UbicarUltimoSectorEscrito426
	GOTO	L_UbicarUltimoSectorEscrito142
L__UbicarUltimoSectorEscrito426:
;NodoAcelerometro.c,542 :: 		*ptrSectorInicioSD = bufferSectorFinal[3];                      //LSB
	ADD	W14, #0, W2
	ADD	W2, #3, W0
	MOV.B	[W0], [W3]
;NodoAcelerometro.c,543 :: 		*(ptrSectorInicioSD+1) = bufferSectorFinal[2];
	ADD	W3, #1, W1
	ADD	W2, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,544 :: 		*(ptrSectorInicioSD+2) = bufferSectorFinal[1];
	ADD	W3, #2, W1
	ADD	W2, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,545 :: 		*(ptrSectorInicioSD+3) = bufferSectorFinal[0];                  //MSB
	ADD	W3, #3, W0
; ptrSectorInicioSD end address is: 6 (W3)
	MOV.B	[W2], [W0]
;NodoAcelerometro.c,546 :: 		break;
	GOTO	L_UbicarUltimoSectorEscrito140
;NodoAcelerometro.c,548 :: 		} else {
L_UbicarUltimoSectorEscrito142:
;NodoAcelerometro.c,549 :: 		sectorInicioSD = PSE;                                           //Si no pudo realizar la lectura procede a sobreescribir la SD
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,536 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,551 :: 		}
; ptrSectorInicioSD end address is: 6 (W3)
	GOTO	L_UbicarUltimoSectorEscrito139
L_UbicarUltimoSectorEscrito140:
;NodoAcelerometro.c,552 :: 		}
L_UbicarUltimoSectorEscrito138:
;NodoAcelerometro.c,554 :: 		return sectorInicioSD;
	MOV	[W14+512], W0
	MOV	[W14+514], W1
;NodoAcelerometro.c,556 :: 		}
;NodoAcelerometro.c,554 :: 		return sectorInicioSD;
;NodoAcelerometro.c,556 :: 		}
L_end_UbicarUltimoSectorEscrito:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _UbicarUltimoSectorEscrito

_InformacionSectores:
	LNK	#16

;NodoAcelerometro.c,561 :: 		void InformacionSectores(unsigned char* tramaInfoSec){
;NodoAcelerometro.c,573 :: 		infoPSF = PSF;
	MOV	_PSF, W0
	MOV	_PSF+2, W1
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;NodoAcelerometro.c,574 :: 		infoPSE = PSE;
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+4]
	MOV	W1, [W14+6]
;NodoAcelerometro.c,577 :: 		ptrPSF = (unsigned char *) & infoPSF;
	ADD	W14, #0, W0
; ptrPSF start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,578 :: 		ptrPSE = (unsigned char *) & infoPSE;
	ADD	W14, #4, W0
; ptrPSE start address is: 8 (W4)
	MOV	W0, W4
;NodoAcelerometro.c,579 :: 		ptrPSEC = (unsigned char *) & infoPSEC;
	ADD	W14, #8, W0
; ptrPSEC start address is: 10 (W5)
	MOV	W0, W5
;NodoAcelerometro.c,580 :: 		ptrSA = (unsigned char *) & infoSA;
	ADD	W14, #12, W0
; ptrSA start address is: 12 (W6)
	MOV	W0, W6
;NodoAcelerometro.c,582 :: 		infoPSEC = UbicarPrimerSectorEscrito();                                    //Ubica el primer sector escrito
	PUSH	W6
	PUSH.D	W4
	PUSH	W3
	PUSH	W10
	CALL	_UbicarPrimerSectorEscrito
	POP	W10
	POP	W3
	POP.D	W4
	POP	W6
	MOV	W0, [W14+8]
	MOV	W1, [W14+10]
;NodoAcelerometro.c,584 :: 		if (banInicioMuestreo==0){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__InformacionSectores428
	GOTO	L_InformacionSectores146
L__InformacionSectores428:
;NodoAcelerometro.c,585 :: 		infoSA = UbicarUltimoSectorEscrito(0);                                  //Calcula el ultimo sector escrito
	PUSH	W6
	PUSH.D	W4
	PUSH	W3
	PUSH	W10
	CLR	W10
	CALL	_UbicarUltimoSectorEscrito
	POP	W10
	POP	W3
	POP.D	W4
	POP	W6
	MOV	W0, [W14+12]
	MOV	W1, [W14+14]
;NodoAcelerometro.c,586 :: 		} else {
	GOTO	L_InformacionSectores147
L_InformacionSectores146:
;NodoAcelerometro.c,587 :: 		infoSA = sectorSD - 1;                                                  //Calcula el sector actual
	MOV	_sectorSD, W1
	MOV	_sectorSD+2, W2
	ADD	W14, #12, W0
	SUB	W1, #1, [W0++]
	SUBB	W2, #0, [W0--]
;NodoAcelerometro.c,588 :: 		}
L_InformacionSectores147:
;NodoAcelerometro.c,590 :: 		tramaInfoSec[0] = 0xD1;                                                    //Subfuncion
	MOV.B	#209, W0
	MOV.B	W0, [W10]
;NodoAcelerometro.c,591 :: 		tramaInfoSec[1] = *ptrPSF;                                                 //LSB PSF
	ADD	W10, #1, W0
	MOV.B	[W3], [W0]
;NodoAcelerometro.c,592 :: 		tramaInfoSec[2] = *(ptrPSF+1);
	ADD	W10, #2, W1
	ADD	W3, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,593 :: 		tramaInfoSec[3] = *(ptrPSF+2);
	ADD	W10, #3, W1
	ADD	W3, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,594 :: 		tramaInfoSec[4] = *(ptrPSF+3);                                             //MSB PSF
	ADD	W10, #4, W1
	ADD	W3, #3, W0
; ptrPSF end address is: 6 (W3)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,595 :: 		tramaInfoSec[5] = *ptrPSE;                                                 //LSB PSE
	ADD	W10, #5, W0
	MOV.B	[W4], [W0]
;NodoAcelerometro.c,596 :: 		tramaInfoSec[6] = *(ptrPSE+1);
	ADD	W10, #6, W1
	ADD	W4, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,597 :: 		tramaInfoSec[7] = *(ptrPSE+2);
	ADD	W10, #7, W1
	ADD	W4, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,598 :: 		tramaInfoSec[8] = *(ptrPSE+3);                                             //MSB PSE
	ADD	W10, #8, W1
	ADD	W4, #3, W0
; ptrPSE end address is: 8 (W4)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,599 :: 		tramaInfoSec[9] = *ptrPSEC;                                                //LSB PSEC
	ADD	W10, #9, W0
	MOV.B	[W5], [W0]
;NodoAcelerometro.c,600 :: 		tramaInfoSec[10] = *(ptrPSEC+1);
	ADD	W10, #10, W1
	ADD	W5, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,601 :: 		tramaInfoSec[11] = *(ptrPSEC+2);
	ADD	W10, #11, W1
	ADD	W5, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,602 :: 		tramaInfoSec[12] = *(ptrPSEC+3);                                           //MSB PSEC
	ADD	W10, #12, W1
	ADD	W5, #3, W0
; ptrPSEC end address is: 10 (W5)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,603 :: 		tramaInfoSec[13] = *ptrSA;                                                 //LSB SA
	ADD	W10, #13, W0
	MOV.B	[W6], [W0]
;NodoAcelerometro.c,604 :: 		tramaInfoSec[14] = *(ptrSA+1);
	ADD	W10, #14, W1
	ADD	W6, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,605 :: 		tramaInfoSec[15] = *(ptrSA+2);
	ADD	W10, #15, W1
	ADD	W6, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,606 :: 		tramaInfoSec[16] = *(ptrSA+3);                                             //MSB SA
	ADD	W10, #16, W1
	ADD	W6, #3, W0
; ptrSA end address is: 12 (W6)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,608 :: 		}
L_end_InformacionSectores:
	ULNK
	RETURN
; end of _InformacionSectores

_InspeccionarSector:
	LNK	#514

;NodoAcelerometro.c,613 :: 		void InspeccionarSector(unsigned short modoLec, unsigned long sectorReq, unsigned char* tramaDatosSec){
;NodoAcelerometro.c,620 :: 		if (modoLec==0xD2){
	MOV.B	#210, W0
	CP.B	W10, W0
	BRA Z	L__InspeccionarSector430
	GOTO	L_InspeccionarSector148
L__InspeccionarSector430:
;NodoAcelerometro.c,621 :: 		TEST = ~TEST;
	BTG	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,622 :: 		}
L_InspeccionarSector148:
;NodoAcelerometro.c,625 :: 		if (banInicioMuestreo==0){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__InspeccionarSector431
	GOTO	L_InspeccionarSector149
L__InspeccionarSector431:
;NodoAcelerometro.c,626 :: 		USE = UbicarUltimoSectorEscrito(0);
	PUSH.D	W10
	PUSH.D	W12
	CLR	W10
	CALL	_UbicarUltimoSectorEscrito
	POP.D	W12
	POP.D	W10
; USE start address is: 0 (W0)
;NodoAcelerometro.c,627 :: 		} else {
	MOV	W1, W2
	MOV	W0, W1
; USE end address is: 0 (W0)
	GOTO	L_InspeccionarSector150
L_InspeccionarSector149:
;NodoAcelerometro.c,628 :: 		USE = sectorSD - 1;
	MOV	_sectorSD, W0
	MOV	_sectorSD+2, W1
; USE start address is: 0 (W0)
	SUB	W0, #1, W0
	SUBB	W1, #0, W1
	MOV	W1, W2
	MOV	W0, W1
; USE end address is: 0 (W0)
;NodoAcelerometro.c,629 :: 		}
L_InspeccionarSector150:
;NodoAcelerometro.c,631 :: 		tramaDatosSec[0] = modoLec;                                                //Subfuncion
; USE start address is: 2 (W1)
	MOV.B	W10, [W13]
;NodoAcelerometro.c,634 :: 		if ((sectorReq>=PSE)&&(sectorReq<USF)){
	MOV	#lo_addr(_PSE), W0
	CP	W11, [W0++]
	CPB	W12, [W0--]
	BRA GEU	L__InspeccionarSector432
	GOTO	L__InspeccionarSector318
L__InspeccionarSector432:
	MOV	#lo_addr(_USF), W0
	CP	W11, [W0++]
	CPB	W12, [W0--]
	BRA LTU	L__InspeccionarSector433
	GOTO	L__InspeccionarSector317
L__InspeccionarSector433:
L__InspeccionarSector316:
;NodoAcelerometro.c,636 :: 		if (sectorReq<USE){
	CP	W11, W1
	CPB	W12, W2
	BRA LTU	L__InspeccionarSector434
	GOTO	L_InspeccionarSector154
L__InspeccionarSector434:
; USE end address is: 2 (W1)
;NodoAcelerometro.c,637 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,639 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_InspeccionarSector155:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__InspeccionarSector435
	GOTO	L_InspeccionarSector156
L__InspeccionarSector435:
;NodoAcelerometro.c,641 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, sectorReq);
	ADD	W14, #0, W0
	PUSH.D	W10
	PUSH.D	W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W12
	POP.D	W10
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,643 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__InspeccionarSector436
	GOTO	L_InspeccionarSector158
L__InspeccionarSector436:
;NodoAcelerometro.c,645 :: 		for (y=0;y<numDatosSec;y++){
	CLR	W0
	MOV	W0, _y
L_InspeccionarSector159:
	MOV	_y, W1
	MOV	#512, W0
	ADD	W14, W0, W0
	CP	W1, [W0]
	BRA LTU	L__InspeccionarSector437
	GOTO	L_InspeccionarSector160
L__InspeccionarSector437:
;NodoAcelerometro.c,646 :: 		tramaDatosSec[y+1] = bufferSectorReq[y];
	MOV	_y, W0
	INC	W0
	ADD	W13, W0, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,645 :: 		for (y=0;y<numDatosSec;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,647 :: 		}
	GOTO	L_InspeccionarSector159
L_InspeccionarSector160:
;NodoAcelerometro.c,648 :: 		numDatosSec = 13;
	MOV	#13, W0
	MOV	W0, [W14+512]
;NodoAcelerometro.c,649 :: 		break;
	GOTO	L_InspeccionarSector156
;NodoAcelerometro.c,650 :: 		} else {
L_InspeccionarSector158:
;NodoAcelerometro.c,652 :: 		tramaDatosSec[1] = 0xEE;
	ADD	W13, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,653 :: 		tramaDatosSec[2] = 0xE3;
	ADD	W13, #2, W1
	MOV.B	#227, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,654 :: 		numDatosSec = 3;
	MOV	#3, W0
	MOV	W0, [W14+512]
;NodoAcelerometro.c,639 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,656 :: 		}
	GOTO	L_InspeccionarSector155
L_InspeccionarSector156:
;NodoAcelerometro.c,657 :: 		} else {
	GOTO	L_InspeccionarSector163
L_InspeccionarSector154:
;NodoAcelerometro.c,659 :: 		tramaDatosSec[1] = 0xEE;
	ADD	W13, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,660 :: 		tramaDatosSec[2] = 0xE2;
	ADD	W13, #2, W1
	MOV.B	#226, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,661 :: 		numDatosSec = 3;
	MOV	#3, W0
	MOV	W0, [W14+512]
;NodoAcelerometro.c,662 :: 		}
L_InspeccionarSector163:
;NodoAcelerometro.c,664 :: 		} else {
	GOTO	L_InspeccionarSector164
;NodoAcelerometro.c,634 :: 		if ((sectorReq>=PSE)&&(sectorReq<USF)){
L__InspeccionarSector318:
L__InspeccionarSector317:
;NodoAcelerometro.c,667 :: 		tramaDatosSec[1] = 0xEE;
	ADD	W13, #1, W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,668 :: 		tramaDatosSec[2] = 0xE1;
	ADD	W13, #2, W1
	MOV.B	#225, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,669 :: 		numDatosSec = 3;
	MOV	#3, W0
	MOV	W0, [W14+512]
;NodoAcelerometro.c,671 :: 		}
L_InspeccionarSector164:
;NodoAcelerometro.c,673 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, numDatosSec, tramaDatosSec);
	PUSH.D	W10
	PUSH.D	W12
	PUSH	W13
	MOV.B	#243, W12
	MOV.B	#2, W11
	MOV.B	#1, W10
	MOV	[W14+512], W13
	CALL	_EnviarTramaRS485
	SUB	#2, W15
	POP.D	W12
	POP.D	W10
;NodoAcelerometro.c,675 :: 		}
L_end_InspeccionarSector:
	ULNK
	RETURN
; end of _InspeccionarSector

_RecuperarTramaAceleracion:
	LNK	#518

;NodoAcelerometro.c,680 :: 		void RecuperarTramaAceleracion(unsigned long sectorReq, unsigned char* tramaAcelSeg){
;NodoAcelerometro.c,686 :: 		tramaAcelSeg[0] = 0xD3;                                                     //Subfuncion
	MOV.B	#211, W0
	MOV.B	W0, [W12]
;NodoAcelerometro.c,687 :: 		contSector = 0;
; contSector start address is: 6 (W3)
	CLR	W3
	CLR	W4
;NodoAcelerometro.c,690 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,692 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion165:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion439
	GOTO	L__RecuperarTramaAceleracion319
L__RecuperarTramaAceleracion439:
;NodoAcelerometro.c,693 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	ADD	W10, W3, W1
	ADDC	W11, W4, W2
	ADD	W14, #0, W0
	PUSH	W3
	PUSH	W4
	PUSH	W12
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	POP	W12
	POP	W4
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,694 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion440
	GOTO	L_RecuperarTramaAceleracion168
L__RecuperarTramaAceleracion440:
;NodoAcelerometro.c,696 :: 		for (y=0;y<6;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion169:
; contSector start address is: 6 (W3)
	MOV	_y, W0
	CP	W0, #6
	BRA LTU	L__RecuperarTramaAceleracion441
	GOTO	L_RecuperarTramaAceleracion170
L__RecuperarTramaAceleracion441:
;NodoAcelerometro.c,697 :: 		tiempoAcel[y] = bufferSectorReq[y+6];
	MOV	#512, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W2
	MOV	_y, W0
	ADD	W0, #6, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,696 :: 		for (y=0;y<6;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,698 :: 		}
	GOTO	L_RecuperarTramaAceleracion169
L_RecuperarTramaAceleracion170:
;NodoAcelerometro.c,700 :: 		for (y=0;y<500;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion172:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion442
	GOTO	L_RecuperarTramaAceleracion173
L__RecuperarTramaAceleracion442:
;NodoAcelerometro.c,701 :: 		tramaAcelSeg[y+1] = bufferSectorReq[y+12];
	MOV	_y, W0
	INC	W0
	ADD	W12, W0, W2
	MOV	_y, W0
	ADD	W0, #12, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,700 :: 		for (y=0;y<500;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,702 :: 		}
	GOTO	L_RecuperarTramaAceleracion172
L_RecuperarTramaAceleracion173:
;NodoAcelerometro.c,703 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,704 :: 		break;
	GOTO	L_RecuperarTramaAceleracion166
;NodoAcelerometro.c,705 :: 		}
L_RecuperarTramaAceleracion168:
;NodoAcelerometro.c,692 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,706 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion165
L__RecuperarTramaAceleracion319:
;NodoAcelerometro.c,692 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,706 :: 		}
L_RecuperarTramaAceleracion166:
;NodoAcelerometro.c,709 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,711 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion175:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion443
	GOTO	L__RecuperarTramaAceleracion320
L__RecuperarTramaAceleracion443:
;NodoAcelerometro.c,712 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	ADD	W10, W3, W1
	ADDC	W11, W4, W2
	ADD	W14, #0, W0
	PUSH	W3
	PUSH	W4
	PUSH	W12
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	POP	W12
	POP	W4
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,713 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion444
	GOTO	L_RecuperarTramaAceleracion178
L__RecuperarTramaAceleracion444:
;NodoAcelerometro.c,715 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion179:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion445
	GOTO	L_RecuperarTramaAceleracion180
L__RecuperarTramaAceleracion445:
;NodoAcelerometro.c,716 :: 		tramaAcelSeg[y+501] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#501, W0
	ADD	W1, W0, W0
	ADD	W12, W0, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,715 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,717 :: 		}
	GOTO	L_RecuperarTramaAceleracion179
L_RecuperarTramaAceleracion180:
;NodoAcelerometro.c,718 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,719 :: 		break;
	GOTO	L_RecuperarTramaAceleracion176
;NodoAcelerometro.c,720 :: 		}
L_RecuperarTramaAceleracion178:
;NodoAcelerometro.c,711 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,721 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion175
L__RecuperarTramaAceleracion320:
;NodoAcelerometro.c,711 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,721 :: 		}
L_RecuperarTramaAceleracion176:
;NodoAcelerometro.c,724 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,726 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion182:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion446
	GOTO	L__RecuperarTramaAceleracion321
L__RecuperarTramaAceleracion446:
;NodoAcelerometro.c,727 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	ADD	W10, W3, W1
	ADDC	W11, W4, W2
	ADD	W14, #0, W0
	PUSH	W3
	PUSH	W4
	PUSH	W12
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	POP	W12
	POP	W4
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,728 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion447
	GOTO	L_RecuperarTramaAceleracion185
L__RecuperarTramaAceleracion447:
;NodoAcelerometro.c,730 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion186:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion448
	GOTO	L_RecuperarTramaAceleracion187
L__RecuperarTramaAceleracion448:
;NodoAcelerometro.c,731 :: 		tramaAcelSeg[y+1013] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#1013, W0
	ADD	W1, W0, W0
	ADD	W12, W0, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,730 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,732 :: 		}
	GOTO	L_RecuperarTramaAceleracion186
L_RecuperarTramaAceleracion187:
;NodoAcelerometro.c,733 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,734 :: 		break;
	GOTO	L_RecuperarTramaAceleracion183
;NodoAcelerometro.c,735 :: 		}
L_RecuperarTramaAceleracion185:
;NodoAcelerometro.c,726 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,736 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion182
L__RecuperarTramaAceleracion321:
;NodoAcelerometro.c,726 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,736 :: 		}
L_RecuperarTramaAceleracion183:
;NodoAcelerometro.c,739 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,741 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion189:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion449
	GOTO	L__RecuperarTramaAceleracion322
L__RecuperarTramaAceleracion449:
;NodoAcelerometro.c,742 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
	ADD	W10, W3, W1
	ADDC	W11, W4, W2
	ADD	W14, #0, W0
	PUSH	W3
	PUSH	W4
	PUSH	W12
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	POP	W12
	POP	W4
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,743 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion450
	GOTO	L_RecuperarTramaAceleracion192
L__RecuperarTramaAceleracion450:
;NodoAcelerometro.c,745 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion193:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion451
	GOTO	L_RecuperarTramaAceleracion194
L__RecuperarTramaAceleracion451:
;NodoAcelerometro.c,746 :: 		tramaAcelSeg[y+1525] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#1525, W0
	ADD	W1, W0, W0
	ADD	W12, W0, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,745 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,747 :: 		}
	GOTO	L_RecuperarTramaAceleracion193
L_RecuperarTramaAceleracion194:
;NodoAcelerometro.c,748 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,749 :: 		break;
	GOTO	L_RecuperarTramaAceleracion190
;NodoAcelerometro.c,750 :: 		}
L_RecuperarTramaAceleracion192:
;NodoAcelerometro.c,741 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,751 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion189
L__RecuperarTramaAceleracion322:
;NodoAcelerometro.c,741 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,751 :: 		}
L_RecuperarTramaAceleracion190:
;NodoAcelerometro.c,754 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,756 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion196:
; contSector start address is: 6 (W3)
; contSector end address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion452
	GOTO	L_RecuperarTramaAceleracion197
L__RecuperarTramaAceleracion452:
; contSector end address is: 6 (W3)
;NodoAcelerometro.c,757 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
; contSector start address is: 6 (W3)
	ADD	W10, W3, W1
	ADDC	W11, W4, W2
	ADD	W14, #0, W0
	PUSH	W3
	PUSH	W4
	PUSH	W12
	PUSH.D	W10
	MOV	W1, W11
	MOV	W2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W10
	POP	W12
	POP	W4
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,758 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion453
	GOTO	L_RecuperarTramaAceleracion199
L__RecuperarTramaAceleracion453:
; contSector end address is: 6 (W3)
;NodoAcelerometro.c,760 :: 		for (y=0;y<464;y++){
	CLR	W0
	MOV	W0, _y
L_RecuperarTramaAceleracion200:
	MOV	_y, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion454
	GOTO	L_RecuperarTramaAceleracion201
L__RecuperarTramaAceleracion454:
;NodoAcelerometro.c,761 :: 		tramaAcelSeg[y+2037] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#2037, W0
	ADD	W1, W0, W0
	ADD	W12, W0, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,760 :: 		for (y=0;y<464;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,762 :: 		}
	GOTO	L_RecuperarTramaAceleracion200
L_RecuperarTramaAceleracion201:
;NodoAcelerometro.c,764 :: 		break;
	GOTO	L_RecuperarTramaAceleracion197
;NodoAcelerometro.c,765 :: 		}
L_RecuperarTramaAceleracion199:
;NodoAcelerometro.c,756 :: 		for (x=0;x<5;x++){
; contSector start address is: 6 (W3)
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,766 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion196
L_RecuperarTramaAceleracion197:
;NodoAcelerometro.c,769 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion203:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__RecuperarTramaAceleracion455
	GOTO	L_RecuperarTramaAceleracion204
L__RecuperarTramaAceleracion455:
;NodoAcelerometro.c,770 :: 		tramaAcelSeg[2501+x] = tiempoAcel[x];
	MOV	#2501, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	ADD	W12, W0, W2
	MOV	#512, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,769 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,771 :: 		}
	GOTO	L_RecuperarTramaAceleracion203
L_RecuperarTramaAceleracion204:
;NodoAcelerometro.c,773 :: 		}
L_end_RecuperarTramaAceleracion:
	ULNK
	RETURN
; end of _RecuperarTramaAceleracion

_GuardarPruebaSD:
	LNK	#2506

;NodoAcelerometro.c,778 :: 		void GuardarPruebaSD(unsigned char* tiempoSD){
;NodoAcelerometro.c,787 :: 		contadorEjemploSD = 0;
	PUSH	W11
	PUSH	W12
	PUSH	W13
; contadorEjemploSD start address is: 4 (W2)
	CLR	W2
;NodoAcelerometro.c,788 :: 		for (x=0;x<2500;x++){
	CLR	W0
	MOV	W0, _x
; contadorEjemploSD end address is: 4 (W2)
L_GuardarPruebaSD206:
; contadorEjemploSD start address is: 4 (W2)
	MOV	_x, W1
	MOV	#2500, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD457
	GOTO	L_GuardarPruebaSD207
L__GuardarPruebaSD457:
;NodoAcelerometro.c,789 :: 		aceleracionSD[x] = contadorEjemploSD;
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
;NodoAcelerometro.c,790 :: 		contadorEjemploSD ++;
	ADD.B	W2, #1, W1
	MOV.B	W1, W2
;NodoAcelerometro.c,791 :: 		if (contadorEjemploSD >= 255){
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA GEU	L__GuardarPruebaSD458
	GOTO	L__GuardarPruebaSD323
L__GuardarPruebaSD458:
;NodoAcelerometro.c,792 :: 		contadorEjemploSD = 0;
	CLR	W2
; contadorEjemploSD end address is: 4 (W2)
;NodoAcelerometro.c,793 :: 		}
	GOTO	L_GuardarPruebaSD209
L__GuardarPruebaSD323:
;NodoAcelerometro.c,791 :: 		if (contadorEjemploSD >= 255){
;NodoAcelerometro.c,793 :: 		}
L_GuardarPruebaSD209:
;NodoAcelerometro.c,788 :: 		for (x=0;x<2500;x++){
; contadorEjemploSD start address is: 4 (W2)
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,794 :: 		}
; contadorEjemploSD end address is: 4 (W2)
	GOTO	L_GuardarPruebaSD206
L_GuardarPruebaSD207:
;NodoAcelerometro.c,797 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD210:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarPruebaSD459
	GOTO	L_GuardarPruebaSD211
L__GuardarPruebaSD459:
;NodoAcelerometro.c,798 :: 		bufferSD[x] = cabeceraSD[x];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_cabeceraSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,797 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,799 :: 		}
	GOTO	L_GuardarPruebaSD210
L_GuardarPruebaSD211:
;NodoAcelerometro.c,801 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD213:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarPruebaSD460
	GOTO	L_GuardarPruebaSD214
L__GuardarPruebaSD460:
;NodoAcelerometro.c,802 :: 		bufferSD[6+x] = tiempoSD[x];
	MOV	_x, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W10, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,801 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,803 :: 		}
	GOTO	L_GuardarPruebaSD213
L_GuardarPruebaSD214:
;NodoAcelerometro.c,805 :: 		for (x=0;x<500;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD216:
	MOV	_x, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD461
	GOTO	L_GuardarPruebaSD217
L__GuardarPruebaSD461:
;NodoAcelerometro.c,806 :: 		bufferSD[12+x] = aceleracionSD[x];
	MOV	_x, W0
	ADD	W0, #12, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,805 :: 		for (x=0;x<500;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,807 :: 		}
	GOTO	L_GuardarPruebaSD216
L_GuardarPruebaSD217:
;NodoAcelerometro.c,809 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,811 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,814 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD219:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD462
	GOTO	L_GuardarPruebaSD220
L__GuardarPruebaSD462:
;NodoAcelerometro.c,815 :: 		bufferSD[x] = aceleracionSD[x+500];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#500, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,814 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,816 :: 		}
	GOTO	L_GuardarPruebaSD219
L_GuardarPruebaSD220:
;NodoAcelerometro.c,817 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,818 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,821 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD222:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD463
	GOTO	L_GuardarPruebaSD223
L__GuardarPruebaSD463:
;NodoAcelerometro.c,822 :: 		bufferSD[x] = aceleracionSD[x+1012];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1012, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,821 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,823 :: 		}
	GOTO	L_GuardarPruebaSD222
L_GuardarPruebaSD223:
;NodoAcelerometro.c,824 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,825 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,828 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD225:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD464
	GOTO	L_GuardarPruebaSD226
L__GuardarPruebaSD464:
;NodoAcelerometro.c,829 :: 		bufferSD[x] = aceleracionSD[x+1524];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1524, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,828 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,830 :: 		}
	GOTO	L_GuardarPruebaSD225
L_GuardarPruebaSD226:
;NodoAcelerometro.c,831 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,832 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,835 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD228:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD465
	GOTO	L_GuardarPruebaSD229
L__GuardarPruebaSD465:
;NodoAcelerometro.c,836 :: 		if (x<464){
	MOV	_x, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD466
	GOTO	L_GuardarPruebaSD231
L__GuardarPruebaSD466:
;NodoAcelerometro.c,837 :: 		bufferSD[x] = aceleracionSD[x+2036];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#2036, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,838 :: 		} else {
	GOTO	L_GuardarPruebaSD232
L_GuardarPruebaSD231:
;NodoAcelerometro.c,839 :: 		bufferSD[x] = 0;
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,840 :: 		}
L_GuardarPruebaSD232:
;NodoAcelerometro.c,835 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,841 :: 		}
	GOTO	L_GuardarPruebaSD228
L_GuardarPruebaSD229:
;NodoAcelerometro.c,842 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
;NodoAcelerometro.c,843 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,846 :: 		GuardarInfoSector(sectorSD, infoUltimoSector);
	MOV	_infoUltimoSector, W12
	MOV	_infoUltimoSector+2, W13
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarInfoSector
	POP	W10
;NodoAcelerometro.c,848 :: 		TEST = 0;                                                               //Apaga el TEST cuando termina de gurdar la trama
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,850 :: 		}
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

;NodoAcelerometro.c,861 :: 		void int_1() org IVT_ADDR_INT1INTERRUPT {
;NodoAcelerometro.c,863 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;NodoAcelerometro.c,866 :: 		if ((horaSistema==0)&&(banInicioMuestreo==1)){
	MOV	_horaSistema, W0
	MOV	_horaSistema+2, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__int_1468
	GOTO	L__int_1326
L__int_1468:
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1469
	GOTO	L__int_1325
L__int_1469:
L__int_1324:
;NodoAcelerometro.c,867 :: 		PSEC = sectorSD;
	MOV	_sectorSD, W0
	MOV	_sectorSD+2, W1
	MOV	W0, _PSEC
	MOV	W1, _PSEC+2
;NodoAcelerometro.c,868 :: 		GuardarInfoSector(PSEC, infoPrimerSector);
	MOV	_infoPrimerSector, W12
	MOV	_infoPrimerSector+2, W13
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarInfoSector
;NodoAcelerometro.c,866 :: 		if ((horaSistema==0)&&(banInicioMuestreo==1)){
L__int_1326:
L__int_1325:
;NodoAcelerometro.c,871 :: 		if (banSetReloj==1){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1470
	GOTO	L_int_1236
L__int_1470:
;NodoAcelerometro.c,872 :: 		horaSistema++;                                                          //Incrementa el reloj del sistema
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaSistema), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,873 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza la trama de tiempo
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;NodoAcelerometro.c,874 :: 		TEST = ~TEST;
	BTG	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,875 :: 		}
L_int_1236:
;NodoAcelerometro.c,877 :: 		if (horaSistema==86400){                                                   //(24*3600)+(0*60)+(0) = 86400
	MOV	_horaSistema, W2
	MOV	_horaSistema+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__int_1471
	GOTO	L_int_1237
L__int_1471:
;NodoAcelerometro.c,878 :: 		horaSistema = 0;                                                        //Reinicia el reloj al llegar a las 24:00:00 horas
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,879 :: 		fechaSistema = IncrementarFecha(fechaSistema);                          //Incrementa la fecha del sistema
	MOV	_fechaSistema, W10
	MOV	_fechaSistema+2, W11
	CALL	_IncrementarFecha
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,880 :: 		}
L_int_1237:
;NodoAcelerometro.c,882 :: 		if (banInicioMuestreo==1){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1472
	GOTO	L_int_1238
L__int_1472:
;NodoAcelerometro.c,883 :: 		Muestrear();
	CALL	_Muestrear
;NodoAcelerometro.c,884 :: 		}
L_int_1238:
;NodoAcelerometro.c,886 :: 		}
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

;NodoAcelerometro.c,891 :: 		void Timer1Int() org IVT_ADDR_T1INTERRUPT{
;NodoAcelerometro.c,893 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer1
	PUSH	W10
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;NodoAcelerometro.c,895 :: 		numFIFO = ADXL355_read_byte(FIFO_ENTRIES); //75                            //Lee el numero de muestras disponibles en el FIFO
	MOV.B	#5, W10
	CALL	_ADXL355_read_byte
	MOV	#lo_addr(_numFIFO), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,896 :: 		numSetsFIFO = (numFIFO)/3;                 //25                            //Lee el numero de sets disponibles en el FIFO
	ZE	W0, W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(_numSetsFIFO), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,899 :: 		for (x=0;x<numSetsFIFO;x++){
	CLR	W0
	MOV	W0, _x
L_Timer1Int239:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Timer1Int474
	GOTO	L_Timer1Int240
L__Timer1Int474:
;NodoAcelerometro.c,900 :: 		ADXL355_read_FIFO(datosLeidos);                                        //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,901 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Timer1Int242:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Timer1Int475
	GOTO	L_Timer1Int243
L__Timer1Int475:
;NodoAcelerometro.c,902 :: 		datosFIFO[y+(x*9)] = datosLeidos[y];                               //LLena la trama datosFIFO
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
;NodoAcelerometro.c,901 :: 		for (y=0;y<9;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,903 :: 		}
	GOTO	L_Timer1Int242
L_Timer1Int243:
;NodoAcelerometro.c,899 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,904 :: 		}
	GOTO	L_Timer1Int239
L_Timer1Int240:
;NodoAcelerometro.c,907 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	CLR	W0
	MOV	W0, _x
L_Timer1Int245:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Timer1Int476
	GOTO	L_Timer1Int246
L__Timer1Int476:
;NodoAcelerometro.c,908 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int477
	GOTO	L__Timer1Int329
L__Timer1Int477:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int478
	GOTO	L__Timer1Int328
L__Timer1Int478:
	GOTO	L_Timer1Int250
L__Timer1Int329:
L__Timer1Int328:
;NodoAcelerometro.c,909 :: 		tramaAceleracion[contFIFO+contMuestras+x] = contMuestras;
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
;NodoAcelerometro.c,910 :: 		tramaAceleracion[contFIFO+contMuestras+x+1] = datosFIFO[x];
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
;NodoAcelerometro.c,911 :: 		contMuestras++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contMuestras), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,912 :: 		} else {
	GOTO	L_Timer1Int251
L_Timer1Int250:
;NodoAcelerometro.c,913 :: 		tramaAceleracion[contFIFO+contMuestras+x] = datosFIFO[x];
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
;NodoAcelerometro.c,914 :: 		}
L_Timer1Int251:
;NodoAcelerometro.c,907 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,915 :: 		}
	GOTO	L_Timer1Int245
L_Timer1Int246:
;NodoAcelerometro.c,917 :: 		contFIFO = (contMuestras*9);                                               //Incrementa el contador de FIFOs
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,919 :: 		contTimer1++;                                                              //Incrementa una unidad cada vez que entra a la interrupcion por Timer1
	MOV.B	#1, W1
	MOV	#lo_addr(_contTimer1), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,921 :: 		if (contTimer1==numTMR1){                                                  //Verifica si se cumplio el numero de interrupciones por TMR1 para la tasa de muestreo seleccionada
	MOV	#lo_addr(_contTimer1), W0
	ZE	[W0], W1
	MOV	#lo_addr(_numTMR1), W0
	SE	[W0], W0
	CP	W1, W0
	BRA Z	L__Timer1Int479
	GOTO	L_Timer1Int252
L__Timer1Int479:
;NodoAcelerometro.c,922 :: 		T1CON.TON = 0;                                                          //Apaga el Timer1
	BCLR	T1CON, #15
;NodoAcelerometro.c,923 :: 		banCiclo = 1;                                                           //Activa la bandera que indica que se completo un ciclo de medicion
	MOV	#lo_addr(_banCiclo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,924 :: 		contTimer1 = 0;                                                         //Limpia el contador de interrupciones por Timer1
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,925 :: 		}
L_Timer1Int252:
;NodoAcelerometro.c,927 :: 		}
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

;NodoAcelerometro.c,932 :: 		void Timer2Int() org IVT_ADDR_T2INTERRUPT{
;NodoAcelerometro.c,934 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer2
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;NodoAcelerometro.c,937 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,938 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,939 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,941 :: 		}
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

;NodoAcelerometro.c,946 :: 		void urx_1() org  IVT_ADDR_U1RXINTERRUPT {
;NodoAcelerometro.c,949 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;NodoAcelerometro.c,950 :: 		byteRS485 = U1RXREG;
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	U1RXREG, WREG
	MOV.B	W0, [W1]
;NodoAcelerometro.c,951 :: 		OERR_bit = 0;                                                              //Limpia este bit para limpiar el FIFO UART
	BCLR	OERR_bit, BitPos(OERR_bit+0)
;NodoAcelerometro.c,954 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_1482
	GOTO	L_urx_1253
L__urx_1482:
;NodoAcelerometro.c,956 :: 		if (i_rs485<(numDatosRS485)){
	MOV	_i_rs485, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__urx_1483
	GOTO	L_urx_1254
L__urx_1483:
;NodoAcelerometro.c,957 :: 		inputPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,958 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,959 :: 		} else {
	GOTO	L_urx_1255
L_urx_1254:
;NodoAcelerometro.c,960 :: 		T2CON.TON = 0;                                                       //Apaga el Timer2
	BCLR	T2CON, #15
;NodoAcelerometro.c,961 :: 		banRSI = 0;                                                       //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,962 :: 		banRSC = 1;                                                       //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,974 :: 		}
L_urx_1255:
;NodoAcelerometro.c,975 :: 		}
L_urx_1253:
;NodoAcelerometro.c,978 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1484
	GOTO	L__urx_1335
L__urx_1484:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1485
	GOTO	L__urx_1334
L__urx_1485:
L__urx_1333:
;NodoAcelerometro.c,979 :: 		if (byteRS485==0x3A){                                                   //Verifica si el primer byte recibido sea la cabecera de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__urx_1486
	GOTO	L_urx_1259
L__urx_1486:
;NodoAcelerometro.c,980 :: 		T2CON.TON = 1;                                                       //Enciende el Timer2
	BSET	T2CON, #15
;NodoAcelerometro.c,981 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,982 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,983 :: 		}
L_urx_1259:
;NodoAcelerometro.c,978 :: 		if ((banRSI==0)&&(banRSC==0)){
L__urx_1335:
L__urx_1334:
;NodoAcelerometro.c,985 :: 		if ((banRSI==1)&&(i_rs485<5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1487
	GOTO	L__urx_1337
L__urx_1487:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA LTU	L__urx_1488
	GOTO	L__urx_1336
L__urx_1488:
L__urx_1332:
;NodoAcelerometro.c,986 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                                //Recupera los datos de cabecera de la trama UART: [0x3A, Direccion, Funcion, NumeroDatosLSB, NumeroDatosMSB]
	MOV	#lo_addr(_tramaCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,987 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,985 :: 		if ((banRSI==1)&&(i_rs485<5)){
L__urx_1337:
L__urx_1336:
;NodoAcelerometro.c,989 :: 		if ((banRSI==1)&&(i_rs485==5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1489
	GOTO	L__urx_1341
L__urx_1489:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA Z	L__urx_1490
	GOTO	L__urx_1340
L__urx_1490:
L__urx_1331:
;NodoAcelerometro.c,991 :: 		if ((tramaCabeceraRS485[1]==IDNODO)||(tramaCabeceraRS485[1]==255)){
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA NZ	L__urx_1491
	GOTO	L__urx_1339
L__urx_1491:
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W1
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1492
	GOTO	L__urx_1338
L__urx_1492:
	GOTO	L_urx_1268
L__urx_1339:
L__urx_1338:
;NodoAcelerometro.c,992 :: 		funcionRS485 = tramaCabeceraRS485[2];
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_tramaCabeceraRS485+2), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,993 :: 		*(ptrnumDatosRS485) = tramaCabeceraRS485[3];                         //LSB numDatosRS485
	MOV	#lo_addr(_tramaCabeceraRS485+3), W1
	MOV	_ptrnumDatosRS485, W0
	MOV.B	[W1], [W0]
;NodoAcelerometro.c,994 :: 		*(ptrnumDatosRS485+1) = tramaCabeceraRS485[4];                       //MSB numDatosRS485
	MOV	_ptrnumDatosRS485, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaCabeceraRS485+4), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,995 :: 		banRSI = 2;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,996 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,997 :: 		} else {
	GOTO	L_urx_1269
L_urx_1268:
;NodoAcelerometro.c,998 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,999 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1000 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,1001 :: 		}
L_urx_1269:
;NodoAcelerometro.c,989 :: 		if ((banRSI==1)&&(i_rs485==5)){
L__urx_1341:
L__urx_1340:
;NodoAcelerometro.c,1005 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1493
	GOTO	L_urx_1270
L__urx_1493:
;NodoAcelerometro.c,1006 :: 		subFuncionRS485 = inputPyloadRS485[0];
	MOV	#lo_addr(_subFuncionRS485), W1
	MOV	#lo_addr(_inputPyloadRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1007 :: 		switch (funcionRS485){
	GOTO	L_urx_1271
;NodoAcelerometro.c,1008 :: 		case 0xF1:
L_urx_1273:
;NodoAcelerometro.c,1010 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1494
	GOTO	L_urx_1274
L__urx_1494:
;NodoAcelerometro.c,1011 :: 		for (x=0;x<6;x++) {
	CLR	W0
	MOV	W0, _x
L_urx_1275:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1495
	GOTO	L_urx_1276
L__urx_1495:
;NodoAcelerometro.c,1012 :: 		tiempo[x] = inputPyloadRS485[x+1];                  //LLena la trama tiempo con el payload de la trama recuperada
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_inputPyloadRS485), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,1011 :: 		for (x=0;x<6;x++) {
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,1013 :: 		}
	GOTO	L_urx_1275
L_urx_1276:
;NodoAcelerometro.c,1014 :: 		horaSistema = RecuperarHoraRPI(tiempo);                 //Recupera la hora de la RPi
	MOV	#lo_addr(_tiempo), W10
	CALL	_RecuperarHoraRPI
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,1015 :: 		fechaSistema = RecuperarFechaRPI(tiempo);               //Recupera la fecha de la RPi
	MOV	#lo_addr(_tiempo), W10
	CALL	_RecuperarFechaRPI
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,1016 :: 		banSetReloj = 1;                                        //Activa la bandera para indicar que se establecio la hora y fecha
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1017 :: 		}
L_urx_1274:
;NodoAcelerometro.c,1019 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1496
	GOTO	L_urx_1278
L__urx_1496:
;NodoAcelerometro.c,1021 :: 		outputPyloadRS485[0] = 0xD2;
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1022 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_urx_1279:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1497
	GOTO	L_urx_1280
L__urx_1497:
;NodoAcelerometro.c,1023 :: 		outputPyloadRS485[x+1] = tiempo[x];
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_outputPyloadRS485), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,1022 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,1024 :: 		}
	GOTO	L_urx_1279
L_urx_1280:
;NodoAcelerometro.c,1025 :: 		EnviarTramaRS485(1, IDNODO, 0xF1, 7, outputPyloadRS485);//Envia la hora local al Master
	MOV	#7, W13
	MOV.B	#241, W12
	MOV.B	#2, W11
	MOV.B	#1, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;NodoAcelerometro.c,1026 :: 		}
L_urx_1278:
;NodoAcelerometro.c,1027 :: 		break;
	GOTO	L_urx_1272
;NodoAcelerometro.c,1029 :: 		case 0xF2:
L_urx_1282:
;NodoAcelerometro.c,1031 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1498
	GOTO	L_urx_1283
L__urx_1498:
;NodoAcelerometro.c,1032 :: 		sectorSD = UbicarUltimoSectorEscrito(inputPyloadRS485[1]);   //inputPyloadRS485[1] = sobrescribir (0=no, 1=si)
	MOV	#lo_addr(_inputPyloadRS485+1), W0
	MOV.B	[W0], W10
	CALL	_UbicarUltimoSectorEscrito
	MOV	W0, _sectorSD
	MOV	W1, _sectorSD+2
;NodoAcelerometro.c,1033 :: 		PSEC = sectorSD;                                             //Guarda el numero del primer sector escrito en este ciclo de muestreo
	MOV	W0, _PSEC
	MOV	W1, _PSEC+2
;NodoAcelerometro.c,1034 :: 		GuardarInfoSector(PSEC, infoPrimerSector);
	MOV	_infoPrimerSector, W12
	MOV	_infoPrimerSector+2, W13
	MOV.D	W0, W10
	CALL	_GuardarInfoSector
;NodoAcelerometro.c,1035 :: 		banInicioMuestreo = 1;                                       //Activa la bandera para iniciar el muestreo
	MOV	#lo_addr(_banInicioMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1036 :: 		}
L_urx_1283:
;NodoAcelerometro.c,1038 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1499
	GOTO	L_urx_1284
L__urx_1499:
;NodoAcelerometro.c,1039 :: 		banInicioMuestreo = 0;                                        //Limpia la bandera para detener el muestreo
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1040 :: 		}
L_urx_1284:
;NodoAcelerometro.c,1041 :: 		break;
	GOTO	L_urx_1272
;NodoAcelerometro.c,1043 :: 		case 0xF3:
L_urx_1285:
;NodoAcelerometro.c,1046 :: 		*ptrsectorReq = inputPyloadRS485[1];                        //LSB sectorReq
	MOV	#lo_addr(_inputPyloadRS485+1), W1
	MOV	_ptrsectorReq, W0
	MOV.B	[W1], [W0]
;NodoAcelerometro.c,1047 :: 		*(ptrsectorReq+1) = inputPyloadRS485[2];
	MOV	_ptrsectorReq, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_inputPyloadRS485+2), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1048 :: 		*(ptrsectorReq+2) = inputPyloadRS485[3];
	MOV	_ptrsectorReq, W0
	ADD	W0, #2, W1
	MOV	#lo_addr(_inputPyloadRS485+3), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1049 :: 		*(ptrsectorReq+3) = inputPyloadRS485[4];                    //MSB sectorReq
	MOV	_ptrsectorReq, W0
	ADD	W0, #3, W1
	MOV	#lo_addr(_inputPyloadRS485+4), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,1052 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1500
	GOTO	L_urx_1286
L__urx_1500:
;NodoAcelerometro.c,1054 :: 		InformacionSectores(outputPyloadRS485);
	MOV	#lo_addr(_outputPyloadRS485), W10
	CALL	_InformacionSectores
;NodoAcelerometro.c,1055 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, 17, outputPyloadRS485);
	MOV	#17, W13
	MOV.B	#243, W12
	MOV.B	#2, W11
	MOV.B	#1, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;NodoAcelerometro.c,1056 :: 		}
L_urx_1286:
;NodoAcelerometro.c,1058 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1501
	GOTO	L_urx_1287
L__urx_1501:
;NodoAcelerometro.c,1060 :: 		InspeccionarSector(0xD2, sectorReq, outputPyloadRS485);
	MOV	#lo_addr(_outputPyloadRS485), W13
	MOV	_sectorReq, W11
	MOV	_sectorReq+2, W12
	MOV.B	#210, W10
	CALL	_InspeccionarSector
;NodoAcelerometro.c,1061 :: 		}
L_urx_1287:
;NodoAcelerometro.c,1063 :: 		if (subFuncionRS485==0xD3){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#211, W0
	CP.B	W1, W0
	BRA Z	L__urx_1502
	GOTO	L_urx_1288
L__urx_1502:
;NodoAcelerometro.c,1065 :: 		RecuperarTramaAceleracion(sectorReq, outputPyloadRS485);
	MOV	#lo_addr(_outputPyloadRS485), W12
	MOV	_sectorReq, W10
	MOV	_sectorReq+2, W11
	CALL	_RecuperarTramaAceleracion
;NodoAcelerometro.c,1066 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, 2507, outputPyloadRS485);
	MOV	#2507, W13
	MOV.B	#243, W12
	MOV.B	#2, W11
	MOV.B	#1, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;NodoAcelerometro.c,1067 :: 		}
L_urx_1288:
;NodoAcelerometro.c,1068 :: 		break;
	GOTO	L_urx_1272
;NodoAcelerometro.c,1070 :: 		}
L_urx_1271:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1503
	GOTO	L_urx_1273
L__urx_1503:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1504
	GOTO	L_urx_1282
L__urx_1504:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1505
	GOTO	L_urx_1285
L__urx_1505:
L_urx_1272:
;NodoAcelerometro.c,1072 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1073 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,1075 :: 		}
L_urx_1270:
;NodoAcelerometro.c,1077 :: 		}
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
