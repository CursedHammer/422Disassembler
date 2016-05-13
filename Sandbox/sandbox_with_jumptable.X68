*-----------------------------------------------------------
* Title      : NOP check
* Written by : Jack Eldridge
* Date       : 5-4-2016
* Description: getting a feel for opcode checking
*-----------------------------------------------------------
STACK       EQU $7000
    ORG    $1000



START:                  ; first instruction of program
* Jump table code

*stack   EQU     $A000
*example EQU     %0001101000000100 ; MOVE.B D4, D1 = 0001 1010 0000 0100 
*example EQU     %0100111001110001   ; NOP  = 0100 1110 0111 0001
*example EQU     %0010101001000100    ; MOVEA.L   D4, A5 = 0010 1010 0100 0100
*example EQU     %0010101000000100    ; MOVE.L   D4, D5 = 0010 1010 0000 0100
*example EQU     %0011101000000100    ; MOVE.W   D4, D5 = 0011 1010 0000 0100
*example EQU     %0011101001000100    ; MOVEA.W   D4, D5 = 0011 1010 0100 0100
*example EQU     %0000011000000101       ; 0000 0110 0000 0101 = ADDI.B D5, D7
*example EQU     %0000011001000101       ; 0000 0110 0100 0101 = ADDI.W D5, D7
*example EQU     %0000011010000101       ; 0000 0110 1000 0101 = ADDI.L D5, D7
*example EQU     %0100100111010101      ; 0100 1001 1101 0101 = LEA D5, (A5)
*example EQU     %0100111001110101  ; RTS  = 0100 1110 0111 0101
*example EQU     %0100001010000111  ; CLR.L  = 0100 0010 1000 0111
*example EQU     %0100001000000111  ; CLR.B  = 0100 0010 0000 0111
*example EQU     %0100001001000111  ; CLR.W  = 0100 0010 0100 0111
example EQU     %0111111011111111   ;   MOVEQ.L #%11111111, D7 = 0111 1110 1111 1111
*example EQU     %0100111010010110  ; JSR (A6)  = 0100 1110 1001 0110

shift   EQU     12                  ; Shift 12 bits 

* Program starts here

        LEA     STACK,SP            ; Load the SP
        LEA     table,A0            ; Index into the table
        CLR.L   D0                  ; Zero it
        MOVE.W  #example,D0         ; We'll play with it here
        MOVE.B  #shift,D1           ; Shift 12 bits to the right  
        LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement                

table   JMP     code0000        ; ADDI.B, ADDI.W, or ADDI.L
        JMP     code0001        ; MOVE.B
        JMP     code0010        ; MOVEA.L or MOVE.L
        JMP     code0011        ; MOVEA.W or MOVE.W
        JMP     code0100        ; NOP or MOVEM.W or MOVEM.L or LEA or CLR.B or CLR.W or CLR.L or JSR or RTS
        JMP     code0101
        JMP     code0110
        JMP     code0111        ; MOVEQ.L
        JMP     code1000
        JMP     code1001
        JMP     code1010
        JMP     code1011
        JMP     code1100
        JMP     code1101
        JMP     code1110
        JMP     code1111
       
*The following subroutines will get filled in as you decode the instructions . For *now, just exit gracefully.

code0000 JSR   ADDI_BorADDI_WorADDI_L
code0001 JSR   ISMOVEB
         JSR   DONE
code0010 JSR   MOVEA_LorMOVE_L        ; MOVEA.L or MOVE.L
code0011 JSR  MOVEA_WorMOVE_W        ; MOVEA.W or MOVE.W
code0100 JSR    NOP_MOVEM_LEA_JSR_CLR_RTS
         JSR    DONE
code0101 STOP  #$2700
code0110 STOP  #$2700
code0111 JSR    ISMOVEQL
code1000 STOP  #$2700
code1001 STOP  #$2700
code1010 STOP  #$2700
code1011 STOP  #$2700
code1100 STOP  #$2700
code1101 STOP  #$2700
code1110 STOP  #$2700
code1111 STOP  #$2700

*****************************someCLR ************************************
someCLR     LEA     STACK,SP            ; Load the SP
                    LEA     tableSomeCLR, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #8,D1           ; Shift 9 bits left 
                    ASL.W   D1,D0            
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right  
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)           
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0 
                    
                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JSR     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement                

tableSomeCLR        JMP     CLRcode00   *CLR.B
                    JMP     CLRcode01   *CLR.W                                      
                    JMP     CLRcode10   *CLR.L

