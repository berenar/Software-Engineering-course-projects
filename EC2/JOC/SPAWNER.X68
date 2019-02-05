; =============================================================================
; SPAWNER MANAGEMENT
; =============================================================================

; -----------------------------------------------------------------------------
SPWUPD
; UPDATES THE SPAWNER
; INPUT    - NONE
; OUTPUT   - NONE
; MODIFIES - NONE
; -----------------------------------------------------------------------------
            MOVEM.L D0/A1-A3,-(A7)
.PIPES      MOVE.B  (SCRCYCCT),D0
            AND     #$3F,D0                 ; EVERY 64 CYCLES
            BNE     .END
            LEA     CANOINIT,A1
            LEA     CANOUPD,A2
            LEA     CANOPLOT,A3
            MOVE.W  #ASTTYPE,D0
            JSR     AGLADD
.END        MOVEM.L (A7)+,D0/A1-A3
            RTS









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
