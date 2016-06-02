*-----------------------------------------------------------
* Title      : Effective Addressing Subroutines
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 16 May 2016
* Description: Support file containing the effective
*              addressing subroutines for the disassembler.
*-----------------------------------------------------------

*-- Definitions Used for Code ------------------------------
    INCLUDE 'EA_UTIL.X68'

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
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    MOVE.W      D1, D7              ; Return register value to D7 for use by subroutine
    JSR         EA_PRINT_DN         ; Print data register
    JMP         ADD_END
*-----------------------------------
*--- Mode 2 ------------------------
ADD_MODE_2:
    CLR.L       D0                  ; Clear data register 0
    MOVE.B      #2, D0              ; Save mode number to D0
    JSR         EA_PRINT_DN         ; Print data register
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
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
    JSR         EA_PRINT_IND         ; Print address register indirect
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
    JSR         EA_INVALID          ; Opcode word is Invalid
    RTS                             ; Finish evaluating EA bits
*-----------------------------------
ADD_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS

*---------- ADDA Effective Addresses -----------------------
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
    JSR         EA_PRINT_IND         ; Print address register indirect
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
    JSR         EA_OPMODE_COMBO     ; Get opmode bits in
    JSR         EA_PRINT_IMM        ; Print immediate data
    JMP         ADDA_MODE_END
*-----------------------------------
ADDA_MODE_INVALID:
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ADDA_END
ADDA_MODE_END:
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_OPMODE_COMBO     ; Opmode: D6, register: D7
    JSR         EA_PRINT_AN         ; Print address register
ADDA_END:
    JSR         EA_UPDATE_POINTER   ; Update global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS

*---------- ADDI Effective Addresses -----------------------
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
    ADDA.L      #$00000002, A5      ; Increment A5 past current word
    CLR.L       D0
    MOVE.W      (A5), D0            ; read next word in memory and save
    MOVE.B      #8, D2              ; Clear upper 8 bits of operand word
    LSL.W       D2, D0              ; Perform shift (zeros shifted in)
    MOVE.B      #8, D2             ; 'Right-align' bits 0-7 to get value
    LSR.W       D2, D0              ; Perform shift (zeros shifted in)
    *print data
    ADDA.L      #$00000002, A5      ; Increment A5 past operand word
    JMP         ADDI_GET_DEST
ADDI_W:
    ADDA.L      #$00000002, A5      ; Increment A5 past current word
    CLR.L       D0
    MOVE.W      (A5), D0            ; read next word in memory and save
    *print data
    ADDA.L      #$00000002, A5      ; Increment A5 past operand word
    JMP         ADDI_GET_DEST
ADDI_L:
    ADDA.L      #$00000002, A5      ; Increment A5 past current word
    MOVE.L      (A5), D0            ; read next two words in memory and save
    ADDA.L      #$00000004, A5      ; Increment A5 past operand longword
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
    JSR         EA_PRINT_IND         ; Print address register indirect
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
*---------- ADDQ Effective Addresses -----------------------
* Parses and prints the effective addressing information for
* the ADDQ opcode
*-----------------------------------------------------------
EA_ADDQ:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
*--- Parse data --------------------
    MOVE.L      (A6), D1            ; Load opcode to data register 1
    MOVE.B      #4, D2              ; Clear upper 4 bits of opcode word
    LSL.W       D2, D1              ; Perform shift (zeros shifted in)
    MOVE.B      #13, D2             ; 'Right-align' bits 9-11 to determine mode bits
    LSR.W       D2, D1              ; Perform shift (zeros shifted in)
    CMP.B       #$00, D1            ; Check for special case (if imm. data is 0, value is actually 8)
    BNE         ADDQ_PRINT_IMM      ; If any value other than 0, print the data
    MOVE.B      #$08, D1            ; Else, the value is 0 and therefore symbolic of the value 8, so replace with the value 8
ADDQ_PRINT_IMM:
    LEA         POUND, A4         ; Print '#'
    JSR         WRITE2MEM
    JSR         EA_PRINT_DATA
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
*-----------------------------------
*--- Check validity based on mode value
    JSR         EA_DEFAULT_COMBO
    LEA         ADDQ_MODE, A0       ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
ADDQ_MODE:
    JMP         ADDQ_MODE_000       ; Dn
    JMP         ADDQ_MODE_001       ; An
    JMP         ADDQ_MODE_010       ; (An)
    JMP         ADDQ_MODE_011       ; (An)+
    JMP         ADDQ_MODE_100       ; -(An)
    JMP         ADDQ_MODE_101       ; Invalid: Address Register Indirect with Displacement Mode
    JMP         ADDQ_MODE_110       ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         ADDQ_MODE_111       ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- EA mode jump table options ----
ADDQ_MODE_000: ; Dn
    JSR         EA_PRINT_DN         ; Print data register direct operand
    JMP         ADDQ_END            ; End evaluation of ea mode
ADDQ_MODE_001: ; An
    JSR         EA_PRINT_AN         ; Address register direct is invalid mode
    JMP         ADDQ_END            ; End evaluation of ea mode
ADDQ_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         ADDQ_END            ; End evaluation of ea mode
ADDQ_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         ADDQ_END            ; End evaluation of ea mode
ADDQ_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         ADDQ_END            ; End evaluation of ea mode
ADDQ_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ADDQ_END
ADDQ_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ADDQ_END
ADDQ_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         ADDQ_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         ADDQ_ABS_L
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ADDQ_END
*-----------------------------------
*--- Valid options for mode 111 ----
ADDQ_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         ADDQ_END
ADDQ_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         ADDQ_END

*-----------------------------------
ADDQ_END:
    JSR         EA_UPDATE_POINTER   ; Update global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- AND Effective Addresses -------------------------
* Parses and prints the effective addressing information for
* the AND opcode
*-----------------------------------------------------------
EA_AND:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
    JSR         EA_OPMODE_COMBO     ; opmode: D6, register: D7
    LEA         ADD_OPMODE, A0      ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- determine mode: mode 1 is '<ea>, Dn', mode 2 is 'Dn, <ea>'
AND_OPMODE:
    JMP         AND_OPMODE_000      ; mode 1, byte
    JMP         AND_OPMODE_001      ; mode 1, word
    JMP         AND_OPMODE_010      ; mode 1, long
    JMP         AND_OPMODE_011      ; Invalid value
    JMP         AND_OPMODE_100      ; mode 2, byte
    JMP         AND_OPMODE_101      ; mode 2, word
    JMP         AND_OPMODE_110      ; mode 2, long
    JMP         AND_OPMODE_111      ; Invalid value
*-----------------------------------
*--- Opmode jump table options -----
AND_OPMODE_000: ; mode 1, byte
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         AND_MODE_1
AND_OPMODE_001: ; mode 1, word
    MOVE.B      #2, D5              ; Store size in the case of an immediate operand
    JMP         AND_MODE_1
AND_OPMODE_010: ; mode 1, long
    MOVE.B      #3, D5              ; Store size in the case of an immediate operand
    JMP         AND_MODE_1
AND_OPMODE_011: ; Invalid value
    JSR         EA_INVALID
    JMP         AND_END
AND_OPMODE_100: ; mode 2, byte
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         AND_MODE_2
AND_OPMODE_101: ; mode 2, word
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         AND_MODE_2
AND_OPMODE_110: ; mode 2, long
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         AND_MODE_2
AND_OPMODE_111: ; Invalid value
    JSR         EA_INVALID
    JMP         AND_END
