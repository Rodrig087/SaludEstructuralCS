
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
	BRA NZ	L__ADXL355_init270
	GOTO	L_ADXL355_init4
L__ADXL355_init270:
	CP.B	W10, #2
	BRA NZ	L__ADXL355_init271
	GOTO	L_ADXL355_init5
L__ADXL355_init271:
	CP.B	W10, #4
	BRA NZ	L__ADXL355_init272
	GOTO	L_ADXL355_init6
L__ADXL355_init272:
	CP.B	W10, #8
	BRA NZ	L__ADXL355_init273
	GOTO	L_ADXL355_init7
L__ADXL355_init273:
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
	BRA Z	L__ADXL355_read_data277
	GOTO	L_ADXL355_read_data8
L__ADXL355_read_data277:
;adxl355_spi.c,152 :: 		CS_ADXL355=0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,153 :: 		for (j=0;j<9;j++){
; j start address is: 4 (W2)
	CLR	W2
; j end address is: 4 (W2)
L_ADXL355_read_data9:
; j start address is: 4 (W2)
	CP.B	W2, #9
	BRA LTU	L__ADXL355_read_data278
	GOTO	L_ADXL355_read_data10
L__ADXL355_read_data278:
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
	BRA LTU	L__ADXL355_read_data279
	GOTO	L_ADXL355_read_data14
L__ADXL355_read_data279:
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
;tiempo_rtc.c,99 :: 		hora = (short)(longHora / 3600);
	PUSH.D	W10
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	MOV.B	W0, [W14+0]
;tiempo_rtc.c,100 :: 		minuto = (short)((longHora%3600) / 60);
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
;tiempo_rtc.c,101 :: 		segundo = (short)((longHora%3600) % 60);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W12
	MOV.B	W0, [W14+2]
;tiempo_rtc.c,103 :: 		dia = (short)(longFecha / 10000);
	PUSH.D	W12
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W12
	MOV.B	W0, [W14+3]
;tiempo_rtc.c,104 :: 		mes = (short)((longFecha%10000) / 100);
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
;tiempo_rtc.c,105 :: 		anio = (short)((longFecha%10000) % 100);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
; anio start address is: 8 (W4)
	MOV.B	W0, W4
;tiempo_rtc.c,107 :: 		segundo = Dec2Bcd(segundo);
	MOV.B	[W14+2], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+2]
;tiempo_rtc.c,108 :: 		minuto = Dec2Bcd(minuto);
	MOV.B	[W14+1], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+1]
;tiempo_rtc.c,109 :: 		hora = Dec2Bcd(hora);
	MOV.B	[W14+0], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+0]
;tiempo_rtc.c,110 :: 		dia = Dec2Bcd(dia);
	MOV.B	[W14+3], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+3]
;tiempo_rtc.c,111 :: 		mes = Dec2Bcd(mes);
	MOV.B	[W14+4], W10
	CALL	_Dec2Bcd
	MOV.B	W0, [W14+4]
;tiempo_rtc.c,112 :: 		anio = Dec2Bcd(anio);
	MOV.B	W4, W10
; anio end address is: 8 (W4)
	CALL	_Dec2Bcd
; anio start address is: 2 (W1)
	MOV.B	W0, W1
;tiempo_rtc.c,114 :: 		DS3234_write_byte(Segundos_Esc, segundo);
	MOV.B	[W14+2], W11
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
	MOV.B	[W14+3], W11
	MOV.B	#132, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,118 :: 		DS3234_write_byte(Mes_Esc, mes);
	MOV.B	[W14+4], W11
	MOV.B	#133, W10
	CALL	_DS3234_write_byte
;tiempo_rtc.c,119 :: 		DS3234_write_byte(Anio_Esc, anio);
	MOV.B	W1, W11
; anio end address is: 2 (W1)
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
;tiempo_rtc.c,144 :: 		valueRead = 0x1F & DS3234_read_byte(Horas_Lec);
	MOV.B	#2, W10
	CALL	_DS3234_read_byte
	ZE	W0, W0
	AND	W0, #31, W0
;tiempo_rtc.c,145 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,146 :: 		hora = (long)valueRead;
	ZE	W0, W0
	CLR	W1
;tiempo_rtc.c,148 :: 		horaRTC = (hora*3600)+(minuto*60)+(segundo);                               //Calcula el segundo actual = hh*3600 + mm*60 + ss
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
;tiempo_rtc.c,150 :: 		SPI2_Init();
	CALL	_SPI2_Init
;tiempo_rtc.c,152 :: 		return horaRTC;
	MOV.D	W2, W0
; horaRTC end address is: 4 (W2)
;tiempo_rtc.c,154 :: 		}
;tiempo_rtc.c,152 :: 		return horaRTC;
;tiempo_rtc.c,154 :: 		}
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

;tiempo_rtc.c,157 :: 		unsigned long RecuperarFechaRTC(){
;tiempo_rtc.c,165 :: 		SPI2_Init_Advanced(_SPI_MASTER, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_64, _SPI_SS_DISABLE, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_ACTIVE_2_IDLE);
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
;tiempo_rtc.c,167 :: 		valueRead = DS3234_read_byte(DiaMes_Lec);
	MOV.B	#4, W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,168 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,169 :: 		dia = (long)valueRead;
; dia start address is: 12 (W6)
	ZE	W0, W6
	CLR	W7
;tiempo_rtc.c,170 :: 		valueRead = 0x1F & DS3234_read_byte(Mes_Lec);
	MOV.B	#5, W10
	CALL	_DS3234_read_byte
	ZE	W0, W0
	AND	W0, #31, W0
;tiempo_rtc.c,171 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,172 :: 		mes = (long)valueRead;
; mes start address is: 16 (W8)
	ZE	W0, W8
	CLR	W9
;tiempo_rtc.c,173 :: 		valueRead = DS3234_read_byte(Anio_Lec);
	MOV.B	#6, W10
	CALL	_DS3234_read_byte
;tiempo_rtc.c,174 :: 		valueRead = Bcd2Dec(valueRead);
	MOV.B	W0, W10
	CALL	_Bcd2Dec
;tiempo_rtc.c,175 :: 		anio = (long)valueRead;
	ZE	W0, W0
	CLR	W1
;tiempo_rtc.c,177 :: 		fechaRTC = (anio*10000)+(mes*100)+(dia);                                   //10000*aa + 100*mm + dd
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
;tiempo_rtc.c,179 :: 		SPI2_Init();
	CALL	_SPI2_Init
;tiempo_rtc.c,181 :: 		return fechaRTC;
	MOV.D	W2, W0
; fechaRTC end address is: 4 (W2)
;tiempo_rtc.c,183 :: 		}
;tiempo_rtc.c,181 :: 		return fechaRTC;
;tiempo_rtc.c,183 :: 		}
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

