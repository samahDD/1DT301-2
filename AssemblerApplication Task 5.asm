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
;   Function:           Ring counter with a delay of 500ms
;
;   Input ports:
;
;   Output ports:       PORTB
;
;   Subroutines:       Delay
;
;   Included files:     m2560def.inc
;
;   Other information:  Ring counter with a delay of 500ms
;
;   Changes in program:
;						2019-09-09
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
 .include "m2560def.inc"

 ldi R20, HIGH (RAMEND)
 out SPH, R20

 ldi R20, low(RAMEND)
 out SPL, R20

 ldi r16, 0xFF ;PORTB output
 out DDRB, r16

 ldi r17, 0b1111_1110 ;initial led state
 out PORTB, r17

 loop:
	 out PORTB, r17 ; initial led state
	 CALL Delay     ; delay of 0.5sec
	 com r17        ; this instruction performs a one's complement of register Rd.
	 LSL r17        ; shifts all bits in Rd one place to the left. Bit 0 is cleared
	 com r17        ; one's complement again
rjmp loop

Delay:
	 ldi r18, 21    ; 500ms delay achieved using calculator
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
