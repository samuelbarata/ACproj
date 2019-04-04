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

DISPLAY1		EQU 0A000H  ; (periférico POUT-1)
DISPLAY2		EQU 0C000H  ; (periférico POUT-2)
DISPLAY3		EQU	06000H	; (periférico POUT-3)
TEC_IN			EQU 0E000H  ; endereço do teclado (periférico PIN)
PSCREEN			EQU 8000H   ; endereço do ecrã (pixelscreen)
LINHA			EQU	16		; linha to teclado a testar primeiro



PLACE		1000H

tec_out:	WORD 0

submarino:	
			STRING 0,0,1,1,0
			STRING 0,0,0,1,0
			STRING 1,1,1,1,1

SP_f:		TABLE 100H
SP_init:




PLACE		0
inicializacao:
		MOV	SP 	SP_init


main:
	CALL	teclado


	JMP		main






; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		teclado													│
; │	DESCRICAO:	Verifica que tecla foi primida e guarda na memoria;		│
; │				caso nenhuma tenja cido primida guarda -1				│
; │	OUTPUT:		Tecla para memoria 'tec_out'							│
; ╰─────────────────────────────────────────────────────────────────────╯

teclado:
	init:
	PUSH	R0
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R8


	MOV R5, TEC_IN	; R5 com endereço de memória BUFFER 
	MOV	R1, LINHA	; testar a linha 
	MOV	R2, PINPOUT	; R2 com o endereço do periférico
	MOV R6, tec_out ; Onde se guarda o output do teclado
	MOV R7, -1		; Valor caso nenhuma tecla seja primida

	SHR		R1, 1		; linha do teclado, passa para a seguinte [anterior]
	JZ		load		; se chegou a 0 volta à 1ª
	MOVB 	[R2], R1	; input teclado
	MOVB 	R3, [R2]	; output teclado
	AND 	R3, R3		; afectar as flags (MOVs não afectam as flags) - verifica se alguma tecla foi pressionada
	JZ 		store		; nenhuma tecla premida
	MOV		R4, R3		; guardar tecla premida em registo


	MOV 	R7, 0		; contador linhas
	MOV 	R8, 0		; contador colunas

	linhas:
	CMP		R1, 1		; verifica se o bit de menor peso é 1
	JZ		colunas		; se for vai avaliar a mesma coisa nas linhas
	ADD		R7, 1		; se n for adiciona 1 ao contador
	SHR		R1, 1		; desloca o numero para a direita
	JMP		linhas		; repete até determinar o nº de linhas

	colunas:
	CMP		R4, 1
	JZ		equacao
	ADD		R8, 1
	SHR		R4, 1
	JMP		colunas	

	equacao:			; R7 = 4*linha + coluna
	SHL		R7, 2		; linha * 4
	ADD		R7, R8		; (linha*4) + coluna

	store:
	MOV 	[R6],R7


;#######################################################################
	fim:
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