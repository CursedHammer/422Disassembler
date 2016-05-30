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
*example EQU     %0100111001110001 ; NOP  = 0100 1110 0111 0001
*example EQU     %0010101001000100 ; MOVEA.L   D4, A5 = 0010 1010 0100 0100
*example EQU     %0010101000000100 ; MOVE.L   D4, D5 = 0010 1010 0000 0100
*example EQU     %0011101000000100 ; MOVE.W   D4, D5 = 0011 1010 0000 0100
*example EQU     %0011101001000100 ; MOVEA.W   D4, D5 = 0011 1010 0100 0100
*example EQU     %0000011000000101 ; ADDI.B D5, D7 = 0000 0110 0000 0101
*example EQU     %0000011001000101 ; ADDI.W D5, D7 = 0000 0110 0100 0101
*example EQU     %0000011010000101 ; ADDI.L D5, D7 = 0000 0110 1000 0101
*example EQU     %0100100111010101 ; LEA D5, (A5) = 0100 1001 1101 0101
*example EQU     %0100111001110101 ; RTS  = 0100 1110 0111 0101
*example EQU     %0100001010000111 ; CLR.L  = 0100 0010 1000 0111
*example EQU     %0100001000000111 ; CLR.B  = 0100 0010 0000 0111
*example EQU     %0100001001000111 ; CLR.W  = 0100 0010 0100 0111

example EQU     %0100001011000111 ; INVALID = 0100 0010 1100 0111

*example EQU     %0111111011111111 ; MOVEQ.L #%11111111, D7 = 0111 1110 1111 1111
*example EQU     %0100111010010110 ; JSR (A6)  = 0100 1110 1001 0110
*example EQU     %0101111000000011 ; ADDQ.B    #%111, D3 = 0101 1110 0000 0011
*example EQU     %0101111001000011 ; ADDQ.W    #%111, D3 = 0101 1110 0100 0011
*example EQU     %0101111010000011 ; ADDQ.L    #%111, D3 = 0101 1110 1000 0011
*example EQU     %1011100000000011 ; CMP.B D3, D4 = 1011 100 000 000 011
*example EQU     %1011100001000011 ; CMP.W D3, D4 = 1011 100 001 000 011
*example EQU     %1011100010000011 ; CMP.L D3, D4 = 1011 100 010 000 011

*example EQU     %1011100011000011 ;         INVALID 1011 100 011 000 011

*example EQU     %1001100100000011 ; SUB.B D3, D4 = 1001 100 100 000 011
*example EQU     %1001011000000100 ; SUB.B D4, D3 = 1001 011 000 000 100

*example EQU     %1001100101000011 ; SUB.W D3, D4 = 1001 100 101 000 011
*example EQU     %1001011001000100 ; SUB.W D4, D3 = 1001 011 001 000 100

*example EQU     %1001100110000011 ; SUB.L D3, D4 = 1001 100 110 000 011
*example EQU     %1001011010000100 ; SUB.L D4, D3 = 1001 011 010 000 100

*example EQU     %1101100100000011 ; ADD.B D3, D4 = 1101 100 100 000 011
*example EQU     %1101011000000100 ; ADD.B D4, D3 = 1101 011 000 000 100

*example EQU     %1101100101000011 ; ADD.W D3, D4 = 1101 100 101 000 011
*example EQU     %1101011001000100 ; ADD.W D4, D3 = 1101 011 001 000 100

*example EQU     %1101100110000011 ; ADD.L D3, D4 = 1101 100 110 000 011
*example EQU     %1101011010000100 ; ADD.L D4, D3 = 1101 011 010 000 100

*example EQU     %1101100011000011 ; ADDA.W D3, A4 = 1101 100 011 000 011
*example EQU     %1101100111000011 ; ADDA.L D3, A4 = 1101 100 111 000 011

*example EQU     %1100100000000011 ; AND.B D3, D4 = 1100 100 000 000 011
*example EQU     %1100011100000100 ; AND.B D4, D3 = 1100 011 100 000 100

*example EQU     %1100100001000011 ; AND.W D3, D4 = 1100 100 001 000 011
*example EQU     %1100011101000100 ; AND.W D4, D3 = 1100 011 101 000 100

*example EQU     %1100100010000011 ; AND.L D3, D4 = 1100 100 010 000 011
*example EQU     %1100011110000100 ; AND.L D4, D3 = 1100 011 110 000 100

*example EQU     %1100100111000011 ; MULS.W D3, D4 = 1100 100 111 000 011

*example EQU     %0100110000000011 ; MULS.L D3, D4 = 01001 1 0000 000 011

