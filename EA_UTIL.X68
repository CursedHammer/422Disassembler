*-----------------------------------------------------------
* Title      : Effective Addressing Subroutines
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 1 June 2016
* Description: Support file containing the utility
*              subroutines for the effective addressing
*              subroutines for the disassembler.
*-----------------------------------------------------------

*-----------------------------------------------------------
*-- Generic Subroutines ------------------------------------
*-----------------------------------------------------------

*---------- Unimplemented EA -------------------------------
* Prints error message for EA subroutines that have not been
* implemented yet
*-----------------------------------------------------------
EA_UNIMPLEMENTED:
    ADDA.L      #$00000002, A6      ; Increment past current opcode word
    LEA         EA_MSG_UNIMP, A4
    JSR         WRITE2MEM
    RTS

*---------- Invalid OpCode ---------------------------------
* Prints error message for current opcode in memory
*-----------------------------------------------------------
EA_INVALID:
    MOVEA.L     A6, A5              ; Copy global pointer
    ADDA.L      #$00000002, A5      ; Increment past current opcode word
    JSR         INVALID_DATA        ; Print data error message
    RTS

*---------- Data Print Unimplemented -----------------------
* Message replacing printing data, for testing
*-----------------------------------------------------------
EA_PRINT_DATA:
    LEA         EA_MSG_PRINT_DATA, A4
    JSR         WRITE2MEM
    RTS


*---------- Update Global Pointer --------------------------
* Updates global pointer based on address stored in A5
*-----------------------------------------------------------
EA_UPDATE_POINTER:
    CMP.L       A5, A6              ; Check if A5==A6
    BNE         UPDATE_PTR          ; If NOT equal (a.k.a if any extra operands
                                    ; were read, and is already up to date),
                                    ; update global with current
    ADDA.L      #$00000002, A5      ; Else, increment past current opcode word, then update
UPDATE_PTR:
    MOVEA.L     A5, A6              ; Update global pointer
    RTS

*---------- Copy Global Pointer ----------------------------
* Stores current global pointer in A5. Called at the
* beginning of every main subroutine
*-----------------------------------------------------------
EA_COPY_PTR:
    MOVEA.L     A6, A5              ; Save global pointer
    RTS

*---------- Parse Default Combo ----------------------------
* Parses and separates values in the default mode/register
* data combo found at the end of many opcode words.
* POST: mode bits in D6, register bits in D7
*-----------------------------------------------------------
EA_DEFAULT_COMBO:
    CLR.L       D6                  ; Clear space for mode bits
    CLR.L       D7                  ; Clear space for register bits
* Get Mode
    MOVE.W      (A6), D1            ; Load opcode to data register 1
    MOVE.B      #10, D2             ; Clear upper 10 bits of opcode word
    LSL.W       D2, D1              ; Perform shift (zeros shifted in)
    MOVE.B      #13, D2             ; 'Right-align' bits 3-5 to determine mode bits
    LSR.W       D2, D1              ; Perform shift (zeros shifted in)
    MOVE.B      D1, D6              ; Save mode bits to D6
* Get Register
    MOVE.L      (A6), D1            ; Reload opcode to data register 1
    MOVE.B      #13, D2             ; Clear upper 13 bits of opcode word
    LSL.W       D2, D1              ; Perform shift (zeros shifted in)
    MOVE.B      #13, D2             ; 'Right-align' bits 0-2 to determine register bits
    LSR.W       D2, D1              ; Perform shift (zeros shifted in)
    MOVE.B      D1, D7              ; Save register bits to D7
    RTS                             ; Return from subroutine

*---------- Parse Opmode Combo ----------------------------
* Parses and separates values in the opmode/register
* data combo found in bits 6-11 in many opcode words.
* POST: opmode bits in D6, register bits in D7
*-----------------------------------------------------------
EA_OPMODE_COMBO:
    CLR.L       D6                  ; Clear space for mode bits
    CLR.L       D7                  ; Clear space for register bits
