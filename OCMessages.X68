*-----------------------------------------------------------
* Title      : Opcode Messages
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 16 May 2016
* Description: Support file containing the various messages
*              used by the OC subroutines.
*-----------------------------------------------------------


CR      EQU     $0D
LF      EQU     $0A
MESSAGESPACE DC.B  ' ',0
MESSAGENOP DC.B    'NOP',0

MESSAGEMOVEW DC.B    'MOVE.W',0
MESSAGEMOVEL DC.B    'MOVE.L',0
MESSAGEMOVEB DC.B    'MOVE.B',0

MESSAGEADDIW DC.B    'ADDI.W',0
MESSAGEADDIL DC.B    'ADDI.L',0
MESSAGEADDIB DC.B    'ADDI.B',0

MESSAGEMOVEAL DC.B    'MOVEA.L',0
MESSAGEMOVEAW DC.B    'MOVEA.W',0

MESSAGEMOVEML DC.B    'MOVEM.L',0
MESSAGEMOVEMW DC.B    'MOVEM.W',0

MESSAGEJSR DC.B    'JSR',0

MESSAGECLR DC.B    'CLR',0

MESSAGERTS DC.B    'RTS',0

MESSAGELEA DC.B    'LEA',0

MESSAGECLRB DC.B    'CLR.B',0
MESSAGECLRW DC.B    'CLR.W',0
MESSAGECLRL DC.B    'CLR.L',0

MESSAGEADDQB DC.B    'ADDQ.B',0
MESSAGEADDQW DC.B    'ADDQ.W',0
MESSAGEADDQL DC.B    'ADDQ.L',0

MESSAGECMPB DC.B    'CMP.B',0
MESSAGECMPW DC.B    'CMP.W',0
MESSAGECMPL DC.B    'CMP.L',0

MESSAGESUBB DC.B    'SUB.B',0
MESSAGESUBW DC.B    'SUB.W',0
MESSAGESUBL DC.B    'SUB.L',0

MESSAGEADDB DC.B    'ADD.B',0
MESSAGEADDW DC.B    'ADD.W',0
MESSAGEADDL DC.B    'ADD.L',0

MESSAGEADDAW DC.B    'ADDA.W',0
MESSAGEADDAL DC.B    'ADDA.L',0

MESSAGEMOVEQL DC.B    'MOVEQ.L',0

MESSAGEANDB DC.B    'AND.B',0
MESSAGEANDW DC.B    'AND.W',0
MESSAGEANDL DC.B    'AND.L',0

MESSAGEMULSW DC.B    'MULS.W',0

MESSAGEASRB DC.B    'ASR.B',0
MESSAGEASRW DC.B    'ASR.W',0
MESSAGEASRL DC.B    'ASR.L',0

MESSAGEASLB DC.B    'ASL.B',0
MESSAGEASLW DC.B    'ASL.W',0
MESSAGEASLL DC.B    'ASL.L',0

MESSAGERORB DC.B    'ROR.B',0
MESSAGERORW DC.B    'ROR.W',0
MESSAGERORL DC.B    'ROR.L',0

MESSAGEROLB DC.B    'ROL.B',0
MESSAGEROLW DC.B    'ROL.W',0
MESSAGEROLL DC.B    'ROL.L',0

MESSAGELSRB DC.B    'LSR.B',0
MESSAGELSRW DC.B    'LSR.W',0
MESSAGELSRL DC.B    'LSR.L',0

MESSAGELSLB DC.B    'LSL.B',0
MESSAGELSLW DC.B    'LSL.W',0
MESSAGELSLL DC.B    'LSL.L',0

MESSAGEORB DC.B    'OR.B',0
MESSAGEORW DC.B    'OR.W',0
MESSAGEORL DC.B    'OR.L',0

MESSAGEDIVUW DC.B    'DIVU.W',0

MESSAGEBCC DC.B    'BCC',0
MESSAGEBGT DC.B    'BGT',0
MESSAGEBLE DC.B    'BLE',0

MESSAGEOPCODE_INVALID DC.B    'That is not an opcode!', 0




*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
