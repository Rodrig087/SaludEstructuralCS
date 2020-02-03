
_ConfigurarGPS:

;tiempo_gps.c,5 :: 		void ConfigurarGPS(){
;tiempo_gps.c,6 :: 		UART1_Write_Text("$PMTK605*31\r\n");
	PUSH	W10
	PUSH	W11
	MOV	#lo_addr(?lstr1_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,7 :: 		UART1_Write_Text("$PMTK220,1000*1F\r\n");
	MOV	#lo_addr(?lstr2_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,8 :: 		UART1_Write_Text("$PMTK251,115200*1F\r\n");
	MOV	#lo_addr(?lstr3_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,9 :: 		Delay_ms(1000);                                                            //Tiempo necesario para que se de efecto el cambio de configuracion
	MOV	#123, W8
	MOV	#4681, W7
L_ConfigurarGPS0:
	DEC	W7
	BRA NZ	L_ConfigurarGPS0
	DEC	W8
	BRA NZ	L_ConfigurarGPS0
;tiempo_gps.c,10 :: 		UART1_Init(115200);
	MOV	#49664, W10
	MOV	#1, W11
	CALL	_UART1_Init
;tiempo_gps.c,11 :: 		UART1_Write_Text("$PMTK313,1*2E\r\n");
	MOV	#lo_addr(?lstr4_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,12 :: 		UART1_Write_Text("$PMTK314,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0*29\r\n");
	MOV	#lo_addr(?lstr5_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,13 :: 		UART1_Write_Text("$PMTK319,1*24\r\n");
	MOV	#lo_addr(?lstr6_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,14 :: 		UART1_Write_Text("$PMTK413*34\r\n");
	MOV	#lo_addr(?lstr7_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,15 :: 		UART1_Write_Text("$PMTK513,1*28\r\n");
	MOV	#lo_addr(?lstr8_Master), W10
	CALL	_UART1_Write_Text
;tiempo_gps.c,16 :: 		Delay_ms(1000);
	MOV	#123, W8
	MOV	#4681, W7
L_ConfigurarGPS2:
	DEC	W7
	BRA NZ	L_ConfigurarGPS2
	DEC	W8
	BRA NZ	L_ConfigurarGPS2
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

;Master.c,72 :: 		void main() {
;Master.c,74 :: 		ConfiguracionPrincipal();
	CALL	_ConfiguracionPrincipal
;Master.c,78 :: 		banUTI = 0;
	MOV	#lo_addr(_banUTI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,79 :: 		banUTC = 0;
	MOV	#lo_addr(_banUTC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,81 :: 		banLec = 0;
	MOV	#lo_addr(_banLec), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,82 :: 		banEsc = 0;
	MOV	#lo_addr(_banEsc), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,83 :: 		banCiclo = 0;
	MOV	#lo_addr(_banCiclo), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,84 :: 		banSetReloj = 0;
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,85 :: 		banSetGPS = 0;
	MOV	#lo_addr(_banSetGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,86 :: 		banTIGPS = 0;
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,87 :: 		banTFGPS = 0;
	MOV	#lo_addr(_banTFGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,88 :: 		banTCGPS = 0;
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,90 :: 		banMuestrear = 0;                                                          //Inicia el programa con esta bandera en bajo para permitir que la RPi envie la peticion de inicio de muestreo
	MOV	#lo_addr(_banMuestrear), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,91 :: 		banInicio = 0;                                                             //Bandera de inicio de muestreo
	MOV	#lo_addr(_banInicio), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,92 :: 		banLeer = 0;
	MOV	#lo_addr(_banLeer), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,93 :: 		banConf = 0;
	MOV	#lo_addr(_banConf), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,95 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,96 :: 		x = 0;
	CLR	W0
	MOV	W0, _x
;Master.c,97 :: 		y = 0;
	CLR	W0
	MOV	W0, _y
;Master.c,98 :: 		i_gps = 0;
	CLR	W0
	MOV	W0, _i_gps
;Master.c,99 :: 		horaSistema = 0;
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,100 :: 		i_uart = 0;
	CLR	W0
	MOV	W0, _i_uart
;Master.c,102 :: 		contMuestras = 0;
	MOV	#lo_addr(_contMuestras), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,103 :: 		contCiclos = 0;
	MOV	#lo_addr(_contCiclos), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,104 :: 		contFIFO = 0;
	CLR	W0
	MOV	W0, _contFIFO
;Master.c,105 :: 		numFIFO = 0;
	MOV	#lo_addr(_numFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,106 :: 		numSetsFIFO = 0;
	MOV	#lo_addr(_numSetsFIFO), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,107 :: 		contTimer1 = 0;
	MOV	#lo_addr(_contTimer1), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,109 :: 		byteGPS = 0;
	MOV	#lo_addr(_byteGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,111 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,112 :: 		TEST = 1;
	BSET	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,114 :: 		SPI1BUF = 0x00;
	CLR	SPI1BUF
;Master.c,116 :: 		while(1){
L_main4:
;Master.c,118 :: 		}
	GOTO	L_main4
;Master.c,120 :: 		}
L_end_main:
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main

_ConfiguracionPrincipal:

;Master.c,129 :: 		void ConfiguracionPrincipal(){
;Master.c,132 :: 		CLKDIVbits.FRCDIV = 0;                                                     //FIN=FRC/1
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	MOV	CLKDIVbits, W1
	MOV	#63743, W0
	AND	W1, W0, W0
	MOV	WREG, CLKDIVbits
;Master.c,133 :: 		CLKDIVbits.PLLPOST = 0;                                                    //N2=2
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;Master.c,134 :: 		CLKDIVbits.PLLPRE = 5;                                                     //N1=7
	MOV.B	#5, W0
	MOV.B	W0, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #31, W1
	MOV	#lo_addr(CLKDIVbits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(CLKDIVbits), W0
	MOV.B	W1, [W0]
;Master.c,135 :: 		PLLFBDbits.PLLDIV = 150;                                                   //M=152
	MOV	#150, W0
	MOV	W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	#511, W0
	AND	W1, W0, W1
	MOV	#lo_addr(PLLFBDbits), W0
	XOR	W1, [W0], W1
	MOV	W1, PLLFBDbits
;Master.c,138 :: 		ANSELA = 0;                                                                //Configura PORTA como digital     *
	CLR	ANSELA
;Master.c,139 :: 		ANSELB = 0;                                                                //Configura PORTB como digital     *
	CLR	ANSELB
;Master.c,140 :: 		TRISA3_bit = 0;                                                            //Configura el pin A3 como salida  *
	BCLR	TRISA3_bit, BitPos(TRISA3_bit+0)
;Master.c,141 :: 		TRISA4_bit = 0;                                                            //Configura el pin A4 como salida  *
	BCLR	TRISA4_bit, BitPos(TRISA4_bit+0)
;Master.c,142 :: 		TRISB12_bit = 0;                                                           //Configura el pin B12 como salida *
	BCLR	TRISB12_bit, BitPos(TRISB12_bit+0)
;Master.c,143 :: 		TRISB10_bit = 1;                                                           //Configura el pin B10 como entrada *
	BSET	TRISB10_bit, BitPos(TRISB10_bit+0)
;Master.c,144 :: 		TRISB11_bit = 1;                                                           //Configura el pin B11 como entrada *
	BSET	TRISB11_bit, BitPos(TRISB11_bit+0)
;Master.c,145 :: 		TRISB13_bit = 1;                                                           //Configura el pin B13 como entrada *
	BSET	TRISB13_bit, BitPos(TRISB13_bit+0)
;Master.c,146 :: 		INTCON2.GIE = 1;                                                           //Habilita las interrupciones globales *
	BSET	INTCON2, #15
;Master.c,149 :: 		RPINR18bits.U1RXR = 0x22;                                                  //Configura el pin RB2/RPI34 como Rx1
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
;Master.c,150 :: 		RPOR0bits.RP35R = 0x01;                                                    //Configura el Tx1 en el pin RB3/RP35
	MOV	#256, W0
	MOV	W0, W1
	MOV	#lo_addr(RPOR0bits), W0
	XOR	W1, [W0], W1
	MOV	#16128, W0
	AND	W1, W0, W1
	MOV	#lo_addr(RPOR0bits), W0
	XOR	W1, [W0], W1
	MOV	W1, RPOR0bits
;Master.c,151 :: 		UART1_Init(9600);                                                          //Inicializa el UART1 con una velocidad de 9600 baudios
	MOV	#9600, W10
	MOV	#0, W11
	CALL	_UART1_Init
;Master.c,152 :: 		U1RXIE_bit = 0;                                                            //Desabilita la interrupcion por UART1 RX
	BCLR	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Master.c,153 :: 		U1RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
	BCLR	U1RXIF_bit, BitPos(U1RXIF_bit+0)
;Master.c,154 :: 		IPC2bits.U1RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#16384, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#28672, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;Master.c,155 :: 		U1STAbits.URXISEL = 0x00;
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U1STAbits), W0
	MOV.B	W1, [W0]
;Master.c,158 :: 		RPINR19bits.U2RXR = 0x2F;                                                  //Configura el pin RB15/RPI47 como Rx2
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
;Master.c,159 :: 		RPOR1bits.RP36R = 0x03;                                                    //Configura el Tx2 en el pin RB4/RP36
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
;Master.c,160 :: 		UART2_Init_Advanced(2000000, 2, 1, 1);                                     //Inicializa el UART2 con una velocidad de 2Mbps
	MOV	#1, W13
	MOV	#2, W12
	MOV	#33920, W10
	MOV	#30, W11
	MOV	#1, W0
	PUSH	W0
	CALL	_UART2_Init_Advanced
	SUB	#2, W15
;Master.c,161 :: 		U2RXIE_bit = 0;                                                            //Desabilita la interrupcion por UART2 RX
	BCLR	U2RXIE_bit, BitPos(U2RXIE_bit+0)
;Master.c,162 :: 		U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART1 RX
	BCLR	U2RXIF_bit, BitPos(U2RXIF_bit+0)
;Master.c,163 :: 		IPC7bits.U2RXIP = 0x04;                                                    //Prioridad de la interrupcion UART1 RX
	MOV	#1024, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC7bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC7bits
;Master.c,164 :: 		U2STAbits.URXISEL = 0x00;
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	[W0], W1
	MOV.B	#63, W0
	AND.B	W1, W0, W1
	MOV	#lo_addr(U2STAbits), W0
	MOV.B	W1, [W0]
;Master.c,176 :: 		SPI1STAT.SPIEN = 1;                                                        //Habilita el SPI1 *
	BSET	SPI1STAT, #15
;Master.c,177 :: 		SPI1_Init_Advanced(_SPI_SLAVE, _SPI_8_BIT, _SPI_PRESCALE_SEC_1, _SPI_PRESCALE_PRI_1, _SPI_SS_ENABLE, _SPI_DATA_SAMPLE_END, _SPI_CLK_IDLE_HIGH, _SPI_ACTIVE_2_IDLE);        //*
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
;Master.c,178 :: 		SPI1IE_bit = 1;                                                            //Habilita la interrupcion por SPI1  *
	BSET	SPI1IE_bit, BitPos(SPI1IE_bit+0)
;Master.c,179 :: 		SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI *
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Master.c,180 :: 		IPC2bits.SPI1IP = 0x03;                                                    //Prioridad de la interrupcion SPI1
	MOV	#768, W0
	MOV	W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	#1792, W0
	AND	W1, W0, W1
	MOV	#lo_addr(IPC2bits), W0
	XOR	W1, [W0], W1
	MOV	W1, IPC2bits
;Master.c,183 :: 		RPINR0 = 0x2E00;                                                           //Asigna INT1 al RB14/RPI46
	MOV	#11776, W0
	MOV	WREG, RPINR0
;Master.c,184 :: 		INT1IE_bit = 0;                                                            //Habilita la interrupcion externa INT1
	BCLR	INT1IE_bit, BitPos(INT1IE_bit+0)
;Master.c,185 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;Master.c,186 :: 		IPC5bits.INT1IP = 0x01;                                                    //Prioridad en la interrupocion externa 1
	MOV.B	#1, W0
	MOV.B	W0, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	AND.B	W1, #7, W1
	MOV	#lo_addr(IPC5bits), W0
	XOR.B	W1, [W0], W1
	MOV	#lo_addr(IPC5bits), W0
	MOV.B	W1, [W0]
;Master.c,188 :: 		Delay_ms(200);                                                             //Espera hasta que se estabilicen los cambios
	MOV	#25, W8
	MOV	#27150, W7
L_ConfiguracionPrincipal6:
	DEC	W7
	BRA NZ	L_ConfiguracionPrincipal6
	DEC	W8
	BRA NZ	L_ConfiguracionPrincipal6
	NOP
;Master.c,190 :: 		}
L_end_ConfiguracionPrincipal:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	RETURN
; end of _ConfiguracionPrincipal

