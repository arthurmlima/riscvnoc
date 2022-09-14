#include <stdint.h>
#include <stdbool.h>

//este é o riscv_0 (RECEBE mensagem)


#define reg_leds (*(volatile uint32_t*)0x03000000)
#define reg_uart_clkdiv (*(volatile uint32_t*)0x02000004)
#define reg_uart_data (*(volatile uint32_t*)0x02000008)

#define PE_WRITE_ADDRESS      (*(volatile uint32_t*)0x02200000)
#define PE_WRITE_ADDRESS_TOP      (*(volatile uint32_t*)0x02210000)

#define PE_READ_ADDRESS       (*(volatile uint32_t*)0x02100000)
#define PE_READ_ADDRESS_TOP       (*(volatile uint32_t*)0x02110000)


#define write_message_pixelValue (*(volatile uint32_t*)0x00018000)
#define write_message_xDest      (*(volatile uint32_t*)0x00018004)
#define write_message_yDest      (*(volatile uint32_t*)0x00018008)
#define write_message_step       (*(volatile uint32_t*)0x0001800C)
#define write_message_frame      (*(volatile uint32_t*)0x00018010)
#define write_message_xOrig      (*(volatile uint32_t*)0x00018014)
#define write_message_yOrig      (*(volatile uint32_t*)0x00018018)
#define write_message_fb         (*(volatile uint32_t*)0x0001801c)
#define write_message_req        (*(volatile uint32_t*)0x00018020)
#define write_message_ack        (*(volatile uint32_t*)0x00018024)

#define write_buffer_top (*(volatile uint32_t*)       0x00018204)
#define write_buffer (*(volatile uint32_t*)       0x00018200)

#define read_message_pixelValue     (*(volatile uint32_t*)0x00018100)
#define read_message_xDest          (*(volatile uint32_t*)0x00018104)
#define read_message_yDest          (*(volatile uint32_t*)0x00018108)
#define read_message_step           (*(volatile uint32_t*)0x0001810C)
#define read_message_frame          (*(volatile uint32_t*)0x00018110)
#define read_message_xOrig          (*(volatile uint32_t*)0x00018114)
#define read_message_yOrig          (*(volatile uint32_t*)0x00018118)
#define read_message_fb             (*(volatile uint32_t*)0x0001811c)
#define read_message_req            (*(volatile uint32_t*)0x00018120)
#define read_message_ack            (*(volatile uint32_t*)0x00018124)


#define PM_WRITE_MASK_PIXEL 0x81FF0000
#define PM_WRITE_MASK_ADDR  0x000000FF


#define PE_WRITE_ADDRESS_MASK_PIXEL 511UL<<16
#define PE_WRITE_ADDRESS_MASK_XDEST 255UL<<8
#define PE_WRITE_ADDRESS_MASK_YDEST 255UL<<0
#define PE_WRITE_ADDRESS_MASK_STEP  63UL<<27
#define PE_WRITE_ADDRESS_MASK_FRAME 255UL<<19
#define PE_WRITE_ADDRESS_MASK_XORIG 255UL<<11
#define PE_WRITE_ADDRESS_MASK_YORIG 255UL<<3
#define PE_WRITE_ADDRESS_MASK_FB    1UL<<2
#define PE_WRITE_ADDRESS_MASK_REQ   1UL<<1
#define PE_WRITE_ADDRESS_MASK_REQ   1UL<<1
#define PE_WRITE_ADDRESS_MASK_ACK   1UL

void setPixel(uint32_t pixel_Value);
void setXdest(uint32_t x_Dest);
void setYdest(uint32_t y_Dest);
void setStep(uint32_t step);
void setFrame(uint32_t frame);
void setXorig(uint32_t x_Orig);
void setYorig(uint32_t y_Orig);
void setFb(uint32_t fb);

void setPM_Address(uint32_t address);
void setPM_pixel(uint32_t pixel);

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


void read_gpio(void);
void write_gpio(void);

void Write_message(void);
void Read_message(void);


void putchar(char c);
void print(const char *p);
void print_dec(uint32_t v);



