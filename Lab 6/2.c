#include <avr/io.h>
#include <stdio.h>
#include <string.h>

void init( void );
void message( char* charachter , int length ) ;
void sendChar(char character);

int main(void) {		//main function
	init();
	char* str = "\rAO0001Task 1 Complete         Second row" ;
	message (str ,strlen(str)) ;
	str = "\rBO0001Last row too" ;
	message (str ,strlen(str)) ;
	str = "\rZD001" ;
	message (str ,strlen(str)) ;

	return 0;
}

void message(char* character , int length ){
	int checksum=0;
	for(int i =0;i<length ; i++){
		checksum+=character[i] ;
	}
	checksum%=256;
	
	char temp [strlen(character)+3] ;
	
	sprintf(temp, "%s%02X\n" , character , checksum) ;
	
	for (int i =0;i<length+3; i++)  {
		sendChar(temp[i]) ;
	}
}

void init(void)				//enable rx and tx
{
	UBRR1L = 25;
	UCSR1B = ((1 << RXEN1) | (1 << TXEN1)); 
}

void sendChar(char character)	// wait until USART Data register is empty and send character
{
	while ( !(UCSR1A & (1<<UDRE1)) ) ; 
	UDR1 = character;
}