*example EQU     %0100100010010100 ; MOVEM.W (A4), (D16A6) = 0100 1000 10 010 100
*example EQU     %0100110010101110 ; MOVEM.W (D16A6), (A4) = 0100 1100 10 101 110

*example EQU     %0100100011010100 ; MOVEM.L (A4), (D16A6) = 0100 1000 11 010 100
*example EQU     %0100110011101110 ; MOVEM.L (D16A6), (A4) = 0100 1100 11 101 110

*example EQU     %1110111100011010  ; ROL.B  D1,D2 = 1110 111 1 00 0 11 010 where D1 = 0x111 or 7
*example EQU     %1110111101011010  ; ROL.W  D1,D2 = 1110 111 1 01 0 11 010 where D1 = 0x111 or 7
*example EQU     %1110111110011010  ; ROL.L  D1,D2 = 1110 111 1 10 0 11 010 where D1 = 0x111 or 7

*example EQU     %1110111000011010  ; ROR.B  D1,D2 = 1110 111 0 00 0 11 010 where D1 = 0x111 or 7
*example EQU     %1110111001011010  ; ROR.W  D1,D2 = 1110 111 0 01 0 11 010 where D1 = 0x111 or 7
*example EQU     %1110111010011010  ; ROR.L  D1,D2 = 1110 111 0 10 0 11 010 where D1 = 0x111 or 7

*example EQU     %1110111100001010  ; LSL.B  D1,D2 = 1110 111 1 00 0 01 010 where D1 = 0x111 or 7
*example EQU     %1110111101001010  ; LSL.W  D1,D2 = 1110 111 1 01 0 01 010 where D1 = 0x111 or 7
*example EQU     %1110111110001010  ; LSL.L  D1,D2 = 1110 111 1 10 0 01 010 where D1 = 0x111 or 7

*example EQU     %1110111000001010  ; LSR.B  D1,D2 = 1110 111 0 00 0 01 010 where D1 = 0x111 or 7
*example EQU     %1110111001001010  ; LSR.W  D1,D2 = 1110 111 0 01 0 01 010 where D1 = 0x111 or 7
*example EQU     %1110111010001010  ; LSR.L  D1,D2 = 1110 111 0 10 0 01 010 where D1 = 0x111 or 7

*example EQU     %1110111100000010  ; ASL.B  D1,D2 = 1110 111 1 00 0 00 010 where D1 = 0x111 or 7
*example EQU     %1110111101000010  ; ASL.W  D1,D2 = 1110 111 1 01 0 00 010 where D1 = 0x111 or 7
*example EQU     %1110111110000010  ; ASL.L  D1,D2 = 1110 111 1 10 0 00 010 where D1 = 0x111 or 7

*example EQU     %1110111000000010  ; ASR.B  D1,D2 = 1110 111 0 00 0 00 010 where D1 = 0x111 or 7
*example EQU     %1110111001000010  ; ASR.W  D1,D2 = 1110 111 0 01 0 00 010 where D1 = 0x111 or 7
*example EQU     %1110111010000010  ; ASR.L  D1,D2 = 1110 111 0 10 0 00 010 where D1 = 0x111 or 7

*example EQU     %1000100011000011 ; DIVU.W D3,D4 = 1000 100 011 000 011
*example EQU     %0100110001000011 ; DIVU.L D3,D4 = 0100 110001 000 011

*example EQU     %1000100000000011 ; OR.B D3,D4 = 1000 100 000 000 011
*example EQU     %1000100100000011 ; OR.B D3,D4 = 1000 100 100 000 011
*example EQU     %1000100001000011 ; OR.W D3,D4 = 1000 100 001 000 011
*example EQU     %1000100101000011 ; OR.W D3,D4 = 1000 100 101 000 011
*example EQU     %1000100010000011 ; OR.L D3,D4 = 1000 100 010 000 011
*example EQU     %1000100110000011 ; OR.L D3,D4 = 1000 100 110 000 011

*example EQU     %0110010000000000 ; BCC = 0110 0100 0000 0000
*example EQU     %0110111000000000 ; BGT = 0110 1110 0000 0000
*example EQU     %0110111100000000  ; BLE = 0110 1111 0000 0000

*example EQU     %1010111100000000  ; INVALID

shift   EQU     12                 ; Shift 12 bits

* Program starts here

        LEA     STACK,SP            ; Load the SP
        LEA     table,A0            ; Index into the table
        CLR.L   D0                  ; Zero it
        MOVE.W  #example,D0         ; We'll play with it here
        MOVE.B  #shift,D1           ; Shift 12 bits to the right
        LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

