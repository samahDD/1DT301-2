/*
 * AssemblerApplication1.asm
 *
 *  Created: 2019-09-15 15:33:06
 *   Author: kt222iq
 */ 


 .include "m2560def.inc"

ldi r16, 0xFF
out DDRB, r16

ldi r16, 0x00
out DDRA, r16

ldi r16, 0xFF
out portB, r16

ldi r18, 0b1101_1111 ; when sw5 is pressed PINA5 is 0
ldi r19, 0b1111_1110

loop: 
	in r17, PINA
	cp r17, r18
	breq light
rjmp loop

light: out portB, r19
