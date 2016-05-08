*-----------------------------------------------------------
* Title      : NOP check
* Written by : Jack Eldridge
* Date       : 5-4-2016
* Description: getting a feel for opcode checking
*-----------------------------------------------------------
STACK       EQU $7000
    ORG    $1000

START:                  ; first instruction of program

* Put program code here
    LEA     STACK, SP
   
    MOVE.W      #$4E71, $2000  *4E71 = 0100 1110 0111 0001 = NOP
    MOVE.W      #$3A04, $2010   *3A47 = 0011 1010 0000 0100 = MOVE.W D4, D1
    MOVE.W      #$2A04, $2020   *2A47 = 0010 1010 0000 0100 = MOVE.L D4, D1
    MOVE.W      #$1A04, $2030   *1A47 = 0010 1010 0000 0100 = MOVE.B D4, D1
    MOVE.W      #$0605, $2040   *0605 = 0000 0110 0000 0101 = ADDI.B D5, D7
    MOVE.W      #$0645, $2050   *0605 = 0000 0110 0000 0101 = ADDI.W D5, D7
    MOVE.W      #$0685, $2060   *0605 = 0000 0110 0000 0101 = ADDI.L D5, D7
    
    MOVE.W      #$FFFF, $2070   *test, should have no result
    MOVE.W      #$0000, $2080   *test, should have no result     
   
   *NOP
    MOVE.W      $2000, A6  
    JSR         GETOPCODE
 
  *MOVE 
    MOVE.W      $2010, A6 
    JSR         GETOPCODE 
    MOVE.W      $2020, A6 
    JSR         GETOPCODE 
    MOVE.W      $2030, A6 
    JSR         GETOPCODE 

   *ADDI
    MOVE.W      $2040, A6 
    JSR         GETOPCODE 
    MOVE.W      $2050, A6 
    JSR         GETOPCODE 
    MOVE.W      $2060, A6 
    JSR         GETOPCODE 
    
   *TEST
    MOVE.W      $2070, A6 
    JSR         GETOPCODE 
    MOVE.W      $2080, A6 
    JSR         GETOPCODE     
 
    JSR         DONE

GETOPCODE   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            JSR         NOPCHECK        *Check if opcode is just a NOP
            JSR         MOVECHECK       *Check if opcode is MOVE
            JSR         ADDICHECK       *Check if opcode is ADDI
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine

********************************NOP****************************** 
NOPCHECK    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            MOVE.W  #$4E71, D3
            CMP.W   A6, D3
            BEQ     ISNOP   *OPCODE is NOP
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine

ISNOP       LEA MESSAGENOP, A1         *OPCODE is MOVE.W so display NOP message
            MOVE.B  #14, D0
            TRAP    #15
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine

***************END NOP**************************************************
                        
***************************************MOVE**************************************            
MOVECHECK   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            JSR     TESTMOVEW
            JSR     TESTMOVEL
            JSR     TESTMOVEB

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine

TESTMOVEW   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            MOVE.W  #$0, D6
            MOVE.W  A6, D4      *copy of A6 to D4
            MOVE.W  #$3000, D3
            SUB.W   D3, D4      subtract 3000(D3) from copy of what was in A6 (D4)
            CMP.W   D6, D4      *BHS taken if D4 is greater than or = to 0 (D6)
            BHS     MAYBEMOVEW
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine

MAYBEMOVEW   MOVE.W #$4000, D3
             MOVE.W  #$F000, D6
             MOVE.W A6, D4          *copy of A6 to D4
             SUB.W   D3, D4      subtract D4 from 4000(D3)
             CMP.W   D6, D4      *BHS taken if D3 is greater than or = to 0(D6)

             BHS     ISMOVEW         *OPCODE is MOVE.W 0011  so 3xxx
             MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
             RTS                          ; Exit subroutine
         
ISMOVEW     LEA MESSAGEMOVEW, A1         *OPCODE is MOVE.W so display NOP message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine

TESTMOVEL   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            MOVE.W  #$0, D6
            MOVE.W  A6, D4      *copy of A6 to D4
            MOVE.W  #$2000, D3
            SUB.W   D3, D4      subtract 3000 from copy of what was in A6
            CMP.W   D6, D4      *compare subtraction result to 0
            BHS     MAYBEMOVEL
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine           

MAYBEMOVEL   MOVE.W #$3000, D3
             MOVE.W  #$F000, D6
             MOVE.W A6, D4          *copy of A6 to D4
             SUB.W   D3, D4      subtract 3000 from copy of what was in A6
             CMP.W   D6, D4      *compare subtraction result to 0
             BHS     ISMOVEL        *OPCODE is MOVE.L 0010 so 2xxx
             MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
             RTS                          ; Exit subroutine
            
ISMOVEL     LEA MESSAGEMOVEL, A1         *OPCODE is MOVE.L so display NOP message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
                     