*-----------------------------------
*--- Mode 1 ------------------------
AND_MODE_1:
    CLR.L       D0                  ; Clear data register 0
    MOVE.B      #1, D0              ; Save mode number to D0
    MOVE.W      D7, D1              ; Save register value for printing dest. operand
    JSR         EA_DEFAULT_COMBO    ; Stores mode bits in D6, register bits in D7
    JSR         AND_EVAL_EA         ; Evaluate the results of subroutine call
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    MOVE.W      D1, D7              ; Return register value to D7 for use by subroutine
    JSR         EA_PRINT_DN         ; Print data register
    JMP         AND_END
*-----------------------------------
*--- Mode 2 ------------------------
AND_MODE_2:
    CLR.L       D0                  ; Clear data register 0
    MOVE.B      #2, D0              ; Save mode number to D0
    JSR         EA_PRINT_DN         ; Print data register
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_DEFAULT_COMBO    ; Stores mode bits in D6, register bits in D7
    JSR         AND_EVAL_EA         ; Evaluate the results of subroutine call
    JMP         AND_END
*-----------------------------------
*--- Evaluate EA bits --------------
AND_EVAL_EA:
    LEA         AND_MODE, A0        ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- Check validity based on mode value
AND_MODE:
    JMP         AND_MODE_000        ; Dn (invalid if opmode 2)
    JMP         AND_MODE_001        ; Invalid: An
    JMP         AND_MODE_010        ; (An)
    JMP         AND_MODE_011        ; (An)+
    JMP         AND_MODE_100        ; -(An)
    JMP         AND_MODE_101        ; Invalid: Address Register Indirect with Displacement Mode
    JMP         AND_MODE_110        ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         AND_MODE_111        ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- EA mode jump table options ----
AND_MODE_000: ; Dn (invalid if opmode 2)
    CMP         #2, D0
    BEQ         AND_MODE_INVALID    ; If opmode 2, Dn is invalid addressing mode
    JSR         EA_PRINT_DN         ; Print data register direct operand
    JMP         AND_MODE_END        ; End evaluation of ea mode
AND_MODE_001: ; Invalid: An
    JMP         AND_MODE_INVALID
AND_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         AND_MODE_END        ; End evaluation of ea mode
AND_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         AND_MODE_END        ; End evaluation of ea mode
AND_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         AND_MODE_END        ; End evaluation of ea mode
AND_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JMP         AND_MODE_INVALID
AND_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         AND_MODE_INVALID
AND_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         AND_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         AND_ABS_L
    CMP.B       #$04, D7            ; Test for immediate data
    BEQ         AND_IMM
    JMP         AND_MODE_INVALID    ; else, invalid
*-----------------------------------
*--- Valid options for mode 111 ----
AND_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         AND_MODE_END
AND_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         AND_MODE_END
AND_IMM: ; invalid if opmode is 2
    CMP         #2, D0
    BEQ         AND_MODE_INVALID    ; If opmode 2, An is invalid addressing mode
    JSR         EA_PRINT_IMM        ; Print immediate data
    JMP         AND_MODE_END
*-----------------------------------
AND_MODE_END:
    RTS                             ; Finish evaluating EA bits
AND_MODE_INVALID:
    JSR         EA_INVALID          ; Opcode word is Invalid
    RTS                             ; Finish evaluating EA bits
*-----------------------------------
AND_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- ASd Effective Addresses -------------------------
* Parses and prints the effective addressing information for
* the ASd opcode
*-----------------------------------------------------------
EA_ASd:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
    JSR         EA_SIZE_BITS        ; get size bits in D7
*--- Branch based on size bits -----
    CMP.B       #$03, D7            ; test if memory shift
    BEQ         ASd_MEM
    BRA         ASd_REG             ; else, register shfit
*-----------------------------------
*--- Register Shift ----------------
ASd_REG:
* In preparation, isolate count/register field
    MOVE.W      (A6), D7            ; read opcode word in memory and save,
                                    ; (using D7 because EA_PRINT_DN uses D7)
    MOVE.B      #4, D2              ; Clear upper 4 bits of operand word
    LSL.W       D2, D7              ; Perform shift (zeros shifted in)
    MOVE.B      #13, D2             ; 'Right-align' bits 9-11 to get count/register field
    LSR.W       D2, D7              ; Perform shift (zeros shifted in)
* Isolate i/r field
    MOVE.W      (A6), D0            ; read opcode word in memory and save
    MOVE.B      #10, D2             ; Clear upper 10 bits of operand word
    LSL.W       D2, D0              ; Perform shift (zeros shifted in)
    MOVE.B      #15, D2             ; 'Right-align' bit 5 to get value
    LSR.W       D2, D0              ; Perform shift (zeros shifted in)
    CMP.B       #$00, D0            ; If i/r bit is 0, count/register field contains shift count (modulo 64)
    BEQ         ASd_REG_COUNT
ASd_REG_REG:                        ; Else, count/register field contains register number
    JSR         EA_PRINT_DN         ; Print register value, stored in D7
    JMP         ASd_REG_END         ; Jump to end of ASd_REG
ASd_REG_COUNT:
    LEA         POUND, A4        ; Print '#'
    JSR         WRITE2MEM
    JSR         EA_PRINT_DATA *print hex value in D7 as byte todo, continue on to ASd_REG_END
ASd_REG_END:
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_DEFAULT_COMBO    ; To get register bits in D7, 'mode' bits are not used
    JSR         EA_PRINT_DN         ; Print register value in D7
    JMP         ASd_END
*-----------------------------------
*--- Memory Shift ------------------
ASd_MEM:
    JSR         EA_DEFAULT_COMBO    ; mode: D6, register: D7
    LEA         ASd_MEM_MODE, A0    ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--------------------------------------
*--- Check validity based on mode value
ASd_MEM_MODE:
    JMP         ASd_MEM_MODE_000     ; Invalid: Dn
    JMP         ASd_MEM_MODE_001     ; Invalid: An
    JMP         ASd_MEM_MODE_010     ; (An)
    JMP         ASd_MEM_MODE_011     ; (An)+
    JMP         ASd_MEM_MODE_100     ; -(An)
    JMP         ASd_MEM_MODE_101     ; Invalid: Address Register Indirect with Displacement Mode
    JMP         ASd_MEM_MODE_110     ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         ASd_MEM_MODE_111     ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- Jump table options ------------
ASd_MEM_MODE_000: ; Invalid: Dn
    JSR         EA_INVALID          ; Data register direct is invalid mode
    JMP         ASd_END
ASd_MEM_MODE_001: ; Invalid: An
    JSR         EA_INVALID          ; Address register direct is invalid mode
    JMP         ASd_END
ASd_MEM_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         ASd_END
ASd_MEM_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         ASd_END
ASd_MEM_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         ASd_END         ; Continue with parsing destination operand
ASd_MEM_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ASd_END
ASd_MEM_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ASd_END
ASd_MEM_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         ASd_MEM_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         ASd_MEM_ABS_L
    JSR         EA_INVALID          ; Else: invalid
    JMP         ASd_END
*-----------------------------------
*--- Valid options for mode 111 ----
ASd_MEM_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         ASd_END
ASd_MEM_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         ASd_END
*-----------------------------------
ASd_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- Bcc Effective Addresses ------------------------
* Parses and prints the effective addressing information for
* the BCC opcode
*-----------------------------------------------------------
EA_Bcc:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
*--- Parse 8-bit displacement bits ----------
    MOVE.L      (A6), D1            ; Load opcode to data register 1
    MOVE.B      #8, D2              ; Clear upper 8 bits of opcode word
    LSL.W       D2, D1              ; Perform shift (zeros shifted in)
    MOVE.B      #8, D2              ; 'Right-align' bits 0-7 to determine condition
    LSR.W       D2, D1              ; Perform shift (zeros shifted in)
    *save ultimate address to be printed
    MOVEA.L     A6, A4              ; Copy global pointer for dislay
    CMP.B       #$00, D1            ; If value is zero, real value is next word in memory
    BEQ         BCC_W
    CMP.B       #$FF, D1            ; If value is FF, real value is next longword
    BEQ         BCC_L
    JMP         BCC_B               ; Else, parse lower-order byte of opcode word
