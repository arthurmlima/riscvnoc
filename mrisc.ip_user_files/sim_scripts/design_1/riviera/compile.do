vlib work
vlib riviera

vlib riviera/xilinx_vip
vlib riviera/xil_defaultlib
vlib riviera/xpm
vlib riviera/axi_infrastructure_v1_1_0
vlib riviera/axi_vip_v1_1_5
vlib riviera/zynq_ultra_ps_e_vip_v1_0_5
vlib riviera/lib_cdc_v1_0_2
vlib riviera/proc_sys_reset_v5_0_13
vlib riviera/generic_baseblocks_v2_1_0
vlib riviera/axi_register_slice_v2_1_19
vlib riviera/fifo_generator_v13_2_4
vlib riviera/axi_data_fifo_v2_1_18
vlib riviera/axi_crossbar_v2_1_20
vlib riviera/axi_protocol_converter_v2_1_19

vmap xilinx_vip riviera/xilinx_vip
vmap xil_defaultlib riviera/xil_defaultlib
vmap xpm riviera/xpm
vmap axi_infrastructure_v1_1_0 riviera/axi_infrastructure_v1_1_0
vmap axi_vip_v1_1_5 riviera/axi_vip_v1_1_5
vmap zynq_ultra_ps_e_vip_v1_0_5 riviera/zynq_ultra_ps_e_vip_v1_0_5
vmap lib_cdc_v1_0_2 riviera/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 riviera/proc_sys_reset_v5_0_13
vmap generic_baseblocks_v2_1_0 riviera/generic_baseblocks_v2_1_0
vmap axi_register_slice_v2_1_19 riviera/axi_register_slice_v2_1_19
vmap fifo_generator_v13_2_4 riviera/fifo_generator_v13_2_4
vmap axi_data_fifo_v2_1_18 riviera/axi_data_fifo_v2_1_18
vmap axi_crossbar_v2_1_20 riviera/axi_crossbar_v2_1_20
vmap axi_protocol_converter_v2_1_19 riviera/axi_protocol_converter_v2_1_19

vlog -work xilinx_vip  -sv2k12 "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_axi4streampc.sv" \
"C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_axi4pc.sv" \
"C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/xil_common_vip_pkg.sv" \
"C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_pkg.sv" \
"C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_pkg.sv" \
"C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi4stream_vip_if.sv" \
"C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/axi_vip_if.sv" \
"C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/clk_vip_if.sv" \
"C:/Xilinx/Vivado/2019.1/data/xilinx_vip/hdl/rst_vip_if.sv" \

vlog -work xil_defaultlib  -sv2k12 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
"C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -93 \
"C:/Xilinx/Vivado/2019.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work axi_infrastructure_v1_1_0  -v2k5 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl/axi_infrastructure_v1_1_vl_rfs.v" \

vlog -work axi_vip_v1_1_5  -sv2k12 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/d4a8/hdl/axi_vip_v1_1_vl_rfs.sv" \

vlog -work zynq_ultra_ps_e_vip_v1_0_5  -sv2k12 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl/zynq_ultra_ps_e_vip_v1_0_vl_rfs.sv" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim/design_1_zynq_ultra_ps_e_0_0_vip_wrapper.v" \
"../../../bd/design_1/ip/design_1_zcu104_0_0/sim/design_1_zcu104_0_0.v" \

vcom -work lib_cdc_v1_0_2 -93 \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ef1e/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -93 \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/8842/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -93 \
"../../../bd/design_1/ip/design_1_rst_ps8_0_100M_0/sim/design_1_rst_ps8_0_100M_0.vhd" \

vlog -work generic_baseblocks_v2_1_0  -v2k5 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/b752/hdl/generic_baseblocks_v2_1_vl_rfs.v" \

vlog -work axi_register_slice_v2_1_19  -v2k5 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/4d88/hdl/axi_register_slice_v2_1_vl_rfs.v" \

vlog -work fifo_generator_v13_2_4  -v2k5 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1f5a/simulation/fifo_generator_vlog_beh.v" \

vcom -work fifo_generator_v13_2_4 -93 \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.vhd" \

vlog -work fifo_generator_v13_2_4  -v2k5 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1f5a/hdl/fifo_generator_v13_2_rfs.v" \

vlog -work axi_data_fifo_v2_1_18  -v2k5 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/5b9c/hdl/axi_data_fifo_v2_1_vl_rfs.v" \

vlog -work axi_crossbar_v2_1_20  -v2k5 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ace7/hdl/axi_crossbar_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_xbar_0/sim/design_1_xbar_0.v" \
"../../../bd/design_1/ip/design_1_system_ila_0_0/bd_0/sim/bd_f60c.v" \
"../../../bd/design_1/ip/design_1_system_ila_0_0/bd_0/ip/ip_0/sim/bd_f60c_ila_lib_0.v" \
"../../../bd/design_1/ip/design_1_system_ila_0_0/sim/design_1_system_ila_0_0.v" \

vlog -work axi_protocol_converter_v2_1_19  -v2k5 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/c83a/hdl/axi_protocol_converter_v2_1_vl_rfs.v" \

vlog -work xil_defaultlib  -v2k5 "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/ec67/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/cac7/hdl" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0/sim_tlm" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ip/design_1_zynq_ultra_ps_e_0_0" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/1b7e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/122e/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/6887/hdl/verilog" "+incdir+../../../../mrisc.srcs/sources_1/bd/design_1/ipshared/9623/hdl/verilog" "+incdir+C:/Xilinx/Vivado/2019.1/data/xilinx_vip/include" \
"../../../bd/design_1/ip/design_1_auto_pc_0/sim/design_1_auto_pc_0.v" \
"../../../bd/design_1/sim/design_1.v" \

vlog -work xil_defaultlib \
"glbl.v"
