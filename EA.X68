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
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
    JSR         EA_OPMODE_COMBO     ; opmode: D6, register: D7
    LEA         ADD_OPMODE, A0      ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- determine mode: mode 1 is '<ea>, Dn', mode 2 is 'Dn, <ea>'
ADD_OPMODE:
    JMP         ADD_OPMODE_000      ; mode 1, byte
    JMP         ADD_OPMODE_001      ; mode 1, word
    JMP         ADD_OPMODE_010      ; mode 1, long
    JMP         ADD_OPMODE_011      ; Invalid value
    JMP         ADD_OPMODE_100      ; mode 2, byte
    JMP         ADD_OPMODE_101      ; mode 2, word
    JMP         ADD_OPMODE_110      ; mode 2, long
    JMP         ADD_OPMODE_111      ; Invalid value
*-----------------------------------
*--- Opmode jump table options -----
ADD_OPMODE_000: ; mode 1, byte
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         ADD_MODE_1
ADD_OPMODE_001: ; mode 1, word
    MOVE.B      #2, D5              ; Store size in the case of an immediate operand
    JMP         ADD_MODE_1
ADD_OPMODE_010: ; mode 1, long
    MOVE.B      #3, D5              ; Store size in the case of an immediate operand
    JMP         ADD_MODE_1
ADD_OPMODE_011: ; Invalid value
    JSR         EA_INVALID
    JMP         ADD_END
ADD_OPMODE_100: ; mode 2, byte
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         ADD_MODE_2
ADD_OPMODE_101: ; mode 2, word
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         ADD_MODE_2
ADD_OPMODE_110: ; mode 2, long
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         ADD_MODE_2
ADD_OPMODE_111: ; Invalid value
    JSR         EA_INVALID
    JMP         ADD_END
*-----------------------------------
*--- Mode 1 ------------------------
ADD_MODE_1:
    CLR.L       D0                  ; Clear data register 0
    MOVE.B      #1, D0              ; Save mode number to D0
    MOVE.W      D7, D1              ; Save register value for printing dest. operand
    JSR         EA_DEFAULT_COMBO    ; Stores mode bits in D6, register bits in D7
    JSR         ADD_EVAL_EA         ; Evaluate the results of subroutine call
    *PRINT COMMA TODO
    MOVE.W      D1, D7              ; Return register value to D7 for use by subroutine
    JSR         EA_PRINT_DN         ; Print data register
    JMP         ADD_END
*-----------------------------------
*--- Mode 2 ------------------------
ADD_MODE_2:
    CLR.L       D0                  ; Clear data register 0
    MOVE.B      #2, D0              ; Save mode number to D0
    JSR         EA_PRINT_DN         ; Print data register
    *PRINT COMMA TODO
    JSR         EA_DEFAULT_COMBO    ; Stores mode bits in D6, register bits in D7
    JSR         ADD_EVAL_EA         ; Evaluate the results of subroutine call
    JMP         ADD_END
*-----------------------------------
*--- Evaluate EA bits --------------
ADD_EVAL_EA:
    LEA         ADD_MODE, A0        ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- Check validity based on mode value
ADD_MODE:
    JMP         ADD_MODE_000        ; Dn (invalid if opmode 2)
    JMP         ADD_MODE_001        ; An (invalid if opmode 2)
    JMP         ADD_MODE_010        ; (An)
    JMP         ADD_MODE_011        ; (An)+
    JMP         ADD_MODE_100        ; -(An)
    JMP         ADD_MODE_101        ; Invalid: Address Register Indirect with Displacement Mode
    JMP         ADD_MODE_110        ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         ADD_MODE_111        ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- EA mode jump table options ----
ADD_MODE_000: ; Dn (invalid if opmode 2)
    CMP         #2, D0
    BEQ         ADD_MODE_INVALID    ; If opmode 2, Dn is invalid addressing mode
    JSR         EA_PRINT_DN         ; Print data register direct operand
    JMP         ADD_MODE_END        ; End evaluation of ea mode
