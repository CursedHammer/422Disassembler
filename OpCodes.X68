*-----------------------------------------------------------
* Title      : Op-Code Subroutines
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 3 May 2016
* Description: Support file containing the op-code subroutines
*              for the disassembler.
*-----------------------------------------------------------

*----------- Definitions Used for Code ---------------------

*----------- Subroutines: ----------------------------------

*----------- OR_BorOR_WorOR_LorDIVU --------------------------
OR_BorOR_WorOR_LorDIVU:
        LEA         tableOR_BorOR_WorOR_LorDIVU, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #1,D1           ; Shift 1 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableOR_BorOR_WorOR_LorDIVU
        JMP         OR_DIVUcode000   ; OR.B
        JMP         OR_DIVUcode001   ; OR.W
        JMP         OR_DIVUcode010   ; OR.L

        JMP         OR_DIVUcode011   ; DIVU (either word or long from ea)
        JMP         OR_DIVUcode100   ; OR.B
        JMP         OR_DIVUcode101   ; OR.W
        JMP         OR_DIVUcode110   ; OR.L
        ;JMP    OR_DIVUcode111

OR_DIVUcode000 JSR  ISORB
               JSR  DONE
OR_DIVUcode001 JSR  ISORW
               JSR  DONE
OR_DIVUcode010 JSR  ISORL
               JSR  DONE
OR_DIVUcode011 JSR  ISDIVU
               JSR  DONE
OR_DIVUcode100 JSR  ISORB
               JSR  DONE
OR_DIVUcode101 JSR  ISORW
               JSR  DONE
OR_DIVUcode110 JSR  ISORL
               JSR  DONE

*----------- END  ADD_BorADD_WorADD_L --------------------------

*----------- someASR --------------------------
someASR:
        LEA         tableSomeASR, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #2,D1           ; Shift 2 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeASR:
        JMP         ASRcode00   *ASR.B
        JMP         ASRcode01   *ASR.W
        JMP         ASRcode10   *ASR.L

ASRcode00 JSR       ISASRB
          JSR       DONE
ASRcode01 JSR       ISASRW
          JSR       DONE
ASRcode10 JSR       ISASRL
          JSR       DONE

*----------- END someLSL --------------------------


*----------- someASL --------------------------
someASL:
        LEA         tableSomeASL, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #2,D1           ; Shift 2 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeASL:
        JMP         ASLcode00   *ASL.B
        JMP         ASLcode01   *ASL.W
        JMP         ASLcode10   *ASL.L

ASLcode00 JSR       ISASLB
          JSR       DONE
ASLcode01 JSR       ISASLW
          JSR       DONE
ASLcode10 JSR       ISASLL
          JSR       DONE

*----------- END someLSL --------------------------

*----------- someLSR --------------------------
someLSR:
        LEA         tableSomeLSR, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #2,D1           ; Shift 2 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeLSR:
        JMP         LSRcode00   *LSR.B
        JMP         LSRcode01   *LSR.W
        JMP         LSRcode10   *LSR.L

LSRcode00 JSR       ISLSRB
          JSR       DONE
LSRcode01 JSR       ISLSRW
          JSR       DONE
LSRcode10 JSR       ISLSRL
          JSR       DONE

*----------- END someLSR --------------------------

*----------- someLSL --------------------------
someLSL:
        LEA         tableSomeLSL, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #2,D1           ; Shift 2 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeLSL:
        JMP         LSLcode00   *LSL.B
        JMP         LSLcode01   *LSL.W
        JMP         LSLcode10   *LSL.L

LSLcode00 JSR       ISLSLB
          JSR       DONE
LSLcode01 JSR       ISLSLW
          JSR       DONE
LSLcode10 JSR       ISLSLL
          JSR       DONE

*----------- END someLSL --------------------------

*----------- someROL --------------------------
someROL:
        LEA         tableSomeROL, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #2,D1           ; Shift 2 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeROL:
        JMP         ROLcode00   *ROL.B
        JMP         ROLcode01   *ROL.W
        JMP         ROLcode10   *ROL.L

