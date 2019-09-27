;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2019-09-09
;   Author: Andrei Neagu (an223kj)
;           Konstantinos Tatsis (kt222iq)
;
;   Lab number:         1
;   Title:              How to use the PORTs. Digital input /output.
;                       Subroutine call.
;
;   Hardware:           STK600, CPU ATmega2560
;
;   Function:           Light LED in PORTB corresponding its Switch in PORTA
;
;   Input ports:        PORTA
;
;   Output ports:       PORTB
;
;   Subroutines:        No subroutines used
;
;   Included files:     m2560def.inc
;
;   Other information:  In order to light a led, you have to press
;						a switch. The input from the switch will
;						activate the corresponding led.
;
;   Changes in program:
;					   2019-09-09
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


.include "m2560def.inc"

loop:

ldi r17,0b00000000 ; loads the binary value to 17
out DDRA,r17	   ; sets PORTA using DDRA as a input port using the binary value stored r17

ldi r17, 0b11111111   ;loads the binary value to 17
out DDRB,r17		; sets PORTB using DDRB as an output port using the binary value stored r17

in r17, PINA  ;loads the inputted pin address of port A to r17
out PORTB,r17 ;outputs the value of r17 to PORTB

rjmp loop
