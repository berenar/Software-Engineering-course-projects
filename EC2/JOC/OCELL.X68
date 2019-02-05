; =============================================================================
; PLAYER MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
PLRINIT
; INITIALIZES THE PLAYER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.W  #0,(PLRPOSX)
            MOVE.W  #(SCRHEIGH-PLRHEIGH)/2,(PLRPOSY)
            CLR.W   (PLRSPDY)
            CLR.W   (CANOCOUNT)
            CLR.W   (PLRSCORE)
            CLR.W   (PLRDEAD)
            RTS

; -----------------------------------------------------------------------------
PLRUPD
; UPDATES THE PLAYER MOTION
; INPUT    - NONE (ACCESSES KBDVAL AND KBDEDGE)
; OUTPUT   - NONE (MODIFIES PLAYER DATA)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            
            ;APLICA GRAVETAT A L'OCELL (EIX Y)
            MOVE.W  (PLRPOSY),D1
            MOVE.W  D1,D2                   ; COPIA DE LA POSICIO Y
            ADD.W   #PLRHEIGH,D2            ; PER TENIR EN COMPTE L'ALTURA
            SUB.W   #SCRHEIGH,D2            ; ALTURA PANTALLA-POSICIO Y OCELL
            BLE     .APLICA                 ; NOMES SI NO ES ABAIX DE LA PANTALLA
            BRA     .NOAPLICA               ; IMPEDEIX QUE LA GRAVETAT FACI SORTIR
                                            ; L'OCELL PER LA PART INFERIOR
.APLICA     ADDQ.W  #GRAVETAT,D1            ; GRAVETAT A LA POSICIO Y DE L'OCELL
            MOVE.W  D1,(PLRPOSY)
            
.NOAPLICA   MOVE.W  (PLRSPDY),D0            
            ADD.W   (PLRPOSY),D0

            MOVE.W  D0,(PLRPOSY)            ; MOURE Y
            MOVE.L  (A7)+,D0                ; RECUPERAR VALOR DE D0
            CMP.B   #0,(PLRDEAD)            ; MIRAR SI EL JUGADOR ES MORT
            BEQ     .VIU
            CLR.B   (PLRDEAD)               ; REINICIAR VALOR DE MORT
            MOVE.W  #STAGOVR,(STANEXT)      ; SEGUENT ESTAT: GAMEOVER
            ;JUGADOR MORT, REPRODUIR SO
            MOVE.B  #AUDMSKNL|AUDARGID,D1   ; PREPARE SOUND
            JSR     AUDPLAY                 ; PLAY ARGH SOUND

            
.VIU        MOVE.W  D1,-(A7)
            MOVE.B  (KBDVAL),D1             ; PERFORM MOTION AND CHECK BOUNDS
            ROR.B   #1,D1
            BCC     .CHKUP
            SUB.W   #PLRSPEED,(PLRPOSX)
            CMP.W   #PLRWIDTH,(PLRPOSX)
            BGE     .CHKUP
            MOVE.W   #PLRWIDTH,(PLRPOSX)
            
.CHKUP      ROR.B   #1,D1                   ;amunt
            BCC     .CHKRT
            SUB.W   #PLRSPEED,(PLRPOSY)
            TST.W   (PLRPOSY)
            BGE     .CHKRT
            CLR.W   (PLRPOSY)
.CHKRT      ROR.B   #1,D1                   ;dreta
            BCC     .CHKDN
            ADD.W   #PLRSPEED,(PLRPOSX)
            CMP.W   #SCRWIDTH-PLRWIDTH,(PLRPOSX)
            BLE     .CHKDN
            MOVE.W  #SCRWIDTH-PLRWIDTH,(PLRPOSX)
.CHKDN      ROR.B   #1,D1                   ;avall
            BCC     .MDONE
            ADD.W   #PLRSPEED,(PLRPOSY)
            CMP.W   #SCRHEIGH-PLRHEIGH,(PLRPOSY)
            BLE     .MDONE
            MOVE.W  #SCRHEIGH-PLRHEIGH,(PLRPOSY)
            