ROLcode00 JSR       ISROLB
          JSR       DONE
ROLcode01 JSR       ISROLW
          JSR       DONE
ROLcode10 JSR       ISROLL
          JSR       DONE

*----------- END someROR --------------------------


*----------- someROR --------------------------
someROR:
        LEA         tableSomeROR, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #2,D1           ; Shift 2 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeROR:
        JMP         RORcode00   *ROR.B
        JMP         RORcode01   *ROR.W
        JMP         RORcode10   *ROR.L

RORcode00 JSR       ISRORB
          JSR       DONE
RORcode01 JSR       ISRORW
          JSR       DONE
RORcode10 JSR       ISRORL
          JSR       DONE

*----------- END someROR --------------------------

*----------- ROL_ROR --------------------------
ROL_ROR:
        LEA         tableROL_ROR, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                    ; and the rest are zeroed out)
        MOVE.B      #3,D1           ; Shift 3 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableROL_ROR:
        JMP         ROL_RORcode0   ; ROR
        JMP         ROL_RORcode1   ; ROL

ROL_RORcode0 JSR    someROR
             JSR    DONE
ROL_RORcode1 JSR    someROL
             JSR    DONE

*----------- END ROL_ROR --------------------------

*----------- LSL_LSR --------------------------
LSL_LSR:
        LEA         tableLSL_LSR, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #3,D1           ; Shift 3 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableLSL_LSR:
        JMP         LSL_LSRcode0   ; LSR
        JMP         LSL_LSRcode1   ; LSL

LSL_LSRcode0 JSR    someLSR
             JSR    DONE
LSL_LSRcode1 JSR    someLSL
             JSR    DONE

*----------- END LSL_LSR --------------------------

*----------- ASL_ASR --------------------------
ASL_ASR:
        LEA         tableASL_ASR, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #3,D1           ; Shift 3 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableASL_ASR:
        JMP         ASL_ASRcode0   ; ASR
        JMP         ASL_ASRcode1   ; ASL

ASL_ASRcode0 JSR    someASR
             JSR    DONE
ASL_ASRcode1 JSR    someASL
             JSR    DONE

*----------- END ASL_ASR --------------------------

*----------- ROd_LSd_ASd --------------------------
ROd_LSd_ASd:
        LEA         tableROd_LSd_ASd, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #11,D1           ; Shift 11 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B          #2,D1           ; Shift 2 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableROd_LSd_ASd:
        JMP         ROd_LSd_ASdcode00   ; ASL_ASR
        JMP         ROd_LSd_ASdcode01   ; LSL_LSR
        JMP         ROd_LSd_ASdcode10
        JMP         ROd_LSd_ASdcode11   ; ROL_ROR

ROd_LSd_ASdcode00 JSR ASL_ASR
                  JSR DONE
ROd_LSd_ASdcode01 JSR LSL_LSR
                  JSR DONE
ROd_LSd_ASdcode10 STOP #$2700
ROd_LSd_ASdcode11 JSR ROL_ROR
                  JSR DONE

*----------- END  ROd_LSd_ASd --------------------------

*----------- AND_BorAND_WorAND_LorMULS_W --------------------------
AND_BorAND_WorAND_LorMULS_W:
        LEA         tableAND_BorAND_WorAND_LorMULS_W, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                ; and the rest are zeroed out)
        MOVE.B      #1,D1           ; Shift 1 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

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
           JSR      DONE
ANDcode001 JSR      ISANDW
           JSR      DONE
ANDcode010 JSR      ISANDL
           JSR      DONE
ANDcode011 STOP     #$2700
ANDcode100 JSR      ISANDB
           JSR      DONE
ANDcode101 JSR      ISANDW
           JSR      DONE
ANDcode110 JSR      ISANDL
           JSR      DONE
ANDcode111 JSR      ISMULSW
           JSR      DONE

*----------- END  ADD_BorADD_WorADD_L --------------------------