*--- Sign Extension for byte displacement
BCC_B:
    ADDA.L      #$00000002, A4      ; Increment display pointer past opcode word
    MOVE.W      (A6), D3            ; Save opcode word
    MOVE.B      #8, D2              ; Clear upper 8 bits of opcode word
    LSL.W       D2, D3              ; Perform shift (zeros shifted in)
    MOVE.B      #15, D2             ; 'Right-align' bit 7 to determine MSB
    LSR.W       D2, D3              ; Perform shift (zeros shifted in)
    CMP.B       #$00, D3            ; If 0, sign extend with 0 (already done by isolation code)
    BEQ         BCC_DISPLAY
    ADD.L       #$FFFFFF00, D1      ; Else, sign extend data with F
    JMP         BCC_DISPLAY
*-----------------------------------
*--- Sign extension for word displacement
BCC_W:
    ADDA.L      #$00000004, A4      ; Increment display pointer past opcode word
                                    ; and displacement word in memory
    ADDA.L      #$00000002, A5      ; Increment A5 past opcode word
    MOVE.W      (A5), D3            ; Read word displacement from memory
    ADDA.L      #$00000002, A5      ; Increment A5 past word read
    MOVE.B      #15, D2             ; 'Right-align' bit 15 to determine MSB
    LSR.W       D2, D3              ; Perform shift (zeros shifted in)
    CMP.B       #$00, D3            ; If 0, sign extend with 0 (already done by isolation code)
    BEQ         BCC_DISPLAY
    ADD.L       #$FFFF0000, D1      ; Else, sign extend data with F
    JMP         BCC_DISPLAY
*-----------------------------------
*--- Read longword displacement ----
BCC_L:
    ADDA.L      #$00000006, A4      ; Increment display pointer past opcode word
                                    ; and displacement longword in memory
    ADDA.L      #$00000002, A5      ; Increment A5 past opcode word
    MOVE.L      (A5), D1            ; Read longword displacement from memory
    ADDA.L      #$00000004, A5      ; Increment A5 past longword read
    JMP         BCC_DISPLAY
*-----------------------------------
BCC_DISPLAY:
    ADDA.L      D1, A4              ; add displacement to current addressing
    *print address in A4
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- CLR Effective Addresses ------------------------
* Parses and prints the effective addressing information for
* the CLR opcode
*-----------------------------------------------------------
EA_CLR:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to ASd
    JSR         EA_DEFAULT_COMBO    ; mode: D6, register: D7
    LEA         CLR_MODE, A0        ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--------------------------------------
*--- Check validity based on mode value
CLR_MODE:
    JMP         CLR_MODE_000        ; Dn
    JMP         CLR_MODE_001        ; Invalid: An
    JMP         CLR_MODE_010        ; (An)
    JMP         CLR_MODE_011        ; (An)+
    JMP         CLR_MODE_100        ; -(An)
    JMP         CLR_MODE_101        ; Invalid: Address Register Indirect with Displacement Mode
    JMP         CLR_MODE_110        ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         CLR_MODE_111        ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- Jump table options ------------
CLR_MODE_000: ; Dn
    JSR         EA_PRINT_DN
    JMP         CLR_END
CLR_MODE_001: ; Invalid: An
    JSR         EA_INVALID          ; Address register direct is invalid mode
    JMP         CLR_END
CLR_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         CLR_END
CLR_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         CLR_END
CLR_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         CLR_END             ; Continue with parsing destination operand
CLR_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         CLR_END
CLR_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         CLR_END
CLR_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         CLR_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         CLR_ABS_L
    JSR         EA_INVALID          ; Else: invalid
    JMP         CLR_END
*-----------------------------------
*--- Valid options for mode 111 ----
CLR_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         CLR_END
CLR_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         CLR_END
*-----------------------------------
CLR_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- CMP Effective Addresses ------------------------
* Parses and prints the effective addressing information for
* the CMP opcode
*-----------------------------------------------------------
EA_CMP:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
*--- Check validity based on mode value
    JSR         EA_DEFAULT_COMBO
    LEA         CMP_MODE, A0       ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
CMP_MODE:
    JMP         CMP_MODE_000       ; Dn
    JMP         CMP_MODE_001       ; An
    JMP         CMP_MODE_010       ; (An)
    JMP         CMP_MODE_011       ; (An)+
    JMP         CMP_MODE_100       ; -(An)
    JMP         CMP_MODE_101       ; Invalid: Address Register Indirect with Displacement Mode
    JMP         CMP_MODE_110       ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         CMP_MODE_111       ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- EA mode jump table options ----
CMP_MODE_000: ; Dn
    JSR         EA_PRINT_DN         ; Print data register direct operand
    JMP         CMP_MODE_END        ; End evaluation of ea mode
CMP_MODE_001: ; An
    JSR         EA_PRINT_AN         ; Address register direct is invalid mode
    JMP         CMP_MODE_END        ; End evaluation of ea mode
CMP_MODE_010: ; (An)
    JSR         EA_PRINT_IND        ; Print address register indirect
    JMP         CMP_MODE_END        ; End evaluation of ea mode
CMP_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         CMP_MODE_END        ; End evaluation of ea mode
CMP_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         CMP_MODE_END        ; End evaluation of ea mode
CMP_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         CMP_END
CMP_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         CMP_END
CMP_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         CMP_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         CMP_ABS_L
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         CMP_END
*-----------------------------------
*--- Valid options for mode 111 ----
CMP_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         CMP_MODE_END
CMP_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         CMP_MODE_END
*-----------------------------------
*--- Evaluate and print register ---
CMP_MODE_END:
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_OPMODE_COMBO     ; get register bits in D7, opmode bits not used
    JSR         EA_PRINT_DN         ; print register
CMP_END:
    JSR         EA_UPDATE_POINTER   ; Update global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- DIVU.W Effective Addresses -----------------------
* Parses and prints the effective addressing information for
* the DIVU.W opcode
*-----------------------------------------------------------
EA_DIVU_W:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
    JSR         EA_DEFAULT_COMBO    ; mode: D6, register: D7
    LEA         DIVU_W_MODE, A0       ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- Check validity based on mode value
DIVU_W_MODE:
    JMP         DIVU_W_MODE_000     ; Dn
    JMP         DIVU_W_MODE_001     ; Invalid: An
    JMP         DIVU_W_MODE_010     ; (An)
    JMP         DIVU_W_MODE_011     ; (An)+
    JMP         DIVU_W_MODE_100     ; -(An)
    JMP         DIVU_W_MODE_101     ; Invalid: Address Register Indirect with Displacement Mode
    JMP         DIVU_W_MODE_110     ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         DIVU_W_MODE_111     ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- Jump table options ------------
DIVU_W_MODE_000: ; Dn
    JSR         EA_PRINT_DN         ; Print data register direct operand
    JMP         DIVU_W_DEST         ; Go to: print destination operand
DIVU_W_MODE_001: ; Invalid: An
    JSR         EA_INVALID          ; Address register direct is invalid mode
    JMP         DIVU_W_END
