#include <stdint.h>
#include <stdbool.h>


//este é o riscv_0 (RECEBE mensagem)


#define reg_leds (*(volatile uint32_t*)0x03000000)
#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)
#define PE_WRITE_ADDRESS      (*(volatile uint64_t*)0x02200000)
#define PE_READ_ADDRESS       (*(volatile uint64_t*)0x02100000)

#define write_message_pixelValue (*(volatile uint32_t*)0x00012000)
#define write_message_xDest (*(volatile uint32_t*)     0x00012004)
#define write_message_yDest (*(volatile uint32_t*)     0x00012008)
#define write_message_step (*(volatile uint32_t*)      0x0001200C)
#define write_message_frame (*(volatile uint32_t*)     0x00012010)
#define write_message_xOrig (*(volatile uint32_t*)     0x00012014)
#define write_message_yOrig (*(volatile uint32_t*)     0x00012018)
#define write_message_fb (*(volatile uint32_t*)        0x0001201c)
#define write_message_req (*(volatile uint32_t*)       0x00012020)
#define write_message_ack (*(volatile uint32_t*)       0x00012024)

#define read_message_pixelValue (*(volatile uint32_t*)0x00012100)
#define read_message_xDest (*(volatile uint32_t*)     0x00012104)
#define read_message_yDest (*(volatile uint32_t*)     0x00012108)
#define read_message_step (*(volatile uint32_t*)      0x0001210C)
#define read_message_frame (*(volatile uint32_t*)     0x00012110)
#define read_message_xOrig (*(volatile uint32_t*)     0x00012114)
#define read_message_yOrig (*(volatile uint32_t*)     0x00012118)
#define read_message_fb (*(volatile uint32_t*)        0x0001211c)
#define read_message_req (*(volatile uint32_t*)       0x00012120)
#define read_message_ack (*(volatile uint32_t*)       0x00012124)


#define DATA_DEGUB_ADDRESS      (*(volatile uint64_t*)0x00012F0)





#define PE_WRITE_ADDRESS_MASK_PIXEL 511ULL<<51
#define PE_WRITE_ADDRESS_MASK_XDEST 255ULL<<43
#define PE_WRITE_ADDRESS_MASK_YDEST 255ULL<<35
#define PE_WRITE_ADDRESS_MASK_STEP  255ULL<<27
#define PE_WRITE_ADDRESS_MASK_FRAME 255ULL<<19
#define PE_WRITE_ADDRESS_MASK_XORIG 255ULL<<11
#define PE_WRITE_ADDRESS_MASK_YORIG 255ULL<<3
#define PE_WRITE_ADDRESS_MASK_FB    1ULL<<2
#define PE_WRITE_ADDRESS_MASK_REQ   1ULL<<1
#define PE_WRITE_ADDRESS_MASK_REQ   1ULL<<1
#define PE_WRITE_ADDRESS_MASK_ACK   1ULL

void setPixel(uint32_t pixel_Value);
void setXdest(uint32_t x_Dest);
void setYdest(uint32_t y_Dest);
void setStep(uint32_t step);
void setFrame(uint32_t frame);
void setXorig(uint32_t x_Orig);
void setYorig(uint32_t y_Orig);
void setFb(uint32_t fb);

void setdebugPixel(uint32_t pixel_Value);
void setdebugXdest(uint32_t x_Dest);
void setdebugYdest(uint32_t y_Dest);
void setdebugStep(uint32_t step);
void setdebugFrame(uint32_t frame);
void setdebugXorig(uint32_t x_Orig);
void setdebugYorig(uint32_t y_Orig);
void setdebugFb(uint32_t fb);

void readPixel(void);
void readXdest(void);
void readYdest(void);
void readStep(void);
void readFrame(void);
void readXorig(void);
void readYorig(void);
void readFb(void);
void readReq(void);
void readAck(void);


void readdebugPixel(void);
void readdebugXdest(void);
void readdebugYdest(void);
void readdebugStep(void);
void readdebugFrame(void);
void readdebugXorig(void);
void readdebugYorig(void);
void readdebugFb(void);
void readdebugReq(void);
void readdebugAck(void);


void read_gpio(void);
void write_gpio(void);

void Write_message(void);
void Read_message(void);

void Write_message_debug(void);
void Read_debug_message(void);

void print_read_message(void);


void putchar(char c);
void print(const char *p);
void print_dec(uint32_t v);