*----------- ADD_BorADD_WorADD_L --------------------------
ADD_BorADD_WorADD_L:
        LEA         tableADD_BorADD_WorADD_L, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                                        ; and the rest are zeroed out)
        MOVE.B      #1,D1               ; Shift 1 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableADD_BorADD_WorADD_L:
        JMP         ADDcode000   *ADD.B
        JMP         ADDcode001   *ADD.W
        JMP         ADDcode010   *ADD.L
        JMP         ADDcode011   *ADDA.W
        JMP         ADDcode100   *ADD.B
        JMP         ADDcode101   *ADD.W
        JMP         ADDcode110   *ADD.L
        JMP         ADDcode111   *ADDA.L

ADDcode000 JSR      ISADDB
           JSR      DONE
ADDcode001 JSR      ISADDW
           JSR      DONE
ADDcode010 JSR      ISADDL
           JSR      DONE
ADDcode011 JSR      ISADDAW
           JSR      DONE
ADDcode100 JSR      ISADDB
           JSR      DONE
ADDcode101 JSR      ISADDW
           JSR      DONE
ADDcode110 JSR      ISADDL
           JSR      DONE
ADDcode111 JSR      ISADDAL
           JSR      DONE

*----------- END  ADD_BorADD_WorADD_L --------------------------

*----------- SUB_BorSUB_WorSUB_L --------------------------
SUB_BorSUB_WorSUB_L:
        LEA         tableSUB_BorSUB_WorSUB_L, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                    ; and the rest are zeroed out)
        MOVE.B      #1,D1           ; Shift 1 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSUB_BorSUB_WorSUB_L:
        JMP         SUBcode000   *SUB.B
        JMP         SUBcode001   *SUB.W
        JMP         SUBcode010   *SUB.L

        JMP         SUBcode011
        JMP         SUBcode100   *SUB.B
        JMP         SUBcode101   *SUB.W
        JMP         SUBcode110   *SUB.L

SUBcode000 JSR      ISSUBB
           JSR      DONE
SUBcode001 JSR      ISSUBW
           JSR      DONE
SUBcode010 JSR      ISSUBL
           JSR      DONE
SUBcode011 STOP     #$2700
SUBcode100 JSR      ISSUBB
           JSR      DONE
SUBcode101 JSR      ISSUBW
           JSR      DONE
SUBcode110 JSR      ISSUBL
           JSR      DONE

*----------- END  SUB_BorSUB_WorSUB_L --------------------------

*----------- CMP_BorCMP_WorCMP_L --------------------------
CMP_BorCMP_WorCMP_L:
        LEA         tableCMP_BorCMP_WorCMP_L, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B          #1,D1           ; Shift 1 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableCMP_BorCMP_WorCMP_L:
        JMP         CMPcode000   *CMP.B
        JMP         CMPcode001   *CMP.W
        JMP         CMPcode010   *CMP.L

CMPcode000 JSR      ISCMPB
           JSR      DONE
CMPcode001 JSR      ISCMPW
           JSR      DONE
CMPcode010 JSR      ISCMPL
           JSR      DONE

*----------- END CMP_BorCMP_WorCMP_L --------------------------


*----------- ADDQ_BorADDQ_WorADDQ_L --------------------------
ADDQ_BorADDQ_WorADDQ_L:
        LEA         tableADDQ_BorADDQ_WorADDQ_L, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #2,D1           ; Shift 2 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableADDQ_BorADDQ_WorADDQ_L:
        JMP         ADDQcode00   *ADDQ.B
        JMP         ADDQcode01   *ADDQ.W
        JMP         ADDQcode10   *ADDQ.L

ADDQcode00 JSR      ISADDQB
           JSR      DONE
ADDQcode01 JSR      ISADDQW
           JSR      DONE
ADDQcode10 JSR      ISADDQL
           JSR      DONE

*----------- END ADDQ_BorADDQ_WorADDQ_L --------------------------

*----------- someCLR --------------------------
someCLR:
        LEA         tableSomeCLR, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #8,D1           ; Shift 8 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #2,D1           ; Shift 2 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeCLR:
        JMP         CLRcode00   *CLR.B
        JMP         CLRcode01   *CLR.W
        JMP         CLRcode10   *CLR.L

