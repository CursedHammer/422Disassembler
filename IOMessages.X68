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