table   JMP     code0000        ; ADDI.B, ADDI.W, or ADDI.L
        JMP     code0001        ; MOVE.B
        JMP     code0010        ; MOVEA.L or MOVE.L
        JMP     code0011        ; MOVEA.W or MOVE.W
        JMP     code0100        ; NOP or MOVEM.W or MOVEM.L or LEA or CLR.B or CLR.W or CLR.L or JSR or RTS or MULS.W
        JMP     code0101        ; ADDQ.B or ADDQ.W or ADDQ.L
        JMP     code0110        ; BCC or BGT or BLE
        JMP     code0111        ; MOVEQ.L
        JMP     code1000        ; OR.B or OR.W or OR.L or DIVU.W
        JMP     code1001        ; SUB.B or SUB.W or SUB.L
        JMP     code1010
        JMP     code1011        ; CMP.B or CMP.W or CMP.L
        JMP     code1100        ; AND_BorAND_WorAND_LorMULS_W
        JMP     code1101        ; ADD.B or ADD.W or ADD.L
        JMP     code1110        ; ROd_LSd_ASd
        JMP     code1111

*The following subroutines will get filled in as you decode the instructions . For *now, just exit gracefully.

code0000 JSR   ADDI_BorADDI_WorADDI_L
code0001 JSR   ISMOVEB
         JSR   DONE
code0010 JSR   MOVEA_LorMOVE_L
code0011 JSR  MOVEA_WorMOVE_W
code0100 JSR    NOP_MOVEM_LEA_JSR_CLR_RTS
         JSR    DONE
code0101 JSR    ADDQ_BorADDQ_WorADDQ_L
         JSR    DONE
code0110 JSR    BCCorBGTorBLE
         JSR    DONE
code0111 JSR    ISMOVEQL
         JSR    DONE
code1000 JSR    OR_BorOR_WorOR_LorDIVU
         JSR    DONE
code1001 JSR    SUB_BorSUB_WorSUB_L
         JSR    DONE
code1010 JSR    OPCODE_INVALID              ;INVALID
         RTS   
code1011 JSR    CMP_BorCMP_WorCMP_L
         JSR DONE
code1100 JSR    AND_BorAND_WorAND_LorMULS_W
         JSR    DONE
code1101 JSR    ADD_BorADD_WorADD_L
         JSR    DONE
code1110 JSR    ROd_LSd_ASd
         JSR    DONE
code1111 JSR    OPCODE_INVALID              ;INVALID
		 RTS 

*****************************  BCCorBGTorBLE ************************************
BCCorBGTorBLE       LEA     STACK,SP            ; Load the SP
                    LEA     tableBCCorBGTorBLE, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #6,D1           ; Shift 6 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableBCCorBGTorBLE   JMP    BCCorBGTorBLEcode00   ; BCC
                     JMP    BCCorBGTorBLEcode01   ;
                     JMP    BCCorBGTorBLEcode10   ; BGT
                     JMP    BCCorBGTorBLEcode11   ; BLE



BCCorBGTorBLEcode00    JSR     ISBCC
                       RTS
BCCorBGTorBLEcode01    JSR    OPCODE_INVALID              ;INVALID
					   RTS 
BCCorBGTorBLEcode10    JSR     ISBGT
                       RTS
BCCorBGTorBLEcode11    JSR     ISBLE
                       RTS

***************************** END  BCCorBGTorBLE ************************************

*****************************  MULSLorDIVUL ************************************
MULSLorDIVUL        LEA     STACK,SP            ; Load the SP
                    LEA     tableMULSLorDIVUL, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #6,D1           ; Shift 6 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableMULSLorDIVUL             JMP    MULSLorDIVULcode0   ;  MULS.L
                              JMP    MULSLorDIVULcode1   ;  DIVU.L

MULSLorDIVULcode0   JSR     ISMULSL
                    RTS
MULSLorDIVULcode1   JSR     ISDIVUL
                    RTS
***************************** END  MULSLorDIVUL ************************************

*****************************  OR_BorOR_WorOR_LorDIVU ************************************
OR_BorOR_WorOR_LorDIVU     LEA     STACK,SP            ; Load the SP
                    LEA     tableOR_BorOR_WorOR_LorDIVU, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #1,D1           ; Shift 1 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableOR_BorOR_WorOR_LorDIVU             JMP    OR_DIVUcode000   ; OR.B
                                        JMP    OR_DIVUcode001   ; OR.W
                                        JMP    OR_DIVUcode010   ; OR.L

                                        JMP    OR_DIVUcode011   ; DIVU.W
                                        JMP    OR_DIVUcode100   ; OR.B
                                        JMP    OR_DIVUcode101   ; OR.W
                                        JMP    OR_DIVUcode110   ; OR.L
                                        JMP    OR_DIVUcode111    ; INVALID


