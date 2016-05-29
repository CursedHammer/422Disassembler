*-----------------------------------------------------------
* Title      : 68k Disassembler
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 16 May 2016
* Description: An inverse assembler that will convert a memory
*              image of instructions and data back to the display.
*              The following will be decoded:
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

STACK   EQU         $7000           ; Largest location in memory...will need to
                                    ; change this based on memory range for code to read
TRUE    EQU         $01             ; value equivalent to 'true'

START   ORG         $1000
        LEA         STACK, SP       ; SP is stored in A7
        JSR         IO_WELCOME      ; Run welcome subroutine
        ; get addresses and do address validation
        MOVE.L      BEGINADDR, A6   ; Move start address to A6 for easier manipulation
LOOP    JSR         OC_PARSE        ; Determine if there is an initial opcode match
        ; decrement row count
        ; if at 0, prompt for next page
        ; else, continue
LOOP_CHECK CMPA     A6, ENDADDR      ; Check if pointer is at end of address range
        BLT         END_LOOP ; For debugging, if pointer advances too far
        ; in case this resets status register, do another compare TODO
        BNE         LOOP            ; If not at end address, restart loop
        ; If at end of address range, check if user wants to continue
        ; if user wants to continue, restart
        ; else, end

        STOP        #$3000          ; End program
*       JMP         START           ; Restart program (optional workflow)


*---------- Subroutine Files -------------------------------

        INCLUDE 'IO.X68'
        INCLUDE 'OpCodes.X68'
        INCLUDE 'EA.X68'

*---------- Variables and Constants ------------------------


*---------- Reserved Registers -----------------------------
*   A7: stack pointer
*   A6: current address (updated by subroutines)
*   D0: instruction validity flag (reset by main control
*       code, can be set to false by subroutines)
*-----------------------------------------------------------

*---------- End --------------------------------------------
        END        START            ; last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