.MDONE      MOVE.W  (A7)+,D1
            RTS


; -----------------------------------------------------------------------------
PLRPLOT
; PLOTS THE PLAYER ITS LIFE AND THE SCORE
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0-D6,-(A7)
                        
            JSR     ALTERNAR                ;CANVIAR VALOR DE ALAONO
            
            UTLSPEN #PLRNRMCL
            UTLSFIL #PLRNRMCL
            
            ; PLOT THE PLAYER
            MOVE.W  (PLRPOSX), D1            
            MOVE.W  (PLRPOSY), D2           ; JUGADOR A LA POSICIO (D1,D2)
            MOVE.W  D1, D3
            MOVE.W  D2, D4
            ADD.W   #PLRWIDTH, D3
            ADD.W   #PLRHEIGH, D4
            MOVE.B  #88,D0                  ; ELIPSE
            TRAP    #15
            SUB.W   #PLRWIDTH/2,D3
            MOVE.B  #87,D0                  ; RECTANGLE
            TRAP    #15
            

            ;DECIDIR SI PINTAR L'ALA ALTA O BAIXA
            MOVE.W  (ALAONO),D6
            TST.B   D6
            BNE     .PINTALTA
            UTLSPEN #PLRWNGCL
            UTLSFIL #PLRWNGCL
            JSR     BAIXAPLOT
            BRA     .CONTINUA
            
.PINTALTA   UTLSPEN #PLRWNGCL2
            UTLSFIL #PLRWNGCL2
            JSR     ALTAPLOT
.CONTINUA   JSR     ULLPLOT                 ; PINTAR ULL      
            
            ; PLOT THE SCORE TEXT
            UTLSPEN #$00FFFFFF
            UTLSFIL #$00FFFFFF
            MOVE.W  #5, D1            
            MOVE.W  #11, D2
            MOVE.W  D1, D3
            MOVE.W  D2, D4
            ADD.W   #77, D3
            ADD.W   #21, D4
            MOVE.B  #87,D0                  ; RECTANGLE ON POSAR LA PUNTUACIO
            TRAP    #15

            UTLSPEN #PLRTXTCL
            UTLSFIL #CELCOL
            UTLLOCT PLRTXTX,PLRTXTY
            LEA     .SCORESTR,A1
            CLR.L   D1
            MOVE.W  (PLRSCORE), D1          ; PUNTUACIO
            MOVE.B  #17,D0                  ; IMPRIMIR TEXT
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D6
            RTS
            
.SCORESTR   DC.B    'SCORE: ',0




; -----------------------------------------------------------------------------
ULLPLOT
; PINTA L'ULL DE L'OCELL
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - SCRCYCCT
; -----------------------------------------------------------------------------
            ;ULL
            UTLSPEN #PLREYCL
            UTLSFIL #PLREYCL
            MOVE.W  (PLRPOSX), D1            
            MOVE.W  (PLRPOSY), D2           ; JUGADOR A LA POSICIO (D1,D2)
            ADD.W   #16,D1
            ADD.W   #5,D2
            MOVE.W  D1, D3
            MOVE.W  D2, D4
            ADD.W   #10, D3
            ADD.W   #10, D4
            MOVE.B  #88,D0                  ; ELIPSE (EXTERIOR DE L'ULL)
            TRAP    #15
            
            UTLSPEN #PLREYCL2
            UTLSFIL #PLREYCL2
            MOVE.W  (PLRPOSX), D1            
            MOVE.W  (PLRPOSY), D2           ; JUGADOR A LA POSICIO (D1,D2)
            ADD.W   #19,D1
            ADD.W   #8,D2
            MOVE.W  D1, D3
            MOVE.W  D2, D4
            ADD.W   #5, D3
            ADD.W   #5, D4
            MOVE.B  #88,D0                  ; ELIPSE (INTERIOR DE L'ULL)
            TRAP    #15
            RTS


