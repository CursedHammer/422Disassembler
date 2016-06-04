******************************************************************************
* Title      : I/O Subroutines
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 3 May 2016
* Description: Support file containing the I/O subroutines
*              for the disassembler.
******************************************************************************
*
* TODO:
*
* DONE:
*    Write data error
*    Chase down bug when you enter more the 8chars for address and it loops
*    Hex to ASCII
*    Write end function to ask user if they are done
*    Make sure addresses are even
*    ASCII to Hex
*    Make sure all hex values (nearly none)
*    Check that ending address is less than beginning address
*    Display full screens of data and clear
*
******************************************************************************


******************************************************************************
*           DEFINITIONS                                                      *
******************************************************************************

STR_LEN   EQU   $5020
HEXFLAG   EQU   $5021
HEXVALUE  EQU   $5030
REMAINDER EQU   $5050
MOD       EQU   2

CR        EQU   $0D
LF        EQU   $0A

* For buffer code
BUFFER  EQU     $5070               * Buffer address for string

* For End Program code
UPYES     EQU   'Y'
LOWYES    EQU   'y'

******************************************************************************
*           BEGIN CODE                                                       *
******************************************************************************

*---------- START ------------------------------------------------------------
* Begins program's logical flow. Similar to main in C/C++
*-----------------------------------------------------------------------------
GET_ADDRESSES
    JSR         CLEARSCRN
    JSR         IO_WELCOME          * Run welcome subroutine

GET_FIRST_ADDRESS
    LEA         PS1,A1              * Loads message into A1
    JSR         MAKE_CHECKS         * Get address and perform checks
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BNE         GET_FIRST_ADDRESS   * If no, get hex again

    MOVE.L      HEXVALUE,BEGINADDR  * Copy hex value to begin
    JSR         NEW_LINE            * Space
    JSR         CLEAR               * Clear values for next hex

GET_SECOND_ADDRESS
    LEA         PS2,A1              * Loads message into A1
    JSR         MAKE_CHECKS         * Get address and perform checks
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BNE         GET_SECOND_ADDRESS  * If no, get hex again

    MOVE.L      HEXVALUE,ENDADDR    * Copy hex value to begin
    JSR         NEW_LINE            * Space
    JSR         CLEAR               * Clear values for next hex

CHECK_BADDR_IS_LESS_THAN_EADDR
    JSR         IS_LESSTHAN         *
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BEQ         FINISHED            * If yes, finished
    LEA         ADR_ERR_NOTLT,A1    * Else, load error message
    BSR.W       ADDRESS_ERR
    BSR.W       START


FINISHED
    RTS                             * Return to Disassembler

*---------- END - START ------------------------------------------------------


******************************************************************************
*           SUB ROUTINES                                                     *
******************************************************************************

*---------- IO_WELCOME -------------------------------------------------------
* Prints a welcome message
*-----------------------------------------------------------------------------

IO_WELCOME:
    LEA         INTRO,A1            * Loads message into A1
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays Intro Message

    JSR         NEW_LINE            * Call Subroutine
    RTS                             * Return from subroutine

*---------- END - IO_WELCOME -------------------------------------------------


*---------- CLEAR ------------------------------------------------------------
* Clear HEXVALUE, D6, and STR_LEN. Then return to main.
*-----------------------------------------------------------------------------
CLEAR
    CLR.L       D6                   * Clear
    MOVE.W      #$FFFF,STR_LEN       * Clear
    MOVE.L      #$FFFFFFFF,HEXVALUE  * Clear
    MOVE.L      #$FFFFFFFF,REMAINDER * Clear
    RTS                              * Return to main to get hex

*---------- END - CLEAR ------------------------------------------------------


*---------- GET_HEXSTRING ----------------------------------------------------
* Read in the ASCII string address and verify length is <= 8.
*-----------------------------------------------------------------------------
GET_HEXSTRING
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    MOVE.W      #(PS2-PS1),D1       * The prompt string length
    TRAP        #15                 * Displays contents of A1

    LEA         HEXSTRING,A1        * Pointer to store the sentence
    MOVE.B      #2,D0               * Set up readstring function
    TRAP        #15                 * Get string from keyboard
    MOVE.B      D1,STR_LEN          * Save length of input string

    CMPI.B      #8,(STR_LEN)        * Is length > 8?
    BGT         BAD_LENGTH          * If yes, get hex again

    LEA         HEXSTRING,A0        * Load address for verification
    MOVE.B      #1,(HEXFLAG)
    RTS                             * Return from subroutine

