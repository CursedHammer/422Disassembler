*-----------------------------------------------------------
* Title      : Testing Code
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 2 May 2016
* Description: Testing code for the inverse assembler, testing
*              various combinations of op codes and effective
*              addressing modes.
*
* VERSION: 0.2 - Initial List
*
*              Addressing Modes
*
*                Data Register Direct
*                Address Register Direct
*                Address Register Indirect
*                Immediate Data
*                Address Register Indirect with Post Increment
*                Address Register Indirect with Pre Decrement
*                Absolute Long Address
*                Absolute Word Address
*
*              Instructions
*
*                NOP
*                MOVE
*                MOVEA
*                MOVEQ
*                MOVEM
*                ADD
*                ADDA
*                ADDI
*                ADDQ
*                SUB
*                MULS
*                DIVU
*                LEA
*                CLR
*                AND
*                OR
*                LSL
*                LSR
*                ASR
*                ASL
*                ROL
*                ROR
*                CMP
*                Bcc (BCC, BGT, BLE)
*                JSR
*                RTS
*
*-----------------------------------------------------------
    ORG    $7000



START:                  ; first instruction of program

    MOVE.B      D4, D1
    NOP
    MOVEA.L     D4, A5
    MOVE.L      D4, D5
    MOVE.W      D4, D5
    MOVEA.W     D4, A5
    ADDI.B      #2, D7
    ADDI.W      #3, D7
    ADDI.L      #5, D7
    LEA         (A2), A5
    RTS
    CLR.L       D7
    CLR.B       D7
    CLR.W       D7
    MOVEQ.L     #100, D7
    JSR (A6)
    ADDQ.B      #%111, D3
    ADDQ.W      #%111, D3
    ADDQ.L      #%111, D3
    CMP.B       D3, D4
    CMP.W       D3, D4
    CMP.L       D3, D4
    SUB.B       D3, D4
    SUB.B       D4, D3
    SUB.W       D3, D4
    SUB.W       D4, D3
    SUB.L       D3, D4
    SUB.L       D4, D3
    ADD.B       D3, D4
    ADD.B       D4, D3
    ADD.W       D3, D4
    ADD.W       D4, D3
    ADD.L       D3, D4
    ADD.L       D4, D3
    ADDA.W      D3, A4
    ADDA.L      D3, A4
    AND.B       D3, D4
    AND.B       D4, D3
    AND.W       D3, D4
    AND.W       D4, D3
    AND.L       D3, D4
    AND.L       D4, D3
    MULS.W      D3, D4
    MOVEM.L     A0-A1/A3-A5/D0-D7, -(A7)
    MOVEM.L     (A7)+, A0-A1/A3-A5/D0-D7
    ROL.B       D1,D2
    ROL.W       D1,D2
    ROL.L       D1,D2
    ROR.B       D1,D2
    ROR.W       D1,D2
    ROR.L       D1,D2
    LSL.B       D1,D2
    LSL.W       D1,D2
    LSL.L       D1,D2
    LSR.B       D1,D2
    LSR.W       D1,D2
    LSR.L       D1,D2
    ASL.B       D1,D2
    ASL.W       D1,D2
    ASL.L       D1,D2
    ASR.B       D1,D2
    ASR.W       D1,D2
    ASR.L       D1,D2
    DIVU.W      D3,D4
    OR.B        D3,D4
    OR.B        D3,D4
    OR.W        D3,D4
    OR.W        D3,D4
    OR.L        D3,D4
    OR.L        D3,D4
    BCC         $0001234
    BGT         $0001234
    BCC         $0004321
    SIMHALT             ; halt simulator
    * Put variables and constants here
    END    START        ; last line of source

*-----------------------------------------------------------
*--- Testing with all ea combinations started below --------
*-----------------------------------------------------------

