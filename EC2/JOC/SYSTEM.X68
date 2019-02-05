; =============================================================================
; SYSTEM MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
SYSINIT
; INITIALIZES THE SYSTEM
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVE.L  (A7)+,A0                ; GET RETURN ADDRESS
            JSR     KBDINIT                 ; INIT KEYBOARD
            JSR     SCRINIT                 ; INIT SCREEN
            JSR     DMMINIT                 ; INIT DYNAMIC MEMORY
            ANDI.W  #$DFFF,SR               ; SWITCH TO USER
            MOVE.L  A0,-(A7)                ; PUT RETURN ADDRESS
            RTS

; =============================================================================
; SCREEN MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
SCRINIT
; INITIALIZES THE SCREEN, SCREEN-RELATED INTERRUPT AND VARS.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - D0,D1,D2,D3
; -----------------------------------------------------------------------------
            ;NETEJA REGISTRES A USAR
            CLR.L   D0
            CLR.L   D1
            CLR.L   D2
            CLR.L   D3
            
            ; TO DO:
            ; - DISABLE INTS (SET INT BITS IN SR TO 111)
            MOVE.W  SR,D0
            OR.W    #$0700,D0
            MOVE.W  D0,SR
            ; - INSTALL SCRUPD INTO TRAP SCRTRAP
            MOVE.L  #SCRUPD,($80+SCRTRAP*4)
            ; - SET RESOLUTION TO SCRWIDTH X SCRHEIGHT
            MOVE.B  #33,D0
            MOVE.L  #(SCRWIDTH)*$10000,D1
            MOVE.L  #(SCRHEIGH), D3
            ADD.L   D3,D1    
            TRAP    #15
            ; - SET WINDOWED MODE
            MOVE.B  #33,D0
            MOVE.L  #1,D1
            TRAP    #15
            ; - CLEAR VISIBLE BUFFER
            MOVEQ   #11,D0
            MOVE.W  $FF00, D1
            TRAP    #15
            ; - ENABLE DOUBLE BUFFER
            MOVEQ   #92,D0
            MOVE.B  #17,D1
            TRAP    #15
            ; - CLEAR HIDDEN BUFFER
            MOVEQ   #11,D0
            MOVE.W  $FF00, D1
            TRAP    #15
            ; - INSTALL SCRISR FOR IRQ SCRIRQ (IRQ INTERRUPT VECTOR BEGINS
            ;   AT $60. INSTALLATION IS SIMILAR TO TRAP INSTALLATION)
            MOVE.L   #SCRISR,($60+SCRIRQ*4)
            ; - ENABLE AUTO-IRQ EVERY SCRTIM MS FOR IRQ SCRIRQ (SEE TRAP #15
            ;   TASK 32)
            MOVEQ   #32,D0
            MOVE.B  #6,D1
            MOVE.L  #SCRIRQ,D2
            OR      #$80,D2
            MOVE.L  #SCRTIM,D3
            TRAP    #15
            ; - CLEAR SCRINTCT AND SCRCYCCT
            CLR.B   (SCRINTCT)
            CLR.B   (SCRCYCCT)
            ; - ENABLE INTS (SET INT BITS IN SR TO 000)
            MOVE.W   SR,D0
            AND.W    #$F8FF,D0
            MOVE.W   D0,SR
            RTS

; -----------------------------------------------------------------------------
SCRISR
; SCREEN TIMER ISR. INCREASES THE INTERRUPT COUNTER AND UPDATES DOUBLE BUFFER.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ADDQ.B  #1,(SCRINTCT)           ; UPDATE INT FLAG/COUNTER
            ADDQ.B  #1,(SCRCYCCT)           ; UPDATE CYCLE COUNTER
            RTE

; -----------------------------------------------------------------------------
SCRUPD
; TRAP SERVICE ROUTINE IN CHARGE OF VISUALIZING CURRENT FRAME AND CLEARING
; BUFFER FOR THE NEXT ONE.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ;GUARDAR REGISTRES A USAR
            MOVEM.L D0-D1,-(A7)
            ; TO DO: UPDATE DOUBLE BUFFER AND CLEAR HIDDEN BUFFER
            ;UPDATE DOUBLE BUFFER
            MOVE.B  #94,D0
            TRAP    #15
            
            ;CLEAR HIDDEN BUFFER
            MOVE.W  #$FF00,D1
            MOVE.B  #11,D0
            TRAP    #15
            
            ;RESTAURAR REGISTRES USATS
            MOVEM.L (A7)+,D0-D1
            RTE