* Get Opmode
    MOVE.W      (A6), D1            ; Load opcode to data register 1
    MOVE.B      #7, D2              ; Clear upper 7 bits of opcode word
    LSL.W       D2, D1              ; Perform shift (zeros shifted in)
    MOVE.B      #13, D2             ; 'Right-align' bits 6-8 to determine opmode bits
    LSR.W       D2, D1              ; Perform shift (zeros shifted in)
    MOVE.B      D1, D6              ; Save opmode bits to D6
* Get Register
    MOVE.L      (A6), D1            ; Reload opcode to data register 1
    MOVE.B      #4, D2              ; Clear upper 4 bits of opcode word
    LSL.W       D2, D1              ; Perform shift (zeros shifted in)
    MOVE.B      #13, D2             ; 'Right-align' bits 9-11 to determine register bits
    LSR.W       D2, D1              ; Perform shift (zeros shifted in)
    MOVE.B      D1, D7              ; Save register bits to D7
    RTS                             ; Return from subroutine

*---------- Parse Size bits --------------------------------
* Stores the size bits 6-7 of opcode word in D7
*-----------------------------------------------------------
EA_SIZE_BITS:
    CLR.L       D7
    MOVE.W      (A6), D7            ; Load opcode to data register 1
    MOVE.B      #8, D2              ; Clear upper 8 bits of opcode word
    LSL.W       D2, D7              ; Perform shift (zeros shifted in)
    MOVE.B      #14, D2             ; 'Right-align' bits 6-7 to determine size bits
    LSR.W       D2, D7              ; Perform shift (zeros shifted in)
    RTS

*-----------------------------------------------------------
*-- Read & Print Subroutines -------------------------------
*-----------------------------------------------------------

*---------- Data Register Direct ---------------------------
* Prints the data register direct operand based on register
* value in D7
*-----------------------------------------------------------
EA_PRINT_DN:
    LEA         EA_PRINT_DN_JMP, A0 ; Set index '0' for jump table
    MULU        #6, D7              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D7)           ; Jump indirect with index, i.e. jump to 'table' + displacement
EA_PRINT_DN_JMP:
    JMP         DN_000 ; D0
    JMP         DN_001 ; D1
    JMP         DN_010 ; D2
    JMP         DN_011 ; D3
    JMP         DN_100 ; D4
    JMP         DN_101 ; D5
    JMP         DN_110 ; D6
    JMP         DN_111 ; D7
DN_000: ; D0
    LEA         EA_MSG_D0, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_DN_END
DN_001: ; D1
    LEA         EA_MSG_D1, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_DN_END
DN_010: ; D2
    LEA         EA_MSG_D2, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_DN_END
DN_011: ; D3
    LEA         EA_MSG_D3, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_DN_END
DN_100: ; D4
    LEA         EA_MSG_D4, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_DN_END
DN_101: ; D5
    LEA         EA_MSG_D5, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_DN_END
DN_110: ; D6
    LEA         EA_MSG_D6, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_DN_END
DN_111: ; D7
    LEA         EA_MSG_D7, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_DN_END

EA_PRINT_DN_END:
    RTS

*---------- Address Register Direct ------------------------
* Prints the address register direct operand based on
* register value in D7
*-----------------------------------------------------------
EA_PRINT_AN:
    LEA         AN_JMP, A0          ; Set index '0' for jump table
    MULU        #6, D7              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D7)           ; Jump indirect with index, i.e. jump to 'table' + displacement
AN_JMP:
    JMP         AN_000 ; A0
    JMP         AN_001 ; A1
    JMP         AN_010 ; A2
    JMP         AN_011 ; A3
    JMP         AN_100 ; A4
    JMP         AN_101 ; A5
    JMP         AN_110 ; A6
    JMP         AN_111 ; A7
AN_000: ; A0
    LEA         EA_MSG_A0, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_AN_END
AN_001: ; A1
    LEA         EA_MSG_A1, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_AN_END
AN_010: ; A2
    LEA         EA_MSG_A2, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_AN_END
AN_011: ; A3
    LEA         EA_MSG_A3, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_AN_END
