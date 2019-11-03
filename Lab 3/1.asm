;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2019-09-30
; Author:
; Andrei Neagu
; Konstantinos Tatsis
;
; Lab number: 3
; Title: How to use interrupts
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Turn LED0 on and off with interrupts
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

.org 0x00				;setup interrupt vectors
rjmp start				;

.org INT0addr
rjmp leds

.org 0x72				; program start
start:
ldi r20, HIGH(RAMEND)	; R20 = high part of RAMEND address
out SPH,R20				; SPH = high part of RAMEND address
ldi R20, low(RAMEND)	; R20 = low part of RAMEND address
out SPL,R20				; SPL = low part of RAMEND address

ldi r16, 0x00			; set PORTD as input
out DDRD,r16   

ldi r16, 0x01			; set PORTB1 as output
out DDRB, r16

ldi r16, 0b0000_0001	;enable INT0, interrupt 0 
out EIMSK, r16

ldi r16, 0b0000_0010	;set EICRA(INT0-3) to to falling edge
sts EICRA, r16
sei						;Sets the Global Interrupt flag (I) in SREG (status register) to enable

ldi r16, 0b0000_0001	;used for led display
main:
nop						;wait
rjmp main

leds:
com r16
out PORTB, r16			; turn on LED0

ldi r22, 200			;my delay
delay:
dec r22
cpi r22,0
brne delay
reti
