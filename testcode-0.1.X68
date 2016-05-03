*-----------------------------------------------------------
* Title      : Testing Code
* Written by : Marijn Burger, Jack Eldridge, Brandon Authier
* Date       : 2 May 2016
* Description: Testing code for the inverse assembler, testing
*              various combinations of op codes and effective
*              addressing modes.
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
*                MOVEQ
*                MOVEM
*                ADD
*                ADDA
*                ADDI
*                SUB
*                MULS
*                DIVU
*                LEA
*                CLR
*                AND
*                LSL
*                ASR
*                ROL
*                CMP
*                Bcc (BCC, BGT, BLE)
*                JSR
*                RTS
*
* VERSION: 0.1 - Initial Skeleton
*-----------------------------------------------------------
    ORG    $1000
START:                  ; first instruction of program

* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
