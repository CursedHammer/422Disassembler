*-----------------------------------------------------------
* Title      : Effective Addressing Subroutines
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 16 May 2016
* Description: Support file containing the effective
*              addressing subroutines for the disassembler.
*-----------------------------------------------------------

*-- Definitions Used for Code ------------------------------
        INCLUDE 'EAMessages.X68'

*-- Subroutines: -------------------------------------------
*---------- ADD Effective Addresses ------------------------
* Parses and prints the effective addressing information for
* the ADD opcode
*-----------------------------------------------------------
EA_ADD:
    MOVEM.W     A0-A6/D0-D7, -(SP)  ; Save registers
    JSR         EA_OPMODE_COMBO     ; opmode: D6, register: D7
    LEA         ADD_OPMODE, A0      ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JSR         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- determine mode: mode 1 is '<ea>, Dn', mode 2 is 'Dn, <ea>'
ADD_OPMODE:
    JMP         ADD_OPMODE_000 ; mode 1, byte
    JMP         ADD_OPMODE_001 ; mode 1, word
    JMP         ADD_OPMODE_010 ; mode 1, long
    JMP         ADD_OPMODE_011 ; Invalid value
    JMP         ADD_OPMODE_100 ; mode 2, byte
    JMP         ADD_OPMODE_101 ; mode 2, word
    JMP         ADD_OPMODE_110 ; mode 2, long
    JMP         ADD_OPMODE_111 ; Invalid value
*-----------------------------------
*--- Opmode jump table options -----
ADD_OPMODE_000: ; mode 1, byte
        MOVE.B      #1, D5          ; Store size in the case of an immediate operand
        JMP         ADD_MODE_1
ADD_OPMODE_001: ; mode 1, word
        MOVE.B      #2, D5          ; Store size in the case of an immediate operand
        JMP         ADD_MODE_1
ADD_OPMODE_010: ; mode 1, long
        MOVE.B      #3, D5          ; Store size in the case of an immediate operand
        JMP         ADD_MODE_1
ADD_OPMODE_011: ; Invalid value
        JSR         EA_INVALID
        JMP         ADD_END
ADD_OPMODE_100: ; mode 2, byte
        MOVE.B      #1, D5          ; Store size in the case of an immediate operand
        JMP         ADD_MODE_2
ADD_OPMODE_101: ; mode 2, word
        MOVE.B      #1, D5          ; Store size in the case of an immediate operand
        JMP         ADD_MODE_2
ADD_OPMODE_110: ; mode 2, long
        MOVE.B      #1, D5          ; Store size in the case of an immediate operand
        JMP         ADD_MODE_2
ADD_OPMODE_111: ; Invalid value
        JSR         EA_INVALID
        JMP         ADD_END
*-----------------------------------
*--- Mode 1 ------------------------
ADD_MODE_1:
        CLR         D0              ; Clear data register 0
        MOVE.B      #1, D0          ; Save mode number to D0
        MOVE.W      D7, D1          ; Save register value for printing dest. operand
        JSR         EA_DEFAULT_COMBO ; Stores mode bits in D6, register bits in D7
        JSR         ADD_EVAL_EA     ; Evaluate the results of subroutine call
        *PRINT COMMA TODO
        MOVE.W      D1, D7          ; Return register value to D7 for use by subroutine
        JSR         EA_PRINT_DN     ; Print data register
        JMP         ADD_END
*-----------------------------------
*--- Mode 2 ------------------------
ADD_MODE_2:
        CLR         D0              ; Clear data register 0
        MOVE.B      #2, D0          ; Save mode number to D0
        JSR         EA_PRINT_DN     ; Print data register
        *PRINT COMMA TODO
        JSR         EA_DEFAULT_COMBO ; Stores mode bits in D6, register bits in D7
        JSR         ADD_EVAL_EA     ; Evaluate the results of subroutine call
        JMP         ADD_END
*-----------------------------------
*--- Evaluate EA bits --------------
ADD_EVAL_EA:
        LEA         ADD_MODE, A0        ; Set index '0' for jump table
        MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- Check validity based on mode value
