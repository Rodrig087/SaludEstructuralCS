
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
	BRA LTU	L__IncrementarFecha376
	GOTO	L_IncrementarFecha0
L__IncrementarFecha376:
;tiempo_rtc.c,199 :: 		dia++;
; dia start address is: 16 (W8)
	ADD	W6, #1, W8
	ADDC	W7, #0, W9
; dia end address is: 12 (W6)
;tiempo_rtc.c,200 :: 		} else {
; dia end address is: 16 (W8)
	MOV.D	W4, W6
	GOTO	L_IncrementarFecha1
L_IncrementarFecha0:
;tiempo_rtc.c,201 :: 		if (mes==2){
; dia start address is: 12 (W6)
	CP	W4, #2
	CPB	W5, #0
	BRA Z	L__IncrementarFecha377
	GOTO	L_IncrementarFecha2
L__IncrementarFecha377:
;tiempo_rtc.c,203 :: 		if (((anio-16)%4)==0){
	SUB	W2, #16, W0
	SUBB	W3, #0, W1
	AND	W0, #3, W0
	AND	W1, #0, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__IncrementarFecha378
	GOTO	L_IncrementarFecha3
L__IncrementarFecha378:
;tiempo_rtc.c,204 :: 		if (dia==29){
	CP	W6, #29
	CPB	W7, #0
	BRA Z	L__IncrementarFecha379
	GOTO	L_IncrementarFecha4
L__IncrementarFecha379:
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
	GOTO	L_IncrementarFecha5
L_IncrementarFecha4:
;tiempo_rtc.c,208 :: 		dia++;
; dia start address is: 0 (W0)
; dia start address is: 12 (W6)
	ADD	W6, #1, W0
	ADDC	W7, #0, W1
; dia end address is: 12 (W6)
; mes end address is: 8 (W4)
; dia end address is: 0 (W0)
;tiempo_rtc.c,209 :: 		}
L_IncrementarFecha5:
;tiempo_rtc.c,210 :: 		} else {
; dia start address is: 0 (W0)
; mes start address is: 8 (W4)
	MOV.D	W0, W8
; dia end address is: 0 (W0)
	MOV.D	W4, W6
	GOTO	L_IncrementarFecha6
L_IncrementarFecha3:
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
L_IncrementarFecha6:
;tiempo_rtc.c,214 :: 		} else {
; mes start address is: 12 (W6)
; dia start address is: 16 (W8)
; mes end address is: 12 (W6)
; dia end address is: 16 (W8)
	GOTO	L_IncrementarFecha7
L_IncrementarFecha2:
;tiempo_rtc.c,215 :: 		if (dia<30){
; mes start address is: 8 (W4)
; dia start address is: 12 (W6)
	CP	W6, #30
	CPB	W7, #0
	BRA LTU	L__IncrementarFecha380
	GOTO	L_IncrementarFecha8
L__IncrementarFecha380:
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
	GOTO	L_IncrementarFecha9
L_IncrementarFecha8:
;tiempo_rtc.c,218 :: 		if (mes==4||mes==6||mes==9||mes==11){
; dia start address is: 12 (W6)
	CP	W4, #4
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha381
	GOTO	L__IncrementarFecha232
L__IncrementarFecha381:
	CP	W4, #6
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha382
	GOTO	L__IncrementarFecha231
L__IncrementarFecha382:
	CP	W4, #9
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha383
	GOTO	L__IncrementarFecha230
L__IncrementarFecha383:
	CP	W4, #11
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha384
	GOTO	L__IncrementarFecha229
L__IncrementarFecha384:
	MOV.D	W4, W0
	MOV.D	W6, W4
	GOTO	L_IncrementarFecha12
L__IncrementarFecha232:
L__IncrementarFecha231:
L__IncrementarFecha230:
L__IncrementarFecha229:
;tiempo_rtc.c,219 :: 		if (dia==30){
	CP	W6, #30
	CPB	W7, #0
	BRA Z	L__IncrementarFecha385
	GOTO	L_IncrementarFecha13
L__IncrementarFecha385:
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
	GOTO	L_IncrementarFecha14
L_IncrementarFecha13:
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
L_IncrementarFecha14:
;tiempo_rtc.c,225 :: 		}
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
L_IncrementarFecha12:
;tiempo_rtc.c,226 :: 		if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
; mes start address is: 0 (W0)
; dia start address is: 8 (W4)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha386
	GOTO	L__IncrementarFecha242
L__IncrementarFecha386:
	CP	W0, #1
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha387
	GOTO	L__IncrementarFecha238
L__IncrementarFecha387:
	CP	W0, #3
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha388
	GOTO	L__IncrementarFecha237
L__IncrementarFecha388:
	CP	W0, #5
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha389
	GOTO	L__IncrementarFecha236
L__IncrementarFecha389:
	CP	W0, #7
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha390
	GOTO	L__IncrementarFecha235
L__IncrementarFecha390:
	CP	W0, #8
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha391
	GOTO	L__IncrementarFecha234
L__IncrementarFecha391:
	CP	W0, #10
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha392
	GOTO	L__IncrementarFecha233
L__IncrementarFecha392:
	GOTO	L_IncrementarFecha19
L__IncrementarFecha238:
L__IncrementarFecha237:
L__IncrementarFecha236:
L__IncrementarFecha235:
L__IncrementarFecha234:
L__IncrementarFecha233:
L__IncrementarFecha226:
;tiempo_rtc.c,227 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha393
	GOTO	L_IncrementarFecha20
L__IncrementarFecha393:
;tiempo_rtc.c,228 :: 		dia = 1;
	MOV	#1, W4
	MOV	#0, W5
;tiempo_rtc.c,229 :: 		mes++;
	ADD	W0, #1, W0
	ADDC	W1, #0, W1
;tiempo_rtc.c,230 :: 		} else {
	GOTO	L_IncrementarFecha21
L_IncrementarFecha20:
;tiempo_rtc.c,231 :: 		dia++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
;tiempo_rtc.c,232 :: 		}
L_IncrementarFecha21:
;tiempo_rtc.c,233 :: 		}
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
L_IncrementarFecha19:
;tiempo_rtc.c,226 :: 		if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
; mes start address is: 0 (W0)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
	GOTO	L__IncrementarFecha239
L__IncrementarFecha242:
L__IncrementarFecha239:
;tiempo_rtc.c,234 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha394
	GOTO	L__IncrementarFecha243
L__IncrementarFecha394:
	CP	W0, #12
	CPB	W1, #0
	BRA Z	L__IncrementarFecha395
	GOTO	L__IncrementarFecha244
L__IncrementarFecha395:
L__IncrementarFecha225:
;tiempo_rtc.c,235 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha396
	GOTO	L_IncrementarFecha25
L__IncrementarFecha396:
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
	GOTO	L_IncrementarFecha26
L_IncrementarFecha25:
;tiempo_rtc.c,240 :: 		dia++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
;tiempo_rtc.c,241 :: 		}
L_IncrementarFecha26:
;tiempo_rtc.c,234 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; anio start address is: 4 (W2)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha241
L__IncrementarFecha243:
L__IncrementarFecha241:
; mes start address is: 0 (W0)
; anio start address is: 4 (W2)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha240
L__IncrementarFecha244:
L__IncrementarFecha240:
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
L_IncrementarFecha9:
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
L_IncrementarFecha7:
;tiempo_rtc.c,246 :: 		}
; dia start address is: 16 (W8)
; anio start address is: 4 (W2)
; mes start address is: 12 (W6)
; mes end address is: 12 (W6)
; anio end address is: 4 (W2)
; dia end address is: 16 (W8)
L_IncrementarFecha1:
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

_GPS_init:

;tiempo_gps.c,13 :: 		void GPS_init(short conf,short NMA){
;tiempo_gps.c,45 :: 		UART1_Write_Text("$PMTK605*31\r\n");
	PUSH	W10
	PUSH	W11
	MOV	#lo_addr(?lstr1_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,46 :: 		UART1_Write_Text("$PMTK220,1000*1F\r\n");
	MOV	#lo_addr(?lstr2_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,47 :: 		UART1_Write_Text("$PMTK251,115200*1F\r\n");
	MOV	#lo_addr(?lstr3_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,48 :: 		Delay_ms(1000);                                                            //Tiempo necesario para que se de efecto el cambio de configuracion
	MOV	#123, W8
	MOV	#4681, W7
L_GPS_init27:
	DEC	W7
	BRA NZ	L_GPS_init27
	DEC	W8
	BRA NZ	L_GPS_init27
;tiempo_gps.c,49 :: 		UART1_Init(115200);
	MOV	#49664, W10
	MOV	#1, W11
	CALL	_UART1_Init
;tiempo_gps.c,50 :: 		UART1_Write_Text("$PMTK313,1*2E\r\n");
	MOV	#lo_addr(?lstr4_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,51 :: 		UART1_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29\r\n");
	MOV	#lo_addr(?lstr5_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,52 :: 		UART1_Write_Text("$PMTK319,1*24\r\n");
	MOV	#lo_addr(?lstr6_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,53 :: 		UART1_Write_Text("$PMTK413*34\r\n");
	MOV	#lo_addr(?lstr7_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,54 :: 		UART1_Write_Text("$PMTK513,1*28\r\n");
	MOV	#lo_addr(?lstr8_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,55 :: 		Delay_ms(1000);
	MOV	#123, W8
	MOV	#4681, W7
L_GPS_init29:
	DEC	W7
	BRA NZ	L_GPS_init29
	DEC	W8
	BRA NZ	L_GPS_init29
;tiempo_gps.c,56 :: 		U1MODE.UARTEN = 0;                                                         //Desactiva el UART1
	BCLR	U1MODE, #15
;tiempo_gps.c,57 :: 		}
L_end_GPS_init:
	POP	W11
	POP	W10
	RETURN
; end of _GPS_init

_RecuperarFechaGPS:
	LNK	#28

;tiempo_gps.c,62 :: 		unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS){
;tiempo_gps.c,67 :: 		char *ptrDatoStringF = &datoStringF;
	PUSH	W10
	ADD	W14, #16, W4
	MOV	W4, [W14+26]
; ptrDatoStringF start address is: 12 (W6)
	MOV	W4, W6
;tiempo_gps.c,68 :: 		datoStringF[2] = '\0';
	ADD	W4, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
;tiempo_gps.c,69 :: 		tramaFecha[3] = '\0';
	ADD	W14, #0, W3
	MOV	W3, [W14+24]
	ADD	W3, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;tiempo_gps.c,72 :: 		datoStringF[0] = tramaDatosGPS[10];
	ADD	W10, #10, W0
	MOV.B	[W0], [W4]
;tiempo_gps.c,73 :: 		datoStringF[1] = tramaDatosGPS[11];
	ADD	W4, #1, W1
	ADD	W10, #11, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,74 :: 		tramaFecha[0] = atoi(ptrDatoStringF);
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
;tiempo_gps.c,77 :: 		datoStringF[0] = tramaDatosGPS[8];
	ADD	W10, #8, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,78 :: 		datoStringF[1] = tramaDatosGPS[9];
	ADD	W0, #1, W1
	ADD	W10, #9, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,79 :: 		tramaFecha[1] = atoi(ptrDatoStringF);
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
;tiempo_gps.c,82 :: 		datoStringF[0] = tramaDatosGPS[6];
	ADD	W10, #6, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,83 :: 		datoStringF[1] = tramaDatosGPS[7];
	ADD	W0, #1, W1
	ADD	W10, #7, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,84 :: 		tramaFecha[2] =  atoi(ptrDatoStringF);
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
;tiempo_gps.c,86 :: 		fechaGPS = (tramaFecha[0]*10000)+(tramaFecha[1]*100)+(tramaFecha[2]);      //10000*aa + 100*mm + dd
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
;tiempo_gps.c,88 :: 		return fechaGPS;
;tiempo_gps.c,90 :: 		}
;tiempo_gps.c,88 :: 		return fechaGPS;
;tiempo_gps.c,90 :: 		}
L_end_RecuperarFechaGPS:
	POP	W10
	ULNK
	RETURN
