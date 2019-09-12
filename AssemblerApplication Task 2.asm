/*
 * AssemblerApplication1.asm
 *
 *  Created: 2019-09-09 13:40:54
 *   Author: kt222iq
 */ 

;***** STK600 LEDS and SWITCH demonstration
.include "m2560def.inc"

loop:

ldi r16,0b00000000 ; loads the binary value to r16
out DDRA,r16	   ; sets PORTA using DDRA as a input port using the binary value stored r16

ldi r16, 0b11111111   ;loads the binary value to r16
out DDRB,r16		; sets PORTB using DDRB as an output port using the binary value stored r16

in r16, PINA  ;loads the inputted pin address of port A to r16
out PORTB,r16 ;outputs the value of r16 to P

rjmp loop

