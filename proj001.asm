;┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;┃				Grupo **				┃
;┞──────────────────────────────────────┦
;│ Alunos:								│
;│	Pedro Tracana			93610		│
;│	Samuel Barata			94230		│
;│	Vasyl Lanko				93622		│
;╰──────────────────────────────────────╯

;																														│Comentários debug para a direita do caracter 120



; ╭─────────────────────────────────────────────────────────────────────╮
; │ Constantes															│
; ╰─────────────────────────────────────────────────────────────────────╯

; 0000H --> 5FFFH	[RAM]
DISPLAY1		EQU 0A000H  ; Displays hexa			(periférico POUT-1)
TEC_IN			EQU 0C000H  ; Input teclado			(periférico POUT-2)
DISPLAY2		EQU	06000H	; Displays hexa extra	(periférico POUT-3)
TEC_OUT			EQU 0E000H  ; endereço do teclado	(periférico PIN)
PSCREEN			EQU 08000H  ; endereço do ecrã		(pixelscreen)
LINHA			EQU	16		; linha to teclado a testar primeiro



PLACE		1000H

key_press:	WORD	0				;tecla primida
			WORD	0				;se no instante anterior uma tecla tinha cido primida								#esta parte ainda n funciona
submarino:	STRING	13,23,6,3		;x, y, Δx, Δy
			STRING	0,0,1,1,0,0
			STRING	0,0,0,1,0,0
			STRING	1,1,1,1,1,1

barco1:		STRING	4,4,8,6
			STRING	0,1,0,0,0,0,0,0
			STRING	0,0,1,0,0,0,0,0
			STRING	0,0,1,0,0,0,0,0
			STRING	1,1,1,1,1,1,1,1
			STRING	0,1,1,1,1,1,1,0
			STRING	0,0,1,1,1,1,0,0

barco2:		STRING	20,5,6,5
			STRING	0,1,0,0,0,0
			STRING	0,0,1,0,0,0
			STRING	0,0,1,0,0,0
			STRING	1,1,1,1,1,1
			STRING	0,1,1,1,1,0

torpedo:	STRING	0,0,1,3
			STRING	1
			STRING	1
			STRING	1

bala:		STRING	0,0,1,1
			STRING	1


SP_final:	TABLE	100H
SP_inicial:




PLACE		0
inicializacao:
	MOV		SP,		SP_inicial
	MOV		R0,		0
	MOV		R1,		0
	MOV		R2,		0
	MOV		R3,		0
	MOV		R4,		0
	MOV		R5,		0
	MOV		R6,		0
	MOV		R7,		0
	MOV		R8,		0
	MOV		R9,		0
	MOV		R10,	0

	MOV		R0,		submarino
	MOV		R1,		1			;escreve
	CALL 	imagem
	MOV		R0,		barco1
	CALL	imagem
	MOV		R0,		barco2
	CALL	imagem

main:
	CALL	teclado
	CALL	processa_teclado

fim:
	JMP		main




; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		teclado													│
; │	DESCRICAO:	Verifica que tecla foi primida e guarda na memoria;		│
; │				caso nenhuma tenja cido primida guarda -1				│
; │	OUTPUT:		Tecla para memoria 'tec_out'							│
; ╰─────────────────────────────────────────────────────────────────────╯