; end of _RecuperarFechaGPS

_RecuperarHoraGPS:
	LNK	#28

;tiempo_gps.c,93 :: 		unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS){
;tiempo_gps.c,98 :: 		char *ptrDatoString = &datoString;
	PUSH	W10
	ADD	W14, #16, W4
	MOV	W4, [W14+26]
; ptrDatoString start address is: 12 (W6)
	MOV	W4, W6
;tiempo_gps.c,99 :: 		datoString[2] = '\0';
	ADD	W4, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
;tiempo_gps.c,100 :: 		tramaTiempo[3] = '\0';
	ADD	W14, #0, W3
	MOV	W3, [W14+24]
	ADD	W3, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;tiempo_gps.c,103 :: 		datoString[0] = tramaDatosGPS[0];
	MOV.B	[W10], [W4]
;tiempo_gps.c,104 :: 		datoString[1] = tramaDatosGPS[1];
	ADD	W4, #1, W1
	ADD	W10, #1, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,105 :: 		tramaTiempo[0] = atoi(ptrDatoString);
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
;tiempo_gps.c,108 :: 		datoString[0] = tramaDatosGPS[2];
	ADD	W10, #2, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,109 :: 		datoString[1] = tramaDatosGPS[3];
	ADD	W0, #1, W1
	ADD	W10, #3, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,110 :: 		tramaTiempo[1] = atoi(ptrDatoString);
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
;tiempo_gps.c,113 :: 		datoString[0] = tramaDatosGPS[4];
	ADD	W10, #4, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,114 :: 		datoString[1] = tramaDatosGPS[5];
	ADD	W0, #1, W1
	ADD	W10, #5, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,115 :: 		tramaTiempo[2] = atoi(ptrDatoString);
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
;tiempo_gps.c,117 :: 		horaGPS = (tramaTiempo[0]*3600)+(tramaTiempo[1]*60)+(tramaTiempo[2]);      //Calcula el segundo actual = hh*3600 + mm*60 + ss
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
;tiempo_gps.c,118 :: 		return horaGPS;
;tiempo_gps.c,120 :: 		}
;tiempo_gps.c,118 :: 		return horaGPS;
;tiempo_gps.c,120 :: 		}
L_end_RecuperarHoraGPS:
	POP	W10
	ULNK
	RETURN
; end of _RecuperarHoraGPS

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
	BRA Z	L__EnviarTramaRS485404
	GOTO	L__EnviarTramaRS485245
L__EnviarTramaRS485404:
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
L_EnviarTramaRS48532:
; iDatos start address is: 6 (W3)
; numDatosMSB start address is: 2 (W1)
; numDatosLSB start address is: 8 (W4)
; payload start address is: 4 (W2)
	CP	W3, W13
	BRA LTU	L__EnviarTramaRS485405
	GOTO	L_EnviarTramaRS48533
L__EnviarTramaRS485405:
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
	GOTO	L_EnviarTramaRS48532
L_EnviarTramaRS48533:
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
L_EnviarTramaRS48535:
; payload start address is: 2 (W1)
; numDatosLSB start address is: 4 (W2)
; numDatosMSB start address is: 6 (W3)
	CALL	_UART1_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485406
	GOTO	L_EnviarTramaRS48536
L__EnviarTramaRS485406:
	GOTO	L_EnviarTramaRS48535
L_EnviarTramaRS48536:
;rs485.c,44 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
; numDatosMSB end address is: 6 (W3)
; numDatosLSB end address is: 4 (W2)
; payload end address is: 2 (W1)
	MOV.B	W3, W0
;rs485.c,45 :: 		}
	GOTO	L_EnviarTramaRS48531
L__EnviarTramaRS485245:
;rs485.c,30 :: 		if (puertoUART == 1){
	MOV.B	W1, W0
	MOV	W2, W1
	MOV.B	W4, W2
;rs485.c,45 :: 		}
L_EnviarTramaRS48531:
;rs485.c,47 :: 		if (puertoUART == 2){
; numDatosMSB start address is: 0 (W0)
; numDatosLSB start address is: 4 (W2)
; payload start address is: 2 (W1)
	CP.B	W10, #2
	BRA Z	L__EnviarTramaRS485407
	GOTO	L_EnviarTramaRS48537
L__EnviarTramaRS485407:
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
L_EnviarTramaRS48538:
; iDatos start address is: 4 (W2)
; payload start address is: 2 (W1)
; payload end address is: 2 (W1)
	CP	W2, W13
	BRA LTU	L__EnviarTramaRS485408
	GOTO	L_EnviarTramaRS48539
L__EnviarTramaRS485408:
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
	GOTO	L_EnviarTramaRS48538
L_EnviarTramaRS48539:
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
L_EnviarTramaRS48541:
	CALL	_UART2_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485409
	GOTO	L_EnviarTramaRS48542
L__EnviarTramaRS485409:
	GOTO	L_EnviarTramaRS48541
L_EnviarTramaRS48542:
;rs485.c,61 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
;rs485.c,62 :: 		}
L_EnviarTramaRS48537:
;rs485.c,64 :: 		}
L_end_EnviarTramaRS485:
	ULNK
	RETURN
; end of _EnviarTramaRS485

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 50
	MOV	#4, W0
	IOR	68

