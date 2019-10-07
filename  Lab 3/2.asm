; Replace with your application code
;
; AssemblerApplication2Lab3.asm
;
; Created: 2019-09-29 17:19:53
; Author : kt222iq
;


; Replace with your application code

.include "m2560def.inc"

	.def leds = r16
	.def decider = r22
	.def settings = r17

	
	.org 0x00				;constant to "store/load" to EIMSK address / sets interrupt 
	rjmp start

	.org INT0addr
	rjmp interrupt_0		
	.org 0x72

start: 										
	ldi r20, HIGH (RAMEND)  ;Initialize the STACK
	out SPH, R20
	ldi r20, low (RAMEND)
	out SPL, R20

	ldi settings, 0xFF		;Load value "0xFF" to register "settings"
	out DDRB, settings		;Output value of settings register to PORTA
	ldi settings, 0x00		;Load value "0x00" to register "settings"
	out DDRD, settings

	ldi leds, 0xFE			;Load value "0xFE" to register "leds"
	ldi decider, 0x00		;Load value "0x00" to register "decider"
 
	ldi settings, 0b0000_0001 	;Load value .... to settings register
	out EIMSK, settings			;Output the value of register settings to the External Interrupt Mask Register"
	ldi settings, 0b0000_0010	;Load value ... to "settings" register.
	sts EICRA, settings			;"Store Direct to data space" --> load value of register settings to the "External Interrupt Control"

sei 							;enables the "Set Global Interrupt Flag"


ring:		; RING COUNTER subroutine		
		cpi decider, 0xFF		;If value "0xFF" is load to register Decider then
		breq reset_john			;Go to subroutine "reset_John"

		cpi leds, 0xFF			;If value "0xFF" is loaded to register leds
		breq fixLedsOff			;Go to "fixLedsOff"

		out PORTB, leds			
		com leds
		lsl leds				;Shifts the bits to leds register
		com leds				;Complement/flip the value of leds
		rcall delay				;Call delay subroutine
rjmp ring					    ;Go back to ring subroutine
	
	fixLedsOff:					
		ldi leds, 0xFE			
		rjmp ring				

; JOHNSON COUNTER
johnson_on:				
	cpi decider, 0x00	;if the value is loaded then
	breq reset_ring		; then branch to "reset_ring"

	cpi leds, 0x00		
	breq johnson_off

	out PORTB, leds
	lsl leds
	rcall delay
rjmp johnson_on

johnson_off:		
	cpi decider, 0x00
	breq reset_ring

	out PORTB, leds
	cpi leds, 0xFF
	breq johnson_on
	com leds			;Complement/flip the value of leds
	lsr leds			;"Logical shift to the right" shifts the value in register leds
	com leds			
	rcall delay
rjmp johnson_off


; Generate by delay loop
delay:
	ldi r18, 3
	ldi r19, 138
	ldi r21, 86
L1: dec r21
	brne L1
	dec r19
	brne L1
	dec r18
	brne L1
	rjmp PC+1
ret	;Return to where the call was made

interrupt_0:
	com decider	;Flip the value of decider
	reti 		;Return from the interrupt

reset_ring:
	ldi leds, 0xFF
	out PORTB, leds
	rjmp ring

reset_john: 
	ldi leds, 0xFF
	out PORTB, leds
	rjmp johnson_on