OR_DIVUcode000      JSR     ISORB
                    RTS
OR_DIVUcode001      JSR     ISORW
                    RTS
OR_DIVUcode010      JSR     ISORL
                    RTS
OR_DIVUcode011      JSR     ISDIVUW
                    RTS
OR_DIVUcode100      JSR     ISORB
                    RTS
OR_DIVUcode101      JSR     ISORW
                    RTS
OR_DIVUcode110      JSR     ISORL
                    RTS
OR_DIVUcode111      JSR    OPCODE_INVALID              ;INVALID
		            RTS                

***************************** END  ADD_BorADD_WorADD_L ************************************

*****************************someASR ************************************
someASR    LEA     STACK,SP            ; Load the SP
                    LEA     tableSomeASR, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #8,D1           ; Shift 8 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeASR        JMP     ASRcode00   *ASR.B
                    JMP     ASRcode01   *ASR.W
                    JMP     ASRcode10   *ASR.L
                    JMP     ASRcode11   ; INVALID


ASRcode00   JSR     ISASRB
            RTS
ASRcode01   JSR     ISASRW
            RTS
ASRcode10   JSR     ISASRL
            RTS
ASRcode11   JSR    OPCODE_INVALID              ;INVALID
		    RTS

*****************************END someLSL ************************************


*****************************someASL ************************************
someASL    LEA     STACK,SP            ; Load the SP
                    LEA     tableSomeASL, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #8,D1           ; Shift 8 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeASL        JMP     ASLcode00   *ASL.B
                    JMP     ASLcode01   *ASL.W
                    JMP     ASLcode10   *ASL.L
                    JMP     ASLcode11   ; INVALID


ASLcode00   JSR     ISASLB
            RTS
ASLcode01   JSR     ISASLW
            RTS
ASLcode10   JSR     ISASLL
            RTS
ASLcode11   JSR    OPCODE_INVALID              ;INVALID
		    RTS
*****************************END someLSL ************************************


*****************************someLSR ************************************
someLSR    LEA     STACK,SP            ; Load the SP
                    LEA     tableSomeLSR, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #8,D1           ; Shift 8 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeLSR        JMP     LSRcode00   *LSR.B
                    JMP     LSRcode01   *LSR.W
                    JMP     LSRcode10   *LSR.L
                    JMP     LSRcode11   ; INVALID
                    
LSRcode00   JSR     ISLSRB
            RTS
LSRcode01   JSR     ISLSRW
            RTS
LSRcode10   JSR     ISLSRL
            RTS
LSRcode11   JSR    OPCODE_INVALID              ;INVALID
		    RTS
*****************************END someLSR ************************************


*****************************someLSL ************************************
someLSL    LEA     STACK,SP            ; Load the SP
                    LEA     tableSomeLSL, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #8,D1           ; Shift 8 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeLSL        JMP     LSLcode00   *LSL.B
                    JMP     LSLcode01   *LSL.W
                    JMP     LSLcode10   *LSL.L
                    JMP     LSLcode11   ; INVALID

LSLcode00   JSR     ISLSLB
            RTS
LSLcode01   JSR     ISLSLW
            RTS
LSLcode10   JSR     ISLSLL
            RTS
LSLcode11   JSR    OPCODE_INVALID              ;INVALID
		    RTS
*****************************END someLSL ************************************


*****************************someROL ************************************
someROL    LEA     STACK,SP            ; Load the SP
                    LEA     tableSomeROL, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #8,D1           ; Shift 8 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeROL        JMP     ROLcode00   *ROL.B
                    JMP     ROLcode01   *ROL.W
                    JMP     ROLcode10   *ROL.L
                    JMP     ROLcode11   ; INVALID

ROLcode00   JSR     ISROLB
            RTS
ROLcode01   JSR     ISROLW
            RTS
ROLcode10   JSR     ISROLL
            RTS
ROLcode11   JSR    OPCODE_INVALID              ;INVALID
		    RTS
*****************************END someROR ************************************


*****************************someROR ************************************
someROR     LEA     STACK,SP            ; Load the SP
                    LEA     tableSomeROR, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #8,D1           ; Shift 8 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeROR        JMP     RORcode00   *ROR.B
                    JMP     RORcode01   *ROR.W
                    JMP     RORcode10   *ROR.L
                    JMP     RORcode11   ; INVALID

RORcode00   JSR     ISRORB
            RTS
RORcode01   JSR     ISRORW
            RTS
RORcode10   JSR     ISRORL
            RTS
RORcode11   JSR     OPCODE_INVALID              ;INVALID
		    RTS
*****************************END someROR ************************************


