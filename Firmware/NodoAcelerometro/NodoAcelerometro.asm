
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
	BRA NZ	L__ADXL355_init320
	GOTO	L_ADXL355_init4
L__ADXL355_init320:
	CP.B	W10, #2
	BRA NZ	L__ADXL355_init321
	GOTO	L_ADXL355_init5
L__ADXL355_init321:
	CP.B	W10, #4
	BRA NZ	L__ADXL355_init322
	GOTO	L_ADXL355_init6
L__ADXL355_init322:
	CP.B	W10, #8
	BRA NZ	L__ADXL355_init323
	GOTO	L_ADXL355_init7
L__ADXL355_init323:
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
	BRA Z	L__ADXL355_read_data327
	GOTO	L_ADXL355_read_data8
L__ADXL355_read_data327:
;adxl355_spi.c,152 :: 		CS_ADXL355=0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;adxl355_spi.c,153 :: 		for (j=0;j<9;j++){
; j start address is: 4 (W2)
	CLR	W2
; j end address is: 4 (W2)
L_ADXL355_read_data9:
; j start address is: 4 (W2)
	CP.B	W2, #9
	BRA LTU	L__ADXL355_read_data328
	GOTO	L_ADXL355_read_data10
L__ADXL355_read_data328:
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
	BRA LTU	L__ADXL355_read_data329
	GOTO	L_ADXL355_read_data14
L__ADXL355_read_data329:
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
	BRA LTU	L__IncrementarFecha338
	GOTO	L_IncrementarFecha18
L__IncrementarFecha338:
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
	BRA Z	L__IncrementarFecha339
	GOTO	L_IncrementarFecha20
L__IncrementarFecha339:
;tiempo_rtc.c,202 :: 		if (((anio-16)%4)==0){
	SUB	W2, #16, W0
	SUBB	W3, #0, W1
	AND	W0, #3, W0
	AND	W1, #0, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__IncrementarFecha340
	GOTO	L_IncrementarFecha21
L__IncrementarFecha340:
;tiempo_rtc.c,203 :: 		if (dia==29){
	CP	W6, #29
	CPB	W7, #0
	BRA Z	L__IncrementarFecha341
	GOTO	L_IncrementarFecha22
L__IncrementarFecha341:
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
	BRA LTU	L__IncrementarFecha342
	GOTO	L_IncrementarFecha26
L__IncrementarFecha342:
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
	BRA NZ	L__IncrementarFecha343
	GOTO	L__IncrementarFecha276
L__IncrementarFecha343:
	CP	W4, #6
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha344
	GOTO	L__IncrementarFecha275
L__IncrementarFecha344:
	CP	W4, #9
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha345
	GOTO	L__IncrementarFecha274
L__IncrementarFecha345:
	CP	W4, #11
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha346
	GOTO	L__IncrementarFecha273
L__IncrementarFecha346:
	MOV.D	W4, W0
	MOV.D	W6, W4
	GOTO	L_IncrementarFecha30
L__IncrementarFecha276:
L__IncrementarFecha275:
L__IncrementarFecha274:
L__IncrementarFecha273:
;tiempo_rtc.c,218 :: 		if (dia==30){
	CP	W6, #30
	CPB	W7, #0
	BRA Z	L__IncrementarFecha347
	GOTO	L_IncrementarFecha31
L__IncrementarFecha347:
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
	BRA NZ	L__IncrementarFecha348
	GOTO	L__IncrementarFecha286
L__IncrementarFecha348:
	CP	W0, #1
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha349
	GOTO	L__IncrementarFecha282
L__IncrementarFecha349:
	CP	W0, #3
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha350
	GOTO	L__IncrementarFecha281
L__IncrementarFecha350:
	CP	W0, #5
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha351
	GOTO	L__IncrementarFecha280
L__IncrementarFecha351:
	CP	W0, #7
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha352
	GOTO	L__IncrementarFecha279
L__IncrementarFecha352:
	CP	W0, #8
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha353
	GOTO	L__IncrementarFecha278
L__IncrementarFecha353:
	CP	W0, #10
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha354
	GOTO	L__IncrementarFecha277
L__IncrementarFecha354:
	GOTO	L_IncrementarFecha37
L__IncrementarFecha282:
L__IncrementarFecha281:
L__IncrementarFecha280:
L__IncrementarFecha279:
L__IncrementarFecha278:
L__IncrementarFecha277:
L__IncrementarFecha270:
;tiempo_rtc.c,226 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha355
	GOTO	L_IncrementarFecha38
L__IncrementarFecha355:
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
	GOTO	L__IncrementarFecha283
L__IncrementarFecha286:
L__IncrementarFecha283:
;tiempo_rtc.c,233 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha356
	GOTO	L__IncrementarFecha287
L__IncrementarFecha356:
	CP	W0, #12
	CPB	W1, #0
	BRA Z	L__IncrementarFecha357
	GOTO	L__IncrementarFecha288
L__IncrementarFecha357:
L__IncrementarFecha269:
;tiempo_rtc.c,234 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha358
	GOTO	L_IncrementarFecha43
L__IncrementarFecha358:
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
	GOTO	L__IncrementarFecha285
L__IncrementarFecha287:
L__IncrementarFecha285:
; mes start address is: 0 (W0)
; anio start address is: 4 (W2)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha284
L__IncrementarFecha288:
L__IncrementarFecha284:
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
	BRA Z	L__EnviarTramaRS485361
	GOTO	L__EnviarTramaRS485289
L__EnviarTramaRS485361:
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
	BRA LTU	L__EnviarTramaRS485362
	GOTO	L_EnviarTramaRS48547
L__EnviarTramaRS485362:
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
; numDatosMSB end address is: 2 (W1)
; numDatosLSB end address is: 8 (W4)
; payload end address is: 4 (W2)
	POP	W10
	MOV.B	W1, W3
	MOV	W2, W1
	MOV.B	W4, W2
;rs485.c,42 :: 		while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48549:
; payload start address is: 2 (W1)
; numDatosLSB start address is: 4 (W2)
; numDatosMSB start address is: 6 (W3)
	CALL	_UART1_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485363
	GOTO	L_EnviarTramaRS48550
L__EnviarTramaRS485363:
	GOTO	L_EnviarTramaRS48549
L_EnviarTramaRS48550:
;rs485.c,43 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
; numDatosMSB end address is: 6 (W3)
; numDatosLSB end address is: 4 (W2)
; payload end address is: 2 (W1)
	MOV.B	W3, W0
;rs485.c,44 :: 		}
	GOTO	L_EnviarTramaRS48545
L__EnviarTramaRS485289:
;rs485.c,30 :: 		if (puertoUART == 1){
	MOV.B	W1, W0
	MOV	W2, W1
	MOV.B	W4, W2
;rs485.c,44 :: 		}
L_EnviarTramaRS48545:
;rs485.c,46 :: 		if (puertoUART == 2){
; numDatosMSB start address is: 0 (W0)
; numDatosLSB start address is: 4 (W2)
; payload start address is: 2 (W1)
	CP.B	W10, #2
	BRA Z	L__EnviarTramaRS485364
	GOTO	L_EnviarTramaRS48551
L__EnviarTramaRS485364:
;rs485.c,47 :: 		MSRS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSET	MSRS485, BitPos(MSRS485+0)
;rs485.c,48 :: 		UART2_Write(0x3A);                                                      //Envia la cabecera de la trama
	PUSH	W10
	MOV	#58, W10
	CALL	_UART2_Write
;rs485.c,49 :: 		UART2_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W11, W10
	CALL	_UART2_Write
;rs485.c,50 :: 		UART2_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W12, W10
	CALL	_UART2_Write
;rs485.c,51 :: 		UART2_Write(numDatosLSB);                                               //Envia el LSB del numero de datos
; numDatosLSB end address is: 4 (W2)
	ZE	W2, W10
	CALL	_UART2_Write
;rs485.c,52 :: 		UART2_Write(numDatosMSB);                                               //Envia el MSB del numero de datos
; numDatosMSB end address is: 0 (W0)
	ZE	W0, W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,53 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 4 (W2)
	CLR	W2
; iDatos end address is: 4 (W2)
L_EnviarTramaRS48552:
; iDatos start address is: 4 (W2)
; payload start address is: 2 (W1)
; payload end address is: 2 (W1)
	CP	W2, W13
	BRA LTU	L__EnviarTramaRS485365
	GOTO	L_EnviarTramaRS48553
L__EnviarTramaRS485365:
; payload end address is: 2 (W1)
;rs485.c,54 :: 		UART2_Write(payload[iDatos]);
; payload start address is: 2 (W1)
	ADD	W1, W2, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,53 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W2
;rs485.c,55 :: 		}
; payload end address is: 2 (W1)
; iDatos end address is: 4 (W2)
	GOTO	L_EnviarTramaRS48552
L_EnviarTramaRS48553:
;rs485.c,56 :: 		UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART2_Write
;rs485.c,57 :: 		UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,58 :: 		while(UART2_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48555:
	CALL	_UART2_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485366
	GOTO	L_EnviarTramaRS48556
L__EnviarTramaRS485366:
	GOTO	L_EnviarTramaRS48555
L_EnviarTramaRS48556:
;rs485.c,59 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
;rs485.c,60 :: 		}
L_EnviarTramaRS48551:
;rs485.c,62 :: 		}
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

;NodoAcelerometro.c,116 :: 		void main() {
;NodoAcelerometro.c,118 :: 		ConfiguracionPrincipal();
	PUSH	W10
	CALL	_ConfiguracionPrincipal
;NodoAcelerometro.c,119 :: 		TEST = 0;                                                                                                                                        //Pin de TEST
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,121 :: 		tasaMuestreo = 1;                                                          //1=250Hz, 2=125Hz, 4=62.5Hz, 8=31.25Hz
	MOV	#lo_addr(_tasaMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,122 :: 		ADXL355_init(tasaMuestreo);                                                //Inicializa el modulo ADXL con la tasa de muestreo requerida:
	MOV.B	#1, W10
	CALL	_ADXL355_init
;NodoAcelerometro.c,123 :: 		numTMR1 = (tasaMuestreo*10)-1;                                             //Calcula el numero de veces que tienen que desbordarse el TMR1 para cada tasa de muestreo
	MOV	#lo_addr(_tasaMuestreo), W0
	SE	[W0], W1
	MOV	#10, W0
	MUL.UU	W1, W0, W2
	MOV	#lo_addr(_numTMR1), W0
	SUB.B	W2, #1, [W0]
;NodoAcelerometro.c,128 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;NodoAcelerometro.c,129 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;NodoAcelerometro.c,130 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;NodoAcelerometro.c,131 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;NodoAcelerometro.c,134 :: 		inicioSistema = 0;
	MOV	#lo_addr(_inicioSistema), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,137 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,138 :: 		horaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,139 :: 		fechaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,142 :: 		banCiclo = 0;
	MOV	#lo_addr(_banCiclo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,143 :: 		banInicioMuestreo = 0;
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,144 :: 		numFIFO = 0;
	MOV	#lo_addr(_numFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,145 :: 		numSetsFIFO = 0;
	MOV	#lo_addr(_numSetsFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,146 :: 		contTimer1 = 0;
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,147 :: 		contMuestras = 0;
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,148 :: 		contCiclos = 0;
	MOV	#lo_addr(_contCiclos), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,149 :: 		contFIFO = 0;
	CLR	W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,152 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,153 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,154 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,155 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,156 :: 		funcionRS485 = 0;
	MOV	#lo_addr(_funcionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,157 :: 		subFuncionRS485 = 0;
	MOV	#lo_addr(_subFuncionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,158 :: 		numDatosRS485 = 0;
	CLR	W0
	MOV	W0, _numDatosRS485
;NodoAcelerometro.c,159 :: 		ptrnumDatosRS485 = (unsigned char *) & numDatosRS485;
	MOV	#lo_addr(_numDatosRS485), W0
	MOV	W0, _ptrnumDatosRS485
;NodoAcelerometro.c,160 :: 		ptrsectorReq = (unsigned char *) & sectorReq;
	MOV	#lo_addr(_sectorReq), W0
	MOV	W0, _ptrsectorReq
;NodoAcelerometro.c,163 :: 		PSEC = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _PSEC
	MOV	W1, _PSEC+2
;NodoAcelerometro.c,164 :: 		sectorSD = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _sectorSD
	MOV	W1, _sectorSD+2
;NodoAcelerometro.c,165 :: 		sectorLec = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _sectorLec
	MOV	W1, _sectorLec+2
;NodoAcelerometro.c,166 :: 		checkEscSD = 0;
	MOV	#lo_addr(_checkEscSD), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,167 :: 		checkLecSD = 0;
	MOV	#lo_addr(_checkLecSD), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,168 :: 		MSRS485 = 0;                                                               //Estabkece el Max485 en modo lectura
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;NodoAcelerometro.c,192 :: 		sdflags.detected = true;
	MOV	#lo_addr(_sdflags), W0
	BSET.B	[W0], #1
;NodoAcelerometro.c,195 :: 		if (sdflags.detected && !sdflags.init_ok) {
	MOV	#lo_addr(_sdflags), W0
	MOV.B	[W0], W0
	BTSS.B	W0, #1
	GOTO	L__main292
	MOV	#lo_addr(_sdflags), W0
	MOV.B	[W0], W0
	BTSC.B	W0, #0
	GOTO	L__main291
L__main290:
;NodoAcelerometro.c,196 :: 		if (SD_Init_Try(10) == SUCCESSFUL_INIT) {
	MOV.B	#10, W10
	CALL	_SD_Init_Try
	MOV.B	#170, W1
	CP.B	W0, W1
	BRA Z	L__main370
	GOTO	L_main60
L__main370:
;NodoAcelerometro.c,197 :: 		sdflags.init_ok = true;
	MOV	#lo_addr(_sdflags), W0
	BSET.B	[W0], #0
;NodoAcelerometro.c,198 :: 		inicioSistema = 1;                                                //Activa la bandera para permitir el inicio del sistema
	MOV	#lo_addr(_inicioSistema), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,199 :: 		TEST = 1;
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,200 :: 		} else {
	GOTO	L_main61
L_main60:
;NodoAcelerometro.c,201 :: 		sdflags.init_ok = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #0
;NodoAcelerometro.c,202 :: 		INT1IE_bit = 0;                                                   //Desabilita la interrupcion externa INT1
	BCLR	INT1IE_bit, BitPos(INT1IE_bit+0)
;NodoAcelerometro.c,203 :: 		U1MODE.UARTEN = 0;                                                //Desabilita el UART
	BCLR	U1MODE, #15
;NodoAcelerometro.c,204 :: 		inicioSistema = 0;                                                //Apaga la bandera de inicio del sistema
	MOV	#lo_addr(_inicioSistema), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,205 :: 		TEST = 0;
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,206 :: 		}
L_main61:
;NodoAcelerometro.c,195 :: 		if (sdflags.detected && !sdflags.init_ok) {
L__main292:
L__main291:
;NodoAcelerometro.c,208 :: 		Delay_ms(2000);
	MOV	#245, W8
	MOV	#9362, W7
L_main62:
	DEC	W7
	BRA NZ	L_main62
	DEC	W8
	BRA NZ	L_main62
	NOP
;NodoAcelerometro.c,211 :: 		while(1){
L_main64:
;NodoAcelerometro.c,214 :: 		}
	GOTO	L_main64
;NodoAcelerometro.c,216 :: 		}
L_end_main:
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;NodoAcelerometro.c,224 :: 		void ConfiguracionPrincipal(){
;NodoAcelerometro.c,227 :: 		CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	CLKDIVbits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, CLKDIVbits
;NodoAcelerometro.c,228 :: 		CLKDIVbits.PLLPOST = 0;                                                    //N2=2
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,229 :: 		CLKDIVbits.PLLPRE = 5;                                                     //N1=7
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,230 :: 		PLLFBDbits.PLLDIV = 150;                                                   //M=152
	MOV	#150, W0
	MOV	W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	#511, W0
	AND	W1, W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	W1, PLLFBDbits
;NodoAcelerometro.c,233 :: 		ANSELA = 0;                                                                //Configura PORTA como digital     *
	CLR	ANSELA
;NodoAcelerometro.c,234 :: 		ANSELB = 0;                                                                //Configura PORTB como digital     *
	CLR	ANSELB
;NodoAcelerometro.c,235 :: 		TEST_Direction = 0;                                                        //TEST
	BCLR	TRISA2_bit, BitPos(TRISA2_bit+0)
;NodoAcelerometro.c,236 :: 		CsADXL_Direction = 0;                                                      //CS ADXL
	BCLR	TRISA3_bit, BitPos(TRISA3_bit+0)
;NodoAcelerometro.c,237 :: 		sd_CS_tris = 0;                                                            //CS SD
	BCLR	TRISB0_bit, BitPos(TRISB0_bit+0)
;NodoAcelerometro.c,238 :: 		MSRS485_Direction = 0;                                                     //MAX485 MS
	BCLR	TRISB12_bit, BitPos(TRISB12_bit+0)
;NodoAcelerometro.c,239 :: 		sd_detect_tris = 1;                                                        //Pin detection SD
	BSET	TRISA4_bit, BitPos(TRISA4_bit+0)
;NodoAcelerometro.c,240 :: 		TRISB14_bit = 1;                                                           //Pin de interrupcion
	BSET	TRISB14_bit, BitPos(TRISB14_bit+0)
;NodoAcelerometro.c,243 :: 		INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales
	BSET	INTCON2, #15
;NodoAcelerometro.c,246 :: 		RPINR18bits.U1RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx1
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
;NodoAcelerometro.c,247 :: 		RPOR1bits.RP36R = 0x01;                                                    //Configura el Tx1 en el pin RB4/RP36
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
;NodoAcelerometro.c,248 :: 		U1RXIE_bit = 1;                                                            //Activa la interrupcion por UART1 RX
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;NodoAcelerometro.c,249 :: 		U1STAbits.URXISEL = 0x00;                                                  //Interrupt is set when any character is received and transferred from the UxRSR to the receive buffer; receive buffer has one or more characters
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,250 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;NodoAcelerometro.c,251 :: 		IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#16384, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;NodoAcelerometro.c,252 :: 		UART1_Init_Advanced(2000000, _UART_8BIT_NOPARITY, _UART_ONE_STOPBIT, _UART_HI_SPEED);                            //Inicializa el UART1 con una velocidad de 2Mbps
	CLR	W13
	CLR	W12
	MOV	#33920, W10
	MOV	#30, W11
	MOV	#1, W0
	PUSH	W0
	CALL	_UART1_Init_Advanced
	SUB	#2, W15
;NodoAcelerometro.c,256 :: 		RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
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
;NodoAcelerometro.c,257 :: 		RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
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
;NodoAcelerometro.c,258 :: 		RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
	MOV	#2304, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR1bits
;NodoAcelerometro.c,259 :: 		SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
	BSET	SPI2STAT, #15
;NodoAcelerometro.c,260 :: 		SPI2_Init();                                                               //Inicializa el modulo SPI2
	CALL	_SPI2_Init
;NodoAcelerometro.c,263 :: 		RPINR0 = 0x2E00;                                                           //Asigna INT1 al RB14/RPI46
	MOV	#11776, W0
	MOV	WREG, RPINR0
;NodoAcelerometro.c,264 :: 		INT1IE_bit = 1;                                                            //Interrupcion externa INT1
	BSET	INT1IE_bit, BitPos(INT1IE_bit+0)
;NodoAcelerometro.c,265 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;NodoAcelerometro.c,266 :: 		IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,269 :: 		T1CON = 0x0020;
	MOV	#32, W0
	MOV	WREG, T1CON
;NodoAcelerometro.c,270 :: 		T1CON.TON = 0;                                                             //Apaga el Timer1
	BCLR	T1CON, #15
;NodoAcelerometro.c,271 :: 		T1IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR1
	BSET	T1IE_bit, BitPos(T1IE_bit+0)
;NodoAcelerometro.c,272 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR1
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;NodoAcelerometro.c,273 :: 		PR1 = 62500;                                                               //Car ga el preload para un tiempo de 100ms
	MOV	#62500, W0
	MOV	WREG, PR1
;NodoAcelerometro.c,274 :: 		IPC0bits.T1IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR1
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;NodoAcelerometro.c,277 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|STANDBY);                           //Coloco el ADXL en modo STANDBY para pausar las conversiones y limpiar el FIFO
	MOV.B	#5, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;NodoAcelerometro.c,280 :: 		sdflags.detected = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #1
;NodoAcelerometro.c,281 :: 		sdflags.init_ok = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #0
;NodoAcelerometro.c,282 :: 		sdflags.saving = false;
	MOV	#lo_addr(_sdflags), W0
	BCLR.B	[W0], #2
;NodoAcelerometro.c,284 :: 		Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#25, W8
	MOV	#27150, W7
L_ConfiguracionPrincipal66:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal66
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal66
	NOP
;NodoAcelerometro.c,286 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_Muestrear:

;NodoAcelerometro.c,291 :: 		void Muestrear(){
;NodoAcelerometro.c,293 :: 		if (banCiclo==0){
	PUSH	W10
	PUSH	W11
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__Muestrear374
	GOTO	L_Muestrear68
L__Muestrear374:
;NodoAcelerometro.c,295 :: 		ADXL355_write_byte(POWER_CTL, DRDY_OFF|MEASURING);                     //Coloca el ADXL en modo medicion
	MOV.B	#4, W11
	MOV.B	#45, W10
	CALL	_ADXL355_write_byte
;NodoAcelerometro.c,296 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,298 :: 		} else if (banCiclo==1) {
	GOTO	L_Muestrear69
L_Muestrear68:
	MOV	#lo_addr(_banCiclo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__Muestrear375
	GOTO	L_Muestrear70
L__Muestrear375:
;NodoAcelerometro.c,300 :: 		banCiclo = 2;                                                          //Limpia la bandera de ciclo completo
	MOV	#lo_addr(_banCiclo), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,302 :: 		tramaAceleracion[0] = contCiclos;                                      //LLena el primer elemento de la tramaCompleta con el contador de ciclos
	MOV	#lo_addr(_tramaAceleracion), W1
	MOV	#lo_addr(_contCiclos), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,303 :: 		numFIFO = ADXL355_read_byte(FIFO_ENTRIES);
	MOV.B	#5, W10
	CALL	_ADXL355_read_byte
	MOV	#lo_addr(_numFIFO), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,304 :: 		numSetsFIFO = (numFIFO)/3;                                             //Lee el numero de sets disponibles en el FIFO
	ZE	W0, W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(_numSetsFIFO), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,307 :: 		for (x=0;x<numSetsFIFO;x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear71:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Muestrear376
	GOTO	L_Muestrear72
L__Muestrear376:
;NodoAcelerometro.c,308 :: 		ADXL355_read_FIFO(datosLeidos);                                    //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,309 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Muestrear74:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Muestrear377
	GOTO	L_Muestrear75
L__Muestrear377:
;NodoAcelerometro.c,310 :: 		datosFIFO[y+(x*9)] = datosLeidos[y];                           //LLena la trama datosFIFO
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
;NodoAcelerometro.c,309 :: 		for (y=0;y<9;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,311 :: 		}
	GOTO	L_Muestrear74
L_Muestrear75:
;NodoAcelerometro.c,307 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,312 :: 		}
	GOTO	L_Muestrear71
L_Muestrear72:
;NodoAcelerometro.c,315 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	CLR	W0
	MOV	W0, _x
L_Muestrear77:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Muestrear378
	GOTO	L_Muestrear78
L__Muestrear378:
;NodoAcelerometro.c,316 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Muestrear379
	GOTO	L__Muestrear295
L__Muestrear379:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Muestrear380
	GOTO	L__Muestrear294
L__Muestrear380:
	GOTO	L_Muestrear82
L__Muestrear295:
L__Muestrear294:
;NodoAcelerometro.c,317 :: 		tramaAceleracion[contFIFO+contMuestras+x] = contMuestras;          //Funciona bien
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
;NodoAcelerometro.c,318 :: 		tramaAceleracion[contFIFO+contMuestras+x+1] = datosFIFO[x];
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
;NodoAcelerometro.c,319 :: 		contMuestras++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contMuestras), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,320 :: 		} else {
	GOTO	L_Muestrear83
L_Muestrear82:
;NodoAcelerometro.c,321 :: 		tramaAceleracion[contFIFO+contMuestras+x] = datosFIFO[x];
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
;NodoAcelerometro.c,322 :: 		}
L_Muestrear83:
;NodoAcelerometro.c,315 :: 		for (x=0;x<(numSetsFIFO*9);x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,323 :: 		}
	GOTO	L_Muestrear77
L_Muestrear78:
;NodoAcelerometro.c,327 :: 		contMuestras = 0;                                                      //Limpia el contador de muestras
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,328 :: 		contFIFO = 0;                                                          //Limpia el contador de FIFOs
	CLR	W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,329 :: 		T1CON.TON = 1;                                                         //Enciende el Timer1
	BSET	T1CON, #15
;NodoAcelerometro.c,331 :: 		GuardarTramaSD(tiempo, tramaAceleracion);
	MOV	#lo_addr(_tramaAceleracion), W11
	MOV	#lo_addr(_tiempo), W10
	CALL	_GuardarTramaSD
;NodoAcelerometro.c,334 :: 		}
L_Muestrear70:
L_Muestrear69:
;NodoAcelerometro.c,336 :: 		contCiclos++;                                                              //Incrementa el contador de ciclos
	MOV.B	#1, W1
	MOV	#lo_addr(_contCiclos), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,338 :: 		}
L_end_Muestrear:
	POP	W11
	POP	W10
	RETURN
; end of _Muestrear

_GuardarBufferSD:

;NodoAcelerometro.c,343 :: 		void GuardarBufferSD(unsigned char* bufferLleno, unsigned long sector){
;NodoAcelerometro.c,345 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarBufferSD84:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__GuardarBufferSD382
	GOTO	L_GuardarBufferSD85
L__GuardarBufferSD382:
;NodoAcelerometro.c,346 :: 		checkEscSD = SD_Write_Block(bufferLleno,sector);
	PUSH	W11
	PUSH	W12
	PUSH	W10
	CALL	_SD_Write_Block
	POP	W10
	POP	W12
	POP	W11
	MOV	#lo_addr(_checkEscSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,347 :: 		if (checkEscSD == DATA_ACCEPTED){
	CP.B	W0, #22
	BRA Z	L__GuardarBufferSD383
	GOTO	L_GuardarBufferSD87
L__GuardarBufferSD383:
;NodoAcelerometro.c,349 :: 		break;
	GOTO	L_GuardarBufferSD85
;NodoAcelerometro.c,350 :: 		}
L_GuardarBufferSD87:
;NodoAcelerometro.c,351 :: 		Delay_us(10);
	MOV	#80, W7
L_GuardarBufferSD88:
	DEC	W7
	BRA NZ	L_GuardarBufferSD88
	NOP
	NOP
;NodoAcelerometro.c,345 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,352 :: 		}
	GOTO	L_GuardarBufferSD84
L_GuardarBufferSD85:
;NodoAcelerometro.c,353 :: 		}
L_end_GuardarBufferSD:
	RETURN
; end of _GuardarBufferSD

_GuardarTramaSD:

;NodoAcelerometro.c,358 :: 		void GuardarTramaSD(unsigned char* tiempoSD, unsigned char* aceleracionSD){
;NodoAcelerometro.c,365 :: 		for (x=0;x<6;x++){
	PUSH	W12
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD90:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarTramaSD385
	GOTO	L_GuardarTramaSD91
L__GuardarTramaSD385:
;NodoAcelerometro.c,366 :: 		bufferSD[x] = cabeceraSD[x];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_cabeceraSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,365 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,367 :: 		}
	GOTO	L_GuardarTramaSD90
L_GuardarTramaSD91:
;NodoAcelerometro.c,369 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD93:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarTramaSD386
	GOTO	L_GuardarTramaSD94
L__GuardarTramaSD386:
;NodoAcelerometro.c,370 :: 		bufferSD[6+x] = tiempoSD[x];
	MOV	_x, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W10, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,369 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,371 :: 		}
	GOTO	L_GuardarTramaSD93
L_GuardarTramaSD94:
;NodoAcelerometro.c,373 :: 		for (x=0;x<500;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD96:
	MOV	_x, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD387
	GOTO	L_GuardarTramaSD97
L__GuardarTramaSD387:
;NodoAcelerometro.c,374 :: 		bufferSD[12+x] = aceleracionSD[x];
	MOV	_x, W0
	ADD	W0, #12, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W11, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,373 :: 		for (x=0;x<500;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,375 :: 		}
	GOTO	L_GuardarTramaSD96
L_GuardarTramaSD97:
;NodoAcelerometro.c,377 :: 		GuardarBufferSD(bufferSD, sectorSD);
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
L_GuardarTramaSD99:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD388
	GOTO	L_GuardarTramaSD100
L__GuardarTramaSD388:
;NodoAcelerometro.c,383 :: 		bufferSD[x] = aceleracionSD[x+500];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#500, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,382 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,384 :: 		}
	GOTO	L_GuardarTramaSD99
L_GuardarTramaSD100:
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
L_GuardarTramaSD102:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD389
	GOTO	L_GuardarTramaSD103
L__GuardarTramaSD389:
;NodoAcelerometro.c,390 :: 		bufferSD[x] = aceleracionSD[x+1012];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1012, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,389 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,391 :: 		}
	GOTO	L_GuardarTramaSD102
L_GuardarTramaSD103:
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
L_GuardarTramaSD105:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD390
	GOTO	L_GuardarTramaSD106
L__GuardarTramaSD390:
;NodoAcelerometro.c,397 :: 		bufferSD[x] = aceleracionSD[x+1524];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1524, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,396 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,398 :: 		}
	GOTO	L_GuardarTramaSD105