ADD_MODE_001: ; An (invalid if opmode 2)
    CMP         #2, D0
    BEQ         ADD_MODE_INVALID    ; If opmode 2, An is invalid addressing mode
    JSR         EA_PRINT_AN         ; Address register direct is invalid mode
    JMP         ADD_MODE_END        ; End evaluation of ea mode
ADD_MODE_010: ; (An)
    JSR         EA_PRINT_AN_IND     ; Print address register indirect
    JMP         ADD_MODE_END        ; End evaluation of ea mode
ADD_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         ADD_MODE_END        ; End evaluation of ea mode
ADD_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         ADD_MODE_END        ; End evaluation of ea mode
ADD_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JMP         ADD_MODE_INVALID
ADD_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         ADD_MODE_INVALID
ADD_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         ADD_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         ADD_ABS_L
    CMP.B       #$04, D7            ; Test for immediate data
    BEQ         ADD_IMM
    JMP         ADD_MODE_INVALID    ; else, invalid
*-----------------------------------
*--- Valid options for mode 111 ----
ADD_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         ADD_MODE_END
ADD_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         ADD_MODE_END
ADD_IMM: ; invalid if opmode is 2
    CMP         #2, D0
    BEQ         ADD_MODE_INVALID    ; If opmode 2, An is invalid addressing mode
    JSR         EA_PRINT_IMM        ; Print immediate data
    JMP         ADD_MODE_END
*-----------------------------------
ADD_MODE_END:
    RTS                             ; Finish evaluating EA bits
ADD_MODE_INVALID:
    JSR         EA_INVALID          ; Opcode word is Invalid, continue to ADD_END
    RTS                             ; Finish evaluating EA bits
*-----------------------------------
ADD_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS

*---------- ADDA Effective Addresses ------------------------
* Parses and prints the effective addressing information for
* the ADDA opcode
*-----------------------------------------------------------
EA_ADDA:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
    JSR         EA_DEFAULT_COMBO    ; Mode: D6, register: D7
    LEA         ADDA_MODE, A0       ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- Check validity based on mode value
ADDA_MODE:
    JMP         ADDA_MODE_000       ; Dn
    JMP         ADDA_MODE_001       ; An
    JMP         ADDA_MODE_010       ; (An)
    JMP         ADDA_MODE_011       ; (An)+
    JMP         ADDA_MODE_100       ; -(An)
    JMP         ADDA_MODE_101       ; Invalid: Address Register Indirect with Displacement Mode
    JMP         ADDA_MODE_110       ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         ADDA_MODE_111       ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- EA mode jump table options ----
ADDA_MODE_000: ; Dn
    JSR         EA_PRINT_DN         ; Print data register direct operand
    JMP         ADDA_MODE_END       ; End evaluation of ea mode
ADDA_MODE_001: ; An
    JSR         EA_PRINT_AN         ; Address register direct is invalid mode
    JMP         ADDA_MODE_END       ; End evaluation of ea mode
ADDA_MODE_010: ; (An)
    JSR         EA_PRINT_AN_IND     ; Print address register indirect
    JMP         ADDA_MODE_END       ; End evaluation of ea mode
ADDA_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         ADDA_MODE_END       ; End evaluation of ea mode
ADDA_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         ADDA_MODE_END       ; End evaluation of ea mode
ADDA_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JMP         ADDA_MODE_INVALID
ADDA_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         ADDA_MODE_INVALID
ADDA_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         ADDA_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         ADDA_ABS_L
    CMP.B       #$04, D7            ; Test for immediate data
    BEQ         ADDA_IMM
    JMP         ADDA_MODE_INVALID   ; Else, invalid
*-----------------------------------
*--- Valid options for mode 111 ----
ADDA_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         ADDA_MODE_END
ADDA_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         ADDA_MODE_END
ADDA_IMM:
    JSR         EA_PRINT_IMM        ; Print immediate data
    JMP         ADDA_MODE_END
