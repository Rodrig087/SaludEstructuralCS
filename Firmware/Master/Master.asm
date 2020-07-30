
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
	BRA LTU	L__IncrementarFecha312
	GOTO	L_IncrementarFecha0
L__IncrementarFecha312:
;tiempo_rtc.c,198 :: 		dia++;
; dia start address is: 16 (W8)
	ADD	W6, #1, W8
	ADDC	W7, #0, W9
; dia end address is: 12 (W6)
;tiempo_rtc.c,199 :: 		} else {
; dia end address is: 16 (W8)
	MOV.D	W4, W6
	GOTO	L_IncrementarFecha1
L_IncrementarFecha0:
;tiempo_rtc.c,200 :: 		if (mes==2){
; dia start address is: 12 (W6)
	CP	W4, #2
	CPB	W5, #0
	BRA Z	L__IncrementarFecha313
	GOTO	L_IncrementarFecha2
L__IncrementarFecha313:
;tiempo_rtc.c,202 :: 		if (((anio-16)%4)==0){
	SUB	W2, #16, W0
	SUBB	W3, #0, W1
	AND	W0, #3, W0
	AND	W1, #0, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__IncrementarFecha314
	GOTO	L_IncrementarFecha3
L__IncrementarFecha314:
;tiempo_rtc.c,203 :: 		if (dia==29){
	CP	W6, #29
	CPB	W7, #0
	BRA Z	L__IncrementarFecha315
	GOTO	L_IncrementarFecha4
L__IncrementarFecha315:
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
	GOTO	L_IncrementarFecha5
L_IncrementarFecha4:
;tiempo_rtc.c,207 :: 		dia++;
; dia start address is: 0 (W0)
; dia start address is: 12 (W6)
	ADD	W6, #1, W0
	ADDC	W7, #0, W1
; dia end address is: 12 (W6)
; mes end address is: 8 (W4)
; dia end address is: 0 (W0)
;tiempo_rtc.c,208 :: 		}
L_IncrementarFecha5:
;tiempo_rtc.c,209 :: 		} else {
; dia start address is: 0 (W0)
; mes start address is: 8 (W4)
	MOV.D	W0, W8
; dia end address is: 0 (W0)
	MOV.D	W4, W6
	GOTO	L_IncrementarFecha6
L_IncrementarFecha3:
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
L_IncrementarFecha6:
;tiempo_rtc.c,213 :: 		} else {
; mes start address is: 12 (W6)
; dia start address is: 16 (W8)
; mes end address is: 12 (W6)
; dia end address is: 16 (W8)
	GOTO	L_IncrementarFecha7
L_IncrementarFecha2:
;tiempo_rtc.c,214 :: 		if (dia<30){
; mes start address is: 8 (W4)
; dia start address is: 12 (W6)
	CP	W6, #30
	CPB	W7, #0
	BRA LTU	L__IncrementarFecha316
	GOTO	L_IncrementarFecha8
L__IncrementarFecha316:
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
	GOTO	L_IncrementarFecha9
L_IncrementarFecha8:
;tiempo_rtc.c,217 :: 		if (mes==4||mes==6||mes==9||mes==11){
; dia start address is: 12 (W6)
	CP	W4, #4
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha317
	GOTO	L__IncrementarFecha183
L__IncrementarFecha317:
	CP	W4, #6
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha318
	GOTO	L__IncrementarFecha182
L__IncrementarFecha318:
	CP	W4, #9
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha319
	GOTO	L__IncrementarFecha181
L__IncrementarFecha319:
	CP	W4, #11
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha320
	GOTO	L__IncrementarFecha180
L__IncrementarFecha320:
	MOV.D	W4, W0
	MOV.D	W6, W4
	GOTO	L_IncrementarFecha12
L__IncrementarFecha183:
L__IncrementarFecha182:
L__IncrementarFecha181:
L__IncrementarFecha180:
;tiempo_rtc.c,218 :: 		if (dia==30){
	CP	W6, #30
	CPB	W7, #0
	BRA Z	L__IncrementarFecha321
	GOTO	L_IncrementarFecha13
L__IncrementarFecha321:
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
	GOTO	L_IncrementarFecha14
L_IncrementarFecha13:
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
L_IncrementarFecha14:
;tiempo_rtc.c,224 :: 		}
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
L_IncrementarFecha12:
;tiempo_rtc.c,225 :: 		if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
; mes start address is: 0 (W0)
; dia start address is: 8 (W4)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha322
	GOTO	L__IncrementarFecha193
L__IncrementarFecha322:
	CP	W0, #1
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha323
	GOTO	L__IncrementarFecha189
L__IncrementarFecha323:
	CP	W0, #3
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha324
	GOTO	L__IncrementarFecha188
L__IncrementarFecha324:
	CP	W0, #5
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha325
	GOTO	L__IncrementarFecha187
L__IncrementarFecha325:
	CP	W0, #7
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha326
	GOTO	L__IncrementarFecha186
L__IncrementarFecha326:
	CP	W0, #8
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha327
	GOTO	L__IncrementarFecha185
L__IncrementarFecha327:
	CP	W0, #10
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha328
	GOTO	L__IncrementarFecha184
L__IncrementarFecha328:
	GOTO	L_IncrementarFecha19
L__IncrementarFecha189:
L__IncrementarFecha188:
L__IncrementarFecha187:
L__IncrementarFecha186:
L__IncrementarFecha185:
L__IncrementarFecha184:
L__IncrementarFecha177:
;tiempo_rtc.c,226 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha329
	GOTO	L_IncrementarFecha20
L__IncrementarFecha329:
;tiempo_rtc.c,227 :: 		dia = 1;
	MOV	#1, W4
	MOV	#0, W5
;tiempo_rtc.c,228 :: 		mes++;
	ADD	W0, #1, W0
	ADDC	W1, #0, W1
;tiempo_rtc.c,229 :: 		} else {
	GOTO	L_IncrementarFecha21
L_IncrementarFecha20:
;tiempo_rtc.c,230 :: 		dia++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
;tiempo_rtc.c,231 :: 		}
L_IncrementarFecha21:
;tiempo_rtc.c,232 :: 		}
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
L_IncrementarFecha19:
;tiempo_rtc.c,225 :: 		if ((dia!=1)&&(mes==1||mes==3||mes==5||mes==7||mes==8||mes==10)){
; mes start address is: 0 (W0)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
	GOTO	L__IncrementarFecha190
L__IncrementarFecha193:
L__IncrementarFecha190:
;tiempo_rtc.c,233 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha330
	GOTO	L__IncrementarFecha194
L__IncrementarFecha330:
	CP	W0, #12
	CPB	W1, #0
	BRA Z	L__IncrementarFecha331
	GOTO	L__IncrementarFecha195
L__IncrementarFecha331:
L__IncrementarFecha176:
;tiempo_rtc.c,234 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha332
	GOTO	L_IncrementarFecha25
L__IncrementarFecha332:
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
	GOTO	L_IncrementarFecha26
L_IncrementarFecha25:
;tiempo_rtc.c,239 :: 		dia++;
	ADD	W4, #1, W4
	ADDC	W5, #0, W5
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
;tiempo_rtc.c,240 :: 		}
L_IncrementarFecha26:
;tiempo_rtc.c,233 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; anio start address is: 4 (W2)
; mes start address is: 0 (W0)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha192
L__IncrementarFecha194:
L__IncrementarFecha192:
; mes start address is: 0 (W0)
; anio start address is: 4 (W2)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha191
L__IncrementarFecha195:
L__IncrementarFecha191:
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
L_IncrementarFecha9:
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
L_IncrementarFecha7:
;tiempo_rtc.c,245 :: 		}
; dia start address is: 16 (W8)
; anio start address is: 4 (W2)
; mes start address is: 12 (W6)
; mes end address is: 12 (W6)
; anio end address is: 4 (W2)
; dia end address is: 16 (W8)
L_IncrementarFecha1:
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
;tiempo_gps.c,56 :: 		}
L_end_GPS_init:
	POP	W11
	POP	W10
	RETURN
; end of _GPS_init

_RecuperarFechaGPS:
	LNK	#28

;tiempo_gps.c,61 :: 		unsigned long RecuperarFechaGPS(unsigned char *tramaDatosGPS){
;tiempo_gps.c,66 :: 		char *ptrDatoStringF = &datoStringF;
	PUSH	W10
	ADD	W14, #16, W4
	MOV	W4, [W14+26]
; ptrDatoStringF start address is: 12 (W6)
	MOV	W4, W6
;tiempo_gps.c,67 :: 		datoStringF[2] = '\0';
	ADD	W4, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
;tiempo_gps.c,68 :: 		tramaFecha[3] = '\0';
	ADD	W14, #0, W3
	MOV	W3, [W14+24]
	ADD	W3, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;tiempo_gps.c,71 :: 		datoStringF[0] = tramaDatosGPS[6];
	ADD	W10, #6, W0
	MOV.B	[W0], [W4]
;tiempo_gps.c,72 :: 		datoStringF[1] = tramaDatosGPS[7];
	ADD	W4, #1, W1
	ADD	W10, #7, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,73 :: 		tramaFecha[0] =  atoi(ptrDatoStringF);
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
;tiempo_gps.c,76 :: 		datoStringF[0] = tramaDatosGPS[8];
	ADD	W10, #8, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,77 :: 		datoStringF[1] = tramaDatosGPS[9];
	ADD	W0, #1, W1
	ADD	W10, #9, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,78 :: 		tramaFecha[1] = atoi(ptrDatoStringF);
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
;tiempo_gps.c,81 :: 		datoStringF[0] = tramaDatosGPS[10];
	ADD	W10, #10, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,82 :: 		datoStringF[1] = tramaDatosGPS[11];
	ADD	W0, #1, W1
	ADD	W10, #11, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,83 :: 		tramaFecha[2] = atoi(ptrDatoStringF);
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
;tiempo_gps.c,85 :: 		fechaGPS = (tramaFecha[0]*10000)+(tramaFecha[1]*100)+(tramaFecha[2]);      //10000*dd + 100*mm + aa
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
;tiempo_gps.c,87 :: 		return fechaGPS;
;tiempo_gps.c,89 :: 		}
;tiempo_gps.c,87 :: 		return fechaGPS;
;tiempo_gps.c,89 :: 		}
L_end_RecuperarFechaGPS:
	POP	W10
	ULNK
	RETURN
