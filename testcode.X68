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
*  Immediate Data
*  Address Register Indirect with Post Increment
*  Address Register Indirect with Pre Decremet
*  Absolute Long Address
*  Absolute Word Address
*
*Instructions
*
*   NOP
*   MOVE
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
