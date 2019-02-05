; =============================================================================
; CANONADA MANAGEMENT. IT IS AN AGENT.
; LOCAL MEMORY IS:
; +0 WORD X COORDINATE
; +2 WORD Y COORDINATE
; +4 WORD X SPEED
; +6 WORD Y SPEED
; +8 WORD PIPE SCORE
; =============================================================================

; -----------------------------------------------------------------------------
CANOINIT
; INITALIZES A PIPE
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - ASSUMES SCRHEIGH IS GREATER THAN 255
; -----------------------------------------------------------------------------
            MOVE.W  D0, -(A7)
            CLR.W   8(A0)
            ADD.W   #1, (CANOCOUNT)          ; NOMBRE DE CANONADES+1
            MOVE.W  #SCRWIDTH, (A0)          ; POSICIO X DE LA PANTALLA
            JSR     UTLRAND                 ; GENERAM RANDOM
            MOVE.W  D0,2(A0)                ; POSICIO RANDOM Y      
            MOVE.W  (CANOCOUNT), D2
            ADD.W   #CANOSPEED, D2           ;CANOSPEED+CANOCOUNT
            MOVE.W  D2, D1                   ;LA VELOCITAT DE LES CANONADES
            MOVE.W  D1, 4(A0)                ; VELOCITAT RANDOM X

            MOVE.W  #0, 6(A0)
.END        MOVE.W  (A7)+, D0
            RTS

; -----------------------------------------------------------------------------
CANOUPD
; UPDATES AN ASTEROID
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  D0, -(A7)
            MOVE.W  4(A0), D0                ; UPDATE COORDINATES
            SUB.W   D0, (A0)
            CMP.W   #-CANOWIDTH, (A0)
            BMI     .MATAR                  ;BRANCH ON MINUS (NEGATIU)
            
            MOVE.W  6(A0), D0
            ADD.W   D0, 2(A0) 
            
            MOVE.W  (A0), D0
            CMP.W   #0, 8(A0)
            BNE     .COL
            CMP.W   (PLRPOSX),D0
            BGT     .COL
            ADD.W   #CANOWIDTH, D0
            CMP.W   (PLRPOSX), D0
            BLT     .COL
            ADD.W   #CANOSCORE, (PLRSCORE)    ; AFEGIR PUNTUACIÓ DE LA CANONADA
            ;JUGADOR PASSA PER DAVALL UNA CANONADA
            MOVE.B  #AUDMSKNL|AUDPK1ID,D1   ; PREPARE SOUND
            JSR     AUDPLAY                 ; PLAY ARGH SOUND
            ADD.W   #1, 8(A0)
            
            ;COLLISION
.COL        MOVE.W  (A0),       D0          
            MOVE.W  2(A0),      D1
            MOVE.W  (PLRPOSX),  D2
            MOVE.W  (PLRPOSY),  D3
            MOVE.W  #CANOWIDTH, D4
            MOVE.W  #PLRWIDTH,  D5
            MOVE.W  #HOLESIZE,  D6
            MOVE.W  #PLRHEIGH,  D7
            JSR     UTLCHCOL                ; MIRAR SI HA XOCAT
            TST.B    D0
            BEQ     .END
            MOVE.B  #1,(PLRDEAD)            ;MATAR JUGADOR
            BRA     .END
 
.MATAR      JSR     AGLKILL                 ;MATAR AGENT SI SURT DE LA PANTALLA
            BRA     .COL
            
.END        MOVE.W  (A7)+,D0
            RTS


; -----------------------------------------------------------------------------
CANOPLOT
; PLOTS AN ASTEROID
; INPUT    - A0 POINTER TO THE LOCAL MEMORY
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.W D1-D5,-(A7)
            
            UTLSPEN #CANOPENCL
            UTLSFIL #CANOFILCL
            ;MEITAT SUPERIOR DE LA CANONADA
            MOVE.W  (A0), D1
            MOVE.W  #0, D2           ;CLEAR
            MOVE.W  2(A0), D4
            MOVE.W  D1, D3
            ADD.W   #CANOWIDTH, D3
            MOVE.B  #87, D0          ;TASK 87 DEL TRAP 15
            TRAP    #15
            
            ;MEITAT INFERIOR DE LA CANONADA
            MOVE.W  D4,D2
            MOVE.W  #SCRHEIGH, D4
            ADD.W   #HOLESIZE, D2   ;PER NO PINTAR EL FORAT
            TRAP    #15
            
            MOVEM.W (A7)+,D1-D5
            RTS




















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
