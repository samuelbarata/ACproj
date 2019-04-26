;┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;┃				Grupo 09				┃
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
PIN				EQU 0E000H  ; endereço do teclado + relogios (periférico PIN)
PSCREEN			EQU 08000H  ; endereço do ecrã		(pixelscreen)
LINHA			EQU	16		; linha to teclado a testar primeiro
NMEXESUB		EQU 2		; valor no qual o teclado n move o sub.
submarinoXI		EQU	9		;posição inicial submarino
submarinoYI		EQU	20


PLACE		1000H

key_press:	WORD	0				;tecla primida
			WORD	0				;se no instante anterior uma tecla tinha cido primida

table_char:	STRING	-1,	-1			;0	↖︎
			STRING	0,	-1			;1	↑
			STRING	1,	-1			;2	↗︎
			STRING	0,	NMEXESUB	;3
			STRING	-1,	0			;4	←
			STRING	0,	NMEXESUB	;5
			STRING	1,	0			;6	→
			STRING	0,	NMEXESUB	;7
			STRING	-1,	1			;8	↙︎
			STRING	0,	1			;9	↓
			STRING	1,	1			;A	↘︎
			STRING	0,	NMEXESUB	;B	↺
			STRING	0,	NMEXESUB	;C
			STRING	0,	NMEXESUB	;D
			STRING	0,	NMEXESUB	;E
			STRING	0,	NMEXESUB	;F	⬣


submarino:	STRING	9,20,6,3		;x, y, largura do submarino (Δx), comprimento (Δy)
			STRING	0,0,1,1,0,0
			STRING	0,0,0,1,0,0
			STRING	1,1,1,1,1,1

barco1:		STRING	1,2,8,6			;x, y, Δx, Δy
			STRING	0,1,0,0,0,0,0,0
			STRING	0,0,1,0,0,0,0,0
			STRING	0,0,1,0,0,0,0,0
			STRING	1,1,1,1,1,1,1,1
			STRING	0,1,1,1,1,1,1,0
			STRING	0,0,1,1,1,1,0,0

barco2:		STRING	20,3,6,5		;x, y, Δx, Δy
			STRING	0,1,0,0,0,0
			STRING	0,0,1,0,0,0
			STRING	0,0,1,0,0,0
			STRING	1,1,1,1,1,1
			STRING	0,1,1,1,1,0

torpedo:	STRING	10,16,1,3		;x, y, Δx, Δy
			STRING	1
			STRING	1
			STRING	1

bala:		STRING	1,21,1,1		;x, y, Δx, Δy
			STRING	1


SP_final:	TABLE	100H
SP_inicial:

inicio:
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H



fim_jogo:
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 07H, 1CH, 6CH, 00H
		STRING 04H, 08H, 54H, 00H
		STRING 06H, 08H, 54H, 00H
		STRING 04H, 08H, 44H, 00H
		STRING 04H, 08H, 44H, 00H
		STRING 04H, 1CH, 44H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 23H, 0CH, 30H
		STRING 00H, 24H, 90H, 48H
		STRING 00H, 24H, 90H, 48H
		STRING 00H, 24H, 96H, 48H
		STRING 01H, 24H, 92H, 48H
		STRING 00H,	0C3H, 0CH, 30H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H
		STRING 00H, 00H, 00H, 00H

; Tabela de vectores de interrupção																						[n percebo isto]
tab:		WORD	rot0

PLACE		0
inicializacao:
	MOV		SP,		SP_inicial
	MOV		BTE,	tab			;interrupções																			[n percebo isto]
	CALL	reset_all			;faz reset a todas as variaveis do jogo

main:
	CALL	teclado				;lê input
	CALL	processa_teclado	;analisa input
	
	AND		R0,	R0
	JZ		fim_main
	CMP		R0,	1
	JZ 		inicializacao

	CALL	relogios			;verifica ciclos de relogio
	
	JMP		main				;repete o ciclo principal
