
#include <avr/io.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void init(void);
void sendChar(char);
void message(char*, char*, int);
void readString();
char readFromTerminal();

int main(void) {
	init();

	readString();

	return 0;
}

void readString() {
	char chars[72];
	for (int i = 0; i < 72; ++i) {
		chars[i] = ' ';
	}

	char temp[24];
	int counter = 0;
	while (1) {
		// read a char
		char c = readFromTerminal();

		if (c != 0xd) {
			if (counter < 25) {
				temp[counter] = c;
				++counter;
				continue;
			}
		}
		// read the address
		c = readFromTerminal();

		int lineNo = ((c - 0x30) - 1); // line number
		if (lineNo < 0 || lineNo > 2) {
			continue;
		}

		// fill with spaces
		for (int i = 0; i < 24; ++i) {
			chars[i +  lineNo * 24] = i < counter? temp[i]: ' ';
		}

		if (lineNo == 0 || lineNo == 1) {
			message("\rAO0001", chars, 48);
		} else {
			message("\rBO0001", chars + 48, 24);
		}
		message( "\rZD001", 0, 0);

		counter = 0;
	}
}

char readFromTerminal() {
	while ( !(UCSR1A & (1<<RXC1)) ) ; // wait until USART Data register is empty and send character
	return UDR1;
}

void init(void)	//enable rx and tx
{
	UBRR1L = 25;
	UCSR1B = ((1 << RXEN1) | (1 << TXEN1));
}

void sendChar(char character)
{
	while ( !(UCSR1A & (1<<UDRE1)) ) ; // wait until USART Data register is empty and send character
	UDR1 = character;
}

void message(char* command, char* string, int len) //send string to USART, must specify in the command the line
{
	char buffer[80];
	for (int i = 0; i < strlen(command); ++i) {
		buffer[i] = command[i];
	}
	for (int i = 0; i < len; ++i) {
		buffer[i + strlen(command)] = string[i];
	}
	int totalLen = strlen(command) + len;
	buffer[totalLen] = 0;

	unsigned int checksum = 0;
	for (int i = 0; i < totalLen; i++)
		checksum += buffer[i];

	checksum %= 256;

	char output[90];
	sprintf(output, "%s%02X\n", buffer, checksum);

	for (int i = 0; output[i]; i++)
		sendChar(output[i]);
}