DIVU_W_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         DIVU_W_DEST
DIVU_W_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         DIVU_W_DEST
DIVU_W_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         DIVU_W_DEST         ; Continue with parsing destination operand
DIVU_W_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         DIVU_W_END
DIVU_W_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         DIVU_W_END
DIVU_W_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         DIVU_W_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         DIVU_W_ABS_L
    CMP.B       #$04, D7            ; Test for immediate data
    BEQ         DIVU_W_IMM
    JSR         EA_INVALID          ; Else: invalid
    JMP         DIVU_W_END
*-----------------------------------
*--- Valid options for mode 111 ----
DIVU_W_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         DIVU_W_DEST         ; Continue with parsing destination operand
DIVU_W_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         DIVU_W_DEST         ; Continue with parsing destination operand
DIVU_W_IMM:
    MOVE.B      #2, D5              ; Size is word
    JSR         EA_PRINT_IMM        ; Print immediate data
    JMP         DIVU_W_DEST         ; Continue with parsing destination operand
*-----------------------------------
DIVU_W_DEST:
    *print COMMA
    *Get destination register
    MOVE.W      (A6), D7            ; Load word at current pointer to D1
    MOVE.B      #4, D2              ; Clear upper 4 bits of opcode word
    LSL.W       D2, D7              ; Perform shift (zeros shifted in)
    MOVE.B      #13, D2             ; 'Right-align' bits 9-11 to determine register
    LSR.W       D2, D7              ; Perform shift (zeros shifted in)
    JSR         EA_PRINT_DN         ; Print data register direct operand
DIVU_W_END:
    JSR         EA_UPDATE_POINTER   ; Update global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- JSR Effective Addresses ------------------------
* Parses and prints the effective addressing information for
* the JSR opcode
*-----------------------------------------------------------
EA_JSR:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to ASd
    JSR         EA_DEFAULT_COMBO    ; mode: D6, register: D7
    LEA         JSR_MODE, A0        ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--------------------------------------
*--- Check validity based on mode value
JSR_MODE:
    JMP         JSR_MODE_000        ; Invalid: Dn
    JMP         JSR_MODE_001        ; Invalid: An
    JMP         JSR_MODE_010        ; (An)
    JMP         JSR_MODE_011        ; Invalid: (An)+
    JMP         JSR_MODE_100        ; Invalid: -(An)
    JMP         JSR_MODE_101        ; Invalid: Address Register Indirect with Displacement Mode
    JMP         JSR_MODE_110        ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         JSR_MODE_111        ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- Jump table options ------------
JSR_MODE_000: ; Invalid: Dn
    JSR         EA_INVALID          ; Data register direct is invalid mode
    JMP         JSR_END
JSR_MODE_001: ; Invalid: An
    JSR         EA_INVALID          ; Address register direct is invalid mode
    JMP         JSR_END
JSR_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         JSR_END
JSR_MODE_011: ; (An)+
    JSR         EA_INVALID          ; Address register indirect w/ post increment is invalid mode
    JMP         JSR_END
JSR_MODE_100: ; -(An)
    JSR         EA_INVALID          ; Address register indirect w/ pre decrement is invalid mode
    JMP         JSR_END
JSR_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         JSR_END
JSR_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         JSR_END
JSR_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         JSR_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         JSR_ABS_L
    JSR         EA_INVALID          ; Else: invalid
    JMP         JSR_END
*-----------------------------------
*--- Valid options for mode 111 ----
JSR_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         JSR_END
JSR_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         JSR_END
*-----------------------------------
JSR_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- LEA Effective Addresses ------------------------
* Parses and prints the effective addressing information for
* the LEA opcode
*-----------------------------------------------------------
EA_LEA:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to ASd
    JSR         EA_DEFAULT_COMBO    ; mode: D6, register: D7
    LEA         LEA_MODE, A0        ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--------------------------------------
*--- Check validity based on mode value
LEA_MODE:
    JMP         LEA_MODE_000        ; Dn
    JMP         LEA_MODE_001        ; Invalid: An
    JMP         LEA_MODE_010        ; (An)
    JMP         LEA_MODE_011        ; (An)+
    JMP         LEA_MODE_100        ; -(An)
    JMP         LEA_MODE_101        ; Invalid: Address Register Indirect with Displacement Mode
    JMP         LEA_MODE_110        ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         LEA_MODE_111        ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- Jump table options ------------
LEA_MODE_000: ; Invalid: Dn
    JSR         EA_INVALID          ; Data register direct is invalid mode
    JMP         LEA_END
LEA_MODE_001: ; Invalid: An
    JSR         EA_INVALID          ; Address register direct is invalid mode
    JMP         LEA_END
LEA_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         LEA_DEST
LEA_MODE_011: ; (An)+
    JSR         EA_INVALID          ; Address register indirect with post increment is invalid
    JMP         LEA_END
LEA_MODE_100: ; -(An)
    JSR         EA_INVALID          ; Adress register indirect with pre decrement is invalid
    JMP         LEA_END             ; Continue with parsing destination operand
LEA_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         LEA_END
LEA_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         LEA_END
LEA_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         LEA_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         LEA_ABS_L
    JSR         EA_INVALID          ; Else: invalid
    JMP         LEA_DEST
*-----------------------------------
*--- Valid options for mode 111 ----
LEA_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         LEA_DEST
LEA_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         LEA_DEST
*-----------------------------------
*--- Parse destination address register
LEA_DEST:
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_OPMODE_COMBO     ; Get register bits in D7, opmode bits unused
    JSR         EA_PRINT_AN         ; Print address register
LEA_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- LSd Effective Addresses ------------------------
* Parses and prints the effective addressing information for
* the LSd opcode
*-----------------------------------------------------------
EA_LSd:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
    JSR         EA_SIZE_BITS        ; get size bits in D7
*--- Branch based on size bits -----
    CMP.B       #$03, D7            ; test if memory shift
    BEQ         LSd_MEM
    BRA         LSd_REG             ; else, register shfit
*-----------------------------------
*--- Register Shift ----------------
LSd_REG:
* In preparation, isolate count/register field
    MOVE.W      (A6), D7            ; read opcode word in memory and save,
                                    ; (using D7 because EA_PRINT_DN uses D7)
    MOVE.B      #4, D2              ; Clear upper 4 bits of operand word
    LSL.W       D2, D7              ; Perform shift (zeros shifted in)
    MOVE.B      #13, D2             ; 'Right-align' bits 9-11 to get count/register field
    LSR.W       D2, D7              ; Perform shift (zeros shifted in)
* Isolate i/r field
    MOVE.W      (A6), D0            ; read opcode word in memory and save
    MOVE.B      #10, D2             ; Clear upper 10 bits of operand word
    LSL.W       D2, D0              ; Perform shift (zeros shifted in)
    MOVE.B      #15, D2             ; 'Right-align' bit 5 to get value
    LSR.W       D2, D0              ; Perform shift (zeros shifted in)
    CMP.B       #$00, D0            ; If i/r bit is 0, count/register field contains shift count (modulo 64)
    BEQ         LSd_REG_COUNT
LSd_REG_REG:                        ; Else, count/register field contains register number
    JSR         EA_PRINT_DN         ; Print register value, stored in D7
    JMP         LSd_REG_END         ; Jump to end of LSd_REG
LSd_REG_COUNT:
    LEA         POUND, A4         ; Print '#'
    JSR         WRITE2MEM
    JSR         EA_PRINT_DATA  *print hex value in D7 as byte todo, continue on to LSd_REG_END
LSd_REG_END:
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_DEFAULT_COMBO    ; To get register bits in D7, 'mode' bits are not used
    JSR         EA_PRINT_DN         ; Print register value in D7
    JMP         LSd_END
*-----------------------------------
*--- Memory Shift ------------------
LSd_MEM:
    JSR         EA_DEFAULT_COMBO    ; mode: D6, register: D7
    LEA         LSd_MEM_MODE, A0    ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--------------------------------------