CLRcode00 JSR       ISCLRB
          JSR       DONE
CLRcode01 JSR       ISCLRW
          JSR       DONE
CLRcode10 JSR       ISCLRL
          JSR       DONE

*----------- END someCLR --------------------------

*----------- NOPorCLRorRTSorJSR --------------------------
NOPorCLRorRTSorJSR:
        LEA         tableNOPorCLRorRTSorJSR, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here

        MOVE.W      #%0100111001110001,D1  ; 0100111001110001 = NOP
        CMP.W       D0, D1
        BEQ         NOPcommand

        MOVE.W      #%0100111001110101,D1  ; 0100111001110101 = RTS
        CMP.W       D0, D1
        BEQ         RTScommand

        MOVE.B      #4,D1           ; Shift 4 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)


        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

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
           JSR      DONE
NOPcommand JSR      ISNOP
           JSR      DONE
JSRorCLRcode0000 STOP #$2700
JSRorCLRcode0001 STOP #$2700
JSRorCLRcode0010 JSR someCLR
                 JSR DONE
JSRorCLRcode0011 STOP #$2700
JSRorCLRcode0100 STOP #$2700
JSRorCLRcode0101 STOP #$2700
JSRorCLRcode0110 STOP #$2700
JSRorCLRcode0111 STOP #$2700
JSRorCLRcode1000 STOP #$2700
JSRorCLRcode1001 STOP #$2700
JSRorCLRcode1010 STOP #$2700
JSRorCLRcode1011 STOP #$2700
JSRorCLRcode1100 STOP #$2700
JSRorCLRcode1101 STOP #$2700
JSRorCLRcode1110 JSR ISJSR
                 JSR DONE
JSRorCLRcode1111 STOP  #$2700

*----------- END NOPorCLRorRTSorJSR --------------------------

*----------- someMOVEM --------------------------
someMOVEM:
        LEA         tableSomeMOVEM, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #9,D1           ; Shift 9 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)
        MOVE.B      #3,D1           ; Shift 3 bits right
        ASR.W       D1,D0

        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableSomeMOVEM:
        JMP         MOVEMcode0   ;MOVEM.W
        JMP         MOVEMcode1   ;MOVEM.L

MOVEMcode0 JSR      ISMOVEMW
           JSR      DONE
MOVEMcode1 JSR      ISMOVEML
           JSR       DONE

*----------- END someMOVEM --------------------------

*----------- NOP_MOVEM_LEA_JSR_CLR_RTS --------------------------
NOP_MOVEM_LEA_JSR_CLR_RTS:
        LEA         tableNOP_MOVEM_LEA_JSR_CLR_RTS, A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits right
        ASR.W       D1,D0

        MOVE.B      #13,D1           ; Shift 13 bits left
        ASL.W       D1,D0
        MOVE.B      #shift,D1           ; Shift 12 bits to the right
        LSR.W       D1,D0               ; Move the bits (moves highest 4 bits to lowest 4 positions,
                        ; and the rest are zeroed out)


        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

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



LOTScode0000 JSR    ISMULSL
LOTScode0001 STOP   #$2700
LOTScode0010 JSR    someMOVEM
             JSR    DONE
LOTScode0011 STOP   #$2700
LOTScode0100 STOP   #$2700
LOTScode0101 STOP   #$2700
LOTScode0110 JSR    ISLEA
             JSR    DONE
LOTScode0111 STOP   #$2700
LOTScode1000 JSR    NOPorCLRorRTSorJSR
             JSR    DONE
LOTScode1001 STOP   #$2700
LOTScode1010 JSR    NOPorCLRorRTSorJSR
             JSR    DONE
LOTScode1011 STOP   #$2700
LOTScode1100 STOP   #$2700
LOTScode1101 STOP   #$2700
LOTScode1110 JSR    ISLEA
             JSR    DONE
LOTScode1111 STOP   #$2700

*----------- END NOP_MOVEM_LEA_JSR_CLR_RTS --------------------------

