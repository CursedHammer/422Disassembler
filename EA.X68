*-----------------------------------------------------------
* Title      : Effective Addressing Subroutines
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 3 May 2016
* Description: Support file containing the effective
*              addressing subroutines for the disassembler.
*-----------------------------------------------------------

*----------- Definitions Used for Code ---------------------

*----------- Subroutines: ----------------------------------
*--Generic--------------------------------------------------
EA_REG
EA_MODE
EA_OPMODE
EA_CONSTANT ; might not need this one? would just skip those bits
EA_SIZE     ; need to be careful here, size codes may be different among different instructions
EA_COUNT_REG ; for rotations and shifts
*--Instruction-Specific-------------------------------------
EA_MOVEQ
EA_MOVEM
EA_COND     ; specific to Bcc
*---------- Example Subroutine -----------------------------
* Example Description
*-----------------------------------------------------------

*----------- Variables and Constants -----------------------


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