;tiempo_rtc.c,186 :: 		unsigned long IncrementarFecha(unsigned long longFecha){
;tiempo_rtc.c,193 :: 		anio = longFecha / 10000;
	PUSH.D	W10
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
; anio start address is: 4 (W2)
	MOV.D	W0, W2
;tiempo_rtc.c,194 :: 		mes = (longFecha%10000) / 100;
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
;tiempo_rtc.c,195 :: 		dia = (longFecha%10000) % 100;
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
;tiempo_rtc.c,197 :: 		if (dia<28){
	CP	W0, #28
	CPB	W1, #0
	BRA LTU	L__IncrementarFecha288
	GOTO	L_IncrementarFecha18
L__IncrementarFecha288:
;tiempo_rtc.c,198 :: 		dia++;
; dia start address is: 16 (W8)
	ADD	W6, #1, W8
	ADDC	W7, #0, W9
; dia end address is: 12 (W6)
;tiempo_rtc.c,199 :: 		} else {
; dia end address is: 16 (W8)
	MOV.D	W4, W6
	GOTO	L_IncrementarFecha19
L_IncrementarFecha18:
;tiempo_rtc.c,200 :: 		if (mes==2){
; dia start address is: 12 (W6)
	CP	W4, #2
	CPB	W5, #0
	BRA Z	L__IncrementarFecha289
	GOTO	L_IncrementarFecha20
L__IncrementarFecha289:
;tiempo_rtc.c,202 :: 		if (((anio-16)%4)==0){
	SUB	W2, #16, W0
	SUBB	W3, #0, W1
	AND	W0, #3, W0
	AND	W1, #0, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__IncrementarFecha290
	GOTO	L_IncrementarFecha21
L__IncrementarFecha290:
;tiempo_rtc.c,203 :: 		if (dia==29){
	CP	W6, #29
	CPB	W7, #0
	BRA Z	L__IncrementarFecha291
	GOTO	L_IncrementarFecha22
L__IncrementarFecha291:
; dia end address is: 12 (W6)
;tiempo_rtc.c,204 :: 		dia = 1;
; dia start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,205 :: 		mes++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
;tiempo_rtc.c,206 :: 		} else {
; dia end address is: 0 (W0)
	GOTO	L_IncrementarFecha23
L_IncrementarFecha22:
;tiempo_rtc.c,207 :: 		dia++;
; dia start address is: 0 (W0)
; dia start address is: 12 (W6)
	ADD	W6, #1, W0
	ADDC	W7, #0, W1
; dia end address is: 12 (W6)
; mes end address is: 8 (W4)
; dia end address is: 0 (W0)
;tiempo_rtc.c,208 :: 		}
L_IncrementarFecha23:
;tiempo_rtc.c,209 :: 		} else {
; dia start address is: 0 (W0)
; mes start address is: 8 (W4)
	MOV.D	W0, W8
; dia end address is: 0 (W0)
	MOV.D	W4, W6
	GOTO	L_IncrementarFecha24
L_IncrementarFecha21:
;tiempo_rtc.c,210 :: 		dia = 1;
; dia start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,211 :: 		mes++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
	MOV.D	W0, W8
; mes end address is: 8 (W4)
; dia end address is: 0 (W0)
	MOV.D	W4, W6
;tiempo_rtc.c,212 :: 		}
L_IncrementarFecha24:
;tiempo_rtc.c,213 :: 		} else {
; mes start address is: 12 (W6)
; dia start address is: 16 (W8)
; mes end address is: 12 (W6)
; dia end address is: 16 (W8)
	GOTO	L_IncrementarFecha25
L_IncrementarFecha20:
;tiempo_rtc.c,214 :: 		if (dia<30){
; mes start address is: 8 (W4)
; dia start address is: 12 (W6)
	CP	W6, #30
	CPB	W7, #0
	BRA LTU	L__IncrementarFecha292
	GOTO	L_IncrementarFecha26
L__IncrementarFecha292:
;tiempo_rtc.c,215 :: 		dia++;
; dia start address is: 0 (W0)
	ADD	W6, #1, W0
	ADDC	W7, #0, W1
; dia end address is: 12 (W6)
;tiempo_rtc.c,216 :: 		} else {
	PUSH.D	W4
; dia end address is: 0 (W0)
	MOV.D	W2, W4
	MOV.D	W0, W2
	POP.D	W0
	GOTO	L_IncrementarFecha27
L_IncrementarFecha26:
;tiempo_rtc.c,217 :: 		if (mes==4||mes==6||mes==9||mes==11){
; dia start address is: 12 (W6)
	CP	W4, #4
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha293
	GOTO	L__IncrementarFecha229
L__IncrementarFecha293:
	CP	W4, #6
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha294
	GOTO	L__IncrementarFecha228
L__IncrementarFecha294:
	CP	W4, #9
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha295
	GOTO	L__IncrementarFecha227
L__IncrementarFecha295:
	CP	W4, #11
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha296
	GOTO	L__IncrementarFecha226
L__IncrementarFecha296:
	MOV.D	W4, W0
	MOV.D	W6, W4
	GOTO	L_IncrementarFecha30
L__IncrementarFecha229:
L__IncrementarFecha228:
L__IncrementarFecha227:
L__IncrementarFecha226:
;tiempo_rtc.c,218 :: 		if (dia==30){
	CP	W6, #30
	CPB	W7, #0
	BRA Z	L__IncrementarFecha297
	GOTO	L_IncrementarFecha31
L__IncrementarFecha297:
; dia end address is: 12 (W6)
;tiempo_rtc.c,219 :: 		dia = 1;
; dia start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,220 :: 		mes++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
;tiempo_rtc.c,221 :: 		} else {
	PUSH.D	W0
; dia end address is: 0 (W0)
	MOV.D	W4, W0
	POP.D	W4
	GOTO	L_IncrementarFecha32
L_IncrementarFecha31:
;tiempo_rtc.c,222 :: 		dia++;
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
;tiempo_rtc.c,223 :: 		}
L_IncrementarFecha32:
;tiempo_rtc.c,224 :: 		}
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
L_IncrementarFecha30:
;tiempo_rtc.c,225 :: 		if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
; mes start address is: 0 (W0)
; dia start address is: 8 (W4)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha298
	GOTO	L__IncrementarFecha239
L__IncrementarFecha298:
	CP	W0, #1
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha299
	GOTO	L__IncrementarFecha235
L__IncrementarFecha299:
	CP	W0, #3
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha300
	GOTO	L__IncrementarFecha234
L__IncrementarFecha300:
	CP	W0, #5
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha301
	GOTO	L__IncrementarFecha233
L__IncrementarFecha301:
	CP	W0, #7
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha302
	GOTO	L__IncrementarFecha232
L__IncrementarFecha302:
	CP	W0, #8
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha303
	GOTO	L__IncrementarFecha231
L__IncrementarFecha303:
	CP	W0, #10
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha304
	GOTO	L__IncrementarFecha230
L__IncrementarFecha304:
	GOTO	L_IncrementarFecha37
L__IncrementarFecha235:
L__IncrementarFecha234:
L__IncrementarFecha233:
L__IncrementarFecha232:
L__IncrementarFecha231:
L__IncrementarFecha230:
L__IncrementarFecha223:
;tiempo_rtc.c,226 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha305
	GOTO	L_IncrementarFecha38
L__IncrementarFecha305:
;tiempo_rtc.c,227 :: 		dia = 1;
	MOV	#1, W4
	MOV	#0, W5
;tiempo_rtc.c,228 :: 		mes++;
	ADD	W0, #1, W0
	ADDC	W1, #0, W1
;tiempo_rtc.c,229 :: 		} else {
	GOTO	L_IncrementarFecha39
L_IncrementarFecha38:
;tiempo_rtc.c,230 :: 		dia++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
;tiempo_rtc.c,231 :: 		}
L_IncrementarFecha39:
;tiempo_rtc.c,232 :: 		}
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
L_IncrementarFecha37:
;tiempo_rtc.c,225 :: 		if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
; mes start address is: 0 (W0)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
	GOTO	L__IncrementarFecha236
L__IncrementarFecha239:
L__IncrementarFecha236:
;tiempo_rtc.c,233 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha306
	GOTO	L__IncrementarFecha240
L__IncrementarFecha306:
	CP	W0, #12
	CPB	W1, #0
	BRA Z	L__IncrementarFecha307
	GOTO	L__IncrementarFecha241
L__IncrementarFecha307:
L__IncrementarFecha222:
;tiempo_rtc.c,234 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha308
	GOTO	L_IncrementarFecha43
L__IncrementarFecha308:
; mes end address is: 0 (W0)
;tiempo_rtc.c,235 :: 		dia = 1;
	MOV	#1, W4
	MOV	#0, W5
;tiempo_rtc.c,236 :: 		mes = 1;
; mes start address is: 0 (W0)
	MOV	#1, W0
	MOV	#0, W1
;tiempo_rtc.c,237 :: 		anio++;
	ADD	W2, #1, W2
	ADDC	W3, #0, W3
;tiempo_rtc.c,238 :: 		} else {
	GOTO	L_IncrementarFecha44
L_IncrementarFecha43:
;tiempo_rtc.c,239 :: 		dia++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
;tiempo_rtc.c,240 :: 		}
L_IncrementarFecha44:
;tiempo_rtc.c,233 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; anio start address is: 4 (W2)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha238
L__IncrementarFecha240:
L__IncrementarFecha238:
; mes start address is: 0 (W0)
; anio start address is: 4 (W2)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha237
L__IncrementarFecha241:
L__IncrementarFecha237:
;tiempo_rtc.c,242 :: 		}
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
;tiempo_rtc.c,243 :: 		}
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
;tiempo_rtc.c,245 :: 		}
; dia start address is: 16 (W8)
; anio start address is: 4 (W2)
; mes start address is: 12 (W6)
; mes end address is: 12 (W6)
; anio end address is: 4 (W2)
; dia end address is: 16 (W8)
L_IncrementarFecha19:
;tiempo_rtc.c,247 :: 		fechaInc = (anio*10000)+(mes*100)+(dia);                                   //10000*aa + 100*mm + dd
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
;tiempo_rtc.c,248 :: 		return fechaInc;
;tiempo_rtc.c,250 :: 		}
L_end_IncrementarFecha:
	ULNK
	RETURN
; end of _IncrementarFecha

_AjustarTiempoSistema:
	LNK	#14

;tiempo_rtc.c,253 :: 		void AjustarTiempoSistema(unsigned long longHora, unsigned long longFecha, unsigned short *tramaTiempoSistema){
	MOV	[W14-8], W0
	MOV	W0, [W14-8]
;tiempo_rtc.c,262 :: 		hora = (short)(longHora / 3600);
	PUSH.D	W12
	PUSH.D	W10
	MOV	#3600, W2
	MOV	#0, W3
	MOV.D	W10, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W10
	MOV.B	W0, [W14+0]
;tiempo_rtc.c,263 :: 		minuto = (short)((longHora%3600) / 60);
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
;tiempo_rtc.c,264 :: 		segundo = (short)((longHora%3600) % 60);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#60, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
	POP.D	W12
	MOV.B	W0, [W14+2]
;tiempo_rtc.c,266 :: 		anio = (short)(longFecha / 10000);
	PUSH.D	W12
	MOV	#10000, W2
	MOV	#0, W3
	MOV.D	W12, W0
	CLR	W4
	CALL	__Divide_32x32
	POP.D	W12
	MOV.B	W0, [W14+4]
;tiempo_rtc.c,267 :: 		mes = (short)((longFecha%10000) / 100);
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
;tiempo_rtc.c,268 :: 		dia = (short)((longFecha%10000) % 100);
	MOV	[W14+10], W0
	MOV	[W14+12], W1
	MOV	#100, W2
	MOV	#0, W3
	CLR	W4
	CALL	__Modulus_32x32
; dia start address is: 4 (W2)
	MOV.B	W0, W2
;tiempo_rtc.c,270 :: 		tramaTiempoSistema[0] = anio;
	MOV	[W14-8], W1
	MOV.B	[W14+4], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,271 :: 		tramaTiempoSistema[1] = mes;
	MOV	[W14-8], W0
	ADD	W0, #1, W1
	MOV.B	[W14+3], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,272 :: 		tramaTiempoSistema[2] = dia;
	MOV	[W14-8], W0
	INC2	W0
	MOV.B	W2, [W0]
; dia end address is: 4 (W2)
;tiempo_rtc.c,273 :: 		tramaTiempoSistema[3] = hora;
	MOV	[W14-8], W0
	ADD	W0, #3, W1
	MOV.B	[W14+0], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,274 :: 		tramaTiempoSistema[4] = minuto;
	MOV	[W14-8], W0
	ADD	W0, #4, W1
	MOV.B	[W14+1], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,275 :: 		tramaTiempoSistema[5] = segundo;
	MOV	[W14-8], W0
	ADD	W0, #5, W1
	MOV.B	[W14+2], W0
	MOV.B	W0, [W1]
;tiempo_rtc.c,277 :: 		}
L_end_AjustarTiempoSistema:
	ULNK
	RETURN