BAD_LENGTH
    MOVE.B      #0,(HEXFLAG)        * Bad length set HEXFLAG to false
    RTS                             * Return to subroutine

*---------- END - GET_HEXSTRING ----------------------------------------------


*---------- ASCII_TO_HEX -----------------------------------------------------
* Checks to see if each character is hexadecimal
*-----------------------------------------------------------------------------
ASCII_TO_HEX
    MOVE.B      (A0)+,D3            * Move first char into D3
    CMPI.B      #'0',D3             * Is Char equal to 0?
    BEQ         HEXZERO
    CMPI.B      #'1',D3             * Is Char equal to 1?
    BEQ         HEXONE
    CMPI.B      #'2',D3             * Is Char equal to 2?
    BEQ         HEXTWO
    CMPI.B      #'3',D3             * Is Char equal to 3?
    BEQ         HEXTHREE
    CMPI.B      #'4',D3             * Is Char equal to 4?
    BEQ         HEXFOUR
    CMPI.B      #'5',D3             * Is Char equal to 5?
    BEQ         HEXFIVE
    CMPI.B      #'6',D3             * Is Char equal to 6?
    BEQ         HEXSIX
    CMPI.B      #'7',D3             * Is Char equal to 7?
    BEQ         HEXSEVEN
    CMPI.B      #'8',D3             * Is Char equal to 8?
    BEQ         HEXEIGHT
    CMPI.B      #'9',D3             * Is Char equal to 9?
    BEQ         HEXNINE
    CMPI.B      #'A',D3             * Is Char equal to A?
    BEQ         HEXA
    CMPI.B      #'B',D3             * Is Char equal to B?
    BEQ         HEXB
    CMPI.B      #'C',D3             * Is Char equal to C?
    BEQ         HEXC
    CMPI.B      #'D',D3             * Is Char equal to D?
    BEQ         HEXD
    CMPI.B      #'E',D3             * Is Char equal to E?
    BEQ         HEXE
    CMPI.B      #'F',D3             * Is Char equal to F?
    BEQ         HEXF
    CMPI.B      #'a',D3             * Is Char equal to a?
    BEQ         HEXA
    CMPI.B      #'b',D3             * Is Char equal to b?
    BEQ         HEXB
    CMPI.B      #'c',D3             * Is Char equal to c?
    BEQ         HEXC
    CMPI.B      #'d',D3             * Is Char equal to d?
    BEQ         HEXD
    CMPI.B      #'e',D3             * Is Char equal to e?
    BEQ         HEXE
    CMPI.B      #'f',D3             * Is Char equal to f?
    BEQ         HEXF

*   Value is not hex. Reset values and loop back to get hex
*   =======================================================
    MOVE.B      #0,HEXFLAG          * Set false
    BRA         CLEAR               * Clear some values

FOUND
    SUBI.B      #1,STR_LEN          * Decrease string by one
    CMPI.B      #0,STR_LEN          * Is string = 0?
    BNE         SHIFTLEFT           * If no, shift value left
    MOVE.L      D6,HEXVALUE         * If yes, save hex value
    MOVE.B      #1,HEXFLAG          * Set true
    RTS                             * Then, return to main

SHIFTLEFT
    LSL.L       #4,D6               * Shift the value left
    BRA         ASCII_TO_HEX        * Check next char

HEXZERO
    ADD.L       #$0,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXONE
    ADD.L       #$1,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXTWO
    ADD.L       #$2,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXTHREE
    ADD.L       #$3,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXFOUR
    ADD.L       #$4,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXFIVE
    ADD.L       #$5,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXSIX
    ADD.L       #$6,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXSEVEN
    ADD.L       #$7,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXEIGHT
    ADD.L       #$8,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXNINE
    ADD.L       #$9,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXA
    ADD.L       #$A,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXB
    ADD.L       #$B,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXC
    ADD.L       #$C,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXD
    ADD.L       #$D,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXE
    ADD.L       #$E,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left
HEXF
    ADD.L       #$F,D6              * Add value
    BRA         FOUND               * found, decrease strlen, shift value left

