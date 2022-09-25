// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Sun Sep 25 07:08:49 2022
// Host        : DESKTOP-1Q96SJ0 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_zcu104_0_0_stub.v
// Design      : design_1_zcu104_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "zcu104,Vivado 2019.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, ser_tx, ser_rx, reset_riscv, IN_N, IN_N_ACK, 
  IN_S, IN_S_ACK, IN_E, IN_E_ACK, IN_W, IN_W_ACK, OUT_N, OUT_N_ACK, OUT_S, OUT_S_ACK, OUT_E, OUT_E_ACK, 
  OUT_W, OUT_W_ACK, axi_image_pixel, axi_image_x, axi_image_y, axi_image_req, axi_image_ack, 
  entrada_init_prog_fim, saida_init_prog_fim, s00_axi_aclk, s00_axi_aresetn, 
  s00_axi_awaddr, s00_axi_awprot, s00_axi_awvalid, s00_axi_awready, s00_axi_wdata, 
  s00_axi_wstrb, s00_axi_wvalid, s00_axi_wready, s00_axi_bresp, s00_axi_bvalid, 
  s00_axi_bready, s00_axi_araddr, s00_axi_arprot, s00_axi_arvalid, s00_axi_arready, 
  s00_axi_rdata, s00_axi_rresp, s00_axi_rvalid, s00_axi_rready)
/* synthesis syn_black_box black_box_pad_pin="clk,ser_tx,ser_rx,reset_riscv,IN_N[63:0],IN_N_ACK,IN_S[63:0],IN_S_ACK,IN_E[63:0],IN_E_ACK,IN_W[63:0],IN_W_ACK,OUT_N[63:0],OUT_N_ACK,OUT_S[63:0],OUT_S_ACK,OUT_E[63:0],OUT_E_ACK,OUT_W[63:0],OUT_W_ACK,axi_image_pixel[31:0],axi_image_x[31:0],axi_image_y[31:0],axi_image_req[31:0],axi_image_ack[31:0],entrada_init_prog_fim[31:0],saida_init_prog_fim,s00_axi_aclk,s00_axi_aresetn,s00_axi_awaddr[31:0],s00_axi_awprot[2:0],s00_axi_awvalid,s00_axi_awready,s00_axi_wdata[31:0],s00_axi_wstrb[3:0],s00_axi_wvalid,s00_axi_wready,s00_axi_bresp[1:0],s00_axi_bvalid,s00_axi_bready,s00_axi_araddr[14:0],s00_axi_arprot[2:0],s00_axi_arvalid,s00_axi_arready,s00_axi_rdata[31:0],s00_axi_rresp[1:0],s00_axi_rvalid,s00_axi_rready" */;
  input clk;
  output ser_tx;
  input ser_rx;
  output reset_riscv;
  input [63:0]IN_N;
  output IN_N_ACK;
  input [63:0]IN_S;
  output IN_S_ACK;
  input [63:0]IN_E;
  output IN_E_ACK;
  input [63:0]IN_W;
  output IN_W_ACK;
  output [63:0]OUT_N;
  input OUT_N_ACK;
  output [63:0]OUT_S;
  input OUT_S_ACK;
  output [63:0]OUT_E;
  input OUT_E_ACK;
  output [63:0]OUT_W;
  input OUT_W_ACK;
  input [31:0]axi_image_pixel;
  input [31:0]axi_image_x;
  input [31:0]axi_image_y;
  input [31:0]axi_image_req;
  output [31:0]axi_image_ack;
  input [31:0]entrada_init_prog_fim;
  output saida_init_prog_fim;
  input s00_axi_aclk;
  input s00_axi_aresetn;
  input [31:0]s00_axi_awaddr;
  input [2:0]s00_axi_awprot;
  input s00_axi_awvalid;
  output s00_axi_awready;
  input [31:0]s00_axi_wdata;
  input [3:0]s00_axi_wstrb;
  input s00_axi_wvalid;
  output s00_axi_wready;
  output [1:0]s00_axi_bresp;
  output s00_axi_bvalid;
  input s00_axi_bready;
  input [14:0]s00_axi_araddr;
  input [2:0]s00_axi_arprot;
  input s00_axi_arvalid;
  output s00_axi_arready;
  output [31:0]s00_axi_rdata;
  output [1:0]s00_axi_rresp;
  output s00_axi_rvalid;
  input s00_axi_rready;
endmodule
