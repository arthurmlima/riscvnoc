2
// primeira coisa é escrever a função que estabelece a leitura.
void distribute_image_from_zynq(void)
{
    uint32_t volatile count=0;
    while(count!=IMAGE_WIDTH*IMAGE_HEIGHT)
    {
  // esperar o request 
    while((AXI_IM_TRANFER_REQ & 0x2)==0);

   
  // verificar se o pixel é da memoria interna 
  if(check_local_pixel(AXI_IM_TRANFER_X,AXI_IM_TRANFER_Y)!=0)
  {
    set_pixel(AXI_IM_TRANFER_PIXEL,AXI_IM_TRANFER_X,AXI_IM_TRANFER_Y,step,frame);
    if( AXI_IM_TRANFER_X== X_INIT + SUB_IMAG_WIDTH )
  } 
  else 
  {
   write_gpio(AXI_IM_TRANFER_PIXEL,AXI_IM_TRANFER_X,AXI_IM_TRANFER_Y,0,0,0,0,1);
  }  

    AXI_IM_TRANFER_ACK=1;

    // esperar reset do req 
    while((AXI_IM_TRANFER_REQ & 0x2)!=1);
    
    AXI_IM_TRANFER_ACK=0;
    
    count=count+1
    }
}

//retorna 1 quando e local 
//retorna 0 quando e remoto
int check_local_pixel(uint32_t x,uint32_t y)
{
    if( ((x >= X_INIT) & (x< X_INIT+SUB_IMAG_WIDTH)) && ((Y >= Y_INIT) & (x< Y_INIT+SUB_IMAG_HEIGHT)) )
    {
    return 1;
    }
    return 0;
    
}










// para os tiles que nao fazem nada 
void get_first_image_recv(void)
{
get_and_set_local_image_from_zynq_recv();
send_transfer_finished_notice_recv();
}

void send_transfer_finished_notice_recv(void)
{
    write_gpio(0,x,y,0,0,0,0,1);
}


void get_and_set_local_image_from_zynq_recv(void)
{
    for(volatile uint32_t i = 0; i < SUB_IMAG_HEIGHT; i++)
    {   
        for(volatile uint32_t j = 0; j < SUB_IMAG_WIDTH; j++)
        {
        set_local_pixel_from_zynq_recv();
        }
    }    
}

void get_and_set_local_pixel_from_zynq_recv(void)
{       
    read_gpio();
    set_pm_pixel(read_message_pixelValue,read_message_xDest,read_message_yDest,0,0);
}















//funcs referentes aos tiles de fora

void get_first_image_recv(void)
{
get_and_set_local_image_from_zynq_recv();
send_transfer_finished_notice_recv();
}

void send_transfer_finished_notice_recv(void)
{
    write_gpio(0,x,y,0,0,0,0,1);
}


void get_and_set_local_image_from_zynq_recv(void)
{
    for(volatile uint32_t i = 0; i < SUB_IMAG_HEIGHT; i++)
    {   
        for(volatile uint32_t j = 0; j < SUB_IMAG_WIDTH; j++)
        {
        set_local_pixel_from_zynq_recv();
        }
    }    
}

void get_and_set_local_pixel_from_zynq_recv(void)
{       
    read_gpio();
    set_pm_pixel(read_message_pixelValue,read_message_xDest,read_message_yDest,0,0);
}


