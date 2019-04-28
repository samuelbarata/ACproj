;┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
;┃				Grupo 09				┃
;┞──────────────────────────────────────┦
;│ Alunos:								│
;│	Pedro Tracana			93610		│
;│	Samuel Barata			94230		│
;│	Vasyl Lanko				93622		│
;├──────────────────────────────┬───────╯
;│	0 ↖︎		1 ↑		2 ↗︎		3	│
;│	4 ←		5 ✼		6 →		7	│
;│	8 ↙︎		9 ↓		A ↘︎		B ↺	│
;│	C		D		E		F ⬣	│
;╰──────────────────────────────╯


;		🚨⚠️O MEU PC NÃO CONSEGUE CORRER OS CLOCK, NÃO TESTEI BUÉS CENAS⚠️🚨

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
NMEXESUB		EQU 2		; valor no qual o teclado não move o sub.
submarinoXI		EQU	9		; submarino posição inicial
submarinoYI		EQU	20
barco1XI		EQU	5		; barco1 posição inicial
barco1YI		EQU	1		
barco2XI		EQU	25		; barco2 posição inicial
barco2YI		EQU	8
sub_max_x		EQU	31		; barreiras invisíveis do submarino
sub_min_x		EQU	0
sub_max_y		EQU	31
sub_min_y		EQU	15
bar_max_x		EQU	31		; barreiras invisíveis dos barcos
bar_min_x		EQU	0

; ╭─────────────────────────────────────────────────────────────────────╮
; │ Memória																│
; ╰─────────────────────────────────────────────────────────────────────╯

PLACE		1000H

key_press:	WORD	0				;tecla primida
			WORD	0				;se no instante anterior uma tecla tinha cido primida (0[escrever]/1[não escrever])

display_valor_1:
			WORD	0
display_valor_2:
			WORD	0

table_char:						;movimentos do submarino
			STRING	-1,	-1			;0	↖︎
			STRING	0,	-1			;1	↑
			STRING	1,	-1			;2	↗︎
			STRING	0,	NMEXESUB	;3
			STRING	-1,	0			;4	←
			STRING	0,	NMEXESUB	;5	✼
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

submarino:	STRING	9,20,6,3,1,0		;x, y, largura do submarino (Δx), comprimento (Δy), ativo?, N/A
			STRING	0,0,1,1,0,0
			STRING	0,0,0,1,0,0
			STRING	1,1,1,1,1,1

barco1:		STRING	1,2,8,6,1,0			;x, y, Δx, Δy, ativo?, N/A
			STRING	0,1,0,0,0,0,0,0
			STRING	0,0,1,0,0,0,0,0
			STRING	0,0,1,0,0,0,0,0
			STRING	1,1,1,1,1,1,1,1
			STRING	0,1,1,1,1,1,1,0
			STRING	0,0,1,1,1,1,0,0

barco2:		STRING	20,9,6,5,1,0		;x, y, Δx, Δy, ativo?, N/A
			STRING	0,1,0,0,0,0
			STRING	0,0,1,0,0,0
			STRING	0,0,1,0,0,0
			STRING	1,1,1,1,1,1
			STRING	0,1,1,1,1,0

torpedo:	STRING	10,16,1,3,0,0		;x, y, Δx, Δy, estado [ativo/inativo], ativo?, N/A
			STRING	1
			STRING	1
			STRING	1

bala:		STRING	1,21,1,1,0,0		;x, y, Δx, Δy, estado [ativo/inativo], ativo?, N/A
			STRING	1

; Tabela de vectores de interrupção																						[n percebo isto]
tab:		WORD	rot0
			WORD	rot1

SP_final:	TABLE	100H
SP_inicial:


; ╭─────────────────────────────────────────────────────────────────────╮
; │ ecrãs																│
; ╰─────────────────────────────────────────────────────────────────────╯
inicio:								;ecrã apagado
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

