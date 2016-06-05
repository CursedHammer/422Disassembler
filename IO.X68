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
*    Make sure all hex values
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

* For Hex to ASCII code
MASK8       EQU   %11110000000000000000000000000000
MASK7       EQU   %00001111000000000000000000000000
MASK6       EQU   %00000000111100000000000000000000
MASK5       EQU   %00000000000011110000000000000000
MASK4       EQU   %00000000000000001111000000000000
MASK3       EQU   %00000000000000000000111100000000
MASK2       EQU   %00000000000000000000000011110000
MASK1       EQU   %00000000000000000000000000001111

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
    JSR         IS_LESSTHAN         * Subroutine to verigy baddr < eaddr
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BEQ         FINISHED            * If yes, finished
    LEA         ADR_ERR_NOTLT,A1    * Else, load error message
    BSR.W       ADDRESS_ERR         * Subroutine if address error
    
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
* Checks that the given Ascii string is hex and is even
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
* Clear all output on screen and displays the error message
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
    JSR         CLEAN_BUFF          * Clean buffer
    LEA         BUFFER, A2          * Reset buffer pointer
    MOVE.L      A6,D6               * Move the address location to D6
    MOVE.L      #8,D7               * Set size to L
    JSR         WRITEDATA2MEM       * Write address to buffer

    LEA         TAB,A4              * Load TAB to A4
    JSR         WRITE2MEM           * Write tab to buffer

    LEA         DATA,A4             * Load DATA to A4
    JSR         WRITE2MEM           * Write 'DATA' to buffer

    LEA         TAB,A4              * Load TAB to A4
    JSR         WRITE2MEM           * Write tab to buffer

    LEA         DOLLAR,A4           * Load DOLLAR to A4
    JSR         WRITE2MEM           * Write '$' to buffer

    CLR.L       D6
    MOVE.W      (A6),D6             * Move the address value to D6
    MOVE.L      #4,D7               * Set size to W
    JSR         WRITEDATA2MEM       * Write address to buffer

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
    
WRITE_BEGINL
    MOVE.B      #'$',(A2)+          * Write a '$' to BUFFER 
    MOVE.L      A6,D6               * Copy address to D6
    MOVE.B      #8,D7               * Set LONG for WRITEDATA2MEM
    BSR.W       WRITEDATA2MEM       * Write address to BUFFER
    MOVE.B      #' ',(A2)+          * Write a ' ' to BUFFER
    MOVE.B      #' ',(A2)+          * Write a ' ' to BUFFER
    MOVE.B      #' ',(A2)+          * Write a ' ' to BUFFER
    MOVE.B      #' ',(A2)+          * Write a ' ' to BUFFER
    RTS                             * Return program control

PRINTLN
    LEA         BUFFER,A1           * Load BUFFER address into A1
    MOVE.B      #14,D0              * Task 14, no CR or LF
    TRAP        #15                 * Display string held in BUFFER
    RTS                             * Return to main

CLEAN_BUFF
    LEA         BUFFER, A2          * Reset buffer pointer
CLEAN_BUFF_LOOP:
    CMPI.L      #$FFFFFFFF,(A2)     * Is it default value?
    BEQ         BUFFDONE            * Buffer has been cleaned
    MOVE.L      #$FFFFFFFF,(A2)+    * Fill with F's
    BRA         CLEAN_BUFF_LOOP     * Continue cleaning buffer
BUFFDONE
    RTS                             * Return to main

NEW_PAGE
    LEA         ENTER,A1            * Load enter message into A1
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays contents of A1
    MOVE.B      #5,D0               * Read single character from
    TRAP        #15                 * The keyboard into D1.B
    JSR         CLEARSCRN           * Clear the screen.
    RTS

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

******************************************************************************
*           DATA PRINTING SUBROUTINES                                        *
******************************************************************************

*---------- WRITEDATA2MEM ----------------------------------------------------
* Like WRITE2MEM, writes hex value to buffer after converting it to ASCII
* PRE: Value to print in D6, size in D7 (B: 2, W: 4, L: 8)
*-----------------------------------------------------------------------------
WRITEDATA2MEM
    BSR.W       LONG_MASK
    BSR.W       WORD_MASK
    BSR.L       BYTE_MASK
    RTS