*--- Check validity based on mode value
LSd_MEM_MODE:
    JMP         LSd_MEM_MODE_000     ; Invalid: Dn
    JMP         LSd_MEM_MODE_001     ; Invalid: An
    JMP         LSd_MEM_MODE_010     ; (An)
    JMP         LSd_MEM_MODE_011     ; (An)+
    JMP         LSd_MEM_MODE_100     ; -(An)
    JMP         LSd_MEM_MODE_101     ; Invalid: Address Register Indirect with Displacement Mode
    JMP         LSd_MEM_MODE_110     ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         LSd_MEM_MODE_111     ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- Jump table options ------------
LSd_MEM_MODE_000: ; Invalid: Dn
    JSR         EA_INVALID          ; Data register direct is invalid mode
    JMP         LSd_END
LSd_MEM_MODE_001: ; Invalid: An
    JSR         EA_INVALID          ; Address register direct is invalid mode
    JMP         LSd_END
LSd_MEM_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         LSd_END
LSd_MEM_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         LSd_END
LSd_MEM_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         LSd_END         ; Continue with parsing destination operand
LSd_MEM_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         LSd_END
LSd_MEM_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         LSd_END
LSd_MEM_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         LSd_MEM_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         LSd_MEM_ABS_L
    JSR         EA_INVALID          ; Else: invalid
    JMP         LSd_END
*-----------------------------------
*--- Valid options for mode 111 ----
LSd_MEM_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         LSd_END
LSd_MEM_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         LSd_END
*-----------------------------------
LSd_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- MOVE Effective Addresses -----------------------
* Parses and prints the effective addressing information for
* the MOVE opcode
*-----------------------------------------------------------
EA_MOVE:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to ASd
*--- Parse size bits ---------------
    MOVE.L      (A6), D5            ; Load opcode to data register 5 (for using size bits in immediate data)
    MOVE.B      #2, D2              ; Clear upper 10 bits of opcode word
    LSL.W       D2, D5              ; Perform shift (zeros shifted in)
    MOVE.B      #14, D2             ; 'Right-align' bits 12-13 to determine mode bits
    LSR.W       D2, D5              ; Perform shift (zeros shifted in)
    CMP.B       #$03, D5            ; if size bits are 11, correct D5
                                    ; to 10 for use with immediate data subroutine
    BEQ         MOVE_ADJUST_W
    CMP.B       #$02, D5            ; if size bits are 10, correct D5
                                    ; to 11 for use with immediate data subroutine
    BEQ         MOVE_ADJUST_L
    JMP         MOVE_SOURCE         ; Jump to evaluating source operand
MOVE_ADJUST_W:
    MOVE.B      #$02, D5            ; Correct for weird sizing in MOVE
    JMP         MOVE_SOURCE         ; Jump to evaluating source operand
MOVE_ADJUST_L:
    MOVE.B      #$03, D5            ; Correct for weird sizing in MOVE
    JMP         MOVE_SOURCE         ; Jump to evaluating source operand
*-----------------------------------
*--- Source operand ----------------
MOVE_SOURCE:
    JSR         EA_DEFAULT_COMBO    ; mode: D6, register: D7
    LEA         MOVE_SRC_MODE, A0   ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--------------------------------------
*--- Check validity based on mode value
MOVE_SRC_MODE:
    JMP         MOVE_SRC_MODE_000   ; Dn
    JMP         MOVE_SRC_MODE_001   ; An
    JMP         MOVE_SRC_MODE_010   ; (An)
    JMP         MOVE_SRC_MODE_011   ; (An)+
    JMP         MOVE_SRC_MODE_100   ; -(An)
    JMP         MOVE_SRC_MODE_101   ; Invalid: Address Register Indirect with Displacement Mode
    JMP         MOVE_SRC_MODE_110   ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         MOVE_SRC_MODE_111   ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- Jump table options ------------
MOVE_SRC_MODE_000: ; Dn
    JSR         EA_PRINT_DN         ; Print data register in D7
    JMP         MOVE_DESTINATION
MOVE_SRC_MODE_001: ; Invalid: An
    JSR         EA_PRINT_AN         ; Print address register in D7
    JMP         MOVE_DESTINATION
MOVE_SRC_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         MOVE_DESTINATION
MOVE_SRC_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         MOVE_DESTINATION
MOVE_SRC_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         MOVE_DESTINATION    ; Continue with parsing destination operand
MOVE_SRC_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         MOVE_END
MOVE_SRC_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         MOVE_END
MOVE_SRC_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         MOVE_SRC_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         MOVE_SRC_ABS_L
    CMP.B       #$04, D7            ; Test for immediate data
    BEQ         MOVE_SRC_IMM
    JSR         EA_INVALID          ; Else: invalid
    JMP         MOVE_END
*-----------------------------------
*--- Valid options for mode 111 ----
MOVE_SRC_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         MOVE_DESTINATION
MOVE_SRC_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         MOVE_DESTINATION
MOVE_SRC_IMM:
    JSR         EA_PRINT_IMM        ; Print immediate data
    JMP         MOVE_DESTINATION
*-----------------------------------
MOVE_DESTINATION:
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_OPMODE_COMBO     ; mode: D6, register: D7 (destination bits)
    LEA         MOVE_DST_MODE, A0   ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--------------------------------------
*--- Check validity based on mode value
MOVE_DST_MODE:
    JMP         MOVE_DST_MODE_000   ; Dn
    JMP         MOVE_DST_MODE_001   ; Invalid: An
    JMP         MOVE_DST_MODE_010   ; (An)
    JMP         MOVE_DST_MODE_011   ; (An)+
    JMP         MOVE_DST_MODE_100   ; -(An)
    JMP         MOVE_DST_MODE_101   ; Invalid: Address Register Indirect with Displacement Mode
    JMP         MOVE_DST_MODE_110   ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         MOVE_DST_MODE_111   ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- Jump table options ------------
MOVE_DST_MODE_000: ; Dn
    JSR         EA_PRINT_DN         ; Print data register in D7
    JMP         MOVE_END
MOVE_DST_MODE_001: ; Invalid: An
    JSR         EA_INVALID          ; Print address register in D7
    JMP         MOVE_END
MOVE_DST_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         MOVE_END
MOVE_DST_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         MOVE_END
MOVE_DST_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         MOVE_END    ; Continue with parsing destination operand
MOVE_DST_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         MOVE_END
MOVE_DST_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         MOVE_END
MOVE_DST_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         MOVE_DST_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         MOVE_DST_ABS_L
    JSR         EA_INVALID          ; Else: invalid
    JMP         MOVE_END
*-----------------------------------
*--- Valid options for mode 111 ----
MOVE_DST_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         MOVE_END
MOVE_DST_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         MOVE_END
*-----------------------------------
MOVE_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- MOVEA Effective Addresses ----------------------
* Parses and prints the effective addressing information for
* the MOVEA opcode
*-----------------------------------------------------------
EA_MOVEA:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to ASd
*--- Parse size bits ---------------
    MOVE.L      (A6), D5            ; Load opcode to data register 5 (for using size bits in immediate data)
    MOVE.B      #2, D2              ; Clear upper 10 bits of opcode word
    LSL.W       D2, D5              ; Perform shift (zeros shifted in)
    MOVE.B      #14, D2             ; 'Right-align' bits 12-13 to determine mode bits
    LSR.W       D2, D5              ; Perform shift (zeros shifted in)
    CMP.B       #$03, D5            ; if size bits are 11, correct D5
                                    ; to 10 for use with immediate data subroutine
    BEQ         MOVEA_ADJUST_W
    CMP.B       #$02, D5            ; if size bits are 10, correct D5
                                    ; to 11 for use with immediate data subroutine
    BEQ         MOVEA_ADJUST_L
    JMP         MOVEA_SOURCE         ; Jump to evaluating source operand
