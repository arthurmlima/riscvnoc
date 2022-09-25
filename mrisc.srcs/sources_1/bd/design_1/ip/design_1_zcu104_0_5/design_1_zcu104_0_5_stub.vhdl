-- Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
-- Date        : Sun Sep 25 07:09:17 2022
-- Host        : DESKTOP-1Q96SJ0 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               C:/Users/arthu/mrisc/mrisc.srcs/sources_1/bd/design_1/ip/design_1_zcu104_0_5/design_1_zcu104_0_5_stub.vhdl
-- Design      : design_1_zcu104_0_5
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xczu7ev-ffvc1156-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_zcu104_0_5 is
  Port ( 
    clk : in STD_LOGIC;
    ser_tx : out STD_LOGIC;
    ser_rx : in STD_LOGIC;
    reset_riscv : out STD_LOGIC;
    IN_N : in STD_LOGIC_VECTOR ( 63 downto 0 );
    IN_N_ACK : out STD_LOGIC;
    IN_S : in STD_LOGIC_VECTOR ( 63 downto 0 );
    IN_S_ACK : out STD_LOGIC;
    IN_E : in STD_LOGIC_VECTOR ( 63 downto 0 );
    IN_E_ACK : out STD_LOGIC;
    IN_W : in STD_LOGIC_VECTOR ( 63 downto 0 );
    IN_W_ACK : out STD_LOGIC;
    OUT_N : out STD_LOGIC_VECTOR ( 63 downto 0 );
    OUT_N_ACK : in STD_LOGIC;
    OUT_S : out STD_LOGIC_VECTOR ( 63 downto 0 );
    OUT_S_ACK : in STD_LOGIC;
    OUT_E : out STD_LOGIC_VECTOR ( 63 downto 0 );
    OUT_E_ACK : in STD_LOGIC;
    OUT_W : out STD_LOGIC_VECTOR ( 63 downto 0 );
    OUT_W_ACK : in STD_LOGIC;
    axi_image_pixel : in STD_LOGIC_VECTOR ( 31 downto 0 );
    axi_image_x : in STD_LOGIC_VECTOR ( 31 downto 0 );
    axi_image_y : in STD_LOGIC_VECTOR ( 31 downto 0 );
    axi_image_req : in STD_LOGIC_VECTOR ( 31 downto 0 );
    axi_image_ack : out STD_LOGIC_VECTOR ( 31 downto 0 );
    entrada_init_prog_fim : in STD_LOGIC_VECTOR ( 31 downto 0 );
    saida_init_prog_fim : out STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 14 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );

end design_1_zcu104_0_5;

architecture stub of design_1_zcu104_0_5 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,ser_tx,ser_rx,reset_riscv,IN_N[63:0],IN_N_ACK,IN_S[63:0],IN_S_ACK,IN_E[63:0],IN_E_ACK,IN_W[63:0],IN_W_ACK,OUT_N[63:0],OUT_N_ACK,OUT_S[63:0],OUT_S_ACK,OUT_E[63:0],OUT_E_ACK,OUT_W[63:0],OUT_W_ACK,axi_image_pixel[31:0],axi_image_x[31:0],axi_image_y[31:0],axi_image_req[31:0],axi_image_ack[31:0],entrada_init_prog_fim[31:0],saida_init_prog_fim,s00_axi_aclk,s00_axi_aresetn,s00_axi_awaddr[31:0],s00_axi_awprot[2:0],s00_axi_awvalid,s00_axi_awready,s00_axi_wdata[31:0],s00_axi_wstrb[3:0],s00_axi_wvalid,s00_axi_wready,s00_axi_bresp[1:0],s00_axi_bvalid,s00_axi_bready,s00_axi_araddr[14:0],s00_axi_arprot[2:0],s00_axi_arvalid,s00_axi_arready,s00_axi_rdata[31:0],s00_axi_rresp[1:0],s00_axi_rvalid,s00_axi_rready";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "zcu104,Vivado 2019.1";
begin
end;
