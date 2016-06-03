*-----------------------------------------------------------
* Title      : Op-Code Subroutines
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 3 May 2016
* Description: Support file containing the op-code subroutines
*              for the disassembler.
*-----------------------------------------------------------

*----------- Subroutines: ----------------------------------

*----------- OC_PARSE --------------------------------------
OC_PARSE:
        MOVEM.L     A0-A1/A3-A5/D0-D7, -(SP) ; Save registers
        LEA         initial_table,A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0         ; We'll play with it here
        MOVE.B      #12,D1          ; Shift 12 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

initial_table:
        JMP         code0000        ; ADDI.B, ADDI.W, or ADDI.L
        JMP         code0001        ; MOVE.B
        JMP         code0010        ; MOVEA.L or MOVE.L
        JMP         code0011        ; MOVEA.W or MOVE.W
        JMP         code0100        ; NOP or MOVEM.W or MOVEM.L or LEA or CLR.B or CLR.W or CLR.L or JSR or RTS or MULS.W
        JMP         code0101        ; ADDQ.B or ADDQ.W or ADDQ.L
        JMP         code0110        ; BCC or BGT or BLE
        JMP         code0111        ; MOVEQ.L
        JMP         code1000        ; OR.B or OR.W or OR.L or DIVU (DIVU is either word or long depending on ea)
        JMP         code1001        ; SUB.B or SUB.W or SUB.L
        JMP         code1010
        JMP         code1011        ; CMP.B or CMP.W or CMP.L
        JMP         code1100        ; AND_BorAND_WorAND_LorMULS_W
        JMP         code1101        ; ADD.B or ADD.W or ADD.L
        JMP         code1110        ; ROd_LSd_ASd
        JMP         code1111

code0000 JSR        ADDI_BorADDI_WorADDI_L
         JMP        DONE
code0001 JSR        ISMOVEB
         JMP        DONE
code0010 JSR        MOVEA_LorMOVE_L
         JMP        DONE
code0011 JSR        MOVEA_WorMOVE_W
         JMP        DONE
code0100 JSR        NOP_MOVEM_LEA_JSR_CLR_RTS
         JMP        DONE
code0101 JSR        ADDQ_BorADDQ_WorADDQ_L
         JMP        DONE
code0110 JSR        BCCorBGTorBLE
         JMP        DONE
code0111 JSR        ISMOVEQL
         JMP        DONE
code1000 JSR        OR_BorOR_WorOR_LorDIVU
         JMP        DONE
code1001 JSR        SUB_BorSUB_WorSUB_L
         JMP        DONE
code1010 JSR        OPCODE_INVALID              ;INVALID
		 JMP        DONE
code1011 JSR        CMP_BorCMP_WorCMP_L
         JMP        DONE
code1100 JSR        AND_BorAND_WorAND_LorMULS_W
         JMP        DONE
code1101 JSR        ADD_BorADD_WorADD_L
         JMP        DONE
code1110 JSR        ROd_LSd_ASd
         JMP        DONE
code1111 JSR        OPCODE_INVALID              ;INVALID
		 JMP        DONE
*----------- Done ------------------------------------------
DONE    MOVEM.L     (SP)+,  A0-A1/A3-A5/D0-D7 ; Restore registers
        RTS

*****************************  BCCorBGTorBLE ************************************
BCCorBGTorBLE       LEA     tableBCCorBGTorBLE, A0            ; Index into the table
                    CLR.L   D0                  ; Zero it
                    MOVE.W  (A6),D0         ; We'll play with it here
                    MOVE.B  #6,D1           ; Shift 6 bits left
                    ASL.W   D1,D0
                    MOVE.B  #14,D1           ; Shift 14 bits to the right
                    LSR.W   D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
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

*----------- OR_BorOR_WorOR_LorDIVU ------------------------
OR_BorOR_WorOR_LorDIVU:
        LEA         tableOR_BorOR_WorOR_LorDIVU, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #13,D1          ; Shift 13 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableOR_BorOR_WorOR_LorDIVU
        JMP         OR_DIVUcode000  ; OR.B
        JMP         OR_DIVUcode001  ; OR.W
        JMP         OR_DIVUcode010  ; OR.L
        JMP         OR_DIVUcode011  ; DIVU.W
        JMP         OR_DIVUcode100  ; OR.B
        JMP         OR_DIVUcode101  ; OR.W
        JMP         OR_DIVUcode110  ; OR.L
        JMP         OR_DIVUcode111  ; INVALID


