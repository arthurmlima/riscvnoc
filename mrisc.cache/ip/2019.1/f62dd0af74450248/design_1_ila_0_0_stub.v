// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
// Date        : Tue Sep 20 09:56:00 2022
// Host        : DESKTOP-1Q96SJ0 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ design_1_ila_0_0_stub.v
// Design      : design_1_ila_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu7ev-ffvc1156-2-e
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2019.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, probe0, probe1, probe2, probe3, probe4, probe5, 
  probe6, probe7, probe8, probe9, probe10, probe11, probe12, probe13)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[7:0],probe1[7:0],probe2[7:0],probe3[7:0],probe4[0:0],probe5[0:0],probe6[7:0],probe7[7:0],probe8[7:0],probe9[7:0],probe10[7:0],probe11[0:0],probe12[9:0],probe13[9:0]" */;
  input clk;
  input [7:0]probe0;
  input [7:0]probe1;
  input [7:0]probe2;
  input [7:0]probe3;
  input [0:0]probe4;
  input [0:0]probe5;
  input [7:0]probe6;
  input [7:0]probe7;
  input [7:0]probe8;
  input [7:0]probe9;
  input [7:0]probe10;
  input [0:0]probe11;
  input [9:0]probe12;
  input [9:0]probe13;
endmodule