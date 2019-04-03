;┌──────────────────────────────────────┐
;│				Grupo **				│
;├──────────────────────────────────────┤
;│ Alunos:								│
;│	Pedro Tracana			93610		│
;│	Samuel Barata			94230		│
;│	Vasyl Lanko				93622		│
;└──────────────────────────────────────┘


; |---------------------------------------------------------------------|
; | Constantes                                                          |
; |---------------------------------------------------------------------|
DISPLAY1		EQU 0A000H  ; (periférico POUT-1)
DISPLAY2		EQU 0C000H  ; (periférico POUT-2)
DISPLAY3		EQU	06000H	; (periférico POUT-3)
T_IN			EQU 0E000H  ; endereço das colunas do teclado (periférico PIN)
PSCREEN			EQU 8000H   ; endereço do ecrã (pixelscreen)





PLACE       1000H

			;nº colunas; nº linhas; coordenadas
submarino:	STRING 5,3;,?,?
			STRING 0,0,1,1,0
			STRING 0,0,0,1,0
			STRING 1,1,1,1,1