; end of _AjustarTiempoSistema

_EnviarTramaRS485:
	LNK	#0

;rs485.c,17 :: 		void EnviarTramaRS485(unsigned short puertoUART, unsigned short direccion, unsigned short funcion, unsigned short subfuncion, unsigned short numDatos, unsigned char *payload){
; numDatos start address is: 0 (W0)
	MOV.B	[W14-8], W0
; payload start address is: 4 (W2)
	MOV	[W14-10], W2
;rs485.c,21 :: 		if (puertoUART == 1){
	CP.B	W10, #1
	BRA Z	L__EnviarTramaRS485311
	GOTO	L__EnviarTramaRS485242
L__EnviarTramaRS485311:
;rs485.c,22 :: 		MSRS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSET	MSRS485, BitPos(MSRS485+0)
;rs485.c,23 :: 		UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
	PUSH	W10
	MOV	#58, W10
	CALL	_UART1_Write
;rs485.c,24 :: 		UART1_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W11, W10
	CALL	_UART1_Write
;rs485.c,25 :: 		UART1_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W12, W10
	CALL	_UART1_Write
;rs485.c,26 :: 		UART1_Write(subfuncion);                                                //Envia el codigo de la subfuncion
	ZE	W13, W10
	CALL	_UART1_Write
;rs485.c,27 :: 		UART1_Write(numDatos);                                                  //Envia el numero de datos
	ZE	W0, W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,28 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 2 (W1)
	CLR	W1
; numDatos end address is: 0 (W0)
; iDatos end address is: 2 (W1)
; payload end address is: 4 (W2)
	MOV.B	W0, W3
L_EnviarTramaRS48546:
; iDatos start address is: 2 (W1)
; payload start address is: 4 (W2)
; numDatos start address is: 6 (W3)
	ZE	W3, W0
	CP	W1, W0
	BRA LTU	L__EnviarTramaRS485312
	GOTO	L_EnviarTramaRS48547
L__EnviarTramaRS485312:
;rs485.c,29 :: 		UART1_Write(payload[iDatos]);
	ADD	W2, W1, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,28 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W1
;rs485.c,30 :: 		}
; iDatos end address is: 2 (W1)
	GOTO	L_EnviarTramaRS48546
L_EnviarTramaRS48547:
;rs485.c,31 :: 		UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART1_Write
;rs485.c,32 :: 		UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART1_Write
; numDatos end address is: 6 (W3)
; payload end address is: 4 (W2)
	POP	W10
	MOV.B	W3, W1
;rs485.c,33 :: 		while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48549:
; numDatos start address is: 2 (W1)
; payload start address is: 4 (W2)
	CALL	_UART1_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485313
	GOTO	L_EnviarTramaRS48550
L__EnviarTramaRS485313:
	GOTO	L_EnviarTramaRS48549
L_EnviarTramaRS48550:
;rs485.c,34 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
; numDatos end address is: 2 (W1)
; payload end address is: 4 (W2)
;rs485.c,35 :: 		}
	GOTO	L_EnviarTramaRS48545
L__EnviarTramaRS485242:
;rs485.c,21 :: 		if (puertoUART == 1){
	MOV.B	W0, W1
;rs485.c,35 :: 		}
L_EnviarTramaRS48545:
;rs485.c,37 :: 		if (puertoUART == 2){
; payload start address is: 4 (W2)
; numDatos start address is: 2 (W1)
	CP.B	W10, #2
	BRA Z	L__EnviarTramaRS485314
	GOTO	L_EnviarTramaRS48551
L__EnviarTramaRS485314:
;rs485.c,38 :: 		MSRS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSET	MSRS485, BitPos(MSRS485+0)
;rs485.c,39 :: 		UART2_Write(0x3A);                                                      //Envia la cabecera de la trama
	PUSH	W10
	MOV	#58, W10
	CALL	_UART2_Write
;rs485.c,40 :: 		UART2_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W11, W10
	CALL	_UART2_Write
;rs485.c,41 :: 		UART2_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W12, W10
	CALL	_UART2_Write
;rs485.c,42 :: 		UART2_Write(subfuncion);                                                //Envia el codigo de la subfuncion
	ZE	W13, W10
	CALL	_UART2_Write
;rs485.c,43 :: 		UART2_Write(numDatos);                                                  //Envia el numero de datos
	ZE	W1, W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,44 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 6 (W3)
	CLR	W3
; numDatos end address is: 2 (W1)
; iDatos end address is: 6 (W3)
L_EnviarTramaRS48552:
; iDatos start address is: 6 (W3)
; numDatos start address is: 2 (W1)
; payload start address is: 4 (W2)
; payload end address is: 4 (W2)
	ZE	W1, W0
	CP	W3, W0
	BRA LTU	L__EnviarTramaRS485315
	GOTO	L_EnviarTramaRS48553
L__EnviarTramaRS485315:
; payload end address is: 4 (W2)
;rs485.c,45 :: 		UART2_Write(payload[iDatos]);
; payload start address is: 4 (W2)
	ADD	W2, W3, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,44 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W3
;rs485.c,46 :: 		}
; numDatos end address is: 2 (W1)
; payload end address is: 4 (W2)
; iDatos end address is: 6 (W3)
	GOTO	L_EnviarTramaRS48552
L_EnviarTramaRS48553:
;rs485.c,47 :: 		UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART2_Write
;rs485.c,48 :: 		UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,49 :: 		while(UART2_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48555:
	CALL	_UART2_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485316
	GOTO	L_EnviarTramaRS48556
L__EnviarTramaRS485316:
	GOTO	L_EnviarTramaRS48555
L_EnviarTramaRS48556:
;rs485.c,50 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
;rs485.c,51 :: 		}
L_EnviarTramaRS48551:
;rs485.c,53 :: 		}
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

