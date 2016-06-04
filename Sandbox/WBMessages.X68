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