*-----------------------------------
ADDA_MODE_INVALID:
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ADDA_END
ADDA_MODE_END:
    *PRINT COMMA TODO
    JSR         EA_OPMODE_COMBO     ; Opmode: D6, register: D7
    JSR         EA_PRINT_AN         ; Print address register
ADDA_END:
    JSR         EA_UPDATE_POINTER   ; Update global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS

*---------- ADDI Effective Addresses ------------------------
* Parses and prints the effective addressing information for
* the ADDI opcode
*-----------------------------------------------------------
EA_ADDI:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
    JSR         EA_SIZE_BITS        ; get size bits in D7
*--- Branch based on size ----------
    CMP.B       #$00, D7            ; Test if size: byte
    BEQ         ADDI_B
    CMP.B       #$01, D7            ; Test if size: word
    BEQ         ADDI_W
    CMP.B       #$02, D7            ; Test if size: long
    BEQ         ADDI_L
    JSR         EA_INVALID          ; Else, invalid
    JMP         ADDI_END
*--- Print immediate data ----------
ADDI_B:
    ADDA.W      #$2, A5             ; Increment A5 past current word
    CLR.L       D0
    MOVE.W      (A5), D0            ; read next word in memory and save
    MOVE.B      #8, D2              ; Clear upper 8 bits of operand word
    LSL.W       D2, D0              ; Perform shift (zeros shifted in)
    MOVE.B      #8, D2             ; 'Right-align' bits 0-7 to get value
    LSR.W       D2, D0              ; Perform shift (zeros shifted in)
    *print data
    ADDA.W      #$2, A5             ; Increment A5 past operand word
    JMP         ADDI_GET_DEST
ADDI_W:
    ADDA.W      #$2, A5             ; Increment A5 past current word
    CLR.L       D0
    MOVE.W      (A5), D0            ; read next word in memory and save
    *print data
    ADDA.W      #$2, A5             ; Increment A5 past operand word
    JMP         ADDI_GET_DEST
ADDI_L:
    ADDA.W      #$2, A5             ; Increment A5 past current word
    MOVE.L      (A5), D0            ; read next two words in memory and save
    ADDA.W      #$4, A5             ; Increment A5 past operand longword
*--- Get destination operand -------
ADDI_GET_DEST:
    *PRINT COMMA
    JSR         EA_DEFAULT_COMBO    ; get mode bits in D6, register bits in D7
    LEA         ADDI_MODE, A0       ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- Check validity based on mode value
ADDI_MODE:
    JMP         ADDI_MODE_000       ; Dn
    JMP         ADDI_MODE_001       ; Invalid: An
    JMP         ADDI_MODE_010       ; (An)
    JMP         ADDI_MODE_011       ; (An)+
    JMP         ADDI_MODE_100       ; -(An)
    JMP         ADDI_MODE_101       ; Invalid: Address Register Indirect with Displacement Mode
    JMP         ADDI_MODE_110       ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         ADDI_MODE_111       ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- EA mode jump table options ----
ADDI_MODE_000: ; Dn
    JSR         EA_PRINT_DN         ; Print data register direct operand
    JMP         ADDI_END
ADDI_MODE_001: ; Invalid: An
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ADDI_END
ADDI_MODE_010: ; (An)
    JSR         EA_PRINT_AN_IND     ; Print address register indirect
    JMP         ADDI_END            ; End evaluation of ea mode
ADDI_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         ADDI_END            ; End evaluation of ea mode
ADDI_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         ADDI_END            ; End evaluation of ea mode
ADDI_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ADDI_END
ADDI_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ADDI_END
ADDI_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         ADDI_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         ADDI_ABS_L
    JSR         EA_INVALID          ; else, invalid
    JMP         ADDI_END
*-----------------------------------
*--- Valid options for mode 111 ----
ADDI_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         ADDI_END
ADDI_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         ADDI_END
*-----------------------------------
ADDI_END:
    JSR         EA_UPDATE_POINTER   ; Update global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*-----------------------------------------------------------