;NodoAcelerometro.c,110 :: 		void main() {
;NodoAcelerometro.c,112 :: 		ConfiguracionPrincipal();
	PUSH	W10
	CALL	_ConfiguracionPrincipal
;NodoAcelerometro.c,113 :: 		TEST = 0;                                                                                                                                        //Pin de TEST
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,115 :: 		tasaMuestreo = 1;                                                          //1=250Hz, 2=125Hz, 4=62.5Hz, 8=31.25Hz
	MOV	#lo_addr(_tasaMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,116 :: 		ADXL355_init(tasaMuestreo);                                                //Inicializa el modulo ADXL con la tasa de muestreo requerida:
	MOV.B	#1, W10
	CALL	_ADXL355_init
;NodoAcelerometro.c,117 :: 		numTMR1 = (tasaMuestreo*10)-1;                                             //Calcula el numero de veces que tienen que desbordarse el TMR1 para cada tasa de muestreo
	MOV	#lo_addr(_tasaMuestreo), W0
	SE	[W0], W1
	MOV	#10, W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(_numTMR1), W0
	SUB.B	W2, #1, [W0]
;NodoAcelerometro.c,122 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;NodoAcelerometro.c,123 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;NodoAcelerometro.c,124 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;NodoAcelerometro.c,125 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;NodoAcelerometro.c,128 :: 		inicioSistema = 0;
	MOV	#lo_addr(_inicioSistema), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,131 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,132 :: 		horaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,133 :: 		fechaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,136 :: 		banCiclo = 0;
	MOV	#lo_addr(_banCiclo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,137 :: 		banInicioMuestreo = 0;
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,138 :: 		numFIFO = 0;
	MOV	#lo_addr(_numFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,139 :: 		numSetsFIFO = 0;
	MOV	#lo_addr(_numSetsFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,140 :: 		contTimer1 = 0;
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,141 :: 		contMuestras = 0;
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,142 :: 		contCiclos = 0;
	MOV	#lo_addr(_contCiclos), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,143 :: 		contFIFO = 0;
	CLR	W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,146 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,147 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,148 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,149 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,150 :: 		numDatosRS485 = 0;
	CLR	W0
	MOV	W0, _numDatosRS485
;NodoAcelerometro.c,151 :: 		funcionRS485 = 0;
	MOV	#lo_addr(_funcionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,152 :: 		subFuncionRS485 = 0;
	MOV	#lo_addr(_subFuncionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,154 :: 		banU2 = 1;
	MOV	#lo_addr(_banU2), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,157 :: 		sectorSD = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _sectorSD
	MOV	W1, _sectorSD+2
;NodoAcelerometro.c,158 :: 		sectorLec = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _sectorLec
	MOV	W1, _sectorLec+2
;NodoAcelerometro.c,159 :: 		checkEscSD = 0;
	MOV	#lo_addr(_checkEscSD), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,160 :: 		checkLecSD = 0;
	MOV	#lo_addr(_checkLecSD), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,161 :: 		MSRS485 = 0;                                                               //Estabkece el Max485 en modo lectura
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;NodoAcelerometro.c,185 :: 		sdflags.detected = true;
	MOV	#lo_addr(_sdflags), W0
	BSET.B	[W0], #1
;NodoAcelerometro.c,188 :: 		if (sdflags.detected && !sdflags.init_ok) {
	MOV	#lo_addr(_sdflags), W0
	MOV.B	[W0], W0
	BTSS.B	W0, #1
	GOTO	L__main245
	MOV	#lo_addr(_sdflags), W0
	MOV.B	[W0], W0
	BTSC.B	W0, #0
	GOTO	L__main244
L__main243:
;NodoAcelerometro.c,189 :: 		if (SD_Init_Try(10) == SUCCESSFUL_INIT) {
	MOV.B	#10, W10
	CALL	_SD_Init_Try
	MOV.B	#170, W1
	CP.B	W0, W1
	BRA Z	L__main320
	GOTO	L_main60
L__main320:
;NodoAcelerometro.c,190 :: 		sdflags.init_ok = true;
	MOV	#lo_addr(_sdflags), W0
	BSET.B	[W0], #0
;NodoAcelerometro.c,191 :: 		inicioSistema = 1;                                                //Activa la bandera para permitir el inicio del sistema
	MOV	#lo_addr(_inicioSistema), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,192 :: 		TEST = 1;
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,193 :: 		} else {
	GOTO	L_main61
L_main60:
;NodoAcelerometro.c,194 :: 		sdflags.init_ok = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #0
;NodoAcelerometro.c,195 :: 		INT1IE_bit = 0;                                                   //Desabilita la interrupcion externa INT1
	BCLR	INT1IE_bit, BitPos(INT1IE_bit+0)
;NodoAcelerometro.c,196 :: 		U1MODE.UARTEN = 0;                                                //Desabilita el UART
	BCLR	U1MODE, #15
;NodoAcelerometro.c,197 :: 		inicioSistema = 0;                                                //Apaga la bandera de inicio del sistema
	MOV	#lo_addr(_inicioSistema), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,198 :: 		TEST = 0;
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,199 :: 		}
L_main61:
;NodoAcelerometro.c,188 :: 		if (sdflags.detected && !sdflags.init_ok) {
L__main245:
L__main244:
;NodoAcelerometro.c,201 :: 		Delay_ms(2000);
	MOV	#245, W8
	MOV	#9362, W7
L_main62:
	DEC	W7
	BRA NZ	L_main62
	DEC	W8
	BRA NZ	L_main62
	NOP
;NodoAcelerometro.c,204 :: 		while(1){
L_main64:
;NodoAcelerometro.c,207 :: 		}
	GOTO	L_main64
;NodoAcelerometro.c,209 :: 		}
L_end_main:
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;NodoAcelerometro.c,217 :: 		void ConfiguracionPrincipal(){
;NodoAcelerometro.c,220 :: 		CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	CLKDIVbits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, CLKDIVbits
;NodoAcelerometro.c,221 :: 		CLKDIVbits.PLLPOST = 0;                                                    //N2=2
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,222 :: 		CLKDIVbits.PLLPRE = 5;                                                     //N1=7
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,223 :: 		PLLFBDbits.PLLDIV = 150;                                                   //M=152
	MOV	#150, W0
	MOV	W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	#511, W0
	AND	W1, W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	W1, PLLFBDbits
;NodoAcelerometro.c,226 :: 		ANSELA = 0;                                                                //Configura PORTA como digital     *
	CLR	ANSELA
;NodoAcelerometro.c,227 :: 		ANSELB = 0;                                                                //Configura PORTB como digital     *
	CLR	ANSELB
;NodoAcelerometro.c,228 :: 		TEST_Direction = 0;                                                        //TEST
	BCLR	TRISA2_bit, BitPos(TRISA2_bit+0)
;NodoAcelerometro.c,229 :: 		CsADXL_Direction = 0;                                                      //CS ADXL
	BCLR	TRISA3_bit, BitPos(TRISA3_bit+0)
;NodoAcelerometro.c,230 :: 		sd_CS_tris = 0;                                                            //CS SD
	BCLR	TRISB0_bit, BitPos(TRISB0_bit+0)
;NodoAcelerometro.c,231 :: 		MSRS485_Direction = 0;                                                     //MAX485 MS
	BCLR	TRISB12_bit, BitPos(TRISB12_bit+0)
;NodoAcelerometro.c,232 :: 		sd_detect_tris = 1;                                                        //Pin detection SD
	BSET	TRISA4_bit, BitPos(TRISA4_bit+0)
;NodoAcelerometro.c,233 :: 		TRISB14_bit = 1;                                                           //Pin de interrupcion
	BSET	TRISB14_bit, BitPos(TRISB14_bit+0)
;NodoAcelerometro.c,236 :: 		INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales
	BSET	INTCON2, #15
;NodoAcelerometro.c,239 :: 		RPINR18bits.U1RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx1
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
;NodoAcelerometro.c,240 :: 		RPOR1bits.RP36R = 0x01;                                                    //Configura el Tx1 en el pin RB4/RP36
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
;NodoAcelerometro.c,241 :: 		U1RXIE_bit = 1;                                                            //Activa la interrupcion por UART1 RX
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;NodoAcelerometro.c,242 :: 		U1STAbits.URXISEL = 0x00;                                                  //Interrupt is set when any character is received and transferred from the UxRSR to the receive buffer; receive buffer has one or more characters
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,243 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;NodoAcelerometro.c,244 :: 		IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#16384, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;NodoAcelerometro.c,245 :: 		UART1_Init_Advanced(2000000, _UART_8BIT_NOPARITY, _UART_ONE_STOPBIT, _UART_HI_SPEED);                            //Inicializa el UART1 con una velocidad de 2Mbps
	CLR	W13
	CLR	W12
	MOV	#33920, W10
	MOV	#30, W11
	MOV	#1, W0
	PUSH	W0
	CALL	_UART1_Init_Advanced
	SUB	#2, W15
;NodoAcelerometro.c,249 :: 		RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
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
;NodoAcelerometro.c,250 :: 		RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
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
;NodoAcelerometro.c,251 :: 		RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
	MOV	#2304, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR1bits
;NodoAcelerometro.c,252 :: 		SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
	BSET	SPI2STAT, #15
;NodoAcelerometro.c,253 :: 		SPI2_Init();                                                               //Inicializa el modulo SPI2
	CALL	_SPI2_Init
;NodoAcelerometro.c,256 :: 		RPINR0 = 0x2E00;                                                           //Asigna INT1 al RB14/RPI46
	MOV	#11776, W0
	MOV	WREG, RPINR0
;NodoAcelerometro.c,257 :: 		INT1IE_bit = 1;                                                            //Interrupcion externa INT1
	BSET	INT1IE_bit, BitPos(INT1IE_bit+0)
;NodoAcelerometro.c,258 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;NodoAcelerometro.c,259 :: 		IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,262 :: 		T1CON = 0x0020;
	MOV	#32, W0
	MOV	WREG, T1CON
;NodoAcelerometro.c,263 :: 		T1CON.TON = 0;                                                             //Apaga el Timer1
	BCLR	T1CON, #15
;NodoAcelerometro.c,264 :: 		T1IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR1
	BSET	T1IE_bit, BitPos(T1IE_bit+0)
;NodoAcelerometro.c,265 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR1
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;NodoAcelerometro.c,266 :: 		PR1 = 62500;                                                               //Car ga el preload para un tiempo de 100ms
	MOV	#62500, W0
	MOV	WREG, PR1
;NodoAcelerometro.c,267 :: 		IPC0bits.T1IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR1
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;NodoAcelerometro.c,270 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|STANDBY);                           //Coloco el ADXL en modo STANDBY para pausar las conversiones y limpiar el FIFO
	MOV.B	#5, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;NodoAcelerometro.c,273 :: 		sdflags.detected = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #1
;NodoAcelerometro.c,274 :: 		sdflags.init_ok = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #0
;NodoAcelerometro.c,275 :: 		sdflags.saving = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #2
;NodoAcelerometro.c,277 :: 		Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#25, W8
	MOV	#27150, W7
L_ConfiguracionPrincipal66:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal66
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal66
	NOP
;NodoAcelerometro.c,279 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_Muestrear:

;NodoAcelerometro.c,284 :: 		void Muestrear(){
;NodoAcelerometro.c,286 :: 		if (banCiclo==0){
	PUSH	W10
	PUSH	W11
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__Muestrear324
	GOTO	L_Muestrear68
L__Muestrear324:
;NodoAcelerometro.c,288 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|MEASURING);                     //Coloca el ADXL en modo medicion
	MOV.B	#4, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;NodoAcelerometro.c,289 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,291 :: 		} else if (banCiclo==1) {
	GOTO	L_Muestrear69
L_Muestrear68:
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Muestrear325
	GOTO	L_Muestrear70
L__Muestrear325:
;NodoAcelerometro.c,293 :: 		banCiclo = 2;                                                          //Limpia la bandera de ciclo completo
	MOV	#lo_addr(_banCiclo), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,295 :: 		tramaAceleracion[0] = contCiclos;                                      //LLena el primer elemento de la tramaCompleta con el contador de ciclos
	MOV	#lo_addr(_tramaAceleracion), W1
	MOV	#lo_addr(_contCiclos), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,296 :: 		numFIFO = ADXL355_read_byte(FIFO_ENTRIES);
	MOV.B	#5, W10
	CALL	_ADXL355_read_byte
	MOV	#lo_addr(_numFIFO), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,297 :: 		numSetsFIFO = (numFIFO)/3;                                             //Lee el numero de sets disponibles en el FIFO
	ZE	W0, W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(_numSetsFIFO), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,300 :: 		for (x=0;x<numSetsFIFO;x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear71:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Muestrear326
	GOTO	L_Muestrear72
L__Muestrear326:
;NodoAcelerometro.c,301 :: 		ADXL355_read_FIFO(datosLeidos);                                    //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,302 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Muestrear74:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Muestrear327
	GOTO	L_Muestrear75
L__Muestrear327:
;NodoAcelerometro.c,303 :: 		datosFIFO[y+(x*9)] = datosLeidos[y];                           //LLena la trama datosFIFO
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
;NodoAcelerometro.c,302 :: 		for (y=0;y<9;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,304 :: 		}
	GOTO	L_Muestrear74
L_Muestrear75:
;NodoAcelerometro.c,300 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,305 :: 		}
	GOTO	L_Muestrear71
L_Muestrear72:
;NodoAcelerometro.c,308 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear77:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Muestrear328
	GOTO	L_Muestrear78
L__Muestrear328:
;NodoAcelerometro.c,309 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Muestrear329
	GOTO	L__Muestrear248
L__Muestrear329:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Muestrear330
	GOTO	L__Muestrear247
L__Muestrear330:
	GOTO	L_Muestrear82
L__Muestrear248:
L__Muestrear247:
;NodoAcelerometro.c,310 :: 		tramaAceleracion[contFIFO+contMuestras+x] = contMuestras;          //Funciona bien
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
;NodoAcelerometro.c,311 :: 		tramaAceleracion[contFIFO+contMuestras+x+1] = datosFIFO[x];
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
;NodoAcelerometro.c,312 :: 		contMuestras++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contMuestras), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,313 :: 		} else {
	GOTO	L_Muestrear83
L_Muestrear82:
;NodoAcelerometro.c,314 :: 		tramaAceleracion[contFIFO+contMuestras+x] = datosFIFO[x];
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
;NodoAcelerometro.c,315 :: 		}
L_Muestrear83:
;NodoAcelerometro.c,308 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,316 :: 		}
	GOTO	L_Muestrear77
