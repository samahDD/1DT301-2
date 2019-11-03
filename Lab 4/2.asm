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
; Function: Task2
;
; Input ports:
;
; Output ports: PORTB
;
; Subroutines: reset, loop, again, increase, decrease, timer0_int
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.def temp = r16
.def ledCounter = r17
.def counter = r18
.def LEDstate = r22
.def switch0 = r23
.def switch1 = r24

.org 0x00
rjmp start

.org INT1addr
rjmp increase

.org INT2addr
rjmp decrease

.org OVF0addr
jmp timer0_int

.org 0x72
start:
	ldi temp, HIGH(RAMEND) ; initialize SP, Stackpointer
	out SPH, temp
	ldi temp, LOW(RAMEND)
	out SPL, temp

	ldi temp, 0x01			;set DDRB as output
	out DDRB, temp

	ldi ledState, 0x01
	out PORTB, ledState		;light LED0

	ldi temp, 0x05			; prescaler value to TCCR0
	out TCCR0B, temp		; CS2 - CS2 = 101, osc.clock / 1024

	ldi temp, (1<<TOIE0)	; Timer 0 enable flag, TOIE0
	sts TIMSK0, temp		; to register TIMSK

	ldi temp, 205			; starting value for counter
	out TCNT0, temp			;50MS

	ldi temp, 0b0000_0110	;enable INT1 and INT2
	out EIMSK, temp

	ldi temp, 0b0011_1100	; set RISING edge for INT1 and INT2
	sts EICRA, temp
	sei						; enable global interrupt

	clr counter
	ldi ledCounter,10

loop:
	rjmp loop

increase:
	cpi ledCounter,20		;increases ledcounter until it is 20
	breq retiInc
	inc ledCounter
	retiInc:
	reti

decrease:					;decreases ledcounter until it is 0
	cpi ledCounter,0
	breq retiDec
	dec ledCounter
	retiDec:
	reti

timer0_int:
	push temp		; timer interrupt routine
	in temp, SREG	; save SREG on stack
	push temp

	ldi temp, 205 ; starting value for counter
	out TCNT0, temp

	inc counter

	cp ledCounter, counter	;this achieves the PWM effect
	brge turn_off
	clr temp
	out PORTB, temp
	rjmp end

	turn_off:
	ser temp			;turns off the led
	out PORTB, temp

	end:				;when this is reached timer0e_int nds
	cpi counter,20
	brne again
	clr counter

	again:
	pop temp		; restore SREG
	out SREG, temp
	pop temp		 ; restore register


reti