*****************************  ROL_ROR ************************************
ROL_ROR     LEA     STACK,SP            ; Load the SP
                    LEA     tableROL_ROR, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #3,D1           ; Shift 3 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableROL_ROR            JMP    ROL_RORcode0   ; ROR
                        JMP    ROL_RORcode1   ; ROL




ROL_RORcode0   JSR     someROR
               RTS
ROL_RORcode1   JSR     someROL
               RTS


***************************** END ROL_ROR ************************************


*****************************  LSL_LSR ************************************
LSL_LSR     LEA     STACK,SP            ; Load the SP
                    LEA     tableLSL_LSR, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #3,D1           ; Shift 3 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableLSL_LSR            JMP    LSL_LSRcode0   ; LSR
                        JMP    LSL_LSRcode1   ; LSL




LSL_LSRcode0   JSR     someLSR
               RTS
LSL_LSRcode1   JSR     someLSL
               RTS


***************************** END LSL_LSR ************************************


*****************************  ASL_ASR ************************************
ASL_ASR     LEA     STACK,SP            ; Load the SP
                    LEA     tableASL_ASR, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #3,D1           ; Shift 3 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableASL_ASR            JMP    ASL_ASRcode0   ; ASR
                        JMP    ASL_ASRcode1   ; ASL




ASL_ASRcode0   JSR     someASR
               RTS
ASL_ASRcode1   JSR     someASL
               RTS


***************************** END ASL_ASR ************************************


*****************************  ROd_LSd_ASd ************************************
ROd_LSd_ASd     LEA     STACK,SP            ; Load the SP
                    LEA     tableROd_LSd_ASd, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #11,D1           ; Shift 11 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableROd_LSd_ASd        JMP    ROd_LSd_ASdcode00   ; ASL_ASR
                        JMP    ROd_LSd_ASdcode01   ; LSL_LSR
                        JMP    ROd_LSd_ASdcode10
                        JMP    ROd_LSd_ASdcode11   ; ROL_ROR



ROd_LSd_ASdcode00   JSR     ASL_ASR
                    RTS
ROd_LSd_ASdcode01   JSR     LSL_LSR
                    RTS
ROd_LSd_ASdcode10   JSR    OPCODE_INVALID              ;INVALID
					RTS 
ROd_LSd_ASdcode11   JSR     ROL_ROR
                    RTS

***************************** END  ROd_LSd_ASd ************************************

*****************************  AND_BorAND_WorAND_LorMULS_W ************************************
AND_BorAND_WorAND_LorMULS_W     LEA     STACK,SP            ; Load the SP
                    LEA     tableAND_BorAND_WorAND_LorMULS_W, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #1,D1           ; Shift 1 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableAND_BorAND_WorAND_LorMULS_W        JMP    ANDcode000   ; AND.B
                                        JMP    ANDcode001   ; AND.W
                                        JMP    ANDcode010   ; AND.L

                                        JMP    ANDcode011
                                        JMP    ANDcode100   ; AND.B
                                        JMP    ANDcode101   ; AND.W
                                        JMP    ANDcode110   ; AND.L
                                        JMP    ANDcode111   ; MULS.W


ANDcode000   JSR     ISANDB
             RTS
ANDcode001   JSR     ISANDW
             RTS
ANDcode010   JSR     ISANDL
             RTS
ANDcode011   JSR    OPCODE_INVALID              ;INVALID
			 RTS 
ANDcode100   JSR     ISANDB
             RTS
ANDcode101   JSR     ISANDW
             RTS
ANDcode110   JSR     ISANDL
             RTS
ANDcode111   JSR     ISMULSW
             RTS

***************************** END  ADD_BorADD_WorADD_L ************************************

*****************************  ADD_BorADD_WorADD_L ************************************
ADD_BorADD_WorADD_L     LEA     STACK,SP            ; Load the SP
                    LEA     tableADD_BorADD_WorADD_L, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #1,D1           ; Shift 1 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableADD_BorADD_WorADD_L         JMP    ADDcode000   *ADD.B
                                 JMP    ADDcode001   *ADD.W
                                 JMP    ADDcode010   *ADD.L

                                 JMP    ADDcode011   *ADDA.W
                                 JMP    ADDcode100   *ADD.B
                                 JMP    ADDcode101   *ADD.W
                                 JMP    ADDcode110   *ADD.L
                                 JMP    ADDcode111   *ADDA.L


ADDcode000   JSR     ISADDB
             RTS
ADDcode001   JSR     ISADDW
             RTS
ADDcode010   JSR     ISADDL
             RTS
ADDcode011   JSR     ISADDAW
             RTS
ADDcode100   JSR     ISADDB
             RTS
ADDcode101   JSR     ISADDW
             RTS