void main()
{
    reg_uart_clkdiv=868;

    write_message_pixelValue=54;
    write_message_xDest     =0;
    write_message_yDest     =0;
    write_message_step      =29;
    write_message_frame     =13;
    write_message_xOrig      =0;
    write_message_yOrig      =0;
    write_message_fb         =0; 
    while(1)
    {  
    write_message_pixelValue++;
    write_message_xDest     ++;
    write_message_yDest     ++;
    write_message_step      ++;
    write_message_frame     ++;
    write_message_xOrig     ++;
    write_message_yOrig     ++;

    write_gpio(1);


    print_dec(write_message_pixelValue);
    print("\n\r");
    print_dec(write_message_xDest     );
    print("\n\r");
    print_dec(write_message_yDest     );
    print("\n\r");
    print_dec(write_message_step      );
    print("\n\r");
    print_dec(write_message_frame     );
    print("\n\r");
    print_dec(write_message_xOrig     );
    print("\n\r");
    print_dec(write_message_yOrig     );
    print("\n\r");
    print_dec(write_message_fb        );
    print("\n\r");
    
    
    
    
    
    
    
     




    

for( volatile long int k=0;k<600000;k++);
for( volatile long int k=0;k<600000;k++);
for( volatile long int k=0;k<600000;k++);
}


}

void write_gpio(uint8_t pm_ou_pe)
{
// resetar o buff de envio
PE_WRITE_ADDRESS=0ULL;

Write_message(pm_ou_pe);
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
		write_buffer_top |=   (write_buffer_top & ~PE_WRITE_ADDRESS_MASK_PIXEL) | ((uint32_t)pixel_Value<<16);
}
void setXdest(uint32_t x_Dest)
{
		write_buffer_top |=   (write_buffer_top & ~PE_WRITE_ADDRESS_MASK_XDEST) | ((uint32_t)x_Dest<<8);
}
void setYdest(uint32_t y_Dest)
{
		write_buffer_top |=   (write_buffer_top & ~PE_WRITE_ADDRESS_MASK_YDEST) | ((uint32_t)y_Dest);
}

void setStep(uint32_t step)
{
	    write_buffer |=   (write_buffer & ~PE_WRITE_ADDRESS_MASK_STEP) | ((uint32_t)step<<27);
}
void setFrame(uint32_t frame)
{
	    write_buffer |=   (write_buffer & ~PE_WRITE_ADDRESS_MASK_FRAME) | ((uint32_t)frame<<19);
}

void setXorig(uint32_t x_Orig)
{
	    write_buffer |=   (write_buffer & ~PE_WRITE_ADDRESS_MASK_XORIG) | ((uint32_t)x_Orig<<11);
}
void setYorig(uint32_t y_Orig)
{
	    write_buffer |=   (write_buffer & ~PE_WRITE_ADDRESS_MASK_YORIG) | ((uint32_t)y_Orig<<3);
}
void setFb(uint32_t fb)
{
	    write_buffer |=   (write_buffer & ~PE_WRITE_ADDRESS_MASK_FB) | ((uint32_t)fb<<2);
}




void readPixel(void)
{

    read_message_xDest= ((PE_READ_ADDRESS_TOP) & (PE_WRITE_ADDRESS_MASK_PIXEL))>>16;

}
void readXdest(void)
{
    read_message_xDest= ((PE_READ_ADDRESS_TOP) & (PE_WRITE_ADDRESS_MASK_XDEST))>>8;
}
void readYdest(void)
{
   read_message_yDest= ((PE_READ_ADDRESS_TOP) & (PE_WRITE_ADDRESS_MASK_YDEST));
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




void Write_message(uint8_t pm_ou_pe)
{

//escrever a mensagem
    PE_WRITE_ADDRESS=0;
    PE_WRITE_ADDRESS_TOP=0;
    write_buffer_top=0;
    write_buffer=0;
    
    if(pm_ou_pe==0)
    {
        setPixel(write_message_pixelValue);
        setYdest(write_message_yDest);
    }
    else
    {
        setPM_pixel(write_message_pixelValue);
        setPM_Address(write_message_yDest); 
    }
    setXdest(write_message_xDest);
    setFrame(write_message_step);
    setStep (write_message_frame);
    setXorig(write_message_xOrig);
    setYorig(write_message_yOrig);
    setFb   (write_message_fb);
    PE_WRITE_ADDRESS_TOP= write_buffer_top;
    PE_WRITE_ADDRESS= write_buffer;


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
void setPM_pixel(uint32_t pixel)
{
	write_buffer_top |=   (write_buffer_top & ~PE_WRITE_ADDRESS_MASK_PIXEL) | ((uint32_t)pixel<<16);
}
void setPM_Address(uint32_t address)
{
	write_buffer_top |=   (write_buffer_top & ~PM_WRITE_MASK_ADDR) | ((uint32_t)address);

}

