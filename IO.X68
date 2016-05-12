*-----------------------------------------------------------
* Title      : I/O Subroutines
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 3 May 2016
* Description: Support file containing the I/O subroutines
*              for the disassembler.
*-----------------------------------------------------------

*----------- Definitions Used for Code ---------------------

PRTSTRCRLF EQU      0               ; Trap function to print string + CRLF
PRTSTR  EQU         1               ; Trap function to print string
READHEX EQU         2               ; Read String

CR      EQU         $0D
LF      EQU         $0A

*---------- Subroutines: -----------------------------------

*---------- Welcome ----------------------------------------
* Prints welcome messages and gathers initial parameters
*-----------------------------------------------------------
IO_WELCOME:
        MOVEM.W     A0-A6/D0-D7, -(SP) ; Save registers
        
*       Print Welcome Message
*       --------------------- 
        LEA         INTRO,A1        ; Loads message into A1
        MOVE.B      #14,D0          ; Moves the TRACK 14 into D0
        TRAP        #15             ; Displays Intro Message 
        BSR         NEW_LINE        ; Call Subroutine

*       Prompt for Start Address
*       ------------------------        
        LEA         PROMPT1,A1      ; Loads message into A1
        MOVE.B      #14,D0          ; Moves the TRACK 14 into D0
        TRAP        #15             ; Displays StartAddr Message 
        
*       Read the Start Address
*       ----------------------
        MOVEA.L     #STARTADDR,A1   ; Pointer to store the sentence
        MOVE.B      #READHEX,D0     ; Set up readstring function
        TRAP        #15             ; Get string from keyboard
        CMPI.W      #0,D4           ; length = 0?
        BEQ         QUIT            ; @histamineblkr: there is a limit to the offset
                                    ; allowed with a Bcc statement...proposed
                                    ; implementation below using JSR so that we aren't limited
                                     
*       BEQ         IO_WELCOME_QUIT
*IO_WELCOME_QUIT:
*       JSR         QUIT  
       
        *@histamineblkr: I think you continue working from here
        
        MOVEM.W     (SP)+, A0-A6/D0-D7 ; Restore registers
        RTS                         ; Exit subroutine

*---------- Variables and Constants ------------------------

INTRO   DC.B        'WELCOME!',CR,LF,'This is a 68K disassembler.',CR,LF,0
PROMPT1 DC.B        'Please enter the starting address to be read (hex): 0x',0
PROMPT2 DC.B        'Please enter the ending address to be read (hex): 0x',0

MESSAGE3 DC.B       CR,LF,'',CR,LF,0
MESSAGE4 DC.B       '',CR,LF,0
MESSAGE5 DC.B       '',CR,LF,0

ILLEGAL DC.B        '1000    DATA    $WXYZ',CR,LF,0

ENDL    DC.B        CR,LF,0




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