; end of _RecuperarFechaGPS

_RecuperarHoraGPS:
	LNK	#28

;tiempo_gps.c,92 :: 		unsigned long RecuperarHoraGPS(unsigned char *tramaDatosGPS){
;tiempo_gps.c,97 :: 		char *ptrDatoString = &datoString;
	PUSH	W10
	ADD	W14, #16, W4
	MOV	W4, [W14+26]
; ptrDatoString start address is: 12 (W6)
	MOV	W4, W6
;tiempo_gps.c,98 :: 		datoString[2] = '\0';
	ADD	W4, #2, W1
	CLR	W0
	MOV.B	W0, [W1]
;tiempo_gps.c,99 :: 		tramaTiempo[3] = '\0';
	ADD	W14, #0, W3
	MOV	W3, [W14+24]
	ADD	W3, #12, W2
	CLR	W0
	CLR	W1
	MOV.D	W0, [W2]
;tiempo_gps.c,102 :: 		datoString[0] = tramaDatosGPS[0];
	MOV.B	[W10], [W4]
;tiempo_gps.c,103 :: 		datoString[1] = tramaDatosGPS[1];
	ADD	W4, #1, W1
	ADD	W10, #1, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,104 :: 		tramaTiempo[0] = atoi(ptrDatoString);
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
;tiempo_gps.c,107 :: 		datoString[0] = tramaDatosGPS[2];
	ADD	W10, #2, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,108 :: 		datoString[1] = tramaDatosGPS[3];
	ADD	W0, #1, W1
	ADD	W10, #3, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,109 :: 		tramaTiempo[1] = atoi(ptrDatoString);
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
;tiempo_gps.c,112 :: 		datoString[0] = tramaDatosGPS[4];
	ADD	W10, #4, W1
	MOV	[W14+26], W0
	MOV.B	[W1], [W0]
;tiempo_gps.c,113 :: 		datoString[1] = tramaDatosGPS[5];
	ADD	W0, #1, W1
	ADD	W10, #5, W0
	MOV.B	[W0], [W1]
;tiempo_gps.c,114 :: 		tramaTiempo[2] = atoi(ptrDatoString);
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
;tiempo_gps.c,116 :: 		horaGPS = (tramaTiempo[0]*3600)+(tramaTiempo[1]*60)+(tramaTiempo[2]);      //Calcula el segundo actual = hh*3600 + mm*60 + ss
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
;tiempo_gps.c,117 :: 		return horaGPS;
;tiempo_gps.c,119 :: 		}
;tiempo_gps.c,117 :: 		return horaGPS;
;tiempo_gps.c,119 :: 		}
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
	BRA Z	L__EnviarTramaRS485340
	GOTO	L__EnviarTramaRS485196
L__EnviarTramaRS485340:
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
	BRA LTU	L__EnviarTramaRS485341
	GOTO	L_EnviarTramaRS48533
L__EnviarTramaRS485341:
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
; numDatosMSB end address is: 2 (W1)
; numDatosLSB end address is: 8 (W4)
; payload end address is: 4 (W2)
	POP	W10
	MOV.B	W1, W3
	MOV	W2, W1
	MOV.B	W4, W2
;rs485.c,42 :: 		while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48535:
; payload start address is: 2 (W1)
; numDatosLSB start address is: 4 (W2)
; numDatosMSB start address is: 6 (W3)
	CALL	_UART1_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485342
	GOTO	L_EnviarTramaRS48536
L__EnviarTramaRS485342:
	GOTO	L_EnviarTramaRS48535
L_EnviarTramaRS48536:
;rs485.c,43 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
; numDatosMSB end address is: 6 (W3)
; numDatosLSB end address is: 4 (W2)
; payload end address is: 2 (W1)
	MOV.B	W3, W0
;rs485.c,44 :: 		}
	GOTO	L_EnviarTramaRS48531
L__EnviarTramaRS485196:
;rs485.c,30 :: 		if (puertoUART == 1){
	MOV.B	W1, W0
	MOV	W2, W1
	MOV.B	W4, W2
;rs485.c,44 :: 		}
L_EnviarTramaRS48531:
;rs485.c,46 :: 		if (puertoUART == 2){
; numDatosMSB start address is: 0 (W0)
; numDatosLSB start address is: 4 (W2)
; payload start address is: 2 (W1)
	CP.B	W10, #2
	BRA Z	L__EnviarTramaRS485343
	GOTO	L_EnviarTramaRS48537
L__EnviarTramaRS485343:
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
L_EnviarTramaRS48538:
; iDatos start address is: 4 (W2)
; payload start address is: 2 (W1)
; payload end address is: 2 (W1)
	CP	W2, W13
	BRA LTU	L__EnviarTramaRS485344
	GOTO	L_EnviarTramaRS48539
L__EnviarTramaRS485344:
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
	GOTO	L_EnviarTramaRS48538
L_EnviarTramaRS48539:
;rs485.c,56 :: 		UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART2_Write
;rs485.c,57 :: 		UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,58 :: 		while(UART2_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48541:
	CALL	_UART2_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485345
	GOTO	L_EnviarTramaRS48542
L__EnviarTramaRS485345:
	GOTO	L_EnviarTramaRS48541
L_EnviarTramaRS48542:
;rs485.c,59 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
;rs485.c,60 :: 		}
L_EnviarTramaRS48537:
;rs485.c,62 :: 		}
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