fim_jogo:							;ecrã ganhar jogo
		STRING 000H, 000H, 000H, 000H
		STRING 077H, 06CH, 048H, 0C4H
		STRING 042H, 054H, 055H, 00AH
		STRING 062H, 044H, 055H, 06AH
		STRING 042H, 045H, 055H, 02AH
		STRING 047H, 044H, 088H, 0C4H
		STRING 000H, 000H, 000H, 000H
		STRING 000H, 000H, 000H, 000H
		STRING 000H, 000H, 000H, 000H
		STRING 000H, 000H, 000H, 000H
		STRING 000H, 000H, 000H, 000H
		STRING 000H, 000H, 000H, 000H
		STRING 000H, 000H, 030H, 000H
		STRING 000H, 000H, 020H, 000H
		STRING 000H, 000H, 020H, 000H
		STRING 000H, 000H, 0F8H, 000H
		STRING 000H, 000H, 0F8H, 000H
		STRING 000H, 000H, 0F8H, 000H
		STRING 000H, 007H, 0FEH, 000H
		STRING 000H, 01FH, 0FFH, 080H
		STRING 008H, 07FH, 0FFH, 0E0H
		STRING 00CH, 0FFH, 0FFH, 0F0H
		STRING 00FH, 0FDH, 0CEH, 0F8H
		STRING 03FH, 0F8H, 084H, 07CH
		STRING 00FH, 0FDH, 0CEH, 0F8H
		STRING 009H, 0FFH, 0FFH, 0F0H
		STRING 00BH, 0FFH, 0FFH, 0E0H
		STRING 01AH, 03FH, 0FFH, 080H
		STRING 018H, 00FH, 0FEH, 000H
		STRING 018H, 003H, 0F8H, 000H
		STRING 000H, 000H, 0E0H, 000H
		STRING 000H, 000H, 000H, 000H
dino:								;perder jogo
		STRING 000H, 000H, 000H, 000H
		STRING 000H, 000H, 03FH, 0F8H
		STRING 000H, 000H, 07FH, 0FCH
		STRING 000H, 000H, 067H, 0FCH
		STRING 000H, 000H, 067H, 0FCH
		STRING 000H, 000H, 07FH, 0FCH
		STRING 000H, 000H, 07FH, 0FCH
		STRING 000H, 000H, 07FH, 0FCH
		STRING 000H, 000H, 07EH, 000H
		STRING 000H, 000H, 07EH, 000H
		STRING 000H, 000H, 07FH, 0F0H
		STRING 000H, 000H, 07CH, 000H
		STRING 010H, 001H, 0FCH, 000H
		STRING 010H, 007H, 0FCH, 000H
		STRING 010H, 01FH, 0FFH, 080H
		STRING 018H, 01FH, 0FCH, 080H
		STRING 01CH, 03FH, 0FCH, 000H
		STRING 01FH, 0FFH, 0FCH, 000H
		STRING 01FH, 0FFH, 0FCH, 000H
		STRING 01FH, 0FFH, 0FCH, 000H
		STRING 00FH, 0FFH, 0F8H, 000H
		STRING 007H, 0FFH, 0F8H, 000H
		STRING 001H, 0FFH, 0E0H, 000H
		STRING 001H, 0FFH, 0E0H, 000H
		STRING 000H, 0FFH, 0C0H, 000H
		STRING 000H, 039H, 0C0H, 000H
		STRING 000H, 039H, 0C0H, 000H
		STRING 000H, 020H, 040H, 000H
		STRING 000H, 020H, 040H, 000H
		STRING 000H, 020H, 040H, 000H
		STRING 000H, 030H, 060H, 000H
		STRING 000H, 000H, 000H, 000H

PLACE		0
inicializacao:
	MOV		SP,		SP_inicial
	MOV		BTE,	tab			;interrupções																			[n percebo isto]
	CALL	reset_all			;faz reset a todas as variaveis, ecrãs, registos
main:
	CALL	teclado				;lê input
	CALL	processa_teclado	;analisa input
	
	AND		R0,	R0
	JZ		fim_main			;verifica estado jogo
	CMP		R0,	1
	JZ 		inicializacao

	JMP		main				;repete o ciclo principal