ADD_MODE:
        JMP         ADD_MODE_000    ; Dn (invalid if opmode 2)
        JMP         ADD_MODE_001    ; An (invalid if opmode 2)
        JMP         ADD_MODE_010    ; (An)
        JMP         ADD_MODE_011    ; (An)+
        JMP         ADD_MODE_100    ; -(An)
        JMP         ADD_MODE_101    ; Invalid: Address Register Indirect with Displacement Mode
        JMP         ADD_MODE_110    ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
        JMP         ADD_MODE_111    ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- EA mode jump table options ----
ADD_MODE_000: ; Dn (invalid if opmode 2)
        CMP         #2, D0
        BEQ         ADD_MODE_INVALID ; If opmode 2, Dn is invalid addressing mode
        JSR         EA_PRINT_DN     ; Print data register direct operand
        JMP         ADD_MODE_END    ; End evaluation of ea mode
ADD_MODE_001: ; An (invalid if opmode 2)
        CMP         #2, D0
        BEQ         ADD_MODE_INVALID ; If opmode 2, An is invalid addressing mode
        JSR         EA_PRINT_AN     ; Address register direct is invalid mode
        JMP         ADD_MODE_END    ; End evaluation of ea mode
ADD_MODE_010: ; (An)
        JSR         EA_PRINT_AN_IND ; Print address register indirect
        JMP         ADD_MODE_END    ; End evaluation of ea mode
ADD_MODE_011: ; (An)+
        JSR         EA_PRINT_POSTINC ; Print address register indirect with post increment
        JMP         ADD_MODE_END    ; End evaluation of ea mode
ADD_MODE_100: ; -(An)
        JSR         EA_PRINT_PREDEC ; Print address register indirect with pre decrement
        JMP         ADD_MODE_END    ; End evaluation of ea mode
ADD_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
        JMP         ADD_MODE_INVALID
ADD_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
        JMP         ADD_MODE_INVALID
ADD_MODE_111: ; The rest (not all valid, validated by register number)
        CMP.B       #$00, D7        ; Test for absolute word address
        BEQ         ADD_ABS_W
        CMP.B       #$01, D7        ; Test for absolute long address
        BEQ         ADD_ABS_L
        CMP.B       #$04, D7        ; Test for immediate data
        BEQ         ADD_IMM
        JMP         ADD_MODE_INVALID ; else, invalid
*-----------------------------------
*--- Valid options for mode 111 ----
ADD_ABS_W:
        JSR         EA_PRINT_ABS_W  ; Print absolute word address operand
        JMP         ADD_MODE_END
ADD_ABS_L:
        JSR         EA_PRINT_ABS_L  ; Print absolute long address operand
        JMP         ADD_MODE_END
ADD_IMM: ; invalid if opmode is 2
        CMP         #2, D0
        BEQ         ADD_MODE_INVALID ; If opmode 2, An is invalid addressing mode
        JSR         EA_PRINT_IMM    ; Print immediate data
        JMP         ADD_MODE_END
*-----------------------------------
ADD_MODE_END RTS
ADD_MODE_INVALID:
        JSR         EA_INVALID      ; Opcode word is Invalid, continue to ADD_END
*-----------------------------------
ADD_END:
        MOVEM.L     (SP)+, A0-A6/D0-D5 ; Restore registers
        RTS


EA_ADDA
EA_ADDI
EA_ADDQ
EA_AND
EA_ASL
EA_ASR
EA_BCC
EA_CLR
EA_CMP
EA_DIVU
EA_JSR
EA_LEA
EA_LSL
EA_LSR
EA_MOVE
EA_MOVEA
EA_MOVEM
EA_MOVEQ

*---------- MULS.W Effective Addresses ---------------------
* Parses and prints the effective addressing information for
* the MULS.W opcode
*-----------------------------------------------------------

EA_MULS_W:
        MOVEM.W     A0-A6/D0-D7, -(SP) ; Save registers

        JSR         EA_DEFAULT_COMBO ; mode: D6, register: D7
        LEA         MULS_W_MODE, A0 ; Set index '0' for jump table
        MULU        #6, D6          ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0, D6)       ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- Check validity based on mode value --------------------
MULS_W_MODE:
        JMP         MULS_W_MODE_000 ; Dn
        JMP         MULS_W_MODE_001 ; Invalid: An
        JMP         MULS_W_MODE_010 ; (An)
        JMP         MULS_W_MODE_011 ; (An)+
        JMP         MULS_W_MODE_100 ; -(An)
        JMP         MULS_W_MODE_101 ; Invalid: Address Register Indirect with Displacement Mode
        JMP         MULS_W_MODE_110 ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
        JMP         MULS_W_MODE_111 ; The rest (not all valid, validated by register number)