EA_ADDQ:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_AND:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_ASL:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_ASR:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_BCC:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_CLR:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_CMP:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_DIVU:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_JSR:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_LEA:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_LSL:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_LSR:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_MOVE:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_MOVEA:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_MOVEM:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_MOVEQ:
    JSR         EA_UNIMPLEMENTED
    RTS

*---------- MULS.W Effective Addresses ---------------------
* Parses and prints the effective addressing information for
* the MULS.W opcode
*-----------------------------------------------------------
EA_MULS_W:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
    JSR         EA_DEFAULT_COMBO    ; mode: D6, register: D7
    LEA         MULS_W_MODE, A0     ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- Check validity based on mode value --------------------
MULS_W_MODE:
    JMP         MULS_W_MODE_000     ; Dn
    JMP         MULS_W_MODE_001     ; Invalid: An
    JMP         MULS_W_MODE_010     ; (An)
    JMP         MULS_W_MODE_011     ; (An)+
    JMP         MULS_W_MODE_100     ; -(An)
    JMP         MULS_W_MODE_101     ; Invalid: Address Register Indirect with Displacement Mode
    JMP         MULS_W_MODE_110     ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         MULS_W_MODE_111     ; The rest (not all valid, validated by register number)
*-----------------------------------------------------------
*--- Jump table options ------------------------------------
MULS_W_MODE_000: ; Dn
    JSR         EA_PRINT_DN         ; Print data register direct operand
    JMP         MULS_W_DEST         ; Go to: print destination operand
MULS_W_MODE_001: ; Invalid: An
    JSR         EA_INVALID          ; Address register direct is invalid mode
    JMP         MULS_W_END
MULS_W_MODE_010: ; (An)
    JSR         EA_PRINT_AN_IND     ; Print address register indirect
    JMP         MULS_W_DEST
MULS_W_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         MULS_W_DEST
MULS_W_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         MULS_W_DEST         ; Continue with parsing destination operand
MULS_W_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         MULS_W_END
MULS_W_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         MULS_W_END
MULS_W_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         MULS_W_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         MULS_W_ABS_L
    CMP.B       #$04, D7            ; Test for immediate data
    BEQ         MULS_W_IMM
    JSR         EA_INVALID          ; Else: invalid
    JMP         MULS_W_END
*-----------------------------------------------------------
*--- Valid options for mode 111 ----------------------------
MULS_W_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         MULS_W_DEST         ; Continue with parsing destination operand
MULS_W_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         MULS_W_DEST         ; Continue with parsing destination operand
MULS_W_IMM:
    JSR         EA_PRINT_IMM        ; Print immediate data
    JMP         MULS_W_DEST         ; Continue with parsing destination operand
*-----------------------------------------------------------
MULS_W_DEST:
    *print EA_MSG_COMMA
    *Get destination register
    MOVE.W      (A6), D7            ; Load word at current pointer to D1
    MOVE.B      #4, D2              ; Clear upper 4 bits of opcode word
    LSL.W       D2, D7              ; Perform shift (zeros shifted in)
    MOVE.B      #13, D2             ; 'Right-align' bits 9-11 to determine register
    LSR.W       D2, D7              ; Perform shift (zeros shifted in)
    JSR         EA_PRINT_DN         ; Print data register direct operand
MULS_W_END:
    JSR         EA_UPDATE_POINTER   ; Update global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS

EA_NOP:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_OR:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_ROL:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_ROR:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_RTS:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------
EA_SUB:
    JSR         EA_UNIMPLEMENTED
    RTS
*-----------------------------------------------------------

*---------- Example Subroutine -----------------------------
* Example Description
*-----------------------------------------------------------

*-- Generic Subroutines ------------------------------------

*---------- Unimplemented EA -------------------------------
* Prints error message for EA subroutines that have not been
* implemented yet
*-----------------------------------------------------------
EA_UNIMPLEMENTED:
    *print unimplemented message
    RTS