OR_DIVUcode000 JSR  ISORB
               RTS
OR_DIVUcode001 JSR  ISORW
               RTS
OR_DIVUcode010 JSR  ISORL
               RTS
OR_DIVUcode011 JSR  ISDIVUW
               RTS
OR_DIVUcode100 JSR  ISORB
               RTS
OR_DIVUcode101 JSR  ISORW
               RTS
OR_DIVUcode110 JSR  ISORL
               RTS
OR_DIVUcode111 JSR    OPCODE_INVALID              ;INVALID
		       RTS
*----------- END  ADD_BorADD_WorADD_L ----------------------


*----------- someASR ---------------------------------------
someASR:
        LEA         tableSomeASR, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0         ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #14,D1          ; Shift 14 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeASR:
        JMP         ASRcode00       *ASR.B
        JMP         ASRcode01       *ASR.W
        JMP         ASRcode10       *ASR.L
        JMP         ASRcode11       *ASR.W

ASRcode00 JSR       ISASRB
          RTS
ASRcode01 JSR       ISASRW
          RTS
ASRcode10 JSR       ISASRL
          RTS
ASRcode11 JSR       ISASRW
		  RTS
*----------- END someLSL -----------------------------------

*----------- someASL ---------------------------------------
someASL:
        LEA         tableSomeASL, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #14,D1          ; Shift 14 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeASL:
        JMP         ASLcode00       *ASL.B
        JMP         ASLcode01       *ASL.W
        JMP         ASLcode10       *ASL.L
        JMP         ASLcode11       *ASL.W

ASLcode00 JSR       ISASLB
          RTS
ASLcode01 JSR       ISASLW
          RTS
ASLcode10 JSR       ISASLL
          RTS
ASLcode11 JSR       ISASLW
		  RTS
*----------- END someLSL -----------------------------------

*----------- someLSR ---------------------------------------
someLSR:
        LEA         tableSomeLSR, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #14,D1          ; Shift 14 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeLSR:
        JMP         LSRcode00       *LSR.B
        JMP         LSRcode01       *LSR.W
        JMP         LSRcode10       *LSR.L
        JMP         LSRcode11       *LSR.W
LSRcode00 JSR       ISLSRB
          RTS
LSRcode01 JSR       ISLSRW
          RTS
LSRcode10 JSR       ISLSRL
          RTS
LSRcode11 JSR       ISLSRW
		  RTS
*----------- END someLSR -----------------------------------

*----------- someLSL ---------------------------------------
someLSL:
        LEA         tableSomeLSL, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #14,D1          ; Shift 14 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeLSL:
        JMP         LSLcode00       *LSL.B
        JMP         LSLcode01       *LSL.W
        JMP         LSLcode10       *LSL.L
        JMP         LSLcode11       *LSL.W

LSLcode00 JSR       ISLSLB
          RTS
LSLcode01 JSR       ISLSLW
          RTS
LSLcode10 JSR       ISLSLL
          RTS
LSLcode11 JSR       ISLSLW
		  RTS
*----------- END someLSL -----------------------------------

*----------- someROL ---------------------------------------
someROL:
        LEA         tableSomeROL, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #14,D1          ; Shift 14 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeROL:
        JMP         ROLcode00       *ROL.B
        JMP         ROLcode01       *ROL.W
        JMP         ROLcode10       *ROL.L
        JMP         ROLcode11       *ROL.W

ROLcode00 JSR       ISROLB
          RTS
ROLcode01 JSR       ISROLW
          RTS
ROLcode10 JSR       ISROLL
          RTS
ROLcode11 JSR       ISROLW
		  RTS
*----------- END someROR -----------------------------------


*----------- someROR ---------------------------------------
someROR:
        LEA         tableSomeROR, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #14,D1          ; Shift 14 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeROR:
        JMP         RORcode00       *ROR.B
        JMP         RORcode01       *ROR.W
        JMP         RORcode10       *ROR.L
        JMP         RORcode11       *ROR.W

