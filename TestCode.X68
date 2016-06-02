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

MOVE.B D4, D1 ; = 0001 1010 0000 0100
NOP ;   = 0100 1110 0111 0001
MOVEA.L D4, A5 ;  = 0010 1010 0100 0100
MOVE.L D4, D5 ;  = 0010 1010 0000 0100
MOVE.W  D4, D5 ;  = 0011 1010 0000 0100
*  MOVEA.W D4, D5 ;  = 0011 1010 0100 0100
*  ADDI.B D5, D7 ;  = 0000 0110 0000 0101
*  ADDI.W D5, D7 ;  = 0000 0110 0100 0101
*  ADDI.L D5, D7 ;  = 0000 0110 1000 0101
*  LEA D5, (A5) ;  = 0100 1001 1101 0101
RTS ;   = 0100 1110 0111 0101
CLR.L D7 ;  = 0100 0010 1000 0111
CLR.B D7 ;  = 0100 0010 0000 0111
CLR.W D7 ;  = 0100 0010 0100 0111

*example EQU     %0100001011000111 ; INVALID = 0100 0010 1100 0111

*  MOVEQ.L #%11111111, D7 = 0111 1110 1111 1111
JSR (A6) ;   = 0100 1110 1001 0110
*   ADDQ.B    #%111, D3 = 0101 1110 0000 0011
*  ADDQ.W    #%111, D3 = 0101 1110 0100 0011
*  ADDQ.L    #%111, D3 = 0101 1110 1000 0011
CMP.B D3, D4 ;  = 1011 100 000 000 011
CMP.W D3, D4 ;  = 1011 100 001 000 011
CMP.L D3, D4 ;  = 1011 100 010 000 011

*example EQU     %1011100011000011 ;         INVALID 1011 100 011 000 011

SUB.B D3, D4 ;  = 1001 100 100 000 011
SUB.B D4, D3 ;  = 1001 011 000 000 100

SUB.W D3, D4 ;  = 1001 100 101 000 011
SUB.W D4, D3 ;  = 1001 011 001 000 100

SUB.L D3, D4 ;  = 1001 100 110 000 011
SUB.L D4, D3 ;  = 1001 011 010 000 100

ADD.B D3, D4 ;  = 1101 100 100 000 011
ADD.B D4, D3 ;  = 1101 011 000 000 100

ADD.W D3, D4 ;  = 1101 100 101 000 011
ADD.W D4, D3 ;  = 1101 011 001 000 100

ADD.L D3, D4 ;  = 1101 100 110 000 011
ADD.L D4, D3 ;  = 1101 011 010 000 100

ADDA.W D3, A4 ;  = 1101 100 011 000 011
ADDA.L D3, A4 ;  = 1101 100 111 000 011

AND.B D3, D4 ;  = 1100 100 000 000 011
AND.B D4, D3 ;  = 1100 011 100 000 100

AND.W D3, D4 ;  = 1100 100 001 000 011
AND.W D4, D3 ;  = 1100 011 101 000 100

AND.L D3, D4 ;  = 1100 100 010 000 011
AND.L D4, D3 ;  = 1100 011 110 000 100

MULS.W D3, D4 ;  = 1100 100 111 000 011

*   MULS.L D3, D4 ;  = 01001 1 0000 000 011

*   MOVEM.W (A4), (D16A6) = 0100 1000 10 010 100
*   MOVEM.W (D16A6), (A4) = 0100 1100 10 101 110

*   MOVEM.L (A4), (D16A6) = 0100 1000 11 010 100
*   MOVEM.L (D16A6), (A4) = 0100 1100 11 101 110

ROL.B  D1,D2 ;  = 1110 111 1 00 0 11 010 where D1 = 0x111 or 7
ROL.W  D1,D2 ;  = 1110 111 1 01 0 11 010 where D1 = 0x111 or 7
ROL.L  D1,D2 ;  = 1110 111 1 10 0 11 010 where D1 = 0x111 or 7

ROR.B  D1,D2 ;  = 1110 111 0 00 0 11 010 where D1 = 0x111 or 7
ROR.W  D1,D2 ;  = 1110 111 0 01 0 11 010 where D1 = 0x111 or 7
ROR.L  D1,D2 ;  = 1110 111 0 10 0 11 010 where D1 = 0x111 or 7

LSL.B  D1,D2 ;  = 1110 111 1 00 0 01 010 where D1 = 0x111 or 7
LSL.W  D1,D2 ;  = 1110 111 1 01 0 01 010 where D1 = 0x111 or 7
LSL.L  D1,D2 ;  = 1110 111 1 10 0 01 010 where D1 = 0x111 or 7

LSR.B  D1,D2 ;  = 1110 111 0 00 0 01 010 where D1 = 0x111 or 7
LSR.W  D1,D2 ;  = 1110 111 0 01 0 01 010 where D1 = 0x111 or 7
LSR.L  D1,D2 = 1110 111 0 10 0 01 010 where D1 = 0x111 or 7

ASL.B  D1,D2 ;  = 1110 111 1 00 0 00 010 where D1 = 0x111 or 7
ASL.W  D1,D2 ;  = 1110 111 1 01 0 00 010 where D1 = 0x111 or 7
ASL.L  D1,D2 ;  = 1110 111 1 10 0 00 010 where D1 = 0x111 or 7

ASR.B  D1,D2 ;  = 1110 111 0 00 0 00 010 where D1 = 0x111 or 7
ASR.W  D1,D2 ;  = 1110 111 0 01 0 00 010 where D1 = 0x111 or 7
ASR.L  D1,D2 ;  = 1110 111 0 10 0 00 010 where D1 = 0x111 or 7

DIVU.W D3,D4 ;  = 1000 100 011 000 011
*   DIVU.L D3,D4 ;  = 0100 110001 000 011

OR.B D3,D4 ;  = 1000 100 000 000 011
OR.B D3,D4 ;  = 1000 100 100 000 011
OR.W D3,D4 ;  = 1000 100 001 000 011
OR.W D3,D4 ;  = 1000 100 101 000 011
OR.L D3,D4 ;  = 1000 100 010 000 011
OR.L D3,D4 ;  = 1000 100 110 000 011

*example EQU     %0110010000000000 ; BCC = 0110 0100 0000 0000
*example EQU     %0110111000000000 ; BGT = 0110 1110 0000 0000
*example EQU     %0110111100000000  ; BLE = 0110 1111 0000 0000

*example EQU     %1010111100000000  ; INVALID

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