fim_main:
	DI
	PUSH	R0					;guarda o estado do jogo na pilha
	PUSH	R1

	MOV		R1,		display_valor_1
	MOV		R0,		0099H
	CMP		R1,		R0		;verifica se o jogador chegou aos 99
	JZ		ganha
  perde:						;perde o jogo
	MOV		R0,		dino
	JMP		fm_cont
  ganha:						;ganha o jogo
  	MOV		R0,		fim_jogo
  fm_cont:
	CALL	ecra				;imprime ecra fim de jogo
	
	POP		R1
	POP		R0					;retorna o estado do jogo
fim:
	CALL	teclado				
	CALL	processa_teclado	;verifica se a tecla de recomeçar foi primida
	CMP		R0,		1			;0 == ⬣; 1 == inicializacao
	JZ		inicializacao
	JMP		fim					;acaba o programa



; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		teclado													│
; │	DESCRICAO:	Verifica que tecla foi primida e guarda na memoria;		│
; │				caso nenhuma tenha cido primida guarda -1				│
; │																		│
; │	INPUT:		periférico PIN											│
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
	MOV		R4,		00001111b	; mascara bits teclado
	AND		R3,		R4		; isola os bits do teclado dos do relógio
	AND 	R3,		R3		; afectar as flags (MOVs não afectam as flags) - verifica se alguma tecla foi pressionada
	JZ 		ciclo_tec		; nenhuma tecla premida
	MOV		R4, 	R3		; guardar tecla premida em registo

	MOV 	R7, 	0		; contador linhas
	MOV 	R8, 	0		; contador colunas

  linhas:
	CMP		R1, 	1		; verifica se o bit de menor peso é 1
	JZ		colunas			; se for vai avaliar a mesma coisa nas linhas
	ADD		R7, 	1		; se não for adiciona 1 ao contador
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

	tecla_valida:		;guarda a tecla em memoria se a mesma for válida
	MOV		[R6],	R7
	ADD		R6,		2
	MOV		R7,		1		;escreve 1 para por na memoria
	MOV		[R6],	R7		;tecla foi primida, manter a 1 até largar
	JMP		fim_teclado

	tecla_anulada:			;ignora a tecla primida pois ainda é a anterior
	MOV		R7,		-1		;mete -1 na memoria para não acontecer nada mas 
	MOV		[R6],	R7		;deixa a tecla anterior a 1 para não escrever até ser largada
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
; │	INPUT:		Coordenadas X-R0, Y-R1, estado do pixel-R2	│			│
; │	OUTPUT:		Periférico pixelscreen						▽ Y			│
; ╰─────────────────────────────────────────────────────────────────────╯
display:
  init_display:
	PUSH	R0			;contem x
	PUSH	R1			;contem y
	PUSH	R2			;contem o estado (0-apaga/1-escreve)
	PUSH	R4
	PUSH	R5
	PUSH	R6
	PUSH	R7
	PUSH	R10
						;byte = screen + (x/4) + 4*y ; pixel = mod(x,8)
	MOV		R4,		PSCREEN		;endereço base do display
	MOV		R5,		80H			;vai conter a mascara do bit a alterar 80H = 1000 0000
	MOV		R6,		R0			;copia do valor x
	MOV		R7,		8			;Registo para calculos auxiliares
	MOD		R6,		R7			;contem posição do bit [0 - 7]

	ciclo_disp:				;desloca a mascara R5 até ao bit
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
; │	INPUT:		R0 endereço STRING; R1 1-escreve/0-apaga				│
; │	OUTPUT:		Periférico pixelscreen									│
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
	MOV		R7,		R1		;escreve/apaga imagem
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
	ADD		R10,	3				;avança para primeira posição
	
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
			JMP		imagem_colunas			; se não repete

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
; │	DESCRICAO:	Analisa o que fazer com base no input do teclado		│
; │				temos de verificar se a ultima tecla primida foi		│
; │				igual ou não											│
; │																		│
; │	INPUT:		Memória 'key_press'										│
; │	OUTPUT:		R0, estado do jogo										│
; │	DESTROI:	R0														│
; ├─────────────────────────────┬───────────────────────────────────────╯
; │	0 ↖︎		1 ↑		2 ↗︎		3	│
; │	4 ←		5 ✼		6 →		7	│
; │	8 ↙︎		9 ↓		A ↘︎		B ↺	│
; │	C		D		E		F ⬣	│
; ╰─────────────────────────────╯
processa_teclado:
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
	JZ		stop_p				;fim do jogo

	AND		R0,		R0			;se o jogo estiver parado o movimento não ocorre
	JZ		fim_p_teclado

	CALL	movimento			;movimenta submarino
	
	MOV		R10,	torpedo_cria
	CALL	R10					;se a tecla 5 for primida é criado um torpedo
	
	JMP		fim_p_teclado

  stop_p:
	MOV		R0,		0			;atualiza o estado do jogo para parado
	JMP		fim_p_teclado
  init_p:
	MOV		R0,		1			;atualiza o estado do jogo para inicialização

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
; │	DESCRICAO:	Movimenta o submarino									│
; │																		│
; │	INPUT:		tecla premida em R2										│
; │	OUTPUT:		Periférico pixelscreen									│
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

	CALL	verifica_movimentos	;verifica se o submarino vai sair do ecrã se o movimento acontecer
	AND		R1,		R1
	JZ		fim_movimento

	MOV		R0,		submarino	;memoria do submarino
	MOV		R1,		0			;apagar
	CALL	imagem				;apaga o submarino
	MOV		R1,		1			;escrever
	MOV		R4,		table_char
	ADD		R4,		R2			;linha que contem o movimento
	;move o submarino
	MOVB	R3,		[R4]		;deslocação em x
	MOVB	R5,		[R0]		;x atual
	ADD		R5,		R3		;posição x + R3
	MOVB	[R0],	R5		;escreve nova posição
	ADD		R0,		1			;memoria posição y
	ADD		R4,		1			;memoria deslocação em y
	MOVB	R3,		[R4]		;deslocação em y
	MOVB	R5,		[R0]		;posição y atual
	ADD		R5,		R3		;posição y + R3
	MOVB	[R0],	R5		;escreve nova posição

	MOV		R0,		submarino	;imagem a escrever
	MOV		R1,		1			;escrever
	CALL	imagem			;escreve o submarino

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
; │	OUTPUT:		Periférico pixelscreen									│
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
	MOVB	[R0],	R1			;escreve 0
	MOV		R0,		DISPLAY2
	MOVB	[R0],	R1			;escreve 0
	MOV		R0,		display_valor_1
	MOV		[R0],	R1
	MOV		R0,		display_valor_2
	MOV		[R0],	R1

  sub_init:
	MOV		R0,		submarino
	MOV		R1,		submarinoXI	;x inicial
	MOVB	[R0],	R1

	MOV		R1,		submarinoYI	;y inicial
	ADD		R0,		1
	MOVB	[R0],	R1

  b1_init:
	MOV		R0,		barco1
	MOV		R1,		barco1XI	;x inicial
	MOVB	[R0],	R1

	MOV		R1,		barco1YI	;y inicial
	ADD		R0,		1
	MOVB	[R0],	R1

  b2_init:
	MOV		R0,		barco2
	MOV		R1,		barco2XI	;x inicial
	MOVB	[R0],	R1

	MOV		R1,		barco2YI	;y inicial
	ADD		R0,		1
	MOVB	[R0],	R1
  torpedo_init:
  	MOV		R0,		torpedo
  	ADD		R0,		4
  	MOV		R1,		0
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

	EI0
	EI1
	EI
	RET


; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		verifica_movimentos										│
; │	DESCRICAO:	verifica se o submarino pode mexer ou sai do ecrã		│
; │																		│
; │	INPUT:		movimentos em R3 (XXYY)									│
; │	OUTPUT:		R1 0 = não mexe											│
; │	DESTROI:	R1, R4, R5, R7											│
; ╰─────────────────────────────────────────────────────────────────────╯
verifica_movimentos:
	PUSH	R0
	PUSH	R3
	PUSH	R2
	PUSH	R9
	PUSH	R8
	PUSH	R9
	PUSH	R10
  init_veri_movi:
	MOV		R0,		submarino	;memoria do submarino
	MOV		R2,		00FFH		;mascara
	ADD		R0,		2			;Δx
	MOVB	R8,		[R0]		;Δx
	SUB		R8,		1			;coordenadas começam no 0
	ADD		R0,		1			;Δy
	MOVB	R9,		[R0]		;Δy
	SUB		R9,		1			;coordenadas começam no 0
	MOV		R0,		submarino

	veri_x:			;sub_min_x<=x<=sub_max_x
		MOVB	R5,		[R0]		;contem coordenada x
		MOV		R4,		R3			;deslocamento XXYY
		SHR		R4,		8			;deslocamento 00XX
		CALL	hmovbs

		ADD		R5,		R4
		MOV		R7, 	sub_min_x
		CMP		R5,		R7			;vê se a coordenada é sub_min_x [sair esquerda ecrã]
		JN		fim_veri_nao_move

		ADD		R5,		R8
		MOV		R7, 	sub_max_x
		CMP		R5,		R7			;vê se a coordenada é sub_max_x [sair direita ecrã]	
		JP		fim_veri_nao_move

	veri_y:			;sub_min_y<=y<=sub_max_y
		ADD		R0,		1
		MOVB	R5,		[R0]		;coordenada y
		MOV		R4,		R3			;deslocamento XXYY

		AND		R4,		R2			;deslocamento 00YY
		CALL	hmovbs
		ADD		R5,		R4

		MOV		R7,		sub_min_y
		CMP		R5,		R7			;vê se a coordenada é sub_min_y [sair cima ecrã]
		JN		fim_veri_nao_move

		ADD		R5,		R9
		MOV		R7, 	sub_max_y
		CMP		R5,		R7			;vê se a coordenada é sub_max_y [sair baixo ecrã]	
		JP		fim_veri_nao_move
	
  fim_veri_move:
	MOV		R1,		1
	JMP		fim_veri_movi
  fim_veri_nao_move:
	MOV		R1,		0

  fim_veri_movi:
  	POP		R10
  	POP		R9
  	POP		R8
  	POP		R9
	POP		R2
	POP		R3
	POP		R0
	RET


; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		torpedo_move											│
; │	DESCRICAO:	movimenta o torpedo	- [rot1]							│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		torpedo pixelscreen + memoria							│
; ╰─────────────────────────────────────────────────────────────────────╯
torpedo_move:
	PUSH	R0
	PUSH	R1
	PUSH	R2
	PUSH	R4

	MOV		R2,		torpedo																								;alterar linha se houver mais torpedos

	MOV		R0,		[R2]	;posição torpedo XXYY
	MOV		R1,		[R2+4]	;estado [ativo/inativo]
	SHR		R1,		8		;elimina o byte seguinte

	AND		R1,		R1
	JZ		fim_m_torpedo

	move_torpedo:
	SWAP	R0,		R2		;troca posição com memoria do torpedo
	SUB		R2,		1

	MOV		R4,		R2
	CALL	hmovbs			;vai manter apenas o byte de menor peso (00YY)
	AND		R4,		R4
	JZ		dest_torpedo	;se o torpedo chegar ao fim do ecrã é apagado
	
	MOV		R1,		0
	CALL	imagem
	MOV		[R0],	R2
	MOV		R1,		1
	CALL	imagem
	CALL	verifica_choque
	JMP		fim_m_torpedo

	dest_torpedo:
	MOV		R1,		0	
	CALL	imagem			;apaga o torpedo
	ADD		R0,		4
	MOVB	[R0],	R1		;inativa o torpedo

  fim_m_torpedo:
	POP		R4
	POP		R2
	POP		R1
	POP		R0
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		verifica_choque											│
; │	DESCRICAO:	verifica se o torpedo atingiu um barco					│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		N/A														│
; ╰─────────────────────────────────────────────────────────────────────╯
verifica_choque:
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
	
	MOV		R0,		torpedo
	MOV		R1,		sub_max_y
	MOV		R2,		[R0]
	MOV		R3,		00FFH
	AND		R3,		R2			;posição 00YY do torpedo
	CMP		R1,		R3			;se o torpedo ainda estiver na metade do ecra pertencente ao submarino não precisamos
								;de testar se bateu em algum barco
	JN		fim_v_choque
	SHR		R2,		8

