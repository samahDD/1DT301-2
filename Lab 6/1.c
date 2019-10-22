/*
 * GccApplication1.c
 *
 * Created: 2019-10-22 21:14:48
 * Author : an223kj
 */ 

#include <avr/io.h>
#include <stdio.h>
#include <string.h>


void init()
{	
	UBRR1H = 0;
	UBRR1L = 25; 
	UCSR1B = (1<<TXEN1) | (1<<RXEN1); // TX/RX enabled
}


unsigned char receiveChar()
{
	// Wait for data to be received
	while ( !( UCSR1A & (1<<RXC1)));

	// Get and return received data from buffer
	return UDR1;
}

void sendChar(unsigned char unsignedChar)
{
	// Wait for empty transmit buffer.
	while ( !( UCSR1A & (1<<UDRE1)) );
	// Put byte in buffer and send.
	UDR1 = unsignedChar;
}



int main(void)
{
	init();
	/*Check the sum and calculate 
	to which letter it corresponds*/
	char* letter = "\rAO0001C";
	int checkSum=0;
	for(int i =0; i < strlen(letter); i++){
		checkSum+=letter[i] ;
	}
	checkSum%=256;
	
	// Display the letter
	char charArr [ 48 ] ;
	sprintf(charArr, "%s%02X\n" , letter , checkSum ) ;
	
	for(int i =0; i < strlen(charArr); i++){
		sendChar(charArr[ i ] ) ;
	}
	
	letter = "\rZD0013C\n" ;
	
	for(int i =0; i <strlen(letter); i++)
	{
		sendChar(letter[ i ] ) ;

	}
	
	
	
	
}