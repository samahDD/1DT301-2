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

 start:
 ldi r16, 0x0000_0001		;initial led state
 out DDRB, R16				;initial output to LED0
 rcall delay				;call delay of 500ms
 

 loop:
 lsl R16					;shift bits to the left
 out DDRB, R16				;output of shifted value again
 cpi R16, 0x00				;if r16 equals to 0x00 then restart loop 
 breq again					;by going to again
 rcall delay				;delay again
 rjmp loop					;repeat if not equal to 0x00

 again:
 rjmp start


 delay:						;this delay is approx 500ms
	ldi  r18, 5
    ldi  r19, 15
    ldi  r20, 242
L1: dec  r20
    brne L1
    dec  r19
    brne L1
    dec  r18
    brne L1

   
RET