*---------- END - ASCII_TO_HEX -----------------------------------------------


*---------- IS_LESSTHAN ------------------------------------------------------
* Check to see if the starting hex address is less than the ending hex
* address.
*-----------------------------------------------------------------------------
IS_LESSTHAN
    MOVE.L      BEGINADDR,D4        * Store beginning address in D4
    MOVE.L      ENDADDR,D6          * Store ending address in D6
    CMP.L       D6,D4               * Is D4 < D6
    BLT         LT                  * Yes, mark true return to main
    MOVE.B      #0,HEXFLAG          * No, mark false
    BRA         CLEAR               * Clear values, return to main

LT
    MOVE.B      #1,HEXFLAG          * Mark true
    RTS                             * Return to main

*---------- END - IS_LESSTHAN ------------------------------------------------


*---------- IS_HEX_EVEN ------------------------------------------------------
* Check to see if the hex value given is even.
*-----------------------------------------------------------------------------
IS_HEX_EVEN
    MOVE.W      D6,D3               * Move value to be modded into D3
    MOVE.W      #MOD,D5             * Move mod value into D5
    DIVU        D5,D3               * Divide D3 by D5
    MOVE.B      #3,D1               * Set counter to shift value into word
                                    * position
REPEAT
    LSR.L       #4,D3               * Shift remainder to lower word
    DBEQ        D1,REPEAT           * UNTIL [D0] = - 1
    CLR         D1                  * Clear

    CMP.L       #0,D3               * Is hex even?
    BNE         NOTEVEN             * No, clear and go back to get_hex
    MOVE.W      D3,REMAINDER        * Save remainder
    MOVE.B      #1,HEXFLAG          * Set true
    RTS                             * Return to main

NOTEVEN
    MOVE.B      #0,HEXFLAG          * Set false
    BRA         CLEAR               * Clear values

*---------- END - IS_HEX_EVEN ------------------------------------------------


*---------- MAKE_CHECKS ------------------------------------------------------
* Prints a new line
*-----------------------------------------------------------------------------
MAKE_CHECKS
    JSR         GET_HEXSTRING       * Get string from user
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BNE         BAD_CHECK           * If no, get hex again

    JSR         ASCII_TO_HEX        * Convert ascii to hex
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BNE         BAD_CHECK           * If no, get hex again

    JSR         IS_HEX_EVEN         * Check that hex value is even
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BNE         BAD_CHECK           * If no, get hex again

    RTS                             * Return from subroutine

BAD_CHECK
    RTS                             * Return from subroutine

*---------- END - MAKE_CHECKS ------------------------------------------------


*---------- PRINT_HEXVALUE ---------------------------------------------------
* Prints out to display whatever is in A1
*-----------------------------------------------------------------------------
PRINT_HEXVALUE
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays contents of A1

    MOVE.B      #3,D0               * Moves the Task 3 into D0
    TRAP        #15                 * Displays contents of D1

    RTS                             * Return from subroutine

*---------- END - PRINT_HEXVALUE ---------------------------------------------

*---------- NEW_LINE ---------------------------------------------------------
* Prints a new line
*-----------------------------------------------------------------------------
NEW_LINE
    LEA         ENDL,A1             * Loads message into A1
    MOVE.B      #14,D0              * Moves the TRACK 14 into D0
    TRAP        #15                 * Displays New line
    RTS                             * Return from subroutine

*---------- END - NEW_LINE ---------------------------------------------------

*---------- CLEARSCRN --------------------------------------------------------
* Clear all output on screen
*-----------------------------------------------------------------------------
CLEARSCRN
    MOVE.B      #11,D0              * Task 11 for clearing screen
    MOVE.W      #$FF00,D1           * FF00, Clear screen
    TRAP        #15                 * Wait for keystroke
    RTS                             * Return from subroutine

*---------- END - CLEARSCRN --------------------------------------------------


******************************************************************************
*           ERROR SUBROUTINES                                                *
******************************************************************************

*---------- ADDRESS_ERR ------------------------------------------------------
* Clear all output on screen
*-----------------------------------------------------------------------------
ADDRESS_ERR
    BSR.W       CLEARSCRN           * Clear output before displaying error
    MOVE.B      #13,D0              * Moves the Task 13 into D0
    TRAP        #15                 * Displays contents of A1
    MOVE.B      #5,D0               * Read single character from
    TRAP        #15                 * The keyboard into D1.B
    RTS                             * Return from subroutine