teclado:
  init_teclado:
  	PUSH	R0
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R8

	MOV 	R5, 	TEC_IN		; R5 com endereço de memória Input teclado 
	MOV		R1, 	LINHA		; testar a linha
	MOV		R2, 	TEC_OUT		; R2 com o endereço do periférico
	MOV 	R6, 	key_press	; Onde se guarda o output do teclado
	MOV 	R7, 	-1			; Valor caso nenhuma tecla seja primida

  ciclo_tec:
 	SHR		R1, 	1		; linha do teclado, passa para a seguinte [anterior]
 	JZ		store			; Se estiver a 0 significa que nenhuma das teclas foi primida e guarda -1 na memória
	MOVB 	[R5],	R1		; input teclado
	MOVB 	R3, 	[R2]	; output teclado
	AND 	R3,		R3		; afectar as flags (MOVs não afectam as flags) - verifica se alguma tecla foi pressionada
	JZ 		ciclo_tec		; nenhuma tecla premida
	MOV		R4, 	R3		; guardar tecla premida em registo

	MOV 	R7, 	0		; contador linhas
	MOV 	R8, 	0		; contador colunas

  linhas:
	CMP		R1, 	1		; verifica se o bit de menor peso é 1
	JZ		colunas			; se for vai avaliar a mesma coisa nas linhas
	ADD		R7, 	1		; se n for adiciona 1 ao contador
	SHR		R1, 	1		; desloca o numero para a direita
	JMP		linhas			; repete até determinar o nº de linhas

  colunas:
	CMP		R4, 	1
	JZ		equacao
	ADD		R8, 	1
	SHR		R4, 	1
	JMP		colunas	

  equacao:				; R7 = 4*linha + coluna
	SHL		R7, 	2		; linha * 4
	ADD		R7, 	R8		; (linha*4) + coluna

  store:
	CMP		R7,		-1
	JZ		tecla_nula

  ;se tecla anterior == -1:
	MOV		R8,		R6
	ADD		R8,		2
	MOV		R8,		[R8]	;tecla anterior != -1?
	AND		R8,		R8		;1 => não escrever; 0 => escrever
	JNZ		tecla_anulada

	tecla_valida:
	MOV		[R6],	R7
	ADD		R6,		2
	MOV		R7,		1		;escreve 1 para por na memoria
	MOV		[R6],	R7		;tecla foi primida, manter a 1 até largar
	JMP		fim_teclado

	tecla_anulada:			;ignora a tecla primida pois ainda é a anterior
	MOV		R7,		-1		;mete -1 na memoria para não acontecer nada mas 
	MOV		[R6],	R7		;deixa a tecla anterior a 1 para n escrever até ser largada
	JMP		fim_teclado

	tecla_nula:
	MOV		R7,		-1
	MOV		[R6],	R7
	MOV		R7,		0		;valor pra escrever na memoria
	ADD		R6,		2
	MOV		[R6],	R7		;tecla não foi primida, próxima vez pode escrever
	JMP		fim_teclado


  fim_teclado:
	POP 	R8
	POP		R7
	POP		R6
	POP		R5
	POP		R4
	POP		R3
	POP		R2
	POP		R1
	POP		R0
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		display									   0┌───────▷ X	│
; │	DESCRICAO:	Altera o estado de 1 pixel					│			│
; │				endereços 8000H - 807FH						│			│
; │	INPUT:		coordenadas XR0, YR1, estado do pixelR2		│			│
; │	OUTPUT:		Pixel no pixelscreen						▽ Y			│
; ╰─────────────────────────────────────────────────────────────────────╯
display:
  init_display:
  	PUSH	R0
	PUSH	R1
	PUSH	R2
	PUSH	R4
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R10
  processa:					;byte = screen + (x/4) + 4*y ; pixel = mod(x,8)
  	;R0,	x
  	;R1,	y
  	;R2,	estado
	MOV		R4,		PSCREEN		;endereço base do display
	MOV		R5,		80H			;vai conter a mascara do bit a alterar 80H = 1000 0000
	MOV		R6,		R0			;copia do valor x
	MOV		R7,		8			;Registo para calculos auxiliares
	MOD		R6,		R7			;contem posição do bit [0 - 7]

	ciclo_disp:					;desloca a mascara R5 até ao bit
		AND	R6,		R6
		JZ	next_disp1
		SHR	R5,		1
		SUB	R6,		1
		JMP	ciclo_disp		
	
	next_disp1:
	MOV		R7,		8
	DIV		R0,		R7			;x/8
	MOV		R7,		4
	MUL		R1,		R7			;y*4
	ADD		R4,		R0			;screen + (x/4)
	ADD		R4,		R1			;screen + (x/4) + 4*y

	MOVB	R10,	[R4]		;vai buscar o byte atual para R10
  	AND		R2,		R2			;verifica o bit do estado do pixel e determina se vai ser ligado ou desligado
  	JZ		apaga
  
  escreve:
  	OR		R10,	R5			;modifica o bit para 1
  	JMP		fim_display
  
  apaga:
  	NOT		R5					;inverte a mascara
  	AND		R10,	R5			;escreve 0 no bit
 
  fim_display:
  	MOVB	[R4],	R10			;escreve no display
  	POP		R10
	POP		R7
	POP		R6
	POP		R5
	POP		R4
	POP		R2
	POP		R1
	POP		R0
	RET


; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		imagem													│
; │	DESCRICAO:	Recebe o endereço de uma tabela e desenha o "boneco"	│
; │				Correspondente											│
; │																		│
; │	INPUT:		R0 endereço STRING; R1 escreve/apaga					│
; │	OUTPUT:		Desenho no pixelscreen									│
; ╰─────────────────────────────────────────────────────────────────────╯
imagem:
  init_imagem:
	PUSH	R0
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R8
	PUSH	R9
	PUSH	R10

	MOV		R10,	R0		;endereço tabela
	MOV		R7,		R1		;contem 1 escrever; 0 apagar
	MOV		R0,		0		;vai conter coordenada x
	MOV		R1,		0		;vai conter coordenada y
	MOV		R2,		0		;vai conter [0 apaga / 1 escreve]

	MOVB	R3,		[R10]	;Xinicial
	ADD		R10,		1
	MOVB	R4,		[R10]	;Yinicial
	ADD		R10,		1
	MOVB	R5,		[R10]	;Δx
	ADD		R10,		1
	MOVB	R6,		[R10]	;Δy
main_imagem:
	MOV		R0,		R3				;coordenada x
	MOV		R1,		R4				;coordenada y
	SUB		R1,		1				;o ciclo começa por adicionar 1
	MOV		R8,		R6
	ADD		R8,		R4				;y final
	MOV		R9,		R5
	ADD		R9,		R3				;x final
	ADD		R10,	1				;avança para primeira posição
	
	imagem_linhas:
		ADD		R1,		1					;percorre as linhas até a coordenada final ser igual à ultima escrita
		CMP		R8,		R1					
		JZ		fim_imagem					
		MOV		R0,		R3					
		imagem_colunas:						; percorre as colunas
			MOVB	R2,		[R10]			; vai buscar o bit seguinte à memoria
			AND		R2,		R2				; verifica se o bit está ativo ou não
			JNZ		chamada_display			; Se o bit estiver ativo vai chamar a funcao display
		after_chama_disp:
			ADD		R10,	1				; avança para a posição seguinte de memoria
			ADD		R0,		1				; soma 1 ao x
			CMP		R9,		R0				; vê se já passou do limite de colunas
			JZ		imagem_linhas			; se passou avança linha seguinte
			JMP		imagem_colunas			; se n repete

  chamada_display:
  		MOV		R2,		R7					; escreve 0 ou 1 com base se queremos apagar ou escrever a imagem
		CALL	display						; chama a rotina display com R0 X; R1 Y; R2 [escreve/apaga]
		JMP		after_chama_disp			; volta para a posição anterior

  fim_imagem:						;devolve aos registos os valores originais
	POP		R10
	POP		R9
	POP		R8
	POP		R7
	POP		R6
	POP		R5
	POP		R4
	POP		R3
	POP		R2
	POP		R1
	POP		R0
	RET


; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		processa_teclado										│
; │	DESCRICAO:	analisa o que fazer com base no input do teclado		│
; │				temos de verificar se a ultima tecla primida foi		│
; │				igual ou não											│
; │	INPUT:		0														│
; │	OUTPUT:		0														│
; ├─────────────────────────────┬───────────────────────────────────────╯
; │	0 ↖︎		1 ↑		2 ↗︎		3	│
; │	4 ←		5		6 →		7	│
; │	8 ↙︎		9 ↓		A ↘︎		B ↺	│
; │	C		D		E		F ⬣	│
; ╰─────────────────────────────╯
processa_teclado:
  init_p_teclado:
	PUSH	R0
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R8
	PUSH	R9
	PUSH	R10

  main_p_teclado:
	MOV		R2,		key_press
	MOV		R2,		[R2]		;ultima tecla primida
	
	CMP		R2,		-1			;nenhuma tecla primida
	JZ		fim_p_teclado


	MOV		R4,		0			;tecla [0 a F]
	CMP		R2,		R4			;comparar tecla anterior com tecla em R4
	JZ		c_tec_0
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_1
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_2
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_3
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_4
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_5
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_6
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_7
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_8
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_9
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_A
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_B
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_C
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_D
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_E
	ADD		R4,		1
	CMP		R2,		R4
	JZ		c_tec_F

	c_tec_0:
		CALL	tec_0
		JMP		fim_p_teclado
	c_tec_1:
		CALL	tec_1
		JMP		fim_p_teclado
	c_tec_2:
		CALL	tec_2
		JMP		fim_p_teclado
	c_tec_3:
		CALL	tec_3
		JMP		fim_p_teclado
	c_tec_4:
		CALL	tec_4
		JMP		fim_p_teclado
	c_tec_5:
		CALL	tec_5
		JMP		fim_p_teclado
	c_tec_6:
		CALL	tec_6
		JMP		fim_p_teclado
	c_tec_7:
		CALL	tec_7
		JMP		fim_p_teclado
	c_tec_8:
		CALL	tec_8
		JMP		fim_p_teclado
	c_tec_9:
		CALL	tec_9
		JMP		fim_p_teclado
	c_tec_A:
		CALL	tec_A
		JMP		fim_p_teclado
	c_tec_B:
		CALL	tec_B
		JMP		fim_p_teclado
	c_tec_C:
		CALL	tec_C
		JMP		fim_p_teclado
	c_tec_D:
		CALL	tec_D
		JMP		fim_p_teclado
	c_tec_E:
		CALL	tec_E
		JMP		fim_p_teclado
	c_tec_F:
		CALL	tec_F
		JMP		fim_p_teclado


  fim_p_teclado:
	POP		R10
	POP		R9
	POP		R8
	POP		R7
	POP		R6
	POP		R5
	POP		R4
	POP		R3
	POP		R2
	POP		R1
	POP		R0
	RET


; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_0													│
; │	DESCRICAO:	chamada quando a tecla 0 é primida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		update posição submarino								│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_0:
	PUSH	R1
	PUSH	R5
	PUSH	R0

	MOV		R0,		submarino	;memoria do submarino
	MOV		R1,		0	;apagar
	CALL	imagem		;apaga o submarino
	MOV		R1,		1	;escrever
	;move o submarino
	MOVB	R5,		[R0]
	SUB		R5,		 1		;posição x -1
	MOVB	[R0],	R5
	ADD		R0,		1
	MOVB	R5,		[R0]
	SUB		R5,		 1		;posição	y -1
	MOVB	[R0],	R5
	MOV		R0,		submarino
	CALL	imagem		;escreve o submarino

	POP		R0
	POP		R5
	POP		R1
	RET



; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_1													│
; │	DESCRICAO:	chamada quando a tecla 1 é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		update posição submarino								│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_1:
	PUSH	R1
	PUSH	R5
	PUSH	R0

	MOV		R0,		submarino	;memoria do submarino
	MOV		R1,		0			;apagar
	CALL	imagem				;apaga o submarino
	MOV		R1,		1			;escrever
	;move o submarino
	ADD		R0,		1
	MOVB	R5,		[R0]
	SUB		R5,		 1		;posição	y -1
	MOVB	[R0],	R5
	MOV		R0,		submarino	;imagem a escrever
	MOV		R1,		1			;escrever
	CALL	imagem				

	POP		R0
	POP		R5
	POP		R1
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_2													│
; │	DESCRICAO:	chamada quando a tecla 2 é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		update posição submarino								│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_2:
	PUSH	R1
	PUSH	R5
	PUSH	R0

	MOV		R0,		submarino	;memoria do submarino
	MOV		R1,		0	;apagar
	CALL	imagem		;apaga o submarino
	MOV		R1,		1	;escrever
	;move o submarino
	MOVB	R5,		[R0]
	ADD		R5,		 1		;posição x +1
	MOVB	[R0],	R5
	ADD		R0,		1
	MOVB	R5,		[R0]
	SUB		R5,		 1		;posição	y -1
	MOVB	[R0],	R5
	MOV		R0,		submarino	;imagem a escrever
	MOV		R1,		1			;escrever
	CALL	imagem		;escreve o submarino

	POP		R0
	POP		R5
	POP		R1
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_3													│
; │	DESCRICAO:	chamada quando a tecla 3 é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		N/A														│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_3:
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_4													│
; │	DESCRICAO:	chamada quando a tecla 4 é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		update posição submarino								│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_4:
	PUSH	R1
	PUSH	R5
	PUSH	R0

	MOV		R0,		submarino	;memoria do submarino
	MOV		R1,		0	;apagar
	CALL	imagem		;apaga o submarino
	MOV		R1,		1	;escrever
	;move o submarino
	MOVB	R5,		[R0]
	SUB		R5,		 1		;posição x -1
	MOVB	[R0],	R5
	MOV		R0,		submarino	;imagem a escrever
	MOV		R1,		1			;escrever
	CALL	imagem		;escreve o submarino

	POP		R0
	POP		R5
	POP		R1
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_5													│
; │	DESCRICAO:	chamada quando a tecla 5 é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		N/A														│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_5:
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_6													│
; │	DESCRICAO:	chamada quando a tecla 6 é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		update posição submarino								│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_6:
	PUSH	R1
	PUSH	R5
	PUSH	R0

	MOV		R0,		submarino	;memoria do submarino
	MOV		R1,		0	;apagar
	CALL	imagem		;apaga o submarino
	MOV		R1,		1	;escrever
	;move o submarino
	MOVB	R5,		[R0]
	ADD		R5,		 1		;posição x -1
	MOVB	[R0],	R5
	MOV		R0,		submarino	;imagem a escrever
	MOV		R1,		1			;escrever
	CALL	imagem		;escreve o submarino

	POP		R0
	POP		R5
	POP		R1
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_7													│
; │	DESCRICAO:	chamada quando a tecla 7 é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		N/A														│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_7:
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_8													│
; │	DESCRICAO:	chamada quando a tecla 8 é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		update posição submarino								│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_8:
	PUSH	R1
	PUSH	R5
	PUSH	R0

	MOV		R0,		submarino	;memoria do submarino
	MOV		R1,		0	;apagar
	CALL	imagem		;apaga o submarino
	MOV		R1,		1	;escrever
	;move o submarino
	MOVB	R5,		[R0]
	SUB		R5,		 1		;posição x -1
	MOVB	[R0],	R5
	ADD		R0,		1
	MOVB	R5,		[R0]
	ADD		R5,		 1		;posição	y -1
	MOVB	[R0],	R5
	MOV		R0,		submarino	;imagem a escrever
	MOV		R1,		1			;escrever
	CALL	imagem		;escreve o submarino

	POP		R0
	POP		R5
	POP		R1
	RET


; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_9													│
; │	DESCRICAO:	chamada quando a tecla 9 é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		update posição submarino								│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_9:
	PUSH	R1
	PUSH	R5
	PUSH	R0

	MOV		R0,		submarino	;memoria do submarino
	MOV		R1,		0			;apagar
	CALL	imagem				;apaga o submarino
	MOV		R1,		1			;escrever
	;move o submarino
	ADD		R0,		1
	MOVB	R5,		[R0]
	ADD		R5,		 1		;posição	y -1
	MOVB	[R0],	R5
	MOV		R0,		submarino	;imagem a escrever
	MOV		R1,		1			;escrever
	CALL	imagem		;escreve o submarino

	POP		R0
	POP		R5
	POP		R1
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_A													│
; │	DESCRICAO:	chamada quando a tecla A é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		update posição submarino								│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_A:
	PUSH	R1
	PUSH	R5
	PUSH	R0

	MOV		R0,		submarino	;memoria do submarino
	MOV		R1,		0	;apagar
	CALL	imagem		;apaga o submarino
	MOV		R1,		1	;escrever
	;move o submarino
	MOVB	R5,		[R0]
	ADD		R5,		 1		;posição x -1
	MOVB	[R0],	R5
	ADD		R0,		1
	MOVB	R5,		[R0]
	ADD		R5,		 1		;posição	y -1
	MOVB	[R0],	R5
	MOV		R0,		submarino	;imagem a escrever
	MOV		R1,		1			;escrever
	CALL	imagem		;escreve o submarino

	POP		R0
	POP		R5
	POP		R1
	RET


; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_B													│
; │	DESCRICAO:	chamada quando a tecla B é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		N/A														│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_B:
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_C													│
; │	DESCRICAO:	chamada quando a tecla C é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		N/A														│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_C:
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_D													│
; │	DESCRICAO:	chamada quando a tecla D é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		N/A														│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_D:
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_E													│
; │	DESCRICAO:	chamada quando a tecla E é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		N/A														│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_E:
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		tec_F													│
; │	DESCRICAO:	chamada quando a tecla F é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		N/A														│
; ╰─────────────────────────────────────────────────────────────────────╯
tec_F:
	RET