L_Muestrear78:
;NodoAcelerometro.c,320 :: 		contMuestras = 0;                                                      //Limpia el contador de muestras
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,321 :: 		contFIFO = 0;                                                          //Limpia el contador de FIFOs
	CLR	W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,322 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,324 :: 		GuardarTramaSD(tiempo, tramaAceleracion);
	MOV	#lo_addr(_tramaAceleracion), W11
	MOV	#lo_addr(_tiempo), W10
	CALL	_GuardarTramaSD
;NodoAcelerometro.c,327 :: 		}
L_Muestrear70:
L_Muestrear69:
;NodoAcelerometro.c,329 :: 		contCiclos++;                                                              //Incrementa el contador de ciclos
	MOV.B	#1, W1
	MOV	#lo_addr(_contCiclos), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,331 :: 		}
L_end_Muestrear:
	POP	W11
	POP	W10
	RETURN
; end of _Muestrear

_GuardarBufferSD:

;NodoAcelerometro.c,336 :: 		void GuardarBufferSD(unsigned char* bufferLleno, unsigned long sector){
;NodoAcelerometro.c,338 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarBufferSD84:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__GuardarBufferSD332
	GOTO	L_GuardarBufferSD85
L__GuardarBufferSD332:
;NodoAcelerometro.c,339 :: 		checkEscSD = SD_Write_Block(bufferLleno,sector);
	PUSH	W11
	PUSH	W12
	PUSH	W10
	CALL	_SD_Write_Block
	POP	W10
	POP	W12
	POP	W11
	MOV	#lo_addr(_checkEscSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,340 :: 		if (checkEscSD == DATA_ACCEPTED){
	CP.B	W0, #22
	BRA Z	L__GuardarBufferSD333
	GOTO	L_GuardarBufferSD87
L__GuardarBufferSD333:
;NodoAcelerometro.c,342 :: 		break;
	GOTO	L_GuardarBufferSD85
;NodoAcelerometro.c,343 :: 		}
L_GuardarBufferSD87:
;NodoAcelerometro.c,344 :: 		Delay_us(10);
	MOV	#80, W7
L_GuardarBufferSD88:
	DEC	W7
	BRA NZ	L_GuardarBufferSD88
	NOP
	NOP
;NodoAcelerometro.c,338 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,345 :: 		}
	GOTO	L_GuardarBufferSD84
L_GuardarBufferSD85:
;NodoAcelerometro.c,346 :: 		}
L_end_GuardarBufferSD:
	RETURN
; end of _GuardarBufferSD

_GuardarTramaSD:

;NodoAcelerometro.c,351 :: 		void GuardarTramaSD(unsigned char* tiempoSD, unsigned char* aceleracionSD){
;NodoAcelerometro.c,358 :: 		for (x=0;x<6;x++){
	PUSH	W12
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD90:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarTramaSD335
	GOTO	L_GuardarTramaSD91
L__GuardarTramaSD335:
;NodoAcelerometro.c,359 :: 		bufferSD[x] = cabeceraSD[x];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_cabeceraSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,358 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,360 :: 		}
	GOTO	L_GuardarTramaSD90
L_GuardarTramaSD91:
;NodoAcelerometro.c,362 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD93:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarTramaSD336
	GOTO	L_GuardarTramaSD94
L__GuardarTramaSD336:
;NodoAcelerometro.c,363 :: 		bufferSD[6+x] = tiempoSD[x];
	MOV	_x, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W10, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,362 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,364 :: 		}
	GOTO	L_GuardarTramaSD93
L_GuardarTramaSD94:
;NodoAcelerometro.c,366 :: 		for (x=0;x<500;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD96:
	MOV	_x, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD337
	GOTO	L_GuardarTramaSD97
L__GuardarTramaSD337:
;NodoAcelerometro.c,367 :: 		bufferSD[12+x] = aceleracionSD[x];
	MOV	_x, W0
	ADD	W0, #12, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W11, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,366 :: 		for (x=0;x<500;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,368 :: 		}
	GOTO	L_GuardarTramaSD96
L_GuardarTramaSD97:
;NodoAcelerometro.c,370 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,372 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,375 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD99:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD338
	GOTO	L_GuardarTramaSD100
L__GuardarTramaSD338:
;NodoAcelerometro.c,376 :: 		bufferSD[x] = aceleracionSD[x+500];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#500, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,375 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,377 :: 		}
	GOTO	L_GuardarTramaSD99
L_GuardarTramaSD100:
;NodoAcelerometro.c,378 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,379 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,382 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD102:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD339
	GOTO	L_GuardarTramaSD103
L__GuardarTramaSD339:
;NodoAcelerometro.c,383 :: 		bufferSD[x] = aceleracionSD[x+1012];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1012, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,382 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,384 :: 		}
	GOTO	L_GuardarTramaSD102
L_GuardarTramaSD103:
;NodoAcelerometro.c,385 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,386 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,389 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD105:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD340
	GOTO	L_GuardarTramaSD106
L__GuardarTramaSD340:
;NodoAcelerometro.c,390 :: 		bufferSD[x] = aceleracionSD[x+1524];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1524, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,389 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,391 :: 		}
	GOTO	L_GuardarTramaSD105
L_GuardarTramaSD106:
;NodoAcelerometro.c,392 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,393 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,396 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD108:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD341
	GOTO	L_GuardarTramaSD109
L__GuardarTramaSD341:
;NodoAcelerometro.c,397 :: 		if (x<464){
	MOV	_x, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD342
	GOTO	L_GuardarTramaSD111
L__GuardarTramaSD342:
;NodoAcelerometro.c,398 :: 		bufferSD[x] = aceleracionSD[x+2036];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#2036, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,399 :: 		} else {
	GOTO	L_GuardarTramaSD112
L_GuardarTramaSD111:
;NodoAcelerometro.c,400 :: 		bufferSD[x] = 0;
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,401 :: 		}
L_GuardarTramaSD112:
;NodoAcelerometro.c,396 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,402 :: 		}
	GOTO	L_GuardarTramaSD108
L_GuardarTramaSD109:
;NodoAcelerometro.c,403 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
;NodoAcelerometro.c,404 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,407 :: 		GuardarSectorSD(sectorSD);
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarSectorSD
	POP.D	W10
;NodoAcelerometro.c,409 :: 		TEST = 0;                                                               //Apaga el TEST cuando termina de gurdar la trama
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,411 :: 		}
L_end_GuardarTramaSD:
	POP	W12
	RETURN
; end of _GuardarTramaSD

_GuardarSectorSD:
	LNK	#512

;NodoAcelerometro.c,416 :: 		void GuardarSectorSD(unsigned long sector){
;NodoAcelerometro.c,421 :: 		bufferSectores[0] = (sector>>24)&0xFF;                                     //MSB variable sector
	PUSH	W12
	ADD	W14, #0, W5
	LSR	W11, #8, W2
	CLR	W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W5]
;NodoAcelerometro.c,422 :: 		bufferSectores[1] = (sector>>16)&0xFF;
	ADD	W5, #1, W4
	MOV	W11, W2
	CLR	W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W4]
;NodoAcelerometro.c,423 :: 		bufferSectores[2] = (sector>>8)&0xFF;
	ADD	W5, #2, W4
	LSR	W10, #8, W2
	SL	W11, #8, W3
	IOR	W2, W3, W2
	LSR	W11, #8, W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W4]
;NodoAcelerometro.c,424 :: 		bufferSectores[3] = (sector)&0xFF;                                         //LSD variable sector
	ADD	W5, #3, W2
	MOV	#255, W0
	MOV	#0, W1
	AND	W10, W0, W0
	MOV.B	W0, [W2]
;NodoAcelerometro.c,425 :: 		for (x=4;x<512;x++){
	MOV	#4, W0
	MOV	W0, _x
L_GuardarSectorSD113:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarSectorSD344
	GOTO	L_GuardarSectorSD114
L__GuardarSectorSD344:
;NodoAcelerometro.c,426 :: 		bufferSectores[x] = 0;                                                 //Rellena de ceros el resto del buffer
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,425 :: 		for (x=4;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,427 :: 		}
	GOTO	L_GuardarSectorSD113
L_GuardarSectorSD114:
;NodoAcelerometro.c,430 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarSectorSD116:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__GuardarSectorSD345
	GOTO	L_GuardarSectorSD117
L__GuardarSectorSD345:
;NodoAcelerometro.c,431 :: 		checkEscSD = SD_Write_Block(bufferSectores,sectorSave);
	ADD	W14, #0, W0
	PUSH.D	W10
	MOV	_sectorSave, W11
	MOV	_sectorSave+2, W12
	MOV	W0, W10
	CALL	_SD_Write_Block
	POP.D	W10
	MOV	#lo_addr(_checkEscSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,432 :: 		if (checkEscSD == DATA_ACCEPTED){
	CP.B	W0, #22
	BRA Z	L__GuardarSectorSD346
	GOTO	L_GuardarSectorSD119
L__GuardarSectorSD346:
;NodoAcelerometro.c,434 :: 		break;
	GOTO	L_GuardarSectorSD117
;NodoAcelerometro.c,435 :: 		}
L_GuardarSectorSD119:
;NodoAcelerometro.c,436 :: 		Delay_us(10);
	MOV	#80, W7
