;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2019-09-22 16:47:08
;   Author: Andrei Neagu (an223kj)
;           Konstantinos Tatsis (kt222iq)
;
;   Lab number:         2
;   Title:              Change Counter
;   
;   Hardware:           STK600, CPU ATmega2560
;
;   Function:			Displays and increases the binary value every time led 0 is pressed on/off	
;
;   Input ports:		PORTA
;
;   Output ports:       PORTB
;
;   Subroutines:        Activated, main
;
;   Included files:     m2560def.inc
;
;   Other information:  Ring counter with a delay of 500ms
;
;   Changes in program: 2019-09-22 
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


.include "m2560def.inc"

; Initialize Input/Output
ldi r20, 0b0000_0000 ;load 0 (Decimal value) to r20
out DDRA, r20 ; Set PORTA as an input with the value of r20
ldi r20, 0b1111_1111  ;load 255 (Decimal value) to r20
out DDRB, r20 ; Set PORTB as an input with the value of r20
ldi r25, 0b0000_0000 ;load 0 (Decimal value) to r25

;Move to main subroutine check switch
main:
	in r24, PINA  ; Read from PINA and write it to r24
	cpi r24, 0b1111_1110 ; IF r24 equals that binary value "0b1111_1110" then
	breq activated ; branch to pressed subroutine
rjmp main 

activated:
	inc r25 ; increase r25 by 1 decimal value
	com r25 ; complement/ flip the value of r25
	out PORTB, r25 ; Output the value of r25 to PORTB
	com r25 ; complement/ flip the value of r25

loop:  
	in r24, PINA ; Read from PINA and write it to r24
	cpi r24, 0b1111_1111  ; IF r24 not equals that binary value "0b1111_1111" then
	brne loop ; branch to loop subroutine
	
	inc r25 ; increase r25 by 1 decimal value
	com r25  ; complement/ flip the value of r25
	out PORTB, r25 
	com r25
rjmp main ; jump back to main