L_GuardarTramaSD106:
;NodoAcelerometro.c,399 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP.D	W10
;NodoAcelerometro.c,400 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,403 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarTramaSD108:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD391
	GOTO	L_GuardarTramaSD109
L__GuardarTramaSD391:
;NodoAcelerometro.c,404 :: 		if (x<464){
	MOV	_x, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__GuardarTramaSD392
	GOTO	L_GuardarTramaSD111
L__GuardarTramaSD392:
;NodoAcelerometro.c,405 :: 		bufferSD[x] = aceleracionSD[x+2036];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#2036, W0
	ADD	W1, W0, W0
	ADD	W11, W0, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,406 :: 		} else {
	GOTO	L_GuardarTramaSD112
L_GuardarTramaSD111:
;NodoAcelerometro.c,407 :: 		bufferSD[x] = 0;
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,408 :: 		}
L_GuardarTramaSD112:
;NodoAcelerometro.c,403 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,409 :: 		}
	GOTO	L_GuardarTramaSD108
L_GuardarTramaSD109:
;NodoAcelerometro.c,410 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH.D	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
;NodoAcelerometro.c,411 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,414 :: 		GuardarSectorSD(sectorSD);
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarSectorSD
	POP.D	W10
;NodoAcelerometro.c,416 :: 		TEST = 0;                                                               //Apaga el TEST cuando termina de gurdar la trama
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,418 :: 		}
L_end_GuardarTramaSD:
	POP	W12
	RETURN
