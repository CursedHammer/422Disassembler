*-----------------------------------------------------------
* Title      : NOP check
* Written by : Jack Eldridge
* Date       : 5-4-2016
* Description: getting a feel for opcode checking
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here
    
    MOVE.W      #$4E71, $2000  *4E71 = 0100 1110 0111 0001 = NOP
    
    MOVE.W      $2000, A7  

GETOPCODE
    BRA         NOPCHECK        *Check if opcode is just a NOP
 
 
NOPCHECK    MOVE.W  #$4E71, D3
            CMP.W   A7, D3
            BNE     DONE
            LEA MESSAGE, A1
            MOVE.B  #14, D0
            TRAP    #15

DONE        MOVE.B      #9, D0
            TRAP        #15

CR  EQU     $0D 
LF  EQU     $0A
MESSAGE DC.B    'NOP',CR,LF, 0                 

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
