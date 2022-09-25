//Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2019.1 (win64) Build 2552052 Fri May 24 14:49:42 MDT 2019
//Date        : Sun Sep 25 07:02:35 2022
//Host        : DESKTOP-1Q96SJ0 running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (ser_rx_0,
    ser_rx_1,
    ser_tx_0,
    ser_tx_1);
  input ser_rx_0;
  input ser_rx_1;
  output ser_tx_0;
  output ser_tx_1;

  wire ser_rx_0;
  wire ser_rx_1;
  wire ser_tx_0;
  wire ser_tx_1;

  design_1 design_1_i
       (.ser_rx_0(ser_rx_0),
        .ser_rx_1(ser_rx_1),
        .ser_tx_0(ser_tx_0),
        .ser_tx_1(ser_tx_1));
endmodule
