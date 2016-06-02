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

RUNAGAIN  EQU   $6000               * Value equivalent to 'true'

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

LOOP
    * OC_PARSE Command doesn't work due to issues in the Opcode include
    * many errors need to be fixed. Same with EA include

    LEA         BUFFER, A2
    JSR         OC_PARSE            * Determine if there is an initial opcode match
    JSR         WRITE_ENDL
    JSR         PRINTLN
    LEA         BUFFER, A2
    JSR         CLEAN_BUFF

    * decrement row count
    * if at 0, prompt for next page
    * else, continue

    *JSR         INVALID_DATA
    *ADDA.L      #$00000002,A6            * Advance address to test LOOP (test only)

LOOP_CHECK
    * Changed the following code from:
    * CMPA        A6, ENDADDR
    * to:
    * CMPA      (ENDADDR),A6
    * When using the CMPA, destination must be an address so A6
    CMPA.L      ENDADDR,A6          * Is pointer at end of address range?

    BGT         END_LOOP            * If yes, END_LOOP
    ; in case this resets status register, do another compare TODO

    BNE         LOOP                * If not, continue processing addresses
    ; If at end of address range, check if user wants to continue
    ; if user wants to continue, restart
    ; else, end

END_LOOP
    JSR         KEEP_RUNNING        * Does the user want to run program again
    CMPI.B      #1,(RUNAGAIN)       * Does RUNAGAIN = TRUE?
    BEQ         START               * If yes, rerun program
    STOP        #$3000              * Else, end program

*---------- END - START ------------------------------------------------------

*********** END BEGIN CODE ***************************************************


******************************************************************************
*           VARIABLES AND CONSTANTS                                          *
******************************************************************************

******************************************************************************
*           INCLUDES                                                         *
******************************************************************************

    INCLUDE 'IO.X68'
    INCLUDE 'OpCodes.X68'
    INCLUDE 'EA.X68'
    INCLUDE 'EndProgram.X68'
    INCLUDE 'WriteBuffer.X68'

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