; =============================================================================
; KEYBOARD MANAGEMENT (SYSTEM CODE)
; =============================================================================

; -----------------------------------------------------------------------------
KBDINIT
; INITIALIZES THE SYSTEM VARIABLES KBDSYS AND KBDVAL
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            CLR.B   (KBDVAL)                ; INIT VARS
            CLR.B   (KBDEDGE)
            MOVE.L  #KBDREAD,($80+KBDTRAP*4) ; INSTALL
            RTS

; -----------------------------------------------------------------------------
KBDREAD
; TRAP SERVICE ROUTINE.
; UPDATES THE SYSTEM VARIABLES KBDEDGE AND KBDVAL ACCORDING TO THE BITFIELD
; DESCRIBED IN SYSCONST. KBDVAL HOLDS THE CURRENT VALUES AND KBDEDGE HOLDS
; RISING EDGES FROM PREVIOUS CALL TO THE CURRENT ONE.
; INPUT    - NONE
; OUTPUT   - (KBDVAL) AND (KBDEDGE)
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            ; TO DO: UPDATE KBDVAL AND KBDEDGE
            ;GUARDA REGISTRES A PILA
            MOVEM.L D0-D4, -(A7)
            MOVE.B  (KBDVAL), D3
            ;TASK NUMERO 19 (DEL TRAP 15)
            MOVE.B  #19, D0
            ;GUARDA A D1 ELS VALORS DE LES TECLES DE TIPUS FLETXA
            MOVE.L  #KBDLEFT<<24+KBDUP<<16+KBDRIGHT<<8+KBDDOWN, D1
            TRAP    #15
            ;MOU ELS RESULTATS A D2
            MOVE.L  D1, D2
            ;REPETEIX PER LES ALTRES TECLES
            MOVE.B  #19, D0
            MOVE.L  #KBDFIRE1<<24+KBDFIRE2<<16+KBDFIRE3<<8+KBDPAUSE, D1
            TRAP    #15
            ;ACTUALITZA D3            
            BTST.L  #24, D2                 ; BTST.L #24,D1     ; test for 'a'
            BNE     .ESQUERRA               ; IF <NE> THEN      ; if 'a'

            ANDI.B  #KBDMSK0, D3
            BRA     .CONTINUA1
            
            ;FLETXA ESQUERRA
.ESQUERRA   ORI.B   #KBDMSKLF, D3           ; {a code}


.CONTINUA1  BTST.L  #16, D2                 ; BTST.L #16,D1     ; test for 's'

            BNE     .AMUNT
            ANDI.B  #KBDMSK1, D3
            BRA     .CONTINUA2
            
            ;FLETXA AMUNT
.AMUNT      ORI.B   #KBDMSKUP, D3           ; IF <NE> THEN      ; if 's'

            
.CONTINUA2  BTST.L  #8,D2                   ; ...
            BNE     .DRETA
            ANDI.B  #KBDMSK2, D3
            BRA     .CONTINUA3
            
            ;FLETXA DRETA
.DRETA      ORI.B   #KBDMSKRT, D3
            
.CONTINUA3  BTST.L  #0, D2
            BNE     .AVALL
            ANDI.B  #KBDMSK3, D3
            BRA     .CONTINUA4
            
            ;FLETXA AVALL
.AVALL      ORI.B   #KBDMSKDN, D3
            
.CONTINUA4  BTST.L  #24, D1
            BNE     .FIRE1
            ANDI.B  #KBDMSK4, D3
            BRA     .FINAL
            
            ;FIRE1 o ESPAI
.FIRE1      ORI.B   #KBDMSKF1, D3
            ;BRA     .FINAL                 ; NO FA FALTA

.FINAL      ;ACTUALITZA KBDVAL I KBDEDGE
            ;BACKUP DE KBDVAL
            MOVE.B  (KBDVAL), D1
            MOVE.B  D3, (KBDVAL)
            ;(NOT D1) AND D3
            NOT.B   D1
            AND.B   D1, D3
            MOVE.B  D3, (KBDEDGE)

            ;RESTAURA REGISTRES DES DE LA PILA
            MOVEM.L (A7)+, D0-D4
            RTE

