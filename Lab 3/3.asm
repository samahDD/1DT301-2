;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2019-10-02
; Author:
; Andrei Neagu
; Konstantinos Tatsis
;
; Lab number: 3
; Title: How to use interrupts
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Rear lights of a car
;
; Input ports: PORTD
;
; Output ports: PORTB
;
; Subroutines: start, main
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.def onleds = r22
.def leds = r21
.def LeftFlag = r24
.def RightFlag = r23

.org 0x00		; constant to "store/load" to EIMSK address /set interrupt_0
rjmp start

.org INT0addr
rjmp interrupt_0
.org INT3addr
rjmp interrupt_3

.org 0x72		; set interrupt_3

start:
ldi r16, 0b1111_1111	;Load value "0b1111_1111" to register "r16"
out DDRB, r16			;Output value of "r16" register to PORTA
ldi RightFlag, 0b0000_0000	;Load value 1 to RightFlag
ldi LeftFlag, 0b0000_0000
ldi R20, HIGH (RAMEND)
out SPH, R20

ldi R20, low (RAMEND)		;Initialize Stack Pointer
out SPL, R20
ldi r16, 0b0000_1001
out EIMSK, r16
ldi r16, 0b1000_0010		
sts EICRA, r16				;"Store Direct to data space" --- Load value of register to the "External interrupt Control"
sei							;Enables the "set Global interrupt flag"

Main:
ldi onleds, 0b0011_1100		;Load value of 0b0011_1100 to onleds
out PORTB, onleds			;Light leds for "STATE 1"

checkMain:					
cpi RightFlag, 0b1111_1111	;If 0b1111_1111 is loaded to RightFlag
breq Right				;then go to "MainRight sub"
cpi LeftFlag, 0b1111_1111	;If 0b1111_1111 is loaded to LeftFlag
breq Left				;then Go to "MainLeft"

rjmp checkMain				;Else jump to main / leave "STATE 1" lights on

interrupt_0:				
com RightFlag				;Complement/flip the value of leds
clr LeftFlag				;Clear LeftFlag register
reti						;Return from the "interrupt_0"

interrupt_3:				
com LeftFlag				;Same as "interrupt_0"
clr RightFlag				
reti


Left:
	ldi onleds, 0b0000_0011		;Load value "0b0000_0011" to onleds
						
	loadCounterL:
	ldi r17, 0b0001_0000

	loopLeft:

	cpi LeftFlag, 0x00		;If 1 is loaded to LeftFlag
	breq Main				;Branch to "Main subroutine"
	cpi RightFlag, 0xFF		;Same for MainRight subroutine
	breq Right			

	mov leds, onleds		;Copy Register the value of "onleds" to leds
	add leds, r17			;Add the value of the register
	com leds				;Complement/flip the value of leds
		
	out PORTB, leds			;Light to PORTB the value of leds
	rcall delay				;Call delay

	lsl r17					;Shift all bits to the left from value of r17
	cpi r17, 0b0000_0000	;If value 1 is loaded to r17
	breq loadCounterL		;Branch to "loadCounter"

	rjmp loopLeft


Right:
	ldi onleds, 0b1100_0000	;SAME for "MainRight" as "MainLeft"

	loadCounter:
	ldi r17, 0b0000_1000

	loopright:
	cpi RightFlag, 0b0000_0000
	breq Main
	cpi LeftFlag, 0b1111_1111
	breq Left

	mov leds, onleds
	add leds, r17
	com leds

	out PORTB, leds
	rcall delay

	lsr r17
	cpi r17, 0b0000_0000
	breq loadCounter

	rjmp loopright

delay:

	ldi r18, 3
	ldi r19, 138
	ldi r20, 86
L1: dec r20
	brne L1
	dec r19
	brne L1
	dec r18
	brne L1
	rjmp PC+1
ret