fim_main:
	PUSH	R0					;guarda o estado do jogo na pilha
	MOV		R0,		fim_jogo
	CALL	ecra				;imprime ecra fim de jogo
	POP		R0
fim:
	CALL	teclado
	CALL	processa_teclado
	CMP		R0,		1			;0 == ⬣; 1 == inicializacao; outro == decorrer jogo
	JZ		inicializacao
	JMP		fim					;acaba o programa



; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		teclado													│
; │	DESCRICAO:	Verifica que tecla foi primida e guarda na memoria;		│
; │				caso nenhuma tenja cido primida guarda -1				│
; │	OUTPUT:		Tecla para memoria 'key_press'							│
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
	MOV		R2, 	PIN			; R2 com o endereço do periférico
	MOV 	R6, 	key_press	; Onde se guarda o output do teclado
	MOV 	R7, 	-1			; Valor caso nenhuma tecla seja primida

  ciclo_tec:
 	SHR		R1, 	1		; linha do teclado, passa para a seguinte [anterior]
 	JZ		store			; Se estiver a 0 significa que nenhuma das teclas foi primida e guarda -1 na memória
	MOVB 	[R5],	R1		; input teclado
	MOVB 	R3, 	[R2]	; output teclado
	MOV		R4,		00001111b	;mascara bits teclado
	AND		R3,		R4		;isola os bits do teclado
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
; │	INPUT:		N/A														│
; │	OUTPUT:		R0, estado do jogo										│
; ├─────────────────────────────┬───────────────────────────────────────╯
; │	0 ↖︎		1 ↑		2 ↗︎		3	│
; │	4 ←		5		6 →		7	│
; │	8 ↙︎		9 ↓		A ↘︎		B ↺	│
; │	C		D		E		F ⬣	│
; ╰─────────────────────────────╯
processa_teclado:
  init_p_teclado:
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


	MOV		R4,		11			;B
	CMP		R2,		R4
	JZ		init_p				;inicializacao

	MOV		R4,		15			;F
	CMP		R2,		R4
	JZ		stop_p				;fim jogo

	AND		R0,		R0	;se o jogo estiver parado o movimento não ocorre
	JZ		fim_p_teclado

	CALL	movimento
	JMP		fim_p_teclado

  stop_p:
	MOV		R0,		0
	JMP		fim_p_teclado
  init_p:
	MOV		R0,		1




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
	RET



; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		movimento												│
; │	DESCRICAO:	chamada quando a tecla F é premida						│
; │				Correspondente											│
; │																		│
; │	INPUT:		tecla premida em R2										│
; │	OUTPUT:		N/A														│
; ╰─────────────────────────────────────────────────────────────────────╯
movimento:
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

	MOV		R3,		table_char

  m_ciclo:				;traduz tecla primida em movimento
	SHL		R2, 	1		;multiplica por 2
	ADD		R3,		R2		;posição de memoria do movimento
	MOV		R3,		[R3]	;buscar movimentação sub
	CMP		R3, 	NMEXESUB
	JZ		fim_movimento

	CALL	verifica_movimentos
	AND		R1,		R1
	JZ		fim_movimento

	MOV		R0,		submarino	;memoria do submarino
	MOV		R1,		0	;apagar
	CALL	imagem		;apaga o submarino
	MOV		R1,		1	;escrever
	MOV		R4,		table_char
	ADD		R4,		R2
	;move o submarino
	MOVB	R3,		[R4]
	MOVB	R5,		[R0]
	ADD		R5,		R3		;posição x + 
	MOVB	[R0],	R5
	ADD		R0,		1
	ADD		R4,		1
	MOVB	R3,		[R4]
	MOVB	R5,		[R0]
	ADD		R5,		R3		;posição y +
	MOVB	[R0],	R5

	MOV		R0,		submarino	;imagem a escrever
	MOV		R1,		1			;escrever
	CALL	imagem		;escreve o submarino



  fim_movimento:
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
; │	ROTINA:		ecra													│
; │	DESCRICAO:	Recebe o endereço de um desenho de um ecra inteiro		│
; │				e desenha-o todo, mais eficiente que rotina imagem		│
; │				dado que imprime byte a byte							│
; │																		│
; │	INPUT:		R0 endereço STRING										│
; │	OUTPUT:		Desenho no pixelscreen									│
; ╰─────────────────────────────────────────────────────────────────────╯
ecra:
	PUSH	R0
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	MOV		R1,		PSCREEN
	MOV		R2,		0
	MOV		R4, 	40H			;nº bytes ecra
	ecra_ciclo:
		MOV		R3,		[R0]	;byte a escrever
		MOV		[R1],	R3		;escreve o byte
		ADD		R2,		1		;contador
		ADD		R0,		2		;avança para o byte seguinte memoria
		ADD		R1,		2		;avança para o byte seguinte ecra
		CMP		R2,		R4		;verifica se já chegou ao fim do ecra [128 bytes]
		JNZ		ecra_ciclo
	POP		R4
	POP		R3
	POP		R2
	POP		R1
	POP		R0
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		relogios												│
; │	DESCRICAO:															│
; │	INPUT:		relógio 1/2 [PIN]										│
; │	OUTPUT:																│
; ╰─────────────────────────────────────────────────────────────────────╯
relogios:
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

	MOV		R0,		PIN			;endereço dos relogios
	MOVB	R0,		[R0]
	MOV		R1,		00010000b	;relogio 1 mascara
	MOV		R2,		00100000b	;relogio 2 mascara
	AND		R1,		R0			;relogio 1
	AND		R2,		R0			;relogio 2