; end of _GuardarTramaSD

_GuardarSectorSD:
	LNK	#512

;NodoAcelerometro.c,423 :: 		void GuardarSectorSD(unsigned long sector){
;NodoAcelerometro.c,428 :: 		bufferSectores[0] = (sector>>24)&0xFF;                                     //MSB variable sector
	PUSH	W12
	ADD	W14, #0, W5
	LSR	W11, #8, W2
	CLR	W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W5]
;NodoAcelerometro.c,429 :: 		bufferSectores[1] = (sector>>16)&0xFF;
	ADD	W5, #1, W4
	MOV	W11, W2
	CLR	W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W4]
;NodoAcelerometro.c,430 :: 		bufferSectores[2] = (sector>>8)&0xFF;
	ADD	W5, #2, W4
	LSR	W10, #8, W2
	SL	W11, #8, W3
	IOR	W2, W3, W2
	LSR	W11, #8, W3
	MOV	#255, W0
	MOV	#0, W1
	AND	W2, W0, W0
	MOV.B	W0, [W4]
;NodoAcelerometro.c,431 :: 		bufferSectores[3] = (sector)&0xFF;                                         //LSD variable sector
	ADD	W5, #3, W2
	MOV	#255, W0
	MOV	#0, W1
	AND	W10, W0, W0
	MOV.B	W0, [W2]
