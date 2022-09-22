#include <stdint.h>
#include <stdbool.h>

//este é o riscv_0 (RECEBE mensagem)

// TILE_SETUP 
#define X_TILES 2
#define Y_TILES 2

#define IMAGE_WIDTH     20
#define IMAGE_HEIGHT    20

#define SUB_IMAG_WIDTH     IMAGE_WIDTH  / X_TILES
#define SUB_IMAG_HEIGHT    IMAGE_HEIGHT / Y_TILES

#define X_LOCAL  0
#define Y_LOCAL  0

#define X_INIT   SUB_IMAG_WIDTH   *  X_LOCAL
#define Y_INIT   SUB_IMAG_HEIGHT  *  Y_LOCAL

#define X_LINHA   SUB_IMAG_WIDTH   *  X_TILES
#define Y_LINHA   SUB_IMAG_HEIGHT  *  Y_TILES


// CONFIGURAçao da PM 
#define PIXEL_SIZE 16
#define PM_LENGTH   9

#define reg_leds                    (*(volatile uint32_t*)0x03000000)
#define reg_uart_clkdiv             (*(volatile uint32_t*)0x02000004)
#define reg_uart_data               (*(volatile uint32_t*)0x02000008)

#define PE_WRITE_ADDRESS            (*(volatile uint32_t*)0x02200000)
#define PE_WRITE_ADDRESS_TOP        (*(volatile uint32_t*)0x02210000)

#define SET_PIXEL_BUFFER            (*(volatile uint32_t*)0x02220000)
#define SET_PIXEL_BUFFER_TOP        (*(volatile uint32_t*)0x02230000)

#define PE_READ_ADDRESS             (*(volatile uint32_t*)0x02100000)
#define PE_READ_ADDRESS_TOP         (*(volatile uint32_t*)0x02110000)


#define big_array    (*(volatile uint32_t*)0x00018000)

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

#define SET_PM_PIXEL_MASK              0x0000FFFF
#define SET_PM_X_DEST_MASK             0x7F800000
#define SET_PM_Y_DEST_MASK             0x007F8000
#define SET_PM_STEP                    0x00007C00
#define SET_PM_FRAME                   0x000003FC


#define SET_ADDRESS_MASK            0x000003FE
#define SET_REQ_MASK                0x00000001

#define PE_WRITE_ADDRESS_MASK_PIXEL 511UL<<16
#define PE_WRITE_ADDRESS_MASK_XDEST 255UL<<8
#define PE_WRITE_ADDRESS_MASK_YDEST 255UL<<0
#define PE_WRITE_ADDRESS_MASK_STEP  31UL<<27
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

void set_pm_pixel(uint32_t pixel);
void set_pm_x_dest(uint32_t x_dest);
void set_pm_y_dest(uint32_t y_dest);
void set_pm_step(uint32_t step);
void set_pm_frame(uint32_t frame);

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
void write_gpio(uint32_t pixel, uint32_t x_dest, uint32_t y_dest, uint32_t step, uint32_t frame, uint32_t x_orig, uint32_t y_orig, uint32_t fb);
void set_pixel(uint32_t pixel, uint32_t x_dest, uint32_t y_dest, uint32_t step, uint32_t frame);

void Read_message(void);


void putchart(char c);
void print(const char *p);
void print_dec(uint32_t v);


//utilidades 
void delay(void);



////testes
void set_local_image(void);
void get_local_image(void);
void get_external_image(uint8_t tilex, uint8_t tiley);
void get_external_image_noprint(uint8_t tilex, uint8_t tiley);

void teste_local_image(void); //seta e le a pm interna
void teste_leitura_imagem(void);
void teste_com_entre_risc_mestre(void);
void teste_com_entre_risc_escravo(void);



void main()
{
        print("|");
        print("|");         
        print("   "); 
        print("\r\n\n\r");


        reg_uart_clkdiv=868;
        print("teste de comunicacao entre riscs");
        print("\r\n\n\r");
        teste_com_entre_risc_mestre();
        print("teste de funcionamento da memoria local --- leitura e escrita");    
        teste_local_image();    
        delay();
        print("teste de funcionamento da memoria externa --- tile01 --- leitura");    
        get_external_image(0,1);
        volatile int k=0;
        while(1)
        {
            read_gpio();
            k=k+1;
            print_dec(k);
        }

}


/****************************************************************************************
**************************FUNCOES PARA ESCREVER NA PM LOCAL*****************************
*****************************************************************************************/
void set_pixel(uint32_t pixel, uint32_t x_dest, uint32_t y_dest, uint32_t step, uint32_t frame)
{
// resetar o buff de envio
SET_PIXEL_BUFFER=0ULL;
SET_PIXEL_BUFFER_TOP=0;


    set_pm_pixel(pixel);
    set_pm_x_dest(x_dest);
    set_pm_y_dest(y_dest);
    set_pm_step(step);
    set_pm_frame(frame);
    
//setar o request
SET_PIXEL_BUFFER= SET_PIXEL_BUFFER | 0x2;
//esperar pelo acknowledge do recebimento
while((SET_PIXEL_BUFFER & 0x1)== 0);

//reseta o pino de request
SET_PIXEL_BUFFER= SET_PIXEL_BUFFER & (~0x00000002) ;
//esperar pelo reset do acknowledge
while((SET_PIXEL_BUFFER & 0x1)== 1);
}

