
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
	BRA LTU	L__IncrementarFecha300
	GOTO	L_IncrementarFecha0
L__IncrementarFecha300:
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
	BRA Z	L__IncrementarFecha301
	GOTO	L_IncrementarFecha2
L__IncrementarFecha301:
;tiempo_rtc.c,202 :: 		if (((anio-16)%4)==0){
	SUB	W2, #16, W0
	SUBB	W3, #0, W1
	AND	W0, #3, W0
	AND	W1, #0, W1
	CP	W0, #0
	CPB	W1, #0
	BRA Z	L__IncrementarFecha302
	GOTO	L_IncrementarFecha3
L__IncrementarFecha302:
;tiempo_rtc.c,203 :: 		if (dia==29){
	CP	W6, #29
	CPB	W7, #0
	BRA Z	L__IncrementarFecha303
	GOTO	L_IncrementarFecha4
L__IncrementarFecha303:
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
	BRA LTU	L__IncrementarFecha304
	GOTO	L_IncrementarFecha8
L__IncrementarFecha304:
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
	BRA NZ	L__IncrementarFecha305
	GOTO	L__IncrementarFecha175
L__IncrementarFecha305:
	CP	W4, #6
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha306
	GOTO	L__IncrementarFecha174
L__IncrementarFecha306:
	CP	W4, #9
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha307
	GOTO	L__IncrementarFecha173
L__IncrementarFecha307:
	CP	W4, #11
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha308
	GOTO	L__IncrementarFecha172
L__IncrementarFecha308:
	MOV.D	W4, W0
	MOV.D	W6, W4
	GOTO	L_IncrementarFecha12
L__IncrementarFecha175:
L__IncrementarFecha174:
L__IncrementarFecha173:
L__IncrementarFecha172:
;tiempo_rtc.c,218 :: 		if (dia==30){
	CP	W6, #30
	CPB	W7, #0
	BRA Z	L__IncrementarFecha309
	GOTO	L_IncrementarFecha13
L__IncrementarFecha309:
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
	BRA NZ	L__IncrementarFecha310
	GOTO	L__IncrementarFecha185
L__IncrementarFecha310:
	CP	W0, #1
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha311
	GOTO	L__IncrementarFecha181
L__IncrementarFecha311:
	CP	W0, #3
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha312
	GOTO	L__IncrementarFecha180
L__IncrementarFecha312:
	CP	W0, #5
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha313
	GOTO	L__IncrementarFecha179
L__IncrementarFecha313:
	CP	W0, #7
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha314
	GOTO	L__IncrementarFecha178
L__IncrementarFecha314:
	CP	W0, #8
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha315
	GOTO	L__IncrementarFecha177
L__IncrementarFecha315:
	CP	W0, #10
	CPB	W1, #0
	BRA NZ	L__IncrementarFecha316
	GOTO	L__IncrementarFecha176
L__IncrementarFecha316:
	GOTO	L_IncrementarFecha19
L__IncrementarFecha181:
L__IncrementarFecha180:
L__IncrementarFecha179:
L__IncrementarFecha178:
L__IncrementarFecha177:
L__IncrementarFecha176:
L__IncrementarFecha169:
;tiempo_rtc.c,226 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha317
	GOTO	L_IncrementarFecha20
L__IncrementarFecha317:
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
	GOTO	L__IncrementarFecha182
L__IncrementarFecha185:
L__IncrementarFecha182:
;tiempo_rtc.c,233 :: 		if ((dia!=1)&&(mes==12)){
; dia start address is: 8 (W4)
; mes start address is: 0 (W0)
	CP	W4, #1
	CPB	W5, #0
	BRA NZ	L__IncrementarFecha318
	GOTO	L__IncrementarFecha186
L__IncrementarFecha318:
	CP	W0, #12
	CPB	W1, #0
	BRA Z	L__IncrementarFecha319
	GOTO	L__IncrementarFecha187
L__IncrementarFecha319:
L__IncrementarFecha168:
;tiempo_rtc.c,234 :: 		if (dia==31){
	CP	W4, #31
	CPB	W5, #0
	BRA Z	L__IncrementarFecha320
	GOTO	L_IncrementarFecha25
L__IncrementarFecha320:
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
	GOTO	L__IncrementarFecha184
L__IncrementarFecha186:
L__IncrementarFecha184:
; mes start address is: 0 (W0)
; anio start address is: 4 (W2)
; dia start address is: 8 (W4)
; dia end address is: 8 (W4)
; mes end address is: 0 (W0)
; anio end address is: 4 (W2)
	GOTO	L__IncrementarFecha183
L__IncrementarFecha187:
L__IncrementarFecha183:
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

;rs485.c,17 :: 		void EnviarTramaRS485(unsigned short puertoUART, unsigned short direccion, unsigned short funcion, unsigned short numDatos, unsigned char *payload){
; payload start address is: 4 (W2)
	MOV	[W14-8], W2
;rs485.c,21 :: 		if (puertoUART == 1){
	CP.B	W10, #1
	BRA Z	L__EnviarTramaRS485328
	GOTO	L__EnviarTramaRS485188
L__EnviarTramaRS485328:
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
;rs485.c,26 :: 		UART1_Write(numDatos);                                                  //Envia el numero de datos
	ZE	W13, W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,27 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 2 (W1)
	CLR	W1
; payload end address is: 4 (W2)
; iDatos end address is: 2 (W1)
L_EnviarTramaRS48532:
; iDatos start address is: 2 (W1)
; payload start address is: 4 (W2)
	ZE	W13, W0
	CP	W1, W0
	BRA LTU	L__EnviarTramaRS485329
	GOTO	L_EnviarTramaRS48533
L__EnviarTramaRS485329:
;rs485.c,28 :: 		UART1_Write(payload[iDatos]);
	ADD	W2, W1, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;rs485.c,27 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W1
;rs485.c,29 :: 		}
; iDatos end address is: 2 (W1)
	GOTO	L_EnviarTramaRS48532
L_EnviarTramaRS48533:
;rs485.c,30 :: 		UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART1_Write
;rs485.c,31 :: 		UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART1_Write
; payload end address is: 4 (W2)
	POP	W10
	MOV	W2, W1
;rs485.c,32 :: 		while(UART1_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48535:
; payload start address is: 2 (W1)
	CALL	_UART1_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485330
	GOTO	L_EnviarTramaRS48536
L__EnviarTramaRS485330:
	GOTO	L_EnviarTramaRS48535
L_EnviarTramaRS48536:
;rs485.c,33 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
; payload end address is: 2 (W1)
;rs485.c,34 :: 		}
	GOTO	L_EnviarTramaRS48531
L__EnviarTramaRS485188:
;rs485.c,21 :: 		if (puertoUART == 1){
	MOV	W2, W1
;rs485.c,34 :: 		}
L_EnviarTramaRS48531:
;rs485.c,36 :: 		if (puertoUART == 2){
; payload start address is: 2 (W1)
	CP.B	W10, #2
	BRA Z	L__EnviarTramaRS485331
	GOTO	L_EnviarTramaRS48537
L__EnviarTramaRS485331:
;rs485.c,37 :: 		MSRS485 = 1;                                                            //Establece el Max485 en modo escritura
	BSET	MSRS485, BitPos(MSRS485+0)
;rs485.c,38 :: 		UART2_Write(0x3A);                                                      //Envia la cabecera de la trama
	PUSH	W10
	MOV	#58, W10
	CALL	_UART2_Write
;rs485.c,39 :: 		UART2_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W11, W10
	CALL	_UART2_Write
;rs485.c,40 :: 		UART2_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W12, W10
	CALL	_UART2_Write
;rs485.c,41 :: 		UART2_Write(numDatos);                                                  //Envia el numero de datos
	ZE	W13, W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,42 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 4 (W2)
	CLR	W2
; iDatos end address is: 4 (W2)
L_EnviarTramaRS48538:
; iDatos start address is: 4 (W2)
; payload start address is: 2 (W1)
; payload end address is: 2 (W1)
	ZE	W13, W0
	CP	W2, W0
	BRA LTU	L__EnviarTramaRS485332
	GOTO	L_EnviarTramaRS48539
L__EnviarTramaRS485332:
; payload end address is: 2 (W1)
;rs485.c,43 :: 		UART2_Write(payload[iDatos]);
; payload start address is: 2 (W1)
	ADD	W1, W2, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,42 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W2
;rs485.c,44 :: 		}
; payload end address is: 2 (W1)
; iDatos end address is: 4 (W2)
	GOTO	L_EnviarTramaRS48538
L_EnviarTramaRS48539:
;rs485.c,45 :: 		UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART2_Write
;rs485.c,46 :: 		UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART2_Write
	POP	W10
;rs485.c,47 :: 		while(UART2_Tx_Idle()==0);                                              //Espera hasta que se haya terminado de enviar todo el dato por UART antes de continuar
L_EnviarTramaRS48541:
	CALL	_UART2_Tx_Idle
	CP	W0, #0
	BRA Z	L__EnviarTramaRS485333
	GOTO	L_EnviarTramaRS48542
L__EnviarTramaRS485333:
	GOTO	L_EnviarTramaRS48541
L_EnviarTramaRS48542:
;rs485.c,48 :: 		MSRS485 = 0;                                                            //Establece el Max485 en modo lectura
	BCLR	MSRS485, BitPos(MSRS485+0)
;rs485.c,49 :: 		}
L_EnviarTramaRS48537:
;rs485.c,51 :: 		}
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

;Master.c,102 :: 		void main() {
;Master.c,104 :: 		ConfiguracionPrincipal();
	CALL	_ConfiguracionPrincipal
;Master.c,105 :: 		DS3234_init();
	CALL	_DS3234_init
;Master.c,111 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,112 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,113 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;Master.c,114 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;Master.c,117 :: 		banSPI0 = 0;
	MOV	#lo_addr(_banSPI0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,118 :: 		banSPI1 = 0;
	MOV	#lo_addr(_banSPI1), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,119 :: 		banSPI2 = 0;
	MOV	#lo_addr(_banSPI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,120 :: 		banSPI3 = 0;
	MOV	#lo_addr(_banSPI3), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,121 :: 		banSPI4 = 0;
	MOV	#lo_addr(_banSPI4), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,122 :: 		banSPI5 = 0;
	MOV	#lo_addr(_banSPI5), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,123 :: 		banSPI6 = 0;
	MOV	#lo_addr(_banSPI6), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,124 :: 		banSPI7 = 0;
	MOV	#lo_addr(_banSPI7), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,125 :: 		banSPI8 = 0;
	MOV	#lo_addr(_banSPI8), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,126 :: 		banSPI9 = 0;
	MOV	#lo_addr(_banSPI9), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,129 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;Master.c,130 :: 		byteGPS = 0;
	MOV	#lo_addr(_byteGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,131 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,132 :: 		banTFGPS = 0;
	MOV	#lo_addr(_banTFGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,133 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,134 :: 		banSetGPS = 0;
	MOV	#lo_addr(_banSetGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,137 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,138 :: 		horaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,139 :: 		fechaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,140 :: 		fuenteReloj = 0;
	MOV	#lo_addr(_fuenteReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,141 :: 		referenciaTiempo = 0;
	MOV	#lo_addr(_referenciaTiempo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,144 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,145 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,146 :: 		byteRS485 = 0;
	MOV	#lo_addr(_byteRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,147 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,148 :: 		numDatosRS485 = 0;
	CLR	W0
	MOV	W0, _numDatosRS485
;Master.c,149 :: 		funcionRS485 = 0;
	MOV	#lo_addr(_funcionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,150 :: 		subFuncionRS485 = 0;
	MOV	#lo_addr(_subFuncionRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,153 :: 		banInicioMuestreo = 0;
	MOV	#lo_addr(_banInicioMuestreo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,156 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,157 :: 		INT_SINC = 1;                                                              //Enciende el pin TEST
	BSET	LATA1_bit, BitPos(LATA1_bit+0)
;Master.c,158 :: 		INT_SINC1 = 0;                                                             //Inicializa los pines de sincronizacion en 0
	BCLR	LATA0_bit, BitPos(LATA0_bit+0)
;Master.c,159 :: 		INT_SINC2 = 0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;Master.c,160 :: 		INT_SINC3 = 0;
	BCLR	LATB10_bit, BitPos(LATB10_bit+0)
;Master.c,161 :: 		INT_SINC4 = 0;
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,163 :: 		MSRS485 = 0;                                                               //Establece el Max485 en modo de lectura;
	BCLR	LATB11_bit, BitPos(LATB11_bit+0)
;Master.c,165 :: 		SPI1BUF = 0x00;
	CLR	SPI1BUF
;Master.c,167 :: 		while(1){
L_main43:
;Master.c,170 :: 		}
	GOTO	L_main43
;Master.c,172 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;Master.c,181 :: 		void ConfiguracionPrincipal(){
;Master.c,184 :: 		CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	CLKDIVbits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, CLKDIVbits
;Master.c,185 :: 		CLKDIVbits.PLLPOST = 0;                                                    //N2=2
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;Master.c,186 :: 		CLKDIVbits.PLLPRE = 5;                                                     //N1=7
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;Master.c,187 :: 		PLLFBDbits.PLLDIV = 150;                                                   //M=152
	MOV	#150, W0
	MOV	W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	#511, W0
	AND	W1, W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	W1, PLLFBDbits
;Master.c,190 :: 		ANSELA = 0;                                                                //Configura PORTA como digital     *
	CLR	ANSELA
;Master.c,191 :: 		ANSELB = 0;                                                                //Configura PORTB como digital     *
	CLR	ANSELB
;Master.c,193 :: 		TRISA2_bit = 0;                                                            //RTC_CS
	BCLR	TRISA2_bit, BitPos(TRISA2_bit+0)
;Master.c,194 :: 		INT_SINC_Direction = 0;                                                    //INT_SINC
	BCLR	TRISA1_bit, BitPos(TRISA1_bit+0)
;Master.c,195 :: 		INT_SINC1_Direction = 0;                                                   //INT_SINC1
	BCLR	TRISA0_bit, BitPos(TRISA0_bit+0)
;Master.c,196 :: 		INT_SINC2_Direction = 0;                                                   //INT_SINC2
	BCLR	TRISA3_bit, BitPos(TRISA3_bit+0)
;Master.c,197 :: 		INT_SINC3_Direction = 0;                                                   //INT_SINC3
	BCLR	TRISB10_bit, BitPos(TRISB10_bit+0)
;Master.c,198 :: 		INT_SINC4_Direction = 0;                                                   //INT_SINC4
	BCLR	TRISB12_bit, BitPos(TRISB12_bit+0)
;Master.c,199 :: 		RP1_Direction = 0;                                                         //RP1
	BCLR	TRISA4_bit, BitPos(TRISA4_bit+0)
;Master.c,200 :: 		MSRS485_Direction = 0;                                                     //MSRS485
	BCLR	TRISB11_bit, BitPos(TRISB11_bit+0)
;Master.c,202 :: 		TRISB13_bit = 1;                                                           //SQW
	BSET	TRISB13_bit, BitPos(TRISB13_bit+0)
;Master.c,203 :: 		TRISB14_bit = 1;                                                           //PPS
	BSET	TRISB14_bit, BitPos(TRISB14_bit+0)
;Master.c,205 :: 		INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales *
	BSET	INTCON2, #15
;Master.c,208 :: 		RPINR18bits.U1RXR = 0x22;                                                  //Configura el pin RB2/RPI34 como Rx1
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
;Master.c,209 :: 		RPOR0bits.RP35R = 0x01;                                                    //Configura el Tx1 en el pin RB3/RP35
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR0bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR0bits
;Master.c,210 :: 		U1RXIE_bit = 0;                                                            //Habilita la interrupcion UART1 RX
	BCLR	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Master.c,211 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;Master.c,212 :: 		IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#16384, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;Master.c,213 :: 		U1STAbits.URXISEL = 0x00;                                                  //Interrupt is set when any character is received and transferred from the UxRSR to the receive buffer; receive buffer has one or more characters
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;Master.c,214 :: 		UART1_Init(9600);                                                          //Inicializa el UART1 con una velocidad de 9600 baudios
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;Master.c,217 :: 		RPINR19bits.U2RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx2
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
;Master.c,218 :: 		RPOR1bits.RP36R = 0x03;                                                    //Configura el Tx2 en el pin RB4/RP36
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
;Master.c,219 :: 		U2RXIE_bit = 1;                                                            //Habilita la interrupcion UART2 RX
	BSET	U2RXIE_bit, BitPos(U2RXIE_bit+0)
;Master.c,220 :: 		U2STAbits.URXISEL = 0x00;
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	W1, [W0]
;Master.c,221 :: 		IPC7bits.U2RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#1024, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC7bits
;Master.c,222 :: 		U2STAbits.URXISEL = 0x00;
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	W1, [W0]
;Master.c,223 :: 		UART2_Init_Advanced(2000000, _UART_8BIT_NOPARITY, _UART_ONE_STOPBIT, _UART_HI_SPEED);
	CLR	W13
	CLR	W12
	MOV	#33920, W10
	MOV	#30, W11
	MOV	#1, W0
	PUSH	W0
	CALL	_UART2_Init_Advanced
	SUB	#2, W15
;Master.c,226 :: 		SPI1STAT.SPIEN = 1;                                                        //Habilita el SPI1 *
	BSET	SPI1STAT, #15
;Master.c,227 :: 		SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);
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
;Master.c,228 :: 		SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Master.c,229 :: 		IPC2bits.SPI1IP = 0x03;                                                    //Prioridad de la interrupcion SPI1
	MOV	#768, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;Master.c,232 :: 		RPINR22bits.SDI2R = 0x21;                                                  //Configura el pin RB1/RPI33 como SDI2 *
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
;Master.c,233 :: 		RPOR2bits.RP38R = 0x08;                                                    //Configura el SDO2 en el pin RB6/RP38 *
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
;Master.c,234 :: 		RPOR1bits.RP37R = 0x09;                                                    //Configura el SCK2 en el pin RB5/RP37 *
	MOV	#2304, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR1bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR1bits
;Master.c,235 :: 		SPI2STAT.SPIEN = 1;                                                        //Habilita el SPI2 *
	BSET	SPI2STAT, #15
;Master.c,236 :: 		SPI2_Init();                                                               //Inicializa el modulo SPI2
	CALL	_SPI2_Init
;Master.c,237 :: 		CS_DS3234 = 1;                                                             //Pone en alto el CS del RTC
	BSET	LATA2_bit, BitPos(LATA2_bit+0)
;Master.c,240 :: 		RPINR0 = 0x2D00;                                                           //Asigna INT1 al RB13/RPI45 (SQW)
	MOV	#11520, W0
	MOV	WREG, RPINR0
;Master.c,242 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;Master.c,243 :: 		IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;Master.c,246 :: 		SPI1IE_bit = 1;                                                            //SPI1
	BSET	SPI1IE_bit, BitPos(SPI1IE_bit+0)
;Master.c,247 :: 		INT1IE_bit = 0;                                                            //INT1
	BCLR	INT1IE_bit, BitPos(INT1IE_bit+0)
;Master.c,249 :: 		Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#25, W8
	MOV	#27150, W7
L_ConfiguracionPrincipal45:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal45
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal45
	NOP
;Master.c,251 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_InterrupcionP1:

;Master.c,256 :: 		void InterrupcionP1(unsigned short funcionSPI, unsigned short subFuncionSPI, unsigned int numBytesSPI){
;Master.c,259 :: 		if ((funcionSPI==0xB1)&&(subFuncionSPI==0xD1)){
	PUSH	W13
	MOV.B	#177, W0
	CP.B	W10, W0
	BRA Z	L__InterrupcionP1338
	GOTO	L__InterrupcionP1191
L__InterrupcionP1338:
	MOV.B	#209, W0
	CP.B	W11, W0
	BRA Z	L__InterrupcionP1339
	GOTO	L__InterrupcionP1190
L__InterrupcionP1339:
L__InterrupcionP1189:
;Master.c,260 :: 		if (INT1IE_bit==0){
	BTSC	INT1IE_bit, BitPos(INT1IE_bit+0)
	GOTO	L_InterrupcionP150
;Master.c,261 :: 		INT1IE_bit = 1;
	BSET	INT1IE_bit, BitPos(INT1IE_bit+0)
;Master.c,262 :: 		}
L_InterrupcionP150:
;Master.c,264 :: 		outputPyloadRS485[0] = 0xD1;
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#209, W0
	MOV.B	W0, [W1]
;Master.c,265 :: 		for (x=1;x<7;x++){
	MOV	#1, W0
	MOV	W0, _x
L_InterrupcionP151:
	MOV	_x, W0
	CP	W0, #7
	BRA LTU	L__InterrupcionP1340
	GOTO	L_InterrupcionP152
L__InterrupcionP1340:
;Master.c,266 :: 		outputPyloadRS485[x] = tiempo[x-1];
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	SUB	W0, #1, W1
	MOV	#lo_addr(_tiempo), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Master.c,265 :: 		for (x=1;x<7;x++){
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;Master.c,267 :: 		}
	GOTO	L_InterrupcionP151
L_InterrupcionP152:
;Master.c,268 :: 		EnviarTramaRS485(2, 255, 0xF1, 7, outputPyloadRS485);                   //Envia la hora local a los nodos
	PUSH	W12
	PUSH.D	W10
	MOV.B	#7, W13
	MOV.B	#241, W12
	MOV.B	#255, W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
	POP.D	W10
	POP	W12
;Master.c,259 :: 		if ((funcionSPI==0xB1)&&(subFuncionSPI==0xD1)){
L__InterrupcionP1191:
L__InterrupcionP1190:
;Master.c,272 :: 		ptrnumBytesSPI = (unsigned char *) & numBytesSPI;
	MOV	#lo_addr(W12), W2
	MOV	W2, _ptrnumBytesSPI
;Master.c,275 :: 		tramaSolicitudSPI[0] = funcionSPI;                                         //Operacion solicitada
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV.B	W10, [W0]
;Master.c,276 :: 		tramaSolicitudSPI[1] = subFuncionSPI;                                      //Subfuncion solicitada
	MOV	#lo_addr(_tramaSolicitudSPI+1), W0
	MOV.B	W11, [W0]
;Master.c,277 :: 		tramaSolicitudSPI[2] = *(ptrnumBytesSPI);                                  //LSB numBytesSPI
	MOV.B	[W2], W1
	MOV	#lo_addr(_tramaSolicitudSPI+2), W0
	MOV.B	W1, [W0]
;Master.c,278 :: 		tramaSolicitudSPI[3] = *(ptrnumBytesSPI+1);                                //MSB numBytesSPI
	ADD	W2, #1, W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_tramaSolicitudSPI+3), W0
	MOV.B	W1, [W0]
;Master.c,281 :: 		RP1 = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,282 :: 		Delay_us(20);
	MOV	#160, W7
L_InterrupcionP154:
	DEC	W7
	BRA NZ	L_InterrupcionP154
	NOP
	NOP
;Master.c,283 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,285 :: 		}
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

;Master.c,295 :: 		void spi_1() org  IVT_ADDR_SPI1INTERRUPT {
;Master.c,297 :: 		SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Master.c,298 :: 		bufferSPI = SPI1BUF;                                                       //Guarda el contenido del bufeer (lectura)
	MOV	#lo_addr(_bufferSPI), W1
	MOV.B	SPI1BUF, WREG
	MOV.B	W0, [W1]
;Master.c,302 :: 		if ((banSPI0==0)&&(bufferSPI==0xA0)) {
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1342
	GOTO	L__spi_1221
L__spi_1342:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#160, W0
	CP.B	W1, W0
	BRA Z	L__spi_1343
	GOTO	L__spi_1220
L__spi_1343:
L__spi_1219:
;Master.c,303 :: 		banSPI0 = 1;                                                            //Activa la bandera para enviar el tipo de operacion requerido a la RPi
	MOV	#lo_addr(_banSPI0), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,304 :: 		i = 1;
	MOV	#1, W0
	MOV	W0, _i
;Master.c,305 :: 		SPI1BUF = tramaSolicitudSPI[0];                                         //Carga en el buffer la funcion requerida
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Master.c,302 :: 		if ((banSPI0==0)&&(bufferSPI==0xA0)) {
L__spi_1221:
L__spi_1220:
;Master.c,307 :: 		if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1344
	GOTO	L__spi_1224
L__spi_1344:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#160, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1345
	GOTO	L__spi_1223
L__spi_1345:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#240, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1346
	GOTO	L__spi_1222
L__spi_1346:
L__spi_1218:
;Master.c,308 :: 		SPI1BUF = tramaSolicitudSPI[i];                                         //Se envia la subfuncion, y el LSB y MSB de la variable numBytesSPI
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,309 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,307 :: 		if ((banSPI0==1)&&(bufferSPI!=0xA0)&&(bufferSPI!=0xF0)){
L__spi_1224:
L__spi_1223:
L__spi_1222:
;Master.c,311 :: 		if ((banSPI0==1)&&(bufferSPI==0xF0)){
	MOV	#lo_addr(_banSPI0), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1347
	GOTO	L__spi_1226
L__spi_1347:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#240, W0
	CP.B	W1, W0
	BRA Z	L__spi_1348
	GOTO	L__spi_1225
L__spi_1348:
L__spi_1217:
;Master.c,312 :: 		banSPI0 = 0;                                                            //Limpia la bandera
	MOV	#lo_addr(_banSPI0), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,311 :: 		if ((banSPI0==1)&&(bufferSPI==0xF0)){
L__spi_1226:
L__spi_1225:
;Master.c,320 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)){
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1349
	GOTO	L__spi_1228
L__spi_1349:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#161, W0
	CP.B	W1, W0
	BRA Z	L__spi_1350
	GOTO	L__spi_1227
L__spi_1350:
L__spi_1216:
;Master.c,321 :: 		banSPI1 = 1;
	MOV	#lo_addr(_banSPI1), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,322 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,320 :: 		if ((banSPI1==0)&&(bufferSPI==0xA1)){
L__spi_1228:
L__spi_1227:
;Master.c,324 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1351
	GOTO	L__spi_1231
L__spi_1351:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#161, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1352
	GOTO	L__spi_1230
L__spi_1352:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1353
	GOTO	L__spi_1229
L__spi_1353:
L__spi_1215:
;Master.c,325 :: 		tramaSolicitudSPI[i] = bufferSPI;                                       //Recupera la direccion del nodo y el indicador de sobrescritura de la SD
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,326 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,324 :: 		if ((banSPI1==1)&&(bufferSPI!=0xA1)&&(bufferSPI!=0xF1)){
L__spi_1231:
L__spi_1230:
L__spi_1229:
;Master.c,328 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
	MOV	#lo_addr(_banSPI1), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1354
	GOTO	L__spi_1233
L__spi_1354:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA Z	L__spi_1355
	GOTO	L__spi_1232
L__spi_1355:
L__spi_1214:
;Master.c,329 :: 		direccionRS485 = tramaSolicitudSPI[0];
	MOV	#lo_addr(_direccionRS485), W1
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV.B	[W0], [W1]
;Master.c,330 :: 		outputPyloadRS485[0] = 0xD1;                                            //Subfuncion iniciar muestreo
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#209, W0
	MOV.B	W0, [W1]
;Master.c,331 :: 		outputPyloadRS485[1] = tramaSolicitudSPI[1];                            //Payload sobrescribir SD
	MOV	#lo_addr(_outputPyloadRS485+1), W1
	MOV	#lo_addr(_tramaSolicitudSPI+1), W0
	MOV.B	[W0], [W1]
;Master.c,332 :: 		EnviarTramaRS485(2, direccionRS485, 0xF2, 2, outputPyloadRS485);        //Envia la solicitud al nodo
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV.B	#2, W13
	MOV.B	#242, W12
	MOV.B	[W0], W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;Master.c,333 :: 		banSPI1 = 0;
	MOV	#lo_addr(_banSPI1), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,328 :: 		if ((banSPI1==1)&&(bufferSPI==0xF1)){
L__spi_1233:
L__spi_1232:
;Master.c,337 :: 		if ((banSPI2==0)&&(bufferSPI==0xA2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1356
	GOTO	L__spi_1235
L__spi_1356:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#162, W0
	CP.B	W1, W0
	BRA Z	L__spi_1357
	GOTO	L__spi_1234
L__spi_1357:
L__spi_1213:
;Master.c,338 :: 		banSPI2 = 1;
	MOV	#lo_addr(_banSPI2), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,339 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,337 :: 		if ((banSPI2==0)&&(bufferSPI==0xA2)){
L__spi_1235:
L__spi_1234:
;Master.c,341 :: 		if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1358
	GOTO	L__spi_1238
L__spi_1358:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#162, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1359
	GOTO	L__spi_1237
L__spi_1359:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1360
	GOTO	L__spi_1236
L__spi_1360:
L__spi_1212:
;Master.c,342 :: 		tramaSolicitudSPI[i] = bufferSPI;                                       //Recupera la direccion del nodo
	MOV	#lo_addr(_tramaSolicitudSPI), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,341 :: 		if ((banSPI2==1)&&(bufferSPI!=0xA2)&&(bufferSPI!=0xF2)){
L__spi_1238:
L__spi_1237:
L__spi_1236:
;Master.c,344 :: 		if ((banSPI2==1)&&(bufferSPI==0xF2)){
	MOV	#lo_addr(_banSPI2), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1361
	GOTO	L__spi_1240
L__spi_1361:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA Z	L__spi_1362
	GOTO	L__spi_1239
L__spi_1362:
L__spi_1211:
;Master.c,345 :: 		direccionRS485 = tramaSolicitudSPI[0];
	MOV	#lo_addr(_direccionRS485), W1
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV.B	[W0], [W1]
;Master.c,346 :: 		outputPyloadRS485[0] = 0xD2;                                            //Subfuncion detener muestreo
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;Master.c,347 :: 		EnviarTramaRS485(2, direccionRS485, 0xF2, 1, outputPyloadRS485);        //Envia la solicitud al nodo
	MOV	#lo_addr(_tramaSolicitudSPI), W0
	MOV.B	#1, W13
	MOV.B	#242, W12
	MOV.B	[W0], W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;Master.c,348 :: 		banSPI2 = 0;
	MOV	#lo_addr(_banSPI2), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,344 :: 		if ((banSPI2==1)&&(bufferSPI==0xF2)){
L__spi_1240:
L__spi_1239:
;Master.c,352 :: 		if ((banLec==1)&&(bufferSPI==0xA3)){                                       //Verifica si la bandera de inicio de trama esta activa
	MOV	#lo_addr(_banLec), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1363
	GOTO	L__spi_1242
L__spi_1363:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#163, W0
	CP.B	W1, W0
	BRA Z	L__spi_1364
	GOTO	L__spi_1241
L__spi_1364:
L__spi_1210:
;Master.c,353 :: 		banLec = 2;                                                             //Activa la bandera de lectura
	MOV	#lo_addr(_banLec), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,354 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,355 :: 		SPI1BUF = tramaCompleta[i];                                             //**Aqui envio a la RPi la trama de aceleracion recuperada de los nodos
	MOV	#lo_addr(_tramaCompleta), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,352 :: 		if ((banLec==1)&&(bufferSPI==0xA3)){                                       //Verifica si la bandera de inicio de trama esta activa
L__spi_1242:
L__spi_1241:
;Master.c,357 :: 		if ((banLec==2)&&(bufferSPI!=0xF3)){
	MOV	#lo_addr(_banLec), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__spi_1365
	GOTO	L__spi_1244
L__spi_1365:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1366
	GOTO	L__spi_1243
L__spi_1366:
L__spi_1209:
;Master.c,358 :: 		SPI1BUF = tramaCompleta[i];
	MOV	#lo_addr(_tramaCompleta), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,359 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,357 :: 		if ((banLec==2)&&(bufferSPI!=0xF3)){
L__spi_1244:
L__spi_1243:
;Master.c,361 :: 		if ((banLec==2)&&(bufferSPI==0xF3)){                                       //Si detecta el delimitador de final de trama:
	MOV	#lo_addr(_banLec), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__spi_1367
	GOTO	L__spi_1246
L__spi_1367:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA Z	L__spi_1368
	GOTO	L__spi_1245
L__spi_1368:
L__spi_1208:
;Master.c,362 :: 		banLec = 0;                                                             //Limpia la bandera de lectura
	MOV	#lo_addr(_banLec), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,363 :: 		SPI1BUF = 0xFF;
	MOV	#255, W0
	MOV	WREG, SPI1BUF
;Master.c,361 :: 		if ((banLec==2)&&(bufferSPI==0xF3)){                                       //Si detecta el delimitador de final de trama:
L__spi_1246:
L__spi_1245:
;Master.c,372 :: 		if ((banSetReloj==0)&&(bufferSPI==0xA4)){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1369
	GOTO	L__spi_1248
L__spi_1369:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#164, W0
	CP.B	W1, W0
	BRA Z	L__spi_1370
	GOTO	L__spi_1247
L__spi_1370:
L__spi_1207:
;Master.c,373 :: 		banSPI4 = 1;
	MOV	#lo_addr(_banSPI4), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,374 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,372 :: 		if ((banSetReloj==0)&&(bufferSPI==0xA4)){
L__spi_1248:
L__spi_1247:
;Master.c,376 :: 		if ((banSPI4==1)&&(bufferSPI!=0xA4)&&(bufferSPI!=0xF4)){
	MOV	#lo_addr(_banSPI4), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1371
	GOTO	L__spi_1251
L__spi_1371:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#164, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1372
	GOTO	L__spi_1250
L__spi_1372:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#244, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1373
	GOTO	L__spi_1249
L__spi_1373:
L__spi_1206:
;Master.c,377 :: 		tiempoRPI[j] = bufferSPI;
	MOV	#lo_addr(_tiempoRPI), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,378 :: 		j++;
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;Master.c,376 :: 		if ((banSPI4==1)&&(bufferSPI!=0xA4)&&(bufferSPI!=0xF4)){
L__spi_1251:
L__spi_1250:
L__spi_1249:
;Master.c,380 :: 		if ((banSPI4==1)&&(bufferSPI==0xF4)){
	MOV	#lo_addr(_banSPI4), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1374
	GOTO	L__spi_1253
L__spi_1374:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#244, W0
	CP.B	W1, W0
	BRA Z	L__spi_1375
	GOTO	L__spi_1252
L__spi_1375:
L__spi_1205:
;Master.c,381 :: 		horaSistema = RecuperarHoraRPI(tiempoRPI);                              //Recupera la hora de la RPi
	MOV	#lo_addr(_tiempoRPI), W10
	CALL	_RecuperarHoraRPI
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,382 :: 		fechaSistema = RecuperarFechaRPI(tiempoRPI);                            //Recupera la fecha de la RPi
	MOV	#lo_addr(_tiempoRPI), W10
	CALL	_RecuperarFechaRPI
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,387 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,388 :: 		banSPI4 = 0;
	MOV	#lo_addr(_banSPI4), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,389 :: 		banSetReloj = 1;                                                        //Activa la bandera para utilizar el tiempo
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,390 :: 		InterrupcionP1(0xB1,0xD1,6);                                            //Envia la hora local a la RPi y a los nodos
	MOV	#6, W12
	MOV.B	#209, W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,380 :: 		if ((banSPI4==1)&&(bufferSPI==0xF4)){
L__spi_1253:
L__spi_1252:
;Master.c,395 :: 		if ((banSetReloj==1)&&(bufferSPI==0xA5)){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1376
	GOTO	L__spi_1255
L__spi_1376:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#165, W0
	CP.B	W1, W0
	BRA Z	L__spi_1377
	GOTO	L__spi_1254
L__spi_1377:
L__spi_1204:
;Master.c,396 :: 		banSPI5 = 1;
	MOV	#lo_addr(_banSPI5), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,397 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,398 :: 		SPI1BUF = fuenteReloj;                                                  //Envia el indicador de fuente de reloj (0:RTC, 1:GPS)
	MOV	#lo_addr(_fuenteReloj), W0
	ZE	[W0], W0
	MOV	WREG, SPI1BUF
;Master.c,395 :: 		if ((banSetReloj==1)&&(bufferSPI==0xA5)){
L__spi_1255:
L__spi_1254:
;Master.c,400 :: 		if ((banSPI5==1)&&(bufferSPI!=0xA5)&&(bufferSPI!=0xF5)){
	MOV	#lo_addr(_banSPI5), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1378
	GOTO	L__spi_1258
L__spi_1378:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#165, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1379
	GOTO	L__spi_1257
L__spi_1379:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#245, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1380
	GOTO	L__spi_1256
L__spi_1380:
L__spi_1203:
;Master.c,401 :: 		SPI1BUF = tiempo[j];
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,402 :: 		j++;
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;Master.c,400 :: 		if ((banSPI5==1)&&(bufferSPI!=0xA5)&&(bufferSPI!=0xF5)){
L__spi_1258:
L__spi_1257:
L__spi_1256:
;Master.c,404 :: 		if ((banSPI5==1)&&(bufferSPI==0xF5)){
	MOV	#lo_addr(_banSPI5), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1381
	GOTO	L__spi_1260
L__spi_1381:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#245, W0
	CP.B	W1, W0
	BRA Z	L__spi_1382
	GOTO	L__spi_1259
L__spi_1382:
L__spi_1202:
;Master.c,405 :: 		banSPI5 = 0;
	MOV	#lo_addr(_banSPI5), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,406 :: 		banSetReloj = 0;                                                        //Limpia la bandera de lectura
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,404 :: 		if ((banSPI5==1)&&(bufferSPI==0xF5)){
L__spi_1260:
L__spi_1259:
;Master.c,411 :: 		if ((banSetReloj==0)&&(bufferSPI==0xA6)){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1383
	GOTO	L__spi_1262
L__spi_1383:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#166, W0
	CP.B	W1, W0
	BRA Z	L__spi_1384
	GOTO	L__spi_1261
L__spi_1384:
L__spi_1201:
;Master.c,412 :: 		banSPI6 = 1;
	MOV	#lo_addr(_banSPI6), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,411 :: 		if ((banSetReloj==0)&&(bufferSPI==0xA6)){
L__spi_1262:
L__spi_1261:
;Master.c,414 :: 		if ((banSPI6==1)&&(bufferSPI!=0xA6)&&(bufferSPI!=0xF6)){
	MOV	#lo_addr(_banSPI6), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1385
	GOTO	L__spi_1265
L__spi_1385:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#166, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1386
	GOTO	L__spi_1264
L__spi_1386:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#246, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1387
	GOTO	L__spi_1263
L__spi_1387:
L__spi_1200:
;Master.c,415 :: 		referenciaTiempo =  bufferSPI;                                          //Recupera la opcion de referencia de tiempo solicitada
	MOV	#lo_addr(_referenciaTiempo), W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,414 :: 		if ((banSPI6==1)&&(bufferSPI!=0xA6)&&(bufferSPI!=0xF6)){
L__spi_1265:
L__spi_1264:
L__spi_1263:
;Master.c,417 :: 		if ((banSPI6==1)&&(bufferSPI==0xF6)){
	MOV	#lo_addr(_banSPI6), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1388
	GOTO	L__spi_1267
L__spi_1388:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#246, W0
	CP.B	W1, W0
	BRA Z	L__spi_1389
	GOTO	L__spi_1266
L__spi_1389:
L__spi_1199:
;Master.c,418 :: 		banSPI6 = 0;
	MOV	#lo_addr(_banSPI6), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,419 :: 		if (referenciaTiempo==1){
	MOV	#lo_addr(_referenciaTiempo), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1390
	GOTO	L_spi_1119
L__spi_1390:
;Master.c,421 :: 		banTIGPS = 0;                                                   //Limpia la bandera de inicio de trama  del GPS
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,422 :: 		banTCGPS = 0;                                                   //Limpia la bandera de trama completa
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,423 :: 		i_gps = 0;                                                      //Limpia el subindice de la trama GPS
	CLR	W0
	MOV	W0, _i_gps
;Master.c,425 :: 		if (U1RXIE_bit==0){
	BTSC	U1RXIE_bit, BitPos(U1RXIE_bit+0)
	GOTO	L_spi_1120
;Master.c,426 :: 		U1RXIE_bit = 1;
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Master.c,427 :: 		}
L_spi_1120:
;Master.c,428 :: 		} else {
	GOTO	L_spi_1121
L_spi_1119:
;Master.c,430 :: 		horaSistema = RecuperarHoraRTC();                               //Recupera la hora del RTC
	CALL	_RecuperarHoraRTC
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,431 :: 		fechaSistema = RecuperarFechaRTC();                             //Recupera la fecha del RTC
	CALL	_RecuperarFechaRTC
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,432 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);        //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,433 :: 		fuenteReloj = 0;                                                //**Hay que corregir esto en todo
	MOV	#lo_addr(_fuenteReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,434 :: 		banSetReloj = 1;
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,435 :: 		InterrupcionP1(0xB1,0xD1,6);                                    //Envia la hora local a la RPi
	MOV	#6, W12
	MOV.B	#209, W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,436 :: 		}
L_spi_1121:
;Master.c,417 :: 		if ((banSPI6==1)&&(bufferSPI==0xF6)){
L__spi_1267:
L__spi_1266:
;Master.c,441 :: 		if ((banSetReloj==0)&&(bufferSPI==0xA7)){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1391
	GOTO	L__spi_1269
L__spi_1391:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#167, W0
	CP.B	W1, W0
	BRA Z	L__spi_1392
	GOTO	L__spi_1268
L__spi_1392:
L__spi_1198:
;Master.c,442 :: 		banSPI7 = 1;
	MOV	#lo_addr(_banSPI7), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,441 :: 		if ((banSetReloj==0)&&(bufferSPI==0xA7)){
L__spi_1269:
L__spi_1268:
;Master.c,444 :: 		if ((banSPI7==1)&&(bufferSPI!=0xA7)&&(bufferSPI!=0xF7)){
	MOV	#lo_addr(_banSPI7), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1393
	GOTO	L__spi_1272
L__spi_1393:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#167, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1394
	GOTO	L__spi_1271
L__spi_1394:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#247, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1395
	GOTO	L__spi_1270
L__spi_1395:
L__spi_1197:
;Master.c,445 :: 		direccionRS485 =  bufferSPI;                                            //Recupera la direccion del nodo solicitado
	MOV	#lo_addr(_direccionRS485), W1
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], [W1]
;Master.c,444 :: 		if ((banSPI7==1)&&(bufferSPI!=0xA7)&&(bufferSPI!=0xF7)){
L__spi_1272:
L__spi_1271:
L__spi_1270:
;Master.c,447 :: 		if ((banSPI7==1)&&(bufferSPI==0xF7)){
	MOV	#lo_addr(_banSPI7), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1396
	GOTO	L__spi_1274
L__spi_1396:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#247, W0
	CP.B	W1, W0
	BRA Z	L__spi_1397
	GOTO	L__spi_1273
L__spi_1397:
L__spi_1196:
;Master.c,448 :: 		outputPyloadRS485[0] = 0xD2;                                            //Llena el pyload de salidad con la subfuncion solicitada
	MOV	#lo_addr(_outputPyloadRS485), W1
	MOV.B	#210, W0
	MOV.B	W0, [W1]
;Master.c,449 :: 		EnviarTramaRS485(2, direccionRS485, 0xF1, 1, outputPyloadRS485);        //Envia la solicitud al nodo
	MOV	#lo_addr(_direccionRS485), W0
	MOV.B	#1, W13
	MOV.B	#241, W12
	MOV.B	[W0], W11
	MOV.B	#2, W10
	MOV	#lo_addr(_outputPyloadRS485), W0
	PUSH	W0
	CALL	_EnviarTramaRS485
	SUB	#2, W15
;Master.c,447 :: 		if ((banSPI7==1)&&(bufferSPI==0xF7)){
L__spi_1274:
L__spi_1273:
;Master.c,458 :: 		if ((banCheckRS485==0)&&(bufferSPI==0xA8)){
	MOV	#lo_addr(_banCheckRS485), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1398
	GOTO	L__spi_1276
L__spi_1398:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#168, W0
	CP.B	W1, W0
	BRA Z	L__spi_1399
	GOTO	L__spi_1275
L__spi_1399:
L__spi_1195:
;Master.c,460 :: 		banCheckRS485 = 1;
	MOV	#lo_addr(_banCheckRS485), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,458 :: 		if ((banCheckRS485==0)&&(bufferSPI==0xA8)){
L__spi_1276:
L__spi_1275:
;Master.c,468 :: 		if ((banCheckRS485==1)&&(bufferSPI==0xA9)){
	MOV	#lo_addr(_banCheckRS485), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1400
	GOTO	L__spi_1278
L__spi_1400:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#169, W0
	CP.B	W1, W0
	BRA Z	L__spi_1401
	GOTO	L__spi_1277
L__spi_1401:
L__spi_1194:
;Master.c,469 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,470 :: 		SPI1BUF = tramaPrueba[j];
	MOV	#lo_addr(_tramaPrueba), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,471 :: 		j++;
	MOV	#1, W0
	MOV	W0, _j
;Master.c,468 :: 		if ((banCheckRS485==1)&&(bufferSPI==0xA9)){
L__spi_1278:
L__spi_1277:
;Master.c,473 :: 		if ((banCheckRS485==1)&&(bufferSPI!=0xA9)&&(bufferSPI!=0xF9)){
	MOV	#lo_addr(_banCheckRS485), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1402
	GOTO	L__spi_1281
L__spi_1402:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#169, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1403
	GOTO	L__spi_1280
L__spi_1403:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#249, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1404
	GOTO	L__spi_1279
L__spi_1404:
L__spi_1193:
;Master.c,474 :: 		SPI1BUF = tramaPrueba[j];
	MOV	#lo_addr(_tramaPrueba), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,475 :: 		j++;
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;Master.c,473 :: 		if ((banCheckRS485==1)&&(bufferSPI!=0xA9)&&(bufferSPI!=0xF9)){
L__spi_1281:
L__spi_1280:
L__spi_1279:
;Master.c,477 :: 		if ((banCheckRS485==1)&&(bufferSPI==0xF9)){
	MOV	#lo_addr(_banCheckRS485), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1405
	GOTO	L__spi_1283
L__spi_1405:
	MOV	#lo_addr(_bufferSPI), W0
	MOV.B	[W0], W1
	MOV.B	#249, W0
	CP.B	W1, W0
	BRA Z	L__spi_1406
	GOTO	L__spi_1282
L__spi_1406:
L__spi_1192:
;Master.c,478 :: 		banCheckRS485 = 0;
	MOV	#lo_addr(_banCheckRS485), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,477 :: 		if ((banCheckRS485==1)&&(bufferSPI==0xF9)){
L__spi_1283:
L__spi_1282:
;Master.c,487 :: 		}
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

;Master.c,492 :: 		void int_1() org IVT_ADDR_INT1INTERRUPT {
;Master.c,494 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;Master.c,496 :: 		horaSistema++;                                                             //Incrementa el reloj del sistema
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaSistema), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;Master.c,497 :: 		INT_SINC = ~INT_SINC;                                                      //TEST
	BTG	LATA1_bit, BitPos(LATA1_bit+0)
;Master.c,501 :: 		INT_SINC1 = 1;
	BSET	LATA0_bit, BitPos(LATA0_bit+0)
;Master.c,502 :: 		INT_SINC2 = 1;
	BSET	LATA3_bit, BitPos(LATA3_bit+0)
;Master.c,503 :: 		INT_SINC3 = 1;
	BSET	LATB10_bit, BitPos(LATB10_bit+0)
;Master.c,504 :: 		INT_SINC4 = 1;
	BSET	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,505 :: 		Delay_us(20);
	MOV	#160, W7
L_int_1143:
	DEC	W7
	BRA NZ	L_int_1143
	NOP
	NOP
;Master.c,507 :: 		INT_SINC1 = 0;
	BCLR	LATA0_bit, BitPos(LATA0_bit+0)
;Master.c,508 :: 		INT_SINC2 = 0;
	BCLR	LATA3_bit, BitPos(LATA3_bit+0)
;Master.c,509 :: 		INT_SINC3 = 0;
	BCLR	LATB10_bit, BitPos(LATB10_bit+0)
;Master.c,510 :: 		INT_SINC4 = 0;
	BCLR	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,512 :: 		if (horaSistema==86400){                                                   //(24*3600)+(0*60)+(0) = 86400
	MOV	_horaSistema, W2
	MOV	_horaSistema+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__int_1408
	GOTO	L_int_1145
L__int_1408:
;Master.c,513 :: 		horaSistema = 0;                                                        //Reinicia el reloj al llegar a las 24:00:00 horas
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,514 :: 		}
L_int_1145:
;Master.c,515 :: 		if (banInicio==1){
	MOV	#lo_addr(_banInicio), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1409
	GOTO	L_int_1146
L__int_1409:
;Master.c,518 :: 		}
L_int_1146:
;Master.c,520 :: 		}
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

;Master.c,607 :: 		void urx_2() org  IVT_ADDR_U2RXINTERRUPT {
;Master.c,610 :: 		U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART2
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BCLR	U2RXIF_bit, BitPos(U2RXIF_bit+0)
;Master.c,611 :: 		byteRS485 = U2RXREG;                                                       //Lee el byte de la trama enviada por el nodo
	MOV	#lo_addr(_byteRS485), W1
	MOV.B	U2RXREG, WREG
	MOV.B	W0, [W1]
;Master.c,612 :: 		U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART2
	BCLR	U2STA, #1
;Master.c,615 :: 		if (banRSI==2){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__urx_2411
	GOTO	L_urx_2147
L__urx_2411:
;Master.c,616 :: 		if (i_rs485<numDatosRS485){
	MOV	_i_rs485, W1
	MOV	#lo_addr(_numDatosRS485), W0
	CP	W1, [W0]
	BRA LTU	L__urx_2412
	GOTO	L_urx_2148
L__urx_2412:
;Master.c,617 :: 		inputPyloadRS485[i_rs485] = byteRS485;
	MOV	#lo_addr(_inputPyloadRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;Master.c,618 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;Master.c,619 :: 		} else {
	GOTO	L_urx_2149
L_urx_2148:
;Master.c,620 :: 		banRSI = 0;                                                          //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,621 :: 		banRSC = 1;                                                          //Activa la bandera de trama completa
	MOV	#lo_addr(_banRSC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,622 :: 		}
L_urx_2149:
;Master.c,623 :: 		}
L_urx_2147:
;Master.c,626 :: 		if ((banRSI==0)&&(banRSC==0)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_2413
	GOTO	L__urx_2288
L__urx_2413:
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_2414
	GOTO	L__urx_2287
L__urx_2414:
L__urx_2286:
;Master.c,627 :: 		if (byteRS485==0x3A){                                                   //Verifica si el primer byte recibido sea la cabecera de trama
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__urx_2415
	GOTO	L_urx_2153
L__urx_2415:
;Master.c,628 :: 		banRSI = 1;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,629 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,630 :: 		}
L_urx_2153:
;Master.c,626 :: 		if ((banRSI==0)&&(banRSC==0)){
L__urx_2288:
L__urx_2287:
;Master.c,632 :: 		if ((banRSI==1)&&(i_rs485<4)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2416
	GOTO	L__urx_2290
L__urx_2416:
	MOV	_i_rs485, W0
	CP	W0, #4
	BRA LTU	L__urx_2417
	GOTO	L__urx_2289
L__urx_2417:
L__urx_2285:
;Master.c,633 :: 		tramaCabeceraRS485[i_rs485] = byteRS485;                                 //Recupera los datos de cabecera de la trama UART: [0x3A, Direccion, Funcion, NumeroDatos]
	MOV	#lo_addr(_tramaCabeceraRS485), W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteRS485), W0
	MOV.B	[W0], [W1]
;Master.c,634 :: 		i_rs485++;
	MOV	#1, W1
	MOV	#lo_addr(_i_rs485), W0
	ADD	W1, [W0], [W0]
;Master.c,632 :: 		if ((banRSI==1)&&(i_rs485<4)){
L__urx_2290:
L__urx_2289:
;Master.c,636 :: 		if ((banRSI==1)&&(i_rs485==4)){
	MOV	#lo_addr(_banRSI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2418
	GOTO	L__urx_2292
L__urx_2418:
	MOV	_i_rs485, W0
	CP	W0, #4
	BRA Z	L__urx_2419
	GOTO	L__urx_2291
L__urx_2419:
L__urx_2284:
;Master.c,638 :: 		if (tramaCabeceraRS485[1]==direccionRS485){
	MOV	#lo_addr(_tramaCabeceraRS485+1), W0
	MOV.B	[W0], W1
	MOV	#lo_addr(_direccionRS485), W0
	CP.B	W1, [W0]
	BRA Z	L__urx_2420
	GOTO	L_urx_2160
L__urx_2420:
;Master.c,639 :: 		funcionRS485 = tramaCabeceraRS485[2];
	MOV	#lo_addr(_funcionRS485), W1
	MOV	#lo_addr(_tramaCabeceraRS485+2), W0
	MOV.B	[W0], [W1]
;Master.c,640 :: 		numDatosRS485 = tramaCabeceraRS485[3];
	MOV	#lo_addr(_tramaCabeceraRS485+3), W0
	ZE	[W0], W0
	MOV	W0, _numDatosRS485
;Master.c,641 :: 		banRSI = 2;
	MOV	#lo_addr(_banRSI), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,642 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,643 :: 		} else {
	GOTO	L_urx_2161
L_urx_2160:
;Master.c,644 :: 		banRSI = 0;
	MOV	#lo_addr(_banRSI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,645 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,646 :: 		i_rs485 = 0;
	CLR	W0
	MOV	W0, _i_rs485
;Master.c,647 :: 		}
L_urx_2161:
;Master.c,636 :: 		if ((banRSI==1)&&(i_rs485==4)){
L__urx_2292:
L__urx_2291:
;Master.c,651 :: 		if (banRSC==1){
	MOV	#lo_addr(_banRSC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2421
	GOTO	L_urx_2162
L__urx_2421:
;Master.c,652 :: 		subFuncionRS485 = inputPyloadRS485[0];
	MOV	#lo_addr(_subFuncionRS485), W1
	MOV	#lo_addr(_inputPyloadRS485), W0
	MOV.B	[W0], [W1]
;Master.c,653 :: 		switch (funcionRS485){
	GOTO	L_urx_2163
;Master.c,654 :: 		case 0xF1:
L_urx_2165:
;Master.c,657 :: 		InterrupcionP1(0xB1,0xD2,6);
	MOV	#6, W12
	MOV.B	#210, W11
	MOV.B	#177, W10
	CALL	_InterrupcionP1
;Master.c,660 :: 		break;
	GOTO	L_urx_2164
;Master.c,661 :: 		case 0xF2:
L_urx_2166:
;Master.c,664 :: 		break;
	GOTO	L_urx_2164
;Master.c,665 :: 		case 0xF3:
L_urx_2167:
;Master.c,668 :: 		break;
	GOTO	L_urx_2164
;Master.c,669 :: 		}
L_urx_2163:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#241, W0
	CP.B	W1, W0
	BRA NZ	L__urx_2422
	GOTO	L_urx_2165
L__urx_2422:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#242, W0
	CP.B	W1, W0
	BRA NZ	L__urx_2423
	GOTO	L_urx_2166
L__urx_2423:
	MOV	#lo_addr(_funcionRS485), W0
	MOV.B	[W0], W1
	MOV.B	#243, W0
	CP.B	W1, W0
	BRA NZ	L__urx_2424
	GOTO	L_urx_2167
L__urx_2424:
L_urx_2164:
;Master.c,671 :: 		banRSC = 0;
	MOV	#lo_addr(_banRSC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,673 :: 		}
L_urx_2162:
;Master.c,674 :: 		}
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