_InterrupcionP2:

;Master.c,195 :: 		void InterrupcionP2(){
;Master.c,197 :: 		if (INT1IE_bit==0){
	BTSC	INT1IE_bit, BitPos(INT1IE_bit+0)
	GOTO	L_InterrupcionP28
;Master.c,198 :: 		INT1IE_bit = 1;
	BSET	INT1IE_bit, BitPos(INT1IE_bit+0)
;Master.c,199 :: 		}
L_InterrupcionP28:
;Master.c,201 :: 		if (U1RXIE_bit==1){
	BTSS	U1RXIE_bit, BitPos(U1RXIE_bit+0)
	GOTO	L_InterrupcionP29
;Master.c,202 :: 		U1RXIE_bit = 0;
	BCLR	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Master.c,203 :: 		}
L_InterrupcionP29:
;Master.c,205 :: 		RP1 = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,206 :: 		Delay_us(20);
	MOV	#160, W7
L_InterrupcionP210:
	DEC	W7
	BRA NZ	L_InterrupcionP210
	NOP
	NOP
;Master.c,207 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,208 :: 		}
L_end_InterrupcionP2:
	RETURN
; end of _InterrupcionP2

_EnviarTramaUART:
	LNK	#0

;Master.c,213 :: 		void EnviarTramaUART(unsigned short puertoUART, unsigned short direccion, unsigned short numDatos, unsigned short funcion, unsigned char *payload){
; payload start address is: 4 (W2)
	MOV	[W14-8], W2
;Master.c,217 :: 		if (puertoUART == 1){
	CP.B	W10, #1
	BRA Z	L__EnviarTramaUART102
	GOTO	L__EnviarTramaUART62
L__EnviarTramaUART102:
;Master.c,218 :: 		UART1_Write(0x3A);                                                      //Envia la cabecera de la trama
	PUSH	W10
	MOV	#58, W10
	CALL	_UART1_Write
;Master.c,219 :: 		UART1_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W11, W10
	CALL	_UART1_Write
;Master.c,220 :: 		UART1_Write(numDatos);                                                  //Envia el numero de datos
	ZE	W12, W10
	CALL	_UART1_Write
;Master.c,221 :: 		UART1_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W13, W10
	CALL	_UART1_Write
	POP	W10
;Master.c,222 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 2 (W1)
	CLR	W1
; payload end address is: 4 (W2)
; iDatos end address is: 2 (W1)
L_EnviarTramaUART13:
; iDatos start address is: 2 (W1)
; payload start address is: 4 (W2)
	ZE	W12, W0
	CP	W1, W0
	BRA LTU	L__EnviarTramaUART103
	GOTO	L_EnviarTramaUART14
L__EnviarTramaUART103:
;Master.c,223 :: 		UART1_Write(payload[iDatos]);
	ADD	W2, W1, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART1_Write
	POP	W10
;Master.c,222 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W1
;Master.c,224 :: 		}
; iDatos end address is: 2 (W1)
	GOTO	L_EnviarTramaUART13
L_EnviarTramaUART14:
;Master.c,225 :: 		UART1_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART1_Write
;Master.c,226 :: 		UART1_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART1_Write
; payload end address is: 4 (W2)
	POP	W10
	MOV	W2, W1
;Master.c,227 :: 		}
	GOTO	L_EnviarTramaUART12