TESTMOVEB   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            MOVE.W  #$0, D6
            MOVE.W  A6, D4      *copy of A6 to D4
            MOVE.W  #$1000, D3
            SUB.W   D3, D4      subtract 3000 from copy of what was in A6
            CMP.W   D6, D4      *compare subtraction result to 0
            BHS     MAYBEMOVEB
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
            
MAYBEMOVEB   MOVE.W     #$2000, D3
             MOVE.W     #$F000, D6
             MOVE.W     A6, D4          *copy of A6 to D4
             SUB.W      D3, D4      subtract 3000 from copy of what was in A6
             CMP.W      D6, D4      *compare subtraction result to 0
             BHS        ISMOVEB        *OPCODE is MOVE.B 0001 so 1xxx
             MOVEM.W    (SP)+,  A0-A7/D0-D7         ; Restore registers
             RTS                          ; Exit subroutine
             
ISMOVEB     LEA MESSAGEMOVEB, A1         *OPCODE is MOVE.L so display NOP message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
***********************END MOVE ****************************************

************************ADDI*********************************

ADDICHECK   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            JSR     TESTADDIW
            JSR     TESTADDIL
            JSR     TESTADDIB

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine

TESTADDIW   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            MOVE.W  #$F000, D6 * was #$0
            MOVE.W  A6, D4      *copy of A6 to D4
            MOVE.W  #$0640, D3
            SUB.W   D3, D4      subtract 3000(D3) from copy of what was in A6 (D4)
            CMP.W   D6, D4      *BHS taken if D4 is greater than or = to 0 (D6)
            BLO     MAYBEADDIW
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine

MAYBEADDIW   MOVE.W #$064F, D3
             MOVE.W  #$F000, D6
             MOVE.W A6, D4          *copy of A6 to D4
             SUB.W   D3, D4      subtract D4 from 4000(D3)
             CMP.W   D6, D4      *BHS taken if D3 is greater than or = to 0(D6)

             BHS     ISADDIW         *OPCODE is MOVE.W 0011  so 3xxx
             MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
             RTS                          ; Exit subroutine
         
ISADDIW     LEA MESSAGEADDIW, A1         *OPCODE is MOVE.W so display NOP message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine

TESTADDIL   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            MOVE.W  #$F000, D6
            MOVE.W  A6, D4      *copy of A6 to D4
            MOVE.W  #$0680, D3
            SUB.W   D3, D4      subtract 3000 from copy of what was in A6
            CMP.W   D6, D4      *compare subtraction result to 0
            BLO     MAYBEADDIL
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine           

MAYBEADDIL   MOVE.W #$068F, D3
             MOVE.W  #$F000, D6
             MOVE.W A6, D4          *copy of A6 to D4
             SUB.W   D3, D4      subtract 3000 from copy of what was in A6
             CMP.W   D6, D4      *compare subtraction result to 0
             BHS     ISADDIL        *OPCODE is MOVE.L 0010 so 2xxx
             MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
             RTS                          ; Exit subroutine
            
ISADDIL     LEA MESSAGEADDIL, A1         *OPCODE is MOVE.L so display NOP message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
                     
TESTADDIB   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            MOVE.W  #$F000, D6
            MOVE.W  A6, D4      *copy of A6 to D4
            MOVE.W  #$0600, D3
            SUB.W   D3, D4      subtract 3000 from copy of what was in A6
            CMP.W   D6, D4      *compare subtraction result to 0
            BLO     MAYBEADDIB
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
            
MAYBEADDIB   MOVE.W     #$063F, D3
             MOVE.W     #$F000, D6
             MOVE.W     A6, D4          *copy of A6 to D4
             SUB.W      D3, D4      subtract 3000 from copy of what was in A6
             CMP.W      D6, D4      *compare subtraction result to 0
             BHS        ISADDIB        *OPCODE is MOVE.B 0001 so 1xxx
             MOVEM.W    (SP)+,  A0-A7/D0-D7         ; Restore registers
             RTS                          ; Exit subroutine
             
ISADDIB     LEA MESSAGEADDIB, A1         *OPCODE is MOVE.L so display NOP message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine

**********************END ADDI***************************************                               

DONE        MOVE.B      #9, D0
            TRAP        #15

CR  EQU     $0D 
LF  EQU     $0A
MESSAGENOP DC.B    'NOP',CR,LF, 0    
    
MESSAGEMOVEW DC.B    'MOVE.W',CR,LF, 0    
MESSAGEMOVEL DC.B    'MOVE.L',CR,LF, 0 
MESSAGEMOVEB DC.B    'MOVE.B',CR,LF, 0       

MESSAGEADDIW DC.B    'ADDI.W',CR,LF, 0    
MESSAGEADDIL DC.B    'ADDI.L',CR,LF, 0 
MESSAGEADDIB DC.B    'ADDI.B',CR,LF, 0 

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
