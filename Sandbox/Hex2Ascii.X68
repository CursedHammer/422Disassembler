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
BEGIN       EQU   $2000
END         EQU   $2010
STR_LEN     EQU   $2020
HEXFLAG     EQU   $2021
HEXVALUE    EQU   $2030

CR          EQU   $0D
LF          EQU   $0A 

            ORG    $1000
            
******************************************************************************
*           BEGIN CODE                                                       *
******************************************************************************

*---------- START ------------------------------------------------------------
* Begins program's logical flow. Similar to main in C/C++
*-----------------------------------------------------------------------------
START
PRINT_HEX_AS_ASCII
    JSR         IO_WELCOME          * Print welcome message   
    
    JSR         PRINT_HEXVALUE      * Display hex value
    
    SIMHALT                         * Halt simulator
    
*---------- END - START ------------------------------------------------------


*---------- IO_WELCOME -------------------------------------------------------
* Prints a welcome message
*-----------------------------------------------------------------------------

IO_WELCOME 
    LEA         INTRO,A1            * Loads message into A1
    MOVE.B      #14,D0              * Moves the Task 14 into D0
    TRAP        #15                 * Displays Intro Message 
      
    JSR         NEW_LINE            * Call Subroutine        
    RTS                             * Return from subroutine
        
*---------- END - IO_WELCOME -------------------------------------------------


*---------- NEW_LINE ---------------------------------------------------------
* Prints a new line
*-----------------------------------------------------------------------------
NEW_LINE
    LEA         ENDL,A1             * Loads message into A1
    MOVE.B      #14,D0              * Moves the TRACK 14 into D0
    TRAP        #15                 * Displays New line
    RTS                             * Return from subroutine

*---------- END - NEW_LINE ---------------------------------------------------


*---------- PRINT_HEXVALUE ---------------------------------------------------
* Prints out to display whatever is in A1
*-----------------------------------------------------------------------------
PRINT_HEXVALUE
    LEA         ASCIIVAL,A1         * Load message in A1 for display
    MOVE.B      #14,D0              * Moves the Task 13 into D0
    TRAP        #15                 * Displays contents of A1
    
    MOVE.L      #$ABCD1234,D1       * This is the key, move value to D1
    MOVE.B      #16,D2              * Move base 16 to D2
    MOVE.B      #15,D0              * Moves Task 15 into D0
    TRAP        #15                 * Displays contents of D1
    
    RTS                             * Return from subroutine                                  

*---------- END - PRINT_HEXVALUE ---------------------------------------------


******************************************************************************
*           VARIABLES AND CONSTANTS                                          *
******************************************************************************

INTRO           DC.B  'WELCOME!',CR,LF,'This program will convert Hex to Ascii.',CR,LF,0
HEXVAL          DC.B  'The HEX value is  : ',0
ASCIIVAL        DC.B  'The ASCII value is: ',0
ENDL            DC.B  CR,LF,0

HEXSTRING       DS.B  80            * Var for hex string

                END   START         * Last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
