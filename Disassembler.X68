******************************************************************************
* Title      : 68k Disassembler
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 16 May 2016
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
*                Address Register Indirect with Pre Decrement
*                Absolute Long Address
*                Absolute Word Address
*
*              Instructions
*
*                NOP
*                MOVE
*                MOVEA
*                MOVEQ
*                MOVEM
*                ADD
*                ADDA
*                ADDI
*                ADDQ
*                SUB
*                MULS
*                DIVU
*                LEA
*                CLR
*                AND
*                OR
*                LSL
*                LSR
*                ASR
*                ASL
*                ROL
*                ROR
*                CMP
*                Bcc (BCC, BGT, BLE)
*                JSR
*                RTS
*
******************************************************************************

******************************************************************************
*           DEFINITIONS                                                      *
******************************************************************************
STACK     EQU   $7000               * Beginning address for stack pointer

BEGINADDR EQU   $5000               * Variable to hold beginning address value
ENDADDR   EQU   $5010               * Variable to hold ending address value

RUNAGAIN  EQU   $6000               * Run program again variable

RCOUNT    EQU   30                  * Row counter

START     ORG   $1000               * Program begins at address 1000

*********** END DEFINITIONS **************************************************


******************************************************************************
*           BEGIN CODE                                                       *
******************************************************************************

*---------- START ------------------------------------------------------------
* Begins program's logical flow. Similar to main in C/C++
*-----------------------------------------------------------------------------
    LEA         STACK,SP            * SP is stored in A7
    JSR         GET_ADDRESSES       * Runs GET_ADDRESSES and IO_WELCOME
    MOVEA.L     BEGINADDR,A6        * Assign beginning address to A6 for use
* Set up I/O
    LEA         BUFFER, A2
    JSR         CLEAN_BUFF
    MOVE.B      #RCOUNT, D2         * Row counter
LOOP
    LEA         BUFFER, A2          * Create a pointer to BUFFER
    JSR         WRITE_BEGINL        * Write address to BUFFER
    JSR         OC_PARSE            * Determine if there is an initial opcode match
    JSR         WRITE_ENDL          * Write an endline for A1 to BUFFER
    JSR         PRINTLN             * Print the BUFFER to user
    JSR         CLEAN_BUFF          * Clean the BUFFER for reuse
    SUBI.B      #1, D2              * Decrement row counter
    CMPI.B      #0, D2              * Is D2 = 0?
    BNE         LOOP_CHECK          * If counter != 0, continue with normal loop check
    JSR         NEW_PAGE            * Else (counter == 0), prompt for new page
    MOVE.B      #RCOUNT, D2         * Reset row counter
LOOP_CHECK
    CMPA.L      ENDADDR,A6          * Is pointer at end of address range?
    BNE         LOOP                * If not, continue processing addresses
END_LOOP                            * Else, end loop
    JSR         RERUN               * Does the user want to run program again
    CMPI.B      #1,(RUNAGAIN)       * Does RUNAGAIN = TRUE?
    BEQ         START               * If yes, rerun program
    STOP        #$3000              * Else, end program

*---------- END - START ------------------------------------------------------

*********** END BEGIN CODE ***************************************************


******************************************************************************
*           INCLUDES                                                         *
******************************************************************************

    INCLUDE 'IO.X68'
    INCLUDE 'OpCodes.X68'
    INCLUDE 'EA.X68'

    INCLUDE 'IOMessages.X68'
    INCLUDE 'OCMessages.X68'
    INCLUDE 'EAMessages.X68'

*********** END INCLUDES *****************************************************

*---------- Reserved Registers -----------------------------
*   A7: stack pointer
*   A6: current address (updated by subroutines)
*   D0: instruction validity flag (reset by main control
*       code, can be set to false by subroutines)
*-----------------------------------------------------------

*---------- End --------------------------------------------
               END  START          * Last line of source










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