RORcode00 JSR       ISRORB
          RTS
RORcode01 JSR       ISRORW
          RTS
RORcode10 JSR       ISRORL
          RTS
RORcode11 JSR       ISRORW
		  RTS
*----------- END someROR -----------------------------------

*----------- ROL_ROR ---------------------------------------
ROL_ROR:
        LEA         tableROL_ROR, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #15,D1          ; Shift 15 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableROL_ROR:
        JMP         ROL_RORcode0    ; ROR
        JMP         ROL_RORcode1    ; ROL

ROL_RORcode0 JSR    someROR
             RTS
ROL_RORcode1 JSR    someROL
             RTS
*----------- END ROL_ROR -----------------------------------

*----------- LSL_LSR ---------------------------------------
LSL_LSR:
        LEA         tableLSL_LSR, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #15,D1          ; Shift 15 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableLSL_LSR:
        JMP         LSL_LSRcode0    ; LSR
        JMP         LSL_LSRcode1    ; LSL

LSL_LSRcode0 JSR    someLSR
             RTS
LSL_LSRcode1 JSR    someLSL
             RTS
*----------- END LSL_LSR -----------------------------------

*----------- ASL_ASR ---------------------------------------
ASL_ASR:
        LEA         tableASL_ASR, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #15,D1          ; Shift 15 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableASL_ASR:
        JMP         ASL_ASRcode0    ; ASR
        JMP         ASL_ASRcode1    ; ASL

ASL_ASRcode0 JSR    someASR
             RTS
ASL_ASRcode1 JSR    someASL
             RTS
*----------- END ASL_ASR -----------------------------------

*----------- ROd_LSd_ASd -----------------------------------
ROd_LSd_ASd:
        LEA         tableROd_LSd_ASd, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #11,D1          ; Shift 11 bits left
        ASL.W       D1,D0
        MOVE.B      #15,D1          ; Shift 12 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableROd_LSd_ASd:
        JMP         ROd_LSd_ASdcode00 ; ASL_ASR
        JMP         ROd_LSd_ASdcode01 ; LSL_LSR
        JMP         ROd_LSd_ASdcode10
        JMP         ROd_LSd_ASdcode11 ; ROL_ROR

ROd_LSd_ASdcode00 JSR ASL_ASR
                  RTS
ROd_LSd_ASdcode01 JSR LSL_LSR
                  RTS
ROd_LSd_ASdcode10 JSR    OPCODE_INVALID              ;INVALID
				  RTS
ROd_LSd_ASdcode11 JSR ROL_ROR
                  RTS
*----------- END  ROd_LSd_ASd ------------------------------

*----------- AND_BorAND_WorAND_LorMULS_W -------------------
AND_BorAND_WorAND_LorMULS_W:
        LEA         tableAND_BorAND_WorAND_LorMULS_W, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      (A6),D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #13,D1              ; Shift 13 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                ; and the rest are zeroed out)
        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableAND_BorAND_WorAND_LorMULS_W:
        JMP         ANDcode000   ; AND.B
        JMP         ANDcode001   ; AND.W
        JMP         ANDcode010   ; AND.L
        JMP         ANDcode011
        JMP         ANDcode100   ; AND.B
        JMP         ANDcode101   ; AND.W
        JMP         ANDcode110   ; AND.L
        JMP         ANDcode111   ; MULS.W

ANDcode000 JSR      ISANDB
           RTS
ANDcode001 JSR      ISANDW
           RTS
ANDcode010 JSR      ISANDL
           RTS
ANDcode011 JSR    OPCODE_INVALID              ;INVALID
		   RTS
ANDcode100 JSR      ISANDB
           RTS
ANDcode101 JSR      ISANDW
           RTS
ANDcode110 JSR      ISANDL
           RTS
ANDcode111 JSR      ISMULSW
           RTS
*----------- END  ADD_BorADD_WorADD_L ----------------------

*----------- ADD_BorADD_WorADD_L ---------------------------
ADD_BorADD_WorADD_L:
        LEA         tableADD_BorADD_WorADD_L, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #13,D1          ; Shift 13 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableADD_BorADD_WorADD_L:
        JMP         ADDcode000      *ADD.B
        JMP         ADDcode001      *ADD.W
        JMP         ADDcode010      *ADD.L
        JMP         ADDcode011      *ADDA.W
        JMP         ADDcode100      *ADD.B
        JMP         ADDcode101      *ADD.W
        JMP         ADDcode110      *ADD.L
        JMP         ADDcode111      *ADDA.L

