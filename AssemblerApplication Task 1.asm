;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2019-09-09
;   Author: Andrei Neagu(an223kj)
;           Konstantinos Tatsis (kt222iq)
;
;   Lab number:         1
;   Title:              How to use the PORTs. Digital input /output.
;                       Subroutine call.
;
;   Hardware:           STK600, CPU ATmega2560
;
;   Function:           Lights LED2 on PORTB
;
;   Input ports:        No input used
;
;   Output ports:       PIN2 on PORTB
;
;   Subroutines:        No subroutines used
;
;   Included files:     m2560def.inc
;
;   Other information:  In order to light a led, you have to set
;						the number of the PIN you want to use as 0
;						For example: LED2 on would be 0b11111011
;
;   Changes in program:
;						2019-09-09
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

ldi r16, 0b00000100 ; Loading bit value to the register
out DDRB, r16 ; Writing to "Data Direction register for port B" the bit value that we loaded above.