L_GuardarSectorSD120:
	DEC	W7
	BRA NZ	L_GuardarSectorSD120
	NOP
	NOP
;NodoAcelerometro.c,430 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,437 :: 		}
	GOTO	L_GuardarSectorSD116
L_GuardarSectorSD117:
;NodoAcelerometro.c,439 :: 		}
L_end_GuardarSectorSD:
	POP	W12
	ULNK
	RETURN
; end of _GuardarSectorSD

_UbicarUltimoSectorSD:
	LNK	#516

;NodoAcelerometro.c,444 :: 		unsigned long UbicarUltimoSectorSD(unsigned short sobrescribirSD){
;NodoAcelerometro.c,450 :: 		ptrSectorInicioSD = (unsigned char *) & sectorInicioSD;
	PUSH	W11
	PUSH	W12
	MOV	#512, W0
	ADD	W14, W0, W0
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,453 :: 		if (sobrescribirSD==1){
	CP.B	W10, #1
	BRA Z	L__UbicarUltimoSectorSD348
	GOTO	L_UbicarUltimoSectorSD122
L__UbicarUltimoSectorSD348:
; ptrSectorInicioSD end address is: 6 (W3)
;NodoAcelerometro.c,454 :: 		sectorInicioSD = PSE;                                                  //Se escoje el PSE para sobrescribir la SD
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,455 :: 		} else {
	GOTO	L_UbicarUltimoSectorSD123
L_UbicarUltimoSectorSD122:
;NodoAcelerometro.c,456 :: 		checkLecSD = 1;
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,458 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_UbicarUltimoSectorSD124:
; ptrSectorInicioSD start address is: 6 (W3)
; ptrSectorInicioSD end address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__UbicarUltimoSectorSD349
	GOTO	L_UbicarUltimoSectorSD125
L__UbicarUltimoSectorSD349:
; ptrSectorInicioSD end address is: 6 (W3)
;NodoAcelerometro.c,460 :: 		checkLecSD = SD_Read_Block(bufferSectorFinal, sectorSave);
; ptrSectorInicioSD start address is: 6 (W3)
	ADD	W14, #0, W0
	PUSH	W3
	PUSH	W10
	MOV	_sectorSave, W11
	MOV	_sectorSave+2, W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP	W10
	POP	W3
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,462 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__UbicarUltimoSectorSD350
	GOTO	L_UbicarUltimoSectorSD127
L__UbicarUltimoSectorSD350:
;NodoAcelerometro.c,464 :: 		*ptrSectorInicioSD = bufferSectorFinal[3];                      //LSB
	ADD	W14, #0, W2
	ADD	W2, #3, W0
	MOV.B	[W0], [W3]
;NodoAcelerometro.c,465 :: 		*(ptrSectorInicioSD+1) = bufferSectorFinal[2];
	ADD	W3, #1, W1
	ADD	W2, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,466 :: 		*(ptrSectorInicioSD+2) = bufferSectorFinal[1];
	ADD	W3, #2, W1
	ADD	W2, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,467 :: 		*(ptrSectorInicioSD+3) = bufferSectorFinal[0];                  //MSB
	ADD	W3, #3, W0
; ptrSectorInicioSD end address is: 6 (W3)
	MOV.B	[W2], [W0]
;NodoAcelerometro.c,468 :: 		break;
	GOTO	L_UbicarUltimoSectorSD125
;NodoAcelerometro.c,470 :: 		} else {
L_UbicarUltimoSectorSD127:
;NodoAcelerometro.c,471 :: 		sectorInicioSD = PSE;                                           //Si no pudo realizar la lectura procede a sobreescribir la SD
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,458 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,473 :: 		}
; ptrSectorInicioSD end address is: 6 (W3)
	GOTO	L_UbicarUltimoSectorSD124
L_UbicarUltimoSectorSD125:
;NodoAcelerometro.c,474 :: 		}
L_UbicarUltimoSectorSD123:
;NodoAcelerometro.c,476 :: 		return sectorInicioSD;
	MOV	[W14+512], W0
	MOV	[W14+514], W1
;NodoAcelerometro.c,478 :: 		}
;NodoAcelerometro.c,476 :: 		return sectorInicioSD;
;NodoAcelerometro.c,478 :: 		}
L_end_UbicarUltimoSectorSD:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _UbicarUltimoSectorSD

_recuperarDatosAceleracion:
	LNK	#516

;NodoAcelerometro.c,483 :: 		unsigned short recuperarDatosAceleracion(unsigned char* tramaPeticion){
;NodoAcelerometro.c,488 :: 		ptrSectorLec = (unsigned char *) & sectorLec;
	PUSH	W11
	PUSH	W12
	MOV	#512, W1
	ADD	W14, W1, W1
; ptrSectorLec start address is: 4 (W2)
	MOV	W1, W2
;NodoAcelerometro.c,491 :: 		*ptrSectorLec = tramaPeticion[4];                                       //LSB
	ADD	W10, #4, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,492 :: 		*(ptrSectorLec+1) = tramaPeticion[3];
	ADD	W2, #1, W1
	ADD	W10, #3, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,493 :: 		*(ptrSectorLec+2) = tramaPeticion[2];
	ADD	W2, #2, W1
	ADD	W10, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,494 :: 		*(ptrSectorLec+3) = tramaPeticion[1];                                   //MSB
	ADD	W2, #3, W1
; ptrSectorLec end address is: 4 (W2)
	ADD	W10, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,496 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,498 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_recuperarDatosAceleracion131:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__recuperarDatosAceleracion352
	GOTO	L_recuperarDatosAceleracion132
L__recuperarDatosAceleracion352:
;NodoAcelerometro.c,500 :: 		checkLecSD = SD_Read_Block(bufferSectorLeido, sectorLec);
	ADD	W14, #0, W0
	PUSH	W10
	MOV	[W14+512], W11
	MOV	[W14+514], W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP	W10
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,501 :: 		if (checkLecSD==0){
	CP.B	W0, #0
	BRA Z	L__recuperarDatosAceleracion353
	GOTO	L_recuperarDatosAceleracion134
L__recuperarDatosAceleracion353:
;NodoAcelerometro.c,502 :: 		break;
	GOTO	L_recuperarDatosAceleracion132
;NodoAcelerometro.c,503 :: 		}
L_recuperarDatosAceleracion134:
;NodoAcelerometro.c,498 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,504 :: 		}
	GOTO	L_recuperarDatosAceleracion131