ADDcode000 JSR      ISADDB
           RTS
ADDcode001 JSR      ISADDW
           RTS
ADDcode010 JSR      ISADDL
           RTS
ADDcode011 JSR      ISADDAW
           RTS
ADDcode100 JSR      ISADDB
           RTS
ADDcode101 JSR      ISADDW
           RTS
ADDcode110 JSR      ISADDL
           RTS
ADDcode111 JSR      ISADDAL
           RTS
*----------- END  ADD_BorADD_WorADD_L ----------------------

*----------- SUB_BorSUB_WorSUB_L ---------------------------
SUB_BorSUB_WorSUB_L:
        LEA         tableSUB_BorSUB_WorSUB_L, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #13,D1          ; Shift 13 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSUB_BorSUB_WorSUB_L:
        JMP         SUBcode000      *SUB.B
        JMP         SUBcode001      *SUB.W
        JMP         SUBcode010      *SUB.L
        JMP         SUBcode011
        JMP         SUBcode100      *SUB.B
        JMP         SUBcode101      *SUB.W
        JMP         SUBcode110      *SUB.L
        JMP         SUBcode111      ; INVALID

SUBcode000 JSR      ISSUBB
           RTS
SUBcode001 JSR      ISSUBW
           RTS
SUBcode010 JSR      ISSUBL
           RTS
SUBcode011 JSR      OPCODE_INVALID              ;INVALID
           RTS
SUBcode100 JSR      ISSUBB
           RTS
SUBcode101 JSR      ISSUBW
           RTS
SUBcode110 JSR      ISSUBL
           RTS
SUBcode111 JSR      OPCODE_INVALID              ;INVALID
		   RTS
*----------- END  SUB_BorSUB_WorSUB_L ----------------------

*----------- CMP_BorCMP_WorCMP_L ---------------------------
CMP_BorCMP_WorCMP_L:
        LEA         tableCMP_BorCMP_WorCMP_L, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #14,D1          ; Shift 14 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableCMP_BorCMP_WorCMP_L:
        JMP         CMPcode00       *CMP.B
        JMP         CMPcode01       *CMP.W
        JMP         CMPcode10       *CMP.L
        JMP         CMPcode11       ; INVALID

CMPcode00   JSR      ISCMPB
            RTS
CMPcode01   JSR      ISCMPW
            RTS
CMPcode10   JSR      ISCMPL
            RTS
CMPcode11   JSR    OPCODE_INVALID              ;INVALID
		    RTS
*----------- END CMP_BorCMP_WorCMP_L -----------------------

*----------- ADDQ_BorADDQ_WorADDQ_L ------------------------
ADDQ_BorADDQ_WorADDQ_L:
        LEA         tableADDQ_BorADDQ_WorADDQ_L, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #14,D1          ; Shift 14 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableADDQ_BorADDQ_WorADDQ_L:
        JMP         ADDQcode00      *ADDQ.B
        JMP         ADDQcode01      *ADDQ.W
        JMP         ADDQcode10      *ADDQ.L
        JMP         ADDQcode11      ; INVALID

ADDQcode00 JSR      ISADDQB
           RTS
ADDQcode01 JSR      ISADDQW
           RTS
ADDQcode10 JSR      ISADDQL
           RTS
ADDQcode11   JSR    OPCODE_INVALID              ;INVALID
		    RTS
*----------- END ADDQ_BorADDQ_WorADDQ_L --------------------

*----------- someCLR ---------------------------------------
someCLR:
        LEA         tableSomeCLR, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #14,D1       ; Shift 12 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeCLR:
        JMP         CLRcode00       *CLR.B
        JMP         CLRcode01       *CLR.W
        JMP         CLRcode10       *CLR.L
        JMP         CLRcode11       ; INVALID

CLRcode00 JSR       ISCLRB
          RTS
CLRcode01 JSR       ISCLRW
          RTS
CLRcode10 JSR       ISCLRL
          RTS