*----------- ADDI_BorADDI_WorADDI_L --------------------------
ADDI_BorADDI_WorADDI_L:
        LEA         tableADDI_BorADDI_WorADDI_L,A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0
        MOVE.B      #13,D1
        ASR.W       D1,D0


        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

tableADDI_BorADDI_WorADDI_L:
        JMP         ADDIBcode00
        JMP         ADDIWcode01
        JMP         ADDILcode10


ADDIBcode00 JSR     ISADDIB
            JSR     DONE
ADDIWcode01 JSR     ISADDIW
            JSR     DONE
ADDILcode10 JSR     ISADDIL
            JSR     DONE

*----------- END ADDI_BorADDI_WorADDI_L --------------------------

*----------- MOVEA_LorMOVE_L --------------------------
MOVEA_LorMOVE_L:
        LEA         tableMOVEA_LorMOVE_L,A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0            ; 0011 1010 0100 0100 to 0010 0000 0000 0000
        MOVE.B      #13,D1           ; Shift 13 bits right
        ASR.W       D1,D0             ; 0010 0000 0000 0000 to 0000 0000 0000 0001


        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

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
            JSR     DONE
MOVEAcode001 JSR    ISMOVEAL
            JSR     DONE
MOVEcode010 JSR     ISMOVEL
            JSR     DONE
MOVEcode011 JSR     ISMOVEL
            JSR     DONE
MOVEcode100 JSR     ISMOVEL
            JSR     DONE
MOVEcode101 JSR     ISMOVEL
            JSR     DONE
MOVEcode110 JSR     ISMOVEL
            JSR     DONE
MOVEcode111 JSR     ISMOVEL
            JSR     DONE
*----------- END MOVEA_LorMOVE_L --------------------------

*----------- MOVEA_WorMOVE_W --------------------------
MOVEA_WorMOVE_W:
        LEA         tableMOVEA_WorMOVE_W,A0            ; Index into the table
        CLR.L       D0                  ; Zero it
        MOVE.W      #example,D0         ; We'll play with it here
        MOVE.B      #7,D1           ; Shift 7 bits left
        ASL.W       D1,D0            ; 0011 1010 0100 0100 to 0010 0000 0000 0000
        MOVE.B      #13,D1           ; Shift 13 bits right
        ASR.W       D1,D0             ; 0010 0000 0000 0000 to 0000 0000 0000 0001


        MULU        #6,D0               ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0,D0)            ; Jump indirect with index, i.e. jump to 'table' + displacement

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
             JSR    DONE
MOVEAWcode001 JSR   ISMOVEAW
              JSR   DONE
MOVEWcode010 JSR    ISMOVEW
             JSR    DONE
MOVEWcode011 JSR    ISMOVEW
             JSR    DONE
MOVEWcode100 JSR    ISMOVEW
             JSR    DONE
MOVEWcode101 JSR    ISMOVEW
             JSR    DONE
MOVEWcode110 JSR    ISMOVEW
             JSR    DONE
MOVEWcode111 JSR    ISMOVEW
             JSR    DONE
*----------- END MOVEA_WorMOVE_W --------------------------
ISDIVU  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEDIVU, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+, A0-A7/D0-D7         ; Restore registers
        RTS

