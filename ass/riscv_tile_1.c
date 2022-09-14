#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>


//este é o riscv_1 (manda mensagem)

#define getvalue 0x0000000E
#define write_op 0x00000001
#define read_op  0x00000010


#define reg_leds (*(volatile uint32_t*)0x03000000)

#define data (*(volatile uint32_t*)0x00010000)
#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)



#define PE_WRITE_ADDRESS      (*(volatile uint64_t*)0xC0000008)


#define PE_READ_ADDRESS       (*(volatile uint64_t*)0xC0000000)


#define PE_WRITE_ADDRESS_MASK_PIXEL 511ULL<<52
#define PE_WRITE_ADDRESS_MASK_XDEST 255ULL<<44
#define PE_WRITE_ADDRESS_MASK_YDEST 255ULL<<36
#define PE_WRITE_ADDRESS_MASK_STEP  255ULL<<28
#define PE_WRITE_ADDRESS_MASK_FRAME 255ULL<<20
#define PE_WRITE_ADDRESS_MASK_XORIG 255ULL<<12
#define PE_WRITE_ADDRESS_MASK_YORIG 255ULL<<4
#define PE_WRITE_ADDRESS_MASK_FB    1ULL<<3


void setPixel(uint32_t pixel_Value);
void setXdest(uint8_t x_Dest);
void setYdest(uint8_t y_Dest);
void setStep(uint8_t step);
void setFrame(uint8_t frame);
void setXorig(uint8_t x_Orig);
void setYorig(uint8_t y_Orig);
void setFb(uint8_t fb);

void readPixel(void);
void readXdest(void);
void readYdest(void);

void readStep(void);
void readFrame(void);

void readXorig(void);
void readYorig(void);
void readFb(void);


void Write_message(void);
void Read_message(void);
void print_read_message(void);


void send_message(uint32_t x);
void read_message(void);
void putchar(char c);
void print(const char *p);
void print_dec(uint32_t v);

void read_gpio(void);
void Write_message(void);


struct message {
  uint32_t pixelValue;
  uint8_t  xDest;
  uint8_t  yDest;
  uint8_t  step;
  uint8_t  frame;
  uint8_t  xOrig;
  uint8_t  yOrig;
  uint8_t   fb;
};

volatile struct message read_message;
volatile struct message write_message;


void main()
{

reg_uart_clkdiv=868;

data=0;
while(1)
{
    write_message_pixelValue=235;
    write_message_xDest=0;
    write_message_yDest=0;
    write_message_step=1;
    write_message_frame=8;
    write_message_xOrig=41;
    write_message_yOrig=209;
    write_message_fb=1;

write_gpio();
for( volatile long int k=0;k<600000;k++);
for( volatile long int k=0;k<600000;k++);
for( volatile long int k=0;k<600000;k++);
}


}

void write_gpio()
{
// resetar o buff de envio
PE_WRITE_ADDRESS=0;

//escrever a mensagem
Write_message();

//setar o request
PE_WRITE_ADDRESS= PE_WRITE_ADDRESS | 0x2;

//esperar pelo acknowledge do recebimento
while((PE_WRITE_ADDRESS & 0x1)== 0);

//reseta o pino de request
PE_WRITE_ADDRESS= PE_WRITE_ADDRESS & (~0x00000002) ;

//esperar pelo reset do acknowledge
while((PE_WRITE_ADDRESS & 0x1)== 1);


}

void read_gpio(void)
{
    uint32_t x;
    // espera algum sinal de request
    while((PE_READ_ADDRESS & 0x2)==0);

    // recebe a mensagem 
    Read_message(); 
    // seta o acknowledge 
    PE_READ_ADDRESS= PE_READ_ADDRESS | 0x1;

    // espera o reset do request
    while((PE_READ_ADDRESS & 0x2)==1);

    // reseta o pino do acknowledge
    PE_READ_ADDRESS= PE_READ_ADDRESS & (~0x1);

 return x;
}
/*


 "1 1111 1111"  "1111 1111"  "1111 1111"  "1111 1111"  "1111 1111"  "1111 1111"  "1111 1111"   "1"    "1"  |  "1"
    Pixel          Xdest        Ydest        Step         Frame        Xorig        Yorig       fb    Req  |  Ack

                            ESCRITA                                                                       | LEITURA
*/