MOVEA_ADJUST_W:
    MOVE.B      #$02, D5            ; Correct for weird sizing in MOVE
    JMP         MOVEA_SOURCE         ; Jump to evaluating source operand
MOVEA_ADJUST_L:
    MOVE.B      #$03, D5            ; Correct for weird sizing in MOVE
    JMP         MOVEA_SOURCE         ; Jump to evaluating source operand
*-----------------------------------
*--- Source operand ----------------
MOVEA_SOURCE:
    JSR         EA_DEFAULT_COMBO    ; mode: D6, register: D7
    LEA         MOVEA_SRC_MODE, A0   ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--------------------------------------
*--- Check validity based on mode value
MOVEA_SRC_MODE:
    JMP         MOVEA_SRC_MODE_000   ; Dn
    JMP         MOVEA_SRC_MODE_001   ; An
    JMP         MOVEA_SRC_MODE_010   ; (An)
    JMP         MOVEA_SRC_MODE_011   ; (An)+
    JMP         MOVEA_SRC_MODE_100   ; -(An)
    JMP         MOVEA_SRC_MODE_101   ; Invalid: Address Register Indirect with Displacement Mode
    JMP         MOVEA_SRC_MODE_110   ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         MOVEA_SRC_MODE_111   ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- Jump table options ------------
MOVEA_SRC_MODE_000: ; Dn
    JSR         EA_PRINT_DN         ; Print data register in D7
    JMP         MOVEA_DESTINATION
MOVEA_SRC_MODE_001: ; Invalid: An
    JSR         EA_PRINT_AN         ; Print address register in D7
    JMP         MOVEA_DESTINATION
MOVEA_SRC_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         MOVEA_DESTINATION
MOVEA_SRC_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         MOVEA_DESTINATION
MOVEA_SRC_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         MOVEA_DESTINATION    ; Continue with parsing destination operand
MOVEA_SRC_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         MOVEA_END
MOVEA_SRC_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         MOVEA_END
MOVEA_SRC_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         MOVEA_SRC_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         MOVEA_SRC_ABS_L
    CMP.B       #$04, D7            ; Test for immediate data
    BEQ         MOVEA_SRC_IMM
    JSR         EA_INVALID          ; Else: invalid
    JMP         MOVEA_END
*-----------------------------------
*--- Valid options for mode 111 ----
MOVEA_SRC_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         MOVEA_DESTINATION
MOVEA_SRC_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         MOVEA_DESTINATION
MOVEA_SRC_IMM:
    JSR         EA_PRINT_IMM        ; Print immediate data
    JMP         MOVEA_DESTINATION
*-----------------------------------
MOVEA_DESTINATION:
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_OPMODE_COMBO     ; Get register bits in D7, mode bits not used
    JSR         EA_PRINT_AN         ; Print address register, continue to end
*-----------------------------------
MOVEA_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- MOVEM Effective Addresses ----------------------
* Parses and prints the effective addressing information for
* the MOVEM opcode
*-----------------------------------------------------------
EA_MOVEM:
    *seems complicated, todo
    JSR         EA_UNIMPLEMENTED
    RTS
*---------- MOVEQ Effective Addresses ----------------------
* Parses and prints the effective addressing information for
* the MOVEQ opcode
*-----------------------------------------------------------
EA_MOVEQ:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
*isolate data
    MOVE.L      (A6), D1            ; Load opcode to data register 1
    MOVE.B      #8, D2              ; Clear upper 8 bits of opcode word
    LSL.W       D2, D1              ; Perform shift (zeros shifted in)
    MOVE.B      #8, D2              ; 'Right-align' bits 0-7 to determine data bits
    LSR.W       D2, D1              ; Perform shift (zeros shifted in)
*Isolate MSB to do sign extension
    MOVE.L      (A6), D3            ; Save mode bits to D6
    MOVE.B      #8, D2              ; Clear upper 8 bits of opcode word
    LSL.W       D2, D3              ; Perform shift (zeros shifted in)
    MOVE.B      #15, D2             ; 'Right-align' bit 7 to determine MSB
    LSR.W       D2, D3              ; Perform shift (zeros shifted in)
    CMP.B       #$00, D3            ; If 0, sign extend with 0 (already done by isolation code)
    BEQ         MOVEQ_PRINT_DATA
    ADD.L       #$FFFFFF00, D1      ; Else, sign extend data with F
MOVEQ_PRINT_DATA:
    LEA         POUND, A4         ; Print '#'
    JSR         WRITE2MEM
    JSR         EA_PRINT_DATA *print data todo
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_OPMODE_COMBO     ; Get register bits in D7, mode bits not used
    JSR         EA_PRINT_DN         ; Print data register
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
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
*--- Check validity based on mode value
MULS_W_MODE:
    JMP         MULS_W_MODE_000     ; Dn
    JMP         MULS_W_MODE_001     ; Invalid: An
    JMP         MULS_W_MODE_010     ; (An)
    JMP         MULS_W_MODE_011     ; (An)+
    JMP         MULS_W_MODE_100     ; -(An)
    JMP         MULS_W_MODE_101     ; Invalid: Address Register Indirect with Displacement Mode
    JMP         MULS_W_MODE_110     ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         MULS_W_MODE_111     ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- Jump table options ------------
MULS_W_MODE_000: ; Dn
    JSR         EA_PRINT_DN         ; Print data register direct operand
    JMP         MULS_W_DEST         ; Go to: print destination operand
MULS_W_MODE_001: ; Invalid: An
    JSR         EA_INVALID          ; Address register direct is invalid mode
    JMP         MULS_W_END
MULS_W_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
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
*-----------------------------------
*--- Valid options for mode 111 ----
MULS_W_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         MULS_W_DEST         ; Continue with parsing destination operand
MULS_W_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         MULS_W_DEST         ; Continue with parsing destination operand
MULS_W_IMM:
    MOVE.B      #2, D5              ; Size is word
    JSR         EA_PRINT_IMM        ; Print immediate data
    JMP         MULS_W_DEST         ; Continue with parsing destination operand
*-----------------------------------
MULS_W_DEST:
    *print COMMA
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

*---------- OR Effective Addresses -------------------------
* Parses and prints the effective addressing information for
* the OR opcode
*-----------------------------------------------------------
EA_OR:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
    JSR         EA_OPMODE_COMBO     ; opmode: D6, register: D7
    LEA         OR_OPMODE, A0       ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- determine mode: mode 1 is '<ea>, Dn', mode 2 is 'Dn, <ea>'
OR_OPMODE:
    JMP         OR_OPMODE_000       ; mode 1, byte
    JMP         OR_OPMODE_001       ; mode 1, word
    JMP         OR_OPMODE_010       ; mode 1, long
    JMP         OR_OPMODE_011       ; Invalid value
    JMP         OR_OPMODE_100       ; mode 2, byte
    JMP         OR_OPMODE_101       ; mode 2, word
    JMP         OR_OPMODE_110       ; mode 2, long
    JMP         OR_OPMODE_111       ; Invalid value
*-----------------------------------
*--- Opmode jump table options -----
OR_OPMODE_000: ; mode 1, byte
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         OR_MODE_1
OR_OPMODE_001: ; mode 1, word
    MOVE.B      #2, D5              ; Store size in the case of an immediate operand
    JMP         OR_MODE_1