CLRcode00   JSR     ISCLRB
            JSR     DONE
CLRcode01   JSR     ISCLRW  
            JSR     DONE                                 
CLRcode10   JSR     ISCLRL  
            JSR     DONE                    

*****************************END someCLR ************************************

*****************************NOPorCLRorRTSorJSR ************************************
NOPorCLRorRTSorJSR     LEA     STACK,SP            ; Load the SP
                    LEA     tableNOPorCLRorRTSorJSR, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    
                    MOVE.W  #%0100111001110001,D1  ; 0100111001110001 = NOP
                    CMP.W   D0, D1
                    BEQ     NOPcommand
 
                    MOVE.W  #%0100111001110101,D1  ; 0100111001110101 = RTS
                    CMP.W   D0, D1
                    BEQ     RTScommand
  
                    MOVE.B  #4,D1           ; Shift 4 bits left 
                    ASL.W   D1,D0            
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right  
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)           
  
                    
                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JSR     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement                

tableNOPorCLRorRTSorJSR    JMP     JSRorCLRcode0000
                           JMP     JSRorCLRcode0001
                           JMP     JSRorCLRcode0010   
                           JMP     JSRorCLRcode0011
                           JMP     JSRorCLRcode0100
                           JMP     JSRorCLRcode0101
                           JMP     JSRorCLRcode0110
                           JMP     JSRorCLRcode0111
                           JMP     JSRorCLRcode1000
                           JMP     JSRorCLRcode1001
                           JMP     JSRorCLRcode1010
                           JMP     JSRorCLRcode1011
                           JMP     JSRorCLRcode1100
                           JMP     JSRorCLRcode1101
                           JMP     JSRorCLRcode1110
                           JMP     JSRorCLRcode1111

RTScommand          JSR     ISRTS
                    JSR     DONE
NOPcommand          JSR     ISNOP 
                    JSR     DONE                                                                  
JSRorCLRcode0000     STOP  #$2700
JSRorCLRcode0001     STOP  #$2700
JSRorCLRcode0010    JSR      someCLR
                    JSR     DONE
JSRorCLRcode0011     STOP  #$2700
JSRorCLRcode0100     STOP  #$2700
JSRorCLRcode0101     STOP  #$2700
JSRorCLRcode0110     STOP  #$2700
JSRorCLRcode0111     STOP  #$2700
JSRorCLRcode1000     STOP  #$2700
JSRorCLRcode1001     STOP  #$2700
JSRorCLRcode1010     STOP  #$2700
JSRorCLRcode1011     STOP  #$2700
JSRorCLRcode1100     STOP  #$2700
JSRorCLRcode1101     STOP  #$2700
JSRorCLRcode1110    JSR     ISJSR
                    JSR     DONE
JSRorCLRcode1111     STOP  #$2700

*****************************END NOPorCLRorRTSorJSR ************************************


*****************************someMOVEM ************************************
someMOVEM     LEA     STACK,SP            ; Load the SP
                    LEA     tableSomeMOVEM, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #9,D1           ; Shift 9 bits left 
                    ASL.W   D1,D0            
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right  
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)           
  
                    
                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JSR     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement                

tableSomeMOVEM    JMP     MOVEMcode00   ;MOVEM.W
                  JMP     MOVEMcode01   ;MOVEM.L                                      
                      

                          
MOVEMcode00         JSR     ISMOVEMW
                    JSR     DONE
MOVEMcode01         JSR     ISMOVEML
                    JSR     DONE

*****************************END someMOVEM ************************************

*****************************NOP_MOVEM_LEA_JSR_CLR_RTS ************************************
NOP_MOVEM_LEA_JSR_CLR_RTS     LEA     STACK,SP            ; Load the SP
                    LEA     tableNOP_MOVEM_LEA_JSR_CLR_RTS, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits right 
                    ASR.W   D1,D0 

                    MOVE.B  #13,D1           ; Shift 6 bits left 
                    ASL.W   D1,D0            
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right  
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)         
  
                    
                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JSR     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement                

tableNOP_MOVEM_LEA_JSR_CLR_RTS    JMP     LOTScode0000
                                  JMP     LOTScode0001
                                  JMP     LOTScode0010
                                  JMP     LOTScode0011
                                  JMP     LOTScode0100
                                  JMP     LOTScode0101
                                  JMP     LOTScode0110
                                  JMP     LOTScode0111
                                  JMP     LOTScode1000
                                  JMP     LOTScode1001
                                  JMP     LOTScode1010
                                  JMP     LOTScode1011
                                  JMP     LOTScode1100
                                  JMP     LOTScode1101                               JMP     LOTScode1110
                                  JMP     LOTScode1111                           
                      

                          