CLRcode11 JSR    OPCODE_INVALID              ;INVALID
		  RTS
*----------- END someCLR -----------------------------------

*----------- NOPorCLRorRTSorJSR ----------------------------
NOPorCLRorRTSorJSR:
        LEA         tableNOPorCLRorRTSorJSR, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here

        MOVE.W      #%0100111001110001, D1 ; 0100111001110001 = NOP
        CMP.W       D0, D1
        BEQ         NOPcommand

        MOVE.W      #%0100111001110101, D1 ; 0100111001110101 = RTS
        CMP.W       D0, D1
        BEQ         RTScommand

        MOVE.B      #4,D1           ; Shift 4 bits left
        ASL.W       D1,D0
        MOVE.B      #12,D1          ; Shift 12 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableNOPorCLRorRTSorJSR:
        JMP         JSRorCLRcode0000
        JMP         JSRorCLRcode0001
        JMP         JSRorCLRcode0010
        JMP         JSRorCLRcode0011
        JMP         JSRorCLRcode0100
        JMP         JSRorCLRcode0101
        JMP         JSRorCLRcode0110
        JMP         JSRorCLRcode0111
        JMP         JSRorCLRcode1000
        JMP         JSRorCLRcode1001
        JMP         JSRorCLRcode1010
        JMP         JSRorCLRcode1011
        JMP         JSRorCLRcode1100
        JMP         JSRorCLRcode1101
        JMP         JSRorCLRcode1110
        JMP         JSRorCLRcode1111

RTScommand JSR      ISRTS
           RTS
NOPcommand JSR      ISNOP
           RTS
JSRorCLRcode0000 JSR    OPCODE_INVALID              ;INVALID
				 RTS
JSRorCLRcode0001 JSR    OPCODE_INVALID              ;INVALID
				 RTS
JSRorCLRcode0010 JSR someCLR
                 RTS
JSRorCLRcode0011 JSR    OPCODE_INVALID              ;INVALID
				 RTS
JSRorCLRcode0100 JSR    OPCODE_INVALID              ;INVALID
			     RTS
JSRorCLRcode0101 JSR    OPCODE_INVALID              ;INVALID
				 RTS
JSRorCLRcode0110 JSR    OPCODE_INVALID              ;INVALID
				 RTS
JSRorCLRcode0111 JSR    OPCODE_INVALID              ;INVALID
				 RTS
JSRorCLRcode1000 JSR    OPCODE_INVALID              ;INVALID
                 RTS
JSRorCLRcode1001 JSR    OPCODE_INVALID              ;INVALID
				 RTS
JSRorCLRcode1010 JSR    OPCODE_INVALID              ;INVALID
				 RTS
JSRorCLRcode1011 JSR    OPCODE_INVALID              ;INVALID
				 RTS
JSRorCLRcode1100 JSR    OPCODE_INVALID              ;INVALID
				 RTS
JSRorCLRcode1101 JSR    OPCODE_INVALID              ;INVALID
				 RTS
JSRorCLRcode1110 JSR ISJSR
                 RTS
JSRorCLRcode1111 JSR    OPCODE_INVALID              ;INVALID
				 RTS
*----------- END NOPorCLRorRTSorJSR ------------------------

*----------- someMOVEM -------------------------------------
someMOVEM:
        LEA         tableSomeMOVEM, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #9,D1           ; Shift 9 bits left
        ASL.W       D1,D0
        MOVE.B      #15,D1       ; Shift 12 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeMOVEM:
        JMP         MOVEMcode0      ; MOVEM.W
        JMP         MOVEMcode1      ; MOVEM.L

MOVEMcode0 JSR      ISMOVEMW
           RTS
MOVEMcode1 JSR      ISMOVEML
           RTS
*----------- END someMOVEM ---------------------------------