;NodoAcelerometro.c,432 :: 		for (x=4;x<512;x++){
	MOV	#4, W0
	MOV	W0, _x
L_GuardarSectorSD113:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarSectorSD394
	GOTO	L_GuardarSectorSD114
L__GuardarSectorSD394:
;NodoAcelerometro.c,433 :: 		bufferSectores[x] = 0;                                                 //Rellena de ceros el resto del buffer
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,432 :: 		for (x=4;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,434 :: 		}
	GOTO	L_GuardarSectorSD113
L_GuardarSectorSD114:
;NodoAcelerometro.c,437 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarSectorSD116:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__GuardarSectorSD395
	GOTO	L_GuardarSectorSD117
L__GuardarSectorSD395:
;NodoAcelerometro.c,438 :: 		checkEscSD = SD_Write_Block(bufferSectores,sectorSave);
	ADD	W14, #0, W0
	PUSH.D	W10
	MOV	_sectorSave, W11
	MOV	_sectorSave+2, W12
	MOV	W0, W10
	CALL	_SD_Write_Block
	POP.D	W10
	MOV	#lo_addr(_checkEscSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,439 :: 		if (checkEscSD == DATA_ACCEPTED){
	CP.B	W0, #22
	BRA Z	L__GuardarSectorSD396
	GOTO	L_GuardarSectorSD119
L__GuardarSectorSD396:
;NodoAcelerometro.c,441 :: 		break;
	GOTO	L_GuardarSectorSD117
;NodoAcelerometro.c,442 :: 		}
L_GuardarSectorSD119:
;NodoAcelerometro.c,443 :: 		Delay_us(10);
	MOV	#80, W7
L_GuardarSectorSD120:
	DEC	W7
	BRA NZ	L_GuardarSectorSD120
	NOP
	NOP
;NodoAcelerometro.c,437 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,444 :: 		}
	GOTO	L_GuardarSectorSD116
L_GuardarSectorSD117:
;NodoAcelerometro.c,446 :: 		}
L_end_GuardarSectorSD:
	POP	W12
	ULNK
	RETURN
; end of _GuardarSectorSD

_UbicarUltimoSectorSD:
	LNK	#516

;NodoAcelerometro.c,451 :: 		unsigned long UbicarUltimoSectorSD(unsigned short sobrescribirSD){
;NodoAcelerometro.c,457 :: 		ptrSectorInicioSD = (unsigned char *) & sectorInicioSD;
	PUSH	W11
	PUSH	W12
	MOV	#512, W0
	ADD	W14, W0, W0
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,460 :: 		if (sobrescribirSD==1){
	CP.B	W10, #1
	BRA Z	L__UbicarUltimoSectorSD398
	GOTO	L_UbicarUltimoSectorSD122
L__UbicarUltimoSectorSD398:
; ptrSectorInicioSD end address is: 6 (W3)
;NodoAcelerometro.c,461 :: 		sectorInicioSD = PSE;                                                  //Se escoje el PSE para sobrescribir la SD
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,462 :: 		} else {
	GOTO	L_UbicarUltimoSectorSD123
L_UbicarUltimoSectorSD122:
;NodoAcelerometro.c,463 :: 		checkLecSD = 1;
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,465 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_UbicarUltimoSectorSD124:
; ptrSectorInicioSD start address is: 6 (W3)
; ptrSectorInicioSD end address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__UbicarUltimoSectorSD399
	GOTO	L_UbicarUltimoSectorSD125
L__UbicarUltimoSectorSD399:
; ptrSectorInicioSD end address is: 6 (W3)
;NodoAcelerometro.c,467 :: 		checkLecSD = SD_Read_Block(bufferSectorFinal, sectorSave);
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
;NodoAcelerometro.c,469 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__UbicarUltimoSectorSD400
	GOTO	L_UbicarUltimoSectorSD127
L__UbicarUltimoSectorSD400:
;NodoAcelerometro.c,471 :: 		*ptrSectorInicioSD = bufferSectorFinal[3];                      //LSB
	ADD	W14, #0, W2
	ADD	W2, #3, W0
	MOV.B	[W0], [W3]
;NodoAcelerometro.c,472 :: 		*(ptrSectorInicioSD+1) = bufferSectorFinal[2];
	ADD	W3, #1, W1
	ADD	W2, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,473 :: 		*(ptrSectorInicioSD+2) = bufferSectorFinal[1];
	ADD	W3, #2, W1
	ADD	W2, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,474 :: 		*(ptrSectorInicioSD+3) = bufferSectorFinal[0];                  //MSB
	ADD	W3, #3, W0
; ptrSectorInicioSD end address is: 6 (W3)
	MOV.B	[W2], [W0]
;NodoAcelerometro.c,475 :: 		break;
	GOTO	L_UbicarUltimoSectorSD125
;NodoAcelerometro.c,477 :: 		} else {
L_UbicarUltimoSectorSD127:
;NodoAcelerometro.c,478 :: 		sectorInicioSD = PSE;                                           //Si no pudo realizar la lectura procede a sobreescribir la SD
; ptrSectorInicioSD start address is: 6 (W3)
	MOV	_PSE, W0
	MOV	_PSE+2, W1
	MOV	W0, [W14+512]
	MOV	W1, [W14+514]
;NodoAcelerometro.c,465 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,480 :: 		}
; ptrSectorInicioSD end address is: 6 (W3)
	GOTO	L_UbicarUltimoSectorSD124
L_UbicarUltimoSectorSD125:
;NodoAcelerometro.c,481 :: 		}
L_UbicarUltimoSectorSD123:
;NodoAcelerometro.c,483 :: 		return sectorInicioSD;
	MOV	[W14+512], W0
	MOV	[W14+514], W1
;NodoAcelerometro.c,485 :: 		}
;NodoAcelerometro.c,483 :: 		return sectorInicioSD;
;NodoAcelerometro.c,485 :: 		}
L_end_UbicarUltimoSectorSD:
	POP	W12
	POP	W11
	ULNK
	RETURN
; end of _UbicarUltimoSectorSD

_InformacionSectores:
	LNK	#4

;NodoAcelerometro.c,490 :: 		void InformacionSectores(unsigned char* tramaInfoSec){
;NodoAcelerometro.c,496 :: 		unsigned long PSFv = PSF;                                                  //**No se puede asociar el puntero a esta contante
	MOV	#2048, W0
	MOV	W0, [W14+0]
	MOV	#0, W0
	MOV	W0, [W14+2]
;NodoAcelerometro.c,499 :: 		ptrPSF = (unsigned char *) & PSFv;
	ADD	W14, #0, W0
; ptrPSF start address is: 6 (W3)
	MOV	W0, W3
;NodoAcelerometro.c,500 :: 		ptrPSE = (unsigned char *) & PSE;
; ptrPSE start address is: 8 (W4)
	MOV	#lo_addr(_PSE), W4
;NodoAcelerometro.c,501 :: 		ptrPSEC = (unsigned char *) & PSEC;
; ptrPSEC start address is: 10 (W5)
	MOV	#lo_addr(_PSEC), W5
;NodoAcelerometro.c,502 :: 		ptrSA = (unsigned char *) & sectorSD;
; ptrSA start address is: 12 (W6)
	MOV	#lo_addr(_sectorSD), W6
;NodoAcelerometro.c,504 :: 		if (banInicioMuestreo==0){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__InformacionSectores402
	GOTO	L_InformacionSectores131
L__InformacionSectores402:
;NodoAcelerometro.c,505 :: 		PSEC = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _PSEC
	MOV	W1, _PSEC+2
;NodoAcelerometro.c,506 :: 		sectorSD = UbicarUltimoSectorSD(0);                                     //Calcula el ultimo sector escrito
	PUSH	W6
	PUSH.D	W4
	PUSH	W3
	PUSH	W10
	CLR	W10
	CALL	_UbicarUltimoSectorSD
	POP	W10
	POP	W3
	POP.D	W4
	POP	W6
	MOV	W0, _sectorSD
	MOV	W1, _sectorSD+2
;NodoAcelerometro.c,507 :: 		} else {
	GOTO	L_InformacionSectores132
L_InformacionSectores131:
;NodoAcelerometro.c,508 :: 		sectorSD = sectorSD - 1;                                                //Calcula el sector actual
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	SUBR	W1, [W0], [W0++]
	SUBBR	W2, [W0], [W0--]
;NodoAcelerometro.c,509 :: 		}
L_InformacionSectores132:
;NodoAcelerometro.c,511 :: 		tramaInfoSec[0] = 0xD1;                                                    //Subfuncion
	MOV.B	#209, W0
	MOV.B	W0, [W10]
;NodoAcelerometro.c,512 :: 		tramaInfoSec[1] = *ptrPSF;                                                 //LSB PSF
	ADD	W10, #1, W0
	MOV.B	[W3], [W0]
;NodoAcelerometro.c,513 :: 		tramaInfoSec[2] = *(ptrPSF+1);
	ADD	W10, #2, W1
	ADD	W3, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,514 :: 		tramaInfoSec[3] = *(ptrPSF+2);
	ADD	W10, #3, W1
	ADD	W3, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,515 :: 		tramaInfoSec[4] = *(ptrPSF+3);                                             //MSB PSF
	ADD	W10, #4, W1
	ADD	W3, #3, W0
; ptrPSF end address is: 6 (W3)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,516 :: 		tramaInfoSec[5] = *ptrPSE;                                                 //LSB PSE
	ADD	W10, #5, W0
	MOV.B	[W4], [W0]
;NodoAcelerometro.c,517 :: 		tramaInfoSec[6] = *(ptrPSE+1);
	ADD	W10, #6, W1
	ADD	W4, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,518 :: 		tramaInfoSec[7] = *(ptrPSE+2);
	ADD	W10, #7, W1
	ADD	W4, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,519 :: 		tramaInfoSec[8] = *(ptrPSE+3);                                             //MSB PSE
	ADD	W10, #8, W1
	ADD	W4, #3, W0
; ptrPSE end address is: 8 (W4)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,520 :: 		tramaInfoSec[9] = *ptrPSEC;                                                //LSB PSEC
	ADD	W10, #9, W0
	MOV.B	[W5], [W0]
;NodoAcelerometro.c,521 :: 		tramaInfoSec[10] = *(ptrPSEC+1);
	ADD	W10, #10, W1
	ADD	W5, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,522 :: 		tramaInfoSec[11] = *(ptrPSEC+2);
	ADD	W10, #11, W1
	ADD	W5, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,523 :: 		tramaInfoSec[12] = *(ptrPSEC+3);                                           //MSB PSEC
	ADD	W10, #12, W1
	ADD	W5, #3, W0
; ptrPSEC end address is: 10 (W5)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,524 :: 		tramaInfoSec[13] = *ptrSA;                                                 //LSB SA
	ADD	W10, #13, W0
	MOV.B	[W6], [W0]
;NodoAcelerometro.c,525 :: 		tramaInfoSec[14] = *(ptrSA+1);
	ADD	W10, #14, W1
	ADD	W6, #1, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,526 :: 		tramaInfoSec[15] = *(ptrSA+2);
	ADD	W10, #15, W1
	ADD	W6, #2, W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,527 :: 		tramaInfoSec[16] = *(ptrSA+3);                                             //MSB SA
	ADD	W10, #16, W1
	ADD	W6, #3, W0
; ptrSA end address is: 12 (W6)
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,529 :: 		}
L_end_InformacionSectores:
	ULNK
	RETURN
