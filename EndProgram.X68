******************************************************************************
* Title      : I/O End Program
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 1 Jun 2016
* Description: This function asks the user if they would like to rerun the 
*              program or end it.
******************************************************************************


******************************************************************************
*           DEFINITIONS                                                      *
******************************************************************************

UPYES     EQU   'Y'
LOWYES    EQU   'y'

          ORG   $1000

******************************************************************************
*           BEGIN CODE                                                       *
******************************************************************************

*---------- START ------------------------------------------------------------
* Begins program's logical flow. Similar to main in C/C++
*-----------------------------------------------------------------------------           
KEEP_RUNNING
    BSR.W       RERUN               * Run welcome subroutine
    CMPI.B      #1,D5               * Is true?
    BEQ         KEEP_RUNNING        * If yes, keep running program
    BRA         FINISHED            * Else, finished    
      
FINISHED
    SIMHALT                         * halt simulator
    RTS                             * Return to Disassembler
    
*---------- END - START ------------------------------------------------------


******************************************************************************
*           SUB ROUTINES                                                     *
******************************************************************************
           
*---------- RERUN ------------------------------------------------------------
* Prints a welcome message
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
    MOVE.B      #0,D5               * 0 for false to end program
    RTS 
    
NOTDONE
    MOVE.B      #1,D5               * 1 for true to rerun program
    BRA.W       CLEARSCRN           * Clear screen and return from subroutine         
        
*---------- END - RERUN ------------------------------------------------------
* Put program code here

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
*           VARIABLES AND CONSTANTS                                          *
******************************************************************************

ENDQUESTION     DC.B 'WOULD YOU LIKE TO RUN THE PROGRAM AGAIN (Y/N)? ',0

    END         KEEP_RUNNING

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