;Master.c,104 :: 		void main() {
;Master.c,106 :: 		ConfiguracionPrincipal();
	CALL	_ConfiguracionPrincipal
;Master.c,107 :: 		DS3234_init();
	CALL	_DS3234_init
;Master.c,113 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,114 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,115 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;Master.c,116 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;Master.c,119 :: 		banSPI0 = 0;
	MOV	#lo_addr(_banSPI0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,120 :: 		banSPI1 = 0;
	MOV	#lo_addr(_banSPI1), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,121 :: 		banSPI2 = 0;
	MOV	#lo_addr(_banSPI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,122 :: 		banSPI3 = 0;
	MOV	#lo_addr(_banSPI3), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,123 :: 		banSPI4 = 0;
	MOV	#lo_addr(_banSPI4), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,124 :: 		banSPI5 = 0;
	MOV	#lo_addr(_banSPI5), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,125 :: 		banSPI6 = 0;
	MOV	#lo_addr(_banSPI6), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,126 :: 		banSPI7 = 0;
	MOV	#lo_addr(_banSPI7), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,127 :: 		banSPI8 = 0;
	MOV	#lo_addr(_banSPI8), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,128 :: 		banSPI9 = 0;
	MOV	#lo_addr(_banSPI9), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,129 :: 		banSPIA = 0;
	MOV	#lo_addr(_banSPIA), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,132 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;Master.c,133 :: 		byteGPS = 0;
	MOV	#lo_addr(_byteGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,134 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,135 :: 		banTFGPS = 0;
	MOV	#lo_addr(_banTFGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,136 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,137 :: 		banSetGPS = 0;
	MOV	#lo_addr(_banSetGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,140 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,141 :: 		horaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,142 :: 		fechaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,143 :: 		fuenteReloj = 0;
	MOV	#lo_addr(_fuenteReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,144 :: 		referenciaTiempo = 0;
	MOV	#lo_addr(_referenciaTiempo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,147 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,148 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,149 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,150 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,151 :: 		funcionRS485 = 0;
	MOV	#lo_addr(_funcionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,152 :: 		subFuncionRS485 = 0;
	MOV	#lo_addr(_subFuncionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,153 :: 		numDatosRS485 = 0;
	CLR	W0
	MOV	W0, _numDatosRS485
;Master.c,154 :: 		ptrnumDatosRS485 = (unsigned char *) & numDatosRS485;
	MOV	#lo_addr(_numDatosRS485), W0
	MOV	W0, _ptrnumDatosRS485
;Master.c,157 :: 		banInicioMuestreo = 0;
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,160 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,161 :: 		INT_SINC = 1;                                                              //Enciende el pin TEST
	BSET	LATA1_bit, BitPos(LATA1_bit+0)
;Master.c,162 :: 		INT_SINC1 = 0;                                                             //Inicializa los pines de sincronizacion en 0
	BCLR	LATA0_bit, BitPos(LATA0_bit+0)
;Master.c,163 :: 		INT_SINC2 = 0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;Master.c,164 :: 		INT_SINC3 = 0;
	BCLR	LATB10_bit, BitPos(LATB10_bit+0)
;Master.c,165 :: 		INT_SINC4 = 0;
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,167 :: 		MSRS485 = 0;                                                               //Establece el Max485 en modo de lectura;
	BCLR	LATB11_bit, BitPos(LATB11_bit+0)
;Master.c,169 :: 		SPI1BUF = 0x00;
	CLR	SPI1BUF
;Master.c,171 :: 		while(1){
L_main43:
;Master.c,174 :: 		}
	GOTO	L_main43
;Master.c,176 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;Master.c,185 :: 		void ConfiguracionPrincipal(){
;Master.c,188 :: 		CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	CLKDIVbits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, CLKDIVbits
;Master.c,189 :: 		CLKDIVbits.PLLPOST = 0;                                                    //N2=2
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;Master.c,190 :: 		CLKDIVbits.PLLPRE = 5;                                                     //N1=7
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;Master.c,191 :: 		PLLFBDbits.PLLDIV = 150;                                                   //M=152
	MOV	#150, W0
	MOV	W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	#511, W0
	AND	W1, W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	W1, PLLFBDbits
;Master.c,194 :: 		ANSELA = 0;                                                                //Configura PORTA como digital     *
	CLR	ANSELA
;Master.c,195 :: 		ANSELB = 0;                                                                //Configura PORTB como digital     *
	CLR	ANSELB
;Master.c,197 :: 		TRISA2_bit = 0;                                                            //RTC_CS
	BCLR	TRISA2_bit, BitPos(TRISA2_bit+0)
;Master.c,198 :: 		INT_SINC_Direction = 0;                                                    //INT_SINC
	BCLR	TRISA1_bit, BitPos(TRISA1_bit+0)
;Master.c,199 :: 		INT_SINC1_Direction = 0;                                                   //INT_SINC1
	BCLR	TRISA0_bit, BitPos(TRISA0_bit+0)
;Master.c,200 :: 		INT_SINC2_Direction = 0;                                                   //INT_SINC2
	BCLR	TRISA3_bit, BitPos(TRISA3_bit+0)
;Master.c,201 :: 		INT_SINC3_Direction = 0;                                                   //INT_SINC3
	BCLR	TRISB10_bit, BitPos(TRISB10_bit+0)
;Master.c,202 :: 		INT_SINC4_Direction = 0;                                                   //INT_SINC4
	BCLR	TRISB12_bit, BitPos(TRISB12_bit+0)
;Master.c,203 :: 		RP1_Direction = 0;                                                         //RP1
	BCLR	TRISA4_bit, BitPos(TRISA4_bit+0)
;Master.c,204 :: 		MSRS485_Direction = 0;                                                     //MSRS485
	BCLR	TRISB11_bit, BitPos(TRISB11_bit+0)
;Master.c,206 :: 		TRISB13_bit = 1;                                                           //SQW
	BSET	TRISB13_bit, BitPos(TRISB13_bit+0)
;Master.c,207 :: 		TRISB14_bit = 1;                                                           //PPS
	BSET	TRISB14_bit, BitPos(TRISB14_bit+0)
;Master.c,209 :: 		INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales *
	BSET	INTCON2, #15
;Master.c,212 :: 		RPINR18bits.U1RXR = 0x22;                                                  //Configura el pin RB2/RPI34 como Rx1
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
;Master.c,213 :: 		RPOR0bits.RP35R = 0x01;                                                    //Configura el Tx1 en el pin RB3/RP35
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR0bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR0bits
;Master.c,214 :: 		U1RXIE_bit = 0;                                                            //Habilita la interrupcion UART1 RX
	BCLR	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Master.c,215 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;Master.c,216 :: 		IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#16384, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;Master.c,217 :: 		U1STAbits.URXISEL = 0x00;                                                  //Interrupt is set when any character is received and transferred from the UxRSR to the receive buffer; receive buffer has one or more characters
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;Master.c,218 :: 		UART1_Init(9600);                                                          //Inicializa el UART1 con una velocidad de 9600 baudios
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;Master.c,221 :: 		RPINR19bits.U2RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx2
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
;Master.c,222 :: 		RPOR1bits.RP36R = 0x03;                                                    //Configura el Tx2 en el pin RB4/RP36
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
;Master.c,223 :: 		U2RXIE_bit = 1;                                                            //Habilita la interrupcion UART2 RX
	BSET	U2RXIE_bit, BitPos(U2RXIE_bit+0)
;Master.c,224 :: 		U2STAbits.URXISEL = 0x00;
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	W1, [W0]
;Master.c,225 :: 		IPC7bits.U2RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#1024, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC7bits
;Master.c,226 :: 		U2STAbits.URXISEL = 0x00;
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	W1, [W0]
;Master.c,227 :: 		UART2_Init_Advanced(2000000, _UART_8BIT_NOPARITY, _UART_ONE_STOPBIT, _UART_HI_SPEED);
	CLR	W13
	CLR	W12
	MOV	#33920, W10
	MOV	#30, W11
	MOV	#1, W0
	PUSH	W0
	CALL	_UART2_Init_Advanced
	SUB	#2, W15
;Master.c,230 :: 		SPI1STAT.SPIEN = 1;                                                        //Habilita el SPI1 *
	BSET	SPI1STAT, #15
;Master.c,231 :: 		SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
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
;Master.c,232 :: 		SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Master.c,233 :: 		IPC2bits.SPI1IP = 0x03;                                                    //Prioridad de la interrupcion SPI1
	MOV	#768, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;Master.c,236 :: 		RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
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
;Master.c,237 :: 		RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
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
;Master.c,238 :: 		RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
	MOV	#2304, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR1bits
;Master.c,239 :: 		SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
	BSET	SPI2STAT, #15
;Master.c,240 :: 		SPI2_Init();                                                               //Inicializa el modulo SPI2
	CALL	_SPI2_Init
;Master.c,241 :: 		CS_DS3234 = 1;                                                             //Pone en alto el CS del RTC
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;Master.c,244 :: 		RPINR0 = 0x2D00;                                                           //Asigna INT1 al RB13/RPI45 (SQW)
	MOV	#11520, W0
	MOV	WREG, RPINR0
;Master.c,246 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;Master.c,247 :: 		IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;Master.c,250 :: 		SPI1IE_bit = 1;                                                            //SPI1
	BSET	SPI1IE_bit, BitPos(SPI1IE_bit+0)
;Master.c,251 :: 		INT1IE_bit = 0;                                                            //INT1
	BCLR	INT1IE_bit, BitPos(INT1IE_bit+0)
;Master.c,253 :: 		Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#25, W8
	MOV	#27150, W7
L_ConfiguracionPrincipal45:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal45
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal45
	NOP
;Master.c,255 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_InterrupcionP1:

;Master.c,260 :: 		void InterrupcionP1(unsigned short funcionSPI, unsigned short subFuncionSPI, unsigned int numBytesSPI){
;Master.c,263 :: 		if ((funcionSPI==0xB1)&&(subFuncionSPI==0xD1)){
	PUSH	W13
	MOV.B	#177, W0
	CP.B	W10, W0
	BRA Z	L__InterrupcionP1350
	GOTO	L__InterrupcionP1199
L__InterrupcionP1350:
	MOV.B	#209, W0
	CP.B	W11, W0
	BRA Z	L__InterrupcionP1351
	GOTO	L__InterrupcionP1198
L__InterrupcionP1351:
L__InterrupcionP1197:
;Master.c,264 :: 		if (INT1IE_bit==0){
	BTSC	INT1IE_bit, BitPos(INT1IE_bit+0)
	GOTO	L_InterrupcionP150
;Master.c,265 :: 		INT1IE_bit = 1;
	BSET	INT1IE_bit, BitPos(INT1IE_bit+0)
;Master.c,266 :: 		}
L_InterrupcionP150:
;Master.c,268 :: 		outputPyloadRS485[0] = 0xD1;
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#209, W0
	MOV.B	W0, [W1]
;Master.c,269 :: 		for (x=1;x<7;x++){
	MOV	#1, W0
	MOV	W0, _x
L_InterrupcionP151:
	MOV	_x, W0
	CP	W0, #7
	BRA LTU	L__InterrupcionP1352
	GOTO	L_InterrupcionP152
L__InterrupcionP1352:
;Master.c,270 :: 		outputPyloadRS485[x] = tiempo[x-1];
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_tiempo), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Master.c,269 :: 		for (x=1;x<7;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;Master.c,271 :: 		}
	GOTO	L_InterrupcionP151
L_InterrupcionP152:
;Master.c,272 :: 		EnviarTramaRS485(2, 255, 0xF1, 7, outputPyloadRS485);                   //Envia la hora local a los nodos
	PUSH	W12
	PUSH.D	W10
	MOV	#7, W13
	MOV.B	#241, W12
	MOV.B	#255, W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
	POP.D	W10
	POP	W12
;Master.c,263 :: 		if ((funcionSPI==0xB1)&&(subFuncionSPI==0xD1)){
L__InterrupcionP1199:
L__InterrupcionP1198:
;Master.c,276 :: 		ptrnumBytesSPI = (unsigned char *) & numBytesSPI;
	MOV	#lo_addr(W12), W2
	MOV	W2, _ptrnumBytesSPI
;Master.c,279 :: 		tramaSolicitudSPI[0] = funcionSPI;                                         //Operacion solicitada
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV.B	W10, [W0]
;Master.c,280 :: 		tramaSolicitudSPI[1] = subFuncionSPI;                                      //Subfuncion solicitada
	MOV	#lo_addr(_tramaSolicitudSPI+1), W0
	MOV.B	W11, [W0]
;Master.c,281 :: 		tramaSolicitudSPI[2] = *(ptrnumBytesSPI);                                  //LSB numBytesSPI
	MOV.B	[W2], W1
	MOV	#lo_addr(_tramaSolicitudSPI+2), W0
	MOV.B	W1, [W0]
;Master.c,282 :: 		tramaSolicitudSPI[3] = *(ptrnumBytesSPI+1);                                //MSB numBytesSPI
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_tramaSolicitudSPI+3), W0
	MOV.B	W1, [W0]
;Master.c,285 :: 		RP1 = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,286 :: 		Delay_us(20);
	MOV	#160, W7
L_InterrupcionP154:
	DEC	W7
	BRA NZ	L_InterrupcionP154
	NOP
	NOP
;Master.c,287 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,289 :: 		}
L_end_InterrupcionP1:
	POP	W13
	RETURN
; end of _InterrupcionP1

_spi_1:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Master.c,299 :: 		void spi_1() org  IVT_ADDR_SPI1INTERRUPT {
;Master.c,301 :: 		SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Master.c,302 :: 		bufferSPI = SPI1BUF;                                                       //Guarda el contenido del bufeer (lectura)
	MOV	#lo_addr(_bufferSPI), W1
	MOV.B	SPI1BUF, WREG
	MOV.B	W0, [W1]
;Master.c,306 :: 		if ((banSPI0==0)&&(bufferSPI==0xA0)) {
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1354
	GOTO	L__spi_1230
L__spi_1354:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#160, W0
	CP.B	W1, W0
	BRA Z	L__spi_1355
	GOTO	L__spi_1229
L__spi_1355:
L__spi_1228:
;Master.c,307 :: 		banSPI0 = 1;                                                            //Activa la bandera para enviar el tipo de operacion requerido a la RPi
	MOV	#lo_addr(_banSPI0), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,308 :: 		i = 1;
	MOV	#1, W0
	MOV	W0, _i
;Master.c,309 :: 		SPI1BUF = tramaSolicitudSPI[0];                                         //Carga en el buffer la funcion requerida
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Master.c,306 :: 		if ((banSPI0==0)&&(bufferSPI==0xA0)) {
L__spi_1230:
L__spi_1229:
;Master.c,311 :: 		if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1356
	GOTO	L__spi_1233
L__spi_1356:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#160, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1357
	GOTO	L__spi_1232
L__spi_1357:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#240, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1358
	GOTO	L__spi_1231
L__spi_1358:
L__spi_1227:
;Master.c,312 :: 		SPI1BUF = tramaSolicitudSPI[i];                                         //Se envia la subfuncion, y el LSB y MSB de la variable numBytesSPI
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,313 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,311 :: 		if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
L__spi_1233:
L__spi_1232:
L__spi_1231:
;Master.c,315 :: 		if ((banSPI0==1)&&(bufferSPI==0xF0)){
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1359
	GOTO	L__spi_1235
L__spi_1359:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#240, W0
	CP.B	W1, W0
	BRA Z	L__spi_1360
	GOTO	L__spi_1234
L__spi_1360:
L__spi_1226:
;Master.c,316 :: 		banSPI0 = 0;                                                            //Limpia la bandera
	MOV	#lo_addr(_banSPI0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,315 :: 		if ((banSPI0==1)&&(bufferSPI==0xF0)){
L__spi_1235:
L__spi_1234:
;Master.c,324 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)){
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1361
	GOTO	L__spi_1237
L__spi_1361:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#161, W0
	CP.B	W1, W0
	BRA Z	L__spi_1362
	GOTO	L__spi_1236
L__spi_1362:
L__spi_1225:
;Master.c,325 :: 		banSPI1 = 1;
	MOV	#lo_addr(_banSPI1), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,326 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,324 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)){
L__spi_1237:
L__spi_1236:
;Master.c,328 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1363
	GOTO	L__spi_1240
L__spi_1363:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#161, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1364
	GOTO	L__spi_1239
L__spi_1364:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1365
	GOTO	L__spi_1238
L__spi_1365:
L__spi_1224:
;Master.c,329 :: 		tramaSolicitudSPI[i] = bufferSPI;                                       //Recupera la direccion del nodo y el indicador de sobrescritura de la SD
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,330 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,328 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
L__spi_1240:
L__spi_1239:
L__spi_1238:
;Master.c,332 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1366
	GOTO	L__spi_1242
L__spi_1366:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA Z	L__spi_1367
	GOTO	L__spi_1241
L__spi_1367:
L__spi_1223:
;Master.c,333 :: 		direccionRS485 = tramaSolicitudSPI[0];
	MOV	#lo_addr(_direccionRS485), W1
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV.B	[W0], [W1]
;Master.c,334 :: 		outputPyloadRS485[0] = 0xD1;                                            //Subfuncion iniciar muestreo
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#209, W0
	MOV.B	W0, [W1]
;Master.c,335 :: 		outputPyloadRS485[1] = tramaSolicitudSPI[1];                            //Payload sobrescribir SD
	MOV	#lo_addr(_outputPyloadRS485+1), W1
	MOV	#lo_addr(_tramaSolicitudSPI+1), W0
	MOV.B	[W0], [W1]
;Master.c,336 :: 		EnviarTramaRS485(2, direccionRS485, 0xF2, 2, outputPyloadRS485);        //Envia la solicitud al nodo
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV	#2, W13
	MOV.B	#242, W12
	MOV.B	[W0], W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;Master.c,337 :: 		banSPI1 = 0;
	MOV	#lo_addr(_banSPI1), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,332 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
L__spi_1242:
L__spi_1241:
;Master.c,341 :: 		if ((banSPI2==0)&&(bufferSPI==0xA2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1368
	GOTO	L__spi_1244
L__spi_1368:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#162, W0
	CP.B	W1, W0
	BRA Z	L__spi_1369
	GOTO	L__spi_1243
L__spi_1369:
L__spi_1222:
;Master.c,342 :: 		banSPI2 = 1;
	MOV	#lo_addr(_banSPI2), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,343 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,341 :: 		if ((banSPI2==0)&&(bufferSPI==0xA2)){
L__spi_1244:
L__spi_1243:
;Master.c,345 :: 		if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1370
	GOTO	L__spi_1247
L__spi_1370:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#162, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1371
	GOTO	L__spi_1246
L__spi_1371:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1372
	GOTO	L__spi_1245
L__spi_1372:
L__spi_1221:
;Master.c,346 :: 		tramaSolicitudSPI[i] = bufferSPI;                                       //Recupera la direccion del nodo
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,345 :: 		if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
L__spi_1247:
L__spi_1246:
L__spi_1245:
;Master.c,348 :: 		if ((banSPI2==1)&&(bufferSPI==0xF2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1373
	GOTO	L__spi_1249
L__spi_1373:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA Z	L__spi_1374
	GOTO	L__spi_1248
L__spi_1374:
L__spi_1220:
;Master.c,349 :: 		direccionRS485 = tramaSolicitudSPI[0];
	MOV	#lo_addr(_direccionRS485), W1
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV.B	[W0], [W1]
;Master.c,350 :: 		outputPyloadRS485[0] = 0xD2;                                            //Subfuncion detener muestreo
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;Master.c,351 :: 		EnviarTramaRS485(2, direccionRS485, 0xF2, 1, outputPyloadRS485);        //Envia la solicitud al nodo
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV	#1, W13
	MOV.B	#242, W12
	MOV.B	[W0], W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;Master.c,352 :: 		banSPI2 = 0;
	MOV	#lo_addr(_banSPI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,348 :: 		if ((banSPI2==1)&&(bufferSPI==0xF2)){
L__spi_1249:
L__spi_1248:
;Master.c,361 :: 		if ((banSetReloj==0)&&(bufferSPI==0xA4)){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1375
	GOTO	L__spi_1251
L__spi_1375:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#164, W0
	CP.B	W1, W0
	BRA Z	L__spi_1376
	GOTO	L__spi_1250
L__spi_1376:
L__spi_1219:
;Master.c,362 :: 		banSPI4 = 1;
	MOV	#lo_addr(_banSPI4), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,363 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,361 :: 		if ((banSetReloj==0)&&(bufferSPI==0xA4)){
L__spi_1251:
L__spi_1250:
;Master.c,365 :: 		if ((banSPI4==1)&&(bufferSPI!=0xA4)&&(bufferSPI!=0xF4)){
	MOV	#lo_addr(_banSPI4), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1377
	GOTO	L__spi_1254
L__spi_1377:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#164, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1378
	GOTO	L__spi_1253
L__spi_1378:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#244, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1379
	GOTO	L__spi_1252
L__spi_1379:
L__spi_1218:
;Master.c,366 :: 		tiempoRPI[j] = bufferSPI;
	MOV	#lo_addr(_tiempoRPI), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,367 :: 		j++;
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;Master.c,365 :: 		if ((banSPI4==1)&&(bufferSPI!=0xA4)&&(bufferSPI!=0xF4)){
L__spi_1254:
L__spi_1253:
L__spi_1252:
;Master.c,369 :: 		if ((banSPI4==1)&&(bufferSPI==0xF4)){
	MOV	#lo_addr(_banSPI4), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1380
	GOTO	L__spi_1256
L__spi_1380:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#244, W0
	CP.B	W1, W0
	BRA Z	L__spi_1381
	GOTO	L__spi_1255
L__spi_1381:
L__spi_1217:
;Master.c,370 :: 		horaSistema = RecuperarHoraRPI(tiempoRPI);                              //Recupera la hora de la RPi
	MOV	#lo_addr(_tiempoRPI), W10
	CALL	_RecuperarHoraRPI
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,371 :: 		fechaSistema = RecuperarFechaRPI(tiempoRPI);                            //Recupera la fecha de la RPi
	MOV	#lo_addr(_tiempoRPI), W10
	CALL	_RecuperarFechaRPI
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,372 :: 		DS3234_setDate(horaSistema, fechaSistema);                              //Configura la hora en el RTC
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	CALL	_DS3234_setDate
;Master.c,373 :: 		horaSistema = RecuperarHoraRTC();                                       //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,374 :: 		fechaSistema = RecuperarFechaRTC();                                     //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,375 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,376 :: 		banSPI4 = 0;
	MOV	#lo_addr(_banSPI4), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,377 :: 		banSetReloj = 1;                                                        //Activa la bandera para utilizar el tiempo
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,378 :: 		InterrupcionP1(0xB1,0xD1,6);                                            //Envia la hora local a la RPi y a los nodos
	MOV	#6, W12
	MOV.B	#209, W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,369 :: 		if ((banSPI4==1)&&(bufferSPI==0xF4)){
L__spi_1256:
L__spi_1255:
;Master.c,383 :: 		if ((banSetReloj==1)&&(bufferSPI==0xA5)){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1382
	GOTO	L__spi_1258
L__spi_1382:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#165, W0
	CP.B	W1, W0
	BRA Z	L__spi_1383
	GOTO	L__spi_1257
L__spi_1383:
L__spi_1216:
;Master.c,384 :: 		banSPI5 = 1;
	MOV	#lo_addr(_banSPI5), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,385 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,386 :: 		SPI1BUF = fuenteReloj;                                                  //Envia el indicador de fuente de reloj (0:RTC, 1:GPS)
	MOV	#lo_addr(_fuenteReloj), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Master.c,383 :: 		if ((banSetReloj==1)&&(bufferSPI==0xA5)){
L__spi_1258:
L__spi_1257:
;Master.c,388 :: 		if ((banSPI5==1)&&(bufferSPI!=0xA5)&&(bufferSPI!=0xF5)){
	MOV	#lo_addr(_banSPI5), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1384
	GOTO	L__spi_1261
L__spi_1384:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#165, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1385
	GOTO	L__spi_1260
L__spi_1385:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#245, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1386
	GOTO	L__spi_1259
L__spi_1386:
L__spi_1215:
;Master.c,389 :: 		SPI1BUF = tiempo[j];
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,390 :: 		j++;
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;Master.c,388 :: 		if ((banSPI5==1)&&(bufferSPI!=0xA5)&&(bufferSPI!=0xF5)){
L__spi_1261:
L__spi_1260:
L__spi_1259:
;Master.c,392 :: 		if ((banSPI5==1)&&(bufferSPI==0xF5)){
	MOV	#lo_addr(_banSPI5), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1387
	GOTO	L__spi_1263
L__spi_1387:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#245, W0
	CP.B	W1, W0
	BRA Z	L__spi_1388
	GOTO	L__spi_1262
L__spi_1388:
L__spi_1214:
;Master.c,393 :: 		banSPI5 = 0;
	MOV	#lo_addr(_banSPI5), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,394 :: 		banSetReloj = 0;                                                        //Limpia la bandera de lectura
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,392 :: 		if ((banSPI5==1)&&(bufferSPI==0xF5)){
L__spi_1263:
L__spi_1262:
;Master.c,399 :: 		if ((banSetReloj==0)&&(bufferSPI==0xA6)){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1389
	GOTO	L__spi_1265
L__spi_1389:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#166, W0
	CP.B	W1, W0
	BRA Z	L__spi_1390
	GOTO	L__spi_1264
L__spi_1390:
L__spi_1213:
;Master.c,400 :: 		banSPI6 = 1;
	MOV	#lo_addr(_banSPI6), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,399 :: 		if ((banSetReloj==0)&&(bufferSPI==0xA6)){
L__spi_1265:
L__spi_1264:
;Master.c,402 :: 		if ((banSPI6==1)&&(bufferSPI!=0xA6)&&(bufferSPI!=0xF6)){
	MOV	#lo_addr(_banSPI6), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1391
	GOTO	L__spi_1268
L__spi_1391:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#166, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1392
	GOTO	L__spi_1267
L__spi_1392:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#246, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1393
	GOTO	L__spi_1266
L__spi_1393:
L__spi_1212:
;Master.c,403 :: 		referenciaTiempo =  bufferSPI;                                          //Recupera la opcion de referencia de tiempo solicitada
	MOV	#lo_addr(_referenciaTiempo), W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,402 :: 		if ((banSPI6==1)&&(bufferSPI!=0xA6)&&(bufferSPI!=0xF6)){
L__spi_1268:
L__spi_1267:
L__spi_1266:
;Master.c,405 :: 		if ((banSPI6==1)&&(bufferSPI==0xF6)){
	MOV	#lo_addr(_banSPI6), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1394
	GOTO	L__spi_1270
L__spi_1394:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#246, W0
	CP.B	W1, W0
	BRA Z	L__spi_1395
	GOTO	L__spi_1269
L__spi_1395:
L__spi_1211:
;Master.c,406 :: 		banSPI6 = 0;
	MOV	#lo_addr(_banSPI6), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,407 :: 		if (referenciaTiempo==1){
	MOV	#lo_addr(_referenciaTiempo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1396
	GOTO	L_spi_1110
L__spi_1396:
;Master.c,409 :: 		banTIGPS = 0;                                                   //Limpia la bandera de inicio de trama  del GPS
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,410 :: 		banTCGPS = 0;                                                   //Limpia la bandera de trama completa
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,411 :: 		i_gps = 0;                                                      //Limpia el subindice de la trama GPS
	CLR	W0
	MOV	W0, _i_gps
;Master.c,413 :: 		if (U1RXIE_bit==0){
	BTSC	U1RXIE_bit, BitPos(U1RXIE_bit+0)
	GOTO	L_spi_1111
;Master.c,414 :: 		U1RXIE_bit = 1;
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Master.c,415 :: 		}
L_spi_1111:
;Master.c,416 :: 		} else {
	GOTO	L_spi_1112
L_spi_1110:
;Master.c,418 :: 		horaSistema = RecuperarHoraRTC();                               //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,419 :: 		fechaSistema = RecuperarFechaRTC();                             //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,420 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);        //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,421 :: 		fuenteReloj = 0;                                                //**Hay que corregir esto en todo
	MOV	#lo_addr(_fuenteReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,422 :: 		banSetReloj = 1;
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,423 :: 		InterrupcionP1(0xB1,0xD1,6);                                    //Envia la hora local a la RPi
	MOV	#6, W12
	MOV.B	#209, W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,424 :: 		}
L_spi_1112:
;Master.c,405 :: 		if ((banSPI6==1)&&(bufferSPI==0xF6)){
L__spi_1270:
L__spi_1269:
;Master.c,429 :: 		if ((banSPI7==0)&&(bufferSPI==0xA7)){
	MOV	#lo_addr(_banSPI7), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1397
	GOTO	L__spi_1272
L__spi_1397:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#167, W0
	CP.B	W1, W0
	BRA Z	L__spi_1398
	GOTO	L__spi_1271
L__spi_1398:
L__spi_1210:
;Master.c,430 :: 		banSPI7 = 1;
	MOV	#lo_addr(_banSPI7), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,429 :: 		if ((banSPI7==0)&&(bufferSPI==0xA7)){
L__spi_1272:
L__spi_1271:
;Master.c,432 :: 		if ((banSPI7==1)&&(bufferSPI!=0xA7)&&(bufferSPI!=0xF7)){
	MOV	#lo_addr(_banSPI7), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1399
	GOTO	L__spi_1275
L__spi_1399:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#167, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1400
	GOTO	L__spi_1274
L__spi_1400:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#247, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1401
	GOTO	L__spi_1273
L__spi_1401:
L__spi_1209:
;Master.c,433 :: 		direccionRS485 =  bufferSPI;                                            //Recupera la direccion del nodo solicitado
	MOV	#lo_addr(_direccionRS485), W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,432 :: 		if ((banSPI7==1)&&(bufferSPI!=0xA7)&&(bufferSPI!=0xF7)){
L__spi_1275:
L__spi_1274:
L__spi_1273:
;Master.c,435 :: 		if ((banSPI7==1)&&(bufferSPI==0xF7)){
	MOV	#lo_addr(_banSPI7), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1402
	GOTO	L__spi_1277
L__spi_1402:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#247, W0
	CP.B	W1, W0
	BRA Z	L__spi_1403
	GOTO	L__spi_1276
L__spi_1403:
L__spi_1208:
;Master.c,436 :: 		banSPI7 = 0;
	MOV	#lo_addr(_banSPI7), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,437 :: 		outputPyloadRS485[0] = 0xD2;                                            //Llena el pyload de salidad con la subfuncion solicitada
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;Master.c,438 :: 		EnviarTramaRS485(2, direccionRS485, 0xF1, 1, outputPyloadRS485);        //Envia la solicitud al nodo
	MOV	#lo_addr(_direccionRS485), W0
	MOV	#1, W13
	MOV.B	#241, W12
	MOV.B	[W0], W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;Master.c,435 :: 		if ((banSPI7==1)&&(bufferSPI==0xF7)){
L__spi_1277:
L__spi_1276:
;Master.c,443 :: 		if ((banSPI8==0)&&(bufferSPI==0xA8)){
	MOV	#lo_addr(_banSPI8), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1404
	GOTO	L__spi_1279
L__spi_1404:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#168, W0
	CP.B	W1, W0
	BRA Z	L__spi_1405
	GOTO	L__spi_1278
L__spi_1405:
L__spi_1207:
;Master.c,445 :: 		banSPI0 = 2;
	MOV	#lo_addr(_banSPI0), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,446 :: 		banSPI1 = 2;
	MOV	#lo_addr(_banSPI1), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,447 :: 		banSPI2 = 2;
	MOV	#lo_addr(_banSPI2), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,448 :: 		banSPI4 = 2;
	MOV	#lo_addr(_banSPI4), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,449 :: 		banSPI5 = 2;
	MOV	#lo_addr(_banSPI5), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,450 :: 		banSPI6 = 2;
	MOV	#lo_addr(_banSPI6), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,451 :: 		banSPI7 = 2;
	MOV	#lo_addr(_banSPI7), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,452 :: 		banSPIA = 2;
	MOV	#lo_addr(_banSPIA), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,453 :: 		banSPI8 = 1;                                                            //Activa la bandera para recuperar los datos de cabecera
	MOV	#lo_addr(_banSPI8), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,454 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,443 :: 		if ((banSPI8==0)&&(bufferSPI==0xA8)){
L__spi_1279:
L__spi_1278:
;Master.c,457 :: 		if ((banSPI8==1)&&(i<4)){
	MOV	#lo_addr(_banSPI8), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1406
	GOTO	L__spi_1281
L__spi_1406:
	MOV	_i, W0
	CP	W0, #4
	BRA LTU	L__spi_1407
	GOTO	L__spi_1280
L__spi_1407:
L__spi_1206:
;Master.c,458 :: 		tramaSolicitudNodo[i] = bufferSPI;
	MOV	#lo_addr(_tramaSolicitudNodo), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,459 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,457 :: 		if ((banSPI8==1)&&(i<4)){
L__spi_1281:
L__spi_1280:
;Master.c,462 :: 		if ((banSPI8==1)&&(i==4)){
	MOV	#lo_addr(_banSPI8), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1408
	GOTO	L__spi_1283
L__spi_1408:
	MOV	_i, W0
	CP	W0, #4
	BRA Z	L__spi_1409
	GOTO	L__spi_1282
L__spi_1409:
L__spi_1205:
;Master.c,463 :: 		direccionRS485 = tramaSolicitudNodo[1];
	MOV	#lo_addr(_direccionRS485), W1
	MOV	#lo_addr(_tramaSolicitudNodo+1), W0
	MOV.B	[W0], [W1]
;Master.c,464 :: 		funcionRS485 = tramaSolicitudNodo[2];
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_tramaSolicitudNodo+2), W0
	MOV.B	[W0], [W1]
;Master.c,465 :: 		numDatosRS485 = tramaSolicitudNodo[3];
	MOV	#lo_addr(_tramaSolicitudNodo+3), W0
	ZE	[W0], W0
	MOV	W0, _numDatosRS485
;Master.c,466 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,467 :: 		banSPI8 = 2;
	MOV	#lo_addr(_banSPI8), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,462 :: 		if ((banSPI8==1)&&(i==4)){
L__spi_1283:
L__spi_1282:
;Master.c,470 :: 		if ((banSPI8==2)&&(i<=numDatosRS485)){
	MOV	#lo_addr(_banSPI8), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__spi_1410
	GOTO	L__spi_1285
L__spi_1410:
	MOV	_i, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LEU	L__spi_1411
	GOTO	L__spi_1284
L__spi_1411:
L__spi_1204:
;Master.c,471 :: 		tramaSolicitudNodo[i] = bufferSPI;
	MOV	#lo_addr(_tramaSolicitudNodo), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,472 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,470 :: 		if ((banSPI8==2)&&(i<=numDatosRS485)){
L__spi_1285:
L__spi_1284:
;Master.c,475 :: 		if ((banSPI8==2)&&(bufferSPI==0xF8)&&(i>numDatosRS485)){
	MOV	#lo_addr(_banSPI8), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__spi_1412
	GOTO	L__spi_1288
L__spi_1412:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#248, W0
	CP.B	W1, W0
	BRA Z	L__spi_1413
	GOTO	L__spi_1287
L__spi_1413:
	MOV	_i, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA GTU	L__spi_1414
	GOTO	L__spi_1286
L__spi_1414:
L__spi_1203:
;Master.c,476 :: 		banSPI0 = 0;
	MOV	#lo_addr(_banSPI0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,477 :: 		banSPI1 = 0;
	MOV	#lo_addr(_banSPI1), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,478 :: 		banSPI2 = 0;
	MOV	#lo_addr(_banSPI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,479 :: 		banSPI4 = 0;
	MOV	#lo_addr(_banSPI4), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,480 :: 		banSPI5 = 0;
	MOV	#lo_addr(_banSPI5), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,481 :: 		banSPI6 = 0;
	MOV	#lo_addr(_banSPI6), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,482 :: 		banSPI7 = 0;
	MOV	#lo_addr(_banSPI7), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,483 :: 		banSPIA = 0;
	MOV	#lo_addr(_banSPIA), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,484 :: 		banSPI8 = 0;
	MOV	#lo_addr(_banSPI8), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,486 :: 		if (numDatosRS485>1){
	MOV	_numDatosRS485, W0
	CP	W0, #1
	BRA GTU	L__spi_1415
	GOTO	L_spi_1137
L__spi_1415:
;Master.c,487 :: 		for (x=0;x<numDatosRS485;x++){
	CLR	W0
	MOV	W0, _x
L_spi_1138:
	MOV	_x, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__spi_1416
	GOTO	L_spi_1139
L__spi_1416:
;Master.c,488 :: 		outputPyloadRS485[x] = tramaSolicitudNodo[x+1];
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaSolicitudNodo), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Master.c,487 :: 		for (x=0;x<numDatosRS485;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;Master.c,489 :: 		}
	GOTO	L_spi_1138
L_spi_1139:
;Master.c,490 :: 		} else {
	GOTO	L_spi_1141
L_spi_1137:
;Master.c,491 :: 		outputPyloadRS485[0] = tramaSolicitudNodo[1];
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV	#lo_addr(_tramaSolicitudNodo+1), W0
	MOV.B	[W0], [W1]
;Master.c,492 :: 		}
L_spi_1141:
;Master.c,494 :: 		EnviarTramaRS485(2, direccionRS485, funcionRS485, numDatosRS485, outputPyloadRS485);
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
;Master.c,475 :: 		if ((banSPI8==2)&&(bufferSPI==0xF8)&&(i>numDatosRS485)){
L__spi_1288:
L__spi_1287:
L__spi_1286:
;Master.c,499 :: 		if ((banSPIA==0)&&(bufferSPI==0xAA)){
	MOV	#lo_addr(_banSPIA), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1417
	GOTO	L__spi_1290
L__spi_1417:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#170, W0
	CP.B	W1, W0
	BRA Z	L__spi_1418
	GOTO	L__spi_1289
L__spi_1418:
L__spi_1202:
;Master.c,500 :: 		banSPIA = 1;
	MOV	#lo_addr(_banSPIA), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,501 :: 		SPI1BUF = inputPyloadRS485[0];
	MOV	#lo_addr(_inputPyloadRS485), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Master.c,502 :: 		i = 1;
	MOV	#1, W0
	MOV	W0, _i
;Master.c,499 :: 		if ((banSPIA==0)&&(bufferSPI==0xAA)){
L__spi_1290:
L__spi_1289:
;Master.c,504 :: 		if ((banSPIA==1)&&(bufferSPI!=0xAA)&&(bufferSPI!=0xFA)){
	MOV	#lo_addr(_banSPIA), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1419
	GOTO	L__spi_1293
L__spi_1419:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#170, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1420
	GOTO	L__spi_1292
L__spi_1420:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#250, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1421
	GOTO	L__spi_1291
L__spi_1421:
L__spi_1201:
;Master.c,505 :: 		SPI1BUF = inputPyloadRS485[i];
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,506 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,504 :: 		if ((banSPIA==1)&&(bufferSPI!=0xAA)&&(bufferSPI!=0xFA)){
L__spi_1293:
L__spi_1292:
L__spi_1291:
;Master.c,508 :: 		if ((banSPIA==1)&&(bufferSPI==0xFA)){
	MOV	#lo_addr(_banSPIA), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1422
	GOTO	L__spi_1295
L__spi_1422:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#250, W0
	CP.B	W1, W0
	BRA Z	L__spi_1423
	GOTO	L__spi_1294
L__spi_1423:
L__spi_1200:
;Master.c,509 :: 		banSPIA = 0;
	MOV	#lo_addr(_banSPIA), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,508 :: 		if ((banSPIA==1)&&(bufferSPI==0xFA)){
L__spi_1295:
L__spi_1294:
;Master.c,547 :: 		}
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

;Master.c,552 :: 		void int_1() org IVT_ADDR_INT1INTERRUPT {
;Master.c,554 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;Master.c,556 :: 		horaSistema++;                                                             //Incrementa el reloj del sistema
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaSistema), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;Master.c,557 :: 		INT_SINC = ~INT_SINC;                                                      //TEST
	BTG	LATA1_bit, BitPos(LATA1_bit+0)
;Master.c,561 :: 		INT_SINC1 = 1;
	BSET	LATA0_bit, BitPos(LATA0_bit+0)
;Master.c,562 :: 		INT_SINC2 = 1;
	BSET	LATA3_bit, BitPos(LATA3_bit+0)
;Master.c,563 :: 		INT_SINC3 = 1;
	BSET	LATB10_bit, BitPos(LATB10_bit+0)
;Master.c,564 :: 		INT_SINC4 = 1;
	BSET	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,565 :: 		Delay_us(20);
	MOV	#160, W7
L_int_1151:
	DEC	W7
	BRA NZ	L_int_1151
	NOP
	NOP
;Master.c,567 :: 		INT_SINC1 = 0;
	BCLR	LATA0_bit, BitPos(LATA0_bit+0)
;Master.c,568 :: 		INT_SINC2 = 0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;Master.c,569 :: 		INT_SINC3 = 0;
	BCLR	LATB10_bit, BitPos(LATB10_bit+0)
;Master.c,570 :: 		INT_SINC4 = 0;
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,572 :: 		if (horaSistema==86400){                                                   //(24*3600)+(0*60)+(0) = 86400
	MOV	_horaSistema, W2
	MOV	_horaSistema+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__int_1425
	GOTO	L_int_1153
L__int_1425:
;Master.c,573 :: 		horaSistema = 0;                                                        //Reinicia el reloj al llegar a las 24:00:00 horas
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,574 :: 		}
L_int_1153:
;Master.c,575 :: 		if (banInicio==1){
	MOV	#lo_addr(_banInicio), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1426
	GOTO	L_int_1154
L__int_1426:
;Master.c,578 :: 		}
L_int_1154:
;Master.c,580 :: 		}
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

_urx_2:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Master.c,667 :: 		void urx_2() org  IVT_ADDR_U2RXINTERRUPT {
;Master.c,670 :: 		U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART2
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BCLR	U2RXIF_bit, BitPos(U2RXIF_bit+0)
;Master.c,671 :: 		byteRS485 = U2RXREG;                                                       //Lee el byte de la trama enviada por el nodo
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	U2RXREG, WREG
	MOV.B	W0, [W1]
;Master.c,672 :: 		U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART2
	BCLR	U2STA, #1
;Master.c,675 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_2428
	GOTO	L_urx_2155
L__urx_2428:
;Master.c,676 :: 		if (i_rs485<numDatosRS485){
	MOV	_i_rs485, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__urx_2429
	GOTO	L_urx_2156
L__urx_2429:
;Master.c,677 :: 		inputPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;Master.c,678 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;Master.c,679 :: 		} else {
	GOTO	L_urx_2157
L_urx_2156:
;Master.c,680 :: 		banRSI = 0;                                                          //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,681 :: 		banRSC = 1;                                                          //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,682 :: 		}
L_urx_2157:
;Master.c,683 :: 		}
L_urx_2155:
;Master.c,686 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_2430
	GOTO	L__urx_2300
L__urx_2430:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_2431
	GOTO	L__urx_2299
L__urx_2431:
L__urx_2298:
;Master.c,687 :: 		if (byteRS485==0x3A){                                                   //Verifica si el primer byte recibido sea la cabecera de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__urx_2432
	GOTO	L_urx_2161
L__urx_2432:
;Master.c,688 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,689 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,690 :: 		}
L_urx_2161:
;Master.c,686 :: 		if ((banRSI==0)&&(banRSC==0)){
L__urx_2300:
L__urx_2299:
;Master.c,692 :: 		if ((banRSI==1)&&(i_rs485<5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2433
	GOTO	L__urx_2302
L__urx_2433:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA LTU	L__urx_2434
	GOTO	L__urx_2301
L__urx_2434:
L__urx_2297:
;Master.c,693 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                                 //Recupera los datos de cabecera de la trama UART: [0x3A, Direccion, Funcion, NumeroDatos]
	MOV	#lo_addr(_tramaCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;Master.c,694 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;Master.c,692 :: 		if ((banRSI==1)&&(i_rs485<5)){
L__urx_2302:
L__urx_2301:
;Master.c,696 :: 		if ((banRSI==1)&&(i_rs485==5)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2435
	GOTO	L__urx_2304
L__urx_2435:
	MOV	_i_rs485, W0
	CP	W0, #5
	BRA Z	L__urx_2436
	GOTO	L__urx_2303
L__urx_2436:
L__urx_2296:
;Master.c,698 :: 		if (tramaCabeceraRS485[1]==direccionRS485){
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_direccionRS485), W0
	CP.B	W1, [W0]
	BRA Z	L__urx_2437
	GOTO	L_urx_2168
L__urx_2437:
;Master.c,700 :: 		funcionRS485 = tramaCabeceraRS485[2];
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_tramaCabeceraRS485+2), W0
	MOV.B	[W0], [W1]
;Master.c,701 :: 		*(ptrnumDatosRS485) = tramaCabeceraRS485[3];                         //LSB numDatosRS485
	MOV	#lo_addr(_tramaCabeceraRS485+3), W1
	MOV	_ptrnumDatosRS485, W0
	MOV.B	[W1], [W0]
;Master.c,702 :: 		*(ptrnumDatosRS485+1) = tramaCabeceraRS485[4];                       //MSB numDatosRS485
	MOV	_ptrnumDatosRS485, W0
	ADD	W0, #1, W1
	MOV	#lo_addr(_tramaCabeceraRS485+4), W0
	MOV.B	[W0], [W1]
;Master.c,703 :: 		banRSI = 2;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,704 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,705 :: 		} else {
	GOTO	L_urx_2169
L_urx_2168:
;Master.c,706 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,707 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,708 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,709 :: 		}
L_urx_2169:
;Master.c,696 :: 		if ((banRSI==1)&&(i_rs485==5)){
L__urx_2304:
L__urx_2303:
;Master.c,713 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2438
	GOTO	L_urx_2170
L__urx_2438:
;Master.c,714 :: 		subFuncionRS485 = inputPyloadRS485[0];
	MOV	#lo_addr(_subFuncionRS485), W1
	MOV	#lo_addr(_inputPyloadRS485), W0
	MOV.B	[W0], [W1]
;Master.c,715 :: 		switch (funcionRS485){
	GOTO	L_urx_2171
;Master.c,716 :: 		case 0xF1:
L_urx_2173:
;Master.c,717 :: 		InterrupcionP1(0xB1,subFuncionRS485,numDatosRS485);
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV	_numDatosRS485, W12
	MOV.B	[W0], W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,718 :: 		break;
	GOTO	L_urx_2172
;Master.c,719 :: 		case 0xF2:
L_urx_2174:
;Master.c,721 :: 		break;
	GOTO	L_urx_2172
;Master.c,722 :: 		case 0xF3:
L_urx_2175:
;Master.c,723 :: 		InterrupcionP1(0xB3,subFuncionRS485,numDatosRS485);
	MOV	#lo_addr(_subFuncionRS485), W0
	MOV	_numDatosRS485, W12
	MOV.B	[W0], W11
	MOV.B	#179, W10
	CALL	_InterrupcionP1
;Master.c,725 :: 		break;
	GOTO	L_urx_2172
;Master.c,726 :: 		}
L_urx_2171:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__urx_2439
	GOTO	L_urx_2173
L__urx_2439:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA NZ	L__urx_2440
	GOTO	L_urx_2174
L__urx_2440:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA NZ	L__urx_2441
	GOTO	L_urx_2175
L__urx_2441:
L_urx_2172:
;Master.c,728 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,730 :: 		}
L_urx_2170:
;Master.c,731 :: 		}
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
