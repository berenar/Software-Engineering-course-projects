; =============================================================================
; SYSTEM CONSTANTS
; =============================================================================

; --- GAME STATES -------------------------------------------------------------

STANONE     EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
STAINTR     EQU     0                       ; INTRO/PRESS SPACE BAR STATE
STAPLAY     EQU     1                       ; NORMAL GAME STATE
STAGOVR     EQU     2                       ; GAME OVER STATE

; --- AGENT TYPES -------------------------------------------------------------

ASTTYPE     EQU     2

; --- FONS DE PANTALLA RELATED CONSTANTS --------------------------------------
CELCOL      EQU     $00FFCC66               ; COLOR DEL CEL
SOLCOL      EQU     $0000FFFF               ; COLOR DEL SOL
NUVOLCOL    EQU     $00E6FFFF               ; COLOR DELS NUVOLS

; --- OCELL RELATED CONSTANTS  ------------------------------------------------

PLRWIDTH    EQU     30                      ; PLAYER WIDTH
PLRHEIGH    EQU     30                      ; PLAYER HEIGHT
PLRSPEED    EQU     12                      ; PLAYER SPEED
PLRNRMCL    EQU     $0000C0FF               ; PLAYER NORMAL COLOR
PLRWNGCL    EQU     $00007ACC               ; COLOR DE L'ALA DE L'OCELL
PLRWNGCL2   EQU     $00005C99               ; COLOR DE L'ALA DE L'OCELL
PLREYCL     EQU     $00FFFFFF               ; COLOR GLOBUS OCULAR
PLREYCL2    EQU     $00000000               ; COLOR PUPIL.LA
PLRTXTCL    EQU     $00FFFFFF               ; FONT COLOR
PLRTXTX     EQU     1                       ; SCORE X COORDINATE
PLRTXTY     EQU     1                       ; SCORE Y COORDINATE
PLRINIX     EQU     SCRWIDTH/2              ; PLAYER X POSITION IN TITLE
PLRINIY     EQU     SCRHEIGH/2              ; PLAYER Y POSITION IN TITLE
GRAVETAT    EQU     2                       ; GRAVETAT APLICADA A L'OCELL
ALETEIG     EQU     $F

; --- CANONADA RELATED CONSTANTS ----------------------------------------------

HOLESIZE     EQU     100                      ; HOLE SIZE
CANOWIDTH    EQU     100                     ; AMPLADA DE LA CANONADA
CANOPENCL    EQU     $0000B300               ; PIPE PEN COLOR
CANOFILCL    EQU     $0000CC00               ; PIPE FIL COLOR
CSHAPENCL    EQU     $00008000               ; PIPE SHADOW PEN COLOR
CSHAFILCL    EQU     $0000FF00               ; PIPE SHADOW FIL COLOR
CANOEDGE     EQU     5                       ; PIPE EDGE WIDTH
CANOSPEED    EQU     5                       ; FIRST PIPE SPEED 
CANOSCORE    EQU     1                       ; SCORE FOR PIPE

; --- INTRO STATE RELATED CONSTANTS -------------------------------------------

INTTITX     EQU     SCRWIDTH/20              ; TITLE X COORDINATE
INTTITY     EQU     SCRHEIGH/40              ; TITLE Y COORDINATE
INTC        EQU     $00000000                ; TITLE COLOR
INTPRSX     EQU     SCRWIDTH/20              ; PRESS FIRE X COORDINATE
INTPRSY     EQU     SCRHEIGH/20              ; PRESS FIRE Y COORDINATE
INTARRX     EQU     SCRWIDTH/20              ; PRESS ARROWS X COORDINATE
INTARRY     EQU     SCRHEIGH/18              ; PRESS ARROWS Y COORDINATE


; --- GAME OVER STATE RELATED CONSTANTS ---------------------------------------

GOVSTRX     EQU     SCRWIDTH/20             ; TITLE X COORDINATE
GOVSTRY     EQU     SCRHEIGH/40             ; TITLE Y COORDINATE
GOVSTRC     EQU     $00000000               ; TITLE COLOR
LUCKSTRX    EQU     SCRWIDTH/20             ; GOOD LUCK X COORDINATE
LUCKSTRY    EQU     SCRHEIGH/20             ; GOOD LUCK Y COORDINATE
RETRYSTRX   EQU     SCRWIDTH/20             ; RETRY X COORDINATE
RETRYSTRY   EQU     SCRHEIGH/18             ; RETRY Y COORDINATE
        

; --- AUDIO RELATED CONSTANTS -------------------------------------------------

AUDPK1ID    EQU     1                       ; ID OF PICK ITEM 1 SOUND
AUDARGID    EQU     2                       ; ID OF ARGH SOUND
AUDENDID    EQU     $FF                     ; ID TO STOP ALL SOUNDS
AUDMSKLP    EQU     $80                     ; LOOP AUDIO MASK
AUDMSKNL    EQU     $00                     ; NO LOOP AUDIO MASK
AUDACCY     EQU     $FF                     ; ACCEPT PLAYING NEW SOUND
AUDACCN     EQU     $00                     ; DO NOT PLAY NEW SOUND


























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