*----------- NOP_MOVEM_LEA_JSR_CLR_RTS ---------------------
NOP_MOVEM_LEA_JSR_CLR_RTS:
        LEA         tableNOP_MOVEM_LEA_JSR_CLR_RTS, A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits right
        ASR.W       D1,D0
        MOVE.B      #13,D1          ; Shift 13 bits left
        ASL.W       D1,D0
        MOVE.B      #12,D1          ; Shift 12 bits to the right
        LSR.W       D1,D0           ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                    ; and the rest are zeroed out)
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableNOP_MOVEM_LEA_JSR_CLR_RTS:
        JMP         LOTScode0000
        JMP         LOTScode0001
        JMP         LOTScode0010
        JMP         LOTScode0011
        JMP         LOTScode0100
        JMP         LOTScode0101
        JMP         LOTScode0110
        JMP         LOTScode0111
        JMP         LOTScode1000
        JMP         LOTScode1001
        JMP         LOTScode1010
        JMP         LOTScode1011
        JMP         LOTScode1100
        JMP         LOTScode1101
        JMP         LOTScode1110
        JMP         LOTScode1111

LOTScode0000 JSR    OPCODE_INVALID              ; MULS.L and DIVU.L are not supported for 68000 Disassember
             RTS
LOTScode0001 JSR    OPCODE_INVALID              ;INVALID
             RTS
LOTScode0010 JSR    someMOVEM
             RTS
LOTScode0011 JSR    OPCODE_INVALID              ;INVALID
			 RTS
LOTScode0100 JSR    OPCODE_INVALID              ;INVALID
			 RTS
LOTScode0101 JSR    OPCODE_INVALID              ;INVALID
			 RTS
LOTScode0110 JSR    ISLEA
             RTS
LOTScode0111 JSR    OPCODE_INVALID              ;INVALID
			 RTS
LOTScode1000 JSR    NOPorCLRorRTSorJSR
             RTS
LOTScode1001 JSR    OPCODE_INVALID              ;INVALID
			 RTS
LOTScode1010 JSR    NOPorCLRorRTSorJSR
             RTS
LOTScode1011 JSR    OPCODE_INVALID              ;INVALID
			 RTS
LOTScode1100 JSR    OPCODE_INVALID              ;INVALID
			 RTS
LOTScode1101 JSR    OPCODE_INVALID              ;INVALID
			 RTS
LOTScode1110 JSR    ISLEA
             RTS
LOTScode1111 JSR    OPCODE_INVALID              ;INVALID
			 RTS
*----------- END NOP_MOVEM_LEA_JSR_CLR_RTS -----------------

*----------- ADDI_BorADDI_WorADDI_L ------------------------
ADDI_BorADDI_WorADDI_L:
        LEA         tableADDI_BorADDI_WorADDI_L,A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #13,D1          ; Shift 13 bits right
        ASR.W       D1,D0
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableADDI_BorADDI_WorADDI_L:
        JMP         ADDIBcode00
        JMP         ADDIWcode01
        JMP         ADDILcode10
        JMP         ADDILcode11

ADDIBcode00 JSR     ISADDIB
            RTS
ADDIWcode01 JSR     ISADDIW
            RTS
ADDILcode10 JSR     ISADDIL
            RTS
ADDILcode11 JSR    OPCODE_INVALID              ;INVALID
			RTS
*----------- END ADDI_BorADDI_WorADDI_L --------------------

*----------- MOVEA_LorMOVE_L -------------------------------
MOVEA_LorMOVE_L:
        LEA         tableMOVEA_LorMOVE_L,A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0           ; 0011 1010 0100 0100 to 0010 0000 0000 0000
        MOVE.B      #13,D1          ; Shift 13 bits right
        ASR.W       D1,D0           ; 0010 0000 0000 0000 to 0000 0000 0000 0001
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableMOVEA_LorMOVE_L:
        JMP         MOVEcode000
        JMP         MOVEAcode001
        JMP         MOVEcode010
        JMP         MOVEcode011
        JMP         MOVEcode100
        JMP         MOVEcode101
        JMP         MOVEcode110
        JMP         MOVEcode111

MOVEcode000 JSR     ISMOVEL
            RTS
MOVEAcode001 JSR    ISMOVEAL
             RTS
MOVEcode010 JSR     ISMOVEL
            RTS
MOVEcode011 JSR     ISMOVEL
            RTS
MOVEcode100 JSR     ISMOVEL
            RTS
MOVEcode101 JSR     ISMOVEL
            RTS
MOVEcode110 JSR     ISMOVEL
            RTS
MOVEcode111 JSR     ISMOVEL
            RTS