AN_100: ; A4
    LEA         EA_MSG_A4, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_AN_END
AN_101: ; A5
    LEA         EA_MSG_A5, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_AN_END
AN_110: ; A6
    LEA         EA_MSG_A6, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_AN_END
AN_111: ; A7
    LEA         EA_MSG_A7, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_AN_END

EA_PRINT_AN_END:
    RTS
*---------- Address Register Indirect ----------------------
* Prints the address register indirect operand based on
* register value in D7
*-----------------------------------------------------------
EA_PRINT_IND:
    LEA         OPAREN, A4    ; Print open parentheses
    JSR         WRITE2MEM
    LEA         IND_JMP, A0         ; Set index '0' for jump table
    MULU        #6, D7              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D7)           ; Jump indirect with index, i.e. jump to 'table' + displacement
IND_JMP:
    JMP         IND_000 ; (A0)
    JMP         IND_001 ; (A1)
    JMP         IND_010 ; (A2)
    JMP         IND_011 ; (A3)
    JMP         IND_100 ; (A4)
    JMP         IND_101 ; (A5)
    JMP         IND_110 ; (A6)
    JMP         IND_111 ; (A7)
IND_000: ; (A0)
    LEA         EA_MSG_A0, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_IND_END
IND_001: ; (A1)
    LEA         EA_MSG_A1, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_IND_END
IND_010: ; (A2)
    LEA         EA_MSG_A2, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_IND_END
IND_011: ; (A3)
    LEA         EA_MSG_A3, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_IND_END
IND_100: ; (A4)
    LEA         EA_MSG_A4, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_IND_END
IND_101: ; (A5)
    LEA         EA_MSG_A5, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_IND_END
IND_110: ; (A6)
    LEA         EA_MSG_A6, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_IND_END
IND_111: ; (A7)
    LEA         EA_MSG_A7, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_IND_END
EA_PRINT_IND_END:
    LEA         CPAREN, A4   ; Print close parentheses
    JSR         WRITE2MEM
    RTS
*---------- Immediate Data ---------------------------------
* Reads immediate data from memory and prints it, based on
* size stored in D5 (1: B, 2: W, 3: L). Passes back new
* pointer location in A5
*-----------------------------------------------------------
EA_PRINT_IMM:
    MOVEA.L     A5, A1              ; copy pointer to temp
    ADDA.L      #$00000002, A1      ; Advance temp pointer to next word
    CMP         #3, D5
    BEQ         PRINT_IMM_L         ; if L, branch
    MOVE.W      (A1), D0            ; store value in a register (todo, register tbd)
    JSR         EA_PRINT_DATA *print value TODO
    ADDA.L      #$00000002, A1      ; move temp pointer past word that has been read
    JMP         PRINT_IMM_END
PRINT_IMM_L:
    MOVE.L      (A1), D0            ; store value in a register (todo, register tbd)
    *print value TODO
    ADDA.L      #$00000004, A1      ; move temp pointer past longword that has been read
PRINT_IMM_END:
    MOVEA.L     A1, A5              ; store new pointer location to pass back
    RTS
*---------- Address Register Indirect w/ Post Increment ----
* Example Description
*-----------------------------------------------------------
EA_PRINT_POSTINC:
    LEA         OPAREN, A4    ; Print open parentheses
    JSR         WRITE2MEM
    LEA         POSTINC_JMP, A0     ; Set index '0' for jump table
    MULU        #6, D7              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D7)           ; Jump indirect with index, i.e. jump to 'table' + displacement
POSTINC_JMP:
    JMP         POSTINC_000 ; (A0)+
    JMP         POSTINC_001 ; (A1)+
    JMP         POSTINC_010 ; (A2)+
    JMP         POSTINC_011 ; (A3)+
    JMP         POSTINC_100 ; (A4)+
    JMP         POSTINC_101 ; (A5)+
    JMP         POSTINC_110 ; (A6)+
    JMP         POSTINC_111 ; (A7)+
POSTINC_000: ; (A0)+
    LEA         EA_MSG_A0, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PI_END
