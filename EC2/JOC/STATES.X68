; =============================================================================
; GAME STATE MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
STAINIT
; INITALIZES THE STATE MANAGER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #STANONE,(STACUR)
            MOVE.W  #STAINTR,(STANEXT)
            BRA     AUDINIT                 ; INIT AUDIO SYSTEM
            RTS

; -----------------------------------------------------------------------------
STAUPD
; PERFORMS STATE UPDATE AND INIT IF NECESSARY
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STANEXT),D0
            CMP.W   (STACUR),D0
            BEQ     .DOUPD
            MOVE.W  D0,(STACUR)             ; IF STATE CHANGED, DO INIT
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .INITBL(A0),A0
            JSR     (A0)
.DOUPD      CLR.L   D0                      ; IN ANY CASE, DO UPDATE
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .UPDTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.INITBL     DC.L    STAINTRI,STAPLAYI,STAEMPTY
.UPDTBL     DC.L    STAINTRU,STAPLAYU,STAGOVRU

; -----------------------------------------------------------------------------
STAPLOT
; PERFORMS STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            CLR.L   D0
            MOVE.W  (STACUR),D0
            LSL.L   #2,D0
            MOVE.L  D0,A0
            MOVE.L  .PLTTBL(A0),A0
            JSR     (A0)
            MOVEM.L (A7)+,D0/A0
            RTS
.PLTTBL     DC.L    STAINTRP,STAPLAYP,STAGOVRP

; -----------------------------------------------------------------------------
STAEMPTY
; EMPTY SUBROUTINE FOR CASES WITH NOTHING TO DO
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A PLACEHOLDER. NOTHING TO DO.
; -----------------------------------------------------------------------------
            RTS

; =============================================================================
; PLAY STATE
; =============================================================================

; -----------------------------------------------------------------------------
STAPLAYI    EQU     PLRINIT
; PLAY STATE INITIALIZATION.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR PLRINIT
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAPLAYU
; PLAY STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     PLRUPD
            JSR     SPWUPD
            BRA     AGLUPD

; -----------------------------------------------------------------------------
STAPLAYP
; PLAY STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            JSR     FONSPLOT
            JSR     AGLPLOT
            BRA     PLRPLOT

; =============================================================================
; INTRO STATE
; =============================================================================

; -----------------------------------------------------------------------------
STAINTRI    EQU     DMMINIT
; INTRO STATE INIT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; NOTE     - JUST A WRAPPER FOR DMMINIT TO RELEASE ALL MEMORY
; -----------------------------------------------------------------------------

; -----------------------------------------------------------------------------
STAINTRU
; INTRO STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STAPLAY,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAINTRP
; INTRO STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L A1/D0-D1, -(A7)
            
            UTLSFIL #CELCOL
            MOVE.B  #89,D0
            MOVE.W  #10,D1
            MOVE.W  #10,D2
            TRAP    #15

            UTLLOCT INTTITX, INTTITY
            UTLSFIL #CELCOL
            UTLSPEN #INTC
            LEA     .TITSTR, A1
            MOVE.B  #14, D0
            TRAP    #15

            UTLLOCT INTPRSX,INTPRSY   
            UTLSFIL #CELCOL
            UTLSPEN #INTC
            LEA     .PRSSTR, A1
            MOVE.B  #14, D0
            TRAP    #15
            
            UTLLOCT INTARRX,INTARRY 
            UTLSFIL #CELCOL
            UTLSPEN #INTC
            LEA     .ARROWS, A1
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.L (A7)+, A1/D0-D1
            RTS

.TITSTR     DC.B    'FLAPI 68000 BY JANDRO AND BERNAT',0
.PRSSTR     DC.B    '       SPACE BAR TO START       ',0
.ARROWS     DC.B    '     ARROWS TO MOVE THE BIRD    ',0
            DS.W    0

; =============================================================================
; GAME OVER STATE
; =============================================================================
            
; -----------------------------------------------------------------------------
STAGOVRU
; GAME OVER STATE UPDATE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            BTST.B  #KBDBITF1,(KBDEDGE)
            BEQ     .END
            MOVE.W  #STAINTR,(STANEXT)
.END        RTS

; -----------------------------------------------------------------------------
STAGOVRP
; GAME OVER STATE PLOT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            
            ;PLOT GAME OVER STRING
            MOVEM.L A1/D0-D2,-(A7)
            UTLSFIL #CELCOL
            MOVE.B  #89,D0
            MOVE.W  #1,D1
            MOVE.W  #1,D2
            TRAP    #15
            
            UTLLOCT GOVSTRX,GOVSTRY
            UTLSPEN #GOVSTRC
            UTLSFIL #CELCOL
            LEA     .GOVSTR,A1
            MOVE.B  #14,D0
            TRAP    #15                 ;IMPRIMIR "JOC ACABAT"
            
            ;NO FA FALTA BOTAR DE LINIA
            CLR.L   D1
            MOVE.W  (PLRSCORE), D1      ;NOMBRE A IMPRIMIR
            MOVE.B  #10,D2              ;BASE DECIMAL
            MOVE.B  #15,D0              ;TASK NUMBER
            TRAP    #15                 ;IMPRIMIR NOMBRE DE PUNTS

            SUBQ.B  #1, D1               ; SI HA FET 1 PUNT: 'POINT'
            BEQ     .SINGULAR
            
            ;0 POINTS, 1 POINT, 2 POINTS, ETC
.PLURAL     LEA     .PSSTR, A1           ; SI N'HA FET 0 O >1: 'POINTS'
            BRA     .IMPR
            
.SINGULAR   LEA     .PSTR, A1

.IMPR       MOVE.B  #14, D0
            TRAP    #15                 ;IMPRIMIR "PUNTS ACONSEGUITS"
            
            UTLLOCT LUCKSTRX,LUCKSTRY
            LEA     .LUCKSTR,A1
            MOVE.B  #14,D0
            TRAP    #15                 ; IMPRIMIR "BONA SORT"
            
            UTLLOCT LUCKSTRX,LUCKSTRY+2
            LEA     .RETRYSTR,A1        ;IMPRIMIR "TORNAR A INTENTAR"
            MOVE.B  #14,D0
            TRAP    #15

            MOVEM.L (A7)+,A1/D0-D2
            RTS

.GOVSTR     DC.B    'GAME  OVER ! YOU HAVE SCORED ',0
.PSSTR      DC.B    ' POINTS',0
.PSTR       DC.B    ' POINT',0
.LUCKSTR    DC.B    '       GOOD LUCK NEXT TIME...  ',0
.RETRYSTR   DC.B    '      PRESS SPACE BAR TO RETRY    ',0
            DS.W    0



















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