void main()
{

    reg_uart_clkdiv=868;
    write_message_pixelValue=193;
    write_message_xDest=0;
    write_message_yDest=0;
    write_message_step=41;
    write_message_frame=29;
    write_message_xOrig=0;
    write_message_yOrig=0;
    write_message_fb=1;  

    Write_message_debug();
    Read_debug_message();
    print("-------------------------------------\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");



while(1)
{  
read_gpio();
print("-------------------------------------\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");
print_dec(read_message_pixelValue);
print("\n\r");


for( volatile long int k=0;k<600000;k++);
for( volatile long int k=0;k<600000;k++);
for( volatile long int k=0;k<600000;k++);
}


}

void write_gpio(void)
{
// resetar o buff de envio
PE_WRITE_ADDRESS=0ULL;
print_dec(2);

//escrever a mensagem
Write_message();
print_dec(3);
//setar o request
PE_WRITE_ADDRESS= PE_WRITE_ADDRESS | 0x2;
print_dec(4);

//esperar pelo acknowledge do recebimento
while((PE_WRITE_ADDRESS & 0x1)== 0);
print_dec(5);

//reseta o pino de request
PE_WRITE_ADDRESS= PE_WRITE_ADDRESS & (~0x00000002) ;
print_dec(6);

//esperar pelo reset do acknowledge
while((PE_WRITE_ADDRESS & 0x1)== 1);
print_dec(7);


}

void read_gpio(void)
{
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
}

/*
 "1 1111 1111"  "1111 1111"  "1111 1111"  "1111 1111"  "1111 1111"  "1111 1111"  "1111 1111"   "1"    "1"  |  "1"
    Pixel          Xdest        Ydest        Step         Frame        Xorig        Yorig       fb    Req  |  Ack

                            ESCRITA                                                                       | LEITURA
*/

void setPixel(uint32_t pixel_Value)
{
		PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_PIXEL) | ((uint64_t)pixel_Value<<51);
}
void setXdest(uint32_t x_Dest)
{
		PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_XDEST) | ((uint64_t)x_Dest<<43);
}
void setYdest(uint32_t y_Dest)
{
		PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_YDEST) | ((uint64_t)y_Dest<<35);
}

void setStep(uint32_t step)
{
	    PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_STEP) | ((uint64_t)step<<27);
}
void setFrame(uint32_t frame)
{
	    PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_FRAME) | ((uint64_t)frame<<19);
}

void setXorig(uint32_t x_Orig)
{
	    PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_XORIG) | ((uint64_t)x_Orig<<11);
}
void setYorig(uint32_t y_Orig)
{
	    PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_YORIG) | ((uint64_t)y_Orig<<3);
}
void setFb(uint32_t fb)
{
	    PE_WRITE_ADDRESS |=   (PE_WRITE_ADDRESS & ~PE_WRITE_ADDRESS_MASK_FB) | ((uint64_t)fb<<2);
}





void readPixel(void)
{
	volatile uint64_t aux = PE_READ_ADDRESS & PE_WRITE_ADDRESS_MASK_PIXEL ;
	read_message_pixelValue= aux>>51;
}
void readXdest(void)
{
	uint64_t aux= PE_READ_ADDRESS & PE_WRITE_ADDRESS_MASK_XDEST;
	read_message_xDest=	aux>>43;
}
void readYdest(void)
{
   read_message_yDest= ((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_YDEST))>>35;
}
void readStep(void)
{
	 read_message_step= ((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_STEP))>>27;
}
void readFrame(void)
{
	read_message_frame=((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_FRAME))>>19;
}
void readXorig(void)
{
	 read_message_xOrig= ((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_XORIG))>>11;
}
void readYorig(void)
{
	read_message_yOrig =((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_YORIG))>>3;
}
void readFb(void)
{
	read_message_fb=((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_FB))>>2;
}
void readReq(void)
{
	read_message_req=((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_REQ))>>1;
}
void readAck(void)
{
	read_message_ack=((PE_READ_ADDRESS) & (PE_WRITE_ADDRESS_MASK_ACK))>>0;
}