*-----------------------------------------------------------
*--- Jump table options ------------------------------------
MULS_W_MODE_000: ; Dn
        JSR         EA_PRINT_DN     ; Print data register direct operand
        JMP         MULS_W_DEST     ; Go to: print destination operand
MULS_W_MODE_001: ; Invalid: An
        JSR         EA_INVALID      ; Address register direct is invalid mode
        JMP         MULS_W_END
MULS_W_MODE_010: ; (An)
        JSR         EA_PRINT_AN_IND ; Print address register indirect
        JMP         MULS_W_DEST
MULS_W_MODE_011: ; (An)+
        JSR         EA_PRINT_POSTINC ; Print address register indirect with post increment
        JMP         MULS_W_DEST
MULS_W_MODE_100: ; -(An)
        JSR         EA_PRINT_PREDEC ; Print address register indirect with pre decrement
        JMP         MULS_W_DEST     ; Continue with parsing destination operand
MULS_W_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
        JSR         EA_INVALID      ; Opcode word is Invalid
        JMP         MULS_W_END
MULS_W_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
        JSR         EA_INVALID      ; Opcode word is Invalid
        JMP         MULS_W_END
MULS_W_MODE_111: ; The rest (not all valid, validated by register number)
        CMP.B       #$00, D7        ; Test for absolute word address
        BEQ         MULS_W_ABS_W
        CMP.B       #$01, D7        ; Test for absolute long address
        BEQ         MULS_W_ABS_L
        CMP.B       #$04, D7        ; Test for immediate data
        BEQ         MULS_W_IMM
        JSR         EA_INVALID      ; Else: invalid
        JMP         MULS_W_END
*-----------------------------------------------------------
*--- Valid options for mode 111 ----------------------------
MULS_W_ABS_W:
        JSR         EA_PRINT_ABS_W  ; Print absolute word address operand
        JMP         MULS_W_DEST     ; Continue with parsing destination operand
MULS_W_ABS_L:
        JSR         EA_PRINT_ABS_L  ; Print absolute long address operand
        JMP         MULS_W_DEST     ; Continue with parsing destination operand
MULS_W_IMM:
        JSR         EA_PRINT_IMM    ; Print immediate data
        JMP         MULS_W_DEST     ; Continue with parsing destination operand
*-----------------------------------------------------------
MULS_W_DEST:
        *print EA_MSG_COMMA
        *Get destination register
        MOVE.W      (A2), D7        ; Load word at current pointer to D1
        MOVE.B      #4, D2          ; Clear upper 4 bits of opcode word
        LSL.W       D2, D7          ; Perform shift (zeros shifted in)
        MOVE.B      #13, D2         ; 'Right-align' bits 9-11 to determine register
        LSR.W       D2, D7          ; Perform shift (zeros shifted in)
        JSR         EA_PRINT_DN     ; Print data register direct operand
MULS_W_END:
        MOVEM.L     (SP)+, A0-A6/D0-D5 ; Restore registers
        RTS

EA_NOP
EA_OR
EA_ROL
EA_ROR
EA_RTS
EA_SUB

*---------- Example Subroutine -----------------------------
* Example Description
*-----------------------------------------------------------

*-- Generic Subroutines ------------------------------------

*---------- Invalid OpCode ---------------------------------
*
*-----------------------------------------------------------
EA_INVALID:
        *print or indicate invalidity
        RTS

*---------- Parse Default Combo ----------------------------
* Parses and separates values in the default mode/register
* data combo found at the end of many opcode words.
* POST: mode bits in D6, register bits in D7
*-----------------------------------------------------------
EA_DEFAULT_COMBO:
        MOVEM.L     A0-A6/D0-D5, -(SP) ; Save registers (excluding D6 and D7, used
                                       ; to return results, and A7 for SP)
        CLR.B       D6              ; Clear space for mode bits
        CLR.B       D7              ; Clear space for register bits
* Get Mode
        MOVE.L      (A2), D1        ; Load opcode to data register 1
        MOVE.B      #10, D2         ; Clear upper 10 bits of opcode word
        LSL.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      #13, D2         ; 'Right-align' bits 3-5 to determine mode bits
        LSR.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      D1, D6          ; Save mode bits to D6
