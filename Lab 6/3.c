#include <avr/io.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <util/delay.h>

#define DELAY 1000 

const char* names[] = {
	"Andrei Neagu",
	"Kostis Tatsis"
};

void init(void);
void sendChar(char);
void message(char*, char*);

int main(void) {
	 init();
	message( "AO0001", "Computer Technology,2019Assignment #6");
	message( "ZD001", 0); //refresh

	while (1) {
		for (int i = 0; i < 2; i++) {
			message("BO0001", names[i]);
			message("ZD001", 0); // refresh
			_delay_ms(DELAY);
		}
	}

	return 0;
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

void message(char* command, char* string) //send string to USART, must specify in the command the line
{										//dont optimize 
	int command_length = strlen(command);
	int message_length = strlen(string);

	int buffer_size = 1 + command_length + message_length + 3;
	char* buffer = malloc(buffer_size);

	sprintf(buffer, "\r%s%s", command, string);

	unsigned int checksum = 0;
	for (int i = 0; (buffer[i] != 0); i++)
	checksum += buffer[i];
	
	checksum %= 256;

	sprintf(buffer, "%s%02X\n", buffer, checksum);

	for (int i = 0; buffer[i]; i++)
	sendChar(buffer[i]);
}