; =============================================================================
; DYNAMIC MEMORY MANAGEMENT (SYSTEM CODE)
; DYNAMIC MEMORY IS A SET OF DMMBNUM SLOTS OF DMMBSIZE BYTES EACH ONE.
; DMMBSIZE MUST BE POWER OF TWO. A SLOT HAS:
; - HEADER - 1 WORD. SPECIFIES THE OWNER (0 MEANS OWNED BY SYSTEM)
; - DATA   - DMMBSIZE - 2 BYTES. MAY CONTAIN VARS AND ANY KIND OF DATA RELATED
;            THE THE OWNER. IF OWNER==0, DATA IS MEANINGLESS.
; =============================================================================

; -----------------------------------------------------------------------------
DMMINIT
; INITIALIZES THE DYNAMIC MEMORY TO ALL OWNED BY SYSTEM.
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            LEA     DMMDATA,A0
            MOVE.W  #DMMBNUM-1,D0
.LOOP       MOVE.W  #DMMSYSID,(A0)
            ADD.L   #DMMBSIZE,A0
            DBRA.W  D0,.LOOP
            MOVEM.L (A7)+,D0/A0
            RTS

; -----------------------------------------------------------------------------
DMMFIRST
; SEARCHES THE FIRST MEMORY SLOT NOT OWNED BY SYSTEM AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - NONE
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFRLOP    TST.W   (A0)+
            BNE     DMMFRFND
            ADD.L   #DMMBSIZE-2,A0
DMMFRCOM    CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFRLOP
            MOVE.L  #0,A0
DMMFRFND    RTS

; -----------------------------------------------------------------------------
DMMNEXT
; SEARCHES THE NEXT MEMORY SLOT NOT OWNED BY SYSTEM AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - A0   : POINTER WITHIN THE CURRENT SLOT
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFRCOM

; -----------------------------------------------------------------------------
DMMFRSTO
; SEARCHES THE FIRST MEMORY SLOT WITH THE SPECIFIED ID AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - D0.W : ID TO SEARCH
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            LEA     DMMDATA,A0
DMMFLOOP    CMP.W   (A0)+,D0
            BEQ     DMMFFND
            ADD.L   #DMMBSIZE-2,A0
DMMFCOM     CMP.L   #DMMDATA+DMMBSIZE*DMMBNUM-1,A0
            BLT     DMMFLOOP
            MOVE.L  #0,A0
DMMFFND     RTS

; -----------------------------------------------------------------------------
DMMNEXTO
; SEARCHES THE NEXT MEMORY SLOT WITH THE SPECIFIED ID AND OUTPUTS A POINTER
; TO THE CORRESPONDING DATA (SLOT ADDRESS+2)
; INPUT    - D0.W : ID TO SEARCH
;            A0   : POINTER WITHIN THE CURRENT SLOT
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FOUND
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.L  D0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            ADD.L   #DMMBSIZE,D0
            MOVE.L  D0,A0
            MOVE.L  (A7)+,D0
            BRA     DMMFCOM

; -----------------------------------------------------------------------------
DMMALLOC
; SEARCHES THE FIRST FREE (SYS OWNED) SLOT, ASSIGNS TO THE SPECIFIED OWNER
; AND RETURNS A POINTER TO THE CORRESPONDING DATA (SLOT ADDRESS + 2)
; INPUT    - D0.W : ID TO ASSIGN
; OUTPUT   - A0   : POINTER TO THE DATA OR 0 IF NOT FREE SPACE
; MODIFIES - NONE (ASIDE OF OUTPUT)
; -----------------------------------------------------------------------------
            MOVE.W  D0,-(A7)
            CLR.W   D0
            JSR     DMMFRSTO
            MOVE.W  (A7)+,D0
            CMP.L   #0,A0
            BEQ     .END
            MOVE.W  D0,-2(A0)
.END        RTS

; -----------------------------------------------------------------------------
DMMFREE
; FREES THE SLOT TO WHICH THE PROVIDED POINTER BELONGS BY SETTING ITS OWNED TO
; SYSTEM (0)
; INPUT    - A0   : POINTER BELONGING TO THE SLOT TO FREE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A0,-(A7)
            MOVE.L  A0,D0
            AND.L   #-DMMBSIZE,D0           ; TAKE ADVANTAGE OF ALIGNMENT
            MOVE.L  D0,A0
            CLR.W   (A0)
            MOVEM.L (A7)+,D0/A0
            RTS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~0~
*~Tab size~4~