; end of _InformacionSectores

_LeerDatosSector:
	LNK	#514

;NodoAcelerometro.c,534 :: 		unsigned int LeerDatosSector(unsigned short modoLec, unsigned long sectorReq, unsigned char* tramaDatosSec){
;NodoAcelerometro.c,541 :: 		tramaDatosSec[0] = modoLec;                                                //Subfuncion
	MOV.B	W10, [W13]
;NodoAcelerometro.c,542 :: 		if (modoLec==0xD2){
	MOV.B	#210, W0
	CP.B	W10, W0
	BRA Z	L__LeerDatosSector404
	GOTO	L_LeerDatosSector133
L__LeerDatosSector404:
;NodoAcelerometro.c,544 :: 		numDatosSec = 12;
	MOV	#12, W0
	MOV	W0, [W14+512]
;NodoAcelerometro.c,545 :: 		}
L_LeerDatosSector133:
;NodoAcelerometro.c,546 :: 		if (modoLec==0xD3){
	MOV.B	#211, W0
	CP.B	W10, W0
	BRA Z	L__LeerDatosSector405
	GOTO	L_LeerDatosSector134
L__LeerDatosSector405:
;NodoAcelerometro.c,548 :: 		numDatosSec = 512;
	MOV	#512, W0
	MOV	W0, [W14+512]
;NodoAcelerometro.c,549 :: 		}
L_LeerDatosSector134:
;NodoAcelerometro.c,552 :: 		if ((sectorReq>=PSE)&&(sectorReq<SIZESD)){
	MOV	#lo_addr(_PSE), W0
	CP	W11, [W0++]
	CPB	W12, [W0--]
	BRA GEU	L__LeerDatosSector406
	GOTO	L__LeerDatosSector298
L__LeerDatosSector406:
	MOV	#61440, W0
	MOV	#232, W1
	CP	W11, W0
	CPB	W12, W1
	BRA LTU	L__LeerDatosSector407
	GOTO	L__LeerDatosSector297
L__LeerDatosSector407:
L__LeerDatosSector296:
;NodoAcelerometro.c,554 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,556 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_LeerDatosSector138:
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__LeerDatosSector408
	GOTO	L_LeerDatosSector139
L__LeerDatosSector408:
;NodoAcelerometro.c,558 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, sectorReq);
	ADD	W14, #0, W0
	PUSH.D	W10
	PUSH.D	W12
	MOV	W0, W10
	CALL	_SD_Read_Block
	POP.D	W12
	POP.D	W10
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,560 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__LeerDatosSector409
	GOTO	L_LeerDatosSector141
L__LeerDatosSector409:
;NodoAcelerometro.c,562 :: 		for (y=0;y<numDatosSec;y++){
	CLR	W0
	MOV	W0, _y
L_LeerDatosSector142:
	MOV	_y, W1
	MOV	#512, W0
	ADD	W14, W0, W0
	CP	W1, [W0]
	BRA LTU	L__LeerDatosSector410
	GOTO	L_LeerDatosSector143
L__LeerDatosSector410:
;NodoAcelerometro.c,563 :: 		tramaDatosSec[y+1] = bufferSectorReq[y];
	MOV	_y, W0
	INC	W0
	ADD	W13, W0, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,562 :: 		for (y=0;y<numDatosSec;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,564 :: 		}
	GOTO	L_LeerDatosSector142
L_LeerDatosSector143:
;NodoAcelerometro.c,580 :: 		numDatosSec = numDatosSec + 1;
	MOV	[W14+512], W1
	MOV	#512, W0
	ADD	W14, W0, W0
	ADD	W1, #1, [W0]
;NodoAcelerometro.c,581 :: 		break;
	GOTO	L_LeerDatosSector139
;NodoAcelerometro.c,582 :: 		} else {
L_LeerDatosSector141:
;NodoAcelerometro.c,584 :: 		tramaDatosSec[0] = 0xEE;
	MOV.B	#238, W0
	MOV.B	W0, [W13]
;NodoAcelerometro.c,585 :: 		tramaDatosSec[1] = 0xE2;
	ADD	W13, #1, W1
	MOV.B	#226, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,586 :: 		numDatosSec = 2;
	MOV	#2, W0
	MOV	W0, [W14+512]
;NodoAcelerometro.c,556 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,588 :: 		}
	GOTO	L_LeerDatosSector138
L_LeerDatosSector139:
;NodoAcelerometro.c,590 :: 		} else {
	GOTO	L_LeerDatosSector146
;NodoAcelerometro.c,552 :: 		if ((sectorReq>=PSE)&&(sectorReq<SIZESD)){
L__LeerDatosSector298:
L__LeerDatosSector297:
;NodoAcelerometro.c,593 :: 		tramaDatosSec[0] = 0xEE;
	MOV.B	#238, W0
	MOV.B	W0, [W13]
;NodoAcelerometro.c,594 :: 		tramaDatosSec[1] = 0xE1;
	ADD	W13, #1, W1
	MOV.B	#225, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,595 :: 		numDatosSec = 2;
	MOV	#2, W0
	MOV	W0, [W14+512]
;NodoAcelerometro.c,597 :: 		}
L_LeerDatosSector146:
;NodoAcelerometro.c,599 :: 		return numDatosSec;
	MOV	[W14+512], W0
;NodoAcelerometro.c,601 :: 		}
L_end_LeerDatosSector:
	ULNK
	RETURN
; end of _LeerDatosSector

_RecuperarTramaAceleracion:
	LNK	#518

;NodoAcelerometro.c,606 :: 		void RecuperarTramaAceleracion(unsigned long sectorReq, unsigned char* tramaAcelSeg){
;NodoAcelerometro.c,612 :: 		tramaAcelSeg[0] = 0xD3;                                                     //Subfuncion
	MOV.B	#211, W0
	MOV.B	W0, [W12]
;NodoAcelerometro.c,613 :: 		contSector = 0;
; contSector start address is: 6 (W3)
	CLR	W3
	CLR	W4
;NodoAcelerometro.c,616 :: 		checkLecSD = 1;
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,618 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion147:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion412
	GOTO	L__RecuperarTramaAceleracion299
L__RecuperarTramaAceleracion412:
;NodoAcelerometro.c,619 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
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
;NodoAcelerometro.c,620 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion413
	GOTO	L_RecuperarTramaAceleracion150
L__RecuperarTramaAceleracion413:
;NodoAcelerometro.c,622 :: 		for (y=0;y<6;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion151:
; contSector start address is: 6 (W3)
	MOV	_y, W0
	CP	W0, #6
	BRA LTU	L__RecuperarTramaAceleracion414
	GOTO	L_RecuperarTramaAceleracion152
L__RecuperarTramaAceleracion414:
;NodoAcelerometro.c,623 :: 		tiempoAcel[y] = bufferSectorReq[y+6];
	MOV	#512, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W2
	MOV	_y, W0
	ADD	W0, #6, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,622 :: 		for (y=0;y<6;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,624 :: 		}
	GOTO	L_RecuperarTramaAceleracion151
L_RecuperarTramaAceleracion152:
;NodoAcelerometro.c,626 :: 		for (y=0;y<500;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion154:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion415
	GOTO	L_RecuperarTramaAceleracion155
L__RecuperarTramaAceleracion415:
;NodoAcelerometro.c,627 :: 		tramaAcelSeg[y+1] = bufferSectorReq[y+12];
	MOV	_y, W0
	INC	W0
	ADD	W12, W0, W2
	MOV	_y, W0
	ADD	W0, #12, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,626 :: 		for (y=0;y<500;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,628 :: 		}
	GOTO	L_RecuperarTramaAceleracion154
L_RecuperarTramaAceleracion155:
;NodoAcelerometro.c,629 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,630 :: 		break;
	GOTO	L_RecuperarTramaAceleracion148
;NodoAcelerometro.c,631 :: 		}
L_RecuperarTramaAceleracion150:
;NodoAcelerometro.c,618 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,632 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion147
L__RecuperarTramaAceleracion299:
;NodoAcelerometro.c,618 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,632 :: 		}
L_RecuperarTramaAceleracion148:
;NodoAcelerometro.c,635 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,637 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion157:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion416
	GOTO	L__RecuperarTramaAceleracion300
L__RecuperarTramaAceleracion416:
;NodoAcelerometro.c,638 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
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
;NodoAcelerometro.c,639 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion417
	GOTO	L_RecuperarTramaAceleracion160
L__RecuperarTramaAceleracion417:
;NodoAcelerometro.c,641 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion161:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion418
	GOTO	L_RecuperarTramaAceleracion162
L__RecuperarTramaAceleracion418:
;NodoAcelerometro.c,642 :: 		tramaAcelSeg[y+501] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#501, W0
	ADD	W1, W0, W0
	ADD	W12, W0, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,641 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,643 :: 		}
	GOTO	L_RecuperarTramaAceleracion161
L_RecuperarTramaAceleracion162:
;NodoAcelerometro.c,644 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,645 :: 		break;
	GOTO	L_RecuperarTramaAceleracion158
;NodoAcelerometro.c,646 :: 		}
L_RecuperarTramaAceleracion160:
;NodoAcelerometro.c,637 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,647 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion157
L__RecuperarTramaAceleracion300:
;NodoAcelerometro.c,637 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,647 :: 		}
L_RecuperarTramaAceleracion158:
;NodoAcelerometro.c,650 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,652 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion164:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion419
	GOTO	L__RecuperarTramaAceleracion301
L__RecuperarTramaAceleracion419:
;NodoAcelerometro.c,653 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
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
;NodoAcelerometro.c,654 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion420
	GOTO	L_RecuperarTramaAceleracion167
L__RecuperarTramaAceleracion420:
;NodoAcelerometro.c,656 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion168:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion421
	GOTO	L_RecuperarTramaAceleracion169
L__RecuperarTramaAceleracion421:
;NodoAcelerometro.c,657 :: 		tramaAcelSeg[y+1013] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#1013, W0
	ADD	W1, W0, W0
	ADD	W12, W0, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,656 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,658 :: 		}
	GOTO	L_RecuperarTramaAceleracion168
