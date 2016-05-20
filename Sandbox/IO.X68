* TODO:
*    Make checks, ending address should not be less than beginning
*    Hex to ASCII
*    Display full screens of data and clear

* DONE:
*    Make sure addresses are even
*    ASCII to Hex
*    Make sure all hex values (nearly none)
* 
*

******************************************************************************
*           DEFINITIONS                                                      *
******************************************************************************

STACK       EQU   $7000

BEGINADDR   EQU   $5000
ENDADDR     EQU   $5010
STR_LEN     EQU   $5020
HEXFLAG     EQU   $5021
HEXVALUE    EQU   $5030
REMAINDER   EQU   $5050
MOD         EQU   2

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
    LEA    STACK, SP                * SP is stored in A7
    JSR    IO_WELCOME               * Run welcome subroutine
            
GET_FIRST_ADDRESS
    LEA         PS1,A1              * Loads message into A1
    JSR         GET_HEXSTRING       * Get string from user
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BNE         GET_FIRST_ADDRESS   * If yes, get hex again
   
    JSR         ASCII_TO_HEX        * Convert ascii to hex
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BNE         GET_FIRST_ADDRESS   * If yes, get hex again
    
    JSR         IS_HEX_EVEN         * Check that hex value is even
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BNE         GET_FIRST_ADDRESS   * If yes, get hex again
   
    MOVE.L      HEXVALUE,BEGINADDR  * Copy hex value to begin
    LEA         BMESSAGE,A1         * Load message in A1 for display
    MOVE.L      (HEXVALUE),D1       * Load hex value into A1 for display 
    JSR         PRINT_HEXVALUE      * Display hex value
    JSR         NEW_LINE            * Space
    
    JSR         CLEAR               * Clear values for next hex
    
GET_SECOND_ADDRESS
    LEA         PS2,A1              * Loads message into A1
    JSR         GET_HEXSTRING       * Get string from user
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BNE         GET_SECOND_ADDRESS  * If yes, get hex again
   
    JSR         ASCII_TO_HEX        * Convert ascii to hex
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BNE         GET_SECOND_ADDRESS  * If yes, get hex again
    
    JSR         IS_HEX_EVEN         * Check that hex value is even
    CMPI.B      #1,HEXFLAG          * Does HEXFLAG = 1
    BNE         GET_SECOND_ADDRESS  * If yes, get hex again
   
    MOVE.L      HEXVALUE,ENDADDR    * Copy hex value to begin
    LEA         EMESSAGE,A1         * Load message in A1 for display
    MOVE.L      (HEXVALUE),D1       * Load hex value into A1 for display
    JSR         PRINT_HEXVALUE      * Display hex value
    JSR         NEW_LINE            * Space
    
    JSR         CLEAR               * Clear values for next hex
    
    SIMHALT                         * halt simulator
    
*---------- END - START ------------------------------------------------------
       
           
******************************************************************************
*           SUB ROUTINES                                                     *
******************************************************************************
           
*---------- IO_WELCOME -------------------------------------------------------
* Prints a welcome message
*-----------------------------------------------------------------------------

IO_WELCOME: 
            LEA     INTRO,A1        ; Loads message into A1
            MOVE.B  #14,D0          ; Moves the Task 14 into D0
            TRAP    #15             ; Displays Intro Message 
        
            JSR     NEW_LINE        ; Call Subroutine        
            RTS                     ; Return from subroutine
        
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
* Read in the starting address and verify length is <= 8.
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
    BGT         GET_HEXSTRING       * If yes, get hex again
       
    LEA         HEXSTRING,A0        * Load address for verification     
    MOVE.B      #1,(HEXFLAG)   
    RTS                             * Return from subroutine
        
*---------- END - GET_START_ADDR ---------------------------------------------


*---------- ASCII_TO_HEX -----------------------------------------------------------
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


*---------- IS_HEX_EVEN ------------------------------------------------------
* Check to see if the hex value given is even.
*-----------------------------------------------------------------------------
IS_HEX_EVEN      
    MOVE.W      D6,D3
    MOVE.W      #MOD,D5
    DIVU        D5,D3
    MOVE.B      #3,D1
    
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


*---------- PRINT_HEXVALUE ---------------------------------------------------
* Prints out to display whatever is in A1
*-----------------------------------------------------------------------------
PRINT_HEXVALUE
    MOVE.B      #14,D0              * Moves the Task 13 into D0
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


******************************************************************************
*           VARIABLES AND CONSTANTS                                          *
******************************************************************************

INTRO           DC.B  'WELCOME!',CR,LF,'This is a 68K disassembler.',CR,LF,0
PS1             DC.B  'Please enter the starting hex address (max 8 digits): $',0
PS2             DC.B  'Please enter the ending hex address (max 8 digits)  : $',0
BMESSAGE        DC.B  'Beginning addres is: ',0
EMESSAGE        DC.B  'Ending address is: ',0
ENDL            DC.B  CR,LF,0

HEXSTRING       DS.B  80            * Var for hex string

ILLEGAL         DC.B  '1000    DATA    $WXYZ',CR,LF,0

                END   START         * last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
