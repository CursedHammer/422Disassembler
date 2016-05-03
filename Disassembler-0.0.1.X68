*-----------------------------------------------------------
* Title      : 68k Disassembler
* Written by : Brandon Authier (Hblkr, Jack Eldridge, Marijn
* Date       : 2 May 2016
* Description: An inverse assembler that will convert a memory
*              image of instructions and data back to the display.
*              The following will be decoded:
*
*              Addressing Modes
*
*                Data Register Direct
*                Address Register Direct
*                Address Register Indirect
*                Immediate Data
*                Address Register Indirect with Post Increment
*                Address Register Indirect with Pre Decremet
*                Absolute Long Address
*                Absolute Word Address
*
*              Instructions
*
*                NOP
*                MOVE
*                MOVEQ
*                MOVEM
*                ADD
*                ADDA
*                ADDI
*                SUB
*                MULS
*                DIVU
*                LEA
*                CLR
*                AND
*                LSL
*                ASR
*                ROL
*                CMP
*                Bcc (BCC, BGT, BLE)
*                JSR
*                RTS
*
* VERSION: 0.1 - Initial Skeleton
*
*-----------------------------------------------------------

*----------- Definitions Used for Code ---------------------

PRTSTRCRLF    EQU    0               ; Trap function to print string + CRLF
PRTSTR  EQU   1                      ; Trap function to print string
READHEX EQU   2                      ; Read String

CR      EQU   $0D
LF      EQU   $0A

        ORG        $1000

*---------- Code For Output --------------------------------

*       Print Welcome Message
*       --------------------- 
START   LEA         INTRO,A1         ; Loads message into A1
        MOVE.B      #14,D0           ; Moves the TRACK 14 into D0
        TRAP        #15              ; Displays Intro Message 
        BSR         NEW_LINE         ; Call Subroutine

*       Prompt for Start Address
*       ------------------------        
        LEA         PROMPT1,A1       ; Loads message into A1
        MOVE.B      #14,D0           ; Moves the TRACK 14 into D0
        TRAP        #15              ; Displays StartAddr Message 
        
*       Read the Start Address
*       ----------------------
        MOVEA.L     #STARTADDR,A1    ; Pointer to store the sentence
        MOVE.B      #READHEX,D0      ; Set up readstring function
        TRAP        #15              ; Get string from keyboard
        CMPI.W      #0,D4            ; length = 0?
        BEQ         QUIT

*---------- Subroutines ------------------------------------

NEW_LINE:
        LEA         ENDL,A1         ; Loads message into A1
        MOVE.B      #14,D0          ; Moves the TRACK 14 into D0
        TRAP        #15             ; Displays New line
        RTS

BAD_INSTRUCTION:
        LEA         ILLEGAL,A1      ; Loads message into A1
        MOVE.B      #14,D0          ; Moves the TRACK 14 into D0
        TRAP        #15             ; Displays Bad Instruction Message
        RTS
 
QUIT    STOP        #$3000          ; Stop the program
   
*---------- Halt Simulater ---------------------------------

        SIMHALT                     ; halt simulator
        

*---------- Variables and Constants ------------------------

INTRO     DC.B  'WELCOME!',CR,LF,'This is a 68K disassembler.',CR,LF,0
PROMPT1   DC.B  'Please enter the starting address to be read (hex): 0x',0
PROMPT2   DC.B  'Please enter the ending address to be read (hex): 0x',0

MESSAGE3  DC.B  CR,LF,'',CR,LF,0
MESSAGE4  DC.B  '',CR,LF,0
MESSAGE5  DC.B  '',CR,LF,0

STARTADDR DS.L  80                  ; Var for starting address
ENDADDR   DS.L  80                  ; Var for ending address

ILLEGAL  DC.B  '1000    DATA    $WXYZ',CR,LF,0

ENDL     DC.B  CR,LF,0

        END        START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
