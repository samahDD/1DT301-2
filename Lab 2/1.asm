;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2019-09-22
;   Author: Andrei Neagu (an223kj)
;           Konstantinos Tatsis (kt222iq)
;
;   Lab number:         2
;   Title:              Switch – Ring counter / Johnson counter
;
;   Hardware:           STK600, CPU ATmega2560
;
;   Function:           Switches between a ring counter and johnson counter
;
;   Input ports:		PORTA
;
;   Output ports:       PORTB
;
;   Subroutines:	    delay, loop, ring_counter, johnson_counter, switch_ring, switch_johnson
;
;   Included files:     m2560def.inc
;
;   Other information: 
;
;   Changes in program: 2019-09-22
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

ldi r21, HIGH(RAMEND)		;initialize the stack pointer
out SPH,R21 
ldi R21, low(RAMEND) 
out SPL,R21 

ldi r16, 0xFF				; set the DDRB as output
out DDRB, r16 

ldi r20, 0b11111110			; register used to check if SW0 is pressed
 
loop:	
	rcall switch_johnson    ; if SW0 is pressed switch to johnson
 
ring_counter:
	ldi r18, 0b11111110		; the program starts with the ring counter
	call ring_loop

ring_loop:
	out PORTB, r18			; LED0 lights up
	call Delay				; delay of 500ms
	com r18					
	LSL r18					; shift the bits to left
	com r18

	ldi r24,0xFF			
	cp r24, r18				; if the lights reach the end start again with the ring
	breq ring_counter
	
	rcall switch_johnson	; check if SW0 is pressed and go to johnson
	rjmp ring_loop

rjmp loop					; if this is reached go to the start again

johnson_counter : 	
	ldi r19, 0b1111_1110	
	ldi r22, 0b0000_0000

johnson_loop:
	out PORTB, r19			; light first led
	LSL r19					; shift the bits to left
	call Delay				; delay of 500ms
	cp r19, r22				; if the end was reached go to forward
	breq johnson_forward

	rcall switch_ring		; if SW0 is pressed switch to ring
	rjmp johnson_loop		; if this is reached go to the start of johnson

johnson_forward :			; this is the johnson main logic for the second loop
	out PORTB, r22
	ldi r22, 0b11111111
	call Delay
	ldi r19,0b10000000

	johnson_secondary: 
		out PORTB, r19
		ASR r19				; switch the bits to the right
		call Delay 
		cp r19, r22
		breq johnson_counter

		rcall switch_ring		; if SW0 is pressed switch to ring
		rjmp johnson_secondary	; go back to the secondary loop

 switch_johnson:					; checks if SW0 is pressed and if so goes to johnson_counter
		in r16, PINA
		cp r20,r16
		breq johnson_counter
		ret
	 
 switch_ring:					; checks if SW0 is pressed and if so goes to ring_counter
		in r16, PINA
		cp r20,r16
		breq ring_counter
		ret

 Delay :						;this delay is approx 500ms
	ldi  r21, 5
    ldi  r23, 15
    ldi  r24, 242
L1: dec  r24
    brne L1
    dec  r23
    brne L1
    dec  r21
    brne L1
	ret