L_recuperarDatosAceleracion132:
;NodoAcelerometro.c,506 :: 		if (checkLecSD==0) {
	MOV	#lo_addr(_checkLecSD), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__recuperarDatosAceleracion354
	GOTO	L_recuperarDatosAceleracion135
L__recuperarDatosAceleracion354:
;NodoAcelerometro.c,508 :: 		if ((bufferSectorLeido[0]==255)&&(bufferSectorLeido[1]==253)&&(bufferSectorLeido[1]==251)){
	ADD	W14, #0, W0
	MOV.B	[W0], W1
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA Z	L__recuperarDatosAceleracion355
	GOTO	L__recuperarDatosAceleracion252
L__recuperarDatosAceleracion355:
	ADD	W14, #0, W0
	INC	W0
	MOV.B	[W0], W1
	MOV.B	#253, W0
	CP.B	W1, W0
	BRA Z	L__recuperarDatosAceleracion356
	GOTO	L__recuperarDatosAceleracion251
L__recuperarDatosAceleracion356:
	ADD	W14, #0, W0
	INC	W0
	MOV.B	[W0], W1
	MOV.B	#251, W0
	CP.B	W1, W0
	BRA Z	L__recuperarDatosAceleracion357
	GOTO	L__recuperarDatosAceleracion250
L__recuperarDatosAceleracion357:
L__recuperarDatosAceleracion249:
;NodoAcelerometro.c,510 :: 		if (tramaPeticion[5]==0){
	ADD	W10, #5, W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__recuperarDatosAceleracion358
	GOTO	L_recuperarDatosAceleracion139
L__recuperarDatosAceleracion358:
;NodoAcelerometro.c,512 :: 		} else {
	GOTO	L_recuperarDatosAceleracion140
L_recuperarDatosAceleracion139:
;NodoAcelerometro.c,514 :: 		}
L_recuperarDatosAceleracion140:
;NodoAcelerometro.c,508 :: 		if ((bufferSectorLeido[0]==255)&&(bufferSectorLeido[1]==253)&&(bufferSectorLeido[1]==251)){
L__recuperarDatosAceleracion252:
L__recuperarDatosAceleracion251:
L__recuperarDatosAceleracion250:
;NodoAcelerometro.c,516 :: 		}
L_recuperarDatosAceleracion135:
;NodoAcelerometro.c,518 :: 		}
L_end_recuperarDatosAceleracion:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _recuperarDatosAceleracion

_GuardarPruebaSD:
	LNK	#2506

;NodoAcelerometro.c,523 :: 		void GuardarPruebaSD(unsigned char* tiempoSD){
;NodoAcelerometro.c,532 :: 		contadorEjemploSD = 0;
	PUSH	W11
	PUSH	W12
; contadorEjemploSD start address is: 4 (W2)
	CLR	W2
;NodoAcelerometro.c,533 :: 		for (x=0;x<2500;x++){
	CLR	W0
	MOV	W0, _x
; contadorEjemploSD end address is: 4 (W2)
L_GuardarPruebaSD141:
; contadorEjemploSD start address is: 4 (W2)
	MOV	_x, W1
	MOV	#2500, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD360
	GOTO	L_GuardarPruebaSD142
L__GuardarPruebaSD360:
;NodoAcelerometro.c,534 :: 		aceleracionSD[x] = contadorEjemploSD;
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
;NodoAcelerometro.c,535 :: 		contadorEjemploSD ++;
	ADD.B	W2, #1, W1
	MOV.B	W1, W2
;NodoAcelerometro.c,536 :: 		if (contadorEjemploSD >= 255){
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA GEU	L__GuardarPruebaSD361
	GOTO	L__GuardarPruebaSD253
L__GuardarPruebaSD361:
;NodoAcelerometro.c,537 :: 		contadorEjemploSD = 0;
	CLR	W2
; contadorEjemploSD end address is: 4 (W2)
;NodoAcelerometro.c,538 :: 		}
	GOTO	L_GuardarPruebaSD144
L__GuardarPruebaSD253:
;NodoAcelerometro.c,536 :: 		if (contadorEjemploSD >= 255){
;NodoAcelerometro.c,538 :: 		}
L_GuardarPruebaSD144:
;NodoAcelerometro.c,533 :: 		for (x=0;x<2500;x++){
; contadorEjemploSD start address is: 4 (W2)
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,539 :: 		}
; contadorEjemploSD end address is: 4 (W2)
	GOTO	L_GuardarPruebaSD141
L_GuardarPruebaSD142:
;NodoAcelerometro.c,542 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD145:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarPruebaSD362
	GOTO	L_GuardarPruebaSD146
L__GuardarPruebaSD362:
;NodoAcelerometro.c,543 :: 		bufferSD[x] = cabeceraSD[x];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_cabeceraSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,542 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,544 :: 		}
	GOTO	L_GuardarPruebaSD145
L_GuardarPruebaSD146:
;NodoAcelerometro.c,546 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD148:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarPruebaSD363
	GOTO	L_GuardarPruebaSD149
L__GuardarPruebaSD363:
;NodoAcelerometro.c,547 :: 		bufferSD[6+x] = tiempoSD[x];
	MOV	_x, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W10, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,546 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,548 :: 		}
	GOTO	L_GuardarPruebaSD148
L_GuardarPruebaSD149:
;NodoAcelerometro.c,550 :: 		for (x=0;x<500;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD151:
	MOV	_x, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD364
	GOTO	L_GuardarPruebaSD152
L__GuardarPruebaSD364:
;NodoAcelerometro.c,551 :: 		bufferSD[12+x] = aceleracionSD[x];
	MOV	_x, W0
	ADD	W0, #12, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,550 :: 		for (x=0;x<500;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,552 :: 		}
	GOTO	L_GuardarPruebaSD151
L_GuardarPruebaSD152:
;NodoAcelerometro.c,554 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,556 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,559 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD154:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD365
	GOTO	L_GuardarPruebaSD155
L__GuardarPruebaSD365:
;NodoAcelerometro.c,560 :: 		bufferSD[x] = aceleracionSD[x+500];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#500, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,559 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,561 :: 		}
	GOTO	L_GuardarPruebaSD154
L_GuardarPruebaSD155:
;NodoAcelerometro.c,562 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,563 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,566 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD157:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD366
	GOTO	L_GuardarPruebaSD158
L__GuardarPruebaSD366:
;NodoAcelerometro.c,567 :: 		bufferSD[x] = aceleracionSD[x+1012];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1012, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,566 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,568 :: 		}
	GOTO	L_GuardarPruebaSD157
L_GuardarPruebaSD158:
;NodoAcelerometro.c,569 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,570 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,573 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD160:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD367
	GOTO	L_GuardarPruebaSD161
L__GuardarPruebaSD367:
;NodoAcelerometro.c,574 :: 		bufferSD[x] = aceleracionSD[x+1524];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1524, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,573 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,575 :: 		}
	GOTO	L_GuardarPruebaSD160
L_GuardarPruebaSD161:
;NodoAcelerometro.c,576 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,577 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,580 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD163:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD368
	GOTO	L_GuardarPruebaSD164
L__GuardarPruebaSD368:
;NodoAcelerometro.c,581 :: 		if (x<464){
	MOV	_x, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD369
	GOTO	L_GuardarPruebaSD166
L__GuardarPruebaSD369:
;NodoAcelerometro.c,582 :: 		bufferSD[x] = aceleracionSD[x+2036];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#2036, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,583 :: 		} else {
	GOTO	L_GuardarPruebaSD167
L_GuardarPruebaSD166:
;NodoAcelerometro.c,584 :: 		bufferSD[x] = 0;
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,585 :: 		}
L_GuardarPruebaSD167:
;NodoAcelerometro.c,580 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,586 :: 		}
	GOTO	L_GuardarPruebaSD163
L_GuardarPruebaSD164:
;NodoAcelerometro.c,587 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
;NodoAcelerometro.c,588 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,591 :: 		GuardarSectorSD(sectorSD);
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarSectorSD
	POP	W10
;NodoAcelerometro.c,593 :: 		TEST = 0;                                                               //Apaga el TEST cuando termina de gurdar la trama
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,595 :: 		}
L_end_GuardarPruebaSD:
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

;NodoAcelerometro.c,606 :: 		void int_1() org IVT_ADDR_INT1INTERRUPT {
;NodoAcelerometro.c,608 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;NodoAcelerometro.c,610 :: 		if (banSetReloj==1){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1371
	GOTO	L_int_1168
L__int_1371:
;NodoAcelerometro.c,611 :: 		horaSistema++;                                                          //Incrementa el reloj del sistema
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaSistema), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,612 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza la trama de tiempo
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;NodoAcelerometro.c,613 :: 		TEST = ~TEST;
	BTG	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,614 :: 		} else {
	GOTO	L_int_1169
L_int_1168:
;NodoAcelerometro.c,616 :: 		}
L_int_1169:
;NodoAcelerometro.c,618 :: 		if (horaSistema==86400){                                                   //(24*3600)+(0*60)+(0) = 86400
	MOV	_horaSistema, W2
	MOV	_horaSistema+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__int_1372
	GOTO	L_int_1170
L__int_1372:
;NodoAcelerometro.c,619 :: 		horaSistema = 0;                                                        //Reinicia el reloj al llegar a las 24:00:00 horas
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,621 :: 		fechaSistema = IncrementarFecha(fechaSistema);                          //Incrementa la fecha del sistema
	MOV	_fechaSistema, W10
	MOV	_fechaSistema+2, W11
	CALL	_IncrementarFecha
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,622 :: 		}
L_int_1170:
;NodoAcelerometro.c,624 :: 		if (banInicioMuestreo==1){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1373
	GOTO	L_int_1171
L__int_1373:
;NodoAcelerometro.c,625 :: 		Muestrear();
	CALL	_Muestrear
;NodoAcelerometro.c,630 :: 		}
L_int_1171:
;NodoAcelerometro.c,632 :: 		}
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

;NodoAcelerometro.c,637 :: 		void Timer1Int() org IVT_ADDR_T1INTERRUPT{
;NodoAcelerometro.c,639 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer1
	PUSH	W10
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;NodoAcelerometro.c,641 :: 		numFIFO = ADXL355_read_byte(FIFO_ENTRIES); //75                            //Lee el numero de muestras disponibles en el FIFO
	MOV.B	#5, W10
	CALL	_ADXL355_read_byte
	MOV	#lo_addr(_numFIFO), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,642 :: 		numSetsFIFO = (numFIFO)/3;                 //25                            //Lee el numero de sets disponibles en el FIFO
	ZE	W0, W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(_numSetsFIFO), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,645 :: 		for (x=0;x<numSetsFIFO;x++){
	CLR	W0
	MOV	W0, _x
L_Timer1Int172:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Timer1Int375
	GOTO	L_Timer1Int173
L__Timer1Int375:
;NodoAcelerometro.c,646 :: 		ADXL355_read_FIFO(datosLeidos);                                        //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,647 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Timer1Int175:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Timer1Int376
	GOTO	L_Timer1Int176
L__Timer1Int376:
;NodoAcelerometro.c,648 :: 		datosFIFO[y+(x*9)] = datosLeidos[y];                               //LLena la trama datosFIFO
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
;NodoAcelerometro.c,647 :: 		for (y=0;y<9;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,649 :: 		}
	GOTO	L_Timer1Int175
L_Timer1Int176:
;NodoAcelerometro.c,645 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,650 :: 		}
	GOTO	L_Timer1Int172
L_Timer1Int173:
;NodoAcelerometro.c,653 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	CLR	W0
	MOV	W0, _x
L_Timer1Int178:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Timer1Int377
	GOTO	L_Timer1Int179
L__Timer1Int377:
;NodoAcelerometro.c,654 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int378
	GOTO	L__Timer1Int256
L__Timer1Int378:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int379
	GOTO	L__Timer1Int255
L__Timer1Int379:
	GOTO	L_Timer1Int183
L__Timer1Int256:
L__Timer1Int255:
;NodoAcelerometro.c,655 :: 		tramaAceleracion[contFIFO+contMuestras+x] = contMuestras;
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
;NodoAcelerometro.c,656 :: 		tramaAceleracion[contFIFO+contMuestras+x+1] = datosFIFO[x];
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
;NodoAcelerometro.c,657 :: 		contMuestras++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contMuestras), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,658 :: 		} else {
	GOTO	L_Timer1Int184
L_Timer1Int183:
;NodoAcelerometro.c,659 :: 		tramaAceleracion[contFIFO+contMuestras+x] = datosFIFO[x];
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
;NodoAcelerometro.c,660 :: 		}
L_Timer1Int184:
;NodoAcelerometro.c,653 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,661 :: 		}
	GOTO	L_Timer1Int178
L_Timer1Int179:
;NodoAcelerometro.c,663 :: 		contFIFO = (contMuestras*9);                                               //Incrementa el contador de FIFOs
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,665 :: 		contTimer1++;                                                              //Incrementa una unidad cada vez que entra a la interrupcion por Timer1
	MOV.B	#1, W1
	MOV	#lo_addr(_contTimer1), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,667 :: 		if (contTimer1==numTMR1){                                                  //Verifica si se cumplio el numero de interrupciones por TMR1 para la tasa de muestreo seleccionada
	MOV	#lo_addr(_contTimer1), W0
	ZE	[W0], W1
	MOV	#lo_addr(_numTMR1), W0
	SE	[W0], W0
	CP	W1, W0
	BRA Z	L__Timer1Int380
	GOTO	L_Timer1Int185
