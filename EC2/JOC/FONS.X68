; =============================================================================
; GAME PLAY STATE WALLPAPER
; =============================================================================

; -----------------------------------------------------------------------------
FONSPLOT
; DIBUIXA EL FONS DEL JOC 
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------          
            MOVEM.W D1-D5,-(A7)
            
            ; PINTAR CEL
            UTLSFIL #CELCOL
            MOVE.B  #89,D0          ;FLOD FILL AMB EL COLOR DEL CEL
            MOVE.W  #1,D1
            MOVE.W  #1,D2
            TRAP    #15
            
            ;PINTAR SOL
            UTLSPEN #SOLCOL
            UTLSFIL #SOLCOL
            MOVE.B  #88,D0          ;ELIPSE
            MOVE.W  #SCRWIDTH-20,D1
            MOVE.W  #80,D2
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            SUB.W   #60,D3
            SUB.W   #60,D4
            TRAP    #15
            
            ;PINTAR NUVOLS          ;CONJUNT DE ELIPSES
            UTLSPEN #NUVOLCOL
            UTLSFIL #NUVOLCOL
            MOVE.B  #2,D5           ;NOMBRE D'ITERACIONS (ELIPSES)
            MOVE.W  #88,D0          ;ELIPSE
            MOVE.W  #50,D1
            MOVE.W  #50,D2
            
.NUV        ADD.W   #55,D1
            MOVE.W  D1,D3
            MOVE.W  D2,D4
            ADD.W   #100,D3
            ADD.W   #60,D4
            TRAP    #15
            DBRA    D5,.NUV
            
            MOVEM.W (A7)+,D1-D5
            RTS
            
























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
