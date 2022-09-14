//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Wed Sep 14 06:04:16 2022
//Host        : DESKTOP-1Q96SJ0 running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (led1_0,
    led2_0,
    reset_riscv_0,
    ser_rx_0,
    ser_rx_1,
    ser_tx_0,
    ser_tx_1);
  output led1_0;
  output led2_0;
  output reset_riscv_0;
  input ser_rx_0;
  input ser_rx_1;
  output ser_tx_0;
  output ser_tx_1;

  wire led1_0;
  wire led2_0;
  wire reset_riscv_0;
  wire ser_rx_0;
  wire ser_rx_1;
  wire ser_tx_0;
  wire ser_tx_1;

  design_1 design_1_i
       (.led1_0(led1_0),
        .led2_0(led2_0),
        .reset_riscv_0(reset_riscv_0),
        .ser_rx_0(ser_rx_0),
        .ser_rx_1(ser_rx_1),
        .ser_tx_0(ser_tx_0),
        .ser_tx_1(ser_tx_1));
endmodule