L__Timer1Int380:
;NodoAcelerometro.c,668 :: 		T1CON.TON = 0;                                                          //Apaga el Timer1
	BCLR	T1CON, #15
;NodoAcelerometro.c,669 :: 		banCiclo = 1;                                                           //Activa la bandera que indica que se completo un ciclo de medicion
	MOV	#lo_addr(_banCiclo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,670 :: 		contTimer1 = 0;                                                         //Limpia el contador de interrupciones por Timer1
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,671 :: 		}
L_Timer1Int185:
;NodoAcelerometro.c,673 :: 		}
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

;NodoAcelerometro.c,678 :: 		void urx_1() org  IVT_ADDR_U1RXINTERRUPT {
;NodoAcelerometro.c,681 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
	PUSH	W10
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;NodoAcelerometro.c,682 :: 		byteRS485 = U1RXREG;
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	U1RXREG, WREG
	MOV.B	W0, [W1]
;NodoAcelerometro.c,683 :: 		OERR_bit = 0;                                                              //Limpia este bit para limpiar el FIFO UART
	BCLR	OERR_bit, BitPos(OERR_bit+0)
;NodoAcelerometro.c,686 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_1382
	GOTO	L_urx_1186
L__urx_1382:
;NodoAcelerometro.c,687 :: 		if (i_rs485<numDatosRS485){
	MOV	_i_rs485, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__urx_1383
	GOTO	L_urx_1187
L__urx_1383:
;NodoAcelerometro.c,688 :: 		inputPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,689 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,690 :: 		} else {
	GOTO	L_urx_1188
L_urx_1187:
;NodoAcelerometro.c,692 :: 		banRSI = 0;                                                          //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,693 :: 		banRSC = 1;                                                          //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,694 :: 		}
L_urx_1188:
;NodoAcelerometro.c,695 :: 		}
L_urx_1186:
;NodoAcelerometro.c,698 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1384
	GOTO	L__urx_1262
L__urx_1384:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1385
	GOTO	L__urx_1261
L__urx_1385:
L__urx_1260:
;NodoAcelerometro.c,699 :: 		if (byteRS485==0x3A){                                                   //Verifica si el primer byte recibido sea la cabecera de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__urx_1386
	GOTO	L_urx_1192
L__urx_1386:
;NodoAcelerometro.c,701 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,702 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,703 :: 		}
L_urx_1192:
;NodoAcelerometro.c,698 :: 		if ((banRSI==0)&&(banRSC==0)){
L__urx_1262:
L__urx_1261:
;NodoAcelerometro.c,705 :: 		if ((banRSI==1)&&(i_rs485<5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1387
	GOTO	L__urx_1264
L__urx_1387:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA LTU	L__urx_1388
	GOTO	L__urx_1263
L__urx_1388:
L__urx_1259:
;NodoAcelerometro.c,706 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                                //Recupera los datos de cabecera de la trama UART: [0x3A, Direccion, Funcion, Subfuncion, NumeroDatos]
	MOV	#lo_addr(_tramaCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,707 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,705 :: 		if ((banRSI==1)&&(i_rs485<5)){
L__urx_1264:
L__urx_1263:
;NodoAcelerometro.c,709 :: 		if ((banRSI==1)&&(i_rs485==5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1389
	GOTO	L__urx_1268
L__urx_1389:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA Z	L__urx_1390
	GOTO	L__urx_1267
L__urx_1390:
L__urx_1258:
;NodoAcelerometro.c,711 :: 		if ((tramaCabeceraRS485[1]==IDNODO)||(tramaCabeceraRS485[1]==255)){
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA NZ	L__urx_1391
	GOTO	L__urx_1266
L__urx_1391:
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W1
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1392
	GOTO	L__urx_1265
L__urx_1392:
	GOTO	L_urx_1201
L__urx_1266:
L__urx_1265:
;NodoAcelerometro.c,713 :: 		funcionRS485 = tramaCabeceraRS485[2];
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_tramaCabeceraRS485+2), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,714 :: 		subFuncionRS485 = tramaCabeceraRS485[3];
	MOV	#lo_addr(_subFuncionRS485), W1
	MOV	#lo_addr(_tramaCabeceraRS485+3), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,715 :: 		numDatosRS485 = tramaCabeceraRS485[4];
	MOV	#lo_addr(_tramaCabeceraRS485+4), W0
	ZE	[W0], W0
	MOV	W0, _numDatosRS485
;NodoAcelerometro.c,716 :: 		banRSI = 2;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,717 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,718 :: 		} else {
	GOTO	L_urx_1202
L_urx_1201:
;NodoAcelerometro.c,719 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,720 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,721 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,722 :: 		}
L_urx_1202:
;NodoAcelerometro.c,709 :: 		if ((banRSI==1)&&(i_rs485==5)){
L__urx_1268:
L__urx_1267:
;NodoAcelerometro.c,726 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1393
	GOTO	L_urx_1203
L__urx_1393:
;NodoAcelerometro.c,728 :: 		switch (funcionRS485){
	GOTO	L_urx_1204
;NodoAcelerometro.c,729 :: 		case 0xF1:
L_urx_1206:
;NodoAcelerometro.c,731 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1394
	GOTO	L_urx_1207
L__urx_1394:
;NodoAcelerometro.c,732 :: 		for (x=0;x<6;x++) {
	CLR	W0
	MOV	W0, _x
L_urx_1208:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1395
	GOTO	L_urx_1209
L__urx_1395:
;NodoAcelerometro.c,733 :: 		tiempo[x] = inputPyloadRS485[x];                    //LLena la trama tiempo con el payload de la trama recuperada
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,732 :: 		for (x=0;x<6;x++) {
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,734 :: 		}
	GOTO	L_urx_1208
L_urx_1209:
;NodoAcelerometro.c,735 :: 		horaSistema = RecuperarHoraRPI(tiempo);                 //Recupera la hora de la RPi
	MOV	#lo_addr(_tiempo), W10
	CALL	_RecuperarHoraRPI
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,736 :: 		fechaSistema = RecuperarFechaRPI(tiempo);               //Recupera la fecha de la RPi
	MOV	#lo_addr(_tiempo), W10
	CALL	_RecuperarFechaRPI
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,737 :: 		banSetReloj = 1;                                        //Activa la bandera para indicar que se establecio la hora y fecha
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,738 :: 		}
L_urx_1207:
;NodoAcelerometro.c,740 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1396
	GOTO	L_urx_1211
L__urx_1396:
;NodoAcelerometro.c,742 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_urx_1212:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1397
	GOTO	L_urx_1213
L__urx_1397:
;NodoAcelerometro.c,743 :: 		outputPyloadRS485[x] = tiempo[x];
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,742 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,744 :: 		}
	GOTO	L_urx_1212
L_urx_1213:
;NodoAcelerometro.c,747 :: 		INT1IE_bit = 0;
	BCLR	INT1IE_bit, BitPos(INT1IE_bit+0)
;NodoAcelerometro.c,749 :: 		}
L_urx_1211:
;NodoAcelerometro.c,750 :: 		break;
	GOTO	L_urx_1205
;NodoAcelerometro.c,752 :: 		case 0xF2:
L_urx_1215:
;NodoAcelerometro.c,754 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1398
	GOTO	L_urx_1216
L__urx_1398:
;NodoAcelerometro.c,755 :: 		sectorSD = UbicarUltimoSectorSD(inputPyloadRS485[0]);   //inputPyloadRS485[0] = sobrescribir (0=no, 1=si)
	MOV	#lo_addr(_inputPyloadRS485), W0
	MOV.B	[W0], W10
	CALL	_UbicarUltimoSectorSD
	MOV	W0, _sectorSD
	MOV	W1, _sectorSD+2
;NodoAcelerometro.c,756 :: 		banInicioMuestreo = 1;                                  //Activa la bandera para iniciar el muestreo
	MOV	#lo_addr(_banInicioMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,757 :: 		}
L_urx_1216:
;NodoAcelerometro.c,759 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1399
	GOTO	L_urx_1217
L__urx_1399:
;NodoAcelerometro.c,760 :: 		banInicioMuestreo = 0;                                   //Limpia la bandera para detener el muestreo
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,761 :: 		}
L_urx_1217:
;NodoAcelerometro.c,762 :: 		break;
	GOTO	L_urx_1205
;NodoAcelerometro.c,764 :: 		case 0xF3:
L_urx_1218:
;NodoAcelerometro.c,766 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1400
	GOTO	L_urx_1219
L__urx_1400:
;NodoAcelerometro.c,768 :: 		}
L_urx_1219:
;NodoAcelerometro.c,770 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1401
	GOTO	L_urx_1220
L__urx_1401:
;NodoAcelerometro.c,772 :: 		}
L_urx_1220:
;NodoAcelerometro.c,774 :: 		if (subFuncionRS485==0xD3){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#211, W0
	CP.B	W1, W0
	BRA Z	L__urx_1402
	GOTO	L_urx_1221
L__urx_1402:
;NodoAcelerometro.c,776 :: 		}
L_urx_1221:
;NodoAcelerometro.c,777 :: 		break;
	GOTO	L_urx_1205
;NodoAcelerometro.c,779 :: 		}
L_urx_1204:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1403
	GOTO	L_urx_1206
L__urx_1403:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1404
	GOTO	L_urx_1215
L__urx_1404:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1405
	GOTO	L_urx_1218
L__urx_1405:
L_urx_1205:
;NodoAcelerometro.c,781 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,782 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,784 :: 		}
L_urx_1203:
;NodoAcelerometro.c,786 :: 		}
L_end_urx_1:
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
