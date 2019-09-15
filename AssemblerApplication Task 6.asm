/*
 * AssemblerApplication6.asm
 *
 *  Created: 2019-09-15 16:40:32
 *   Author: kt222iq
 */ 


 .include "m2560def.inc"

 ldi r20, HIGH (RAMEND)
 out SPH, R20
 ldi R20, low (RAMEND)
 out SPL, R20

 ldi r16, 0xFF
 out DDRB, r16

 ldi r16, 0xFF
 out PORTB, r16

 ldi r21, 0b1111_1110
 ldi r22, 0xFF
 ldi r23, 0x00

 loop: 
	 out PORTB, r21
	 LSL r21
	 CALL Delay

	 cp r21, r23
	 breq light
rjmp loop


light:
	 out PORTB, r23
	 CALL Delay
	 ldi r21, 0b1000_0000
	 out PORTB, r21
	 Sec_loop:
			out PORTB, r21
			ASR r21
			CALL Delay
			cp r21, r22

			breq loop
		rjmp Sec_loop

Delay:
	 ldi r18, 21
	 ldi r19, 140
	 ldi r20, 174

L1:  dec r20
	 brne L1
	 dec r19
	 brne L1
	 dec r18
	 brne L1
	 rjmp PC+1
RET