;*Addressing Modes
;*
;*  Data Register Direct
;*  Address Register Direct
;*  Address Register Indirect
;*  Address Register Indirect with Post Increment
;*  Address Register Indirect with Pre Decremet
;*  Immediate Data
;*  Absolute Long Address
;*  Absolute Word Address
;
;*-------Instructions----------------------------------------
;*--NOP------------------------------------------------------
;NOP     NOP
;*--MOVE-----------------------------------------------------
;MOVEB   MOVE.B      D0, D1
;        MOVE.B      D0, (A0)
;        MOVE.B      D0, (A0)+
;        MOVE.B      D0, -(A0)
;        MOVE.B      D0, $2000
;        MOVE.B      D0, $FFFC2000
;        MOVE.B      A0, D1
;        MOVE.B      A0, (A0)
;        MOVE.B      A0, (A0)+
;        MOVE.B      A0, -(A0)
;        MOVE.B      A0, $2000
;        MOVE.B      A0, $FFFC2000
;        MOVE.B      (A0), D1
;        MOVE.B      (A0), (A0)
;        MOVE.B      (A0), (A0)+
;        MOVE.B      (A0), -(A0)
;        MOVE.B      (A0), $2000
;        MOVE.B      (A0), $FFFC2000
;        MOVE.B      (A0)+, D1
;        MOVE.B      (A0)+, (A0)
;        MOVE.B      (A0)+, (A0)+
;        MOVE.B      (A0)+, -(A0)
;        MOVE.B      (A0)+, $2000
;        MOVE.B      (A0)+, $FFFC2000
;        MOVE.B      -(A0), D1
;        MOVE.B      -(A0), (A0)
;        MOVE.B      -(A0), (A0)+
;        MOVE.B      -(A0), -(A0)
;        MOVE.B      -(A0), $2000
;        MOVE.B      -(A0), $FFFC2000
;        MOVE.B      #$AB, D1
;        MOVE.B      #$AB, (A0)
;        MOVE.B      #$AB, (A0)+
;        MOVE.B      #$AB, -(A0)
;        MOVE.B      #$AB, $2000
;        MOVE.B      #$AB, $FFFC2000
;        MOVE.B      $2000, D1
;        MOVE.B      $2000, (A0)
;        MOVE.B      $2000, (A0)+
;        MOVE.B      $2000, -(A0)
;        MOVE.B      $2000, $2000
;        MOVE.B      $2000, $FFFC2000
;        MOVE.B      $FFFC2000, D1
;        MOVE.B      $FFFC2000, (A0)
;        MOVE.B      $FFFC2000, (A0)+
;        MOVE.B      $FFFC2000, -(A0)
;        MOVE.B      $FFFC2000, $2000
;        MOVE.B      $FFFC2000, $FFFC2000
;MOVEW   MOVE.W      D0, D1
;        MOVE.W      D0, (A0)
;        MOVE.W      D0, (A0)+
;        MOVE.W      D0, -(A0)
;        MOVE.W      D0, $2000
;        MOVE.W      D0, $FFFC2000
;        MOVE.W      A0, D1
;        MOVE.W      A0, (A0)
;        MOVE.W      A0, (A0)+
;        MOVE.W      A0, -(A0)
;        MOVE.W      A0, $2000
;        MOVE.W      A0, $FFFC2000
;        MOVE.W      (A0), D1
;        MOVE.W      (A0), (A0)
;        MOVE.W      (A0), (A0)+
;        MOVE.W      (A0), -(A0)
;        MOVE.W      (A0), $2000
;        MOVE.W      (A0), $FFFC2000
;        MOVE.W      (A0)+, D1
;        MOVE.W      (A0)+, (A0)
;        MOVE.W      (A0)+, (A0)+
;        MOVE.W      (A0)+, -(A0)
;        MOVE.W      (A0)+, $2000
;        MOVE.W      (A0)+, $FFFC2000
;        MOVE.W      -(A0), D1
;        MOVE.W      -(A0), (A0)
;        MOVE.W      -(A0), (A0)+
;        MOVE.W      -(A0), -(A0)
;        MOVE.W      -(A0), $2000
;        MOVE.W      -(A0), $FFFC2000
;        MOVE.W      #$ABCD, D1
;        MOVE.W      #$ABCD, (A0)
;        MOVE.W      #$ABCD, (A0)+
;        MOVE.W      #$ABCD, -(A0)
;        MOVE.W      #$ABCD, $2000
;        MOVE.W      #$ABCD, $FFFC2000
;        MOVE.W      $2000, D1
;        MOVE.W      $2000, (A0)
;        MOVE.W      $2000, (A0)+
;        MOVE.W      $2000, -(A0)
;        MOVE.W      $2000, $2000
;        MOVE.W      $2000, $FFFC2000
;        MOVE.W      $FFFC2000, D1
;        MOVE.W      $FFFC2000, (A0)
;        MOVE.W      $FFFC2000, (A0)+
;        MOVE.W      $FFFC2000, -(A0)
;        MOVE.W      $FFFC2000, $2000
;        MOVE.W      $FFFC2000, $FFFC2000
;MOVEL   MOVE.L      D0, D1
;        MOVE.L      D0, (A0)
;        MOVE.L      D0, (A0)+
;        MOVE.L      D0, -(A0)
;        MOVE.L      D0, $2000
;        MOVE.L      D0, $FFFC2000
;        MOVE.L      A0, D1
;        MOVE.L      A0, (A0)
;        MOVE.L      A0, (A0)+
;        MOVE.L      A0, -(A0)
;        MOVE.L      A0, $2000
;        MOVE.L      A0, $FFFC2000
;        MOVE.L      (A0), D1
;        MOVE.L      (A0), (A0)
;        MOVE.L      (A0), (A0)+
;        MOVE.L      (A0), -(A0)
;        MOVE.L      (A0), $2000
;        MOVE.L      (A0), $FFFC2000
;        MOVE.L      (A0)+, D1
;        MOVE.L      (A0)+, (A0)
;        MOVE.L      (A0)+, (A0)+
;        MOVE.L      (A0)+, -(A0)
;        MOVE.L      (A0)+, $2000
;        MOVE.L      (A0)+, $FFFC2000
;        MOVE.L      -(A0), D1
;        MOVE.L      -(A0), (A0)
;        MOVE.L      -(A0), (A0)+
;        MOVE.L      -(A0), -(A0)
;        MOVE.L      -(A0), $2000
;        MOVE.L      -(A0), $FFFC2000
;        MOVE.L      #$ABCD1234, D1
;        MOVE.L      #$ABCD1234, (A0)
;        MOVE.L      #$ABCD1234, (A0)+
;        MOVE.L      #$ABCD1234, -(A0)
;        MOVE.L      #$ABCD1234, $2000
;        MOVE.L      #$ABCD1234, $FFFC2000
;        MOVE.L      $2000, D1
;        MOVE.L      $2000, (A0)
;        MOVE.L      $2000, (A0)+
;        MOVE.L      $2000, -(A0)
;        MOVE.L      $2000, $2000
;        MOVE.L      $2000, $FFFC2000
;        MOVE.L      $FFFC2000, D1
;        MOVE.L      $FFFC2000, (A0)
;        MOVE.L      $FFFC2000, (A0)+
;        MOVE.L      $FFFC2000, -(A0)
;        MOVE.L      $FFFC2000, $2000
;        MOVE.L      $FFFC2000, $FFFC2000
;*--MOVEA----------------------------------------------------
;MOVEAB  MOVEA.B     D0, A0
;        MOVEA.B     A1, A0
;        MOVEA.B     (A1), A0
;        MOVEA.B     (A1)+, A0
;        MOVEA.B     -(A1), A0
;        MOVEA.B     #$AB, A0
;        MOVEA.B     $2000, A0
;        MOVEA.B     $FFFC2000, A0
;MOVEAW  MOVEA.W     D0, A0
;        MOVEA.W     A1, A0
;        MOVEA.W     (A1), A0
;        MOVEA.W     (A1)+, A0
;        MOVEA.W     -(A1), A0
;        MOVEA.W     #$ABCD, A0
;        MOVEA.W     $2000, A0
;        MOVEA.W     $FFFC2000, A0
;MOVEAL  MOVEA.L     D0, A0
;        MOVEA.L     A1, A0
;        MOVEA.L     (A1), A0
;        MOVEA.L     (A1)+, A0
;        MOVEA.L     -(A1), A0
;        MOVEA.L     #$ABCD1234, A0
;        MOVEA.L     $2000, A0
;        MOVEA.L     $FFFC2000, A0
;*--MOVEQ----------------------------------------------------
;MOVEQ   MOVEQ       #-3, D0
;*--MOVEM----------------------------------------------------
;TESTSTACK EQU       $7000           ; printed out as errors in output
;        LEA         TESTSTACK, SP   ; SP is stored in A7
;MOVEMW  MOVEM.W     A0-A6/D0-D7, (SP)
;        MOVEM.W     A0-A6/D0-D7, -(SP)
;        MOVEM.W     A1-A5/D3        ; test different registers...add more here?
;        MOVEM.W     A0-A6/D0-D7, $2000
;        MOVEM.W     A0-A6/D0-D7, $FFFC2000
;        MOVEM.W     (SP) , A0-A6/D0-D7
;        MOVEM.W     (SP)+, A0-A6/D0-D7
;        MOVEM.W     $2000, A0-A6/D0-D7
;        MOVEM.W     $FFFC2000, A0-A6/D0-D7
;MOVEML  MOVEM.L     A0-A6/D0-D7, (SP)
;        MOVEM.L     A0-A6/D0-D7, -(SP)
;        MOVEM.L     A1-A5/D3        ; test different registers...add more here?
;        MOVEM.L     A0-A6/D0-D7, $2000
;        MOVEM.L     A0-A6/D0-D7, $FFFC2000
;        MOVEM.L     (SP) , A0-A6/D0-D7
;        MOVEM.L     (SP)+, A0-A6/D0-D7
;        MOVEM.L     $2000, A0-A6/D0-D7
;        MOVEM.L     $FFFC2000, A0-A6/D0-D7
;*--ADD------------------------------------------------------
;*   ADDA
;*   ADDI
;*   ADDQ
;*   SUB
;*   MULS
;*   DIVU
;*   LEA
;*   CLR
;*   AND
;*   OR
;*   LSL
;*   LSR
;*   ASR
;*   ASL
;*   ROL
;*   ROR
;*   CMP
;*   Bcc (BCC, BGT, BLE)
;*   JSR
;*   RTS
;
;    SIMHALT             ; halt simulator
;
;* Put variables and constants here
;
;    END    START        ; last line of source










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