*----------- END MOVEA_LorMOVE_L ---------------------------

*----------- MOVEA_WorMOVE_W -------------------------------
MOVEA_WorMOVE_W:
        LEA         tableMOVEA_WorMOVE_W,A0 ; Index into the table
        CLR.L       D0              ; Zero it
        MOVE.W      (A6),D0     ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0           ; 0011 1010 0100 0100 to 0010 0000 0000 0000
        MOVE.B      #13,D1          ; Shift 13 bits right
        ASR.W       D1,D0           ; 0010 0000 0000 0000 to 0000 0000 0000 0001
        MULU        #6,D0           ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JMP         0(A0,D0)        ; Jump indirect with index, i.e. jump to 'table' + displacement

tableMOVEA_WorMOVE_W:
        JMP         MOVEWcode000
        JMP         MOVEAWcode001
        JMP         MOVEWcode010
        JMP         MOVEWcode011
        JMP         MOVEWcode100
        JMP         MOVEWcode101
        JMP         MOVEWcode110
        JMP         MOVEWcode111

MOVEWcode000 JSR    ISMOVEW
             RTS
MOVEAWcode001 JSR   ISMOVEAW
              RTS
MOVEWcode010 JSR    ISMOVEW
             RTS
MOVEWcode011 JSR    ISMOVEW
             RTS
MOVEWcode100 JSR    ISMOVEW
             RTS
MOVEWcode101 JSR    ISMOVEW
             RTS
MOVEWcode110 JSR    ISMOVEW
             RTS
MOVEWcode111 JSR    ISMOVEW
             RTS
*----------- END MOVEA_WorMOVE_W ---------------------------

*----------- All 'IS' Subroutines --------------------------
; TODO: adjust workflow to:
;   1) save message address to buffer pointer
OPCODE_INVALID JSR     INVALID_DATA
            ADDA.L      #$00000002, A6          ; Increment past current opcode word
            RTS

ISBCC:
            LEA    MESSAGEBCC, A4
            JSR    WRITE2MEM
            LEA    MESSAGESPACE, A4
            JSR    WRITE2MEM
            JSR     EA_Bcc
            RTS
ISBGT:
            LEA MESSAGEBGT, A4
            JSR    WRITE2MEM
            LEA    MESSAGESPACE, A4
            JSR    WRITE2MEM
            JSR     EA_Bcc
            RTS

ISBLE:
            LEA MESSAGEBLE, A4
            JSR    WRITE2MEM
            LEA    MESSAGESPACE, A4
            JSR    WRITE2MEM
            JSR     EA_Bcc
            RTS

ISDIVUW:
            LEA MESSAGEDIVUW, A4
            JSR    WRITE2MEM
            LEA    MESSAGESPACE, A4
            JSR    WRITE2MEM
            JSR     EA_DIVU_W
            RTS

ISORB:
        LEA         MESSAGEORB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_OR
        RTS

ISORW:
        LEA         MESSAGEORW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_OR
        RTS

ISORL:
        LEA         MESSAGEORL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_OR
        RTS

ISASRB:
        LEA         MESSAGEASRB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ASd
        RTS

ISASRW:
        LEA         MESSAGEASRW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ASd
        RTS

ISASRL:
        LEA         MESSAGEASRL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ASd
        RTS

ISASLB:
        LEA         MESSAGEASLB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ASd
        RTS

ISASLW:
        LEA         MESSAGEASLW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ASd
        RTS

ISASLL:
        LEA         MESSAGEASLL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ASd
        RTS

ISLSRB:
        LEA         MESSAGELSRB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_LSd
        RTS

ISLSRW:
        LEA         MESSAGELSRW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_LSd
        RTS

ISLSRL:
        LEA         MESSAGELSRL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_LSd
        RTS

ISLSLB:
        LEA         MESSAGELSLB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_LSd
        RTS

ISLSLW:
        LEA         MESSAGELSLW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_LSd
        RTS

ISLSLL:
        LEA         MESSAGELSLL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_LSd
        RTS

ISRORB:
        LEA         MESSAGERORB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ROd
        RTS

ISRORW:
        LEA         MESSAGERORW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ROd
        RTS

ISRORL:
        LEA         MESSAGERORL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ROd
        RTS

