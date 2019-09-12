/*
 * AssemblerApplication1.asm
 *
 *  Created: 2019-09-09 13:40:54
 *   Author: kt222iq
 */ 


;***** STK600 LEDS and SWITCH demonstration
.include "m2560def.inc"

ldi r16, 0b00000100 ; Loading bit value to the register
out DDRB, r16 ; Writing to "Data Direction register for port B" the bit value that we loaded above.