void set_pm_pixel(uint32_t pixel)
{
    SET_PIXEL_BUFFER_TOP  |=   (SET_PIXEL_BUFFER_TOP & ~SET_PM_PIXEL_MASK) | ((uint32_t)pixel);
}

void set_pm_x_dest(uint32_t x_dest)
{
	SET_PIXEL_BUFFER  |=   (SET_PIXEL_BUFFER & ~SET_PM_X_DEST_MASK) | ((uint32_t)x_dest<<23);
}
void set_pm_y_dest(uint32_t y_dest)
{
	SET_PIXEL_BUFFER  |=   (SET_PIXEL_BUFFER & ~SET_PM_Y_DEST_MASK) | ((uint32_t)y_dest<<15);
}
void set_pm_step(uint32_t step)
{
	SET_PIXEL_BUFFER  |=   (SET_PIXEL_BUFFER & ~SET_PM_STEP) | ((uint32_t)step<<10);
}
void set_pm_frame(uint32_t frame)
{
	SET_PIXEL_BUFFER  |=   (SET_PIXEL_BUFFER & ~SET_PM_FRAME) | ((uint32_t)frame<<2);
}


/****************************************************************************************
****************************FIM DAS FUNCOES PARA ESCREVER NA PM LOCAL********************
*****************************************************************************************/






/**********************************************************************************************************************************************
**************************************************************FUNCOES PARA ESCREVER NA REDE***************************************************
*****************************************************************************************/

void write_gpio(uint32_t pixel, uint32_t x_dest, uint32_t y_dest, uint32_t step, uint32_t frame, uint32_t x_orig, uint32_t y_orig, uint32_t fb)
{
// resetar o buff de envio
PE_WRITE_ADDRESS=0ULL;

    PE_WRITE_ADDRESS=0;
    PE_WRITE_ADDRESS_TOP=0;
    write_buffer_top=0;
    write_buffer=0;
    
    setPixel(pixel);
    setXdest(x_dest);
    setYdest(y_dest);
    setFrame(step);
    setStep (frame);
    setXorig(x_orig);
    setYorig(y_orig);
    setFb   (fb);
    PE_WRITE_ADDRESS_TOP= write_buffer_top;
    PE_WRITE_ADDRESS= write_buffer;


//setar o request
PE_WRITE_ADDRESS= PE_WRITE_ADDRESS | 0x2;

//esperar pelo acknowledge do recebimento
while((PE_WRITE_ADDRESS & 0x1)== 0);

//reseta o pino de request
PE_WRITE_ADDRESS= PE_WRITE_ADDRESS & (~0x00000002) ;

//esperar pelo reset do acknowledge
while((PE_WRITE_ADDRESS & 0x1)== 1);

}


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



/****************************************************************************************
****************************FIM DAS FUNCOES PARA ESCREVER NA REDE****************************
*****************************************************************************************/