clk1:
	SHR		R1,		4
	JZ		clk2


clk2:
	SHR		R2,		5

fim_relogios:
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
; │	ROTINA:		reset_all												│
; │	DESCRICAO:	No inicio do jogo faz reset a tudo						│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		Registos, Displays										│
; ╰─────────────────────────────────────────────────────────────────────╯
reset_all:

	MOV		R1,		0
	MOV		R0,		inicio		;tudo a 0
	CALL	ecra				;Apaga todo o conteudo do ecra

	MOV		R0,		DISPLAY1
	MOVB	[R0],	R1			;ecreve 0
	MOV		R0,		DISPLAY2
	MOVB	[R0],	R1			;escreve 0


	MOV		R0,		submarino
	MOV		R1,		submarinoXI	;x inicial
	MOVB	[R0],	R1

	MOV		R1,		submarinoYI	;y inicial
	ADD		R0,		1
	MOVB	[R0],	R1


	MOV		R0,		submarino	;imagem
	MOV		R1,		1			;escreve
	CALL 	imagem				;Imprime o submarino
	MOV		R0,		barco1
	CALL	imagem				;Imprime o barco 1
	MOV		R0,		barco2
	CALL	imagem				;Imprime o barco 2

	MOV		R0,		2			;0 == ⬣; 1 == inicializacao; outro == decorrer jogo
	MOV		R1,		0			;apaga todo o conteudo dos registos
	MOV		R2,		0
	MOV		R3,		0
	MOV		R4,		0
	MOV		R5,		0
	MOV		R6,		0
	MOV		R7,		0
	MOV		R8,		0
	MOV		R9,		0
	MOV		R10,	0

	RET


; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		verifica_movimentos										│
; │	DESCRICAO:	verifica se o submarino pode mexer ou sai do ecrã		│
; │																		│
; │	INPUT:		tecla premida em R2										│
; │	OUTPUT:		R1 0 = não mexe											│
; ╰─────────────────────────────────────────────────────────────────────╯
verifica_movimentos:
	PUSH	R0
	POP		R0
	RET





















;----------interrupções?-------------------																				Não percebo
rot0:
	PUSH	R10
	PUSH	R9
	MOV		R10,	DISPLAY2
	MOVB	R9,		[R10]
	ADD		R9,		1
	MOVB	[R10],	R9
	POP		R9
	POP		R10
	RET