OR_OPMODE_010: ; mode 1, long
    MOVE.B      #3, D5              ; Store size in the case of an immediate operand
    JMP         OR_MODE_1
OR_OPMODE_011: ; Invalid value
    JSR         EA_INVALID
    JMP         OR_END
OR_OPMODE_100: ; mode 2, byte
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         OR_MODE_2
OR_OPMODE_101: ; mode 2, word
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         OR_MODE_2
OR_OPMODE_110: ; mode 2, long
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         OR_MODE_2
OR_OPMODE_111: ; Invalid value
    JSR         EA_INVALID
    JMP         OR_END
*-----------------------------------
*--- Mode 1 ------------------------
OR_MODE_1:
    CLR.L       D0                  ; Clear data register 0
    MOVE.B      #1, D0              ; Save mode number to D0
    MOVE.W      D7, D1              ; Save register value for printing dest. operand
    JSR         EA_DEFAULT_COMBO    ; Stores mode bits in D6, register bits in D7
    JSR         OR_EVAL_EA          ; Evaluate the results of subroutine call
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    MOVE.W      D1, D7              ; Return register value to D7 for use by subroutine
    JSR         EA_PRINT_DN         ; Print data register
    JMP         OR_END
*-----------------------------------
*--- Mode 2 ------------------------
OR_MODE_2:
    CLR.L       D0                  ; Clear data register 0
    MOVE.B      #2, D0              ; Save mode number to D0
    JSR         EA_PRINT_DN         ; Print data register
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_DEFAULT_COMBO    ; Stores mode bits in D6, register bits in D7
    JSR         OR_EVAL_EA          ; Evaluate the results of subroutine call
    JMP         OR_END
*-----------------------------------
*--- Evaluate EA bits --------------
OR_EVAL_EA:
    LEA         OR_MODE, A0         ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- Check validity based on mode value
OR_MODE:
    JMP         OR_MODE_000         ; Invalid: Dn
    JMP         OR_MODE_001         ; An (invalid if opmode 2)
    JMP         OR_MODE_010         ; (An)
    JMP         OR_MODE_011         ; (An)+
    JMP         OR_MODE_100         ; -(An)
    JMP         OR_MODE_101         ; Invalid: Address Register Indirect with Displacement Mode
    JMP         OR_MODE_110         ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         OR_MODE_111         ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- EA mode jump table options ----
OR_MODE_000: ; Invalid: Dn
    JSR         EA_INVALID          ; Invalid for both opmodes
    JMP         OR_MODE_END         ; End evaluation of ea mode
OR_MODE_001: ; An (invalid if opmode 2)
    CMP         #2, D0
    BEQ         OR_MODE_INVALID     ; If opmode 2, An is invalid addressing mode
    JSR         EA_PRINT_AN         ; Address register direct is invalid mode
    JMP         OR_MODE_END         ; End evaluation of ea mode
OR_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         OR_MODE_END         ; End evaluation of ea mode
OR_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         OR_MODE_END         ; End evaluation of ea mode
OR_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         OR_MODE_END         ; End evaluation of ea mode
OR_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JMP         OR_MODE_INVALID
OR_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         OR_MODE_INVALID
OR_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         OR_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         OR_ABS_L
    CMP.B       #$04, D7            ; Test for immediate data
    BEQ         OR_IMM
    JMP         OR_MODE_INVALID     ; else, invalid
*-----------------------------------
*--- Valid options for mode 111 ----
OR_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         OR_MODE_END
OR_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         OR_MODE_END
OR_IMM: ; invalid if opmode is 2
    CMP         #2, D0
    BEQ         OR_MODE_INVALID     ; If opmode 2, An is invalid addressing mode
    JSR         EA_PRINT_IMM        ; Print immediate data
    JMP         OR_MODE_END
*-----------------------------------
OR_MODE_END:
    RTS                             ; Finish evaluating EA bits
OR_MODE_INVALID:
    JSR         EA_INVALID          ; Opcode word is Invalid
    RTS
OR_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- ROd Effective Addresses ------------------------
* Parses and prints the effective addressing information for
* the ROd opcode
*-----------------------------------------------------------
EA_ROd:
    MOVEM.L     A0-A5/D0-D7, -(SP)  ; Save registers (except A6, global pointer to word to read)
    JSR         EA_COPY_PTR         ; Copy global pointer to A5
    JSR         EA_SIZE_BITS        ; get size bits in D7
*--- Branch based on size bits -----
    CMP.B       #$03, D7            ; test if memory shift
    BEQ         ROd_MEM
    BRA         ROd_REG             ; else, register shfit
*-----------------------------------
*--- Register Shift ----------------
ROd_REG:
* In preparation, isolate count/register field
    MOVE.W      (A6), D7            ; read opcode word in memory and save,
                                    ; (using D7 because EA_PRINT_DN uses D7)
    MOVE.B      #4, D2              ; Clear upper 4 bits of operand word
    LSL.W       D2, D7              ; Perform shift (zeros shifted in)
    MOVE.B      #13, D2             ; 'Right-align' bits 9-11 to get count/register field
    LSR.W       D2, D7              ; Perform shift (zeros shifted in)
* Isolate i/r field
    MOVE.W      (A6), D0            ; read opcode word in memory and save
    MOVE.B      #10, D2             ; Clear upper 10 bits of operand word
    LSL.W       D2, D0              ; Perform shift (zeros shifted in)
    MOVE.B      #15, D2             ; 'Right-align' bit 5 to get value
    LSR.W       D2, D0              ; Perform shift (zeros shifted in)
    CMP.B       #$00, D0            ; If i/r bit is 0, count/register field contains shift count (modulo 64)
    BEQ         ROd_REG_COUNT
ROd_REG_REG:                        ; Else, count/register field contains register number
    JSR         EA_PRINT_DN         ; Print register value, stored in D7
    JMP         ROd_REG_END         ; Jump to end of ROd_REG
ROd_REG_COUNT:
    LEA         POUND, A4         ; Print '#'''
    JSR         WRITE2MEM
    JSR         EA_PRINT_DATA       *print hex value in D7 as byte todo, continue on to ROd_REG_END
ROd_REG_END:
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_DEFAULT_COMBO    ; To get register bits in D7, 'mode' bits are not used
    JSR         EA_PRINT_DN         ; Print register value in D7
    JMP         ROd_END
*-----------------------------------
*--- Memory Shift ------------------
ROd_MEM:
    JSR         EA_DEFAULT_COMBO    ; mode: D6, register: D7
    LEA         ROd_MEM_MODE, A0    ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--------------------------------------
*--- Check validity based on mode value
ROd_MEM_MODE:
    JMP         ROd_MEM_MODE_000     ; Invalid: Dn
    JMP         ROd_MEM_MODE_001     ; Invalid: An
    JMP         ROd_MEM_MODE_010     ; (An)
    JMP         ROd_MEM_MODE_011     ; (An)+
    JMP         ROd_MEM_MODE_100     ; -(An)
    JMP         ROd_MEM_MODE_101     ; Invalid: Address Register Indirect with Displacement Mode
    JMP         ROd_MEM_MODE_110     ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         ROd_MEM_MODE_111     ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- Jump table options ------------
ROd_MEM_MODE_000: ; Invalid: Dn
    JSR         EA_INVALID          ; Data register direct is invalid mode
    JMP         ROd_END
ROd_MEM_MODE_001: ; Invalid: An
    JSR         EA_INVALID          ; Address register direct is invalid mode
    JMP         ROd_END
ROd_MEM_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         ROd_END
ROd_MEM_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         ROd_END
ROd_MEM_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         ROd_END         ; Continue with parsing destination operand
ROd_MEM_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ROd_END
ROd_MEM_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JSR         EA_INVALID          ; Opcode word is Invalid
    JMP         ROd_END
