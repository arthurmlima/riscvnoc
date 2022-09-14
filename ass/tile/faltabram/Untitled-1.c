#include <stdint.h>
#include <stdbool.h>

//este é o riscv_0 (RECEBE mensagem)

// TILE_SETUP 
#define X_TILES 3
#define Y_TILES 3

#define IMAGE_WIDTH     120
#define IMAGE_HEIGHT    120

#define SUB_IMAG_WIDTH     IMAGE_WIDTH  / X_TILES
#define SUB_IMAG_HEIGHT    IMAGE_HEIGHT / Y_TILES

#define X_LOCAL  1
#define Y_LOCAL  1

#define X_INIT   SUB_IMAG_WIDTH   *  X_LOCAL
#define Y_INIT   SUB_IMAG_HEIGHT  *  Y_LOCAL


// CONFIGURAçao da PM 
#define PIXEL_SIZE 16
#define PM_LENGTH   9

#define reg_leds                    (*(volatile uint32_t*)0x03000000)
#define reg_uart_clkdiv             (*(volatile uint32_t*)0x02000004)
#define reg_uart_data               (*(volatile uint32_t*)0x02000008)

#define PE_WRITE_ADDRESS            (*(volatile uint32_t*)0x02200000)
#define PE_WRITE_ADDRESS_TOP        (*(volatile uint32_t*)0x02210000)

#define SET_PIXEL_BUFFER            (*(volatile uint32_t*)0x02220000)

#define PE_READ_ADDRESS             (*(volatile uint32_t*)0x02100000)
#define PE_READ_ADDRESS_TOP         (*(volatile uint32_t*)0x02110000)


#define write_message_pixelValue    (*(volatile uint32_t*)0x00018000)
#define write_message_xDest         (*(volatile uint32_t*)0x00018004)
#define write_message_yDest         (*(volatile uint32_t*)0x00018008)
#define write_message_step          (*(volatile uint32_t*)0x0001800C)
#define write_message_frame         (*(volatile uint32_t*)0x00018010)
#define write_message_xOrig         (*(volatile uint32_t*)0x00018014)
#define write_message_yOrig         (*(volatile uint32_t*)0x00018018)
#define write_message_fb            (*(volatile uint32_t*)0x0001801c)
#define write_message_req           (*(volatile uint32_t*)0x00018020)
#define write_message_ack           (*(volatile uint32_t*)0x00018024)

#define write_buffer_top            (*(volatile uint32_t*)0x00018204)
#define write_buffer                (*(volatile uint32_t*)0x00018200)

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

#define SET_PIXEL_MASK              0x03FFFC00
#define SET_ADDRESS_MASK            0x000003FE
#define SET_REQ_MASK                0x00000001

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

void setPM_Address(uint16_t address);
void setPM_pixel(uint16_t pixel);

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
void set_pixel(uint16_t pixel,uint16_t address);

void Write_message(void);
void Write_message_SETPX(uint16_t pixel,uint16_t address);

void Read_message(void);


void putchar(char c);
void print(const char *p);
void print_dec(uint32_t v);



void main()
{
    reg_uart_clkdiv=868;
    write_message_pixelValue=0;
    write_message_xDest     =0;
    write_message_yDest     =0;
    write_message_step      =0;
    write_message_frame     =0;
    write_message_xOrig     =0;
    write_message_yOrig     =0;
    write_message_fb        =0; 
    while(1)
    {  

    for(volatile int kounter=0;kounter<20;kounter++)
    {
    set_pixel((uint16_t)kounter,(uint16_t)kounter);
    }



    for(volatile int kounter=0;kounter<20;kounter++)
    {
    write_message_yDest=kounter;
    write_gpio();
    read_gpio();
    print_dec(read_message_pixelValue);  
    print("\n\r");
    }

     
}


}
void set_pixel(uint16_t pixel, uint16_t address)
{
// resetar o buff de envio
SET_PIXEL_BUFFER=0ULL;
Write_message_SETPX(pixel,address);
//setar o request
SET_PIXEL_BUFFER= SET_PIXEL_BUFFER | 0x2;
//esperar pelo acknowledge do recebimento
while((SET_PIXEL_BUFFER & 0x1)== 0);

//reseta o pino de request
SET_PIXEL_BUFFER= SET_PIXEL_BUFFER & (~0x00000002) ;
//esperar pelo reset do acknowledge
while((SET_PIXEL_BUFFER & 0x1)== 1);


}



void write_gpio(void)
{
// resetar o buff de envio
PE_WRITE_ADDRESS=0ULL;

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

    read_message_pixelValue= ((PE_READ_ADDRESS_TOP) & (PE_WRITE_ADDRESS_MASK_PIXEL))>>16;

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




void Write_message(void)
{

//escrever a mensagem
    PE_WRITE_ADDRESS=0;
    PE_WRITE_ADDRESS_TOP=0;
    write_buffer_top=0;
    write_buffer=0;
    

    setPixel(write_message_pixelValue);
    setYdest(write_message_yDest);
    setXdest(write_message_xDest);
    setFrame(write_message_step);
    setStep (write_message_frame);
    setXorig(write_message_xOrig);
    setYorig(write_message_yOrig);
    setFb   (write_message_fb);
    PE_WRITE_ADDRESS_TOP= write_buffer_top;
    PE_WRITE_ADDRESS= write_buffer;


}

void setPM_pixel(uint16_t pixel)
{
    SET_PIXEL_BUFFER  |=   (SET_PIXEL_BUFFER & ~SET_PIXEL_MASK) | ((uint32_t)pixel<<(PM_LENGTH+2));
}

void setPM_Address(uint16_t address)
{
	SET_PIXEL_BUFFER  |=   (SET_PIXEL_BUFFER & ~SET_ADDRESS_MASK) | ((uint32_t)address<<2);
}

void Write_message_SETPX(uint16_t pixel,uint16_t address)
{
    setPM_pixel(pixel);
    setPM_Address(address);
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



