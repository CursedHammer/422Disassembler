*-----------------------------------------------------------
* Title      : WriteBuffer Messages
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 16 May 2016
* Description: Support file containing the various messages
*              used by the WriteBuffer subroutines.
*-----------------------------------------------------------

* Display
ENTER           DC.B '------------------------- Press Enter ------------------------',0


* Op Commands
MV              DC.B 'MOVE',0
AD              DC.B 'ADD ',0

* Lengths
BYTE            DC.B '.B  ',0
WORD            DC.B '.W  ',0
LONG            DC.B '.L  ',0
ENDL            DC.B CR,LF,0

* Registers
DREG0           DC.B 'D0',0
DREG1           DC.B 'D1',0
DREG2           DC.B 'D2',0
DREG3           DC.B 'D3',0
DREG4           DC.B 'D4',0
DREG5           DC.B 'D5',0
DREG6           DC.B 'D6',0
DREG7           DC.B 'D7',0
AREG0           DC.B 'A0',0
AREG1           DC.B 'A1',0
AREG2           DC.B 'A2',0
AREG3           DC.B 'A3',0
AREG4           DC.B 'A4',0
AREG5           DC.B 'A5',0
AREG6           DC.B 'A6',0
AREG7           DC.B 'A7',0

* Signs
POUND           DC.B '#',0
DOLLAR          DC.B '$',0
PERCENT         DC.B '%',0
COMMA           DC.B ', ',0
OPAREN          DC.B '(',0
CPAREN          DC.B ')',0
PLUS            DC.B '+',0
MINUS           DC.B '-',0

* Spacing
TAB             DC.B '    ',0
