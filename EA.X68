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
EA_ADD
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

        *get default ea
        JSR         EA_DEFAULT_COMBO ; mode: D6, register: d7
        LEA         MULS_W_MODE, A0 ; Set index '0' for jump table
        MULU        #6, D6          ; Form offset (move 6 bytes in memory for every 'JMP' command)
        JSR         0(A0, D6)       ; Jump indirect with index, i.e. jump to 'table' + displacement
        *check validity based on mode value
MULS_W_MODE:
        JMP         MULS_W_MODE_000 ; Dn
        JMP         MULS_W_MODE_001 ; Invalid: An
        JMP         MULS_W_MODE_010 ; (An)
        JMP         MULS_W_MODE_011 ; (An)+
        JMP         MULS_W_MODE_100 ; -(An)
        JMP         MULS_W_MODE_101 ; Invalid: Address Register Indirect with Displacement Mode
        JMP         MULS_W_MODE_110 ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
        JMP         MULS_W_MODE_111 ; The rest (not all valid, validated by register number)

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

MULS_W_ABS_W:
        JSR         EA_PRINT_ABS_W  ; Print absolute word address operand
        JMP         MULS_W_DEST     ; Continue with parsing destination operand
MULS_W_ABS_L:
        JSR         EA_PRINT_ABS_L  ; Print absolute long address operand
        JMP         MULS_W_DEST     ; Continue with parsing destination operand
MULS_W_IMM:
        JSR         EA_PRINT_IMM    ; Print immediate data
        JMP         MULS_W_DEST     ; Continue with parsing destination operand

MULS_W_DEST:
        *print EA_MSG_COMMA
        *Get destination register
        MOVE.W      (A5), D7        ; Load word at current pointer to D1
        MOVE.B      #4, D2          ; Clear upper 4 bits of opcode word
        LSL.W       D2, D7          ; Perform shift (zeros shifted in)
        MOVE.B      #13, D2         ; 'Right-align' bits 9-11 to determine register
        LSR.W       D2, D7          ; Perform shift (zeros shifted in)
        JSR         EA_PRINT_DN     ; Print data register direct operand
MULS_W_END:
        MOVEM.L     (SP)+, A0-A4/D0-D5 ; Restore registers
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
        MOVEM.L     A0-A4/D0-D5, -(SP) ; Save registers (excluding D6 and D7, used
                                       ; to return results, A5-A7 are addresses and SP)
        CLR.B       D6              ; Clear space for mode bits
        CLR.B       D7              ; Clear space for register bits
* Get Mode
        MOVE.L      (A5), D1        ; Load opcode to data register 1
        MOVE.B      #10, D2         ; Clear upper 10 bits of opcode word
        LSL.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      #13, D2         ; 'Right-align' bits 3-5 to determine mode bits
        LSR.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      D1, D6          ; Save mode bits to D6
* Get Register
        MOVE.L      (A5), D1        ; Reload opcode to data register 1
        MOVE.B      #13, D2         ; Clear upper 13 bits of opcode word
        LSL.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      #13, D2         ; 'Right-align' bits 0-2 to determine register bits
        LSR.W       D2, D1          ; Perform shift (zeros shifted in)
        MOVE.B      D1, D7          ; Save register bits to D7

        MOVEM.L     (SP)+, A0-A4/D0-D5 ; Restore registers
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
*print value
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
*print value
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
*print value
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
* Example Description
*-----------------------------------------------------------
EA_PRINT_IMM:

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
*print value
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
*print value
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

*---------- Absolute Word Address --------------------------
* Example Description
*-----------------------------------------------------------
EA_PRINT_ABS_W:

*----------- Variables and Constants -----------------------





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