L_RecuperarTramaAceleracion169:
;NodoAcelerometro.c,659 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,660 :: 		break;
	GOTO	L_RecuperarTramaAceleracion165
;NodoAcelerometro.c,661 :: 		}
L_RecuperarTramaAceleracion167:
;NodoAcelerometro.c,652 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,662 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion164
L__RecuperarTramaAceleracion301:
;NodoAcelerometro.c,652 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,662 :: 		}
L_RecuperarTramaAceleracion165:
;NodoAcelerometro.c,665 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,667 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion171:
; contSector start address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion422
	GOTO	L__RecuperarTramaAceleracion302
L__RecuperarTramaAceleracion422:
;NodoAcelerometro.c,668 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
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
;NodoAcelerometro.c,669 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion423
	GOTO	L_RecuperarTramaAceleracion174
L__RecuperarTramaAceleracion423:
;NodoAcelerometro.c,671 :: 		for (y=0;y<512;y++){
	CLR	W0
	MOV	W0, _y
; contSector end address is: 6 (W3)
L_RecuperarTramaAceleracion175:
; contSector start address is: 6 (W3)
	MOV	_y, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion424
	GOTO	L_RecuperarTramaAceleracion176
L__RecuperarTramaAceleracion424:
;NodoAcelerometro.c,672 :: 		tramaAcelSeg[y+1525] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#1525, W0
	ADD	W1, W0, W0
	ADD	W12, W0, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,671 :: 		for (y=0;y<512;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,673 :: 		}
	GOTO	L_RecuperarTramaAceleracion175
L_RecuperarTramaAceleracion176:
;NodoAcelerometro.c,674 :: 		contSector++;
	ADD	W3, #1, W3
	ADDC	W4, #0, W4
;NodoAcelerometro.c,675 :: 		break;
	GOTO	L_RecuperarTramaAceleracion172
;NodoAcelerometro.c,676 :: 		}
L_RecuperarTramaAceleracion174:
;NodoAcelerometro.c,667 :: 		for (x=0;x<5;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,677 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion171
L__RecuperarTramaAceleracion302:
;NodoAcelerometro.c,667 :: 		for (x=0;x<5;x++){
;NodoAcelerometro.c,677 :: 		}
L_RecuperarTramaAceleracion172:
;NodoAcelerometro.c,680 :: 		checkLecSD = 1;
; contSector start address is: 6 (W3)
	MOV	#lo_addr(_checkLecSD), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,682 :: 		for (x=0;x<5;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion178:
; contSector start address is: 6 (W3)
; contSector end address is: 6 (W3)
	MOV	_x, W0
	CP	W0, #5
	BRA LTU	L__RecuperarTramaAceleracion425
	GOTO	L_RecuperarTramaAceleracion179
L__RecuperarTramaAceleracion425:
; contSector end address is: 6 (W3)
;NodoAcelerometro.c,683 :: 		checkLecSD = SD_Read_Block(bufferSectorReq, (sectorReq+contSector));
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
;NodoAcelerometro.c,684 :: 		if (checkLecSD==0) {
	CP.B	W0, #0
	BRA Z	L__RecuperarTramaAceleracion426
	GOTO	L_RecuperarTramaAceleracion181
L__RecuperarTramaAceleracion426:
; contSector end address is: 6 (W3)
;NodoAcelerometro.c,686 :: 		for (y=0;y<464;y++){
	CLR	W0
	MOV	W0, _y
L_RecuperarTramaAceleracion182:
	MOV	_y, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__RecuperarTramaAceleracion427
	GOTO	L_RecuperarTramaAceleracion183
L__RecuperarTramaAceleracion427:
;NodoAcelerometro.c,687 :: 		tramaAcelSeg[y+2037] = bufferSectorReq[y];
	MOV	_y, W1
	MOV	#2037, W0
	ADD	W1, W0, W0
	ADD	W12, W0, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,686 :: 		for (y=0;y<464;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,688 :: 		}
	GOTO	L_RecuperarTramaAceleracion182
L_RecuperarTramaAceleracion183:
;NodoAcelerometro.c,690 :: 		break;
	GOTO	L_RecuperarTramaAceleracion179
;NodoAcelerometro.c,691 :: 		}
L_RecuperarTramaAceleracion181:
;NodoAcelerometro.c,682 :: 		for (x=0;x<5;x++){
; contSector start address is: 6 (W3)
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,692 :: 		}
; contSector end address is: 6 (W3)
	GOTO	L_RecuperarTramaAceleracion178
L_RecuperarTramaAceleracion179:
;NodoAcelerometro.c,695 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_RecuperarTramaAceleracion185:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__RecuperarTramaAceleracion428
	GOTO	L_RecuperarTramaAceleracion186
L__RecuperarTramaAceleracion428:
;NodoAcelerometro.c,696 :: 		tramaAcelSeg[2501+x] = tiempoAcel[x];
	MOV	#2501, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	ADD	W12, W0, W2
	MOV	#512, W1
	ADD	W14, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,695 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,697 :: 		}
	GOTO	L_RecuperarTramaAceleracion185
L_RecuperarTramaAceleracion186:
;NodoAcelerometro.c,699 :: 		}
L_end_RecuperarTramaAceleracion:
	ULNK
	RETURN
; end of _RecuperarTramaAceleracion

_GuardarPruebaSD:
	LNK	#2506

;NodoAcelerometro.c,704 :: 		void GuardarPruebaSD(unsigned char* tiempoSD){
;NodoAcelerometro.c,713 :: 		contadorEjemploSD = 0;
	PUSH	W11
	PUSH	W12
; contadorEjemploSD start address is: 4 (W2)
	CLR	W2
;NodoAcelerometro.c,714 :: 		for (x=0;x<2500;x++){
	CLR	W0
	MOV	W0, _x
; contadorEjemploSD end address is: 4 (W2)
L_GuardarPruebaSD188:
; contadorEjemploSD start address is: 4 (W2)
	MOV	_x, W1
	MOV	#2500, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD430
	GOTO	L_GuardarPruebaSD189
L__GuardarPruebaSD430:
;NodoAcelerometro.c,715 :: 		aceleracionSD[x] = contadorEjemploSD;
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	W2, [W0]
;NodoAcelerometro.c,716 :: 		contadorEjemploSD ++;
	ADD.B	W2, #1, W1
	MOV.B	W1, W2
;NodoAcelerometro.c,717 :: 		if (contadorEjemploSD >= 255){
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA GEU	L__GuardarPruebaSD431
	GOTO	L__GuardarPruebaSD303
L__GuardarPruebaSD431:
;NodoAcelerometro.c,718 :: 		contadorEjemploSD = 0;
	CLR	W2
; contadorEjemploSD end address is: 4 (W2)
;NodoAcelerometro.c,719 :: 		}
	GOTO	L_GuardarPruebaSD191
L__GuardarPruebaSD303:
;NodoAcelerometro.c,717 :: 		if (contadorEjemploSD >= 255){
;NodoAcelerometro.c,719 :: 		}
L_GuardarPruebaSD191:
;NodoAcelerometro.c,714 :: 		for (x=0;x<2500;x++){
; contadorEjemploSD start address is: 4 (W2)
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,720 :: 		}
; contadorEjemploSD end address is: 4 (W2)
	GOTO	L_GuardarPruebaSD188
L_GuardarPruebaSD189:
;NodoAcelerometro.c,723 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD192:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarPruebaSD432
	GOTO	L_GuardarPruebaSD193
L__GuardarPruebaSD432:
;NodoAcelerometro.c,724 :: 		bufferSD[x] = cabeceraSD[x];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	#lo_addr(_cabeceraSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,723 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,725 :: 		}
	GOTO	L_GuardarPruebaSD192
L_GuardarPruebaSD193:
;NodoAcelerometro.c,727 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD195:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__GuardarPruebaSD433
	GOTO	L_GuardarPruebaSD196
L__GuardarPruebaSD433:
;NodoAcelerometro.c,728 :: 		bufferSD[6+x] = tiempoSD[x];
	MOV	_x, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W1
	MOV	#lo_addr(_x), W0
	ADD	W10, [W0], W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,727 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,729 :: 		}
	GOTO	L_GuardarPruebaSD195
L_GuardarPruebaSD196:
;NodoAcelerometro.c,731 :: 		for (x=0;x<500;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD198:
	MOV	_x, W1
	MOV	#500, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD434
	GOTO	L_GuardarPruebaSD199
L__GuardarPruebaSD434:
;NodoAcelerometro.c,732 :: 		bufferSD[12+x] = aceleracionSD[x];
	MOV	_x, W0
	ADD	W0, #12, W1
	MOV	#lo_addr(_bufferSD), W0
	ADD	W0, W1, W2
	ADD	W14, #0, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,731 :: 		for (x=0;x<500;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,733 :: 		}
	GOTO	L_GuardarPruebaSD198
L_GuardarPruebaSD199:
;NodoAcelerometro.c,735 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,737 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,740 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD201:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD435
	GOTO	L_GuardarPruebaSD202
L__GuardarPruebaSD435:
;NodoAcelerometro.c,741 :: 		bufferSD[x] = aceleracionSD[x+500];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#500, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,740 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,742 :: 		}
	GOTO	L_GuardarPruebaSD201
L_GuardarPruebaSD202:
;NodoAcelerometro.c,743 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,744 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,747 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD204:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD436
	GOTO	L_GuardarPruebaSD205
L__GuardarPruebaSD436:
;NodoAcelerometro.c,748 :: 		bufferSD[x] = aceleracionSD[x+1012];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1012, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,747 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,749 :: 		}
	GOTO	L_GuardarPruebaSD204
L_GuardarPruebaSD205:
;NodoAcelerometro.c,750 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,751 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,754 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD207:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD437
	GOTO	L_GuardarPruebaSD208
L__GuardarPruebaSD437:
;NodoAcelerometro.c,755 :: 		bufferSD[x] = aceleracionSD[x+1524];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#1524, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,754 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,756 :: 		}
	GOTO	L_GuardarPruebaSD207
L_GuardarPruebaSD208:
;NodoAcelerometro.c,757 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
	POP	W10
;NodoAcelerometro.c,758 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,761 :: 		for (x=0;x<512;x++){
	CLR	W0
	MOV	W0, _x
L_GuardarPruebaSD210:
	MOV	_x, W1
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD438
	GOTO	L_GuardarPruebaSD211
L__GuardarPruebaSD438:
;NodoAcelerometro.c,762 :: 		if (x<464){
	MOV	_x, W1
	MOV	#464, W0
	CP	W1, W0
	BRA LTU	L__GuardarPruebaSD439
	GOTO	L_GuardarPruebaSD213
L__GuardarPruebaSD439:
;NodoAcelerometro.c,763 :: 		bufferSD[x] = aceleracionSD[x+2036];
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W1
	MOV	#2036, W0
	ADD	W1, W0, W1
	ADD	W14, #0, W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,764 :: 		} else {
	GOTO	L_GuardarPruebaSD214
L_GuardarPruebaSD213:
;NodoAcelerometro.c,765 :: 		bufferSD[x] = 0;
	MOV	#lo_addr(_bufferSD), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,766 :: 		}
L_GuardarPruebaSD214:
;NodoAcelerometro.c,761 :: 		for (x=0;x<512;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,767 :: 		}
	GOTO	L_GuardarPruebaSD210
L_GuardarPruebaSD211:
;NodoAcelerometro.c,768 :: 		GuardarBufferSD(bufferSD, sectorSD);
	PUSH	W10
	MOV	_sectorSD, W11
	MOV	_sectorSD+2, W12
	MOV	#lo_addr(_bufferSD), W10
	CALL	_GuardarBufferSD
;NodoAcelerometro.c,769 :: 		sectorSD++;
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_sectorSD), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,772 :: 		GuardarSectorSD(sectorSD);
	MOV	_sectorSD, W10
	MOV	_sectorSD+2, W11
	CALL	_GuardarSectorSD
	POP	W10
;NodoAcelerometro.c,774 :: 		TEST = 0;                                                               //Apaga el TEST cuando termina de gurdar la trama
	BCLR	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,776 :: 		}
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

;NodoAcelerometro.c,787 :: 		void int_1() org IVT_ADDR_INT1INTERRUPT {
;NodoAcelerometro.c,789 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;NodoAcelerometro.c,791 :: 		if (banSetReloj==1){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1441
	GOTO	L_int_1215
L__int_1441:
;NodoAcelerometro.c,792 :: 		horaSistema++;                                                          //Incrementa el reloj del sistema
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaSistema), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;NodoAcelerometro.c,793 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza la trama de tiempo
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;NodoAcelerometro.c,794 :: 		TEST = ~TEST;
	BTG	LATA2_bit, BitPos(LATA2_bit+0)
;NodoAcelerometro.c,795 :: 		} else {
	GOTO	L_int_1216
L_int_1215:
;NodoAcelerometro.c,797 :: 		}
L_int_1216:
;NodoAcelerometro.c,799 :: 		if (horaSistema==86400){                                                   //(24*3600)+(0*60)+(0) = 86400
	MOV	_horaSistema, W2
	MOV	_horaSistema+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__int_1442
	GOTO	L_int_1217
L__int_1442:
;NodoAcelerometro.c,800 :: 		horaSistema = 0;                                                        //Reinicia el reloj al llegar a las 24:00:00 horas
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,802 :: 		fechaSistema = IncrementarFecha(fechaSistema);                          //Incrementa la fecha del sistema
	MOV	_fechaSistema, W10
	MOV	_fechaSistema+2, W11
	CALL	_IncrementarFecha
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,803 :: 		}
L_int_1217:
;NodoAcelerometro.c,805 :: 		if (banInicioMuestreo==1){
	MOV	#lo_addr(_banInicioMuestreo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1443
	GOTO	L_int_1218
L__int_1443:
;NodoAcelerometro.c,806 :: 		Muestrear();
	CALL	_Muestrear
;NodoAcelerometro.c,807 :: 		}
L_int_1218:
;NodoAcelerometro.c,809 :: 		}
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