/****************************************************************************************
****************************FUNCOES PARA LER NA REDE****************************
*****************************************************************************************/
void read_gpio(void)
{

    // espera algum sinal de request
    while((PE_READ_ADDRESS & 0x2)==0);

    // recebe a mensagem 
    readPixel();
    readXdest();
    readYdest();
    readStep ();
    readFrame();
    readXorig();
    readYorig();
    readFb();    // seta o acknowledge 
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


/****************************************************************************************
****************************FUNCOES PARA LER NA REDE****************************
*****************************************************************************************/



void putchart(char c)
{
	if (c == '\n')
		putchart('\r');
	reg_uart_data = c;
}

void print(const char *p)
{
	while (*p)
		putchart(*(p++));
}

void print_dec(uint32_t v)
{

	if      (v >= 900) { putchart('9'); v -= 900; }
	else if (v >= 800) { putchart('8'); v -= 800; }
	else if (v >= 700) { putchart('7'); v -= 700; }
	else if (v >= 600) { putchart('6'); v -= 600; }
	else if (v >= 500) { putchart('5'); v -= 500; }
	else if (v >= 400) { putchart('4'); v -= 400; }
	else if (v >= 300) { putchart('3'); v -= 300; }
	else if (v >= 200) { putchart('2'); v -= 200; }
	else if (v >= 100) { putchart('1'); v -= 100; }
	else putchart('0');

	if      (v >= 90) { putchart('9'); v -= 90; }
	else if (v >= 80) { putchart('8'); v -= 80; }
	else if (v >= 70) { putchart('7'); v -= 70; }
	else if (v >= 60) { putchart('6'); v -= 60; }
	else if (v >= 50) { putchart('5'); v -= 50; }
	else if (v >= 40) { putchart('4'); v -= 40; }
	else if (v >= 30) { putchart('3'); v -= 30; }
	else if (v >= 20) { putchart('2'); v -= 20; }
	else if (v >= 10) { putchart('1'); v -= 10; }
	else putchart('0');

	if      (v >= 9) { putchart('9'); v -= 9; }
	else if (v >= 8) { putchart('8'); v -= 8; }
	else if (v >= 7) { putchart('7'); v -= 7; }
	else if (v >= 6) { putchart('6'); v -= 6; }
	else if (v >= 5) { putchart('5'); v -= 5; }
	else if (v >= 4) { putchart('4'); v -= 4; }
	else if (v >= 3) { putchart('3'); v -= 3; }
	else if (v >= 2) { putchart('2'); v -= 2; }
	else if (v >= 1) { putchart('1'); v -= 1; }
	else putchart('0');
}



////////////////////////////////////////////////////
//TESTES E APLICACOES//////////////////////////////

void teste_com_entre_risc_mestre(void)
{
volatile uint32_t pixel;
    for(volatile uint32_t i = 0; i < IMAGE_HEIGHT; i++)
    {   
        for(volatile uint32_t j = 0; j < IMAGE_WIDTH; j++)
        {
        pixel=j+20*i;
        write_gpio(pixel,0,10,0,0,X_INIT,Y_INIT,1);
        read_gpio();
        print("|");
        print_dec(read_message_pixelValue);
        print("|");         
        print("   "); 
        }
    print("\r\n\n\r");
    }
}

void teste_com_entre_risc_escravo(void)
{
    for(volatile uint32_t i = Y_INIT; i < IMAGE_HEIGHT; i++)
    {   
        for(volatile uint32_t j = X_INIT; j < IMAGE_WIDTH; j++)
        {
        read_gpio();
        write_gpio(read_message_pixelValue,0,0,0,0,X_INIT,Y_INIT,1);
        }
    }
}



void set_local_image(void)
{
volatile uint32_t pixel;
    for(volatile uint32_t i = Y_INIT; i < SUB_IMAG_HEIGHT+ Y_INIT; i++)
    {   
        for(volatile uint32_t j = X_INIT; j < SUB_IMAG_WIDTH+ X_INIT; j++)
        {
        pixel=j+X_LINHA*i;
        set_pixel(pixel,j, i, 0, 0); 
        }
    }
}

void get_local_image(void)
{
volatile uint32_t pixel;
    for(volatile uint32_t i = Y_INIT; i < SUB_IMAG_HEIGHT+ Y_INIT; i++)
    {   
        for(volatile uint32_t j = X_INIT; j < SUB_IMAG_WIDTH+ X_INIT; j++)
        {
        write_gpio(0,j,i,0,0,X_INIT,Y_INIT,0);
        read_gpio();
        print("|");
        print_dec(read_message_pixelValue);
        print("|");         
        print("   "); 
        }
        print("\r\n\n\r");
    }
}

void get_external_image(uint8_t tilex, uint8_t tiley)
{
    for(volatile uint32_t i = (tiley*SUB_IMAG_HEIGHT); i < ((tiley+1)*SUB_IMAG_HEIGHT); i++)
    {   
        for(volatile uint32_t j = (tilex*SUB_IMAG_WIDTH); j < ((tilex+1)*SUB_IMAG_WIDTH); j++)
        {
        write_gpio(0,j,i,0,0,X_INIT,Y_INIT,0);
        read_gpio();
        print("|");
        print_dec(read_message_pixelValue);
        print("|");         
        print("   "); 
        }
        print("\r\n\n\r");
    }
}

void get_external_image_noprint(uint8_t tilex, uint8_t tiley)
{
    for(volatile uint32_t i = (tiley*SUB_IMAG_HEIGHT); i < ((tiley+1)*SUB_IMAG_HEIGHT); i++)
    {   
        for(volatile uint32_t j = (tilex*SUB_IMAG_WIDTH); j < ((tilex+1)*SUB_IMAG_WIDTH); j++)
        {
        write_gpio(0,j,i,0,0,X_INIT,Y_INIT,0);
        read_gpio();
        }
       
    }
}
void teste_local_image(void)
{
    set_local_image();
    get_local_image();
}


void teste_leitura_imagem(void)
{
        for(volatile uint32_t i =0; i < X_TILES; i++)
            for(volatile uint32_t j = 0; j<Y_TILES; j++)
        {
            {        
             get_external_image( i,j );            
            }
        }

}

void delay(void)
{
       for(volatile uint32_t ko = 0; ko < 2000000; ko++);
}

 