L__EnviarTramaUART62:
;Master.c,217 :: 		if (puertoUART == 1){
	MOV	W2, W1
;Master.c,227 :: 		}
L_EnviarTramaUART12:
;Master.c,229 :: 		if (puertoUART == 2){
; payload start address is: 2 (W1)
	CP.B	W10, #2
	BRA Z	L__EnviarTramaUART104
	GOTO	L_EnviarTramaUART16
L__EnviarTramaUART104:
;Master.c,230 :: 		UART2_Write(0x3A);                                                      //Envia la cabecera de la trama
	PUSH	W10
	MOV	#58, W10
	CALL	_UART2_Write
;Master.c,231 :: 		UART2_Write(direccion);                                                 //Envia la direccion del destinatario
	ZE	W11, W10
	CALL	_UART2_Write
;Master.c,232 :: 		UART2_Write(numDatos);                                                  //Envia el numero de datos
	ZE	W12, W10
	CALL	_UART2_Write
;Master.c,233 :: 		UART2_Write(funcion);                                                   //Envia el codigo de la funcion
	ZE	W13, W10
	CALL	_UART2_Write
	POP	W10
;Master.c,234 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
; iDatos start address is: 4 (W2)
	CLR	W2
; iDatos end address is: 4 (W2)
L_EnviarTramaUART17:
; iDatos start address is: 4 (W2)
; payload start address is: 2 (W1)
; payload end address is: 2 (W1)
	ZE	W12, W0
	CP	W2, W0
	BRA LTU	L__EnviarTramaUART105
	GOTO	L_EnviarTramaUART18
L__EnviarTramaUART105:
; payload end address is: 2 (W1)
;Master.c,235 :: 		UART2_Write(payload[iDatos]);
; payload start address is: 2 (W1)
	ADD	W1, W2, W0
	PUSH	W10
	ZE	[W0], W10
	CALL	_UART2_Write
	POP	W10
;Master.c,234 :: 		for (iDatos=0;iDatos<numDatos;iDatos++){                                //Envia la carga util de datos
	INC	W2
;Master.c,236 :: 		}
; payload end address is: 2 (W1)
; iDatos end address is: 4 (W2)
	GOTO	L_EnviarTramaUART17
L_EnviarTramaUART18:
;Master.c,237 :: 		UART2_Write(0x0D);                                                      //Envia el primer delimitador de final de la trama
	PUSH	W10
	MOV	#13, W10
	CALL	_UART2_Write
;Master.c,238 :: 		UART2_Write(0x0A);                                                      //Envia el segundo delimitador de final de la trama
	MOV	#10, W10
	CALL	_UART2_Write
	POP	W10
;Master.c,239 :: 		}
L_EnviarTramaUART16:
;Master.c,241 :: 		}
L_end_EnviarTramaUART:
	ULNK
	RETURN
