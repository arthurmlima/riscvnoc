/*
 *  PicoSoC - A simple example SoC using PicoRV32
 *
 *  Copyright (C) 2017  Claire Xenia Wolf <claire@yosyshq.com>
 *
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

`ifdef PICOSOC_V
`endif

module zcu104#(

parameter   ADDR_WIDTH      =  10, 
parameter   DATA_WIDTH      =  9,  // Data  Width in bits

parameter    integer  x_init =  0,
parameter    integer  y_init =  0, 

parameter    pix_depth =16  	,

parameter    img_width=8	 ,  
parameter    img_height=8 	 ,

parameter    subimg_width =10,
parameter    subimg_height=10,	

parameter    n_steps=5	 ,
parameter    n_frames=8   	 ,

parameter    a_steps=1	 ,
parameter    a_frames=1   	 ,

parameter    buffer_length=3,

parameter integer MEM_WORDS  =32768



)(

	input clk,

	output ser_tx,
	input ser_rx,

	output reset_riscv,
	                             
	input [63 : 0]   IN_N,
	output           IN_N_ACK,

	input [63 : 0]   IN_S,
	output           IN_S_ACK,

	input [63 : 0]   IN_E,
	output           IN_E_ACK,

 	input [63 : 0]   IN_W,   
 	output           IN_W_ACK,
  
	output[63 : 0]   OUT_N,
	input            OUT_N_ACK,	

	output[63 : 0]   OUT_S,
	input            OUT_S_ACK,		
		
	output[63 : 0]   OUT_E,	
	input            OUT_E_ACK,

	output[63 : 0]   OUT_W,	
	input            OUT_W_ACK,	



	input wire  s00_axi_aclk,
	input wire  s00_axi_aresetn,
	input wire [32-1 : 0] s00_axi_awaddr,
	input wire [2 : 0] s00_axi_awprot,
	input wire  s00_axi_awvalid,
	output wire  s00_axi_awready,
	input wire [32-1 : 0] s00_axi_wdata,
	input wire [(32/8)-1 : 0] s00_axi_wstrb,
	input wire  s00_axi_wvalid,
	output wire  s00_axi_wready,
	output wire [1 : 0] s00_axi_bresp,
	output wire  s00_axi_bvalid,
	input wire  s00_axi_bready,
	input wire [15-1 : 0] s00_axi_araddr,
	input wire [2 : 0] s00_axi_arprot,
	input wire  s00_axi_arvalid,
	output wire  s00_axi_arready,
	output wire [32-1 : 0] s00_axi_rdata,
	output wire [1 : 0] s00_axi_rresp,
	output wire  s00_axi_rvalid,
	input wire  s00_axi_rready
);

	wire led1;
	wire led2;
	wire led3;
	wire led4;
	wire led5;
	wire ledr_n;
	wire ledg_n;
	reg [63:0]  signal_out_pe_in_router_data;
	wire[63:0]  wsignal_in_pm_out_router_data;
	wire[63:0]  signal_out_pm_in_router_data;
	
  
    wire  wsignal_in_pe_out_router_ack;
	 
	 reg [63 : 0]  signal_in_pm_out_router_data;
	 	 

	 reg           signal_in_pm_out_router_ack;

 	 reg           signal_in_pe_out_router_ack;	   
     
     reg           signal_out_pe_in_router_ack;
     
wire wsignal_out_pm_in_router_ack;
wire wsignal_out_riscv_in_pm_ack;
wire[63:0] wsignal_out_pm_in_router_data;
assign wsignal_out_pm_in_router_data = 	signal_out_pm_in_router_data	;



	reg [5:0] reset_cnt = 0;
	wire resetn = &reset_cnt;

	always @(posedge clk) begin
		reset_cnt <= reset_cnt + !resetn;
	end
	reg [31:0] gpio;
	wire [7:0] leds;
	assign leds = gpio;

	assign led1 = leds[1];
	assign led2 = leds[2];
	assign led3 = leds[3];
	assign led4 = leds[4];
	assign led5 = leds[5];

	assign ledr_n = !leds[6];
	assign ledg_n = !leds[7];
		
	wire        iomem_valid;
	reg         iomem_ready;
	wire [3:0]  iomem_wstrb;
	wire [31:0] iomem_addr;
	wire [31:0] iomem_wdata;
	reg  [31:0] iomem_rdata;
	

wire wsignal_in_riscv_out_pm_ack;

wire  wsignal_out_pe_in_router_ack;
wire  wsignal_in_pe_out_pm_ack;
wire[63:0]  wsignal_in_pe_out_router_data;


wire wsignal_in_pm_out_router_ack;
wire[63:0] wsignal_out_riscv_in_pm_data;
wire  signal_out_pm_in_router_ack;

reg[63:0] signal_out_riscv_in_pm_data;
assign wsignal_out_riscv_in_pm_data = signal_out_riscv_in_pm_data;











always @(posedge clk) 
begin
	if (!reset_riscv) 
	begin
		gpio <= 0;
	end else 
		begin
			iomem_ready <= 0;
			if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 8'h 03) begin
				iomem_ready <= 1;
				iomem_rdata <= gpio;
				if (iomem_wstrb[0]) gpio[ 7: 0] <= iomem_wdata[ 7: 0];
				if (iomem_wstrb[1]) gpio[15: 8] <= iomem_wdata[15: 8];
				if (iomem_wstrb[2]) gpio[23:16] <= iomem_wdata[23:16];
				if (iomem_wstrb[3]) gpio[31:24] <= iomem_wdata[31:24];
		    end
		    
		    
//****************************************************************************************************************************			
//*************************************RISC LÊ DO ROTEADOR*************************************************************			
//****************************************************************************************************************************			
		    
			else if (iomem_valid && !iomem_ready && iomem_addr[31:0] == 32'h 0210_0000)  begin // le mensagem para risc primeiros 8 bytes
				iomem_ready <= 1;
				iomem_rdata <=  {wsignal_in_pe_out_router_data[31:1], iomem_wdata[0]};
				if (iomem_wstrb[0]) signal_out_pe_in_router_ack <= iomem_wdata[0];
			end	
			else if (iomem_valid && !iomem_ready && iomem_addr[31:0] == 32'h 0211_0000)  begin // le mensagem para risc ultimos 8 bytes
				iomem_ready <= 1;
				iomem_rdata <= wsignal_in_pe_out_router_data[63:32];
			end	


//****************************************************************************************************************************			
//*************************************RISC ESCREVE NO ROTEADOR*************************************************************			
//****************************************************************************************************************************							
			
			else if (iomem_valid && !iomem_ready && iomem_addr[31:0] == 32'h 0220_0000) begin // escreve mensagem para risc
				iomem_ready <= 1;
				iomem_rdata <= {signal_out_pe_in_router_data[31:1], wsignal_in_pe_out_router_ack};
				if (iomem_wstrb[0]) signal_out_pe_in_router_data[ 7: 0] <= {iomem_wdata[ 7: 1],wsignal_in_pe_out_router_ack};
				if (iomem_wstrb[1]) signal_out_pe_in_router_data[15: 8] <= iomem_wdata[15: 8];
				if (iomem_wstrb[2]) signal_out_pe_in_router_data[23:16] <= iomem_wdata[23:16];
				if (iomem_wstrb[3]) signal_out_pe_in_router_data[31:24] <= iomem_wdata[31:24];				
			end
			
		 else if (iomem_valid && !iomem_ready && iomem_addr[31:0] == 32'h 0221_0000) begin // escreve mensagem para risc
				iomem_ready <= 1;
				iomem_rdata <= signal_out_pe_in_router_data[31:0];
				if (iomem_wstrb[0]) signal_out_pe_in_router_data[39: 32] <= iomem_wdata[ 7: 0];
				if (iomem_wstrb[1]) signal_out_pe_in_router_data[47: 40] <= iomem_wdata[15: 8];
				if (iomem_wstrb[2]) signal_out_pe_in_router_data[55:48] <= iomem_wdata[23:16];
				if (iomem_wstrb[3]) signal_out_pe_in_router_data[63:56] <= iomem_wdata[31:24];				
			end
//****************************************************************************************************************************			
//****************************************************************************************************************************

			else if (iomem_valid && !iomem_ready && iomem_addr[31:0] == 32'h 0222_0000) begin // interface risc-pm
				iomem_ready <= 1;
				iomem_rdata <=      {signal_out_riscv_in_pm_data[31:1], wsignal_in_riscv_out_pm_ack};
				if (iomem_wstrb[0]) signal_out_riscv_in_pm_data[ 7: 0] <= {iomem_wdata[ 7: 1],wsignal_in_riscv_out_pm_ack};
				if (iomem_wstrb[1]) signal_out_riscv_in_pm_data[15: 8] <= iomem_wdata[15: 8];
				if (iomem_wstrb[2]) signal_out_riscv_in_pm_data[23:16] <= iomem_wdata[23:16];
				if (iomem_wstrb[3]) signal_out_riscv_in_pm_data[31:24] <= iomem_wdata[31:24];				
			end
			else if (iomem_valid && !iomem_ready && iomem_addr[31:0] == 32'h 0223_0000) begin // interface risc-pm
				iomem_ready <= 1;
				iomem_rdata <=      signal_out_riscv_in_pm_data[63:32] ;
				if (iomem_wstrb[0]) signal_out_riscv_in_pm_data[39:32] <=  iomem_wdata[7: 0];
				if (iomem_wstrb[1]) signal_out_riscv_in_pm_data[47:40] <=  iomem_wdata[15: 8];
				if (iomem_wstrb[2]) signal_out_riscv_in_pm_data[55:48]  <= iomem_wdata[23:16];
				if (iomem_wstrb[3]) signal_out_riscv_in_pm_data[63:56]  <= iomem_wdata[31:24];				
			end


			
		end
		
		
end


		
 
	picosoc #(
		.BARREL_SHIFTER(0),
		.ENABLE_MULDIV(0),
		.MEM_WORDS(MEM_WORDS)
	) soc (
		.clk          (clk         ),
		
		.resetn       (reset_riscv      ),
		.reset_riscv  (reset_riscv  ),
		
		.ser_tx       (ser_tx      ),
		.ser_rx       (ser_rx      ),

		.irq_5        (1'b0        ),
		.irq_6        (1'b0        ),
		.irq_7        (1'b0        ),

		.iomem_valid  (iomem_valid ),
		.iomem_ready  (iomem_ready ),
		.iomem_wstrb  (iomem_wstrb ),
		.iomem_addr   (iomem_addr  ),
		.iomem_wdata  (iomem_wdata ),
		.iomem_rdata  (iomem_rdata ),
		
		
		.s00_axi_aclk(s00_axi_aclk),
		.s00_axi_aresetn(s00_axi_aresetn),
		.s00_axi_awaddr(s00_axi_awaddr),
		.s00_axi_awprot(s00_axi_awprot),
		.s00_axi_awvalid(s00_axi_awvalid),
		.s00_axi_awready(s00_axi_awready),
		.s00_axi_wdata(s00_axi_wdata),
		.s00_axi_wstrb(s00_axi_wstrb),
		.s00_axi_wvalid(s00_axi_wvalid),
		.s00_axi_wready(s00_axi_wready),
		.s00_axi_bresp(s00_axi_bresp),
		.s00_axi_bvalid(s00_axi_bvalid),
		.s00_axi_bready(s00_axi_bready),
		.s00_axi_araddr(s00_axi_araddr),
		.s00_axi_arprot(s00_axi_arprot),
		.s00_axi_arvalid(s00_axi_arvalid),
		.s00_axi_arready(s00_axi_arready),
		.s00_axi_rdata(s00_axi_rdata),
		.s00_axi_rresp(s00_axi_rresp),
		.s00_axi_rvalid(s00_axi_rvalid),
		.s00_axi_rready(s00_axi_rready)
	);


	pm_wrapper #( 
         .pix_depth      (pix_depth),
         .addr_size       (10),
         .mem_size        (100),

         .img_width(img_width)	 ,  
         .img_height(img_height) 	 ,
         .subimg_width(subimg_width) ,	
         .subimg_height(subimg_height),	
         .n_steps(n_steps) 	 ,  
         .n_frames(n_frames),
         .a_steps(a_steps),
         .a_frames(a_frames),
         .x_init(x_init)       , 
         .y_init(y_init)       
	  	 

 )pm_wrapper(


.clk(clk),
.reset(!reset_riscv),

 
.input_data(wsignal_in_pm_out_router_data), 
.input_ack (signal_out_pm_in_router_ack ),
 
.input_riscv_data(wsignal_out_riscv_in_pm_data), 
.input_riscv_ack (wsignal_in_riscv_out_pm_ack ),
 
.output_data(signal_out_pm_in_router_data), 
.output_ack (wsignal_in_pm_out_router_ack) 

        
);



router_wrapper #(
        .x_init(x_init),
        .y_init(y_init),    
        .ADDR_WIDTH(10),  
        .DATA_WIDTH(9), 
        .pix_depth(pix_depth)  	 ,
        .img_width(img_width)	 ,  
        .img_height(img_height) 	 ,
        .subimg_width(subimg_width) ,	
        .subimg_height(subimg_height),	
        .n_steps(n_steps) 	 ,  
        .n_frames(n_frames)   	 ,
        .buffer_length(buffer_length)

 )router_wrapper(


.clk(clk),
.reset(!reset_riscv),
   
.in_router_out_pm_data(signal_out_pm_in_router_data), 
.out_router_in_pm_ack (wsignal_in_pm_out_router_ack ),
 
.out_router_in_pm_data(wsignal_in_pm_out_router_data), 
.in_router_out_pm_ack (signal_out_pm_in_router_ack),  

// canal de escrita
.in_router_out_pe_data(signal_out_pe_in_router_data), 
.out_router_in_pe_ack (wsignal_in_pe_out_router_ack ),
 
.out_router_in_pe_data(wsignal_in_pe_out_router_data), //i_data  
.in_router_out_pe_ack (signal_out_pe_in_router_ack),  
                                         
.in_router_out_N_data(IN_N),  
.out_router_in_n_ack (IN_N_ACK ),  

.out_router_in_n_data(OUT_N),  
.in_router_out_n_ack (OUT_N_ACK ),  
                      
                      
.in_router_out_s_data(IN_S  ),
.out_router_in_s_ack(IN_S_ACK   ),

.out_router_in_s_data(OUT_S  ),
.in_router_out_s_ack (OUT_S_ACK   ),
                                        
.in_router_out_e_data ( IN_E),
.out_router_in_e_ack  ( IN_E_ACK ),

.out_router_in_e_data ( OUT_E),
.in_router_out_e_ack  ( OUT_E_ACK ),
                                             
.in_router_out_w_data(IN_W),  
.out_router_in_w_ack (IN_W_ACK ),  

.out_router_in_w_data(OUT_W),  
.in_router_out_w_ack (OUT_W_ACK ) 


        
		);
		
endmodule