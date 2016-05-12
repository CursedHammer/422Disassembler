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
*                Address Register Indirect with Pre Decremet
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
START:  ORG    $1000                ; first instruction of program

*Addressing Modes
*
*  Data Register Direct
*  Address Register Direct
*  Address Register Indirect
*  Address Register Indirect with Post Increment
*  Address Register Indirect with Pre Decremet
*  Immediate Data
*  Absolute Long Address
*  Absolute Word Address
*
*Instructions

*--NOP------------------------------------------------------
NOP     NOP
*--MOVE-----------------------------------------------------
MOVEB   MOVE.B      D0, D1
        MOVE.B      D0, (A0)
        MOVE.B      D0, (A0)+
        MOVE.B      D0, -(A0)
        MOVE.B      D0, $2000
        MOVE.B      D0, $FFFC2000
        MOVE.B      A0, D1
        MOVE.B      A0, (A0)
        MOVE.B      A0, (A0)+
        MOVE.B      A0, -(A0)
        MOVE.B      A0, $2000
        MOVE.B      A0, $FFFC2000
        MOVE.B      (A0), D1
        MOVE.B      (A0), (A0)
        MOVE.B      (A0), (A0)+
        MOVE.B      (A0), -(A0)
        MOVE.B      (A0), $2000
        MOVE.B      (A0), $FFFC2000
        MOVE.B      (A0)+, D1
        MOVE.B      (A0)+, (A0)
        MOVE.B      (A0)+, (A0)+
        MOVE.B      (A0)+, -(A0)
        MOVE.B      (A0)+, $2000
        MOVE.B      (A0)+, $FFFC2000
        MOVE.B      -(A0), D1
        MOVE.B      -(A0), (A0)
        MOVE.B      -(A0), (A0)+
        MOVE.B      -(A0), -(A0)
        MOVE.B      -(A0), $2000
        MOVE.B      -(A0), $FFFC2000
        MOVE.B      #$AB, D1
        MOVE.B      #$AB, (A0)
        MOVE.B      #$AB, (A0)+
        MOVE.B      #$AB, -(A0)
        MOVE.B      #$AB, $2000
        MOVE.B      #$AB, $FFFC2000
        MOVE.B      $2000, D1
        MOVE.B      $2000, (A0)
        MOVE.B      $2000, (A0)+
        MOVE.B      $2000, -(A0)
        MOVE.B      $2000, $2000
        MOVE.B      $2000, $FFFC2000
        MOVE.B      $FFFC2000, D1
        MOVE.B      $FFFC2000, (A0)
        MOVE.B      $FFFC2000, (A0)+
        MOVE.B      $FFFC2000, -(A0)
        MOVE.B      $FFFC2000, $2000
        MOVE.B      $FFFC2000, $FFFC2000
MOVEW   MOVE.W      D0, D1
        MOVE.W      D0, (A0)
        MOVE.W      D0, (A0)+
        MOVE.W      D0, -(A0)
        MOVE.W      D0, $2000
        MOVE.W      D0, $FFFC2000
        MOVE.W      A0, D1
        MOVE.W      A0, (A0)
        MOVE.W      A0, (A0)+
        MOVE.W      A0, -(A0)
        MOVE.W      A0, $2000
        MOVE.W      A0, $FFFC2000
        MOVE.W      (A0), D1
        MOVE.W      (A0), (A0)
        MOVE.W      (A0), (A0)+
        MOVE.W      (A0), -(A0)
        MOVE.W      (A0), $2000
        MOVE.W      (A0), $FFFC2000
        MOVE.W      (A0)+, D1
        MOVE.W      (A0)+, (A0)
        MOVE.W      (A0)+, (A0)+
        MOVE.W      (A0)+, -(A0)
        MOVE.W      (A0)+, $2000
        MOVE.W      (A0)+, $FFFC2000
        MOVE.W      -(A0), D1
        MOVE.W      -(A0), (A0)
        MOVE.W      -(A0), (A0)+
        MOVE.W      -(A0), -(A0)
        MOVE.W      -(A0), $2000
        MOVE.W      -(A0), $FFFC2000
        MOVE.W      #$ABCD, D1
        MOVE.W      #$ABCD, (A0)
        MOVE.W      #$ABCD, (A0)+
        MOVE.W      #$ABCD, -(A0)
        MOVE.W      #$ABCD, $2000
        MOVE.W      #$ABCD, $FFFC2000
        MOVE.W      $2000, D1
        MOVE.W      $2000, (A0)
        MOVE.W      $2000, (A0)+
        MOVE.W      $2000, -(A0)
        MOVE.W      $2000, $2000
        MOVE.W      $2000, $FFFC2000
        MOVE.W      $FFFC2000, D1
        MOVE.W      $FFFC2000, (A0)
        MOVE.W      $FFFC2000, (A0)+
        MOVE.W      $FFFC2000, -(A0)
        MOVE.W      $FFFC2000, $2000
        MOVE.W      $FFFC2000, $FFFC2000
MOVEL   MOVE.L      D0, D1
        MOVE.L      D0, (A0)
        MOVE.L      D0, (A0)+
        MOVE.L      D0, -(A0)
        MOVE.L      D0, $2000
        MOVE.L      D0, $FFFC2000
        MOVE.L      A0, D1
        MOVE.L      A0, (A0)
        MOVE.L      A0, (A0)+
        MOVE.L      A0, -(A0)
        MOVE.L      A0, $2000
        MOVE.L      A0, $FFFC2000
        MOVE.L      (A0), D1
        MOVE.L      (A0), (A0)
        MOVE.L      (A0), (A0)+
        MOVE.L      (A0), -(A0)
        MOVE.L      (A0), $2000
        MOVE.L      (A0), $FFFC2000
        MOVE.L      (A0)+, D1
        MOVE.L      (A0)+, (A0)
        MOVE.L      (A0)+, (A0)+
        MOVE.L      (A0)+, -(A0)
        MOVE.L      (A0)+, $2000
        MOVE.L      (A0)+, $FFFC2000
        MOVE.L      -(A0), D1
        MOVE.L      -(A0), (A0)
        MOVE.L      -(A0), (A0)+
        MOVE.L      -(A0), -(A0)
        MOVE.L      -(A0), $2000
        MOVE.L      -(A0), $FFFC2000
        MOVE.L      #$ABCD1234, D1
        MOVE.L      #$ABCD1234, (A0)
        MOVE.L      #$ABCD1234, (A0)+
        MOVE.L      #$ABCD1234, -(A0)
        MOVE.L      #$ABCD1234, $2000
        MOVE.L      #$ABCD1234, $FFFC2000
        MOVE.L      $2000, D1
        MOVE.L      $2000, (A0)
        MOVE.L      $2000, (A0)+
        MOVE.L      $2000, -(A0)
        MOVE.L      $2000, $2000
        MOVE.L      $2000, $FFFC2000
        MOVE.L      $FFFC2000, D1
        MOVE.L      $FFFC2000, (A0)
        MOVE.L      $FFFC2000, (A0)+
        MOVE.L      $FFFC2000, -(A0)
        MOVE.L      $FFFC2000, $2000
        MOVE.L      $FFFC2000, $FFFC2000

*   MOVEA
*   MOVEQ
*   MOVEM
*   ADD
*   ADDA
*   ADDI
*   ADDQ
*   SUB
*   MULS
*   DIVU
*   LEA
*   CLR
*   AND
*   OR
*   LSL
*   LSR
*   ASR
*   ASL
*   ROL
*   ROR
*   CMP
*   Bcc (BCC, BGT, BLE)
*   JSR
*   RTS 

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
