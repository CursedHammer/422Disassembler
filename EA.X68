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
        

* Get destination register
        MOVE.W      (A5), D1        ; Load word at current pointer to D1
        MOVE.B      #4, D2          ; Clear upper 4 bits of opcode word
        LSL.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      #13, D2         ; 'Right-align' bits 9-11 to determine mode bits
        LSR.W       D2, D1          ; Perform shift (zeros shifted in)

        *get default ea
        JSR         EA_DEFAULT_COMBO
        *check validity via jump table
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
        CLR.L       D0              ; Set instruction validity flag to false
        MOVEM.L     (SP)+, A0-A6/D0-D7 ; Restore registers
        RTS                         ; Return program control to OpCode subroutine

*---------- Parse Default Combo ----------------------------
* Parses and separates values in the default mode/register
* data combo found at the end of many opcode words.
* POST: mode bits in D6, register bits in D7
*-----------------------------------------------------------
EA_DEFAULT_COMBO:  
        MOVEM.W     A0-A4/D0-D5, -(SP) ; Save registers (excluding D6 and D7, used
                                       ; to return results, A5-A7 are addresses and SP)
        CLR.B       D6              ; Clear space for mode bits
        CLR.B       D7              ; Clear space for register bits
* Get Mode
        MOVE.L      (A5), D1        ; Load opcode to data register 1
        MOVE.B      #10, D2         ; Clear upper 10 bits of opcode word
        LSL.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      #13, D2         ; 'Right-align' bits 3-5 to determine mode bits
        LSR.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      D1, D6          ; Save mode bits to D6
* Get Register
        MOVE.L      (A5), D1        ; Reload opcode to data register 1
        MOVE.B      #13, D2         ; Clear upper 13 bits of opcode word
        LSL.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      #13, D2         ; 'Right-align' bits 0-2 to determine register bits
        LSR.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      D1, D7          ; Save register bits to D7
        
        MOVEM.L     (SP)+, A0-A4/D0-D5 ; Restore registers
        RTS                         ; Return from subroutine

*-- Read & Print Subroutines -------------------------------

*---------- Data Register Direct ---------------------------
* Example Description
*-----------------------------------------------------------
        
*---------- Address Register Direct ------------------------
* Example Description
*-----------------------------------------------------------

*---------- Address Register Indirect ----------------------
* Example Description
*-----------------------------------------------------------

*---------- Immediate Data ---------------------------------
* Example Description
*-----------------------------------------------------------

*---------- Address Register Indirect w/ Post Increment ----
* Example Description
*-----------------------------------------------------------

*---------- Address Register Indirect w/ Post Increment ----
* Example Description
*-----------------------------------------------------------

*---------- Absolute Long Address --------------------------
* Example Description
*-----------------------------------------------------------

*---------- Absolute Word Address --------------------------
* Example Description
*-----------------------------------------------------------


*----------- Variables and Constants -----------------------




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
