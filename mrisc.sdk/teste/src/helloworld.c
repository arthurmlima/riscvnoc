/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "sleep.h"
#include <stdlib.h>


#include "xparameters.h"
#include "xil_printf.h"
#include "xil_types.h"

enum {
	VIS_OK,
	VIS_ERROR
};

#define VIS_BASE_ADDRESS	XPAR_ZCU104_0_BASEADDR

typedef struct
{
	volatile u32 ADDR;
	volatile u32 DIN;
	volatile u32 DOUT;
	volatile u32 RST;
} Vis_AxiStruct;

#define VIS_AXI				((Vis_AxiStruct *)VIS_BASE_ADDRESS)

/* General Purpose Register - Control Bits */
#define VIS_AXI_EN			((u32 )0x00000001)
#define VIS_AXI_WEN			((u32 )0x0000001E) // HABILITA TUDO

/* General Purpose Register - Status Bits */
#define VIS_AXI_OK			((u32 )0x00100000)

/* Address Register */
#define VIS_AXI_ADR			((u32)0x000FFFE0)
#define VIS_AXI_ADR_SHIFT	0UL
#define VIS_AXI_ADR_MASK	((u32)0xFFFFFFFF)

/* Data In Register */
#define VIS_AXI_DTI			((u32)0x00000001)
#define VIS_AXI_DTI_SHIFT	0UL
#define VIS_AXI_DTI_MASK	((u32)0xFFFFFFFF)

/* Data Out Register */
#define VIS_AXI_DTO			((u32)0x00000001)
#define VIS_AXI_DTO_SHIFT	0UL
#define VIS_AXI_DTO_MASK	((u32)0xFFFFFFFF)


#define text_size 670
#define data_size 54


int main()
{

    init_platform();

    u32 text[134]=
    {
    		0xfd010113,
    		0x02112623,
    		0x02812423,
    		0x03010413,
    		0x00000533,
    		0xfea42a23,
    		0x0040006f,
    		0x00000533,
    		0xfea42823,
    		0x0040006f,
    		0xff042503,
    		0x0000f5b7,
    		0xa5f58593,
    		0x00a5ce63,
    		0x0040006f,
    		0x0040006f,
    		0xff042503,
    		0x00150513,
    		0xfea42823,
    		0xfddff06f,
    		0x00000533,
    		0xfea42623,
    		0x0040006f,
    		0xfec42503,
    		0x0000f5b7,
    		0xa5f58593,
    		0x00a5ce63,
    		0x0040006f,
    		0x0040006f,
    		0xfec42503,
    		0x00150513,
    		0xfea42623,
    		0xfddff06f,
    		0x00000533,
    		0xfea42423,
    		0x0040006f,
    		0xfe842503,
    		0x0000f5b7,
    		0xa5f58593,
    		0x00a5ce63,
    		0x0040006f,
    		0x0040006f,
    		0xfe842503,
    		0x00150513,
    		0xfea42423,
    		0xfddff06f,
    		0x03000537,
    		0x00300593,
    		0x00b52023,
    		0x00000533,
    		0xfea42223,
    		0x0040006f,
    		0xfe442503,
    		0x0000f5b7,
    		0xa5f58593,
    		0x00a5ce63,
    		0x0040006f,
    		0x0040006f,
    		0xfe442503,
    		0x00150513,
    		0xfea42223,
    		0xfddff06f,
    		0x00000533,
    		0xfea42023,
    		0x0040006f,
    		0xfe042503,
    		0x0000f5b7,
    		0xa5f58593,
    		0x00a5ce63,
    		0x0040006f,
    		0x0040006f,
    		0xfe042503,
    		0x00150513,
    		0xfea42023,
    		0xfddff06f,
    		0x00000533,
    		0xfca42e23,
    		0x0040006f,
    		0xfdc42503,
    		0x0000f5b7,
    		0xa5f58593,
    		0x00a5ce63,
    		0x0040006f,
    		0x0040006f,
    		0xfdc42503,
    		0x00150513,
    		0xfca42e23,
    		0xfddff06f,
    		0x03000537,
    		0x00700593,
    		0x00b52023,
    		0x00000533,
    		0xfca42c23,
    		0x0040006f,
    		0xfd842503,
    		0x0000f5b7,
    		0xa5f58593,
    		0x00a5ce63,
    		0x0040006f,
    		0x0040006f,
    		0xfd842503,
    		0x00150513,
    		0xfca42c23,
    		0xfddff06f,
    		0x00000533,
    		0xfca42a23,
    		0x0040006f,
    		0xfd442503,
    		0x0000f5b7,
    		0xa5f58593,
    		0x00a5ce63,
    		0x0040006f,
    		0x0040006f,
    		0xfd442503,
    		0x00150513,
    		0xfca42a23,
    		0xfddff06f,
    		0x00000533,
    		0xfca42823,
    		0x0040006f,
    		0xfd042503,
    		0x0000f5b7,
    		0xa5f58593,
    		0x00a5ce63,
    		0x0040006f,
    		0x0040006f,
    		0xfd042503,
    		0x00150513,
    		0xfca42823,
    		0xfddff06f,
    		0x03000537,
    		0x00100593,
    		0x00b52023,
    		0xe09ff06f,

    };







for(int i=0;i<135;i++)
{
    VIS_AXI->DIN = (u32 ) text[i];
    VIS_AXI->ADDR |= VIS_AXI_WEN ;
    VIS_AXI->ADDR |= ((u32)i << 5);

    VIS_AXI->ADDR |= VIS_AXI_EN ; // Gatilho do enable por ultimo

   while(!(VIS_AXI->ADDR & VIS_AXI_OK)){
    	__asm("nop");
   }
    VIS_AXI->ADDR =0;
}



    VIS_AXI->RST=0;
    usleep(50);


    while(1){
    VIS_AXI->RST = 1;
    }







    cleanup_platform();
    return 0;
}
