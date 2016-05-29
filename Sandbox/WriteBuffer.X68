*-----------------------------------------------------------
* Title      : Store String in Memory
* Written by : Brandon Authier
* Date       : 28 May 2016
* Description: Writes strings to memory buffer and then can
*              be printed to user.
*
*              A4 is used as the temporary holder for the
*              string to be written to the buffer.
*
*              A2 is used to track the BUFFER.
*
*              The BUFFER is addressed at $2000 (Will change)
*
*              D3 is used to the Row Count, RCOUNT.
* 
*-----------------------------------------------------------

CR      EQU     $0D                 * Carriage return
LF      EQU     $0A                 * Line feed

BUFFER  EQU     $2000               * Buffer address for string
RCOUNT  EQU     30                  * Counters
   
        ORG     $1000               * Program beginning address
        
START
    MOVE.B      #RCOUNT,D3          * Move row counter to D3
        
WRITE_LINE
    LEA         BUFFER,A2           * Load BUFFER address to A2 for use

*   Write Strings to Memory Creating a Line
*   =======================================    
    MOVE.L      #MV,A4              * Move the string 'MOVE' to A4
    BSR.S       WRITE2MEM           * Write string to memory
    MOVE.L      #LONG,A4            * Move the string '.L  ' to A4
    BSR.S       WRITE2MEM           * Write string to memory
    MOVE.L      #DREG1,A4           * Move the string 'D1' to A4
    BSR.S       WRITE2MEM           * Write string to memory
    MOVE.L      #COMMA,A4           * Move the string ',' to A4
    BSR.S       WRITE2MEM           * Write string to memory
    MOVE.L      #DREG4,A4           * Move the string 'D4' to A4
    BSR.S       WRITE2MEM           * Write string to memory
    BSR.S       WRITE_ENDL          * Write end of line to memory          
*   ----------- Finished Writing the Whole Line -------------------

*   Print Buffer
*   ============ 
    BSR.S       PRINTLN             * Subroutine to print buffer
*   ----------- Print Buffer -----------------------------------

*   Clean Buffer
*   ============ 
    LEA         BUFFER,A2           * Reset A2 for buffer cleaning
    BSR.S       CLEAN_BUFF          * Subroutine to reset buffer to all F's
*   ----------- Buffer Cleaned --------------------------------------------

*   Is New Page Needed?
*   This is a for loop type wrapper that executes 30 times then asks the 
*   user to press enter to continue which clears the screen. 
*   It loops infinitely in this way.
*   ====================================================================
    SUBI.B      #1,D3               * Decrement RCOUNT by 1
    CMPI.B      #0,D3               * Is RCOUNT = 0
    BEQ         NEW_PAGE            * If yes, prompt user and make new page
    BSR.S       WRITE_LINE          * If no, keep writing lines

*   Pause Program
*   =============    
    BRA         PAUSE               * Pause program (SIMHALT)

*   Subroutines
*   ===========    
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
    LEA         BUFFER,A2           * Reset A2 to BUFFER address beginning
    LEA         (A2),A1             * Load BUFFER address into A1
    MOVE.B      #14,D0              * Task 14, no CR or LF
    TRAP        #15                 * Display string held in BUFFER
    RTS                             * Return to main
    
CLEAN_BUFF
    CMPI.L      #$FFFFFFFF,(A2)     * 
    BEQ         BUFFDONE            * Buffer has been cleaned
    MOVE.L      #$FFFFFFFF,(A2)+    * Fill with F's
    BRA         CLEAN_BUFF          * Continue cleaning buffer
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

CLEARSCRN     
    MOVE.B      #11,D0              * Task 11 for clearing screen
    MOVE.W      #$FF00,D1           * FF00, Clear screen
    TRAP        #15                 * Clears output
    BRA.W       START               * Loop back to start
    
PAUSE
        SIMHALT                     * Halt simulator
        BRA     QUIT                * End program

* Put variables and constants here

* Display
ENTER           DC.B '------------------------- Press Enter ------------------------',0


* Op Commands
MV              DC.B 'MOVE',0
AD              DC.B 'ADD ',0

* Lengths
BYTE            DC.B '.B  ',0
WORD            DC.B '.W  ',0
LONG            DC.B '.L  ',0
ENDL            DC.B CR,LF,0

* Registers
DREG0           DC.B 'D0',0
DREG1           DC.B 'D1',0
DREG2           DC.B 'D2',0
DREG3           DC.B 'D3',0
DREG4           DC.B 'D4',0
DREG5           DC.B 'D5',0
DREG6           DC.B 'D6',0
DREG7           DC.B 'D7',0
AREG0           DC.B 'A0',0
AREG1           DC.B 'A1',0
AREG2           DC.B 'A2',0
AREG3           DC.B 'A3',0
AREG4           DC.B 'A4',0
AREG5           DC.B 'A5',0
AREG6           DC.B 'A6',0
AREG7           DC.B 'A7',0

* Signs
POUND           DC.B '#',0
DOLLAR          DC.B '$',0
PERCENT         DC.B '%',0
COMMA           DC.B ',',0
OPAREN          DC.B '(',0
CPAREN          DC.B ')',0
PLUS            DC.B '+',0
MINUS           DC.B '-',0

* Spacing
TAB             DC.B '    ',0

QUIT
        END     START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~