ISROLB:
        LEA         MESSAGEROLB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ROd
        RTS

ISROLW:
        LEA         MESSAGEROLW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ROd
        RTS

ISROLL:
        LEA         MESSAGEROLL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ROd
        RTS

ISMULSW:
        LEA         MESSAGEMULSW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_MULS_W
        RTS

ISANDB:
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_AND
        RTS

ISANDW:
        LEA         MESSAGEANDW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_AND
        RTS

ISANDL:
        LEA         MESSAGEANDL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_AND
        RTS

ISADDAW:
        LEA         MESSAGEADDAW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ADDA
        RTS

ISADDAL:
        LEA         MESSAGEADDAL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ADDA
        RTS

ISADDB:
        LEA         MESSAGEADDB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ADD
        RTS

ISADDW:
        LEA         MESSAGEADDW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ADD
        RTS

ISADDL:
        LEA         MESSAGEADDL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ADD
        RTS

ISSUBB:
        LEA         MESSAGESUBB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_SUB
        RTS

ISSUBW:
        LEA         MESSAGESUBW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_SUB
        RTS

ISSUBL:
        LEA         MESSAGESUBL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_SUB
        RTS

ISCMPB:
        LEA         MESSAGECMPB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_CMP
        RTS

ISCMPW:
        LEA         MESSAGECMPW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_CMP
        RTS

ISCMPL:
        LEA         MESSAGECMPL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_CMP
        RTS

ISADDQB:
    LEA         MESSAGEADDQB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ADDQ
        RTS

ISADDQW:
    LEA         MESSAGEADDQW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ADDQ
        RTS

ISADDQL:
    LEA         MESSAGEADDQL, A1 *OPCODE is ADDQ.L
        MOVE.B      #14, D0
        TRAP        #15
        JSR         EA_ADDQ
        RTS

ISMOVEQL:
    LEA         MESSAGEMOVEQL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_MOVEQ
        RTS

ISCLRB:
        LEA         MESSAGECLRB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_MOVEQ
        RTS

ISCLRW:
        LEA         MESSAGECLRW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_CLR
        RTS

ISCLRL:
        LEA         MESSAGECLRL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_CLR
        RTS

ISMOVEML:
    LEA         MESSAGEMOVEML, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_MOVEM
        RTS

ISMOVEMW:
    LEA         MESSAGEMOVEMW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_MOVEM
        RTS

ISLEA:
        LEA         MESSAGELEA, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_LEA
        RTS                         ; Exit subroutine

ISJSR:
        LEA         MESSAGEJSR, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_JSR
        RTS                         ; Exit subroutine

ISRTS:
        LEA         MESSAGERTS, A4
        JSR    WRITE2MEM
        JSR    WRITE2MEM
        ADDA.L      #$00000002, A6      ; increment global pointer past current opcode word
        RTS

ISCLR:
        LEA         MESSAGECLR, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_CLR
        RTS

ISNOP:
        LEA         MESSAGENOP, A4
        JSR         WRITE2MEM
        ADDA.L      #$00000002, A6      ; increment global pointer past current opcode word
        RTS                         ; Exit subroutine

ISMOVEW:
    LEA         MESSAGEMOVEW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_MOVE
        RTS                         ; Exit subroutine

ISMOVEAW:
    LEA         MESSAGEMOVEAW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_MOVEA
        RTS                         ; Exit subroutine

ISMOVEL:
    LEA         MESSAGEMOVEL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_MOVE
        RTS                         ; Exit subroutine

ISMOVEAL:
    LEA         MESSAGEMOVEAL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_MOVEA
        RTS                         ; Exit subroutine

ISMOVEB:
    LEA         MESSAGEMOVEB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_MOVE
        RTS                         ; Exit subroutine

ISADDIW:
    LEA         MESSAGEADDIW, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ADDI
        RTS                         ; Exit subroutine

ISADDIL:
    LEA         MESSAGEADDIL, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ADDI
        RTS                         ; Exit subroutine

ISADDIB:
    LEA         MESSAGEADDIB, A4
        JSR    WRITE2MEM
        LEA    MESSAGESPACE, A4
        JSR    WRITE2MEM
        JSR         EA_ADDI
        RTS                         ; Exit subroutine








*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
