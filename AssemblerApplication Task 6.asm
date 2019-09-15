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
;   Function:           Program with Johnson Counter with an infinite loop
;
;   Input ports:
;
;   Output ports:       PORTB
;
;   Subroutines:        Delay
;
;   Included files:     m2560def.inc
;
;   Other information:  Program with Johnson Counter with an infinite loop
;
;   Changes in program:
;						2019-09-09
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 .include "m2560def.inc"

 ldi r20, HIGH (RAMEND)
 out SPH, R20          ; SPH high part of the RAMEND
 ldi R20, low (RAMEND)
 out SPL, R20          ; SPL low pard of RAMEND

 ldi r16, 0xFF
 out DDRB, r16         ; DDRB is set as an output port

 ldi r21, 0b1111_1110  ; initial led state
 ldi r22, 0xFF         ; leds off
 ldi r23, 0x00         ; leds on

 loop:
	 out PORTB, r21  ; initial led state
	 LSL r21         ; shift leds to left
	 CALL Delay      ; delay of 500ms

	 cp r21, r23     ; when r21 equals to r23 go to light
	 breq light
rjmp loop


light:
	 out PORTB, r23        ; leds on
	 CALL Delay            ; delay of 500ms
	 ldi r21, 0b1000_0000  ; initialize the leds to go to the right
	 out PORTB, r21
	 Sec_loop:
			out PORTB, r21     ; initialize the leds to go to the right
			ASR r21            ; shift the bits to the right
			CALL Delay         ; delay of 500ms
			cp r21, r22        ; if r21 equals r22 go back to loop
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