LOTScode0000       STOP  #$2700
LOTScode0001       STOP  #$2700
LOTScode0010        JSR    someMOVEM
                   JSR    DONE
LOTScode0011       STOP  #$2700                   
LOTScode0100        STOP  #$2700
LOTScode0101        STOP  #$2700
LOTScode0110        JSR    ISLEA  
                   JSR    DONE 
LOTScode0111        STOP  #$2700 
LOTScode1000        JSR    NOPorCLRorRTSorJSR
                   JSR    DONE
LOTScode1001        STOP  #$2700               
LOTScode1010        JSR    NOPorCLRorRTSorJSR
                   JSR    DONE
LOTScode1011        STOP  #$2700                   
LOTScode1100        STOP  #$2700
LOTScode1101     STOP  #$2700
LOTScode1110        JSR    ISLEA 
                   JSR    DONE
LOTScode1111       STOP  #$2700                
                   
*****************************END NOP_MOVEM_LEA_JSR_CLR_RTS ************************************


*****************************ADDI_BorADDI_WorADDI_L ************************************
ADDI_BorADDI_WorADDI_L     LEA     STACK,SP            ; Load the SP
                    LEA     tableADDI_BorADDI_WorADDI_L,A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits left 
                    ASL.W   D1,D0            
                    MOVE.B  #13,D1           
                    ASR.W   D1,D0             
  
                    
                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JSR     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement                

tableADDI_BorADDI_WorADDI_L    JMP     ADDIBcode00
                               JMP     ADDIWcode01
                               JMP     ADDILcode10

                          
ADDIBcode00        JSR     ISADDIB
                    JSR    DONE
ADDIWcode01        JSR     ISADDIW
                    JSR    DONE
ADDILcode10        JSR     ISADDIL
                    JSR    DONE

*****************************END ADDI_BorADDI_WorADDI_L ************************************




*****************************MOVEA_LorMOVE_L ************************************
MOVEA_LorMOVE_L     LEA     STACK,SP            ; Load the SP
                    LEA     tableMOVEA_LorMOVE_L,A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits left 
                    ASL.W   D1,D0            ; 0011 1010 0100 0100 to 0010 0000 0000 0000
                    MOVE.B  #13,D1           ; Shift 13 bits right
                    ASR.W   D1,D0             ; 0010 0000 0000 0000 to 0000 0000 0000 0001
  
                    
                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JSR     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement                

tableMOVEA_LorMOVE_L    JMP     MOVEcode000
                        JMP     MOVEAcode001
                        JMP     MOVEcode010
                        JMP     MOVEcode011
                        JMP     MOVEcode100
                        JMP     MOVEcode101
                        JMP     MOVEcode110
                        JMP     MOVEcode111
                          
MOVEcode000     JSR     ISMOVEL
                JSR    DONE
MOVEAcode001    JSR     ISMOVEAL
                JSR    DONE
MOVEcode010     JSR     ISMOVEL
                JSR    DONE
MOVEcode011     JSR     ISMOVEL
                JSR    DONE
MOVEcode100     JSR     ISMOVEL
                JSR    DONE
MOVEcode101     JSR     ISMOVEL
                JSR    DONE
MOVEcode110     JSR     ISMOVEL
                JSR    DONE
MOVEcode111     JSR     ISMOVEL 
                JSR    DONE
*****************************END MOVEA_LorMOVE_L ************************************

*****************************MOVEA_WorMOVE_W ************************************
MOVEA_WorMOVE_W     LEA     STACK,SP            ; Load the SP
                    LEA     tableMOVEA_WorMOVE_W,A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits left 
                    ASL.W   D1,D0            ; 0011 1010 0100 0100 to 0010 0000 0000 0000
                    MOVE.B  #13,D1           ; Shift 13 bits right
                    ASR.W   D1,D0             ; 0010 0000 0000 0000 to 0000 0000 0000 0001
  
                    
                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JSR     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement                

tableMOVEA_WorMOVE_W    JMP     MOVEWcode000
                        JMP     MOVEAWcode001
                        JMP     MOVEWcode010
                        JMP     MOVEWcode011
                        JMP     MOVEWcode100
                        JMP     MOVEWcode101
                        JMP     MOVEWcode110
                        JMP     MOVEWcode111
                          
