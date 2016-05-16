*-----------------------------------------------------------
* Title      : Effective Addressing Subroutines
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 16 May 2016
* Description: Support file containing the effective
*              addressing subroutines for the disassembler.
*-----------------------------------------------------------

*-- Definitions Used for Code ------------------------------
        INCLUDE 'EAMessages.X68'


*-- Subroutines: -------------------------------------------
EA_ADD  
EA_ADDA
EA_ADDI
EA_ADDQ
EA_AND
EA_ASL
EA_ASR
EA_BCC
EA_CLR
EA_CMP
EA_DIVU
EA_JSR
EA_LEA
EA_LSL
EA_LSR
EA_MOVE
EA_MOVEA
EA_MOVEM
EA_MOVEQ

EA_MULS_W:
        MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        MOVE.W      (A5), D1        ; Load word at current pointer to D1 
        
EA_NOP
EA_OR
EA_ROL
EA_ROR
EA_RTS
EA_SUB

*---------- Example Subroutine -----------------------------
* Example Description
*-----------------------------------------------------------

*-- Utility Subroutines ------------------------------------

*---------- Invalid OpCode ---------------------------------
* Executes an early RTS, after setting the validity flag to
* 'False' and restoring registers. Not really a subroutine: 
* is utilized by JMP instructions from EA subroutines,
* so that the RTS is effective at returning from the parent
* EA subroutine
*-----------------------------------------------------------
EA_INVALID:
        CLR.L       D1              ; Set instruction validity flag to false
        MOVEM.L     (SP)+, A0-A6/D0-D7 ; Restore registers
        RTS                         ; Return program control to OpCode subroutine

*---------- Parse Default Combo ----------------------------
* Parses and separates values in the default mode/register
* data combo found at the end of many opcode words
*-----------------------------------------------------------
EA_DEFAULT_COMBO:  
        MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers

        

*----------- Variables and Constants -----------------------



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