* Get Register
        MOVE.L      (A2), D1        ; Reload opcode to data register 1
        MOVE.B      #13, D2         ; Clear upper 13 bits of opcode word
        LSL.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      #13, D2         ; 'Right-align' bits 0-2 to determine register bits
        LSR.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      D1, D7          ; Save register bits to D7

        MOVEM.L     (SP)+, A0-A6/D0-D5 ; Restore registers
        RTS                         ; Return from subroutine

*---------- Parse Opmode Combo ----------------------------
* Parses and separates values in the opmode/register
* data combo found in bits 6-11 in many opcode words.
* POST: opmode bits in D6, register bits in D7
*-----------------------------------------------------------
EA_OPMODE_COMBO:
        MOVEM.L     A0-A6/D0-D5, -(SP) ; Save registers (excluding D6 and D7, used
                                       ; to return results, and A7 for SP)
        CLR.B       D6              ; Clear space for mode bits
        CLR.B       D7              ; Clear space for register bits
* Get Opmode
        MOVE.L      (A2), D1        ; Load opcode to data register 1
        MOVE.B      #7, D2          ; Clear upper 7 bits of opcode word
        LSL.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      #13, D2         ; 'Right-align' bits 6-8 to determine opmode bits
        LSR.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      D1, D6          ; Save opmode bits to D6
* Get Register
        MOVE.L      (A2), D1        ; Reload opcode to data register 1
        MOVE.B      #4, D2          ; Clear upper 4 bits of opcode word
        LSL.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      #13, D2         ; 'Right-align' bits 9-11 to determine register bits
        LSR.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      D1, D7          ; Save register bits to D7

        MOVEM.L     (SP)+, A0-A6/D0-D5 ; Restore registers
        RTS                         ; Return from subroutine

*-- Read & Print Subroutines -------------------------------

*---------- Data Register Direct ---------------------------
* Prints the data register direct operand based on register
* value in D7
*-----------------------------------------------------------
EA_PRINT_DN:
        LEA         EA_PRINT_DN_JMP, A0 ; Set index '0' for jump table
        MULU        #6, D7          ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0, D7)       ; Jump indirect with index, i.e. jump to 'table' + displacement
EA_PRINT_DN_JMP:
        JMP         EA_PRINT_DN_000 ; D0
        JMP         EA_PRINT_DN_001 ; D1
        JMP         EA_PRINT_DN_010 ; D2
        JMP         EA_PRINT_DN_011 ; D3
        JMP         EA_PRINT_DN_100 ; D4
        JMP         EA_PRINT_DN_101 ; D5
        JMP         EA_PRINT_DN_110 ; D6
        JMP         EA_PRINT_DN_111 ; D7
*print value TODO
EA_PRINT_DN_000 ; D0
EA_PRINT_DN_001 ; D1
EA_PRINT_DN_010 ; D2
EA_PRINT_DN_011 ; D3
EA_PRINT_DN_100 ; D4
EA_PRINT_DN_101 ; D5
EA_PRINT_DN_110 ; D6
EA_PRINT_DN_111 ; D7

EA_PRINT_DN_END:
        RTS

*---------- Address Register Direct ------------------------
* Prints the address register direct operand based on
* register value in D7
*-----------------------------------------------------------
EA_PRINT_AN:
        LEA         AN_JMP, A0      ; Set index '0' for jump table
        MULU        #6, D7          ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0, D7)       ; Jump indirect with index, i.e. jump to 'table' + displacement
AN_JMP:
        JMP         AN_000          ; A0
        JMP         AN_001          ; A1
        JMP         AN_010          ; A2
        JMP         AN_011          ; A3
        JMP         AN_100          ; A4
        JMP         AN_101          ; A5
        JMP         AN_110          ; A6
        JMP         AN_111          ; A7
*print value TODO
AN_000 ; A0
AN_001 ; A1
AN_010 ; A2
AN_011 ; A3
AN_100 ; A4
AN_101 ; A5
AN_110 ; A6
AN_111 ; A7

EA_PRINT_AN_END:
        RTS
*---------- Address Register Indirect ----------------------
* Prints the address register indirect operand based on
* register value in D7
*-----------------------------------------------------------
EA_PRINT_IND:
        LEA         IND_JMP, A0     ; Set index '0' for jump table
        MULU        #6, D7          ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0, D7)       ; Jump indirect with index, i.e. jump to 'table' + displacement
