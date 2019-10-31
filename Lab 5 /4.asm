;
; AssemblerApplication4.asm
;
; Created: 2019-10-22 17:18:18
; Author : kt222iq
;


; Replace with your application code
.include "m2560def.inc"

.equ BITMODE4 = 0b0000_0010
.equ CLEAR = 0b0000_00001
.equ DISPCTRL = 0b0000_1111
.equ MEMORY = 0x600

.def Temp = r16
.def Data = r17
.def RS = r18
.def Temp2 = r19
.def counter = r20

.cseg
.org 0x0000
jmp reset

.org URXC1addr
rjmp get_char

.org 0x0072

reset: 
ldi Temp, HIGH (RAMEND)
out SPH, Temp
ldi Temp, LOW (RAMEND)
out SPL, Temp

ser Temp
out ddre, Temp
clr Temp
out porte, Temp

ldi Temp2, 12
sts UBRR1L, Temp2
ldi Temp2, (1<<TXEN1) | (1<<RXEN1)
sts UCSR1B, Temp2

ldi XH, HIGH (MEMORY)
ldi XL, LOW (MEMORY)

rcall init_disp

get_char:
lds Temp, UCSR1A
lds Data, UCSR1A
sbrs Temp, RXC1
rjmp get_char
lds Temp, UDR1

put_char:
mov Data, Temp
sbrs Data, UDRE1
rjmp put_char
st X+, Data
sts UDR1, Temp

inc counter
cpi counter, 140
brne get_char

main:
rcall clr_disp
rcall firstline
rcall print_one
rcall delay

rcall clr_disp
rcall secondline
rcall print_one

rcall firstline
rcall print_two
rcall delay

rcall clr_disp
rcall secondline
rcall print_two
rcall firstline
rcall print_three
rcall delay

rcall clr_disp
rcall secondline
rcall print_three
rcall firstline
rcall print_four
rcall delay

rjmp main 
ret

print_one:
init1:
ldi counter, 0
ldi XH, HIGH(MEMORY)
ldi XL, LOW(MEMORY)
print1:
ld Data, X+
rcall Write_char
rcall long_wait
inc counter
cpi counter, 40
brne print1
ret

print_two:
init2:
ldi counter, 0
ldi XH, HIGH (MEMORY+40)
ldi XL, LOW (MEMORY+40)
print2:
ld Data, X+
rcall write_char
rcall long_wait
inc counter
cpi counter, 40
brne print2
ret

print_three:
init3:
ldi counter, 0
ldi XH, HIGH (MEMORY+80)
ldi XL, LOW (MEMORY+80)
print3:
ld Data, X+
rcall write_char
rcall long_wait
inc counter
cpi counter, 40
brne print3
ret

print_four:
init4:
ldi counter, 0
ldi XH, HIGH (MEMORY+120)
ldi XL, LOW (MEMORY+120)
print4:
ld Data, X+
rcall write_char
rcall long_wait
inc counter
cpi counter, 40
brne print4
ret

firstline:
ldi Data, 128
rcall write_cmd
rcall short_wait
ldi counter, 0x00
ret

secondline:
ldi Data, 168
rcall write_cmd
rcall short_wait
ldi counter, 0x00
ret

delay:
	push r21
		push r22
		push r23

	ldi r21, 26
	ldi r22, 94
	ldi r23, 111

L1: dec r23
		brne L1
		dec r22
		brne L1
		dec r21
		brne L1

			pop r23
			pop r22
		pop r21
	ret
	
init_disp:
rcall power_up_wait
ldi Data, BITMODE4
rcall write_nibble
rcall short_wait
ldi Data, DISPCTRL
rcall write_cmd
rcall short_wait

rcall clr_disp

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
	or Data, Rs
	rcall write_nibble
	mov Data, Temp
	andi Data, 0b0000_1111
	or Data, RS
Write_nibble:
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
 ldi zl, 30
 rjmp wait_loop
 
 long_wait:
	ldi zh, HIGH(1000)
	ldi zl, LOW (1000)
	rjmp wait_loop
power_up_wait:
	ldi zh, HIGH(9000)
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