;Master.c,106 :: 		void main() {
;Master.c,108 :: 		ConfiguracionPrincipal();
	PUSH	W10
	PUSH	W11
	CALL	_ConfiguracionPrincipal
;Master.c,109 :: 		GPS_init(1,1);
	MOV.B	#1, W11
	MOV.B	#1, W10
	CALL	_GPS_init
;Master.c,110 :: 		DS3234_init();
	CALL	_DS3234_init
;Master.c,115 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,116 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,117 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;Master.c,118 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;Master.c,121 :: 		banSPI0 = 0;
	MOV	#lo_addr(_banSPI0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,122 :: 		banSPI1 = 0;
	MOV	#lo_addr(_banSPI1), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,123 :: 		banSPI2 = 0;
	MOV	#lo_addr(_banSPI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,124 :: 		banSPI3 = 0;
	MOV	#lo_addr(_banSPI3), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,125 :: 		banSPI4 = 0;
	MOV	#lo_addr(_banSPI4), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,126 :: 		banSPI5 = 0;
	MOV	#lo_addr(_banSPI5), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,127 :: 		banSPI6 = 0;
	MOV	#lo_addr(_banSPI6), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,128 :: 		banSPI7 = 0;
	MOV	#lo_addr(_banSPI7), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,129 :: 		banSPI8 = 0;
	MOV	#lo_addr(_banSPI8), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,130 :: 		banSPI9 = 0;
	MOV	#lo_addr(_banSPI9), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,131 :: 		banSPIA = 0;
	MOV	#lo_addr(_banSPIA), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,134 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;Master.c,135 :: 		byteGPS = 0;
	MOV	#lo_addr(_byteGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,136 :: 		banGPSI = 0;
	MOV	#lo_addr(_banGPSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,137 :: 		banGPSC = 0;
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,138 :: 		banSetGPS = 0;
	MOV	#lo_addr(_banSetGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,139 :: 		contTimeout1 = 0;
	MOV	#lo_addr(_contTimeout1), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,142 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,143 :: 		banSyncReloj = 0;
	MOV	#lo_addr(_banSyncReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,144 :: 		banRespuestaPi = 0;
	MOV	#lo_addr(_banRespuestaPi), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,145 :: 		horaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,146 :: 		fechaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,147 :: 		fuenteReloj = 0;
	MOV	#lo_addr(_fuenteReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,148 :: 		referenciaTiempo = 0;
	MOV	#lo_addr(_referenciaTiempo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,151 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,152 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,153 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,154 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,155 :: 		funcionRS485 = 0;
	MOV	#lo_addr(_funcionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,156 :: 		subFuncionRS485 = 0;
	MOV	#lo_addr(_subFuncionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,157 :: 		numDatosRS485 = 0;
	CLR	W0
	MOV	W0, _numDatosRS485
;Master.c,158 :: 		ptrnumDatosRS485 = (unsigned char *) & numDatosRS485;
	MOV	#lo_addr(_numDatosRS485), W0
	MOV	W0, _ptrnumDatosRS485
;Master.c,161 :: 		banInicioMuestreo = 0;
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,164 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,165 :: 		INT_SINC = 1;                                                              //Enciende el pin TEST
	BSET	LATA1_bit, BitPos(LATA1_bit+0)
;Master.c,166 :: 		INT_SINC1 = 0;                                                             //Inicializa los pines de sincronizacion en 0
	BCLR	LATA0_bit, BitPos(LATA0_bit+0)
;Master.c,167 :: 		INT_SINC2 = 0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;Master.c,168 :: 		INT_SINC3 = 0;
	BCLR	LATB10_bit, BitPos(LATB10_bit+0)
;Master.c,169 :: 		INT_SINC4 = 0;
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,171 :: 		MSRS485 = 0;                                                               //Establece el Max485 en modo de lectura;
	BCLR	LATB11_bit, BitPos(LATB11_bit+0)
;Master.c,173 :: 		SPI1BUF = 0x00;
	CLR	SPI1BUF
;Master.c,175 :: 		while(1){
L_main43:
;Master.c,176 :: 		asm CLRWDT;         //Clear the watchdog timer
	CLRWDT
;Master.c,177 :: 		Delay_ms(100);
	MOV	#13, W8
	MOV	#13575, W7
L_main45:
	DEC	W7
	BRA NZ	L_main45
	DEC	W8
	BRA NZ	L_main45
;Master.c,178 :: 		}
	GOTO	L_main43
;Master.c,180 :: 		}
L_end_main:
	POP	W11
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;Master.c,189 :: 		void ConfiguracionPrincipal(){
;Master.c,192 :: 		CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	CLKDIVbits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, CLKDIVbits
;Master.c,193 :: 		CLKDIVbits.PLLPOST = 0;                                                    //N2=2
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;Master.c,194 :: 		CLKDIVbits.PLLPRE = 5;                                                     //N1=7
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;Master.c,195 :: 		PLLFBDbits.PLLDIV = 150;                                                   //M=152
	MOV	#150, W0
	MOV	W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	#511, W0
	AND	W1, W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	W1, PLLFBDbits
;Master.c,198 :: 		ANSELA = 0;                                                                //Configura PORTA como digital     *
	CLR	ANSELA
;Master.c,199 :: 		ANSELB = 0;                                                                //Configura PORTB como digital     *
	CLR	ANSELB
;Master.c,201 :: 		TRISA2_bit = 0;                                                            //RTC_CS
	BCLR	TRISA2_bit, BitPos(TRISA2_bit+0)
;Master.c,202 :: 		INT_SINC_Direction = 0;                                                    //INT_SINC
	BCLR	TRISA1_bit, BitPos(TRISA1_bit+0)
;Master.c,203 :: 		INT_SINC1_Direction = 0;                                                   //INT_SINC1
	BCLR	TRISA0_bit, BitPos(TRISA0_bit+0)
;Master.c,204 :: 		INT_SINC2_Direction = 0;                                                   //INT_SINC2
	BCLR	TRISA3_bit, BitPos(TRISA3_bit+0)
;Master.c,205 :: 		INT_SINC3_Direction = 0;                                                   //INT_SINC3
	BCLR	TRISB10_bit, BitPos(TRISB10_bit+0)
;Master.c,206 :: 		INT_SINC4_Direction = 0;                                                   //INT_SINC4
	BCLR	TRISB12_bit, BitPos(TRISB12_bit+0)
;Master.c,207 :: 		RP1_Direction = 0;                                                         //RP1
	BCLR	TRISA4_bit, BitPos(TRISA4_bit+0)
;Master.c,208 :: 		MSRS485_Direction = 0;                                                     //MSRS485
	BCLR	TRISB11_bit, BitPos(TRISB11_bit+0)
;Master.c,209 :: 		TRISB13_bit = 1;                                                           //SQW
	BSET	TRISB13_bit, BitPos(TRISB13_bit+0)
;Master.c,210 :: 		TRISB14_bit = 1;                                                           //PPS
	BSET	TRISB14_bit, BitPos(TRISB14_bit+0)
;Master.c,212 :: 		INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales *
	BSET	INTCON2, #15
;Master.c,215 :: 		RPINR18bits.U1RXR = 0x22;                                                  //Configura el pin RB2/RPI34 como Rx1
	MOV.B	#34, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#127, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPINR18bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPINR18bits), W0
	MOV.B	W1, [W0]
;Master.c,216 :: 		RPOR0bits.RP35R = 0x01;                                                    //Configura el Tx1 en el pin RB3/RP35
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR0bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR0bits
;Master.c,217 :: 		U1RXIE_bit = 1;                                                            //Habilita la interrupcion UART1 RX
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Master.c,218 :: 		IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#16384, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;Master.c,219 :: 		U1STAbits.URXISEL = 0x00;                                                  //Interrupt is set when any character is received and transferred from the UxRSR to the receive buffer; receive buffer has one or more characters
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;Master.c,220 :: 		UART1_Init(9600);                                                          //Inicializa el UART1 con una velocidad de 9600 baudios
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;Master.c,223 :: 		RPINR19bits.U2RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx2
	MOV.B	#47, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPINR19bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#127, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPINR19bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPINR19bits), W0
	MOV.B	W1, [W0]
;Master.c,224 :: 		RPOR1bits.RP36R = 0x03;                                                    //Configura el Tx2 en el pin RB4/RP36
	MOV.B	#3, W0
	MOV.B	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(RPOR1bits), W0
	MOV.B	W1, [W0]
;Master.c,225 :: 		U2RXIE_bit = 1;                                                            //Habilita la interrupcion UART2 RX
	BSET	U2RXIE_bit, BitPos(U2RXIE_bit+0)
;Master.c,226 :: 		IPC7bits.U2RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#1024, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC7bits
;Master.c,227 :: 		U2STAbits.URXISEL = 0x00;
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	W1, [W0]
;Master.c,228 :: 		UART2_Init_Advanced(2000000, _UART_8BIT_NOPARITY, _UART_ONE_STOPBIT, _UART_HI_SPEED);
	CLR	W13
	CLR	W12
	MOV	#33920, W10
	MOV	#30, W11
	MOV	#1, W0
	PUSH	W0
	CALL	_UART2_Init_Advanced
	SUB	#2, W15
;Master.c,231 :: 		SPI1STAT.SPIEN = 1;                                                        //Habilita el SPI1 *
	BSET	SPI1STAT, #15
;Master.c,232 :: 		SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
	MOV	#3, W13
	MOV	#28, W12
	CLR	W11
	CLR	W10
	CLR	W0
	PUSH	W0
	MOV	#64, W0
	PUSH	W0
	MOV	#512, W0
	PUSH	W0
	MOV	#128, W0
	PUSH	W0
	CALL	_SPI1_Init_Advanced
	SUB	#8, W15
;Master.c,233 :: 		SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Master.c,234 :: 		IPC2bits.SPI1IP = 0x03;                                                    //Prioridad de la interrupcion SPI1
	MOV	#768, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;Master.c,237 :: 		RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
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
;Master.c,238 :: 		RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
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
;Master.c,239 :: 		RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
	MOV	#2304, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR1bits
;Master.c,240 :: 		SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
	BSET	SPI2STAT, #15
;Master.c,241 :: 		SPI2_Init();                                                               //Inicializa el modulo SPI2
	CALL	_SPI2_Init
;Master.c,242 :: 		CS_DS3234 = 1;                                                             //Pone en alto el CS del RTC
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;Master.c,245 :: 		RPINR0 = 0x2D00;                                                           //Asigna INT1 al RB13/RPI45 (SQW)
	MOV	#11520, W0
	MOV	WREG, RPINR0
;Master.c,246 :: 		RPINR1 = 0x002E;                                                           //Asigna INT2 al RB14/RPI46 (PPS)
	MOV	#46, W0
	MOV	WREG, RPINR1
;Master.c,247 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;Master.c,248 :: 		INT2IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT2
	BCLR	INT2IF_bit, BitPos(INT2IF_bit+0)
;Master.c,249 :: 		IPC5bits.INT1IP = 0x02;                                                    //Prioridad en la interrupocion externa INT1
	MOV.B	#2, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;Master.c,250 :: 		IPC7bits.INT2IP = 0x01;                                                    //Prioridad en la interrupocion externa INT2
	MOV.B	#16, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR.B	W1, [W0], W1
	MOV.B	#112, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC7bits), W0
	MOV.B	W1, [W0]
;Master.c,253 :: 		T1CON = 0x30;                                                              //Prescalador
	MOV	#48, W0
	MOV	WREG, T1CON
;Master.c,254 :: 		T1CON.TON = 0;                                                             //Apaga el Timer1
	BCLR	T1CON, #15
;Master.c,255 :: 		T1IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR1
	BSET	T1IE_bit, BitPos(T1IE_bit+0)
;Master.c,256 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR1
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;Master.c,257 :: 		PR1 = 46875;                                                               //Carga el preload para un tiempo de 300ms
	MOV	#46875, W0
	MOV	WREG, PR1
;Master.c,258 :: 		IPC0bits.T1IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR1
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC0bits
;Master.c,261 :: 		T2CON = 0x30;                                                              //Prescalador
	MOV	#48, W0
	MOV	WREG, T2CON
;Master.c,262 :: 		T2CON.TON = 0;                                                             //Apaga el Timer2
	BCLR	T2CON, #15
;Master.c,263 :: 		T2IE_bit = 1;                                                              //Habilita la interrupción de desbordamiento TMR2
	BSET	T2IE_bit, BitPos(T2IE_bit+0)
;Master.c,264 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion del TMR2
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;Master.c,265 :: 		PR2 = 46875;                                                               //Carga el preload para un tiempo de 300ms
	MOV	#46875, W0
	MOV	WREG, PR2
;Master.c,266 :: 		IPC1bits.T2IP = 0x02;                                                      //Prioridad de la interrupcion por desbordamiento del TMR2
	MOV	#8192, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC1bits
;Master.c,269 :: 		SPI1IE_bit = 1;                                                            //SPI1
	BSET	SPI1IE_bit, BitPos(SPI1IE_bit+0)
;Master.c,270 :: 		INT1IE_bit = 1;                                                            //INT1
	BSET	INT1IE_bit, BitPos(INT1IE_bit+0)
;Master.c,271 :: 		INT2IE_bit = 1;                                                            //INT2
	BSET	INT2IE_bit, BitPos(INT2IE_bit+0)
;Master.c,273 :: 		Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#25, W8
	MOV	#27150, W7
L_ConfiguracionPrincipal47:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal47
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal47
	NOP
;Master.c,275 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_InterrupcionP1:

;Master.c,280 :: 		void InterrupcionP1(unsigned short funcionSPI, unsigned short subFuncionSPI, unsigned int numBytesSPI){
;Master.c,283 :: 		if ((funcionSPI==0xB1)&&(subFuncionSPI==0xD1)){
	PUSH	W13
	MOV.B	#177, W0
	CP.B	W10, W0
	BRA Z	L__InterrupcionP1414
	GOTO	L__InterrupcionP1248
L__InterrupcionP1414:
	MOV.B	#209, W0
	CP.B	W11, W0
	BRA Z	L__InterrupcionP1415
	GOTO	L__InterrupcionP1247
L__InterrupcionP1415:
L__InterrupcionP1246:
;Master.c,285 :: 		outputPyloadRS485[0] = 0xD1;
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#209, W0
	MOV.B	W0, [W1]
;Master.c,286 :: 		for (x=1;x<7;x++){                                                      //Subfuncion
	MOV	#1, W0
	MOV	W0, _x
L_InterrupcionP152:
	MOV	_x, W0
	CP	W0, #7
	BRA LTU	L__InterrupcionP1416
	GOTO	L_InterrupcionP153
L__InterrupcionP1416:
;Master.c,287 :: 		outputPyloadRS485[x] = tiempo[x-1];                                 //Trama de tiempo
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_tiempo), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Master.c,286 :: 		for (x=1;x<7;x++){                                                      //Subfuncion
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;Master.c,288 :: 		}
	GOTO	L_InterrupcionP152
L_InterrupcionP153:
;Master.c,289 :: 		outputPyloadRS485[7] = fuenteReloj;                                     //Fuente de reloj
	MOV	#lo_addr(_outputPyloadRS485+7), W1
	MOV	#lo_addr(_fuenteReloj), W0
	MOV.B	[W0], [W1]
;Master.c,290 :: 		EnviarTramaRS485(2, 255, 0xF1, 8, outputPyloadRS485);                   //Envia la hora local a los nodos
	PUSH	W12
	PUSH.D	W10
	MOV	#8, W13
	MOV.B	#241, W12
	MOV.B	#255, W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
	POP.D	W10
	POP	W12
;Master.c,283 :: 		if ((funcionSPI==0xB1)&&(subFuncionSPI==0xD1)){
L__InterrupcionP1248:
L__InterrupcionP1247:
;Master.c,293 :: 		if (banRespuestaPi==1){
	MOV	#lo_addr(_banRespuestaPi), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__InterrupcionP1417
	GOTO	L_InterrupcionP155
L__InterrupcionP1417:
;Master.c,295 :: 		ptrnumBytesSPI = (unsigned char *) & numBytesSPI;
	MOV	#lo_addr(W12), W2
	MOV	W2, _ptrnumBytesSPI
;Master.c,297 :: 		tramaSolicitudSPI[0] = funcionSPI;                                     //Operacion solicitada
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV.B	W10, [W0]
;Master.c,298 :: 		tramaSolicitudSPI[1] = subFuncionSPI;                                  //Subfuncion solicitada
	MOV	#lo_addr(_tramaSolicitudSPI+1), W0
	MOV.B	W11, [W0]
;Master.c,299 :: 		tramaSolicitudSPI[2] = *(ptrnumBytesSPI);                              //LSB numBytesSPI
	MOV.B	[W2], W1
	MOV	#lo_addr(_tramaSolicitudSPI+2), W0
	MOV.B	W1, [W0]
;Master.c,300 :: 		tramaSolicitudSPI[3] = *(ptrnumBytesSPI+1);                            //MSB numBytesSPI
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_tramaSolicitudSPI+3), W0
	MOV.B	W1, [W0]
;Master.c,302 :: 		RP1 = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,303 :: 		Delay_us(20);
	MOV	#160, W7
L_InterrupcionP156:
	DEC	W7
	BRA NZ	L_InterrupcionP156
	NOP
	NOP
;Master.c,304 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,305 :: 		banRespuestaPi = 0;
	MOV	#lo_addr(_banRespuestaPi), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,306 :: 		}
L_InterrupcionP155:
;Master.c,307 :: 		}
L_end_InterrupcionP1:
	POP	W13
	RETURN
; end of _InterrupcionP1

_CambiarEstadoBandera:

;Master.c,312 :: 		void CambiarEstadoBandera(unsigned short bandera, unsigned short estado){
;Master.c,314 :: 		if (estado==1){
	CP.B	W11, #1
	BRA Z	L__CambiarEstadoBandera419
	GOTO	L_CambiarEstadoBandera58
L__CambiarEstadoBandera419:
;Master.c,316 :: 		banSPI0 = 3;
	MOV	#lo_addr(_banSPI0), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;Master.c,317 :: 		banSPI1 = 3;
	MOV	#lo_addr(_banSPI1), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;Master.c,318 :: 		banSPI2 = 3;
	MOV	#lo_addr(_banSPI2), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;Master.c,319 :: 		banSPI4 = 3;
	MOV	#lo_addr(_banSPI4), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;Master.c,320 :: 		banSPI5 = 3;
	MOV	#lo_addr(_banSPI5), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;Master.c,321 :: 		banSPI6 = 3;
	MOV	#lo_addr(_banSPI6), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;Master.c,322 :: 		banSPI7 = 3;
	MOV	#lo_addr(_banSPI7), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;Master.c,323 :: 		banSPI8 = 3;
	MOV	#lo_addr(_banSPI8), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;Master.c,324 :: 		banSPIA = 3;
	MOV	#lo_addr(_banSPIA), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;Master.c,326 :: 		switch (bandera){
	GOTO	L_CambiarEstadoBandera59
;Master.c,327 :: 		case 0:
L_CambiarEstadoBandera61:
;Master.c,328 :: 		banSPI0 = 1;
	MOV	#lo_addr(_banSPI0), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,329 :: 		break;
	GOTO	L_CambiarEstadoBandera60
;Master.c,330 :: 		case 1:
L_CambiarEstadoBandera62:
;Master.c,331 :: 		banSPI1 = 1;
	MOV	#lo_addr(_banSPI1), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,332 :: 		break;
	GOTO	L_CambiarEstadoBandera60
;Master.c,333 :: 		case 2:
L_CambiarEstadoBandera63:
;Master.c,334 :: 		banSPI2 = 1;
	MOV	#lo_addr(_banSPI2), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,335 :: 		break;
	GOTO	L_CambiarEstadoBandera60
;Master.c,336 :: 		case 4:
L_CambiarEstadoBandera64:
;Master.c,337 :: 		banSPI4 = 1;
	MOV	#lo_addr(_banSPI4), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,338 :: 		break;
	GOTO	L_CambiarEstadoBandera60
;Master.c,339 :: 		case 5:
L_CambiarEstadoBandera65:
;Master.c,340 :: 		banSPI5 = 1;
	MOV	#lo_addr(_banSPI5), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,341 :: 		break;
	GOTO	L_CambiarEstadoBandera60
;Master.c,342 :: 		case 6:
L_CambiarEstadoBandera66:
;Master.c,343 :: 		banSPI6 = 1;
	MOV	#lo_addr(_banSPI6), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,344 :: 		break;
	GOTO	L_CambiarEstadoBandera60
;Master.c,345 :: 		case 7:
L_CambiarEstadoBandera67:
;Master.c,346 :: 		banSPI7 = 1;
	MOV	#lo_addr(_banSPI7), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,347 :: 		break;
	GOTO	L_CambiarEstadoBandera60
;Master.c,348 :: 		case 8:
L_CambiarEstadoBandera68:
;Master.c,349 :: 		banSPI8 = 1;
	MOV	#lo_addr(_banSPI8), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,350 :: 		break;
	GOTO	L_CambiarEstadoBandera60
;Master.c,351 :: 		case 0x0A:
L_CambiarEstadoBandera69:
;Master.c,352 :: 		banSPIA = 1;
	MOV	#lo_addr(_banSPIA), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,353 :: 		break;
	GOTO	L_CambiarEstadoBandera60
;Master.c,354 :: 		}
L_CambiarEstadoBandera59:
	CP.B	W10, #0
	BRA NZ	L__CambiarEstadoBandera420
	GOTO	L_CambiarEstadoBandera61
L__CambiarEstadoBandera420:
	CP.B	W10, #1
	BRA NZ	L__CambiarEstadoBandera421
	GOTO	L_CambiarEstadoBandera62
L__CambiarEstadoBandera421:
	CP.B	W10, #2
	BRA NZ	L__CambiarEstadoBandera422
	GOTO	L_CambiarEstadoBandera63
L__CambiarEstadoBandera422:
	CP.B	W10, #4
	BRA NZ	L__CambiarEstadoBandera423
	GOTO	L_CambiarEstadoBandera64
L__CambiarEstadoBandera423:
	CP.B	W10, #5
	BRA NZ	L__CambiarEstadoBandera424
	GOTO	L_CambiarEstadoBandera65
L__CambiarEstadoBandera424:
	CP.B	W10, #6
	BRA NZ	L__CambiarEstadoBandera425
	GOTO	L_CambiarEstadoBandera66
L__CambiarEstadoBandera425:
	CP.B	W10, #7
	BRA NZ	L__CambiarEstadoBandera426
	GOTO	L_CambiarEstadoBandera67
L__CambiarEstadoBandera426:
	CP.B	W10, #8
	BRA NZ	L__CambiarEstadoBandera427
	GOTO	L_CambiarEstadoBandera68
L__CambiarEstadoBandera427:
	CP.B	W10, #10
	BRA NZ	L__CambiarEstadoBandera428
	GOTO	L_CambiarEstadoBandera69
L__CambiarEstadoBandera428:
L_CambiarEstadoBandera60:
;Master.c,355 :: 		}
L_CambiarEstadoBandera58:
;Master.c,358 :: 		if (estado==0){
	CP.B	W11, #0
	BRA Z	L__CambiarEstadoBandera429
	GOTO	L_CambiarEstadoBandera70
L__CambiarEstadoBandera429:
;Master.c,359 :: 		banSPI0 = 0;
	MOV	#lo_addr(_banSPI0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,360 :: 		banSPI1 = 0;
	MOV	#lo_addr(_banSPI1), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,361 :: 		banSPI2 = 0;
	MOV	#lo_addr(_banSPI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,362 :: 		banSPI4 = 0;
	MOV	#lo_addr(_banSPI4), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,363 :: 		banSPI5 = 0;
	MOV	#lo_addr(_banSPI5), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,364 :: 		banSPI6 = 0;
	MOV	#lo_addr(_banSPI6), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,365 :: 		banSPI7 = 0;
	MOV	#lo_addr(_banSPI7), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,366 :: 		banSPI8 = 0;
	MOV	#lo_addr(_banSPI8), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,367 :: 		banSPIA = 0;
	MOV	#lo_addr(_banSPIA), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,368 :: 		}
L_CambiarEstadoBandera70:
;Master.c,369 :: 		}
L_end_CambiarEstadoBandera:
	RETURN
; end of _CambiarEstadoBandera

_spi_1:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Master.c,379 :: 		void spi_1() org  IVT_ADDR_SPI1INTERRUPT {
;Master.c,381 :: 		SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Master.c,382 :: 		bufferSPI = SPI1BUF;                                                       //Guarda el contenido del bufeer (lectura)
	MOV	#lo_addr(_bufferSPI), W1
	MOV.B	SPI1BUF, WREG
	MOV.B	W0, [W1]
;Master.c,386 :: 		if ((banSPI0==0)&&(bufferSPI==0xA0)) {
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1431
	GOTO	L__spi_1279
L__spi_1431:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#160, W0
	CP.B	W1, W0
	BRA Z	L__spi_1432
	GOTO	L__spi_1278
L__spi_1432:
L__spi_1277:
;Master.c,387 :: 		CambiarEstadoBandera(0,1);                                              //Activa la bandera para enviar el tipo de operacion requerido a la RPi
	MOV.B	#1, W11
	CLR	W10
	CALL	_CambiarEstadoBandera
;Master.c,388 :: 		i = 1;
	MOV	#1, W0
	MOV	W0, _i
;Master.c,389 :: 		SPI1BUF = tramaSolicitudSPI[0];                                         //Carga en el buffer la funcion requerida
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Master.c,386 :: 		if ((banSPI0==0)&&(bufferSPI==0xA0)) {
L__spi_1279:
L__spi_1278:
;Master.c,391 :: 		if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1433
	GOTO	L__spi_1282
L__spi_1433:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#160, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1434
	GOTO	L__spi_1281
L__spi_1434:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#240, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1435
	GOTO	L__spi_1280
L__spi_1435:
L__spi_1276:
;Master.c,392 :: 		SPI1BUF = tramaSolicitudSPI[i];                                         //Se envia la subfuncion, y el LSB y MSB de la variable numBytesSPI
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,393 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,391 :: 		if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
L__spi_1282:
L__spi_1281:
L__spi_1280:
;Master.c,395 :: 		if ((banSPI0==1)&&(bufferSPI==0xF0)){
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1436
	GOTO	L__spi_1284
L__spi_1436:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#240, W0
	CP.B	W1, W0
	BRA Z	L__spi_1437
	GOTO	L__spi_1283
L__spi_1437:
L__spi_1275:
;Master.c,396 :: 		CambiarEstadoBandera(0,0);                                              //Limpia las banderas
	CLR	W11
	CLR	W10
	CALL	_CambiarEstadoBandera
;Master.c,395 :: 		if ((banSPI0==1)&&(bufferSPI==0xF0)){
L__spi_1284:
L__spi_1283:
;Master.c,404 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)){
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1438
	GOTO	L__spi_1286
L__spi_1438:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#161, W0
	CP.B	W1, W0
	BRA Z	L__spi_1439
	GOTO	L__spi_1285
L__spi_1439:
L__spi_1274:
;Master.c,405 :: 		CambiarEstadoBandera(1,1);
	MOV.B	#1, W11
	MOV.B	#1, W10
	CALL	_CambiarEstadoBandera
;Master.c,406 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,404 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)){
L__spi_1286:
L__spi_1285:
;Master.c,408 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1440
	GOTO	L__spi_1289
L__spi_1440:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#161, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1441
	GOTO	L__spi_1288
L__spi_1441:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1442
	GOTO	L__spi_1287
L__spi_1442:
L__spi_1273:
;Master.c,409 :: 		tramaSolicitudSPI[i] = bufferSPI;                                       //Recupera la direccion del nodo y el indicador de sobrescritura de la SD
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,410 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,408 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
L__spi_1289:
L__spi_1288:
L__spi_1287:
;Master.c,412 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1443
	GOTO	L__spi_1291
L__spi_1443:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA Z	L__spi_1444
	GOTO	L__spi_1290
L__spi_1444:
L__spi_1272:
;Master.c,413 :: 		direccionRS485 = tramaSolicitudSPI[0];
	MOV	#lo_addr(_direccionRS485), W1
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV.B	[W0], [W1]
;Master.c,414 :: 		outputPyloadRS485[0] = 0xD1;                                            //Subfuncion iniciar muestreo
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#209, W0
	MOV.B	W0, [W1]
;Master.c,415 :: 		outputPyloadRS485[1] = tramaSolicitudSPI[1];                            //Payload sobrescribir SD
	MOV	#lo_addr(_outputPyloadRS485+1), W1
	MOV	#lo_addr(_tramaSolicitudSPI+1), W0
	MOV.B	[W0], [W1]
;Master.c,416 :: 		EnviarTramaRS485(2, direccionRS485, 0xF2, 2, outputPyloadRS485);        //Envia la solicitud al nodo
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV	#2, W13
	MOV.B	#242, W12
	MOV.B	[W0], W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;Master.c,417 :: 		CambiarEstadoBandera(1,0);                                              //Limpia la bandera
	CLR	W11
	MOV.B	#1, W10
	CALL	_CambiarEstadoBandera
;Master.c,412 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
L__spi_1291:
L__spi_1290:
;Master.c,421 :: 		if ((banSPI2==0)&&(bufferSPI==0xA2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1445
	GOTO	L__spi_1293
L__spi_1445:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#162, W0
	CP.B	W1, W0
	BRA Z	L__spi_1446
	GOTO	L__spi_1292
L__spi_1446:
L__spi_1271:
;Master.c,422 :: 		CambiarEstadoBandera(2,1);
	MOV.B	#1, W11
	MOV.B	#2, W10
	CALL	_CambiarEstadoBandera
;Master.c,423 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,421 :: 		if ((banSPI2==0)&&(bufferSPI==0xA2)){
L__spi_1293:
L__spi_1292:
;Master.c,425 :: 		if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1447
	GOTO	L__spi_1296
L__spi_1447:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#162, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1448
	GOTO	L__spi_1295
L__spi_1448:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1449
	GOTO	L__spi_1294
L__spi_1449:
L__spi_1270:
;Master.c,426 :: 		tramaSolicitudSPI[i] = bufferSPI;                                       //Recupera la direccion del nodo
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,425 :: 		if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
L__spi_1296:
L__spi_1295:
L__spi_1294:
;Master.c,428 :: 		if ((banSPI2==1)&&(bufferSPI==0xF2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1450
	GOTO	L__spi_1298
L__spi_1450:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA Z	L__spi_1451
	GOTO	L__spi_1297
L__spi_1451:
L__spi_1269:
;Master.c,429 :: 		direccionRS485 = tramaSolicitudSPI[0];
	MOV	#lo_addr(_direccionRS485), W1
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV.B	[W0], [W1]
;Master.c,430 :: 		outputPyloadRS485[0] = 0xD2;                                            //Subfuncion detener muestreo
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;Master.c,431 :: 		EnviarTramaRS485(2, direccionRS485, 0xF2, 1, outputPyloadRS485);        //Envia la solicitud al nodo
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV	#1, W13
	MOV.B	#242, W12
	MOV.B	[W0], W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;Master.c,432 :: 		CambiarEstadoBandera(2,0);                                              //Limpia las banderas
	CLR	W11
	MOV.B	#2, W10
	CALL	_CambiarEstadoBandera
;Master.c,428 :: 		if ((banSPI2==1)&&(bufferSPI==0xF2)){
L__spi_1298:
L__spi_1297:
;Master.c,441 :: 		if ((banSPI4==0)&&(bufferSPI==0xA4)){
	MOV	#lo_addr(_banSPI4), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1452
	GOTO	L__spi_1300
L__spi_1452:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#164, W0
	CP.B	W1, W0
	BRA Z	L__spi_1453
	GOTO	L__spi_1299
L__spi_1453:
L__spi_1268:
;Master.c,442 :: 		CambiarEstadoBandera(4,1);
	MOV.B	#1, W11
	MOV.B	#4, W10
	CALL	_CambiarEstadoBandera
;Master.c,443 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,441 :: 		if ((banSPI4==0)&&(bufferSPI==0xA4)){
L__spi_1300:
L__spi_1299:
;Master.c,445 :: 		if ((banSPI4==1)&&(bufferSPI!=0xA4)&&(bufferSPI!=0xF4)){
	MOV	#lo_addr(_banSPI4), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1454
	GOTO	L__spi_1303
L__spi_1454:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#164, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1455
	GOTO	L__spi_1302
L__spi_1455:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#244, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1456
	GOTO	L__spi_1301
L__spi_1456:
L__spi_1267:
;Master.c,446 :: 		tiempoRPI[j] = bufferSPI;
	MOV	#lo_addr(_tiempoRPI), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,447 :: 		j++;
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;Master.c,445 :: 		if ((banSPI4==1)&&(bufferSPI!=0xA4)&&(bufferSPI!=0xF4)){
L__spi_1303:
L__spi_1302:
L__spi_1301:
;Master.c,449 :: 		if ((banSPI4==1)&&(bufferSPI==0xF4)){
	MOV	#lo_addr(_banSPI4), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1457
	GOTO	L__spi_1305
L__spi_1457:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#244, W0
	CP.B	W1, W0
	BRA Z	L__spi_1458
	GOTO	L__spi_1304
L__spi_1458:
L__spi_1266:
;Master.c,450 :: 		CambiarEstadoBandera(4,0);                                              //Limpia las banderas
	CLR	W11
	MOV.B	#4, W10
	CALL	_CambiarEstadoBandera
;Master.c,451 :: 		horaSistema = RecuperarHoraRPI(tiempoRPI);                              //Recupera la hora de la RPi
	MOV	#lo_addr(_tiempoRPI), W10
	CALL	_RecuperarHoraRPI
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,452 :: 		fechaSistema = RecuperarFechaRPI(tiempoRPI);                            //Recupera la fecha de la RPi
	MOV	#lo_addr(_tiempoRPI), W10
	CALL	_RecuperarFechaRPI
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,453 :: 		DS3234_setDate(horaSistema, fechaSistema);                              //Configura la hora en el RTC
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	CALL	_DS3234_setDate
;Master.c,454 :: 		horaSistema = RecuperarHoraRTC();                                       //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,455 :: 		fechaSistema = RecuperarFechaRTC();                                     //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,456 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,457 :: 		fuenteReloj = 0;                                                        //Fuente de reloj = RED
	MOV	#lo_addr(_fuenteReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,458 :: 		banSetReloj = 1;                                                        //Activa esta bandera para usar la hora/fecha recuperada
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,459 :: 		banRespuestaPi = 1;                                                     //Activa esta bandera para enviar una respuesta a la RPi
	MOV	#lo_addr(_banRespuestaPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,460 :: 		InterrupcionP1(0xB1,0xD1,8);                                            //Envia la hora local a la RPi y a los nodos
	MOV	#8, W12
	MOV.B	#209, W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,449 :: 		if ((banSPI4==1)&&(bufferSPI==0xF4)){
L__spi_1305:
L__spi_1304:
;Master.c,465 :: 		if ((banSPI5==0)&&(bufferSPI==0xA5)){
	MOV	#lo_addr(_banSPI5), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1459
	GOTO	L__spi_1307
L__spi_1459:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#165, W0
	CP.B	W1, W0
	BRA Z	L__spi_1460
	GOTO	L__spi_1306
L__spi_1460:
L__spi_1265:
;Master.c,466 :: 		CambiarEstadoBandera(5,1);
	MOV.B	#1, W11
	MOV.B	#5, W10
	CALL	_CambiarEstadoBandera
;Master.c,467 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,468 :: 		SPI1BUF = fuenteReloj;                                                  //Envia el indicador de fuente de reloj (0:RTC, 1:GPS)
	MOV	#lo_addr(_fuenteReloj), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Master.c,465 :: 		if ((banSPI5==0)&&(bufferSPI==0xA5)){
L__spi_1307:
L__spi_1306:
;Master.c,470 :: 		if ((banSPI5==1)&&(bufferSPI!=0xA5)&&(bufferSPI!=0xF5)){
	MOV	#lo_addr(_banSPI5), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1461
	GOTO	L__spi_1310
L__spi_1461:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#165, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1462
	GOTO	L__spi_1309
L__spi_1462:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#245, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1463
	GOTO	L__spi_1308
L__spi_1463:
L__spi_1264:
;Master.c,471 :: 		SPI1BUF = tiempo[j];
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,472 :: 		j++;
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;Master.c,470 :: 		if ((banSPI5==1)&&(bufferSPI!=0xA5)&&(bufferSPI!=0xF5)){
L__spi_1310:
L__spi_1309:
L__spi_1308:
;Master.c,474 :: 		if ((banSPI5==1)&&(bufferSPI==0xF5)){
	MOV	#lo_addr(_banSPI5), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1464
	GOTO	L__spi_1312
L__spi_1464:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#245, W0
	CP.B	W1, W0
	BRA Z	L__spi_1465
	GOTO	L__spi_1311
L__spi_1465:
L__spi_1263:
;Master.c,475 :: 		CambiarEstadoBandera(5,0);                                              //Limpia las banderas
	CLR	W11
	MOV.B	#5, W10
	CALL	_CambiarEstadoBandera
;Master.c,474 :: 		if ((banSPI5==1)&&(bufferSPI==0xF5)){
L__spi_1312:
L__spi_1311:
;Master.c,480 :: 		if ((banSPI6==0)&&(bufferSPI==0xA6)){
	MOV	#lo_addr(_banSPI6), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1466
	GOTO	L__spi_1314
L__spi_1466:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#166, W0
	CP.B	W1, W0
	BRA Z	L__spi_1467
	GOTO	L__spi_1313
L__spi_1467:
L__spi_1262:
;Master.c,481 :: 		CambiarEstadoBandera(6,1);
	MOV.B	#1, W11
	MOV.B	#6, W10
	CALL	_CambiarEstadoBandera
;Master.c,480 :: 		if ((banSPI6==0)&&(bufferSPI==0xA6)){
L__spi_1314:
L__spi_1313:
;Master.c,483 :: 		if ((banSPI6==1)&&(bufferSPI!=0xA6)&&(bufferSPI!=0xF6)){
	MOV	#lo_addr(_banSPI6), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1468
	GOTO	L__spi_1317
L__spi_1468:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#166, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1469
	GOTO	L__spi_1316
L__spi_1469:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#246, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1470
	GOTO	L__spi_1315
L__spi_1470:
L__spi_1261:
;Master.c,484 :: 		referenciaTiempo =  bufferSPI;                                          //Recupera la opcion de referencia de tiempo solicitada
	MOV	#lo_addr(_referenciaTiempo), W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,483 :: 		if ((banSPI6==1)&&(bufferSPI!=0xA6)&&(bufferSPI!=0xF6)){
L__spi_1317:
L__spi_1316:
L__spi_1315:
;Master.c,486 :: 		if ((banSPI6==1)&&(bufferSPI==0xF6)){
	MOV	#lo_addr(_banSPI6), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1471
	GOTO	L__spi_1319
L__spi_1471:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#246, W0
	CP.B	W1, W0
	BRA Z	L__spi_1472
	GOTO	L__spi_1318
L__spi_1472:
L__spi_1260:
;Master.c,487 :: 		CambiarEstadoBandera(6,0);                                              //Limpia las banderas
	CLR	W11
	MOV.B	#6, W10
	CALL	_CambiarEstadoBandera
;Master.c,488 :: 		banSetReloj = 1;                                                        //Activa esta bandera para usar la hora/fecha recuperada
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,489 :: 		banRespuestaPi = 1;                                                     //Activa esta bandera para enviar una respuesta a la RPi
	MOV	#lo_addr(_banRespuestaPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,490 :: 		if (referenciaTiempo==1){
	MOV	#lo_addr(_referenciaTiempo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1473
	GOTO	L_spi_1125
L__spi_1473:
;Master.c,492 :: 		banGPSI = 1;                                                        //Activa la bandera de inicio de trama  del GPS
	MOV	#lo_addr(_banGPSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,493 :: 		banGPSC = 0;                                                        //Limpia la bandera de trama completa
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,494 :: 		U1MODE.UARTEN = 1;                                                  //Inicializa el UART1
	BSET	U1MODE, #15
;Master.c,496 :: 		T1CON.TON = 1;
	BSET	T1CON, #15
;Master.c,497 :: 		TMR1 = 0;
	CLR	TMR1
;Master.c,498 :: 		} else {
	GOTO	L_spi_1126
L_spi_1125:
;Master.c,500 :: 		horaSistema = RecuperarHoraRTC();                                   //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,501 :: 		fechaSistema = RecuperarFechaRTC();                                 //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,502 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);            //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,503 :: 		fuenteReloj = 2;                                                    //Fuente de reloj = RTC
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,504 :: 		InterrupcionP1(0xB1,0xD1,8);                                        //Envia la hora local a la RPi
	MOV	#8, W12
	MOV.B	#209, W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,505 :: 		}
L_spi_1126:
;Master.c,486 :: 		if ((banSPI6==1)&&(bufferSPI==0xF6)){
L__spi_1319:
L__spi_1318:
;Master.c,510 :: 		if ((banSPI7==0)&&(bufferSPI==0xA7)){
	MOV	#lo_addr(_banSPI7), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1474
	GOTO	L__spi_1321
L__spi_1474:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#167, W0
	CP.B	W1, W0
	BRA Z	L__spi_1475
	GOTO	L__spi_1320
L__spi_1475:
L__spi_1259:
;Master.c,511 :: 		CambiarEstadoBandera(7,1);
	MOV.B	#1, W11
	MOV.B	#7, W10
	CALL	_CambiarEstadoBandera
;Master.c,512 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,510 :: 		if ((banSPI7==0)&&(bufferSPI==0xA7)){
L__spi_1321:
L__spi_1320:
;Master.c,514 :: 		if ((banSPI7==1)&&(bufferSPI!=0xA7)&&(bufferSPI!=0xF7)){
	MOV	#lo_addr(_banSPI7), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1476
	GOTO	L__spi_1324
L__spi_1476:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#167, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1477
	GOTO	L__spi_1323
L__spi_1477:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#247, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1478
	GOTO	L__spi_1322
L__spi_1478:
L__spi_1258:
;Master.c,515 :: 		tramaSolicitudSPI[i] = bufferSPI;
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,514 :: 		if ((banSPI7==1)&&(bufferSPI!=0xA7)&&(bufferSPI!=0xF7)){
L__spi_1324:
L__spi_1323:
L__spi_1322:
;Master.c,517 :: 		if ((banSPI7==1)&&(bufferSPI==0xF7)){
	MOV	#lo_addr(_banSPI7), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1479
	GOTO	L__spi_1326
L__spi_1479:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#247, W0
	CP.B	W1, W0
	BRA Z	L__spi_1480
	GOTO	L__spi_1325
L__spi_1480:
L__spi_1257:
;Master.c,518 :: 		direccionRS485 =  tramaSolicitudSPI[i];
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W2
	MOV	#lo_addr(_direccionRS485), W0
	MOV.B	W2, [W0]
;Master.c,519 :: 		outputPyloadRS485[0] = 0xD2;                                            //Llena el pyload de salidas con la subfuncion solicitada
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;Master.c,520 :: 		EnviarTramaRS485(2, direccionRS485, 0xF1, 1, outputPyloadRS485);        //Envia la solicitud al nodo
	MOV	#1, W13
	MOV.B	#241, W12
	MOV.B	W2, W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;Master.c,521 :: 		banRespuestaPi = 1;
	MOV	#lo_addr(_banRespuestaPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,522 :: 		CambiarEstadoBandera(7,0);                                              //Limpia las banderas
	CLR	W11
	MOV.B	#7, W10
	CALL	_CambiarEstadoBandera
;Master.c,517 :: 		if ((banSPI7==1)&&(bufferSPI==0xF7)){
L__spi_1326:
L__spi_1325:
;Master.c,527 :: 		if ((banSPI8==0)&&(bufferSPI==0xA8)){
	MOV	#lo_addr(_banSPI8), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1481
	GOTO	L__spi_1328
L__spi_1481:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#168, W0
	CP.B	W1, W0
	BRA Z	L__spi_1482
	GOTO	L__spi_1327
L__spi_1482:
L__spi_1256:
;Master.c,528 :: 		CambiarEstadoBandera(8,1);
	MOV.B	#1, W11
	MOV.B	#8, W10
	CALL	_CambiarEstadoBandera
;Master.c,529 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,527 :: 		if ((banSPI8==0)&&(bufferSPI==0xA8)){
L__spi_1328:
L__spi_1327:
;Master.c,532 :: 		if ((banSPI8==1)&&(i<4)){
	MOV	#lo_addr(_banSPI8), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1483
	GOTO	L__spi_1330
L__spi_1483:
	MOV	_i, W0
	CP	W0, #4
	BRA LTU	L__spi_1484
	GOTO	L__spi_1329
L__spi_1484:
L__spi_1255:
;Master.c,533 :: 		tramaSolicitudNodo[i] = bufferSPI;
	MOV	#lo_addr(_tramaSolicitudNodo), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,534 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,532 :: 		if ((banSPI8==1)&&(i<4)){
L__spi_1330:
L__spi_1329:
;Master.c,537 :: 		if ((banSPI8==1)&&(i==4)){
	MOV	#lo_addr(_banSPI8), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1485
	GOTO	L__spi_1332
L__spi_1485:
	MOV	_i, W0
	CP	W0, #4
	BRA Z	L__spi_1486
	GOTO	L__spi_1331
L__spi_1486:
L__spi_1254:
;Master.c,538 :: 		direccionRS485 = tramaSolicitudNodo[1];
	MOV	#lo_addr(_direccionRS485), W1
	MOV	#lo_addr(_tramaSolicitudNodo+1), W0
	MOV.B	[W0], [W1]
;Master.c,539 :: 		funcionRS485 = tramaSolicitudNodo[2];
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_tramaSolicitudNodo+2), W0
	MOV.B	[W0], [W1]
;Master.c,540 :: 		numDatosRS485 = tramaSolicitudNodo[3];
	MOV	#lo_addr(_tramaSolicitudNodo+3), W0
	ZE	[W0], W0
	MOV	W0, _numDatosRS485
;Master.c,541 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,542 :: 		banSPI8 = 2;
	MOV	#lo_addr(_banSPI8), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,537 :: 		if ((banSPI8==1)&&(i==4)){
L__spi_1332:
L__spi_1331:
;Master.c,545 :: 		if ((banSPI8==2)&&(i<=numDatosRS485)){
	MOV	#lo_addr(_banSPI8), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__spi_1487
	GOTO	L__spi_1334
L__spi_1487:
	MOV	_i, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LEU	L__spi_1488
	GOTO	L__spi_1333
L__spi_1488:
L__spi_1253:
;Master.c,546 :: 		tramaSolicitudNodo[i] = bufferSPI;
	MOV	#lo_addr(_tramaSolicitudNodo), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,547 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,545 :: 		if ((banSPI8==2)&&(i<=numDatosRS485)){
L__spi_1334:
L__spi_1333:
;Master.c,550 :: 		if ((banSPI8==2)&&(bufferSPI==0xF8)&&(i>numDatosRS485)){
	MOV	#lo_addr(_banSPI8), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__spi_1489
	GOTO	L__spi_1337
L__spi_1489:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	CP.B	W1, W0
	BRA Z	L__spi_1490
	GOTO	L__spi_1336
L__spi_1490:
	MOV	_i, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA GTU	L__spi_1491
	GOTO	L__spi_1335
L__spi_1491:
L__spi_1252:
;Master.c,551 :: 		CambiarEstadoBandera(8,0);                                              //Limpia las banderas
	CLR	W11
	MOV.B	#8, W10
	CALL	_CambiarEstadoBandera
;Master.c,553 :: 		if (numDatosRS485>1){
	MOV	_numDatosRS485, W0
	CP	W0, #1
	BRA GTU	L__spi_1492
	GOTO	L_spi_1151
L__spi_1492:
;Master.c,554 :: 		for (x=0;x<numDatosRS485;x++){
	CLR	W0
	MOV	W0, _x
L_spi_1152:
	MOV	_x, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__spi_1493
	GOTO	L_spi_1153
L__spi_1493:
;Master.c,555 :: 		outputPyloadRS485[x] = tramaSolicitudNodo[x+1];
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaSolicitudNodo), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Master.c,554 :: 		for (x=0;x<numDatosRS485;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;Master.c,556 :: 		}
	GOTO	L_spi_1152
L_spi_1153:
;Master.c,557 :: 		} else {
	GOTO	L_spi_1155
L_spi_1151:
;Master.c,558 :: 		outputPyloadRS485[0] = tramaSolicitudNodo[1];
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV	#lo_addr(_tramaSolicitudNodo+1), W0
	MOV.B	[W0], [W1]
;Master.c,559 :: 		}
L_spi_1155:
;Master.c,560 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,561 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,562 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,563 :: 		banRespuestaPi = 1;
	MOV	#lo_addr(_banRespuestaPi), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,565 :: 		EnviarTramaRS485(2, direccionRS485, funcionRS485, numDatosRS485, outputPyloadRS485);
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_direccionRS485), W0
	MOV	_numDatosRS485, W13
	MOV.B	[W1], W12
	MOV.B	[W0], W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;Master.c,567 :: 		T2CON.TON = 1;
	BSET	T2CON, #15
;Master.c,568 :: 		TMR2 = 0;
	CLR	TMR2
;Master.c,550 :: 		if ((banSPI8==2)&&(bufferSPI==0xF8)&&(i>numDatosRS485)){
L__spi_1337:
L__spi_1336:
L__spi_1335:
;Master.c,573 :: 		if ((banSPIA==0)&&(bufferSPI==0xAA)){
	MOV	#lo_addr(_banSPIA), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1494
	GOTO	L__spi_1339
L__spi_1494:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#170, W0
	CP.B	W1, W0
	BRA Z	L__spi_1495
	GOTO	L__spi_1338
L__spi_1495:
L__spi_1251:
;Master.c,574 :: 		CambiarEstadoBandera(0x0A,1);
	MOV.B	#1, W11
	MOV.B	#10, W10
	CALL	_CambiarEstadoBandera
;Master.c,575 :: 		SPI1BUF = inputPyloadRS485[0];
	MOV	#lo_addr(_inputPyloadRS485), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Master.c,576 :: 		i = 1;
	MOV	#1, W0
	MOV	W0, _i
;Master.c,573 :: 		if ((banSPIA==0)&&(bufferSPI==0xAA)){
L__spi_1339:
L__spi_1338:
;Master.c,578 :: 		if ((banSPIA==1)&&(bufferSPI!=0xAA)&&(bufferSPI!=0xFA)){
	MOV	#lo_addr(_banSPIA), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1496
	GOTO	L__spi_1342
L__spi_1496:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#170, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1497
	GOTO	L__spi_1341
L__spi_1497:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#250, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1498
	GOTO	L__spi_1340
L__spi_1498:
L__spi_1250:
;Master.c,579 :: 		SPI1BUF = inputPyloadRS485[i];
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,580 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,578 :: 		if ((banSPIA==1)&&(bufferSPI!=0xAA)&&(bufferSPI!=0xFA)){
L__spi_1342:
L__spi_1341:
L__spi_1340:
;Master.c,582 :: 		if ((banSPIA==1)&&(bufferSPI==0xFA)){
	MOV	#lo_addr(_banSPIA), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1499
	GOTO	L__spi_1344
L__spi_1499:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#250, W0
	CP.B	W1, W0
	BRA Z	L__spi_1500
	GOTO	L__spi_1343
L__spi_1500:
L__spi_1249:
;Master.c,583 :: 		CambiarEstadoBandera(0x0A,0);                                           //Limpia las banderas
	CLR	W11
	MOV.B	#10, W10
	CALL	_CambiarEstadoBandera
;Master.c,582 :: 		if ((banSPIA==1)&&(bufferSPI==0xFA)){
L__spi_1344:
L__spi_1343:
;Master.c,588 :: 		}
L_end_spi_1:
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
; end of _spi_1

_int_1:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Master.c,593 :: 		void int_1() org IVT_ADDR_INT1INTERRUPT {
;Master.c,595 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;Master.c,597 :: 		if (banSetReloj==1){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1502
	GOTO	L_int_1165
L__int_1502:
;Master.c,598 :: 		horaSistema++;                                                         //Incrementa el reloj del sistema
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaSistema), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;Master.c,599 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,600 :: 		INT_SINC = ~INT_SINC;                                                  //TEST
	BTG	LATA1_bit, BitPos(LATA1_bit+0)
;Master.c,603 :: 		INT_SINC1 = 1;
	BSET	LATA0_bit, BitPos(LATA0_bit+0)
;Master.c,604 :: 		INT_SINC2 = 1;
	BSET	LATA3_bit, BitPos(LATA3_bit+0)
;Master.c,605 :: 		INT_SINC3 = 1;
	BSET	LATB10_bit, BitPos(LATB10_bit+0)
;Master.c,606 :: 		INT_SINC4 = 1;
	BSET	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,607 :: 		Delay_ms(1);
	MOV	#8000, W7
L_int_1166:
	DEC	W7
	BRA NZ	L_int_1166
	NOP
	NOP
;Master.c,609 :: 		INT_SINC1 = 0;
	BCLR	LATA0_bit, BitPos(LATA0_bit+0)
;Master.c,610 :: 		INT_SINC2 = 0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;Master.c,611 :: 		INT_SINC3 = 0;
	BCLR	LATB10_bit, BitPos(LATB10_bit+0)
;Master.c,612 :: 		INT_SINC4 = 0;
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,613 :: 		}
L_int_1165:
;Master.c,616 :: 		if ((horaSistema!=0)&&(horaSistema%3600==0)){
	MOV	_horaSistema, W0
	MOV	_horaSistema+2, W1
	CP	W0, #0
	CPB	W1, #0
	BRA NZ	L__int_1503
	GOTO	L__int_1347
L__int_1503:
	MOV	#3600, W2
	MOV	#0, W3
	MOV	_horaSistema, W0
	MOV	_horaSistema+2, W1
	CLR	W4
	CALL	__Modulus_32x32
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__int_1504
	GOTO	L__int_1346
L__int_1504:
L__int_1345:
;Master.c,617 :: 		banRespuestaPi = 0;                                                     //No envia respuesta a la RPi
	MOV	#lo_addr(_banRespuestaPi), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,619 :: 		banGPSI = 1;                                                            //Activa la bandera de inicio de trama  del GPS
	MOV	#lo_addr(_banGPSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,620 :: 		banGPSC = 0;                                                            //Limpia la bandera de trama completa
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,621 :: 		U1MODE.UARTEN = 1;                                                      //Inicializa el UART1
	BSET	U1MODE, #15
;Master.c,623 :: 		T1CON.TON = 1;
	BSET	T1CON, #15
;Master.c,624 :: 		TMR1 = 0;
	CLR	TMR1
;Master.c,616 :: 		if ((horaSistema!=0)&&(horaSistema%3600==0)){
L__int_1347:
L__int_1346:
;Master.c,627 :: 		}
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

_int_2:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Master.c,632 :: 		void int_2() org IVT_ADDR_INT2INTERRUPT {
;Master.c,634 :: 		INT2IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT2
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	INT2IF_bit, BitPos(INT2IF_bit+0)
;Master.c,636 :: 		if (banSyncReloj==1){
	MOV	#lo_addr(_banSyncReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_2506
	GOTO	L_int_2171
L__int_2506:
;Master.c,638 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,639 :: 		INT_SINC = ~INT_SINC;                                                  //TEST
	BTG	LATA1_bit, BitPos(LATA1_bit+0)
;Master.c,642 :: 		INT_SINC1 = 1;
	BSET	LATA0_bit, BitPos(LATA0_bit+0)
;Master.c,643 :: 		INT_SINC2 = 1;
	BSET	LATA3_bit, BitPos(LATA3_bit+0)
;Master.c,644 :: 		INT_SINC3 = 1;
	BSET	LATB10_bit, BitPos(LATB10_bit+0)
;Master.c,645 :: 		INT_SINC4 = 1;
	BSET	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,646 :: 		Delay_ms(1);
	MOV	#8000, W7
L_int_2172:
	DEC	W7
	BRA NZ	L_int_2172
	NOP
	NOP
;Master.c,648 :: 		INT_SINC1 = 0;
	BCLR	LATA0_bit, BitPos(LATA0_bit+0)
;Master.c,649 :: 		INT_SINC2 = 0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;Master.c,650 :: 		INT_SINC3 = 0;
	BCLR	LATB10_bit, BitPos(LATB10_bit+0)
;Master.c,651 :: 		INT_SINC4 = 0;
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,654 :: 		Delay_ms(499);
	MOV	#61, W8
	MOV	#59875, W7
L_int_2174:
	DEC	W7
	BRA NZ	L_int_2174
	DEC	W8
	BRA NZ	L_int_2174
	NOP
	NOP
	NOP
	NOP
;Master.c,655 :: 		DS3234_setDate(horaSistema, fechaSistema);                             //Configura la hora en el RTC con la hora recuperada de la RPi
	MOV	_fechaSistema, W12
	MOV	_fechaSistema+2, W13
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	CALL	_DS3234_setDate
;Master.c,657 :: 		banSyncReloj = 0;
	MOV	#lo_addr(_banSyncReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,658 :: 		banSetReloj = 1;                                                       //Activa esta bandera para continuar trabajando con el pulso SQW
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,661 :: 		InterrupcionP1(0xB1,0xD1,8);                                           //Envia la hora local a la RPi y a los nodos
	MOV	#8, W12
	MOV.B	#209, W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,663 :: 		}
L_int_2171:
;Master.c,665 :: 		}
L_end_int_2:
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
; end of _int_2

_Timer1Int:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Master.c,670 :: 		void Timer1Int() org IVT_ADDR_T1INTERRUPT{
;Master.c,672 :: 		T1IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;Master.c,673 :: 		contTimeout1++;                                                            //Incrementa el contador de Timeout
	MOV.B	#1, W1
	MOV	#lo_addr(_contTimeout1), W0
	ADD.B	W1, [W0], [W0]
;Master.c,676 :: 		if (contTimeout1==4){
	MOV	#lo_addr(_contTimeout1), W0
	MOV.B	[W0], W0
	CP.B	W0, #4
	BRA Z	L__Timer1Int508
	GOTO	L_Timer1Int176
L__Timer1Int508:
;Master.c,677 :: 		T1CON.TON = 0;
	BCLR	T1CON, #15
;Master.c,678 :: 		TMR1 = 0;
	CLR	TMR1
;Master.c,679 :: 		contTimeout1 = 0;
	MOV	#lo_addr(_contTimeout1), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,681 :: 		horaSistema = RecuperarHoraRTC();                                       //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,682 :: 		fechaSistema = RecuperarFechaRTC();                                     //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,683 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del RTC
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,684 :: 		fuenteReloj = 7;                                                        //**Indica que se obtuvo la hora del RTC
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#7, W0
	MOV.B	W0, [W1]
;Master.c,685 :: 		InterrupcionP1(0xB1,0xD1,8);                                            //Envia la hora local a la RPi y a los nodos
	MOV	#8, W12
	MOV.B	#209, W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,686 :: 		}
L_Timer1Int176:
;Master.c,688 :: 		}
L_end_Timer1Int:
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
; end of _Timer1Int

_Timer2Int:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Master.c,693 :: 		void Timer2Int() org IVT_ADDR_T2INTERRUPT{
;Master.c,695 :: 		T2IF_bit = 0;                                                              //Limpia la bandera de interrupcion por desbordamiento del Timer2
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BCLR	T2IF_bit, BitPos(T2IF_bit+0)
;Master.c,696 :: 		T2CON.TON = 0;                                                             //Apaga el Timer
	BCLR	T2CON, #15
;Master.c,697 :: 		TMR2 = 0;
	CLR	TMR2
;Master.c,699 :: 		INT_SINC = ~INT_SINC;//TEST
	BTG	LATA1_bit, BitPos(LATA1_bit+0)
;Master.c,702 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,703 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,704 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,707 :: 		numDatosRS485 = 3;
	MOV	#3, W0
	MOV	W0, _numDatosRS485
;Master.c,708 :: 		inputPyloadRS485[0] = 0xD3;
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV.B	#211, W0
	MOV.B	W0, [W1]
;Master.c,709 :: 		inputPyloadRS485[1] = 0xEE;
	MOV	#lo_addr(_inputPyloadRS485+1), W1
	MOV.B	#238, W0
	MOV.B	W0, [W1]
;Master.c,710 :: 		inputPyloadRS485[2] = 0xE4;
	MOV	#lo_addr(_inputPyloadRS485+2), W1
	MOV.B	#228, W0
	MOV.B	W0, [W1]
;Master.c,711 :: 		InterrupcionP1(0xB3,0xD3,3);
	MOV	#3, W12
	MOV.B	#211, W11
	MOV.B	#179, W10
	CALL	_InterrupcionP1
;Master.c,713 :: 		}
L_end_Timer2Int:
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

;Master.c,718 :: 		void urx_1() org  IVT_ADDR_U1RXINTERRUPT {
;Master.c,721 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;Master.c,722 :: 		byteGPS = U1RXREG;                                                         //Lee el byte de la trama enviada por el GPS
	MOV	#lo_addr(_byteGPS), W1
	MOV.B	U1RXREG, WREG
	MOV.B	W0, [W1]
;Master.c,723 :: 		U1STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART1
	BCLR	U1STA, #1
;Master.c,726 :: 		if (banGPSI==3){
	MOV	#lo_addr(_banGPSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #3
	BRA Z	L__urx_1511
	GOTO	L_urx_1177
L__urx_1511:
;Master.c,727 :: 		if (byteGPS!=0x2A){
	MOV	#lo_addr(_byteGPS), W0
	MOV.B	[W0], W1
	MOV.B	#42, W0
	CP.B	W1, W0
	BRA NZ	L__urx_1512
	GOTO	L_urx_1178
L__urx_1512:
;Master.c,728 :: 		tramaGPS[i_gps] = byteGPS;                                           //LLena la tramaGPS hasta recibir el ultimo simbolo ("*") de la trama GPS
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_i_gps), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteGPS), W0
	MOV.B	[W0], [W1]
;Master.c,729 :: 		i_gps++;
	MOV	#1, W1
	MOV	#lo_addr(_i_gps), W0
	ADD	W1, [W0], [W0]
;Master.c,730 :: 		} else {
	GOTO	L_urx_1179
L_urx_1178:
;Master.c,731 :: 		banGPSI = 0;                                                         //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banGPSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,732 :: 		banGPSC = 1;                                                         //Activa la bandera de trama completa
	MOV	#lo_addr(_banGPSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,733 :: 		}
L_urx_1179:
;Master.c,734 :: 		}
L_urx_1177:
;Master.c,737 :: 		if ((banGPSI==1)){
	MOV	#lo_addr(_banGPSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1513
	GOTO	L_urx_1180
L__urx_1513:
;Master.c,738 :: 		if (byteGPS==0x24){                                                     //Verifica si el primer byte recibido sea la cabecera de trama "$"
	MOV	#lo_addr(_byteGPS), W0
	MOV.B	[W0], W1
	MOV.B	#36, W0
	CP.B	W1, W0
	BRA Z	L__urx_1514
	GOTO	L_urx_1181
L__urx_1514:
;Master.c,739 :: 		banGPSI = 2;
	MOV	#lo_addr(_banGPSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,740 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;Master.c,741 :: 		}
L_urx_1181:
;Master.c,742 :: 		}
L_urx_1180:
;Master.c,743 :: 		if ((banGPSI==2)&&(i_gps<6)){
	MOV	#lo_addr(_banGPSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_1515
	GOTO	L__urx_1352
L__urx_1515:
	MOV	_i_gps, W0
	CP	W0, #6
	BRA LTU	L__urx_1516
	GOTO	L__urx_1351
L__urx_1516:
L__urx_1350:
;Master.c,744 :: 		tramaGPS[i_gps] = byteGPS;                                              //Recupera los datos de cabecera de la trama GPS: ["$", "G", "P", "R", "M", "C"]
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_i_gps), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteGPS), W0
	MOV.B	[W0], [W1]
;Master.c,745 :: 		i_gps++;
	MOV	#1, W1
	MOV	#lo_addr(_i_gps), W0
	ADD	W1, [W0], [W0]
;Master.c,743 :: 		if ((banGPSI==2)&&(i_gps<6)){
L__urx_1352:
L__urx_1351:
;Master.c,747 :: 		if ((banGPSI==2)&&(i_gps==6)){
	MOV	#lo_addr(_banGPSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_1517
	GOTO	L__urx_1359
L__urx_1517:
	MOV	_i_gps, W0
	CP	W0, #6
	BRA Z	L__urx_1518
	GOTO	L__urx_1358
L__urx_1518:
L__urx_1349:
;Master.c,749 :: 		T1CON.TON = 0;
	BCLR	T1CON, #15
;Master.c,750 :: 		TMR1 = 0;
	CLR	TMR1
;Master.c,752 :: 		if (tramaGPS[1]=='G'&&tramaGPS[2]=='P'&&tramaGPS[3]=='R'&&tramaGPS[4]=='M'&&tramaGPS[5]=='C'){
	MOV	#lo_addr(_tramaGPS+1), W0
	MOV.B	[W0], W1
	MOV.B	#71, W0
	CP.B	W1, W0
	BRA Z	L__urx_1519
	GOTO	L__urx_1357
L__urx_1519:
	MOV	#lo_addr(_tramaGPS+2), W0
	MOV.B	[W0], W1
	MOV.B	#80, W0
	CP.B	W1, W0
	BRA Z	L__urx_1520
	GOTO	L__urx_1356
L__urx_1520:
	MOV	#lo_addr(_tramaGPS+3), W0
	MOV.B	[W0], W1
	MOV.B	#82, W0
	CP.B	W1, W0
	BRA Z	L__urx_1521
	GOTO	L__urx_1355
L__urx_1521:
	MOV	#lo_addr(_tramaGPS+4), W0
	MOV.B	[W0], W1
	MOV.B	#77, W0
	CP.B	W1, W0
	BRA Z	L__urx_1522
	GOTO	L__urx_1354
L__urx_1522:
	MOV	#lo_addr(_tramaGPS+5), W0
	MOV.B	[W0], W1
	MOV.B	#67, W0
	CP.B	W1, W0
	BRA Z	L__urx_1523
	GOTO	L__urx_1353
L__urx_1523:
L__urx_1348:
;Master.c,753 :: 		banGPSI = 3;
	MOV	#lo_addr(_banGPSI), W1
	MOV.B	#3, W0
	MOV.B	W0, [W1]
;Master.c,754 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;Master.c,755 :: 		} else {
	GOTO	L_urx_1191
;Master.c,752 :: 		if (tramaGPS[1]=='G'&&tramaGPS[2]=='P'&&tramaGPS[3]=='R'&&tramaGPS[4]=='M'&&tramaGPS[5]=='C'){
L__urx_1357:
L__urx_1356:
L__urx_1355:
L__urx_1354:
L__urx_1353:
;Master.c,756 :: 		banGPSI = 0;
	MOV	#lo_addr(_banGPSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,757 :: 		banGPSC = 0;
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,758 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;Master.c,760 :: 		horaSistema = RecuperarHoraRTC();                                    //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,761 :: 		fechaSistema = RecuperarFechaRTC();                                  //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,762 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);             //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del RTC
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,763 :: 		fuenteReloj = 5;                                                     //**Fuente de reloj = RTC
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#5, W0
	MOV.B	W0, [W1]
;Master.c,764 :: 		InterrupcionP1(0xB1,0xD1,8);                                         //Envia la hora local a la RPi y a los nodos                                                   //Envia la hora local a la RPi
	MOV	#8, W12
	MOV.B	#209, W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,765 :: 		banGPSI = 0;
	MOV	#lo_addr(_banGPSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,766 :: 		banGPSC = 0;
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,767 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;Master.c,768 :: 		U1MODE.UARTEN = 0;                                                   //Desactiva el UART1
	BCLR	U1MODE, #15
;Master.c,769 :: 		}
L_urx_1191:
;Master.c,747 :: 		if ((banGPSI==2)&&(i_gps==6)){
L__urx_1359:
L__urx_1358:
;Master.c,773 :: 		if (banGPSC==1){
	MOV	#lo_addr(_banGPSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_1524
	GOTO	L_urx_1192
L__urx_1524:
;Master.c,775 :: 		if (tramaGPS[12]==0x41) {
	MOV	#lo_addr(_tramaGPS+12), W0
	MOV.B	[W0], W1
	MOV.B	#65, W0
	CP.B	W1, W0
	BRA Z	L__urx_1525
	GOTO	L_urx_1193
L__urx_1525:
;Master.c,776 :: 		for (x=0;x<6;x++){
	CLR	W0
	MOV	W0, _x
L_urx_1194:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_1526
	GOTO	L_urx_1195
L__urx_1526:
;Master.c,777 :: 		datosGPS[x] = tramaGPS[x+1];                                     //Guarda los datos de hhmmss
	MOV	#lo_addr(_datosGPS), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaGPS), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Master.c,776 :: 		for (x=0;x<6;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;Master.c,778 :: 		}
	GOTO	L_urx_1194
L_urx_1195:
;Master.c,780 :: 		for (x=44;x<54;x++){
	MOV	#44, W0
	MOV	W0, _x
L_urx_1197:
	MOV	#54, W1
	MOV	#lo_addr(_x), W0
	CP	W1, [W0]
	BRA GTU	L__urx_1527
	GOTO	L_urx_1198
L__urx_1527:
;Master.c,781 :: 		if (tramaGPS[x]==0x2C){
	MOV	#lo_addr(_tramaGPS), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W1
	MOV.B	#44, W0
	CP.B	W1, W0
	BRA Z	L__urx_1528
	GOTO	L_urx_1200
L__urx_1528:
;Master.c,782 :: 		for (y=0;y<6;y++){
	CLR	W0
	MOV	W0, _y
L_urx_1201:
	MOV	_y, W0
	CP	W0, #6
	BRA LTU	L__urx_1529
	GOTO	L_urx_1202
L__urx_1529:
;Master.c,783 :: 		datosGPS[6+y] = tramaGPS[x+y+1];                         //Guarda los datos de DDMMAA en la trama datosGPS
	MOV	_y, W0
	ADD	W0, #6, W1
	MOV	#lo_addr(_datosGPS), W0
	ADD	W0, W1, W2
	MOV	_x, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaGPS), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Master.c,782 :: 		for (y=0;y<6;y++){
	MOV	#1, W1
	MOV	#lo_addr(_y), W0
	ADD	W1, [W0], [W0]
;Master.c,784 :: 		}
	GOTO	L_urx_1201
L_urx_1202:
;Master.c,785 :: 		}
L_urx_1200:
;Master.c,780 :: 		for (x=44;x<54;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;Master.c,786 :: 		}
	GOTO	L_urx_1197
L_urx_1198:
;Master.c,787 :: 		horaSistema = RecuperarHoraGPS(datosGPS);                            //Recupera la hora del GPS
	MOV	#lo_addr(_datosGPS), W10
	CALL	_RecuperarHoraGPS
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,788 :: 		fechaSistema = RecuperarFechaGPS(datosGPS);                          //Recupera la fecha del GPS
	MOV	#lo_addr(_datosGPS), W10
	CALL	_RecuperarFechaGPS
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,789 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);             //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del gps
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,790 :: 		fuenteReloj = 1;                                                     //Indica que se obtuvo la hora del GPS
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,791 :: 		banSyncReloj = 1;
	MOV	#lo_addr(_banSyncReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,792 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,793 :: 		} else {
	GOTO	L_urx_1204
L_urx_1193:
;Master.c,795 :: 		horaSistema = RecuperarHoraRTC();                                    //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,796 :: 		fechaSistema = RecuperarFechaRTC();                                  //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,797 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);             //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas del RTC
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,798 :: 		fuenteReloj = 6;                                                     //**Indica que se obtuvo la hora del RTC
	MOV	#lo_addr(_fuenteReloj), W1
	MOV.B	#6, W0
	MOV.B	W0, [W1]
;Master.c,799 :: 		InterrupcionP1(0xB1,0xD1,8);                                         //Envia la hora local a la RPi y a los nodos
	MOV	#8, W12
	MOV.B	#209, W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,800 :: 		}
L_urx_1204:
;Master.c,802 :: 		banGPSI = 0;
	MOV	#lo_addr(_banGPSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,803 :: 		banGPSC = 0;
	MOV	#lo_addr(_banGPSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,804 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;Master.c,805 :: 		U1MODE.UARTEN = 0;                                                      //Desactiva el UART1
	BCLR	U1MODE, #15
;Master.c,807 :: 		}
L_urx_1192:
;Master.c,809 :: 		}
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

_urx_2:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Master.c,814 :: 		void urx_2() org  IVT_ADDR_U2RXINTERRUPT {
;Master.c,817 :: 		U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART2
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BCLR	U2RXIF_bit, BitPos(U2RXIF_bit+0)
;Master.c,818 :: 		byteRS485 = U2RXREG;                                                       //Lee el byte de la trama enviada por el nodo
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	U2RXREG, WREG
	MOV.B	W0, [W1]
;Master.c,819 :: 		U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART2
	BCLR	U2STA, #1
;Master.c,822 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_2531
	GOTO	L_urx_2205
L__urx_2531:
;Master.c,824 :: 		if (i_rs485<(numDatosRS485)){
	MOV	_i_rs485, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__urx_2532
	GOTO	L_urx_2206
L__urx_2532:
;Master.c,825 :: 		inputPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;Master.c,826 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;Master.c,827 :: 		} else {
	GOTO	L_urx_2207
L_urx_2206:
;Master.c,828 :: 		banRSI = 0;                                                          //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,829 :: 		banRSC = 1;                                                          //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,830 :: 		}
L_urx_2207:
;Master.c,831 :: 		}
L_urx_2205:
;Master.c,834 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_2533
	GOTO	L__urx_2364
L__urx_2533:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_2534
	GOTO	L__urx_2363
L__urx_2534:
L__urx_2362:
;Master.c,835 :: 		if (byteRS485==0x3A){                                                   //Verifica si el primer byte recibido sea la cabecera de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__urx_2535
	GOTO	L_urx_2211
L__urx_2535:
;Master.c,836 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,837 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,838 :: 		}
L_urx_2211:
;Master.c,834 :: 		if ((banRSI==0)&&(banRSC==0)){
L__urx_2364:
L__urx_2363:
;Master.c,840 :: 		if ((banRSI==1)&&(i_rs485<5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2536
	GOTO	L__urx_2366
L__urx_2536:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA LTU	L__urx_2537
	GOTO	L__urx_2365
L__urx_2537:
L__urx_2361:
;Master.c,841 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                                 //Recupera los datos de cabecera de la trama UART: [0x3A, Direccion, Funcion, NumeroDatos]
	MOV	#lo_addr(_tramaCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;Master.c,842 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;Master.c,840 :: 		if ((banRSI==1)&&(i_rs485<5)){
L__urx_2366:
L__urx_2365:
;Master.c,844 :: 		if ((banRSI==1)&&(i_rs485==5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2538
	GOTO	L__urx_2368
L__urx_2538:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA Z	L__urx_2539
	GOTO	L__urx_2367
L__urx_2539:
L__urx_2360:
;Master.c,846 :: 		T2CON.TON = 0;
	BCLR	T2CON, #15
;Master.c,847 :: 		TMR2 = 0;
	CLR	TMR2
;Master.c,849 :: 		if (tramaCabeceraRS485[1]==direccionRS485){
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_direccionRS485), W0
	CP.B	W1, [W0]
	BRA Z	L__urx_2540
	GOTO	L_urx_2218
L__urx_2540:
;Master.c,850 :: 		funcionRS485 = tramaCabeceraRS485[2];
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_tramaCabeceraRS485+2), W0
	MOV.B	[W0], [W1]
;Master.c,851 :: 		*(ptrnumDatosRS485) = tramaCabeceraRS485[3];                         //LSB numDatosRS485
	MOV	#lo_addr(_tramaCabeceraRS485+3), W1
	MOV	_ptrnumDatosRS485, W0
	MOV.B	[W1], [W0]
;Master.c,852 :: 		*(ptrnumDatosRS485+1) = tramaCabeceraRS485[4];                       //MSB numDatosRS485
	MOV	_ptrnumDatosRS485, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaCabeceraRS485+4), W0
	MOV.B	[W0], [W1]
;Master.c,853 :: 		banRSI = 2;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,854 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,855 :: 		} else {
	GOTO	L_urx_2219
L_urx_2218:
;Master.c,856 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,857 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,858 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,859 :: 		}
L_urx_2219:
;Master.c,844 :: 		if ((banRSI==1)&&(i_rs485==5)){
L__urx_2368:
L__urx_2367:
;Master.c,863 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2541
	GOTO	L_urx_2220
L__urx_2541:
;Master.c,864 :: 		subFuncionRS485 = inputPyloadRS485[0];
	MOV	#lo_addr(_subFuncionRS485), W1
	MOV	#lo_addr(_inputPyloadRS485), W0
	MOV.B	[W0], [W1]
;Master.c,865 :: 		switch (funcionRS485){
	GOTO	L_urx_2221
;Master.c,866 :: 		case 0xF1:
L_urx_2223:
;Master.c,867 :: 		InterrupcionP1(0xB1,subFuncionRS485,numDatosRS485);
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV	_numDatosRS485, W12
	MOV.B	[W0], W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,868 :: 		break;
	GOTO	L_urx_2222
;Master.c,869 :: 		case 0xF3:
L_urx_2224:
;Master.c,870 :: 		InterrupcionP1(0xB3,subFuncionRS485,numDatosRS485);
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV	_numDatosRS485, W12
	MOV.B	[W0], W11
	MOV.B	#179, W10
	CALL	_InterrupcionP1
;Master.c,871 :: 		break;
	GOTO	L_urx_2222
;Master.c,872 :: 		}
L_urx_2221:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__urx_2542
	GOTO	L_urx_2223
L__urx_2542:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA NZ	L__urx_2543
	GOTO	L_urx_2224
L__urx_2543:
L_urx_2222:
;Master.c,874 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,876 :: 		}
L_urx_2220:
;Master.c,877 :: 		}
L_end_urx_2:
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
; end of _urx_2