IND_JMP:
        JMP         IND_000         ; (A0)
        JMP         IND_001         ; (A1)
        JMP         IND_010         ; (A2)
        JMP         IND_011         ; (A3)
        JMP         IND_100         ; (A4)
        JMP         IND_101         ; (A5)
        JMP         IND_110         ; (A6)
        JMP         IND_111         ; (A7)
*print value TODO
IND_000 ; (A0)
IND_001 ; (A1)
IND_010 ; (A2)
IND_011 ; (A3)
IND_100 ; (A4)
IND_101 ; (A5)
IND_110 ; (A6)
IND_111 ; (A7)

EA_PRINT_IND_END:
        RTS
*---------- Immediate Data ---------------------------------
* Reads immediate data from memory and prints it, based on
* size stored in D5 (1: B, 2: W, 3: L)
*-----------------------------------------------------------
EA_PRINT_IMM:
        MOVEA.L     A2, A1          ; copy pointer to temp
        ADDA.W      #$2, A1         ; Advance temp pointer to next word
        CMP         #3, D5
        BEQ         PRINT_IMM_L     ; if L, branch
        MOVE.W      (A1), D0        ; store value in a register (todo, register tbd)
        *print value TODO
        JMP         PRINT_IMM_END
PRINT_IMM_L:
        MOVE.L      (A1), D0        ; store value in a register (todo, register tbd)
        *print value TODO           ; and continue on to PRINT_IMM_END
PRINT_IMM_END:
        RTS
*---------- Address Register Indirect w/ Post Increment ----
* Example Description
*-----------------------------------------------------------
EA_PRINT_POSTINC:
        LEA         POSTINC_JMP, A0 ; Set index '0' for jump table
        MULU        #6, D7          ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0, D7)       ; Jump indirect with index, i.e. jump to 'table' + displacement
POSTINC_JMP:
        JMP         POSTINC_000 ; (A0)+
        JMP         POSTINC_001 ; (A1)+
        JMP         POSTINC_010 ; (A2)+
        JMP         POSTINC_011 ; (A3)+
        JMP         POSTINC_100 ; (A4)+
        JMP         POSTINC_101 ; (A5)+
        JMP         POSTINC_110 ; (A6)+
        JMP         POSTINC_111 ; (A7)+
*print value TODO
POSTINC_000 ; (A0)+
POSTINC_001 ; (A1)+
POSTINC_010 ; (A2)+
POSTINC_011 ; (A3)+
POSTINC_100 ; (A4)+
POSTINC_101 ; (A5)+
POSTINC_110 ; (A6)+
POSTINC_111 ; (A7)+

EA_PRINT_PI_END:
        RTS
*---------- Address Register Indirect w/ Pre Decrement -----
* Example Description
*-----------------------------------------------------------
EA_PRINT_PREDEC:
        LEA         PREDEC_JMP, A0 ; Set index '0' for jump table
        MULU        #6, D7          ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0, D7)       ; Jump indirect with index, i.e. jump to 'table' + displacement
PREDEC_JMP:
        JMP         PREDEC_000 ; -(A0)
        JMP         PREDEC_001 ; -(A1)
        JMP         PREDEC_010 ; -(A2)
        JMP         PREDEC_011 ; -(A3)
        JMP         PREDEC_100 ; -(A4)
        JMP         PREDEC_101 ; -(A5)
        JMP         PREDEC_110 ; -(A6)
        JMP         PREDEC_111 ; -(A7)
*print value TODO
PREDEC_000 ; -(A0)
PREDEC_001 ; -(A1)
PREDEC_010 ; -(A2)
PREDEC_011 ; -(A3)
PREDEC_100 ; -(A4)
PREDEC_101 ; -(A5)
PREDEC_110 ; -(A6)
PREDEC_111 ; -(A7)

EA_PRINT_PD_END:
RTS
*---------- Absolute Long Address --------------------------
* Example Description
*-----------------------------------------------------------
EA_PRINT_ABS_L:
*TODO
*---------- Absolute Word Address --------------------------
* Example Description
*-----------------------------------------------------------
EA_PRINT_ABS_W:
*TODO
*----------- Variables and Constants -----------------------

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