; -----------------------------------------------------------------------------
BAIXAPLOT
; PINTA L'ALA DE L'OCELL CAP AVALL
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - SCRCYCCT
; -----------------------------------------------------------------------------
            
            MOVE.W  (PLRPOSX), D1            
            MOVE.W  (PLRPOSY), D2           ; JUGADOR A LA POSICIO (D1,D2)
            ADD.W   #PLRHEIGH/4,D2                 ; L'ALA ESTA MES BAIXA
            MOVE.W  D1, D3
            MOVE.W  D2, D4
            ADD.W   #PLRWIDTH/4, D3
            ADD.W   #PLRHEIGH/2, D4
            MOVE.B  #84, D0                 ; LINIA
            TRAP    #15  
            
            MOVE.W  D3, D1
            MOVE.W  D4, D2
            ADD.W   #PLRWIDTH/4,D3
            SUB.W   #PLRHEIGH/2, D4
            MOVE.B  #84, D0                 ; LINIA
            TRAP    #15
            
            MOVE.W  D3, D1
            MOVE.W  D4, D2
            MOVE.W  (PLRPOSX), D3            
            MOVE.W  (PLRPOSY), D4
            ADD.W   #PLRHEIGH/4,D4          ; L'ALA UNA MICA MES BAIXA
            MOVE.B  #84, D0                 ; LINIA
            TRAP    #15
            
            MOVE.W  (PLRPOSX), D1            
            MOVE.W  (PLRPOSY), D2
            ADD.W   #PLRHEIGH/4,D2
            ADD.W   #4,D1
            ADD.W   #4,D2
            MOVE.B  #89,D0                  ;OMPLIR TRIANGLE FORMAT
            TRAP    #15
            RTS
            
; -----------------------------------------------------------------------------
ALTAPLOT
; PINTA L'ALA DE L'OCELL CAP A DALT
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - SCRCYCCT
; -----------------------------------------------------------------------------
            
            MOVE.W  (PLRPOSX), D1            
            MOVE.W  (PLRPOSY), D2           ; JUGADOR A LA POSICIO (D1,D2)
            ADD.W   #PLRHEIGH/4,D2          ; L'ALA UNA MICA MES BAIXA
            MOVE.W  D1, D3
            MOVE.W  D2, D4
            ADD.W   #PLRWIDTH/4, D3
            SUB.W   #PLRHEIGH/2, D4
            MOVE.B  #84, D0                 ; LINIA
            TRAP    #15  
            
            MOVE.W  D3, D1
            MOVE.W  D4, D2
            ADD.W   #PLRWIDTH/4,D3
            ADD.W   #PLRHEIGH/2, D4
            MOVE.B  #84, D0                 ; LINIA
            TRAP    #15
            
            MOVE.W  D3, D1
            MOVE.W  D4, D2
            MOVE.W  (PLRPOSX), D3            
            MOVE.W  (PLRPOSY), D4
            ADD.W   #PLRHEIGH/4,D4          ; L'ALA UNA MICA MES BAIXA
            MOVE.B  #84, D0                 ; LINIA
            TRAP    #15
            
            MOVE.W  (PLRPOSX), D1            
            MOVE.W  (PLRPOSY), D2
            ADD.W   #PLRHEIGH/4,D2
            ADD.W   #4,D1
            SUB.W   #4,D2
            MOVE.B  #89,D0                  ;OMPLIR TRIANGLE FORMAT
            TRAP    #15
            
            MOVE.W  (PLRPOSX), D1            
            MOVE.W  (PLRPOSY), D2
            ADD.W   #PLRHEIGH/4,D2
            ADD.W   #PLRWIDTH/4,D1
            SUB.W   #9,D2
            MOVE.B  #89,D0                  ; OMPLIR PART RESTANT DEL TRIANGELE
            TRAP    #15                     ; PERQUE INTERSECTA AMB L'OCELL

            RTS






*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