void setPixel(uint32_t pixel_Value)
{
		PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_PIXEL) | ((uint64_t)pixel_Value<<52);
}
void setXdest(uint8_t x_Dest)
{
		PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_XDEST) | ((uint64_t)x_Dest<<44);
}
void setYdest(uint8_t y_Dest)
{
		PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_YDEST) | ((uint64_t)y_Dest<<36);
}

void setStep(uint8_t step)
{
	    PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_STEP) | ((uint64_t)step<<28);
}
void setFrame(uint8_t frame)
{
	    PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_FRAME) | ((uint64_t)frame<<20);
}

void setXorig(uint8_t x_Orig)
{
	    PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_XORIG) | ((uint64_t)x_Orig<<12);
}
void setYorig(uint8_t y_Orig)
{
	    PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_YORIG) | ((uint64_t)y_Orig<<4);
}
void setFb(uint8_t fb)
{
	    PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_FB) | ((uint64_t)fb<<3);
}



void readPixel(void)
{
	volatile uint64_t aux = PE_READ_ADDRESS & PE_WRITE_ADDRESS_MASK_PIXEL ;
	read_message.pixelValue= aux>>52;
}
void readXdest(void)
{
	uint64_t aux= PE_READ_ADDRESS & PE_WRITE_ADDRESS_MASK_XDEST;
	read_message.xDest=	aux>>44;
}
void readYdest(void)
{
   read_message.yDest= ((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_YDEST))>>36;
}
void readStep(void)
{
	 read_message.step= ((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_STEP))>>28;
}
void readFrame(void)
{
	read_message.frame=((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_FRAME))>>20;
}
void readXorig(void)
{
	 read_message.xOrig= ((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_XORIG))>>12;
}
void readYorig(void)
{
	read_message.yOrig =((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_YORIG))>>4;
}
void readFb(void)
{
	read_message.fb=((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_FB))>>3;
}





void Write_message(void)
{
	PE_WRITE_ADDRESS=0ULL;
    setPixel(write_message.pixelValue);
    setXdest(write_message.xDest);
    setYdest(write_message.yDest);
    setStep (write_message.step);
    setFrame(write_message.frame);
    setXorig(write_message.xOrig);
    setYorig(write_message.yOrig);
    setFb   (write_message.fb);
}


void Read_message(void)
{
    readPixel();
    readXdest();
    readYdest();
    readStep ();
    readFrame();
    readXorig();
    readYorig();
    readFb();
}

void putchar(char c)
{
	if (c == '\n')
		putchar('\r');
	reg_uart_data = c;
}

void print(const char *p)
{
	while (*p)
		putchar(*(p++));
}

void print_dec(uint32_t v)
{

	if      (v >= 900) { putchar('9'); v -= 900; }
	else if (v >= 800) { putchar('8'); v -= 800; }
	else if (v >= 700) { putchar('7'); v -= 700; }
	else if (v >= 600) { putchar('6'); v -= 600; }
	else if (v >= 500) { putchar('5'); v -= 500; }
	else if (v >= 400) { putchar('4'); v -= 400; }
	else if (v >= 300) { putchar('3'); v -= 300; }
	else if (v >= 200) { putchar('2'); v -= 200; }
	else if (v >= 100) { putchar('1'); v -= 100; }

	if      (v >= 90) { putchar('9'); v -= 90; }
	else if (v >= 80) { putchar('8'); v -= 80; }
	else if (v >= 70) { putchar('7'); v -= 70; }
	else if (v >= 60) { putchar('6'); v -= 60; }
	else if (v >= 50) { putchar('5'); v -= 50; }
	else if (v >= 40) { putchar('4'); v -= 40; }
	else if (v >= 30) { putchar('3'); v -= 30; }
	else if (v >= 20) { putchar('2'); v -= 20; }
	else if (v >= 10) { putchar('1'); v -= 10; }

	if      (v >= 9) { putchar('9'); v -= 9; }
	else if (v >= 8) { putchar('8'); v -= 8; }
	else if (v >= 7) { putchar('7'); v -= 7; }
	else if (v >= 6) { putchar('6'); v -= 6; }
	else if (v >= 5) { putchar('5'); v -= 5; }
	else if (v >= 4) { putchar('4'); v -= 4; }
	else if (v >= 3) { putchar('3'); v -= 3; }
	else if (v >= 2) { putchar('2'); v -= 2; }
	else if (v >= 1) { putchar('1'); v -= 1; }
	else putchar('0');
}