*---------- END - ADDRESS_ERR ------------------------------------------------


*---------- INVALID_DATA -----------------------------------------------------
* Invalid data to print out to the user
*-----------------------------------------------------------------------------
INVALID_DATA
    MOVE.L      A6,D1               * Move the address location to D1
    MOVE.B      #16,D2              * Move base 16 to D2
    MOVE.B      #15,D0              * Moves Task 15 into D0
    TRAP        #15                 * Displays contents of D1

    LEA         TAB,A1              * Load TAB to A1
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays a tab of A1

    LEA         DATA,A1             * Load address location to A1
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays location of A1

    LEA         TAB,A1              * Load TAB to A1
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays a tab of A1

    LEA         DOLLAR,A1           * Load TAB to A1
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays a tab of A1

    MOVE.W      (A6),D1             * Move the address value to D1
    MOVE.B      #16,D2              * Move base 16 to D2
    MOVE.B      #15,D0              * Moves Task 15 into D0
    TRAP        #15                 * Displays value of D1

    LEA         ENDL,A1             * Load TAB to A1
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays a tab of A1

    RTS                             * Return from subroutine

*---------- END - INVALID_DATA -----------------------------------------------

******************************************************************************
*           BUFFER SUBROUTINES                                               *
******************************************************************************

WRITE2MEM
    CMP.B       #$00,(A4)           * Check if byte is string terminator
    BEQ         SKIP_WRITE          * If yes, skip write and return
    MOVE.B      (A4)+,(A2)+         * If no, write byte to memory
    BRA         WRITE2MEM           * Keep writing, not end of string
SKIP_WRITE
    MOVEA.L     #$00000000,A4       * Clean up A4
    RTS                             * Return to main

WRITE_ENDL
    MOVE.B      #CR,(A2)+           * Move carriage return into memory
    MOVE.B      #LF,(A2)+           * Move line feed into memory
    MOVE.B      #$00,(A2)+          * Move string terminator into memory
    RTS

PRINTLN
    LEA         BUFFER,A1               * Load BUFFER address into A1
    MOVE.B      #14,D0              * Task 14, no CR or LF
    TRAP        #15                 * Display string held in BUFFER
    RTS                             * Return to main

CLEAN_BUFF
    LEA         BUFFER, A2          * Reset buffer pointer
CLEAN_BUFF_LOOP:
    CMPI.L      #$FFFFFFFF,(A2)     *
    BEQ         BUFFDONE            * Buffer has been cleaned
    MOVE.L      #$FFFFFFFF,(A2)+    * Fill with F's
    BRA         CLEAN_BUFF_LOOP     * Continue cleaning buffer
BUFFDONE
    RTS                             * Return to main

NEW_PAGE
    CLR.L       D3                  * Clear counter
    LEA         ENTER,A1            * Load enter message into A1
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays contents of A1
    MOVE.B      #5,D0               * Read single character from
    TRAP        #15                 * The keyboard into D1.B
    BRA.W       CLEARSCRN           * Clear the screen.

*********** END - BUFFER SUBROUTINES *****************************************

******************************************************************************
*           END PROGRAM SUBROUTINES                                          *
******************************************************************************

*---------- RERUN ------------------------------------------------------------
* Check to see if the user would like to rerun the program
*-----------------------------------------------------------------------------

RERUN
    LEA         ENDQUESTION,A1      * Loads message into A1
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays Intro Message

    MOVE.B      #5,D0               * Move task 5 to read one char
    TRAP        #15                 * Trap 15 for IO

    CMPI.B      #UPYES,D1           * Is char = Y
    BEQ         NOTDONE             * If yes, notdone
    CMPI.B      #LOWYES,D1          * Is char = y
    BEQ         NOTDONE             * If yes, notdone
    MOVE.B      #0,(RUNAGAIN)       * 0 for false to end program
    RTS

NOTDONE
    MOVE.B      #1,(RUNAGAIN)       * 1 for true to rerun program
    BSR.W       CLEAR               * Clear all values
    BSR.W       CLEARSCRN           * Clear screen and return from subroutine
    RTS

*********** END - END PROGRAM SUBROUTINES ************************************






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