ADDcode110   JSR     ISADDL
             RTS
ADDcode111   JSR     ISADDAL
             RTS

***************************** END  ADD_BorADD_WorADD_L ************************************

*****************************  SUB_BorSUB_WorSUB_L ************************************
SUB_BorSUB_WorSUB_L     LEA     STACK,SP            ; Load the SP
                    LEA     tableSUB_BorSUB_WorSUB_L, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #1,D1           ; Shift 1 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSUB_BorSUB_WorSUB_L         JMP    SUBcode000   *SUB.B
                                 JMP    SUBcode001   *SUB.W
                                 JMP    SUBcode010   *SUB.L

                                 JMP    SUBcode011
                                 JMP    SUBcode100   *SUB.B
                                 JMP    SUBcode101   *SUB.W
                                 JMP    SUBcode110   *SUB.L
                                 JMP    SUBcode111   ; INVALID


SUBcode000   JSR     ISSUBB
             RTS
SUBcode001   JSR     ISSUBW
             RTS
SUBcode010   JSR     ISSUBL
             RTS
SUBcode011   JSR    OPCODE_INVALID              ;INVALID
		     RTS 
SUBcode100   JSR     ISSUBB
             RTS
SUBcode101   JSR     ISSUBW
             RTS
SUBcode110   JSR     ISSUBL
             RTS
SUBcode111   JSR    OPCODE_INVALID              ;INVALID
		     RTS
***************************** END  SUB_BorSUB_WorSUB_L ************************************


***************************** CMP_BorCMP_WorCMP_L ************************************
CMP_BorCMP_WorCMP_L     LEA     STACK,SP            ; Load the SP
                    LEA     tableCMP_BorCMP_WorCMP_L, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #8,D1           ; Shift 8 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableCMP_BorCMP_WorCMP_L         JMP    CMPcode00   *CMP.B
                                 JMP    CMPcode01   *CMP.W
                                 JMP    CMPcode10   *CMP.L
                                 JMP    CMPcode11   ; INVALID


CMPcode00   JSR     ISCMPB
            RTS
CMPcode01   JSR     ISCMPW
            RTS
CMPcode10   JSR     ISCMPL
            RTS
CMPcode11   JSR    OPCODE_INVALID              ;INVALID
		    RTS
 
***************************** END CMP_BorCMP_WorCMP_L ************************************


***************************** ADDQ_BorADDQ_WorADDQ_L ************************************
ADDQ_BorADDQ_WorADDQ_L     LEA     STACK,SP            ; Load the SP
                    LEA     tableADDQ_BorADDQ_WorADDQ_L, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #8,D1           ; Shift 8 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableADDQ_BorADDQ_WorADDQ_L         JMP     ADDQcode00   *ADDQ.B
                                    JMP     ADDQcode01   *ADDQ.W
                                    JMP     ADDQcode10   *ADDQ.L
                                    JMP     ADDQcode11   ; INVALID

ADDQcode00   JSR     ISADDQB
            RTS
ADDQcode01   JSR     ISADDQW
            RTS
ADDQcode10   JSR     ISADDQL
            RTS
ADDQcode11   JSR    OPCODE_INVALID              ;INVALID
		    RTS
***************************** END ADDQ_BorADDQ_WorADDQ_L ************************************


*****************************someCLR ************************************
someCLR     LEA     STACK,SP            ; Load the SP
                    LEA     tableSomeCLR, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #8,D1           ; Shift 8 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
                    MOVE.B  #2,D1           ; Shift 2 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeCLR        JMP     CLRcode00   *CLR.B
                    JMP     CLRcode01   *CLR.W
                    JMP     CLRcode10   *CLR.L
                    JMP     CLRcode11   ; INVALID

CLRcode00   JSR     ISCLRB
            RTS
CLRcode01   JSR     ISCLRW
            RTS
CLRcode10   JSR     ISCLRL
            RTS
CLRcode11   JSR    OPCODE_INVALID              ;INVALID
		    RTS
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
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

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
                    RTS
NOPcommand          JSR     ISNOP
                    RTS
JSRorCLRcode0000     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode0001     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode0010    JSR      someCLR
                    RTS
JSRorCLRcode0011     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode0100     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode0101     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode0110     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode0111     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode1000     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode1001     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode1010     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode1011     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode1100     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode1101     JSR    OPCODE_INVALID              ;INVALID
					RTS 
JSRorCLRcode1110    JSR     ISJSR
                    RTS
JSRorCLRcode1111     JSR    OPCODE_INVALID              ;INVALID
					RTS 

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
                    MOVE.B  #3,D1           ; Shift 3 bits right
                    ASR.W   D1,D0

                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeMOVEM    JMP     MOVEMcode0   ;MOVEM.W
                  JMP     MOVEMcode1   ;MOVEM.L