*---------- HEX_TO_ASCII -----------------------------------------------------
* Checks to see if each character is hexadecimal
*-----------------------------------------------------------------------------
HEX_TO_ASCII
    CMPI.B      #$0,D3              * Is Char equal to 0?
    BEQ         ASCIIZERO
    CMPI.B      #$1,D3              * Is Hex equal to 1?
    BEQ         ASCIIONE
    CMPI.B      #$2,D3              * Is Hex equal to 2?
    BEQ         ASCIITWO
    CMPI.B      #$3,D3              * Is Hex equal to 3?
    BEQ         ASCIITHREE
    CMPI.B      #$4,D3              * Is Hex equal to 4?
    BEQ         ASCIIFOUR
    CMPI.B      #$5,D3              * Is Hex equal to 5?
    BEQ         ASCIIFIVE
    CMPI.B      #$6,D3              * Is Hex equal to 6?
    BEQ         ASCIISIX
    CMPI.B      #$7,D3              * Is Hex equal to 7?
    BEQ         ASCIISEVEN
    CMPI.B      #$8,D3              * Is Hex equal to 8?
    BEQ         ASCIIEIGHT
    CMPI.B      #$9,D3              * Is Hex equal to 9?
    BEQ         ASCIININE
    CMPI.B      #$A,D3              * Is Hex equal to A?
    BEQ         ASCIIA
    CMPI.B      #$B,D3              * Is Hex equal to B?
    BEQ         ASCIIB
    CMPI.B      #$C,D3              * Is Hex equal to C?
    BEQ         ASCIIC
    CMPI.B      #$D,D3              * Is Hex equal to D?
    BEQ         ASCIID
    CMPI.B      #$E,D3              * Is Hex equal to E?
    BEQ         ASCIIE
    CMPI.B      #$F,D3              * Is Hex equal to F?
    BEQ         ASCIIF

    RTS

FOUND_ASCII
    SUBI.B      #1,D7               * Decrease string by one
    RTS                             * Then, return to main

ASCIIZERO
    MOVE.B       #'0',D3            * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIIONE
    MOVE.B       #'1',D3            * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIITWO
    MOVE.B       #'2',D3            * Copy value to D3Add value
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIITHREE
    MOVE.B      #'3',D3             * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIIFOUR
    MOVE.B       #'4',D3            * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIIFIVE
    MOVE.B      #'5',D3             * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIISIX
    MOVE.B       #'6',D3            * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIISEVEN
    MOVE.B      #'7',D3             * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIIEIGHT
    MOVE.B      #'8',D3             * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIININE
    MOVE.B      #'9',D3             * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIIA
    MOVE.B      #'A',D3             * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIIB
    MOVE.B      #'B',D3             * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIIC
    MOVE.B      #'C',D3             * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIID
    MOVE.B      #'D',D3             * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIIE
    MOVE.B      #'E',D3             * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return
ASCIIF
    MOVE.B      #'F',D3             * Copy value to D3
    BRA         FOUND_ASCII         * Found ascii proceed and return

*---------- END - HEX_TO_ASCII -----------------------------------------------


*---------- LONG_MASK --------------------------------------------------------
* Perform the long mask and proceed
*-----------------------------------------------------------------------------
LONG_MASK
    CMPI.B      #8,D7               * Is D7 < 8
    BLT         SKIP_LONG           * If yes, skip LONG_MASK

    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK8,D3           * Mask everything but the 4 bits wanted
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$4,D3              * Shift 4 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * Move value to A2 pointer

    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK7,D3           * Mask everything but the 4 bits wanted
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * Move value to A2 pointer

    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK6,D3           * Mask everything but the 4 bits wanted
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$4,D3              * Shift 4 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * Move value to A2 pointer

    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK5,D3           * Mask everything but the 4 bits wanted
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * Move value to A2 pointer

    RTS                             * Return program control

SKIP_LONG
    RTS                             * Return program control

*---------- END - LONG_MASK --------------------------------------------------


*---------- WORD_MASK --------------------------------------------------------
* Perform the word mask and proceed
*-----------------------------------------------------------------------------
WORD_MASK
    CMPI.B      #4,D7               * Is D7 < 4
    BLT         SKIP_WORD           * If yes, skip WORD_MASK

    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK4,D3           * Mask everything but the 4 bits wanted
    LSR.W       #$8,D3              * Shift 4 bits
    LSR.W       #$4,D3              * Shift 4 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * Move value to A2 pointer

    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK3,D3           * Mask everything but the 4 bits wanted
    LSR.W       #$8,D3              * Shift 8 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * Move value to A2 pointer

    RTS                             * Return program control

SKIP_WORD
    RTS                             * Return program control

*---------- END - WORD_MASK --------------------------------------------------


*---------- BYTE_MASK --------------------------------------------------------
* Perform the byte mask and proceed
*-----------------------------------------------------------------------------
BYTE_MASK
    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK2,D3           * Mask everything but the 4 bits wanted
    LSR.B       #$4,D3              * Shift 4 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * Move value to A2 pointer

    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK1,D3           * Mask everything but the 4 bits wanted
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * Move value to A2 pointer
    
    RTS                             * Return program control

*---------- END - BYTE_MASK --------------------------------------------------

*********** END - END PROGRAM SUBROUTINES ************************************







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