ISORB   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEORB, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISORW   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEORW, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISORL   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEORL, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISASRB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEASRB, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISASRW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEASRW, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISASRL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEASRL, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISASLB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEASLB, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISASLW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEASLW, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISASLL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEASLL, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISLSRB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGELSRB, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISLSRW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA     MESSAGELSRW, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISLSRL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGELSRL, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISLSLB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGELSLB, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISLSLW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGELSLW, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISLSLL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGELSLL, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISRORB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGERORB, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISRORW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGERORW, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISRORL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGERORL, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISROLB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEROLB, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISROLW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEROLW, A1
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISROLL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEROLL, A1
        MOVE.B      #14, D0
        TRAP        #15

        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISMULSL MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEMULSL, A1         *OPCODE is MULS.L
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISMULSW MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEMULSW, A1         *OPCODE is MULS.W
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISANDB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEANDB, A1         *OPCODE is AND.B
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISANDW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEANDW, A1         *OPCODE is AND.W
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISANDL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEANDL, A1         *OPCODE is AND.L
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISADDAW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEADDAW, A1         *OPCODE is ADDA.W
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISADDAL MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEADDAL, A1         *OPCODE is ADDA.L
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISADDB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEADDB, A1         *OPCODE is ADD.B
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISADDW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEADDW, A1         *OPCODE is ADD.W
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISADDL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEADDL, A1         *OPCODE is ADD.L
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISSUBB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGESUBB, A1         *OPCODE is SUB.B
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISSUBW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGESUBW, A1         *OPCODE is SUB.W
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISSUBL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGESUBL, A1         *OPCODE is SUB.L
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISCMPB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGECMPB, A1         *OPCODE is CMP.B
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISCMPW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGECMPW, A1         *OPCODE is CMP.W
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISCMPL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGECMPL, A1         *OPCODE is CMP.L
        MOVE.B      #14, D0
        TRAP        #15

        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISADDQB MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEADDQB, A1         *OPCODE is ADDQ.B
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISADDQW MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEADDQW, A1         *OPCODE is ADDQ.W
        MOVE.B      #14, D0
        TRAP        #15

        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISADDQL MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEADDQL, A1         *OPCODE is ADDQ.L
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISMOVEQL MOVEM.W    A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEMOVEQL, A1         *OPCODE is MOVEQ.L
        MOVE.B      #14, D0
        TRAP        #15

        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISCLRB  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGECLRB, A1         *OPCODE is CLR.B
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISCLRW  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGECLRW, A1         *OPCODE is CLR.W
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISCLRL  MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGECLRL, A1         *OPCODE is CLR.L
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISMOVEML MOVEM.W    A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEMOVEML, A1         *OPCODE is MOVEM.L
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISMOVEMW MOVEM.W    A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEMOVEMW, A1         *OPCODE is MOVEM.W
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISLEA   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGELEA, A1         *OPCODE is LEA so display LEA message
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS                          ; Exit subroutine

ISJSR   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEJSR, A1         *OPCODE is NOP so display NOP message
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS                          ; Exit subroutine

ISRTS   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGERTS, A1         *OPCODE is RTS
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISCLR   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGECLR, A1         *OPCODE is CLR
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS

ISNOP   MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGENOP, A1         *OPCODE is NOP so display NOP message
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS                          ; Exit subroutine

ISMOVEW MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEMOVEW, A1         *OPCODE is MOVE.W so display MOVEW message
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS                          ; Exit subroutine

ISMOVEAW MOVEM.W    A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEMOVEAW, A1         *OPCODE is MOVEA.W so display MOVEA.W message
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS                          ; Exit subroutine

ISMOVEL MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEMOVEL, A1         *OPCODE is MOVE.L so display MOVE.L message
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS                          ; Exit subroutine

ISMOVEAL MOVEM.W    A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEMOVEAL, A1         *OPCODE is MOVEA.L so display MOVEA.L message
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS                          ; Exit subroutine

ISMOVEB MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEMOVEB, A1         *OPCODE is MOVE.B so display MOVEB message
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS                          ; Exit subroutine

ISADDIW MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEADDIW, A1         *OPCODE is ADDI.W so display ADDI.W message
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS                          ; Exit subroutine

ISADDIL MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEADDIL, A1         *OPCODE is ADDI.L so display ADDI.L message
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS                          ; Exit subroutine

ISADDIB MOVEM.W     A0-A7/D0-D7, -(SP) ; Save registers
        LEA         MESSAGEADDIB, A1         *OPCODE is ADDI.B so display ADDI.B message
        MOVE.B      #14, D0
        TRAP        #15
        MOVEM.W     (SP)+,  A0-A7/D0-D7         ; Restore registers
        RTS                          ; Exit subroutine

*----------- Variables and Constants -----------------------


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
