;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2019-09-22
;   Author: Andrei Neagu (an223kj)
;           Konstantinos Tatsis (kt222iq)
;
;   Lab number:         2
;   Title:             Learn how to program and use subroutines with Assembly Language
;
;   Hardware:           STK600, CPU ATmega2560
;
;   Function:           Delay subroutine with variable delay time
;
;   Input ports:
;
;   Output ports:       PORTB
;
;   Subroutines:       delay, wait_miliseconds
;
;   Included files:     m2560def.inc
;
;   Other information:  Ring counter with a delay of 500ms
;
;   Changes in program:
;				
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"


; INITIALIZE STACK
ldi r18, HIGH (RAMEND)
out SPH, r18
ldi r18, LOW (RAMEND)
out SPL, r18

; Set DDRB as output
ldi r17, 0b1111_1111
out DDRB, r17

ldi r16, 0b1111_1111			; r16 is used in the ring counter

main:
	ring:
		ldi r24, LOW(1000)		; value for the register pair
		ldi r25, HIGH(1000) 
		cpi r16, 0b1111_1111   ; if equal go to again
		breq again

		out PORTB, r16

		com r16
		lsl r16				; shift the bits to the left
		com r16

		rcall wait_milliseconds	; call the subroutine with r25:24	
    rjmp ring

	again:
	ldi r16, 0b1111_1110	; this is used when the counter has reached the end

rjmp main

wait_milliseconds:


delay:						

    ldi  r18, 2
    ldi  r19, 75
L1: dec  r19
    brne L1
    dec  r18
    brne L1
    rjmp PC+1


	sbiw r25:r24,1		; subtract 1 from r25:24 and if not equal branch to delay
	brne delay

RET

