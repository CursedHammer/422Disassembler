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
MESSAGENOP DC.B    'NOP',CR,LF, 0    

MESSAGEMOVEW DC.B    'MOVE.W',CR,LF, 0
MESSAGEMOVEL DC.B    'MOVE.L',CR,LF, 0
MESSAGEMOVEB DC.B    'MOVE.B',CR,LF, 0

MESSAGEADDIW DC.B    'ADDI.W',CR,LF, 0
MESSAGEADDIL DC.B    'ADDI.L',CR,LF, 0
MESSAGEADDIB DC.B    'ADDI.B',CR,LF, 0

MESSAGEMOVEAL DC.B    'MOVEA.L',CR,LF, 0
MESSAGEMOVEAW DC.B    'MOVEA.W',CR,LF, 0

MESSAGEMOVEML DC.B    'MOVEM.L',CR,LF, 0
MESSAGEMOVEMW DC.B    'MOVEM.W',CR,LF, 0

MESSAGEJSR DC.B    'JSR',CR,LF, 0

MESSAGECLR DC.B    'CLR',CR,LF, 0

MESSAGERTS DC.B    'RTS',CR,LF, 0

MESSAGELEA DC.B    'LEA',CR,LF, 0

MESSAGECLRB DC.B    'CLR.B',CR,LF, 0
MESSAGECLRW DC.B    'CLR.W',CR,LF, 0
MESSAGECLRL DC.B    'CLR.L',CR,LF, 0

MESSAGEADDQB DC.B    'ADDQ.B',CR,LF, 0
MESSAGEADDQW DC.B    'ADDQ.W',CR,LF, 0
MESSAGEADDQL DC.B    'ADDQ.L',CR,LF, 0

MESSAGECMPB DC.B    'CMP.B',CR,LF, 0
MESSAGECMPW DC.B    'CMP.W',CR,LF, 0
MESSAGECMPL DC.B    'CMP.L',CR,LF, 0

MESSAGESUBB DC.B    'SUB.B',CR,LF, 0
MESSAGESUBW DC.B    'SUB.W',CR,LF, 0
MESSAGESUBL DC.B    'SUB.L',CR,LF, 0

MESSAGEADDB DC.B    'ADD.B',CR,LF, 0
MESSAGEADDW DC.B    'ADD.W',CR,LF, 0
MESSAGEADDL DC.B    'ADD.L',CR,LF, 0

MESSAGEADDAW DC.B    'ADDA.W',CR,LF, 0
MESSAGEADDAL DC.B    'ADDA.L',CR,LF, 0

MESSAGEMOVEQL DC.B    'MOVEQ.L',CR,LF, 0

MESSAGEANDB DC.B    'AND.B',CR,LF, 0
MESSAGEANDW DC.B    'AND.W',CR,LF, 0
MESSAGEANDL DC.B    'AND.L',CR,LF, 0

MESSAGEMULSW DC.B    'MULS.W',CR,LF, 0
MESSAGEMULSL DC.B    'MULS.L',CR,LF, 0

MESSAGEASRB DC.B    'ASR.B',CR,LF, 0
MESSAGEASRW DC.B    'ASR.W',CR,LF, 0
MESSAGEASRL DC.B    'ASR.L',CR,LF, 0

MESSAGEASLB DC.B    'ASL.B',CR,LF, 0
MESSAGEASLW DC.B    'ASL.W',CR,LF, 0
MESSAGEASLL DC.B    'ASL.L',CR,LF, 0

MESSAGERORB DC.B    'ROR.B',CR,LF, 0
MESSAGERORW DC.B    'ROR.W',CR,LF, 0
MESSAGERORL DC.B    'ROR.L',CR,LF, 0

MESSAGEROLB DC.B    'ROL.B',CR,LF, 0
MESSAGEROLW DC.B    'ROL.W',CR,LF, 0
MESSAGEROLL DC.B    'ROL.L',CR,LF, 0

MESSAGELSRB DC.B    'LSR.B',CR,LF, 0
MESSAGELSRW DC.B    'LSR.W',CR,LF, 0
MESSAGELSRL DC.B    'LSR.L',CR,LF, 0

MESSAGELSLB DC.B    'LSL.B',CR,LF, 0
MESSAGELSLW DC.B    'LSL.W',CR,LF, 0
MESSAGELSLL DC.B    'LSL.L',CR,LF, 0

MESSAGEORB DC.B    'OR.B',CR,LF, 0
MESSAGEORW DC.B    'OR.W',CR,LF, 0
MESSAGEORL DC.B    'OR.L',CR,LF, 0

MESSAGEDIVU DC.B    'DIVU word or long from ea',CR,LF, 0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~