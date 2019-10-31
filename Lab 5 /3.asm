;
; AssemblerApplication3.asm
;
; Created: 2019-10-21 21:31:53
; Author : an223kj
;
; Replace with your application code



.include "m2560def.inc"
.def Temp = r16
.def Data = r17
.def RS = r18

.equ BITMODE4 = 0b000_0010
.equ CLEAR = 0b0000_0001
.equ DISPCTRL = 0b0000_01111

.cseg
.org 0x0000
jmp reset

.org URXC1addr
rjmp get_char

.org 0x0072

reset:

ldi Temp, HIGH(RAMEND)
out SPH, Temp
ldi Temp, LOW (RAMEND)
out SPL, Temp

ser Temp 
out DDRE, Temp
clr Temp
out PORTE, Temp

ldi Temp, 12
sts UBRR1L, Temp

ldi Temp, (1<<TXEN1) | (1<<RXEN1) | (1<<RXCIE1)
sts UCSR1B, Temp

	sei
	rcall init_disp
loop:
	nop
	rjmp loop


init_disp:
	rcall power_up_wait

	ldi Data, BITMODE4
	rcall write_nibble
	rcall short_wait
	ldi Data, DISPCTRL
	rcall write_cmd
	rcall short_wait

clr_disp:
	ldi Data, CLEAR
	rcall write_cmd
	rcall long_wait
	ret


write_char:
	ldi RS, 0b0010_0000
	rjmp write
write_cmd:
	clr RS
write:
	mov Temp, Data
	andi Data, 0b1111_0000
	swap Data
	or Data, RS
	rcall write_nibble
	mov Data, Temp
	andi Data, 0b0000_1111
	or Data, RS

write_nibble:
	rcall switch_output
	nop 
	sbi PORTE, 5
	nop
	nop
	cbi PORTE, 5
	nop
	nop
	ret


short_wait:
	clr zh
	ldi zl,30
	rjmp wait_loop

long_wait:
	ldi zh, HIGH(1000)
	ldi zl, LOW(1000)
	rjmp wait_loop


dbnc_wait:
	ldi zh, HIGH (4600)
	ldi zl, LOW (4600)
	rjmp wait_loop


power_up_wait:
ldi zh, HIGH (9000)
ldi zl, LOW (9000)

wait_loop:
	sbiw z, 1
	brne wait_loop
	ret

switch_output:
	push Temp
	clr Temp
	sbrc Data, 0
	ori Temp, 0b0000_0100
	sbrc Data, 1
	ori Temp, 0b0000_1000
	sbrc Data, 2
	ori Temp, 0b0000_0001
	sbrc Data, 3
	ori Temp, 0b0000_0010
	sbrc Data, 4
	ori Temp, 0b0010_0000
	sbrc Data, 5
	ori Temp, 0b1000_0000
	out porte, Temp
	pop Temp
	ret

get_char:
	lds Temp, UCSR1A
	sbrs Temp, RXC1
	rjmp get_char

	lds Data, UDR1

	rcall short_wait
	rcall display
	reti

diSplay:
	rcall write_char
	ret