*---------- Invalid OpCode ---------------------------------
* Prints error message for current opcode in memory
*-----------------------------------------------------------
EA_INVALID:
    *print or indicate invalidity
    RTS

*---------- Update Global Pointer --------------------------
* Updates global pointer based on address stored in A5
*-----------------------------------------------------------
EA_UPDATE_POINTER:
    CMP.L       A5, A6              ; Check if A5==A6
    BNE         UPDATE_PTR          ; If NOT equal (a.k.a if any extra operands
                                    ; were read, and is already up to date),
                                    ; update global with current
    ADDA.W      #$02, A5            ; Else, increment past current opcode word, then update
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
    MOVE.L      (A6), D1            ; Load opcode to data register 1
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
    MOVE.L      (A6), D1            ; Load opcode to data register 1
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
    MOVE.L      (A6), D7            ; Load opcode to data register 1
    MOVE.B      #8, D2              ; Clear upper 8 bits of opcode word
    LSL.W       D2, D7              ; Perform shift (zeros shifted in)
    MOVE.B      #14, D2             ; 'Right-align' bits 6-7 to determine size bits
    LSR.W       D2, D7              ; Perform shift (zeros shifted in)
    RTS

*-- Read & Print Subroutines -------------------------------

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
*print value TODO
EA_PRINT_DN_000: ; D0
    MOVE.L      #DREG0, A4
    JSR         WRITE_LINE
DN_001 ; D1
DN_010 ; D2
DN_011 ; D3
DN_100 ; D4
DN_101 ; D5
DN_110 ; D6
DN_111 ; D7

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
* size stored in D5 (1: B, 2: W, 3: L). Passes back new
* pointer location in A5
*-----------------------------------------------------------
EA_PRINT_IMM:
    MOVEA.L     A5, A1              ; copy pointer to temp
    ADDA.W      #$2, A1             ; Advance temp pointer to next word
    CMP         #3, D5
    BEQ         PRINT_IMM_L         ; if L, branch
    MOVE.W      (A1), D0            ; store value in a register (todo, register tbd)
    *print value TODO
    ADDA.W      #$2, A1             ; move temp pointer past word that has been read
    JMP         PRINT_IMM_END
PRINT_IMM_L:
    MOVE.L      (A1), D0            ; store value in a register (todo, register tbd)
    *print value TODO
    ADDA.W      #$4, A1             ; move temp pointer past longword that has been read
PRINT_IMM_END:
    MOVEA.L     A1, A5              ; store new pointer location to pass back
    RTS
*---------- Address Register Indirect w/ Post Increment ----
* Example Description
*-----------------------------------------------------------
EA_PRINT_POSTINC:
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
* Reads and prints a longword address operand, and passes
* back new pointer location in A5
*-----------------------------------------------------------
EA_PRINT_ABS_L:
    MOVEA.L     A5, A1              ; copy pointer to temp
    ADDA.W      #$2, A1             ; Advance temp pointer to next word
    MOVE.L      (A1), D0            ; store longword address to print TODO
    *print value TODO
    ADDA.W      #$4, A1             ; move temp pointer past longword that has been read
    MOVEA.L     A1, A5              ; store new pointer location to pass back
    RTS
*---------- Absolute Word Address --------------------------
* Reads and prints a word address operand, and passes back
* new pointer location in A5
*-----------------------------------------------------------
EA_PRINT_ABS_W:
    MOVEA.L     A5, A1              ; copy pointer to temp
    ADDA.W      #$2, A1             ; Advance temp pointer to next word
    MOVE.W      (A1), D0            ; store word address to print in TODO
    *print value TODO
    ADDA.W      #$2, A1             ; move temp pointer past word that has been read
    MOVEA.L     A1, A5              ; store new pointer location to pass back
    RTS
*----------- Variables and Constants -----------------------

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
