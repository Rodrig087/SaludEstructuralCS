
_SD_Read:
	LNK	#2

;sdcard.c,91 :: 		unsigned char SD_Read(unsigned char *Buffer, unsigned int nbytes){
;sdcard.c,94 :: 		for(i = 0; i < SD_TIME_OUT; i++){
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_SD_Read0:
; i start address is: 4 (W2)
	MOV	#100, W0
	CP	W2, W0
	BRA LTU	L__SD_Read78
	GOTO	L_SD_Read1
L__SD_Read78:
;sdcard.c,95 :: 		temp = SPISD_Write(0xFF);
	PUSH	W2
	PUSH.D	W10
	MOV.B	#255, W10
	CALL	_SPISD_Write
	POP.D	W10
	POP	W2
;sdcard.c,96 :: 		if(temp == 0xFE) break;
	MOV.B	#254, W1
	CP.B	W0, W1
	BRA Z	L__SD_Read79
	GOTO	L_SD_Read3
L__SD_Read79:
; i end address is: 4 (W2)
	GOTO	L_SD_Read1
L_SD_Read3:
;sdcard.c,98 :: 		if(i == SD_TIME_OUT-1) return 0xEE;
; i start address is: 4 (W2)
	MOV	#99, W0
	CP	W2, W0
	BRA Z	L__SD_Read80
	GOTO	L_SD_Read4
L__SD_Read80:
; i end address is: 4 (W2)
	MOV.B	#238, W0
	GOTO	L_end_SD_Read
L_SD_Read4:
;sdcard.c,94 :: 		for(i = 0; i < SD_TIME_OUT; i++){
; i start address is: 4 (W2)
	INC	W2
;sdcard.c,99 :: 		}
; i end address is: 4 (W2)
	GOTO	L_SD_Read0
L_SD_Read1:
;sdcard.c,100 :: 		for(i = 0; i < nbytes; i++){
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_SD_Read5:
; i start address is: 4 (W2)
	CP	W2, W11
	BRA LTU	L__SD_Read81
	GOTO	L_SD_Read6
L__SD_Read81:
;sdcard.c,101 :: 		Buffer[i] = SPISD_Write(0xFF);
	ADD	W10, W2, W0
	MOV	W0, [W14+0]
	PUSH	W2
	PUSH.D	W10
	MOV.B	#255, W10
	CALL	_SPISD_Write
	POP.D	W10
	POP	W2
	MOV	[W14+0], W1
	MOV.B	W0, [W1]
;sdcard.c,100 :: 		for(i = 0; i < nbytes; i++){
	INC	W2
;sdcard.c,102 :: 		}
; i end address is: 4 (W2)
	GOTO	L_SD_Read5
L_SD_Read6:
;sdcard.c,103 :: 		temp = SPISD_Write(0xFF);     // Read 16bits of CRC
	PUSH.D	W10
	MOV.B	#255, W10
	CALL	_SPISD_Write
;sdcard.c,104 :: 		temp = SPISD_Write(0xFF);     //
	MOV.B	#255, W10
	CALL	_SPISD_Write
	POP.D	W10
;sdcard.c,105 :: 		return 0x00;                // Successful read
	CLR	W0
;sdcard.c,106 :: 		}
L_end_SD_Read:
	ULNK
	RETURN
; end of _SD_Read

_SD_Read_Block:

;sdcard.c,117 :: 		unsigned char SD_Read_Block(unsigned char *Buffer, unsigned long Address){
;sdcard.c,119 :: 		Select_SD();
	PUSH	W11
	PUSH	W12
	PUSH	W13
	CALL	_Select_SD
;sdcard.c,121 :: 		if(ccs == 0x02) Address<<=9;        // Address * 512 for SDSC cards
	MOV	#lo_addr(_ccs), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__SD_Read_Block83
	GOTO	L_SD_Read_Block8
L__SD_Read_Block83:
	SL	W12, #9, W1
	LSR	W11, #7, W0
	IOR	W0, W1, W1
	SL	W11, #9, W0
	MOV	W0, W11
	MOV	W1, W12
L_SD_Read_Block8:
;sdcard.c,122 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	PUSH	W11
	PUSH	W12
	PUSH	W10
	CALL	_SD_Ready
	POP	W10
	POP	W12
	POP	W11
	CP.B	W0, #0
	BRA Z	L__SD_Read_Block84
	GOTO	L_SD_Read_Block9
L__SD_Read_Block84:
	MOV.B	#17, W0
	GOTO	L_end_SD_Read_Block
L_SD_Read_Block9:
;sdcard.c,123 :: 		SD_Send_Command(READ_SINGLE_BLOCK,Address,0xFF);
	PUSH	W10
	MOV.B	#255, W13
	MOV.B	#17, W10
	CALL	_SD_Send_Command
;sdcard.c,124 :: 		temp = R1_Response();
	CALL	_R1_Response
	POP	W10
; temp start address is: 2 (W1)
	MOV.B	W0, W1
;sdcard.c,125 :: 		if(temp != 0x00) return temp;
	CP.B	W0, #0
	BRA NZ	L__SD_Read_Block85
	GOTO	L_SD_Read_Block10
L__SD_Read_Block85:
	MOV.B	W1, W0
; temp end address is: 2 (W1)
	GOTO	L_end_SD_Read_Block
L_SD_Read_Block10:
;sdcard.c,126 :: 		temp = SD_Read(Buffer,512);
	MOV	#512, W11
	CALL	_SD_Read
; temp start address is: 2 (W1)
	MOV.B	W0, W1
;sdcard.c,128 :: 		Release_SD();
	CALL	_Release_SD
;sdcard.c,129 :: 		return temp;
	MOV.B	W1, W0
; temp end address is: 2 (W1)
;sdcard.c,130 :: 		}
;sdcard.c,129 :: 		return temp;
;sdcard.c,130 :: 		}
L_end_SD_Read_Block:
	POP	W13
	POP	W12
	POP	W11
	RETURN
; end of _SD_Read_Block

_SD_Write_Block:

;sdcard.c,141 :: 		unsigned char SD_Write_Block(unsigned char *Buffer, unsigned long Address){
;sdcard.c,146 :: 		Select_SD();
	PUSH	W13
	CALL	_Select_SD
;sdcard.c,148 :: 		if(ccs == 0x02) Address<<=9;        // Address * 512 for SDSC cards
	MOV	#lo_addr(_ccs), W0
	MOV.B	[W0], W0
	CP.B	W0, #2
	BRA Z	L__SD_Write_Block87
	GOTO	L_SD_Write_Block11
L__SD_Write_Block87:
	SL	W12, #9, W1
	LSR	W11, #7, W0
	IOR	W0, W1, W1
	SL	W11, #9, W0
	MOV	W0, W11
	MOV	W1, W12
L_SD_Write_Block11:
;sdcard.c,149 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	PUSH	W11
	PUSH	W12
	PUSH	W10
	CALL	_SD_Ready
	POP	W10
	POP	W12
	POP	W11
	CP.B	W0, #0
	BRA Z	L__SD_Write_Block88
	GOTO	L_SD_Write_Block12
L__SD_Write_Block88:
	MOV.B	#17, W0
	GOTO	L_end_SD_Write_Block
L_SD_Write_Block12:
;sdcard.c,150 :: 		SD_Send_Command(WRITE_BLOCK,Address,0xFF);
	PUSH	W10
	MOV.B	#255, W13
	MOV.B	#24, W10
	CALL	_SD_Send_Command
;sdcard.c,151 :: 		temp = R1_Response();
	CALL	_R1_Response
	POP	W10
; temp start address is: 2 (W1)
	MOV.B	W0, W1
;sdcard.c,152 :: 		if(temp != 0x00) return temp;
	CP.B	W0, #0
	BRA NZ	L__SD_Write_Block89
	GOTO	L_SD_Write_Block13
L__SD_Write_Block89:
	MOV.B	W1, W0
; temp end address is: 2 (W1)
	GOTO	L_end_SD_Write_Block
L_SD_Write_Block13:
;sdcard.c,153 :: 		temp = SPISD_Write(0xFE);    // Send Start Block Token;
	PUSH	W10
	MOV.B	#254, W10
	CALL	_SPISD_Write
	POP	W10
;sdcard.c,154 :: 		for(i = 0; i < 512; i++){
; i start address is: 2 (W1)
	CLR	W1
; i end address is: 2 (W1)
L_SD_Write_Block14:
; i start address is: 2 (W1)
	MOV	#512, W0
	CP	W1, W0
	BRA LTU	L__SD_Write_Block90
	GOTO	L_SD_Write_Block15
L__SD_Write_Block90:
;sdcard.c,155 :: 		temp = SPISD_Write(Buffer[i]);
	ADD	W10, W1, W0
	PUSH	W1
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV.B	[W0], W10
	CALL	_SPISD_Write
	POP	W10
	POP	W12
	POP	W11
	POP	W1
;sdcard.c,154 :: 		for(i = 0; i < 512; i++){
	INC	W1
;sdcard.c,156 :: 		}
; i end address is: 2 (W1)
	GOTO	L_SD_Write_Block14
L_SD_Write_Block15:
;sdcard.c,157 :: 		temp = SPISD_Write(0xFF);        // Send dummy 16bits CRC
	PUSH	W11
	PUSH	W12
	PUSH	W10
	MOV.B	#255, W10
	CALL	_SPISD_Write
;sdcard.c,158 :: 		temp = SPISD_Write(0xFF);
	MOV.B	#255, W10
	CALL	_SPISD_Write
;sdcard.c,159 :: 		temp = SPISD_Write(0xFF); // Read Response token (xxx0:status(3b):1)
	MOV.B	#255, W10
	CALL	_SPISD_Write
	POP	W10
	POP	W12
	POP	W11
;sdcard.c,160 :: 		temp = (temp&0x0E)>>1;
	ZE	W0, W0
	AND	W0, #14, W0
	ASR	W0, #1, W0
; temp start address is: 2 (W1)
	MOV.B	W0, W1
;sdcard.c,161 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	PUSH	W1
	PUSH	W11
	PUSH	W12
	PUSH	W10
	CALL	_SD_Ready
	POP	W10
	POP	W12
	POP	W11
	POP	W1
	CP.B	W0, #0
	BRA Z	L__SD_Write_Block91
	GOTO	L_SD_Write_Block17
L__SD_Write_Block91:
; temp end address is: 2 (W1)
	MOV.B	#17, W0
	GOTO	L_end_SD_Write_Block
L_SD_Write_Block17:
;sdcard.c,164 :: 		Release_SD();
; temp start address is: 2 (W1)
	CALL	_Release_SD
;sdcard.c,165 :: 		if(temp == 0x02) return DATA_ACCEPTED;
	CP.B	W1, #2
	BRA Z	L__SD_Write_Block92
	GOTO	L_SD_Write_Block18
L__SD_Write_Block92:
; temp end address is: 2 (W1)
	MOV.B	#22, W0
	GOTO	L_end_SD_Write_Block
L_SD_Write_Block18:
;sdcard.c,166 :: 		else if(temp == 0x05) return DATA_REJECTED_CRC_ERROR;
; temp start address is: 2 (W1)
	CP.B	W1, #5
	BRA Z	L__SD_Write_Block93
	GOTO	L_SD_Write_Block20
L__SD_Write_Block93:
; temp end address is: 2 (W1)
	MOV.B	#23, W0
	GOTO	L_end_SD_Write_Block
L_SD_Write_Block20:
;sdcard.c,167 :: 		else if(temp == 0x06) return DATA_REJECTED_WR_ERROR;
; temp start address is: 2 (W1)
	CP.B	W1, #6
	BRA Z	L__SD_Write_Block94
	GOTO	L_SD_Write_Block22
L__SD_Write_Block94:
; temp end address is: 2 (W1)
	MOV.B	#24, W0
	GOTO	L_end_SD_Write_Block
L_SD_Write_Block22:
;sdcard.c,168 :: 		else return ERROR;
	MOV.B	#10, W0
;sdcard.c,169 :: 		}
;sdcard.c,168 :: 		else return ERROR;
;sdcard.c,169 :: 		}
L_end_SD_Write_Block:
	POP	W13
	RETURN
; end of _SD_Write_Block

_SD_Init_Try:
	LNK	#2

;sdcard.c,181 :: 		unsigned char SD_Init_Try(unsigned char try_value){
;sdcard.c,183 :: 		if(try_value == 0) try_value = 1;
	CP.B	W10, #0
	BRA Z	L__SD_Init_Try96
	GOTO	L_SD_Init_Try24
L__SD_Init_Try96:
	MOV.B	#1, W10
L_SD_Init_Try24:
;sdcard.c,184 :: 		for(i = 0; i < try_value; i++){
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_SD_Init_Try25:
; i start address is: 4 (W2)
	CP.B	W2, W10
	BRA LTU	L__SD_Init_Try97
	GOTO	L_SD_Init_Try26
L__SD_Init_Try97:
;sdcard.c,185 :: 		init_status = SD_Init();
	PUSH	W2
	PUSH	W10
	CALL	_SD_Init
	POP	W10
	POP	W2
	MOV.B	W0, [W14+0]
;sdcard.c,186 :: 		if(init_status == SUCCESSFUL_INIT) break;
	MOV.B	#170, W1
	CP.B	W0, W1
	BRA Z	L__SD_Init_Try98
	GOTO	L_SD_Init_Try28
L__SD_Init_Try98:
; i end address is: 4 (W2)
	GOTO	L_SD_Init_Try26
L_SD_Init_Try28:
;sdcard.c,187 :: 		Release_SD();
; i start address is: 4 (W2)
	CALL	_Release_SD
;sdcard.c,188 :: 		Delay_ms(10);
	MOV	#2, W8
	MOV	#14464, W7
L_SD_Init_Try29:
	DEC	W7
	BRA NZ	L_SD_Init_Try29
	DEC	W8
	BRA NZ	L_SD_Init_Try29
	NOP
	NOP
;sdcard.c,184 :: 		for(i = 0; i < try_value; i++){
	INC.B	W2
;sdcard.c,189 :: 		}
; i end address is: 4 (W2)
	GOTO	L_SD_Init_Try25
L_SD_Init_Try26:
;sdcard.c,190 :: 		return init_status;
	MOV.B	[W14+0], W0
;sdcard.c,191 :: 		}
L_end_SD_Init_Try:
	ULNK
	RETURN
; end of _SD_Init_Try

_SD_Init:
	LNK	#2

;sdcard.c,202 :: 		unsigned char SD_Init(void){
;sdcard.c,209 :: 		sd_CS_tris = 0;
	PUSH	W10
	PUSH	W11
	PUSH	W12
	PUSH	W13
	BCLR	sd_CS_tris, BitPos(sd_CS_tris+0)
;sdcard.c,212 :: 		Release_SD();
	CALL	_Release_SD
;sdcard.c,215 :: 		SPISD_Init(SLOW);
	CLR	W10
	CALL	_SPISD_Init
;sdcard.c,218 :: 		for(i = 0; i < 80; i++) SPISD_Write(0xFF);
	CLR	W0
	MOV	W0, [W14+0]
L_SD_Init31:
	MOV	#80, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GTU	L__SD_Init100
	GOTO	L_SD_Init32
L__SD_Init100:
	MOV.B	#255, W10
	CALL	_SPISD_Write
	MOV	[W14+0], W1
	ADD	W14, #0, W0
	ADD	W1, #1, [W0]
	GOTO	L_SD_Init31
L_SD_Init32:
;sdcard.c,221 :: 		Select_SD();
	CALL	_Select_SD
;sdcard.c,222 :: 		for(i = 0; i < SD_TIME_OUT; i++){
	CLR	W0
	MOV	W0, [W14+0]
L_SD_Init34:
	MOV	#100, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GTU	L__SD_Init101
	GOTO	L_SD_Init35
L__SD_Init101:
;sdcard.c,223 :: 		SD_Send_Command(GO_IDLE_STATE,0x00000000,0x4A);     // CMD0
	MOV.B	#74, W13
	CLR	W11
	CLR	W12
	CLR	W10
	CALL	_SD_Send_Command
;sdcard.c,224 :: 		temp = R1_Response();
	CALL	_R1_Response
;sdcard.c,225 :: 		if(temp == (1<<IDLE_STATE)) break;
	CP.B	W0, #1
	BRA Z	L__SD_Init102
	GOTO	L_SD_Init37
L__SD_Init102:
	GOTO	L_SD_Init35
L_SD_Init37:
;sdcard.c,226 :: 		if(i==(SD_TIME_OUT-1)) return CARD_NOT_INSERTED;
	MOV	#99, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA Z	L__SD_Init103
	GOTO	L_SD_Init38
L__SD_Init103:
	MOV.B	#16, W0
	GOTO	L_end_SD_Init
L_SD_Init38:
;sdcard.c,222 :: 		for(i = 0; i < SD_TIME_OUT; i++){
	MOV	[W14+0], W1
	ADD	W14, #0, W0
	ADD	W1, #1, [W0]
;sdcard.c,227 :: 		}
	GOTO	L_SD_Init34
L_SD_Init35:
;sdcard.c,230 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	CALL	_SD_Ready
	CP.B	W0, #0
	BRA Z	L__SD_Init104
	GOTO	L_SD_Init39
L__SD_Init104:
	MOV.B	#17, W0
	GOTO	L_end_SD_Init
L_SD_Init39:
;sdcard.c,231 :: 		SD_Send_Command(SEND_IF_COND,0x000001AA,0x43);          // CMD8
	MOV.B	#67, W13
	MOV	#426, W11
	MOV	#0, W12
	MOV.B	#8, W10
	CALL	_SD_Send_Command
;sdcard.c,232 :: 		temp = R1_Response();
	CALL	_R1_Response
; temp start address is: 2 (W1)
	MOV.B	W0, W1
;sdcard.c,233 :: 		if(temp != (1<<IDLE_STATE)){
	CP.B	W0, #1
	BRA NZ	L__SD_Init105
	GOTO	L_SD_Init40
L__SD_Init105:
; temp end address is: 2 (W1)
;sdcard.c,235 :: 		for(i = 0; i < SD_TIME_OUT; i++){
	CLR	W0
	MOV	W0, [W14+0]
L_SD_Init41:
	MOV	#100, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GTU	L__SD_Init106
	GOTO	L_SD_Init42
L__SD_Init106:
;sdcard.c,236 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	CALL	_SD_Ready
	CP.B	W0, #0
	BRA Z	L__SD_Init107
	GOTO	L_SD_Init44
L__SD_Init107:
	MOV.B	#17, W0
	GOTO	L_end_SD_Init
L_SD_Init44:
;sdcard.c,237 :: 		SD_Send_Command(SEND_OP_COND,0x00000000,0x7C);  // CMD1
	MOV.B	#124, W13
	CLR	W11
	CLR	W12
	MOV.B	#1, W10
	CALL	_SD_Send_Command
;sdcard.c,238 :: 		temp = R1_Response();
	CALL	_R1_Response
;sdcard.c,239 :: 		if(temp == 0x00) break;
	CP.B	W0, #0
	BRA Z	L__SD_Init108
	GOTO	L_SD_Init45
L__SD_Init108:
	GOTO	L_SD_Init42
L_SD_Init45:
;sdcard.c,240 :: 		if(i==(SD_TIME_OUT-1)) return UNUSABLE_CARD;
	MOV	#99, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA Z	L__SD_Init109
	GOTO	L_SD_Init46
L__SD_Init109:
	MOV.B	#18, W0
	GOTO	L_end_SD_Init
L_SD_Init46:
;sdcard.c,235 :: 		for(i = 0; i < SD_TIME_OUT; i++){
	MOV	[W14+0], W1
	ADD	W14, #0, W0
	ADD	W1, #1, [W0]
;sdcard.c,241 :: 		}
	GOTO	L_SD_Init41
L_SD_Init42:
;sdcard.c,242 :: 		} else if (temp == (1<<IDLE_STATE)) {
	GOTO	L_SD_Init47
L_SD_Init40:
; temp start address is: 2 (W1)
	CP.B	W1, #1
	BRA Z	L__SD_Init110
	GOTO	L_SD_Init48
L__SD_Init110:
; temp end address is: 2 (W1)
;sdcard.c,243 :: 		temp_long = Response_32b();
	CALL	_Response_32b
; temp_long start address is: 8 (W4)
	MOV.D	W0, W4
;sdcard.c,244 :: 		temp = (temp_long & ECHO_BACK_MASK);
	MOV	#255, W2
	MOV	#0, W3
	AND	W0, W2, W2
;sdcard.c,245 :: 		if(temp != 0xAA) return ECHO_BACK_ERROR;
	MOV.B	#170, W0
	CP.B	W2, W0
	BRA NZ	L__SD_Init111
	GOTO	L_SD_Init49
L__SD_Init111:
; temp_long end address is: 8 (W4)
	MOV.B	#19, W0
	GOTO	L_end_SD_Init
L_SD_Init49:
;sdcard.c,246 :: 		temp = ((temp_long & VOLTAGE_ACCEPTED_MASK)>>8);
; temp_long start address is: 8 (W4)
	MOV	#3840, W0
	MOV	#0, W1
	AND	W4, W0, W2
	AND	W5, W1, W3
; temp_long end address is: 8 (W4)
	LSR	W2, #8, W0
	SL	W3, #8, W1
	IOR	W0, W1, W0
	LSR	W3, #8, W1
;sdcard.c,247 :: 		if(temp != 0x01) return INCOMPATIBLE_VOLTAGE;
	CP.B	W0, #1
	BRA NZ	L__SD_Init112
	GOTO	L_SD_Init50
L__SD_Init112:
	MOV.B	#20, W0
	GOTO	L_end_SD_Init
L_SD_Init50:
;sdcard.c,250 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	CALL	_SD_Ready
	CP.B	W0, #0
	BRA Z	L__SD_Init113
	GOTO	L_SD_Init51
L__SD_Init113:
	MOV.B	#17, W0
	GOTO	L_end_SD_Init
L_SD_Init51:
;sdcard.c,251 :: 		SD_Send_Command(READ_OCR,0x00000000,0x7E);          // CMD58
	MOV.B	#126, W13
	CLR	W11
	CLR	W12
	MOV.B	#58, W10
	CALL	_SD_Send_Command
;sdcard.c,252 :: 		temp = R1_Response();
	CALL	_R1_Response
; temp start address is: 2 (W1)
	MOV.B	W0, W1
;sdcard.c,253 :: 		if(temp != (1<<IDLE_STATE)) return temp;
	CP.B	W0, #1
	BRA NZ	L__SD_Init114
	GOTO	L_SD_Init52
L__SD_Init114:
	MOV.B	W1, W0
; temp end address is: 2 (W1)
	GOTO	L_end_SD_Init
L_SD_Init52:
;sdcard.c,254 :: 		temp_long = Response_32b();
	CALL	_Response_32b
;sdcard.c,255 :: 		if((temp_long & VOLTAGE_RANGE_MASK) != VOLTAGE_RANGE_MASK)
	MOV	#32768, W2
	MOV	#255, W3
	AND	W0, W2, W2
	AND	W1, W3, W3
	MOV	#32768, W0
	MOV	#255, W1
	CP	W2, W0
	CPB	W3, W1
	BRA NZ	L__SD_Init115
	GOTO	L_SD_Init53
L__SD_Init115:
;sdcard.c,256 :: 		return INCOMPATIBLE_VOLTAGE;
	MOV.B	#20, W0
	GOTO	L_end_SD_Init
L_SD_Init53:
;sdcard.c,259 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	CALL	_SD_Ready
	CP.B	W0, #0
	BRA Z	L__SD_Init116
	GOTO	L_SD_Init54
L__SD_Init116:
	MOV.B	#17, W0
	GOTO	L_end_SD_Init
L_SD_Init54:
;sdcard.c,260 :: 		SD_Send_Command(CRC_ON_OFF,0x00000001,0x41);        // CMD59
	MOV.B	#65, W13
	MOV	#1, W11
	MOV	#0, W12
	MOV.B	#59, W10
	CALL	_SD_Send_Command
;sdcard.c,261 :: 		temp = R1_Response();
	CALL	_R1_Response
; temp start address is: 2 (W1)
	MOV.B	W0, W1
;sdcard.c,262 :: 		if(temp != (1<<IDLE_STATE)) return temp;
	CP.B	W0, #1
	BRA NZ	L__SD_Init117
	GOTO	L_SD_Init55
L__SD_Init117:
	MOV.B	W1, W0
; temp end address is: 2 (W1)
	GOTO	L_end_SD_Init
L_SD_Init55:
;sdcard.c,265 :: 		for(i = 0; i < SD_TIME_OUT; i++){
	CLR	W0
	MOV	W0, [W14+0]
L_SD_Init56:
	MOV	#100, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA GTU	L__SD_Init118
	GOTO	L_SD_Init57
L__SD_Init118:
;sdcard.c,266 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	CALL	_SD_Ready
	CP.B	W0, #0
	BRA Z	L__SD_Init119
	GOTO	L_SD_Init59
L__SD_Init119:
	MOV.B	#17, W0
	GOTO	L_end_SD_Init
L_SD_Init59:
;sdcard.c,267 :: 		SD_Send_Command(APP_CMD,0x00000000,0x32);           // CMD55
	MOV.B	#50, W13
	CLR	W11
	CLR	W12
	MOV.B	#55, W10
	CALL	_SD_Send_Command
;sdcard.c,268 :: 		temp = R1_Response();
	CALL	_R1_Response
;sdcard.c,269 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	CALL	_SD_Ready
	CP.B	W0, #0
	BRA Z	L__SD_Init120
	GOTO	L_SD_Init60
L__SD_Init120:
	MOV.B	#17, W0
	GOTO	L_end_SD_Init
L_SD_Init60:
;sdcard.c,270 :: 		SD_Send_Command(SD_SEND_OP_COND,0x40000000,0x3B);   // ACMD41
	MOV.B	#59, W13
	MOV	#0, W11
	MOV	#16384, W12
	MOV.B	#41, W10
	CALL	_SD_Send_Command
;sdcard.c,271 :: 		temp = R1_Response();
	CALL	_R1_Response
;sdcard.c,272 :: 		if(temp == 0x00) break;  // Initialization done
	CP.B	W0, #0
	BRA Z	L__SD_Init121
	GOTO	L_SD_Init61
L__SD_Init121:
	GOTO	L_SD_Init57
L_SD_Init61:
;sdcard.c,273 :: 		if(i==(SD_TIME_OUT-1)) return UNUSABLE_CARD;
	MOV	#99, W1
	ADD	W14, #0, W0
	CP	W1, [W0]
	BRA Z	L__SD_Init122
	GOTO	L_SD_Init62
L__SD_Init122:
	MOV.B	#18, W0
	GOTO	L_end_SD_Init
L_SD_Init62:
;sdcard.c,265 :: 		for(i = 0; i < SD_TIME_OUT; i++){
	MOV	[W14+0], W1
	ADD	W14, #0, W0
	ADD	W1, #1, [W0]
;sdcard.c,274 :: 		}
	GOTO	L_SD_Init56
L_SD_Init57:
;sdcard.c,275 :: 		}
	GOTO	L_SD_Init63
L_SD_Init48:
;sdcard.c,276 :: 		else return temp;   // Some error of the R1 response type
; temp start address is: 2 (W1)
	MOV.B	W1, W0
; temp end address is: 2 (W1)
	GOTO	L_end_SD_Init
L_SD_Init63:
L_SD_Init47:
;sdcard.c,279 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	CALL	_SD_Ready
	CP.B	W0, #0
	BRA Z	L__SD_Init123
	GOTO	L_SD_Init64
L__SD_Init123:
	MOV.B	#17, W0
	GOTO	L_end_SD_Init
L_SD_Init64:
;sdcard.c,280 :: 		SD_Send_Command(CRC_ON_OFF,0x00000000,0x48);        // CMD59
	MOV.B	#72, W13
	CLR	W11
	CLR	W12
	MOV.B	#59, W10
	CALL	_SD_Send_Command
;sdcard.c,281 :: 		temp = R1_Response();
	CALL	_R1_Response
; temp start address is: 2 (W1)
	MOV.B	W0, W1
;sdcard.c,282 :: 		if(temp != 0x00) return temp;
	CP.B	W0, #0
	BRA NZ	L__SD_Init124
	GOTO	L_SD_Init65
L__SD_Init124:
	MOV.B	W1, W0
; temp end address is: 2 (W1)
	GOTO	L_end_SD_Init
L_SD_Init65:
;sdcard.c,285 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	CALL	_SD_Ready
	CP.B	W0, #0
	BRA Z	L__SD_Init125
	GOTO	L_SD_Init66
L__SD_Init125:
	MOV.B	#17, W0
	GOTO	L_end_SD_Init
L_SD_Init66:
;sdcard.c,286 :: 		SD_Send_Command(SET_BLOCKLEN,0x00000200,0x0A);      // CMD16
	MOV.B	#10, W13
	MOV	#512, W11
	MOV	#0, W12
	MOV.B	#16, W10
	CALL	_SD_Send_Command
;sdcard.c,287 :: 		temp = R1_Response();
	CALL	_R1_Response
; temp start address is: 2 (W1)
	MOV.B	W0, W1
;sdcard.c,288 :: 		if(temp != 0x00) return temp;
	CP.B	W0, #0
	BRA NZ	L__SD_Init126
	GOTO	L_SD_Init67
L__SD_Init126:
	MOV.B	W1, W0
; temp end address is: 2 (W1)
	GOTO	L_end_SD_Init
L_SD_Init67:
;sdcard.c,291 :: 		if(SD_Ready() == 0) return SD_NOT_READY;
	CALL	_SD_Ready
	CP.B	W0, #0
	BRA Z	L__SD_Init127
	GOTO	L_SD_Init68
L__SD_Init127:
	MOV.B	#17, W0
	GOTO	L_end_SD_Init
L_SD_Init68:
;sdcard.c,292 :: 		SD_Send_Command(READ_OCR,0x00000000,0x7E);          // CMD58
	MOV.B	#126, W13
	CLR	W11
	CLR	W12
	MOV.B	#58, W10
	CALL	_SD_Send_Command
;sdcard.c,293 :: 		temp = R1_Response();
	CALL	_R1_Response
; temp start address is: 2 (W1)
	MOV.B	W0, W1
;sdcard.c,294 :: 		if(temp != 0x00) return temp;
	CP.B	W0, #0
	BRA NZ	L__SD_Init128
	GOTO	L_SD_Init69
L__SD_Init128:
	MOV.B	W1, W0
; temp end address is: 2 (W1)
	GOTO	L_end_SD_Init
L_SD_Init69:
;sdcard.c,295 :: 		temp_long = Response_32b();
	CALL	_Response_32b
;sdcard.c,296 :: 		ccs = (long)(temp_long >> 30);
	LSR	W1, #14, W2
	CLR	W3
	MOV	#lo_addr(_ccs), W0
	MOV.B	W2, [W0]
;sdcard.c,299 :: 		Release_SD();
	CALL	_Release_SD
;sdcard.c,301 :: 		SPISD_Init(FAST);
	MOV.B	#1, W10
	CALL	_SPISD_Init
;sdcard.c,303 :: 		return SUCCESSFUL_INIT;
	MOV.B	#170, W0
;sdcard.c,304 :: 		}
;sdcard.c,303 :: 		return SUCCESSFUL_INIT;
;sdcard.c,304 :: 		}
L_end_SD_Init:
	POP	W13
	POP	W12
	POP	W11
	POP	W10
	ULNK
	RETURN
; end of _SD_Init

_R1_Response:

;sdcard.c,314 :: 		unsigned char R1_Response(void){
;sdcard.c,316 :: 		temp = SPISD_Write(0xFF);
	PUSH	W10
	MOV.B	#255, W10
	CALL	_SPISD_Write
;sdcard.c,317 :: 		temp = SPISD_Write(0xFF);
	MOV.B	#255, W10
	CALL	_SPISD_Write
;sdcard.c,318 :: 		return temp;
;sdcard.c,319 :: 		}
;sdcard.c,318 :: 		return temp;
;sdcard.c,319 :: 		}
L_end_R1_Response:
	POP	W10
	RETURN
; end of _R1_Response

_R2_Response:
	LNK	#2

;sdcard.c,329 :: 		unsigned int R2_Response(void){
;sdcard.c,332 :: 		temp = SPISD_Write(0xFF);
	PUSH	W10
	MOV.B	#255, W10
	CALL	_SPISD_Write
;sdcard.c,333 :: 		response = SPISD_Write(0xFF);
	MOV.B	#255, W10
	CALL	_SPISD_Write
	ZE	W0, W0
	MOV	W0, [W14+0]
;sdcard.c,334 :: 		temp = SPISD_Write(0xFF);
	MOV.B	#255, W10
	CALL	_SPISD_Write
;sdcard.c,335 :: 		response = (response<<8)|temp;
	MOV	[W14+0], W1
	SL	W1, #8, W1
	ZE	W0, W0
	IOR	W1, W0, W0
;sdcard.c,336 :: 		return response;
;sdcard.c,337 :: 		}
;sdcard.c,336 :: 		return response;
;sdcard.c,337 :: 		}
L_end_R2_Response:
	POP	W10
	ULNK
	RETURN
; end of _R2_Response

_Response_32b:
	LNK	#4

;sdcard.c,347 :: 		unsigned long Response_32b(void){
;sdcard.c,350 :: 		response = SPISD_Write(0xFF);
	PUSH	W10
	MOV.B	#255, W10
	CALL	_SPISD_Write
	ZE	W0, W0
	CLR	W1
	MOV	W0, [W14+0]
	MOV	W1, [W14+2]
;sdcard.c,351 :: 		temp = SPISD_Write(0xFF);
	MOV.B	#255, W10
	CALL	_SPISD_Write
;sdcard.c,352 :: 		response = (response<<8)|temp;
	MOV	[W14+0], W1
	MOV	[W14+2], W2
	SL	W2, #8, W4
	LSR	W1, #8, W3
	IOR	W3, W4, W4
	SL	W1, #8, W3
	ZE	W0, W1
	CLR	W2
	ADD	W14, #0, W0
	IOR	W3, W1, [W0++]
	IOR	W4, W2, [W0--]
;sdcard.c,353 :: 		temp = SPISD_Write(0xFF);
	MOV.B	#255, W10
	CALL	_SPISD_Write
;sdcard.c,354 :: 		response = (response<<8)|temp;
	MOV	[W14+0], W1
	MOV	[W14+2], W2
	SL	W2, #8, W4
	LSR	W1, #8, W3
	IOR	W3, W4, W4
	SL	W1, #8, W3
	ZE	W0, W1
	CLR	W2
	ADD	W14, #0, W0
	IOR	W3, W1, [W0++]
	IOR	W4, W2, [W0--]
;sdcard.c,355 :: 		temp = SPISD_Write(0xFF);
	MOV.B	#255, W10
	CALL	_SPISD_Write
;sdcard.c,356 :: 		response = (response<<8)|temp;
	MOV	[W14+0], W4
	MOV	[W14+2], W5
	SL	W5, #8, W3
	LSR	W4, #8, W2
	IOR	W2, W3, W3
	SL	W4, #8, W2
	ZE	W0, W0
	CLR	W1
	IOR	W2, W0, W0
	IOR	W3, W1, W1
;sdcard.c,357 :: 		return response;
;sdcard.c,358 :: 		}
;sdcard.c,357 :: 		return response;
;sdcard.c,358 :: 		}
L_end_Response_32b:
	POP	W10
	ULNK
	RETURN
; end of _Response_32b

_SD_Send_Command:

;sdcard.c,368 :: 		void SD_Send_Command(unsigned char command,unsigned long argument, unsigned char crc){
;sdcard.c,369 :: 		SPISD_Write(command |= 0x40);
	PUSH	W10
	ZE	W10, W1
	MOV	#64, W0
	IOR	W1, W0, W0
	MOV.B	W0, W10
	PUSH	W13
	PUSH	W11
	PUSH	W12
	MOV.B	W0, W10
	CALL	_SPISD_Write
	POP	W12
	POP	W11
;sdcard.c,370 :: 		SPISD_Write((unsigned char)(argument>>24));
	LSR	W12, #8, W0
	CLR	W1
	PUSH	W11
	PUSH	W12
	MOV.B	W0, W10
	CALL	_SPISD_Write
	POP	W12
	POP	W11
;sdcard.c,371 :: 		SPISD_Write((unsigned char)(argument>>16));
	MOV	W12, W0
	CLR	W1
	PUSH	W11
	PUSH	W12
	MOV.B	W0, W10
	CALL	_SPISD_Write
	POP	W12
	POP	W11
;sdcard.c,372 :: 		SPISD_Write((unsigned char)(argument>>8));
	LSR	W11, #8, W0
	SL	W12, #8, W1
	IOR	W0, W1, W0
	LSR	W12, #8, W1
	PUSH	W11
	PUSH	W12
	MOV.B	W0, W10
	CALL	_SPISD_Write
	POP	W12
	POP	W11
;sdcard.c,373 :: 		SPISD_Write((unsigned char)(argument));
	MOV.B	W11, W10
	CALL	_SPISD_Write
	POP	W13
;sdcard.c,374 :: 		SPISD_Write((crc<<1)|0x01);
	ZE	W13, W0
	SL	W0, #1, W0
	IOR	W0, #1, W0
	MOV.B	W0, W10
	CALL	_SPISD_Write
;sdcard.c,375 :: 		}
L_end_SD_Send_Command:
	POP	W10
	RETURN
; end of _SD_Send_Command

_SD_Ready:
	LNK	#2

;sdcard.c,386 :: 		unsigned char SD_Ready(void){
;sdcard.c,389 :: 		for(i = 0; i < SD_TIME_OUT; i++){
	PUSH	W10
; i start address is: 4 (W2)
	CLR	W2
; i end address is: 4 (W2)
L_SD_Ready70:
; i start address is: 4 (W2)
	MOV	#100, W0
	CP	W2, W0
	BRA LTU	L__SD_Ready134
	GOTO	L_SD_Ready71
L__SD_Ready134:
;sdcard.c,390 :: 		temp = SPISD_Write(0xFF);
	PUSH	W2
	MOV.B	#255, W10
	CALL	_SPISD_Write
	POP	W2
	MOV.B	W0, [W14+0]
;sdcard.c,391 :: 		if(temp == 0xFF) break;
	MOV.B	#255, W1
	CP.B	W0, W1
	BRA Z	L__SD_Ready135
	GOTO	L_SD_Ready73
L__SD_Ready135:
; i end address is: 4 (W2)
	GOTO	L_SD_Ready71
L_SD_Ready73:
;sdcard.c,392 :: 		if(i == (SD_TIME_OUT-1)) return 0x00;
; i start address is: 4 (W2)
	MOV	#99, W0
	CP	W2, W0
	BRA Z	L__SD_Ready136
	GOTO	L_SD_Ready74
L__SD_Ready136:
; i end address is: 4 (W2)
	CLR	W0
	GOTO	L_end_SD_Ready
L_SD_Ready74:
;sdcard.c,389 :: 		for(i = 0; i < SD_TIME_OUT; i++){
; i start address is: 4 (W2)
	INC	W2
;sdcard.c,393 :: 		}
; i end address is: 4 (W2)
	GOTO	L_SD_Ready70
L_SD_Ready71:
;sdcard.c,394 :: 		return temp;
	MOV.B	[W14+0], W0
;sdcard.c,395 :: 		}
;sdcard.c,394 :: 		return temp;
;sdcard.c,395 :: 		}
L_end_SD_Ready:
	POP	W10
	ULNK
	RETURN
; end of _SD_Ready

_Release_SD:

;sdcard.c,406 :: 		void Release_SD(void){
;sdcard.c,408 :: 		sd_CS_lat = 1;
	BSET	sd_CS_lat, BitPos(sd_CS_lat+0)
;sdcard.c,409 :: 		asm nop;
	NOP
;sdcard.c,410 :: 		}
L_end_Release_SD:
	RETURN
; end of _Release_SD

_Select_SD:

;sdcard.c,421 :: 		void Select_SD(void){
;sdcard.c,423 :: 		sd_CS_lat = 0;
	BCLR	sd_CS_lat, BitPos(sd_CS_lat+0)
;sdcard.c,424 :: 		asm nop;
	NOP
;sdcard.c,425 :: 		}
L_end_Select_SD:
	RETURN
; end of _Select_SD

_SD_Detect:

;sdcard.c,437 :: 		unsigned char SD_Detect(void) {
;sdcard.c,439 :: 		if (sd_detect_port == 0) {
	BTSC	sd_detect_port, BitPos(sd_detect_port+0)
	GOTO	L_SD_Detect75
;sdcard.c,440 :: 		return DETECTED;
	MOV.B	#222, W0
	GOTO	L_end_SD_Detect
;sdcard.c,442 :: 		} else {
L_SD_Detect75:
;sdcard.c,443 :: 		return 0;
	CLR	W0
;sdcard.c,445 :: 		}
L_end_SD_Detect:
	RETURN
; end of _SD_Detect
