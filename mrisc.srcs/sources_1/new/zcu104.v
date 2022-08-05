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

module zcu104# (

parameter   ADDR_WIDTH          =  10, 
parameter   DATA_WIDTH      =  9,  // Data  Width in bits
parameter    x_init       , 
parameter    y_init       , 
parameter    pix_depth  	 ,
parameter    img_width	 ,  
parameter    img_height 	 ,
parameter    subimg_width ,	
parameter    subimg_height,	
parameter    n_steps	 ,  
parameter    n_frames   	 ,
parameter    buffer_length,
parameter integer MEM_WORDS 

)(
	input clk,

	output ser_tx,
	input ser_rx,

	output reset_riscv,

	output led1,
	output led2,
	output led3,
	output led4,
	output led5,

	output ledr_n,
	output ledg_n,
	

	                             
	input [63 : 0]   in_router_out_n_data,
	input [63 : 0]   in_router_out_s_data,
	input [63 : 0]   in_router_out_e_data,
 	input [63 : 0]   in_router_out_w_data,   
 	  
	output[63 : 0]   out_router_in_n_data,
	output[63 : 0]   out_router_in_s_data,	
	output[63 : 0]   out_router_in_e_data,	
	output[63 : 0]   out_router_in_w_data,	

	output           out_router_in_n_ack,
	output           out_router_in_s_ack,
	output           out_router_in_e_ack,
	output           out_router_in_w_ack,
	
	input            in_router_out_n_ack,	
	input            in_router_out_s_ack,		
	input            in_router_out_e_ack,
	input            in_router_out_w_ack,	


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

/*
****** Sinais de entrada do roteador que sao saidas do PM e PE ou de outros routers
*/


	 
	 
	 reg [63 : 0]  signal_in_pm_out_router_data;	 
	 reg [63 : 0]  signal_out_pm_in_router_data;	 
	 
	 
	 
 	 reg [63 : 0]  signal_out_pe_in_router_data;	   
     reg [63 : 0]  signal_in_pe_out_router_data;
     
     
     reg           signal_out_pe_in_router_ack;
	 reg           signal_in_pe_out_router_ack;
     
	 reg [63 : 0]  signal_in_N_out_router_data;	
	 reg [63 : 0]  signal_in_S_out_router_data;	
     reg [63 : 0]  signal_in_E_out_router_data;
     reg [63 : 0]  signal_in_W_out_router_data;	


	 reg           signal_out_pm_in_router_ack;
	 reg           signal_in_pm_out_router_ack;


	 
	 reg           signal_out_N_in_router_ack;	 
	 reg           signal_out_S_in_router_ack;	 	 	
	 reg           signal_out_E_in_router_ack;	 
	 reg           signal_out_W_in_router_ack;





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
	
	
	
	/// Gambiarras do tutu
	reg [31:0] read_message;	
	reg [31:0] write_message;
	reg write_ack;
	
	//gambiarras do tutu falando da pm
	// 
	reg  [31:0]bus_pixel_memory; //busao
	wire [8:0 ]in_pixel_memory; //sai da PM para memoria
	reg  [22:0]out_pixel_memory; //vem da memoria do risc para PM
	

	
	reg enA;
	reg weA;
	reg [9:0] addrA;
	reg [8:0] dinA;
	
	wire [8:0]doutA;
	wire doa_ok;
	
	 reg [pix_depth+img_width+img_height+img_width+img_height+n_frames+n_steps +2 -1 : 0] in_router_out_pm_data;          
     reg out_router_in_pm_ack;
     reg [pix_depth+img_width+img_height+img_width+img_height+n_frames+n_steps +2 -1 : 0] out_router_in_pm_data;   
     reg in_router_out_pm_ack;                                                         
     reg [pix_depth+img_width+img_height+img_width+img_height+n_frames+n_steps +2 -1 : 0] in_router_out_pe_data;  
     reg router_in_pe_ack;
     reg [pix_depth+img_width+img_height+img_width+img_height+n_frames+n_steps +2 -1 :0 0] out_router_in_pe_data;   
     reg in_router_out_pe_ack;
	
	
	
	///continuacao da gambi 
always @(posedge clk) 
begin
{dinA,addrA,weA,enA}=bus_pixel_memory[31:10];
bus_pixel_memory[9:0]={doutA,doa_ok};
end	 
	

/*
always @(posedge clk) 
begin
write_ack
end
*/
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
		    
			else if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 32'h C000_0000)  begin // le mensagem para risc primeiros 8 bytes
				iomem_ready <= 1;
				iomem_rdata <=  {signal_in_pe_out_router_data[31:1], iomem_wdata[0]};
				if (iomem_wstrb[0]) signal_out_pe_in_router_ack <= iomem_wdata[0];
			end	
			else if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 32'h C000_0004)  begin // le mensagem para risc ultimos 8 bytes
				iomem_ready <= 1;
				iomem_rdata <= signal_in_pe_out_router_data[63:32];
			end	


//****************************************************************************************************************************			
//*************************************RISC ESCREVE NO ROTEADOR*************************************************************			
//****************************************************************************************************************************							
			
			else if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 32'h C000_0008) begin // escreve mensagem para risc
				iomem_ready <= 1;
				iomem_rdata <= {signal_out_pe_in_router_data[31:1], signal_in_pe_out_router_ack};
				if (iomem_wstrb[0]) signal_out_pe_in_router_data[ 7: 0] <= {iomem_wdata[ 7: 1],signal_in_pe_out_router_ack};
				if (iomem_wstrb[1]) signal_out_pe_in_router_data[15: 8] <= iomem_wdata[15: 8];
				if (iomem_wstrb[2]) signal_out_pe_in_router_data[23:16] <= iomem_wdata[23:16];
				if (iomem_wstrb[3]) signal_out_pe_in_router_data[31:24] <= iomem_wdata[31:24];				
			end
			
		 else if (iomem_valid && !iomem_ready && iomem_addr[63:32] == 32'h C000_000A) begin // escreve mensagem para risc
				iomem_ready <= 1;
				iomem_rdata <= signal_out_pe_in_router_data[31:1];
				if (iomem_wstrb[0]) signal_out_pe_in_router_data[39: 32] <= iomem_wdata[ 7: 0];
				if (iomem_wstrb[1]) signal_out_pe_in_router_data[47: 40] <= iomem_wdata[15: 8];
				if (iomem_wstrb[2]) signal_out_pe_in_router_data[55:48] <= iomem_wdata[23:16];
				if (iomem_wstrb[3]) signal_out_pe_in_router_data[63:56] <= iomem_wdata[31:24];				
			end
//****************************************************************************************************************************			
//****************************************************************************************************************************







			
			
			else if (iomem_valid && !iomem_ready && iomem_addr[31:24] == 8'h 06) begin // PM<-->risc
				iomem_ready <= 1;
				iomem_rdata <= {bus_pixel_memory[31:10],doutA, doa_ok};
				if (iomem_wstrb[0]) bus_pixel_memory[ 7: 0] <= iomem_wdata[ 7: 0];
				if (iomem_wstrb[1]) bus_pixel_memory[15: 8] <= iomem_wdata[ 15: 8];
				if (iomem_wstrb[2]) bus_pixel_memory[23:16] <= iomem_wdata[23:16];
				if (iomem_wstrb[3]) bus_pixel_memory[31:24] <= iomem_wdata[31:24];				
			end

			
		end
		
		
end

pixel_memory #( 
        .ADDR_WIDTH(10),  
        .DATA_WIDTH(9)

 )pixel_memory_00(
 
		.clkA(clk),
		.weA(weA),
		.enaA(enA),
		.addrA(addrA),
		.dinA(dinA),
		.doutA(doutA),
        .doa_ok(doa_ok)
		);
		
		
	
 
 
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
	
router_wrapper #( 
        .ADDR_WIDTH(10),  
        .DATA_WIDTH(9), 
         .x_init()       , 
         .y_init()       , 
         .pix_depth()  	 ,
         .img_width()	 ,  
         .img_height() 	 ,
         .subimg_width() ,	
         .subimg_height(),	
         .n_steps() 	 ,  
         .n_frames()   	 ,
         .buffer_length()

 )router_wrapper(





      
.in_router_out_pm_data(signal_in_router_out_pm_data), 
.out_router_in_pm_ack (signal_out_router_in_pm_ack ), 
.out_router_in_pm_data(signal_out_router_in_pm_data), 
.in_router_out_pm_ack (signal_in_router_out_pm_ack ),                                            
.in_router_out_pe_data(signal_in_router_out_pe_data), 
.out_router_in_pe_ack (signal_out_router_in_pe_ack ), 
.out_router_in_pe_data(signal_out_router_in_pe_data), 
.in_router_out_pe_ack (signal_in_router_out_pe_ack ),  
                                         
.in_router_out_n_data(in_router_out_n_data),  
.out_router_in_n_ack (out_router_in_n_ack ),  
.out_router_in_n_data(out_router_in_n_data),  
.in_router_out_n_ack (in_router_out_n_ack ),  
                      
                      
.in_router_out_s_data  (in_router_out_s_data  ),
.out_router_in_s_ack(out_router_in_s_ack),
.out_router_in_s_data  (out_router_in_s_data  ),
.in_router_out_s_ack   (in_router_out_s_ack   ),
                    
                    
.in_router_out_e_data ( in_router_out_e_data),
.out_router_in_e_ack  ( out_router_in_e_ack ),
.out_router_in_e_data ( out_router_in_e_data),
.in_router_out_e_ack  ( in_router_out_e_ack ),
                      
                      
.in_router_out_w_data(in_router_out_e_data),  
.out_router_in_w_ack (out_router_in_e_ack ),  
.out_router_in_w_data(out_router_in_e_data),  
.in_router_out_w_ack (in_router_out_e_ack )  



        
		);
endmodule