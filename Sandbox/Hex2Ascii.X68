******************************************************************************
* Title      : Ascii to Hex
* Written by : Brandon Authier
* Date       : 14 Apr 2016
* Description: A program that takes a string and turns it into hex.
*
******************************************************************************

******************************************************************************
*           DEFINITIONS                                                      *
******************************************************************************
ASCIIVALUE  EQU   $5060
BUFFER      EQU   $5070             * Buffer address for string

MASK8       EQU   %11110000000000000000000000000000
MASK7       EQU   %00001111000000000000000000000000
MASK6       EQU   %00000000111100000000000000000000
MASK5       EQU   %00000000000011110000000000000000
MASK4       EQU   %00000000000000001111000000000000
MASK3       EQU   %00000000000000000000111100000000
MASK2       EQU   %00000000000000000000000011110000
MASK1       EQU   %00000000000000000000000000001111

CR          EQU   $0D
LF          EQU   $0A 
            ORG   $1000
         
******************************************************************************
*           BEGIN CODE                                                       *
******************************************************************************

*---------- START ------------------------------------------------------------
* Begins program's logical flow. Similar to main in C/C++
*-----------------------------------------------------------------------------
START
    *MOVE.L      #$AB,D6             * Move BYTE parameter in for parsing 
    *MOVE.L      #$ABCD,D6             * Move WORD parameter in for parsing
    MOVE.L      #$ABCD1234,D6             * Move LONG parameter in for parsing
       
    *MOVE.L      #2,D7               * Move in length
    *MOVE.L      #4,D7               * Move in length
    MOVE.L      #8,D7               * Move in length

    LEA         BUFFER,A2           * Set A2 = BUFFER
    
CONVERT_TO_ASCII
    BSR.W       LONG_MASK
    BSR.W       WORD_MASK
    BSR.L       BYTE_MASK

    JSR         PRINT_ASCIIVALUE    * Display hex value
    
    SIMHALT                         * Halt simulator
    
*---------- END - START ------------------------------------------------------


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
    MOVE.B       #'0',D3          * Add value
    BRA         FOUND_ASCII         * Mark hexflag true and proceed    
ASCIIONE
    MOVE.B       #'1',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIITWO
    MOVE.B       #'2',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIITHREE
    MOVE.B      #'3',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIIFOUR
    MOVE.B       #'4',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIIFIVE
    MOVE.B      #'5',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIISIX
    MOVE.B       #'6',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIISEVEN
    MOVE.B      #'7',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIIEIGHT
    MOVE.B      #'8',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIININE
    MOVE.B      #'9',D3        * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIIA
    MOVE.B      #'A',D3
    BRA         FOUND_ASCII   * Mark hexflag true and proceed    
ASCIIB
    MOVE.B      #'B',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIIC
    MOVE.B      #'C',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIID
    MOVE.B      #'D',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIIE
    MOVE.B      #'E',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
ASCIIF
    MOVE.B      #'F',D3          * Add value
    BRA         FOUND_ASCII   * Mark hexflag true and proceed
        
*---------- END - HEX_TO_ASCII -----------------------------------------------


*---------- LONG_MASK --------------------------------------------------------
* Perform the long mask and proceed
*-----------------------------------------------------------------------------
LONG_MASK
    CMPI.B      #8,D7
    BLT         SKIP_LONG
    
    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK8,D3           * Mask everything but the 4 bits wanted
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$4,D3              * Shift 4 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * 
    
    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK7,D3           * Mask everything but the 4 bits wanted
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * 
    
    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK6,D3           * Mask everything but the 4 bits wanted
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$4,D3              * Shift 4 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            *

    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK5,D3           * Mask everything but the 4 bits wanted
    LSR.L       #$8,D3              * Shift 8 bits
    LSR.L       #$8,D3              * Shift 8 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            *
    
    RTS

SKIP_LONG
    RTS    
    
*---------- END - LONG_MASK --------------------------------------------------


*---------- WORD_MASK --------------------------------------------------------
* Perform the word mask and proceed
*-----------------------------------------------------------------------------
WORD_MASK
    CMPI.B      #4,D7
    BLT         SKIP_WORD
 
    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK4,D3           * Mask everything but the 4 bits wanted
    LSR.W       #$8,D3              * Shift 4 bits
    LSR.W       #$4,D3              * Shift 4 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * 
    
    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK3,D3           * Mask everything but the 4 bits wanted
    LSR.W       #$8,D3              * Shift 8 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            *
    
    RTS

SKIP_WORD
    RTS
    
*---------- END - WORD_MASK --------------------------------------------------


*---------- BYTE_MASK --------------------------------------------------------
* Perform the byte mask and proceed
*-----------------------------------------------------------------------------
BYTE_MASK
    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK2,D3           * Mask everything but the 4 bits wanted
    LSR.B       #$4,D3              * Shift 4 bits
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            * 
    
    MOVE.L      D6,D3               * Reset D3 for next 4 bits
    ANDI.L      #MASK1,D3           * Mask everything but the 4 bits wanted
    BSR.W       HEX_TO_ASCII        * Store hex as ascii value in A0
    MOVE.B      D3,(A2)+            *
    
    MOVE.B      #CR,(A2)+           * Move carriage return into memory
    MOVE.B      #LF,(A2)+           * Move line feed into memory
    MOVE.B      #$00,(A2)+          * Move string terminator into memory
    RTS
    
*---------- END - BYTE_MASK --------------------------------------------------


*---------- PRINT_ASCIIVALUE -------------------------------------------------
* Prints out to display whatever is in A1
*-----------------------------------------------------------------------------
PRINT_ASCIIVALUE
    LEA         ASCIIPROMPT,A1      * Load message in A1 for display
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays contents of A1
    
    LEA         BUFFER,A1           * Load message in A1 for display
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays contents of A1
    
    RTS                             * Return from subroutine                                  

*---------- END - PRINT_ASCIIVALUE -------------------------------------------


******************************************************************************
*           VARIABLES AND CONSTANTS                                          *
******************************************************************************

ASCIIPROMPT     DC.B  'The ASCII value is: 0x',0

                END   START         * Last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
