*-----------------------------------------------------------
* Title      : 68k Disassembler
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
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
* VERSION: 0.2 - Initial Skeleton v2
*
*-----------------------------------------------------------

START   ORG        $1000

        JSR         WELCOME
        BRA         QUIT

*---------- Utility Subroutines ----------------------------

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

*---------- Subroutine Files -------------------------------

    INCLUDE 'io-0.1.X68'            ; not married to these file names,
                                    ; this can be changed
    INCLUDE 'opcodes-0.1.X68'
    INCLUDE 'ea-0.1.X68'
   
*---------- Halt Simulator ---------------------------------

        SIMHALT                     ; halt simulator        

*---------- Variables and Constants ------------------------

STARTADDR DS.L  80                  ; Var for starting address
ENDADDR   DS.L  80                  ; Var for ending address

*---------- End --------------------------------------------
        END        START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