;NodoAcelerometro.c,814 :: 		void Timer1Int() org IVT_ADDR_T1INTERRUPT{
;NodoAcelerometro.c,816 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer1
	PUSH	W10
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;NodoAcelerometro.c,818 :: 		numFIFO = ADXL355_read_byte(FIFO_ENTRIES); //75                            //Lee el numero de muestras disponibles en el FIFO
	MOV.B	#5, W10
	CALL	_ADXL355_read_byte
	MOV	#lo_addr(_numFIFO), W1
	MOV.B	W0, [W1]
;NodoAcelerometro.c,819 :: 		numSetsFIFO = (numFIFO)/3;                 //25                            //Lee el numero de sets disponibles en el FIFO
	ZE	W0, W0
	MOV	#3, W2
	REPEAT	#17
	DIV.S	W0, W2
	MOV	W0, W1
	MOV	#lo_addr(_numSetsFIFO), W0
	MOV.B	W1, [W0]
;NodoAcelerometro.c,822 :: 		for (x=0;x<numSetsFIFO;x++){
	CLR	W0
	MOV	W0, _x
L_Timer1Int219:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__Timer1Int445
	GOTO	L_Timer1Int220
L__Timer1Int445:
;NodoAcelerometro.c,823 :: 		ADXL355_read_FIFO(datosLeidos);                                        //Lee una sola posicion del FIFO
	MOV	#lo_addr(_datosLeidos), W10
	CALL	_ADXL355_read_FIFO
;NodoAcelerometro.c,824 :: 		for (y=0;y<9;y++){
	CLR	W0
	MOV	W0, _y
L_Timer1Int222:
	MOV	_y, W0
	CP	W0, #9
	BRA LTU	L__Timer1Int446
	GOTO	L_Timer1Int223
L__Timer1Int446:
;NodoAcelerometro.c,825 :: 		datosFIFO[y+(x*9)] = datosLeidos[y];                               //LLena la trama datosFIFO
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
;NodoAcelerometro.c,824 :: 		for (y=0;y<9;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,826 :: 		}
	GOTO	L_Timer1Int222
L_Timer1Int223:
;NodoAcelerometro.c,822 :: 		for (x=0;x<numSetsFIFO;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,827 :: 		}
	GOTO	L_Timer1Int219
L_Timer1Int220:
;NodoAcelerometro.c,830 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	CLR	W0
	MOV	W0, _x
L_Timer1Int225:
	MOV	#lo_addr(_numSetsFIFO), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W2
	MOV	#lo_addr(_x), W0
	CP	W2, [W0]
	BRA GTU	L__Timer1Int447
	GOTO	L_Timer1Int226
L__Timer1Int447:
;NodoAcelerometro.c,831 :: 		if ((x==0)||(x%9==0)){
	MOV	_x, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int448
	GOTO	L__Timer1Int306
L__Timer1Int448:
	MOV	_x, W0
	MOV	#9, W2
	REPEAT	#17
	DIV.U	W0, W2
	MOV	W1, W0
	CP	W0, #0
	BRA NZ	L__Timer1Int449
	GOTO	L__Timer1Int305
L__Timer1Int449:
	GOTO	L_Timer1Int230
L__Timer1Int306:
L__Timer1Int305:
;NodoAcelerometro.c,832 :: 		tramaAceleracion[contFIFO+contMuestras+x] = contMuestras;
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
;NodoAcelerometro.c,833 :: 		tramaAceleracion[contFIFO+contMuestras+x+1] = datosFIFO[x];
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
;NodoAcelerometro.c,834 :: 		contMuestras++;
	MOV.B	#1, W1
	MOV	#lo_addr(_contMuestras), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,835 :: 		} else {
	GOTO	L_Timer1Int231
L_Timer1Int230:
;NodoAcelerometro.c,836 :: 		tramaAceleracion[contFIFO+contMuestras+x] = datosFIFO[x];
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
;NodoAcelerometro.c,837 :: 		}
L_Timer1Int231:
;NodoAcelerometro.c,830 :: 		for (x=0;x<(numSetsFIFO*9);x++){      //0-224
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,838 :: 		}
	GOTO	L_Timer1Int225
L_Timer1Int226:
;NodoAcelerometro.c,840 :: 		contFIFO = (contMuestras*9);                                               //Incrementa el contador de FIFOs
	MOV	#lo_addr(_contMuestras), W0
	ZE	[W0], W1
	MOV	#9, W0
	MUL.SS	W1, W0, W0
	MOV	W0, _contFIFO
;NodoAcelerometro.c,842 :: 		contTimer1++;                                                              //Incrementa una unidad cada vez que entra a la interrupcion por Timer1
	MOV.B	#1, W1
	MOV	#lo_addr(_contTimer1), W0
	ADD.B	W1, [W0], [W0]
;NodoAcelerometro.c,844 :: 		if (contTimer1==numTMR1){                                                  //Verifica si se cumplio el numero de interrupciones por TMR1 para la tasa de muestreo seleccionada
	MOV	#lo_addr(_contTimer1), W0
	ZE	[W0], W1
	MOV	#lo_addr(_numTMR1), W0
	SE	[W0], W0
	CP	W1, W0
	BRA Z	L__Timer1Int450
	GOTO	L_Timer1Int232
L__Timer1Int450:
;NodoAcelerometro.c,845 :: 		T1CON.TON = 0;                                                          //Apaga el Timer1
	BCLR	T1CON, #15
;NodoAcelerometro.c,846 :: 		banCiclo = 1;                                                           //Activa la bandera que indica que se completo un ciclo de medicion
	MOV	#lo_addr(_banCiclo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,847 :: 		contTimer1 = 0;                                                         //Limpia el contador de interrupciones por Timer1
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,848 :: 		}
L_Timer1Int232:
;NodoAcelerometro.c,850 :: 		}
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

;NodoAcelerometro.c,855 :: 		void urx_1() org  IVT_ADDR_U1RXINTERRUPT {
;NodoAcelerometro.c,858 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;NodoAcelerometro.c,859 :: 		byteRS485 = U1RXREG;
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	U1RXREG, WREG
	MOV.B	W0, [W1]
;NodoAcelerometro.c,860 :: 		OERR_bit = 0;                                                              //Limpia este bit para limpiar el FIFO UART
	BCLR	OERR_bit, BitPos(OERR_bit+0)
;NodoAcelerometro.c,863 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_1452
	GOTO	L_urx_1233
L__urx_1452:
;NodoAcelerometro.c,864 :: 		if (i_rs485<numDatosRS485){
	MOV	_i_rs485, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__urx_1453
	GOTO	L_urx_1234
L__urx_1453:
;NodoAcelerometro.c,865 :: 		inputPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,866 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,867 :: 		} else {
	GOTO	L_urx_1235
L_urx_1234:
;NodoAcelerometro.c,869 :: 		banRSI = 0;                                                          //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,870 :: 		banRSC = 1;                                                          //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,871 :: 		}
L_urx_1235:
;NodoAcelerometro.c,872 :: 		}
L_urx_1233:
;NodoAcelerometro.c,875 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1454
	GOTO	L__urx_1312
L__urx_1454:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_1455
	GOTO	L__urx_1311
L__urx_1455:
L__urx_1310:
;NodoAcelerometro.c,876 :: 		if (byteRS485==0x3A){                                                   //Verifica si el primer byte recibido sea la cabecera de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__urx_1456
	GOTO	L_urx_1239
L__urx_1456:
;NodoAcelerometro.c,878 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,879 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,880 :: 		}
L_urx_1239:
;NodoAcelerometro.c,875 :: 		if ((banRSI==0)&&(banRSC==0)){
L__urx_1312:
L__urx_1311:
;NodoAcelerometro.c,882 :: 		if ((banRSI==1)&&(i_rs485<5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1457
	GOTO	L__urx_1314
L__urx_1457:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA LTU	L__urx_1458
	GOTO	L__urx_1313
L__urx_1458:
L__urx_1309:
;NodoAcelerometro.c,883 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                                //Recupera los datos de cabecera de la trama UART: [0x3A, Direccion, Funcion, NumeroDatosLSB, NumeroDatosMSB]
	MOV	#lo_addr(_tramaCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,884 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,882 :: 		if ((banRSI==1)&&(i_rs485<5)){
L__urx_1314:
L__urx_1313:
;NodoAcelerometro.c,886 :: 		if ((banRSI==1)&&(i_rs485==5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1459
	GOTO	L__urx_1318
L__urx_1459:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA Z	L__urx_1460
	GOTO	L__urx_1317
L__urx_1460:
L__urx_1308:
;NodoAcelerometro.c,888 :: 		if ((tramaCabeceraRS485[1]==IDNODO)||(tramaCabeceraRS485[1]==255)){
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W0
	CP.B	W0, #5
	BRA NZ	L__urx_1461
	GOTO	L__urx_1316
L__urx_1461:
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W1
	MOV.B	#255, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1462
	GOTO	L__urx_1315
L__urx_1462:
	GOTO	L_urx_1248
L__urx_1316:
L__urx_1315:
;NodoAcelerometro.c,889 :: 		funcionRS485 = tramaCabeceraRS485[2];
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_tramaCabeceraRS485+2), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,890 :: 		*(ptrnumDatosRS485) = tramaCabeceraRS485[3];                         //LSB numDatosRS485
	MOV	#lo_addr(_tramaCabeceraRS485+3), W1
	MOV	_ptrnumDatosRS485, W0
	MOV.B	[W1], [W0]
;NodoAcelerometro.c,891 :: 		*(ptrnumDatosRS485+1) = tramaCabeceraRS485[4];                       //MSB numDatosRS485
	MOV	_ptrnumDatosRS485, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaCabeceraRS485+4), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,892 :: 		banRSI = 2;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,893 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,894 :: 		} else {
	GOTO	L_urx_1249
L_urx_1248:
;NodoAcelerometro.c,895 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,896 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,897 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;NodoAcelerometro.c,898 :: 		}
L_urx_1249:
;NodoAcelerometro.c,886 :: 		if ((banRSI==1)&&(i_rs485==5)){
L__urx_1318:
L__urx_1317:
;NodoAcelerometro.c,902 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1463
	GOTO	L_urx_1250
L__urx_1463:
;NodoAcelerometro.c,903 :: 		subFuncionRS485 = inputPyloadRS485[0];
	MOV	#lo_addr(_subFuncionRS485), W1
	MOV	#lo_addr(_inputPyloadRS485), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,904 :: 		switch (funcionRS485){
	GOTO	L_urx_1251
;NodoAcelerometro.c,905 :: 		case 0xF1:
L_urx_1253:
;NodoAcelerometro.c,907 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1464
	GOTO	L_urx_1254
L__urx_1464:
;NodoAcelerometro.c,908 :: 		for (x=0;x<6;x++) {
	CLR	W0
	MOV	W0, _x
L_urx_1255:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1465
	GOTO	L_urx_1256
L__urx_1465:
;NodoAcelerometro.c,909 :: 		tiempo[x] = inputPyloadRS485[x+1];                  //LLena la trama tiempo con el payload de la trama recuperada
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_inputPyloadRS485), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,908 :: 		for (x=0;x<6;x++) {
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,910 :: 		}
	GOTO	L_urx_1255
L_urx_1256:
;NodoAcelerometro.c,911 :: 		horaSistema = RecuperarHoraRPI(tiempo);                 //Recupera la hora de la RPi
	MOV	#lo_addr(_tiempo), W10
	CALL	_RecuperarHoraRPI
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;NodoAcelerometro.c,912 :: 		fechaSistema = RecuperarFechaRPI(tiempo);               //Recupera la fecha de la RPi
	MOV	#lo_addr(_tiempo), W10
	CALL	_RecuperarFechaRPI
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;NodoAcelerometro.c,913 :: 		banSetReloj = 1;                                        //Activa la bandera para indicar que se establecio la hora y fecha
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,914 :: 		}
L_urx_1254:
;NodoAcelerometro.c,916 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1466
	GOTO	L_urx_1258
L__urx_1466:
;NodoAcelerometro.c,918 :: 		outputPyloadRS485[0] = 0xD2;
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,919 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_urx_1259:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1467
	GOTO	L_urx_1260
L__urx_1467:
;NodoAcelerometro.c,920 :: 		outputPyloadRS485[x+1] = tiempo[x];
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_outputPyloadRS485), W0
	ADD	W0, W1, W2
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], [W2]
;NodoAcelerometro.c,919 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;NodoAcelerometro.c,921 :: 		}
	GOTO	L_urx_1259
L_urx_1260:
;NodoAcelerometro.c,922 :: 		EnviarTramaRS485(1, IDNODO, 0xF1, 7, outputPyloadRS485);//Envia la hora local al Master
	MOV	#7, W13
	MOV.B	#241, W12
	MOV.B	#5, W11
	MOV.B	#1, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;NodoAcelerometro.c,923 :: 		}
L_urx_1258:
;NodoAcelerometro.c,924 :: 		break;
	GOTO	L_urx_1252
;NodoAcelerometro.c,926 :: 		case 0xF2:
L_urx_1262:
;NodoAcelerometro.c,928 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1468
	GOTO	L_urx_1263
L__urx_1468:
;NodoAcelerometro.c,929 :: 		sectorSD = UbicarUltimoSectorSD(inputPyloadRS485[1]);   //inputPyloadRS485[1] = sobrescribir (0=no, 1=si)
	MOV	#lo_addr(_inputPyloadRS485+1), W0
	MOV.B	[W0], W10
	CALL	_UbicarUltimoSectorSD
	MOV	W0, _sectorSD
	MOV	W1, _sectorSD+2
;NodoAcelerometro.c,930 :: 		PSEC = sectorSD;                                        //Guarda el numero del primer sector escrito en este ciclo de muestreo
	MOV	W0, _PSEC
	MOV	W1, _PSEC+2
;NodoAcelerometro.c,931 :: 		banInicioMuestreo = 1;                                  //Activa la bandera para iniciar el muestreo
	MOV	#lo_addr(_banInicioMuestreo), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,932 :: 		}
L_urx_1263:
;NodoAcelerometro.c,934 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1469
	GOTO	L_urx_1264
L__urx_1469:
;NodoAcelerometro.c,935 :: 		banInicioMuestreo = 0;                                   //Limpia la bandera para detener el muestreo
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,936 :: 		}
L_urx_1264:
;NodoAcelerometro.c,937 :: 		break;
	GOTO	L_urx_1252
;NodoAcelerometro.c,939 :: 		case 0xF3:
L_urx_1265:
;NodoAcelerometro.c,942 :: 		*ptrsectorReq = inputPyloadRS485[1];                        //LSB sectorReq
	MOV	#lo_addr(_inputPyloadRS485+1), W1
	MOV	_ptrsectorReq, W0
	MOV.B	[W1], [W0]
;NodoAcelerometro.c,943 :: 		*(ptrsectorReq+1) = inputPyloadRS485[2];
	MOV	_ptrsectorReq, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_inputPyloadRS485+2), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,944 :: 		*(ptrsectorReq+2) = inputPyloadRS485[3];
	MOV	_ptrsectorReq, W0
	ADD	W0, #2, W1
	MOV	#lo_addr(_inputPyloadRS485+3), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,945 :: 		*(ptrsectorReq+3) = inputPyloadRS485[4];                    //MSB sectorReq
	MOV	_ptrsectorReq, W0
	ADD	W0, #3, W1
	MOV	#lo_addr(_inputPyloadRS485+4), W0
	MOV.B	[W0], [W1]
;NodoAcelerometro.c,948 :: 		if (subFuncionRS485==0xD1){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#209, W0
	CP.B	W1, W0
	BRA Z	L__urx_1470
	GOTO	L_urx_1266
L__urx_1470:
;NodoAcelerometro.c,950 :: 		InformacionSectores(outputPyloadRS485);
	MOV	#lo_addr(_outputPyloadRS485), W10
	CALL	_InformacionSectores
;NodoAcelerometro.c,951 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, 17, outputPyloadRS485);
	MOV	#17, W13
	MOV.B	#243, W12
	MOV.B	#5, W11
	MOV.B	#1, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;NodoAcelerometro.c,952 :: 		}
L_urx_1266:
;NodoAcelerometro.c,954 :: 		if (subFuncionRS485==0xD2){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#210, W0
	CP.B	W1, W0
	BRA Z	L__urx_1471
	GOTO	L_urx_1267
L__urx_1471:
;NodoAcelerometro.c,956 :: 		numDatosRS485 = LeerDatosSector(0xD2, sectorReq, outputPyloadRS485);
	MOV	#lo_addr(_outputPyloadRS485), W13
	MOV	_sectorReq, W11
	MOV	_sectorReq+2, W12
	MOV.B	#210, W10
	CALL	_LeerDatosSector
	MOV	W0, _numDatosRS485
;NodoAcelerometro.c,957 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, numDatosRS485, outputPyloadRS485);
	MOV	W0, W13
	MOV.B	#243, W12
	MOV.B	#5, W11
	MOV.B	#1, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;NodoAcelerometro.c,958 :: 		}
L_urx_1267:
;NodoAcelerometro.c,960 :: 		if (subFuncionRS485==0xD3){
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#211, W0
	CP.B	W1, W0
	BRA Z	L__urx_1472
	GOTO	L_urx_1268
L__urx_1472:
;NodoAcelerometro.c,962 :: 		RecuperarTramaAceleracion(sectorReq, outputPyloadRS485);
	MOV	#lo_addr(_outputPyloadRS485), W12
	MOV	_sectorReq, W10
	MOV	_sectorReq+2, W11
	CALL	_RecuperarTramaAceleracion
;NodoAcelerometro.c,963 :: 		EnviarTramaRS485(1, IDNODO, 0xF3, 2507, outputPyloadRS485);
	MOV	#2507, W13
	MOV.B	#243, W12
	MOV.B	#5, W11
	MOV.B	#1, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;NodoAcelerometro.c,964 :: 		}
L_urx_1268:
;NodoAcelerometro.c,965 :: 		break;
	GOTO	L_urx_1252
;NodoAcelerometro.c,967 :: 		}
L_urx_1251:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1473
	GOTO	L_urx_1253
L__urx_1473:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1474
	GOTO	L_urx_1262
L__urx_1474:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1475
	GOTO	L_urx_1265
L__urx_1475:
L_urx_1252:
;NodoAcelerometro.c,969 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,970 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;NodoAcelerometro.c,972 :: 		}
L_urx_1250:
;NodoAcelerometro.c,974 :: 		}
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