ROd_MEM_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         ROd_MEM_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         ROd_MEM_ABS_L
    JSR         EA_INVALID          ; Else: invalid
    JMP         ROd_END
*-----------------------------------
*--- Valid options for mode 111 ----
ROd_MEM_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         ROd_END
ROd_MEM_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         ROd_END
*-----------------------------------
ROd_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS
*---------- SUB Effective Addresses ------------------------
* Parses and prints the effective addressing information for
* the SUB opcode
*-----------------------------------------------------------
EA_SUB:
    JSR         EA_OPMODE_COMBO     ; opmode: D6, register: D7
    LEA         SUB_OPMODE, A0      ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- determine mode: mode 1 is '<ea>, Dn', mode 2 is 'Dn, <ea>'
SUB_OPMODE:
    JMP         SUB_OPMODE_000      ; mode 1, byte
    JMP         SUB_OPMODE_001      ; mode 1, word
    JMP         SUB_OPMODE_010      ; mode 1, long
    JMP         SUB_OPMODE_011      ; Invalid value
    JMP         SUB_OPMODE_100      ; mode 2, byte
    JMP         SUB_OPMODE_101      ; mode 2, word
    JMP         SUB_OPMODE_110      ; mode 2, long
    JMP         SUB_OPMODE_111      ; Invalid value
*-----------------------------------
*--- Opmode jump table options -----
SUB_OPMODE_000: ; mode 1, byte
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         SUB_MODE_1
SUB_OPMODE_001: ; mode 1, word
    MOVE.B      #2, D5              ; Store size in the case of an immediate operand
    JMP         SUB_MODE_1
SUB_OPMODE_010: ; mode 1, long
    MOVE.B      #3, D5              ; Store size in the case of an immediate operand
    JMP         SUB_MODE_1
SUB_OPMODE_011: ; Invalid value
    JSR         EA_INVALID
    JMP         SUB_END
SUB_OPMODE_100: ; mode 2, byte
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         SUB_MODE_2
SUB_OPMODE_101: ; mode 2, word
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         SUB_MODE_2
SUB_OPMODE_110: ; mode 2, long
    MOVE.B      #1, D5              ; Store size in the case of an immediate operand
    JMP         SUB_MODE_2
SUB_OPMODE_111: ; Invalid value
    JSR         EA_INVALID
    JMP         SUB_END
*-----------------------------------
*--- Mode 1 ------------------------
SUB_MODE_1:
    CLR.L       D0                  ; Clear data register 0
    MOVE.B      #1, D0              ; Save mode number to D0
    MOVE.W      D7, D1              ; Save register value for printing dest. operand
    JSR         EA_DEFAULT_COMBO    ; Stores mode bits in D6, register bits in D7
    JSR         SUB_EVAL_EA         ; Evaluate the results of subroutine call
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    MOVE.W      D1, D7              ; Return register value to D7 for use by subroutine
    JSR         EA_PRINT_DN         ; Print data register
    JMP         SUB_END
*-----------------------------------
*--- Mode 2 ------------------------
SUB_MODE_2:
    CLR.L       D0                  ; Clear data register 0
    MOVE.B      #2, D0              ; Save mode number to D0
    JSR         EA_PRINT_DN         ; Print data register
    LEA         COMMA, A4        ; Print comma
    JSR         WRITE2MEM
    JSR         EA_DEFAULT_COMBO    ; Stores mode bits in D6, register bits in D7
    JSR         SUB_EVAL_EA         ; Evaluate the results of subroutine call
    JMP         SUB_END
*-----------------------------------
*--- Evaluate EA bits --------------
SUB_EVAL_EA:
    LEA         SUB_MODE, A0        ; Set index '0' for jump table
    MULU        #6, D6              ; Form offset (move 6 bytes in memory for every 'JMP' command)
    JMP         0(A0, D6)           ; Jump indirect with index, i.e. jump to 'table' + displacement
*--- Check validity based on mode value
SUB_MODE:
    JMP         SUB_MODE_000        ; Dn (invalid if opmode 2)
    JMP         SUB_MODE_001        ; An (invalid if opmode 2)
    JMP         SUB_MODE_010        ; (An)
    JMP         SUB_MODE_011        ; (An)+
    JMP         SUB_MODE_100        ; -(An)
    JMP         SUB_MODE_101        ; Invalid: Address Register Indirect with Displacement Mode
    JMP         SUB_MODE_110        ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         SUB_MODE_111        ; The rest (not all valid, validated by register number)
*-----------------------------------
*--- EA mode jump table options ----
SUB_MODE_000: ; Dn (invalid if opmode 2)
    CMP         #2, D0
    BEQ         SUB_MODE_INVALID    ; If opmode 2, Dn is invalid addressing mode
    JSR         EA_PRINT_DN         ; Print data register direct operand
    JMP         SUB_MODE_END        ; End evaluation of ea mode
SUB_MODE_001: ; An (invalid if opmode 2)
    CMP         #2, D0
    BEQ         SUB_MODE_INVALID    ; If opmode 2, An is invalid addressing mode
    JSR         EA_PRINT_AN         ; Address register direct is invalid mode
    JMP         SUB_MODE_END        ; End evaluation of ea mode
SUB_MODE_010: ; (An)
    JSR         EA_PRINT_IND         ; Print address register indirect
    JMP         SUB_MODE_END        ; End evaluation of ea mode
SUB_MODE_011: ; (An)+
    JSR         EA_PRINT_POSTINC    ; Print address register indirect with post increment
    JMP         SUB_MODE_END        ; End evaluation of ea mode
SUB_MODE_100: ; -(An)
    JSR         EA_PRINT_PREDEC     ; Print address register indirect with pre decrement
    JMP         SUB_MODE_END        ; End evaluation of ea mode
SUB_MODE_101: ; Invalid: Address Register Indirect with Displacement Mode
    JMP         SUB_MODE_INVALID
SUB_MODE_110: ; Invalid: Address Register Indirect with Index (8-Bit Displacement)
    JMP         SUB_MODE_INVALID
SUB_MODE_111: ; The rest (not all valid, validated by register number)
    CMP.B       #$00, D7            ; Test for absolute word address
    BEQ         SUB_ABS_W
    CMP.B       #$01, D7            ; Test for absolute long address
    BEQ         SUB_ABS_L
    CMP.B       #$04, D7            ; Test for immediate data
    BEQ         SUB_IMM
    JMP         SUB_MODE_INVALID    ; else, invalid
*-----------------------------------
*--- Valid options for mode 111 ----
SUB_ABS_W:
    JSR         EA_PRINT_ABS_W      ; Print absolute word address operand
    JMP         SUB_MODE_END
SUB_ABS_L:
    JSR         EA_PRINT_ABS_L      ; Print absolute long address operand
    JMP         SUB_MODE_END
SUB_IMM: ; invalid if opmode is 2
    CMP         #2, D0
    BEQ         SUB_MODE_INVALID    ; If opmode 2, An is invalid addressing mode
    JSR         EA_PRINT_IMM        ; Print immediate data
    JMP         SUB_MODE_END
*-----------------------------------
SUB_MODE_END:
    RTS                             ; Finish evaluating EA bits
SUB_MODE_INVALID:
    JSR         EA_INVALID          ; Opcode word is Invalid
    RTS
*-----------------------------------
SUB_END:
    JSR         EA_UPDATE_POINTER   ; Updates global pointer
    MOVEM.L     (SP)+, A0-A5/D0-D7  ; Restore registers (except A6, global pointer to word to read)
    RTS



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
