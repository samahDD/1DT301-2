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
;   Function:           Light LED0 if SW5 is pressed
;
;   Input ports:        PORTA
;
;   Output ports:       PORTB
;
;   Subroutines:        No subroutines used
;
;   Included files:     m2560def.inc
;
;   Other information:  If other switch rather than switch 5 is pressed
;						no led should light.
;
;   Changes in program:
;						2019-09-09
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 .include "m2560def.inc"

ldi r16, 0b1111_1111 ;value to set the DDRB as outputs
out DDRB, r16 ;sets PORTB using DDRB as a output port using the binary value stored r16

ldi r16, 0b0000_0000 ;value to set the DDRA as inputs
out DDRA, r16 ;sets PORTA using DDRA as a input port using the binary value stored r16

ldi r16, 0b1111_1111 ;turn off the leds
out portB, r16

ldi r18, 0b1101_1111 ; when sw5 is pressed PINA5 is 0
ldi r19, 0b1111_1110 ;code for LED0

loop:
	in r17, PINA ; read PINA
	cp r17, r18 ; compare r18 and r17
	breq equal ; if r17 equal to r18 go to light
rjmp loop

equal: out portB, r19 ; turns on LED0