void readdebugPixel(void)
{
	volatile uint64_t aux = DATA_DEGUB_ADDRESS & PE_WRITE_ADDRESS_MASK_PIXEL ;
	read_message_pixelValue= aux>>51;
}
void readdebugXdest(void)
{
	uint64_t aux= DATA_DEGUB_ADDRESS & PE_WRITE_ADDRESS_MASK_XDEST;
	read_message_xDest=	aux>>43;
}
void readdebugYdest(void)
{
   read_message_yDest= ((DATA_DEGUB_ADDRESS) & (PE_WRITE_ADDRESS_MASK_YDEST))>>35;
}
void readdebugStep(void)
{
	 read_message_step= ((DATA_DEGUB_ADDRESS) & (PE_WRITE_ADDRESS_MASK_STEP))>>27;
}
void readdebugFrame(void)
{
	read_message_frame=((DATA_DEGUB_ADDRESS) & (PE_WRITE_ADDRESS_MASK_FRAME))>>19;
}
void readdebugXorig(void)
{
	 read_message_xOrig= ((DATA_DEGUB_ADDRESS) & (PE_WRITE_ADDRESS_MASK_XORIG))>>11;
}
void readdebugYorig(void)
{
	read_message_yOrig =((DATA_DEGUB_ADDRESS) & (PE_WRITE_ADDRESS_MASK_YORIG))>>3;
}
void readdebugFb(void)
{
	read_message_fb=((DATA_DEGUB_ADDRESS) & (PE_WRITE_ADDRESS_MASK_FB))>>2;
}
void readdebugReq(void)
{
	read_message_req=((DATA_DEGUB_ADDRESS) & (PE_WRITE_ADDRESS_MASK_REQ))>>1;
}
void readdebugAck(void)
{
	read_message_ack=((DATA_DEGUB_ADDRESS) & (PE_WRITE_ADDRESS_MASK_ACK))>>0;
}


void setdebugPixel(uint32_t pixel_Value)
{
		DATA_DEGUB_ADDRESS |=   (DATA_DEGUB_ADDRESS & ~PE_WRITE_ADDRESS_MASK_PIXEL) | ((uint64_t)pixel_Value<<51);
}
void setdebugXdest(uint32_t x_Dest)
{
		DATA_DEGUB_ADDRESS |=   (DATA_DEGUB_ADDRESS & ~PE_WRITE_ADDRESS_MASK_XDEST) | ((uint64_t)x_Dest<<43);
}
void setdebugYdest(uint32_t y_Dest)
{
		DATA_DEGUB_ADDRESS |=   (DATA_DEGUB_ADDRESS & ~PE_WRITE_ADDRESS_MASK_YDEST) | ((uint64_t)y_Dest<<35);
}

void setdebugStep(uint32_t step)
{
	    DATA_DEGUB_ADDRESS |=   (DATA_DEGUB_ADDRESS & ~PE_WRITE_ADDRESS_MASK_STEP) | ((uint64_t)step<<27);
}
void setdebugFrame(uint32_t frame)
{
	    DATA_DEGUB_ADDRESS |=   (DATA_DEGUB_ADDRESS & ~PE_WRITE_ADDRESS_MASK_FRAME) | ((uint64_t)frame<<19);
}

void setdebugXorig(uint32_t x_Orig)
{
	    DATA_DEGUB_ADDRESS |=   (DATA_DEGUB_ADDRESS & ~PE_WRITE_ADDRESS_MASK_XORIG) | ((uint64_t)x_Orig<<11);
}
void setdebugYorig(uint32_t y_Orig)
{
	    DATA_DEGUB_ADDRESS |=   (DATA_DEGUB_ADDRESS & ~PE_WRITE_ADDRESS_MASK_YORIG) | ((uint64_t)y_Orig<<3);
}
void setdebugFb(uint32_t fb)
{
	    DATA_DEGUB_ADDRESS |=   (DATA_DEGUB_ADDRESS & ~PE_WRITE_ADDRESS_MASK_FB) | ((uint64_t)fb<<2);
}



void Write_message(void)
{
	PE_WRITE_ADDRESS=0ULL;
    setPixel(write_message_pixelValue);
    setXdest(write_message_xDest);
    setYdest(write_message_yDest);
    setStep (write_message_step);
    setFrame(write_message_frame);
    setXorig(write_message_xOrig);
    setYorig(write_message_yOrig);
    setFb   (write_message_fb);
}

void Write_message_debug(void)
{
	PE_WRITE_ADDRESS=0ULL;
    setdebugPixel(write_message_pixelValue);
    setdebugXdest(write_message_xDest);
    setdebugYdest(write_message_yDest);
    setdebugStep (write_message_step);
    setdebugFrame(write_message_frame);
    setdebugXorig(write_message_xOrig);
    setdebugYorig(write_message_yOrig);
    setdebugFb   (write_message_fb);
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

void Read_debug_message(void)
{
    readdebugPixel();
    readdebugXdest();
    readdebugYdest();
    readdebugStep ();
    readdebugFrame();
    readdebugXorig();
    readdebugYorig();
    readdebugFb();
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
