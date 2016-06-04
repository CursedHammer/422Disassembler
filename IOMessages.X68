*-----------------------------------------------------------
* Title      : I/O Messages
* Written by : Brandon Authier (Hblkr), Jack S. Eldridge
*              (JackScottie), Marijn Burger (marijnburger)
* Date       : 16 May 2016
* Description: Support file containing the various messages
*              used by the IO subroutines.
*-----------------------------------------------------------

INTRO           DC.B 'WELCOME!',CR,LF,'THIS IS A 68K DISASSEMBLER.',CR,LF,0
PS1             DC.B 'PLEASE ENTER THE STARTING HEX ADDRESS',CR,LF,'(MAX 8 DIGITS AND MUST BE EVEN): $',0
PS2             DC.B 'PLEASE ENTER THE ENDING HEX ADDRESS',CR,LF,'(MAX 8 DIGITS AND MUST BE EVEN): $',0
BMESSAGE        DC.B CR,LF,'BEGINNING ADDRESS GIVEN IS: ',0
EMESSAGE        DC.B CR,LF,'ENDING ADDRESS GIVEN IS   : ',0

ADR_ERR_NOTLT   DC.B 'THE BEGINNING ADDRESS MUST BE LESS THAN THE ENDING ADDRESS.',CR,LF,'PRESS ANY KEY TO TRY AGAIN...',0

HEXSTRING       DS.B 80             * Var for hex string

DATA            DC.B 'DATA',0


*----- Originally from WBMessages --------------------------
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

*----- Originally from EPMessages --------------------------

* Display
ENDQUESTION     DC.B 'WOULD YOU LIKE TO RUN THE PROGRAM AGAIN (Y/N)? ',0
