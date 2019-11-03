;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 1DT301, Computer Technology I
; Date: 2019-10-12
; Author:
; Andrei Neagu
; Konstantinos Tatsis
;
; Lab number: 3
; Title: Timer and UART
;
; Hardware: STK600, CPU ATmega2560
;
; Function: Serial communication Task5
;
; Input ports:
;
; Output ports: PORTB
;
; Subroutines: reset, main_loop, data_received_interrupt, buffer_empty_interrupt
; led_output
; Included files: m2560def.inc
;
; Other information:
;
; Changes in program: (Description and date)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
.include "m2560def.inc"

.def temp = r16
.def ledState = r17
.def complement = r18
.def dataReceived = r19

.equ TRANSFER_RATE = 12 	;1MHz, 4800 bps
.equ TRUE = 0x01
.equ FALSE = 0x00

.cseg

.org 0x00
rjmp reset

.org URXC1addr
rjmp data_received_interrupt

.org UDRE1addr
rjmp buffer_empty_interrupt

.org 0x72

reset:

ldi temp, LOW(RAMEND)
out SPL, temp
ldi temp, HIGH(RAMEND)
out SPH, temp

ser temp
out DDRB, temp

ldi temp, TRANSFER_RATE
sts UBRR1L, temp

ldi temp, (1<<RXEN1) | (1<<TXEN1) | (1<<RXCIE1) | (1<<UDRIE1)
sts UCSR1B, temp

sei
clr ledState


main_loop:
	rcall led_output
	rjmp main_loop

led_output:
	mov complement, ledState
	com complement
	out PORTB, complement

	ret

data_received_interrupt:
	lds ledState, UDR1		;load received data to ledState
    ldi dataReceived, TRUE

    reti

buffer_empty_interrupt:
    cpi dataReceived, FALSE
    breq buffer_empty_end

	sts UDR1, ledState	;send data
	ldi dataReceived, FALSE

    buffer_empty_end:
        reti
