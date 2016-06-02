*-----------------------------------------------------------
* Title      : Effective Addressing Messages
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 16 May 2016
* Description: Support file containing the various messages
*              used by the EA subroutines.
*-----------------------------------------------------------

EA_MSG_NULL         DC.B    0
EA_MSG_SPACE        DC.B    ' ',0
EA_MSG_COMMA        DC.B    ', ',0
EA_MSG_OPENPAREN    DC.B    '(',0
EA_MSG_CLOSEPAREN   DC.B    ')',0
EA_MSG_MIN          DC.B    '-',0
EA_MSG_PLUS         DC.B    '+',0
EA_MSG_HASH         DC.B    '#',0
EA_MSG_HEX          DC.B    '$',0

EA_MSG_D0           DC.B    'D0',0
EA_MSG_D1           DC.B    'D1',0
EA_MSG_D2           DC.B    'D2',0
EA_MSG_D3           DC.B    'D3',0
EA_MSG_D4           DC.B    'D4',0
EA_MSG_D5           DC.B    'D5',0
EA_MSG_D6           DC.B    'D6',0
EA_MSG_D7           DC.B    'D7',0

EA_MSG_A0           DC.B    'A0',0
EA_MSG_A1           DC.B    'A1',0
EA_MSG_A2           DC.B    'A2',0
EA_MSG_A3           DC.B    'A3',0
EA_MSG_A4           DC.B    'A4',0
EA_MSG_A5           DC.B    'A5',0
EA_MSG_A6           DC.B    'A6',0
EA_MSG_A7           DC.B    'A7',0

EA_MSG_UNIMP        DC.B    '[EA CODE NOT IMPLEMENTED]',0
EA_MSG_PRINT_DATA   DC.B    '[PRINTING DATA NOT IMPLEMENTED]',0

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