;	R0 - torpedo
;	R2 - 00XX torpedo
;	R3 - 00YY torpedo

	MOV		R5,		barco1
  v_barco:

	MOV		R6,		[R5]		;XXYY	barco
	MOV		R7,		[R5+2]		;∆X∆Y	barco
	MOV		R8,		R6			;XXYY	barco
	SHR		R6,		8			;00XX	barco
	MOV		R10,	00FFH		;mascara
	AND		R8,		R10			;00YY	barco

	MOV		R9,		R7
	SHR		R9,		8	;00∆X
	AND		R7,		R10	;00∆Y

  ;	R0 - torpedo
  ;	R2 - 00XX torpedo
  ;	R3 - 00YY torpedo
  ;	R5 - barco
  ;	R7 - 00∆Y barco
  ;	R9 - 00∆X barco
  ;	R6 - 00XX barco
  ;	R8 - 00YY barco

	;if([ybarco + ∆ybarco] < ytorpedo):		OK
		MOV		R1,		R8
		ADD		R1,		R7
		CMP		R1,		R3
		JN		v_barco_2
	;if([ytorpedo + ∆ytorpedo] < ybarco):	OK
		MOV		R1,		[R0+2]		;∆X∆Y	torpedo
		AND		R1,		R10			;00∆Y torpedo
		ADD		R1,		R3
		CMP		R1,		R7
		JN		v_barco_2
	;if(xbarco > xtorpedo)					OK
		CMP		R6,		R2
		JP		v_barco_2

	;if([xbarco + ∆xbarco] < xtorpedo)		OK
		MOV		R1,		R6
		ADD		R1,		R9
		CMP		R1,		R2
		JN		v_barco_2
	;else									X
		JMP		choca
  v_barco_2:
  	MOV		R1,		barco2
  	CMP		R5,		R1			;verifica se acabou de testar o barco2
  	JZ		fim_v_choque		;se já verficou ambos sai
  	SWAP	R5,		R1			;se não, mete o barco no R5 e testa
  	JMP		v_barco				;repete o ciclo

  choca:				;R5 - barco em que bateu; R0 - torpedo
	MOV		R1,		0
	MOV		[R5+4],	R1			;inativa o barco
	MOV		[R0+4],	R1			;inativa o torpedo
	CALL	imagem				;apaga o torpedo
	MOV		R0,		R5			;endereço barco
	CALL	imagem				;apaga o barco
	CALL	hexa_escreve_p1		;aumenta os pontos

	fim_v_choque:
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
; │	ROTINA:		torpedo_cria											│
; │	DESCRICAO:	cria um torpedo											│
; │																		│
; │	INPUT:		R2 - ultima tecla primida								│
; │	OUTPUT:		memoria + pixelscreen									│
; ╰─────────────────────────────────────────────────────────────────────╯
torpedo_cria:
	PUSH	R0
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5

	MOV		R0,		5
	CMP		R2,		R0
	JNZ		fim_c_torpedo	;se n foi primida a tecla 5 n faz nada

	MOV		R2,		torpedo																								;alterar linha se houver mais torpedos

	MOV		R0,		[R2]	;posição torpedo XXYY
	MOV		R1,		[R2+2]	;tamanho torpedo ∆X∆Y
	MOV		R5,		[R2+4]	;estado [ativo/inativo]
	SHR		R5,		8		;elimina o byte seguinte

	AND		R5,		R5
	JNZ		fim_c_torpedo	;se já estiver ativo não faz nada

	MOV		R3,		submarino
	MOV		R3,		[R3]		;XXYY submarino
	SUB		R3,		2			
	MOV		R4,		500H
	ADD		R3,		R4
	MOV		[R2],	R3			;posição torpedo
	MOV		R3,		1
	ADD		R2,		4			;posição do estado
	MOVB	[R2],	R3			;ativa o torpedo
	SUB		R2,		4
	MOV		R0,		R2
	CALL	imagem

  fim_c_torpedo:
	POP		R5
	POP		R4
	POP		R3
	POP		R2
	POP		R1
	POP		R0
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		barcos													│
; │	DESCRICAO:	faz os movimentos do barcos	- [rot0]					│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		pixelscreen, memoria barcos								│
; ╰─────────────────────────────────────────────────────────────────────╯
barcos:
	PUSH	R3

	MOV		R3,		barco1
	CALL	barcos_ciclo
	MOV		R3,		barco2
	CALL	barcos_ciclo
	JMP		fim_barcos
	; ╭─────────────────────────────────────────────────────────────────────╮
	; │	ROTINA:		barcos_ciclo											│
	; │	DESCRICAO:	faz os movimentos do barco								│
	; │																		│
	; │	INPUT:		R3 - barco												│
	; │	OUTPUT:		pixelscreen, memoria barcos								│
	; ╰─────────────────────────────────────────────────────────────────────╯
	  barcos_ciclo:
		PUSH	R0
		PUSH	R1
		PUSH	R2
		PUSH	R3
		PUSH	R5
		PUSH	R6
		PUSH	R9
		PUSH	R10

		MOV		R1,		0		;apagar imagem + interrupção
		MOV		R5,		0100H	; XXYY = x+1
		MOV		[R2],	R1

		MOV		R0,		R3		;barco a movimentar
		CALL	imagem			;apaga o barco

		MOV		R3,		[R0]	;posição XXYY do barco
		SUB		R3,		R5
		MOV		R9,		R3		;XXYY barco t++
		SHR		R9,		8		;00XX barco t++

		CALL	random			;devolve em R10 0/1
		AND		R10,	R10		
		JZ		esquerda		;0 move esquerda

	  direita:				;1 move direira
		MOV		R10,	[R0+2]	;ΔxΔy
		SHR		R10,	8		;00(Δx+XX)
		ADD		R9,		R10
		PUSH	R4
		MOV		R4,		R9
		CALL	hmovbs
		MOV		R9,		R4		;faz extensão de sinal 
		POP		R4
		MOV		R6,		bar_max_x
		CMP		R9,		R6		;fica parado ou movimenta
		JN		barco_continua
		MOV		[R0],	R3		;escreve o movimento
		JMP		barco_continua

	  esquerda:				;
		PUSH	R4
		MOV		R4,		R9
		CALL	hmovbs
		MOV		R9,		R4		;faz extensão de sinal 
		POP		R4
		MOV		R6,		bar_min_x
		CMP		R9,		R6		;fica parado ou movimenta
		JN		barco_continua
		MOV		[R0],	R3		;escreve o movimento
		JMP		barco_continua

	  barco_continua:
		MOV		R1,		1
		CALL	imagem
	  fim_c_barcos:
		POP		R10
		POP		R9
		POP		R6
		POP		R5
		POP		R3
		POP		R2
		POP		R1
		POP		R0
  		RET

  fim_barcos:
	POP		R3
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		hexa_escreve_p1											│
; │	DESCRICAO:	incrementa o valor do hexa diplay por 1					│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		DISPLAY1, R0[fim jogo]									│
; │	DESTROI:	R0														│
; ╰─────────────────────────────────────────────────────────────────────╯
hexa_escreve_p1:

	PUSH	R1
	PUSH	R3		;mascara
	PUSH	R4
	PUSH	R5

	MOV		R4,		00001010b
	MOV		R5,		display_valor_1
	MOV		R1,		[R5]
	ADD		R1,		1
	MOV		R3,		00001111b ;isola as unidades
	AND		R3,		R1
	CMP		R3,		R4
	JZ		salta_pra_10
	JMP		hexa_continuacao

  salta_pra_10:
	ADD		R1,		6
	MOV		R4,		10100000b	;valor maximo
	CMP		R4,		R1
	JZ		hexa_fim_jogo
	JMP		hexa_continuacao

  hexa_fim_jogo:
	MOV		R0,		0
	JMP		hexa_fim
  hexa_continuacao:
	MOV		[R5],	R1
	MOV		R5,		DISPLAY1
	MOVB	[R5],	R1

  hexa_fim:
  	POP		R5
	POP		R4
	POP		R3
	POP		R1
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		random													│
; │	DESCRICAO:	devolve um valor random [0/1]							│
; │																		│
; │	INPUT:		DISPLAY2												│
; │	OUTPUT:		R10,	0/1												│
; │	DESTROI:	R10														│
; ╰─────────────────────────────────────────────────────────────────────╯
random:
	PUSH	R0
	MOV		R10,	DISPLAY2	
	MOVB	R10,	[R10]		;contem valor ao calhas
	MOV		R0,		00000001b	;mascara bit menor peso
	AND		R10,	R0			;filtra um unico bit
	POP		R0
	RET							;devolve	0/1 em R10

; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		MOVBS													│
; │	DESCRICAO:	extensão sinal de um byte								│
; │																		│
; │	INPUT:		R4														│
; │	OUTPUT:		R4														│
; ╰─────────────────────────────────────────────────────────────────────╯
hmovbs:
	PUSH	R0

	MOV		R0,		10000000b
	AND		R0,		R4
	JZ		positivo
	MOV		R0,		0FF00H
	OR		R4,		R0
	JMP		movbs_fim
  positivo:
	MOV		R0,		00FFH
  	AND		R4,		R0
  movbs_fim:
	POP		R0
	RET

; ╭─────────────────────────────────────────────────────────────────────╮
; │ Interrupções														│
; │																		│
; │	RE:	0000 0000 0000 0000												│
; │		RNDI IIII TTBA VCNZ												│
; │		 PEE EEEE DV													│
; │		   3 210														│
; ╰─────────────────────────────────────────────────────────────────────╯
rot0:
	CALL	barcos
	RFE

rot1:
	CALL	torpedo_move
	RFE



;-------------------------------INUITIL PARA PROJETO----------------------------------------
; ╭─────────────────────────────────────────────────────────────────────╮
; │	ROTINA:		hexa_escreve_p2											│
; │	DESCRICAO:	incrementa o valor do hexa diplay2 por 1				│
; │																		│
; │	INPUT:		N/A														│
; │	OUTPUT:		DISPLAY2												│
; ╰─────────────────────────────────────────────────────────────────────╯
hexa_escreve_p2:

	PUSH	R1
	PUSH	R3		;mascara
	PUSH	R4
	PUSH	R5

	MOV		R4,		00001010b
	MOV		R5,		display_valor_2
	MOV		R1,		[R5]
	ADD		R1,		1
	MOV		R3,		00001111b ;isola as unidades
	AND		R3,		R1
	CMP		R3,		R4
	JZ		salta_pra_10_2
	JMP		hexa_continuacao_2

  salta_pra_10_2:
	ADD		R1,		6
	JMP		hexa_continuacao_2

  hexa_continuacao_2:
	MOV		[R5],	R1
	MOV		R5,		DISPLAY2
	MOVB	[R5],	R1

  hexa_fim_2:
  	POP		R5
	POP		R4
	POP		R3
	POP		R1
	RET