MOVEMcode0         JSR     ISMOVEMW
                    RTS
MOVEMcode1         JSR     ISMOVEML
                    RTS

*****************************END someMOVEM ************************************

*****************************NOP_MOVEM_LEA_JSR_CLR_RTS ************************************
NOP_MOVEM_LEA_JSR_CLR_RTS     LEA     STACK,SP            ; Load the SP
                    LEA     tableNOP_MOVEM_LEA_JSR_CLR_RTS, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  #example,D0         ; We'll play with it here
                    MOVE.B  #7,D1           ; Shift 7 bits right
                    ASR.W   D1,D0

                    MOVE.B  #13,D1           ; Shift 13 bits left
                    ASL.W   D1,D0
                    MOVE.B  #shift,D1           ; Shift 12 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)


                    MULU    #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

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



LOTScode0000        JSR   MULSLorDIVUL
                    JSR    DONE
LOTScode0001        JSR    OPCODE_INVALID              ;INVALID
					RTS 
LOTScode0010        JSR    someMOVEM
                    JSR    DONE
LOTScode0011        JSR    OPCODE_INVALID              ;INVALID
					RTS 
LOTScode0100        JSR    OPCODE_INVALID              ;INVALID
					RTS 
LOTScode0101        JSR    OPCODE_INVALID              ;INVALID
					RTS 
LOTScode0110        JSR    ISLEA
                    JSR    DONE
LOTScode0111        JSR    OPCODE_INVALID              ;INVALID
					RTS 
LOTScode1000        JSR    NOPorCLRorRTSorJSR
                    JSR    DONE
LOTScode1001        JSR    OPCODE_INVALID              ;INVALID
					RTS 
LOTScode1010        JSR    NOPorCLRorRTSorJSR
                    JSR    DONE
LOTScode1011        JSR    OPCODE_INVALID              ;INVALID
					RTS 
LOTScode1100        JSR    OPCODE_INVALID              ;INVALID
					RTS 
LOTScode1101        JSR    OPCODE_INVALID              ;INVALID
					RTS 
LOTScode1110        JSR    ISLEA
                    JSR    DONE
LOTScode1111        JSR    OPCODE_INVALID              ;INVALID
					RTS 

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
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableADDI_BorADDI_WorADDI_L    JMP     ADDIBcode00
                               JMP     ADDIWcode01
                               JMP     ADDILcode10
                               JMP     ADDILcode11


ADDIBcode00        JSR     ISADDIB
                    JSR    DONE
ADDIWcode01        JSR     ISADDIW
                    JSR    DONE
ADDILcode10        JSR     ISADDIL
                    JSR    DONE
ADDILcode11        JSR    OPCODE_INVALID              ;INVALID
					RTS 
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
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

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
                    JMP     0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

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
OPCODE_INVALID  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEOPCODE_INVALID, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISBCC  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEBCC, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS
ISBGT  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEBGT, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISBLE  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEBLE, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISDIVUL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEDIVUL, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISDIVUW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEDIVUW, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISORB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEORB, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISORW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEORW, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISORL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEORL, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISASRB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEASRB, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISASRW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEASRW, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISASRL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEASRL, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISASLB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEASLB, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISASLW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEASLW, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISASLL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEASLL, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISLSRB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGELSRB, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISLSRW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGELSRW, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISLSRL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGELSRL, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISLSLB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGELSLB, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISLSLW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGELSLW, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISLSLL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGELSLL, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISRORB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGERORB, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISRORW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGERORW, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISRORL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGERORL, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISROLB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEROLB, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISROLW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEROLW, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISROLL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEROLL, A1
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISMULSL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMULSL, A1         *OPCODE is MULS.L
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISMULSW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMULSW, A1         *OPCODE is MULS.W
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISANDB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEANDB, A1         *OPCODE is AND.B
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISANDW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEANDW, A1         *OPCODE is AND.W
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISANDL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEANDL, A1         *OPCODE is AND.L
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISADDAW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEADDAW, A1         *OPCODE is ADDA.W
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISADDAL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEADDAL, A1         *OPCODE is ADDA.L
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISADDB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEADDB, A1         *OPCODE is ADD.B
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISADDW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEADDW, A1         *OPCODE is ADD.W
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISADDL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEADDL, A1         *OPCODE is ADD.L
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISSUBB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGESUBB, A1         *OPCODE is SUB.B
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISSUBW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGESUBW, A1         *OPCODE is SUB.W
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISSUBL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGESUBL, A1         *OPCODE is SUB.L
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISCMPB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGECMPB, A1         *OPCODE is CMP.B
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISCMPW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGECMPW, A1         *OPCODE is CMP.W
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISCMPL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGECMPL, A1         *OPCODE is CMP.L
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISADDQB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEADDQB, A1         *OPCODE is ADDQ.B
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISADDQW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEADDQW, A1         *OPCODE is ADDQ.W
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISADDQL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEADDQL, A1         *OPCODE is ADDQ.L
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISMOVEQL    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMOVEQL, A1         *OPCODE is MOVEQ.L
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
            LEA MESSAGECLRW, A1         *OPCODE is CLR.W
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISCLRL    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGECLRL, A1         *OPCODE is CLR.L
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISMOVEML    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMOVEML, A1         *OPCODE is MOVEM.L
            MOVE.B  #14, D0
            TRAP    #15

            MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
            RTS

