/*
 * AssemblerApplication5.asm
 *
 *  Created: 2019-09-15 16:24:24
 *   Author: kt222iq
 */ 

 .include "m2560def.inc"

 ldi R20, HIGH (RAMEND)
 out SPH, R20

 ldi R20, low(RAMEND)
 out SPL, R20

 ldi r16, 0xFF
 out DDRB, r16

 ldi r17, 0b1111_1110
 out PORTB, r17

 loop: 
	 out PORTB, r17
	 CALL Delay
	 com r17
	 LSL r17
	 com r17
rjmp loop

Delay:
	 ldi r18, 21
	 ldi r19, 140
	 ldi r20, 174
L1: dec r20
	brne L1
	dec r19
	brne L1
	dec r18
	brne L1
	rjmp PC+1
RET



