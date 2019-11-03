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
; Function: Rear lights with a brake
;
; Input ports: PORTD
;
; Output ports: PORTB
;
; Subroutines: start, main, leds, delay
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

.include "m2560def.inc"

.org 0x00				; setup interrupts
rjmp start

.org INT0addr
rjmp interrupt_0

.org INT2addr
rjmp interrupt_2

.org INT3addr
rjmp interrupt_3

.org 0x72
start:

ldi mr, 0b00001101		; enable interrupt 0, 2, 3
out EIMSK, mr

ldi mr, 0b00000000		; interrupt request setup
sts EICRA, mr

ldi mr , 0x00			; PORTD is set as an input
out DDRD, mr
sei						; set global interrupt enable



ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address

.DEF mr = r16
.DEF mri = r17
.DEF flag1 = r22
.DEF flag2 = r23
.DEF flag3 = r24
.DEF flag4 = r25

on:
ser flag1				; Loads $FF directly to register
ser flag2				; Loads $FF directly to register
ser flag3				; Loads $FF directly to register 
clr flag4				; Clear flag4

ldi mr,0xFF				
out DDRB, mr
ldi r16, 0b00111100		; LED0,1,6,7 are lit
out PORTB, mr
rjmp on

turnRight:
clr flag1
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address

ldi mr , 0xFF
out DDRB, mr

RingCounter:

start1:
	ldi mri, 0b00110111 ; LED7,6 and 3 lit
	out PORTB, mri
	rcall delay
		ldi mr,	 0b0000_1100
myloop:
	eor mri, mr				; exclusive or between mr and mri
	out PORTB,mri
	lsr mr					; shift right the bits in mr

	cpi mri, 0b0011_1111	; if equal do ring counter again
	breq RingCounter
	rcall delay
	rjmp myloop				; when this is reached do it again

turnLeft:
clr flag2
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address
ldi mr , 0xFF
out DDRB, mr

RingCounter2:

start2:
	ldi mri, 0b1110_1100  ; LED4,1 and 0 lit
	out PORTB, mri
	rcall delay
	ldi mr,	 0b0011_0000
myloop2:
	eor mri, mr				; exclusive or between mr and mri
	out PORTB,mri
	lsl mr					; shift left the bits

	cpi mri, 0b1111_1100
	breq RingCounter2		; if equal do ring counter again
	rcall delay
	rjmp myloop2			; when this is reached do it again

	

breakWhenOn:
clr flag3					; used for leds
ser flag4					;set to xFF
  ldi mr,0xFF
  out DDRB, mr				
  out PORTB, flag3			; lights all leds
  rjmp breakWhenOn

turnLeftBreak:
clr flag4 //claring flag4
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address
ldi mr , 0xFF
out DDRB, mr
RingWithBreak1:			; ring couter that starts at led 4 and goes left
start3:
	ldi mri, 0b1110_0000 
	out PORTB, mri
	rcall delay
	ldi mr,	 0b0011_0000
myloop3:
	eor mri, mr			; exclusive or between mri and  mr
	out PORTB,mri
	lsl mr				; shift bits to the left
	cpi mri, 0b1111_0000	
	breq RingWithBreak1
	rcall delay
	rjmp myloop3


turnRightBreak:
clr flag4 
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address
ldi mr , 0xFF
out DDRB, mr

RingWithBreak2:
start4:
	ldi mri, 0b0000_0111 ; ring couter that starts at led 3 and goes right
	out PORTB, mri
	rcall delay
	ldi mr,	 0b0000_1100
myloop4:
	eor mri, mr			; exclusive or between mri and  mr
	out PORTB,mri
	lsr mr
	cpi mri, 0b0000_1111
	breq RingWithBreak2
	rcall delay
	rjmp myloop4

interrupt_0:			; starts when button 0 is pressed goes right
sei
cpi flag4, 0xff
breq turnRightBreak
cpi flag1, 0xff
breq turnRightAux
brne idle

interrupt_2:			; starts when button 2 is pressed
sei
cpi flag3 ,0xff
breq breakWhenOn
brne idle

interrupt_3:			; starts when button 3 is pressed goes left
sei
cpi flag4, 0xff
breq turnLeftBreak
cpi flag2, 0xff
breq turnLeftAux
brne idle

turnRightAux:			; helper
	rjmp turnRight
turnLeftAux:			; helpe
	rjmp turnLeft

idle:					; helper
	rjmp on

delay:
ldi  r18, 5
ldi  r19, 15
ldi  r20, 242
	L1: dec  r20
	brne L1
	dec  r19
	brne L1
	dec  r18
	brne L1
ret
