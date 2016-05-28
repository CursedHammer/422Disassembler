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
        *commented code is based on sandbox io file
*        JSR         IO_GET_FIRST_ADDRESS ; Get starting address
*        JSR         IO_GET_SECOND_ADDRESS ; Get ending address
*        MOVE.L      BEGINADDR, A5   ; Move start address to A5 for easier manipulation (location tbd)
*        MOVE.L      ENDADDR, A6     ; Move end address to A6 for easier manipulation (location tbd)
        MOVE.L      STARTADDR, A5   ; Move start address to A5 for easier manipulation (location tbd)
        MOVE.L      ENDADDR, A6     ; Move end address to A6 for easier manipulation (location tbd)
LOOP    MOVE.L      #TRUE, D0       ; Reset boolean flag register, signals validity of current word (boolean flag location tbd)
        JSR         OC_PARSE        ; Determine if there is an initial opcode match
        CMPI.B      #TRUE, D0       ; Check if the opcode is valid
        BNE         IS_ERROR        ; If word has been designated invalid, report error
        JSR         IO_ADD_INSTRUCTION ; If the word is valid, add to display buffer (subroutine name tbd)
LOOP_CHECK CMPA     A5, A6          ; Check if pointer is at end of address range
        BLT         OUT_OF_RANGE_ERROR ; For debugging, if pointer advances too far
        BNE         LOOP            ; If not at end address, restart loop
        JSR         IO_DISPLAY      ; If at end of address, display information
        STOP        #$3000          ; End program
*       JMP         START           ; Restart program (optional workflow)
        
IS_ERROR JSR        IO_ADD_DATA_ERROR ; will be changed to reflect actual subroutine name
        JMP         LOOP_CHECK      ; restart loop
        
OUT_OF_RANGE_ERROR JSR IO_OUT_OF_RANGE_ERROR ; for debugging
        STOP        #$3000          ; End program

*---------- Subroutine Files -------------------------------

        INCLUDE 'IO.X68'
        INCLUDE 'OpCodes.X68'
        INCLUDE 'EA.X68'     

*---------- Variables and Constants ------------------------

STARTADDR DS.L  80                  ; Var for starting address
ENDADDR   DS.L  80                  ; Var for ending address

*---------- Reserved Registers -----------------------------
*   A7: stack pointer
*   A6: end address (stays constant)
*   A5: current address (updated by subroutines)
*   D0: instruction validity flag (reset by main control
*       code, can be set to false by subroutines)
*-----------------------------------------------------------

*---------- End --------------------------------------------
        END        START            ; last line of source
*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
