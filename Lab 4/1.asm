;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2019-10-10
; Author:
; Andrei Neagu
; Konstantinos Tatsis
;
; Lab number: 3
; Title: Timer and UART
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Square wave generator Task1
;
; Input ports:
;
; Output ports: PORTB
;
; Subroutines: reset, loop, again, led, timer0_int
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.def temp = r16
.def ledState = r17
.def counter = r18

.org 0x00
rjmp reset

.org OVF0addr
rjmp timer0_int

.org 0x72
reset:

ldi temp, LOW(RAMEND)	;initialize stack pointer
out SPL, temp
ldi temp, HIGH(RAMEND)
out SPH, temp

ldi temp, 0x01			; set DDRB as output
out DDRB, temp

ldi temp, 0x05			; prescaler value to TCCR0B
out TCCR0B, temp		;0b101 means clock/1025

ldi temp, (1<<TOIE0)	;enable overflow flag
sts TIMSK0, temp		; to TIMSK

ldi temp, 5				; starts from 5 to 255 meaning 250 times
out TCNT0, temp			; until overflow

sei
clr ledState			; clear ledstate used for outputting to leds

loop:
	out PORTB, ledState
	rjmp loop

timer0_int:
	in temp, SREG	; save sreg in SP
	push temp

	;set start value for timer so next interrupt occurs after 250 ms
	ldi temp, 5
	out TCNT0, temp
	inc counter
	cpi counter, 2 			; if counter is 2 then 0,5 sec have passed
	breq led				; then branch to change_led_state

	rjmp again

	led:
		com ledState 		; toggle LED0
		clr counter			; reset counter to 0

	again:
		pop temp			; save sreg in SP
		out SREG, temp
		reti
