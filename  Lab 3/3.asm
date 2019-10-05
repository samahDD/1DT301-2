;
; AssemblerApplication3Lab3.asm
;
; Created: 2019-09-29 18:06:14
; Author : kt222iq
;


; Replace with your application code
.include "m2560def.inc"

.def leds = r25
.def onleds = r20
.def LeftFlag = r24
.def RightFlag = r23
.org 0x00

rjmp start
.org INT0addr

rjmp interrupt_0
.org INT3addr

rjmp interrupt_3
.org 0x72

; Start subroutine
start:
ldi r16, 0b1111_1111
out DDRB, r16
ldi RightFlag, 0b0000_0000
ldi LeftFlag, 0b0000_0000
ldi r20, HIGH (RAMEND)
out SPH, R20
ldi R20, low (RAMEND)
out SPL, R20
ldi r16, 0b0000_1001
out EIMSK, r16
ldi r16, 0b1000_0010
sts EICRA, r16
sei


Main:
ldi onleds, 0b0011_1100
out PORTB, onleds

checkMain:
cpi RightFlag, 0b1111_1111
breq MainRight
cpi LeftFlag, 0b1111_1111
breq MainLeft

rjmp checkMain

interrupt_0:
com RightFlag
clr LeftFlag
reti

interrupt_3:
com LeftFlag
clr RightFlag
reti

MainLeft:
	ldi onleds, 0b0000_0011

	loadCounterL:
	ldi r17, 0b0001_0000

	loopLeft:

	cpi LeftFlag, 0b0000_0000
	breq Main
	cpi RightFlag, 0b1111_1111
	breq MainRight

	mov leds, onleds
	add leds, r17
	com leds

	out PORTB, leds
	rcall delay

	lsl r17
	cpi r17, 0b0000_0000
	breq loadCounterL

rjmp loopLeft

MainRight:
	ldi onleds, 0b1100_0000
	
	loadCounter:
	ldi r17, 0b000_1000

	loopright:
	cpi RightFlag, 0b0000_0000
	breq Main
	cpi LeftFlag, 0b1111_1111
	breq MainLeft

	mov leds, onleds
	add leds, r17
	com leds

	out PORTB, leds
	rcall delay

	lsr r17
	cpi r17, 0b0000_0000
	breq loadCounter ;;;;;;

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
