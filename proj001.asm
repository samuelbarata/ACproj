;┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;┃				Grupo **				┃
;┞──────────────────────────────────────┦
;│ Alunos:								│
;│	Pedro Tracana			93610		│
;│	Samuel Barata			94230		│
;│	Vasyl Lanko				93622		│
;╰──────────────────────────────────────╯




; ╭─────────────────────────────────────────────────────────────────────╮
; │ Constantes															│
; ╰─────────────────────────────────────────────────────────────────────╯

; 0000H --> 5FFFH	[RAM]
DISPLAY1		EQU 0A000H  ; Displays hexa			(periférico POUT-1)
TEC_IN			EQU 0C000H  ; Input teclado			(periférico POUT-2)
DISPLAY2		EQU	06000H	; Displays hexa extra	(periférico POUT-3)
TEC_OUT			EQU 0E000H  ; endereço do teclado	(periférico PIN)
PSCREEN			EQU 08000H   ; endereço do ecrã		(pixelscreen)
LINHA			EQU	16		; linha to teclado a testar primeiro



PLACE		1000H

key_press:	WORD	0
xx:			WORD	0
yy:			WORD	0
status:		WORD	1

submarino:	STRING	5,3,0,0		;largura, altura, posição x, y
			STRING	0,0,1,1,0
			STRING	0,0,0,1,0
			STRING	1,1,1,1,1

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

main:
	;CALL	teclado
	MOV		R0,		xx
	MOV		R0,		[R0]
	MOV		R1,		yy
	MOV		R1,		[R1]
	MOV		R2,		status
	MOV		R2,		[R2]

	CALL 	display

	JMP		main

fim:
	JMP		fim





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

  debug:;################################################################################################################
  	PUSH	R0
  	MOV		R0,		DISPLAY2
  	MOVB	[R0],	R7
  	POP		R0
  ;######################################################################################################################
  store:
	MOV 	[R6],	R7


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
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R8
	PUSH	R9
	PUSH	R10
  processa:					;byte = screen + (x/4) + 4*y ; pixel = mod(x,8)
  	;R0,	x
  	;R1,	y
  	;R2,	estado
  	MOV		R3,		0			;byte que vai ser alterado
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
	
	next_disp1:																											;Certo até aqui
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
  	XOR		R5,		R5			;inverte a mascara
  	AND		R10,	R5			;escreve 0 no bit

  

  fim_display:
  	MOVB	[R4],	R10			;escreve no display
  	POP		R10
  	POP		R9
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