; end of _EnviarTramaUART

_spi_1:
	PUSH	DSWPAG
	PUSH	50
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;Master.c,252 :: 		void spi_1() org  IVT_ADDR_SPI1INTERRUPT {
;Master.c,254 :: 		SPI1IF_bit = 0;                                                            //Limpia la bandera de interrupcion por SPI
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	SPI1IF_bit, BitPos(SPI1IF_bit+0)
;Master.c,255 :: 		buffer = SPI1BUF;                                                          //Guarda el contenido del bufeer (lectura)
	MOV	#lo_addr(_buffer), W1
	MOV.B	SPI1BUF, WREG
	MOV.B	W0, [W1]
;Master.c,258 :: 		if ((banSetReloj==0)){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1107
	GOTO	L_spi_120
L__spi_1107:
;Master.c,259 :: 		if (buffer==0xC0){
	MOV	#lo_addr(_buffer), W0
	MOV.B	[W0], W1
	MOV.B	#192, W0
	CP.B	W1, W0
	BRA Z	L__spi_1108
	GOTO	L_spi_121
L__spi_1108:
;Master.c,260 :: 		banTIGPS = 0;                                                        //Limpia la bandera de inicio de trama  del GPS
	MOV	#lo_addr(_banTIGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,261 :: 		banTCGPS = 0;                                                        //Limpia la bandera de trama completa
	MOV	#lo_addr(_banTCGPS), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,262 :: 		i_gps = 0;                                                           //Limpia el subindice de la trama GPS
	CLR	W0
	MOV	W0, _i_gps
;Master.c,264 :: 		if (U1RXIE_bit==0){
	BTSC	U1RXIE_bit, BitPos(U1RXIE_bit+0)
	GOTO	L_spi_122
;Master.c,265 :: 		U1RXIE_bit = 1;
	BSET	U1RXIE_bit, BitPos(U1RXIE_bit+0)
;Master.c,266 :: 		}
L_spi_122:
;Master.c,267 :: 		}
L_spi_121:
;Master.c,268 :: 		}
L_spi_120:
;Master.c,271 :: 		if ((banSetReloj==0)&&(buffer==0xC3)){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__spi_1109
	GOTO	L__spi_172
L__spi_1109:
	MOV	#lo_addr(_buffer), W0
	MOV.B	[W0], W1
	MOV.B	#195, W0
	CP.B	W1, W0
	BRA Z	L__spi_1110
	GOTO	L__spi_171
L__spi_1110:
L__spi_170:
;Master.c,272 :: 		banEsc = 1;
	MOV	#lo_addr(_banEsc), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,273 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,271 :: 		if ((banSetReloj==0)&&(buffer==0xC3)){
L__spi_172:
L__spi_171:
;Master.c,275 :: 		if ((banEsc==1)&&(buffer!=0xC3)&&(buffer!=0xC4)){
	MOV	#lo_addr(_banEsc), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1111
	GOTO	L__spi_175
L__spi_1111:
	MOV	#lo_addr(_buffer), W0
	MOV.B	[W0], W1
	MOV.B	#195, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1112
	GOTO	L__spi_174
L__spi_1112:
	MOV	#lo_addr(_buffer), W0
	MOV.B	[W0], W1
	MOV.B	#196, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1113
	GOTO	L__spi_173
L__spi_1113:
L__spi_169:
;Master.c,276 :: 		tiempoRPI[j] = buffer;
	MOV	#lo_addr(_tiempoRPI), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_buffer), W0
	MOV.B	[W0], [W1]
;Master.c,277 :: 		j++;
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;Master.c,275 :: 		if ((banEsc==1)&&(buffer!=0xC3)&&(buffer!=0xC4)){
L__spi_175:
L__spi_174:
L__spi_173:
;Master.c,279 :: 		if ((banEsc==1)&&(buffer==0xC4)){
	MOV	#lo_addr(_banEsc), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1114
	GOTO	L__spi_177
L__spi_1114:
	MOV	#lo_addr(_buffer), W0
	MOV.B	[W0], W1
	MOV.B	#196, W0
	CP.B	W1, W0
	BRA Z	L__spi_1115
	GOTO	L__spi_176
L__spi_1115:
L__spi_168:
;Master.c,280 :: 		horaSistema = RecuperarHoraRPI(tiempoRPI);                              //Recupera la hora de la RPi
	MOV	#lo_addr(_tiempoRPI), W10
	CALL	_RecuperarHoraRPI
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,281 :: 		fechaSistema = RecuperarFechaRPI(tiempoRPI);                            //Recupera la fecha de la RPi
	MOV	#lo_addr(_tiempoRPI), W10
	CALL	_RecuperarFechaRPI
	MOV	W0, _fechaSistema
	MOV	W1, _fechaSistema+2
;Master.c,282 :: 		AjustarTiempoSistema(horaSistema, fechaSistema, tiempo);                //Actualiza los datos de la trama tiempo con la hora y fecha recuperadas
	MOV.D	W0, W12
	MOV	_horaSistema, W10
	MOV	_horaSistema+2, W11
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_AjustarTiempoSistema
	SUB	#2, W15
;Master.c,283 :: 		banEsc = 0;
	MOV	#lo_addr(_banEsc), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,286 :: 		EnviarTramaUART(2, 255, 6, 2, tiempo);                                  //puerto = UART1, direccion = broadcast, numBytes = 6 bytes, funcion = setTiempo, trama = tiempo
	MOV.B	#2, W13
	MOV.B	#6, W12
	MOV.B	#255, W11
	MOV.B	#2, W10
	MOV	#lo_addr(_tiempo), W0
	PUSH	W0
	CALL	_EnviarTramaUART
	SUB	#2, W15
;Master.c,287 :: 		U2RXIE_bit = 1;                                                         //Activa la interrupcion por UART1
	BSET	U2RXIE_bit, BitPos(U2RXIE_bit+0)
;Master.c,279 :: 		if ((banEsc==1)&&(buffer==0xC4)){
L__spi_177:
L__spi_176:
;Master.c,292 :: 		if (banSetReloj==1){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1116
	GOTO	L_spi_132
L__spi_1116:
;Master.c,293 :: 		banSetReloj = 2;
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,294 :: 		j = 0;
	CLR	W0
	MOV	W0, _j
;Master.c,295 :: 		SPI1BUF = tiempo[j];
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,296 :: 		}
L_spi_132:
;Master.c,297 :: 		if ((banSetReloj==2)&&(buffer!=0xC1)){
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__spi_1117
	GOTO	L__spi_179
L__spi_1117:
	MOV	#lo_addr(_buffer), W0
	MOV.B	[W0], W1
	MOV.B	#193, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1118
	GOTO	L__spi_178
L__spi_1118:
L__spi_167:
;Master.c,298 :: 		SPI1BUF = tiempo[j];
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,299 :: 		j++;
	MOV	#1, W1
	MOV	#lo_addr(_j), W0
	ADD	W1, [W0], [W0]
;Master.c,297 :: 		if ((banSetReloj==2)&&(buffer!=0xC1)){
L__spi_179:
L__spi_178:
;Master.c,301 :: 		if ((banSetReloj==2)&&(buffer==0xC1)){                                     //Si detecta el delimitador de final de trama:
	MOV	#lo_addr(_banSetReloj), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__spi_1119
	GOTO	L__spi_181
L__spi_1119:
	MOV	#lo_addr(_buffer), W0
	MOV.B	[W0], W1
	MOV.B	#193, W0
	CP.B	W1, W0
	BRA Z	L__spi_1120
	GOTO	L__spi_180
L__spi_1120:
L__spi_166:
;Master.c,302 :: 		banSetReloj = 0;                                                        //Limpia la bandera de lectura
	MOV	#lo_addr(_banSetReloj), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,301 :: 		if ((banSetReloj==2)&&(buffer==0xC1)){                                     //Si detecta el delimitador de final de trama:
L__spi_181:
L__spi_180:
;Master.c,307 :: 		if ((banLec==1)&&(buffer==0xB0)){                                          //Verifica si la bandera de inicio de trama esta activa
	MOV	#lo_addr(_banLec), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__spi_1121
	GOTO	L__spi_183
L__spi_1121:
	MOV	#lo_addr(_buffer), W0
	MOV.B	[W0], W1
	MOV.B	#176, W0
	CP.B	W1, W0
	BRA Z	L__spi_1122
	GOTO	L__spi_182
L__spi_1122:
L__spi_165:
;Master.c,308 :: 		banLec = 2;                                                             //Activa la bandera de lectura
	MOV	#lo_addr(_banLec), W1
	MOV.B	#2, W0
	MOV.B	W0, [W1]
;Master.c,309 :: 		i = 0;
	CLR	W0
	MOV	W0, _i
;Master.c,310 :: 		SPI1BUF = tramaCompleta[i];
	MOV	#lo_addr(_tramaCompleta), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,307 :: 		if ((banLec==1)&&(buffer==0xB0)){                                          //Verifica si la bandera de inicio de trama esta activa
L__spi_183:
L__spi_182:
;Master.c,312 :: 		if ((banLec==2)&&(buffer!=0xB1)){
	MOV	#lo_addr(_banLec), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__spi_1123
	GOTO	L__spi_185
L__spi_1123:
	MOV	#lo_addr(_buffer), W0
	MOV.B	[W0], W1
	MOV.B	#177, W0
	CP.B	W1, W0
	BRA NZ	L__spi_1124
	GOTO	L__spi_184
L__spi_1124:
L__spi_164:
;Master.c,313 :: 		SPI1BUF = tramaCompleta[i];
	MOV	#lo_addr(_tramaCompleta), W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], W0
	MOV.B	[W0], W0
	ZE	W0, W0
	MOV	WREG, SPI1BUF
;Master.c,314 :: 		i++;
	MOV	#1, W1
	MOV	#lo_addr(_i), W0
	ADD	W1, [W0], [W0]
;Master.c,312 :: 		if ((banLec==2)&&(buffer!=0xB1)){
L__spi_185:
L__spi_184:
;Master.c,316 :: 		if ((banLec==2)&&(buffer==0xB1)){                                          //Si detecta el delimitador de final de trama:
	MOV	#lo_addr(_banLec), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__spi_1125
	GOTO	L__spi_187
L__spi_1125:
	MOV	#lo_addr(_buffer), W0
	MOV.B	[W0], W1
	MOV.B	#177, W0
	CP.B	W1, W0
	BRA Z	L__spi_1126
	GOTO	L__spi_186
L__spi_1126:
L__spi_163:
;Master.c,317 :: 		banLec = 0;                                                             //Limpia la bandera de lectura
	MOV	#lo_addr(_banLec), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,318 :: 		SPI1BUF = 0xFF;
	MOV	#255, W0
	MOV	WREG, SPI1BUF
;Master.c,316 :: 		if ((banLec==2)&&(buffer==0xB1)){                                          //Si detecta el delimitador de final de trama:
L__spi_187:
L__spi_186:
;Master.c,321 :: 		}
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

;Master.c,326 :: 		void int_1() org IVT_ADDR_INT1INTERRUPT {
;Master.c,328 :: 		INT1IF_bit = 0;                                                            //Limpia la bandera de interrupcion externa INT1
	BCLR	INT1IF_bit, BitPos(INT1IF_bit+0)
;Master.c,331 :: 		horaSistema++;                                                             //Incrementa el reloj del sistema
	MOV	#1, W1
	MOV	#0, W2
	MOV	#lo_addr(_horaSistema), W0
	ADD	W1, [W0], [W0++]
	ADDC	W2, [W0], [W0--]
;Master.c,333 :: 		if (horaSistema==86400){                                                   //(24*3600)+(0*60)+(0) = 86400
	MOV	_horaSistema, W2
	MOV	_horaSistema+2, W3
	MOV	#20864, W0
	MOV	#1, W1
	CP	W2, W0
	CPB	W3, W1
	BRA Z	L__int_1128
	GOTO	L_int_148
L__int_1128:
;Master.c,334 :: 		horaSistema = 0;                                                        //Reinicia el reloj al llegar a las 24:00:00 horas
	CLR	W0
	CLR	W1
	MOV	W0, _horaSistema
	MOV	W1, _horaSistema+2
;Master.c,335 :: 		}
L_int_148:
;Master.c,337 :: 		if (banInicio==1){
	MOV	#lo_addr(_banInicio), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__int_1129
	GOTO	L_int_149
L__int_1129:
;Master.c,339 :: 		}
L_int_149:
;Master.c,341 :: 		}
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

;Master.c,431 :: 		void urx_2() org  IVT_ADDR_U2RXINTERRUPT {
;Master.c,433 :: 		U2RXIF_bit = 0;                                                            //Limpia la bandera de interrupcion por UART2
	BCLR	U2RXIF_bit, BitPos(U2RXIF_bit+0)
;Master.c,435 :: 		byteUART2 = U2RXREG;                                                       //Lee el byte de la trama enviada por el GPS
	MOV	#lo_addr(_byteUART2), W1
	MOV.B	U2RXREG, WREG
	MOV.B	W0, [W1]
;Master.c,436 :: 		U2STA.OERR = 0;                                                            //Limpia este bit para limpiar el FIFO UART2
	BCLR	U2STA, #1
;Master.c,438 :: 		if ((banUTI==0)&&(byteUART2==0x3A)){                                       //Verifica si el primer byte recibido sea la cabecera de trama
	MOV	#lo_addr(_banUTI), W0
	MOV.B	[W0], W0
	CP.B	W0, #0
	BRA Z	L__urx_2131
	GOTO	L__urx_290
L__urx_2131:
	MOV	#lo_addr(_byteUART2), W0
	MOV.B	[W0], W1
	MOV.B	#58, W0
	CP.B	W1, W0
	BRA Z	L__urx_2132
	GOTO	L__urx_289
L__urx_2132:
L__urx_288:
;Master.c,439 :: 		banUTI = 1;
	MOV	#lo_addr(_banUTI), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,440 :: 		i_uart = 0;
	CLR	W0
	MOV	W0, _i_uart
;Master.c,438 :: 		if ((banUTI==0)&&(byteUART2==0x3A)){                                       //Verifica si el primer byte recibido sea la cabecera de trama
L__urx_290:
L__urx_289:
;Master.c,442 :: 		if (banUTI==1){
	MOV	#lo_addr(_banUTI), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2133
	GOTO	L_urx_253
L__urx_2133:
;Master.c,443 :: 		if (byteUART2!=0x0A){
	MOV	#lo_addr(_byteUART2), W0
	MOV.B	[W0], W0
	CP.B	W0, #10
	BRA NZ	L__urx_2134
	GOTO	L_urx_254
L__urx_2134:
;Master.c,444 :: 		tramaUART2[i_uart] = byteUART2;                                      //Almacena el byte recibido en la trama, mientras este sea diferente del segundo byte del delimitador de final de trama
	MOV	#lo_addr(_tramaUART2), W1
	MOV	#lo_addr(_i_uart), W0
	ADD	W1, [W0], W1
	MOV	#lo_addr(_byteUART2), W0
	MOV.B	[W0], [W1]
;Master.c,445 :: 		i_uart++;
	MOV	#1, W1
	MOV	#lo_addr(_i_uart), W0
	ADD	W1, [W0], [W0]
;Master.c,446 :: 		} else {
	GOTO	L_urx_255
L_urx_254:
;Master.c,447 :: 		banUTI = 0;                                                          //Limpia la bandera de inicio de trama
	MOV	#lo_addr(_banUTI), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,448 :: 		banUTC = 1;                                                          //Activa la bandera de trama completa
	MOV	#lo_addr(_banUTC), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,449 :: 		}
L_urx_255:
;Master.c,450 :: 		}
L_urx_253:
;Master.c,452 :: 		if (banUTC==1){
	MOV	#lo_addr(_banUTC), W0
	MOV.B	[W0], W0
	CP.B	W0, #1
	BRA Z	L__urx_2135
	GOTO	L_urx_256
L__urx_2135:
;Master.c,454 :: 		TEST = ~TEST;                                                          //Indica si se completo la trama
	BTG	LATB12_bit, BitPos(LATB12_bit+0)
;Master.c,455 :: 		for (x=0;x<6;x++) {
	CLR	W0
	MOV	W0, _x
L_urx_257:
	MOV	_x, W0
	CP	W0, #6
	BRA LTU	L__urx_2136
	GOTO	L_urx_258
L__urx_2136:
;Master.c,456 :: 		tiempo[x] = tramaUART2[x+4];                                       //LLeno la trama tiempo con el payload de la trama recuperada
	MOV	#lo_addr(_tiempo), W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], W2
	MOV	_x, W0
	ADD	W0, #4, W1
	MOV	#lo_addr(_tramaUART2), W0
	ADD	W0, W1, W0
	MOV.B	[W0], [W2]
;Master.c,455 :: 		for (x=0;x<6;x++) {
	MOV	#1, W1
	MOV	#lo_addr(_x), W0
	ADD	W1, [W0], [W0]
;Master.c,457 :: 		}
	GOTO	L_urx_257
L_urx_258:
;Master.c,458 :: 		banSetReloj=1;                                                         //Activa la bandera para enviar la hora a la RPI por SPI
	MOV	#lo_addr(_banSetReloj), W1
	MOV.B	#1, W0
	MOV.B	W0, [W1]
;Master.c,460 :: 		RP1 = 1;
	BSET	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,461 :: 		Delay_us(20);
	MOV	#160, W7
L_urx_260:
	DEC	W7
	BRA NZ	L_urx_260
	NOP
	NOP
;Master.c,462 :: 		RP1 = 0;
	BCLR	LATA4_bit, BitPos(LATA4_bit+0)
;Master.c,464 :: 		banUTC = 0;
	MOV	#lo_addr(_banUTC), W1
	CLR	W0
	MOV.B	W0, [W1]
;Master.c,465 :: 		}
L_urx_256:
;Master.c,467 :: 		}
L_end_urx_2:
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	50
	POP	DSWPAG
	RETFIE
; end of _urx_2