MOVEWcode000     JSR     ISMOVEW
                JSR    DONE
MOVEAWcode001    JSR     ISMOVEAW
                JSR    DONE
MOVEWcode010     JSR     ISMOVEW
                JSR    DONE
MOVEWcode011     JSR     ISMOVEW
                JSR    DONE
MOVEWcode100     JSR     ISMOVEW
                JSR    DONE
MOVEWcode101     JSR     ISMOVEW
                JSR    DONE
MOVEWcode110     JSR     ISMOVEW
                JSR    DONE
MOVEWcode111     JSR     ISMOVEW 
                JSR    DONE
*****************************END MOVEA_WorMOVE_W ************************************

ISMOVEQL    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMOVEQL, A1         *OPCODE is CLR.B
            MOVE.B  #14, D0
            TRAP    #15
   
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISCLRB    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGECLRB, A1         *OPCODE is CLR.B
            MOVE.B  #14, D0
            TRAP    #15
   
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISCLRW    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGECLRW, A1         *OPCODE is CLR.B
            MOVE.B  #14, D0
            TRAP    #15
   
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISCLRL    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGECLRL, A1         *OPCODE is CLR.B
            MOVE.B  #14, D0
            TRAP    #15
   
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS
            
ISMOVEML    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMOVEML, A1         *OPCODE is MOVE.L so display MOVE.L message
            MOVE.B  #14, D0
            TRAP    #15
   
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISMOVEMW    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMOVEMW, A1         *OPCODE is MOVE.W so display MOVE.W message
            MOVE.B  #14, D0
            TRAP    #15
   
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS  

ISLEA    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGELEA, A1         *OPCODE is LEA so display LEA message
            MOVE.B  #14, D0
            TRAP    #15
   
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine

ISJSR       MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEJSR, A1         *OPCODE is NOP so display NOP message
            MOVE.B  #14, D0
            TRAP    #15
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
            
ISRTS       MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGERTS, A1         *OPCODE is RTS
            MOVE.B  #14, D0
            TRAP    #15
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS  

ISCLR       MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGECLR, A1         *OPCODE is CLR
            MOVE.B  #14, D0
            TRAP    #15
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS  
            
ISNOP       MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGENOP, A1         *OPCODE is NOP so display NOP message
            MOVE.B  #14, D0
            TRAP    #15
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
         
ISMOVEW     MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMOVEW, A1         *OPCODE is MOVE.W so display MOVEW message
            MOVE.B  #14, D0
            TRAP    #15
   
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
            
ISMOVEAW    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMOVEAW, A1         *OPCODE is MOVEA.W so display MOVEA.W message
            MOVE.B  #14, D0
            TRAP    #15
   
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
            
ISMOVEL     MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMOVEL, A1         *OPCODE is MOVE.L so display MOVE.L message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
            
ISMOVEAL    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMOVEAL, A1         *OPCODE is MOVEA.L so display MOVEA.L message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
       
ISMOVEB     MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMOVEB, A1         *OPCODE is MOVE.B so display MOVEB message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
         
ISADDIW     MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEADDIW, A1         *OPCODE is ADDI.W so display ADDI.W message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
            
ISADDIL     MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEADDIL, A1         *OPCODE is ADDI.L so display ADDI.L message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
                
ISADDIB     MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEADDIB, A1         *OPCODE is ADDI.B so display ADDI.B message
            MOVE.B  #14, D0
            TRAP    #15
            
            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS                          ; Exit subroutine
                      
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

MESSAGEMOVEAL DC.B    'MOVEA.L',CR,LF, 0 
MESSAGEMOVEAW DC.B    'MOVEA.W',CR,LF, 0 

MESSAGEMOVEML DC.B    'MOVEM.L',CR,LF, 0 
MESSAGEMOVEMW DC.B    'MOVEM.W',CR,LF, 0 

MESSAGEJSR DC.B    'JSR',CR,LF, 0 

MESSAGECLR DC.B    'CLR',CR,LF, 0

MESSAGERTS DC.B    'RTS',CR,LF, 0

MESSAGELEA DC.B    'LEA',CR,LF, 0

MESSAGECLRB DC.B    'CLR.B',CR,LF, 0 
MESSAGECLRW DC.B    'CLR.W',CR,LF, 0
MESSAGECLRL DC.B    'CLR.L',CR,LF, 0

MESSAGEMOVEQL DC.B    'MOVEQ.L',CR,LF, 0

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
