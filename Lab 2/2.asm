;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;   1DT301, Computer Technology I
;   Date: 2019-09-21 14:20:40
;   Author: Andrei Neagu (an223kj)
;           Konstantinos Tatsis (kt222iq)
;
;   Lab number:         2
;   Title:              Electronic Dice
;
;   Hardware:           STK600, CPU ATmega2560
;
;   Function:           Lights the led in a random generated way when you press switch (0).
;
;   Input ports:		PORTA
;
;   Output ports:       PORTB
;
;   Subroutines:		Display, Button, one, two..
;
;   Included files:     m2560def.inc
;
;   Other information: -
;
;   Changes in program: 2019-09-21 14:20:40
;
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

ldi r20, 0b1111_1111 ; Load to r20 the binary value
out DDRB, r20 ; Output the loaded value to PORTB

ldi r23,0b0000_0001 ;load to r23 the binary value

; Dice loop
loop:     
in r22, PINA ; Read PINA
cpi r22, 0b1111_1110 ; IF PINA equals to " 0b1111_1110"
breq button ; Then branch to button subroutine
rjmp loop;


;PRESSING SWITCH 
button:
inc r23 ; it increases the value in r23 --> 0b0000_0001 which is 1 in decimal
cpi r23, 7 ; if the load value in r23 is 7 then
breq modulo6 ; branch to subroutine modulo6

check: 
in r22, PINA ; read PORTA and write to r22
cpi r22, 0b1111_1111 ; IF r22 equals to "0b1111_1111"
breq display ; then branch to display subroutine

rjmp button

modulo6: 
ldi r23, 0b0000_0001  ; load to r23 the binary value of 1
rjmp check  ; jump to check subroutine


;OUTPUT RESULT 
display: 
cpi r23, 1 ; if r23 equals to 1
breq one ; go to subroutine one 

cpi r23, 2 ; same as subroutine "one"
breq two

cpi r23, 3
breq three

cpi r23, 4
breq four

cpi r23, 5
breq five

cpi r23, 6
breq six


; DISPLAY RESULT
one:
ldi r21, 0b0001_0000 ; Display random value 1
out DDRB, r21 ;  Output the loaded value to PORTA
rjmp loop

two:
ldi r21, 0b1001_1000 ; Display random value 2
out DDRB, r21 ; Output the loaded value to PORTA
rjmp loop

three:
ldi r21, 0b0011_0000 ; etc
out DDRB, r21
rjmp loop

four:
ldi r21, 0b1111_1000
out DDRB, r21
rjmp loop

five:
ldi r21, 0b0001_1100
out DDRB, r21
rjmp loop

six:
ldi r21, 0b1001_0010
out DDRB, r21
rjmp loop