ISMOVEMW    MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
            LEA MESSAGEMOVEMW, A1         *OPCODE is MOVEM.W
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

MESSAGEADDQB DC.B    'ADDQ.B',CR,LF, 0
MESSAGEADDQW DC.B    'ADDQ.W',CR,LF, 0
MESSAGEADDQL DC.B    'ADDQ.L',CR,LF, 0

MESSAGECMPB DC.B    'CMP.B',CR,LF, 0
MESSAGECMPW DC.B    'CMP.W',CR,LF, 0
MESSAGECMPL DC.B    'CMP.L',CR,LF, 0

MESSAGESUBB DC.B    'SUB.B',CR,LF, 0
MESSAGESUBW DC.B    'SUB.W',CR,LF, 0
MESSAGESUBL DC.B    'SUB.L',CR,LF, 0

MESSAGEADDB DC.B    'ADD.B',CR,LF, 0
MESSAGEADDW DC.B    'ADD.W',CR,LF, 0
MESSAGEADDL DC.B    'ADD.L',CR,LF, 0

MESSAGEADDAW DC.B    'ADDA.W',CR,LF, 0
MESSAGEADDAL DC.B    'ADDA.L',CR,LF, 0

MESSAGEMOVEQL DC.B    'MOVEQ.L',CR,LF, 0

MESSAGEANDB DC.B    'AND.B',CR,LF, 0
MESSAGEANDW DC.B    'AND.W',CR,LF, 0
MESSAGEANDL DC.B    'AND.L',CR,LF, 0

MESSAGEMULSW DC.B    'MULS.W',CR,LF, 0
MESSAGEMULSL DC.B    'MULS.L',CR,LF, 0

MESSAGEASRB DC.B    'ASR.B',CR,LF, 0
MESSAGEASRW DC.B    'ASR.W',CR,LF, 0
MESSAGEASRL DC.B    'ASR.L',CR,LF, 0

MESSAGEASLB DC.B    'ASL.B',CR,LF, 0
MESSAGEASLW DC.B    'ASL.W',CR,LF, 0
MESSAGEASLL DC.B    'ASL.L',CR,LF, 0

MESSAGERORB DC.B    'ROR.B',CR,LF, 0
MESSAGERORW DC.B    'ROR.W',CR,LF, 0
MESSAGERORL DC.B    'ROR.L',CR,LF, 0

MESSAGEROLB DC.B    'ROL.B',CR,LF, 0
MESSAGEROLW DC.B    'ROL.W',CR,LF, 0
MESSAGEROLL DC.B    'ROL.L',CR,LF, 0

MESSAGELSRB DC.B    'LSR.B',CR,LF, 0
MESSAGELSRW DC.B    'LSR.W',CR,LF, 0
MESSAGELSRL DC.B    'LSR.L',CR,LF, 0

MESSAGELSLB DC.B    'LSL.B',CR,LF, 0
MESSAGELSLW DC.B    'LSL.W',CR,LF, 0
MESSAGELSLL DC.B    'LSL.L',CR,LF, 0

MESSAGEORB DC.B    'OR.B',CR,LF, 0
MESSAGEORW DC.B    'OR.W',CR,LF, 0
MESSAGEORL DC.B    'OR.L',CR,LF, 0

MESSAGEDIVUW DC.B    'DIVU.W',CR,LF, 0
MESSAGEDIVUL DC.B    'DIVU.L',CR,LF, 0

MESSAGEBCC DC.B    'BCC',CR,LF, 0
MESSAGEBGT DC.B    'BGT',CR,LF, 0
MESSAGEBLE DC.B    'BLE',CR,LF, 0

MESSAGEOPCODE_INVALID DC.B    'That is not an opcode!',CR,LF, 0

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source





















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