POSTINC_001: ; (A1)+
    LEA         EA_MSG_A1, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PI_END
POSTINC_010: ; (A2)+
    LEA         EA_MSG_A2, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PI_END
POSTINC_011: ; (A3)+
    LEA         EA_MSG_A3, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PI_END
POSTINC_100: ; (A4)+
    LEA         EA_MSG_A4, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PI_END
POSTINC_101: ; (A5)+
    LEA         EA_MSG_A5, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PI_END
POSTINC_110: ; (A6)+
    LEA         EA_MSG_A6, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PI_END
POSTINC_111: ; (A7)+
    LEA         EA_MSG_A7, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PI_END
EA_PRINT_PI_END:
    LEA         CPAREN, A4   ; Print close parentheses
    JSR         WRITE2MEM
    LEA         PLUS, A4         ; Print plus sign
    JSR         WRITE2MEM
    RTS
*---------- Address Register Indirect w/ Pre Decrement -----
* Example Description
*-----------------------------------------------------------
EA_PRINT_PREDEC:
    LEA         MINUS, A4               ; Print minus sign
    JSR         WRITE2MEM
    LEA         OPAREN, A4              ; Print open parentheses
    JSR         WRITE2MEM
    LEA         PREDEC_JMP, A0      ; Set index '0' for jump table
    MULU        #6, D7              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D7)           ; Jump indirect with index, i.e. jump to 'table' + displacement
PREDEC_JMP:
    JMP         PREDEC_000 ; -(A0)
    JMP         PREDEC_001 ; -(A1)
    JMP         PREDEC_010 ; -(A2)
    JMP         PREDEC_011 ; -(A3)
    JMP         PREDEC_100 ; -(A4)
    JMP         PREDEC_101 ; -(A5)
    JMP         PREDEC_110 ; -(A6)
    JMP         PREDEC_111 ; -(A7)

PREDEC_000: ; -(A0)
    LEA         EA_MSG_A0, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PD_END
PREDEC_001: ; -(A1)
    LEA         EA_MSG_A1, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PD_END
PREDEC_010: ; -(A2)
    LEA         EA_MSG_A2, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PD_END
PREDEC_011: ; -(A3)
    LEA         EA_MSG_A3, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PD_END
PREDEC_100: ; -(A4)
    LEA         EA_MSG_A4, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PD_END
PREDEC_101: ; -(A5)
    LEA         EA_MSG_A5, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PD_END
PREDEC_110: ; -(A6)
    LEA         EA_MSG_A6, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PD_END
PREDEC_111: ; -(A7)
    LEA         EA_MSG_A7, A4
    JSR         WRITE2MEM
    JMP         EA_PRINT_PD_END

EA_PRINT_PD_END:
    LEA         CPAREN, A4   ; Print close parentheses
    JSR         WRITE2MEM
    RTS
*---------- Absolute Long Address --------------------------
* Reads and prints a longword address operand, and passes
* back new pointer location in A5
*-----------------------------------------------------------
EA_PRINT_ABS_L:
    MOVEA.L     A5, A1              ; copy pointer to temp
    ADDA.L      #$00000002, A1      ; Advance temp pointer to next word
    MOVE.L      (A1), D0            ; store longword address to print TODO
    JSR         EA_PRINT_DATA *print value TODO
    ADDA.L      #$00000004, A1      ; move temp pointer past longword that has been read
    MOVEA.L     A1, A5              ; store new pointer location to pass back
    RTS
*---------- Absolute Word Address --------------------------
* Reads and prints a word address operand, and passes back
* new pointer location in A5
*-----------------------------------------------------------
EA_PRINT_ABS_W:
    MOVEA.L     A5, A1              ; copy pointer to temp
    ADDA.L      #$00000002, A1      ; Advance temp pointer to next word
    MOVE.L      (A1), D0            ; store word address to print in TODO
    JSR         EA_PRINT_DATA *print value TODO
    ADDA.L      #$00000002, A1      ; move temp pointer past word that has been read
    MOVEA.L     A1, A5              ; store new pointer location to pass back
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
