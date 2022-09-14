# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MEM_WORDS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "buffer_length" -parent ${Page_0}
  ipgui::add_param $IPINST -name "img_height" -parent ${Page_0}
  ipgui::add_param $IPINST -name "img_width" -parent ${Page_0}
  ipgui::add_param $IPINST -name "n_frames" -parent ${Page_0}
  ipgui::add_param $IPINST -name "n_steps" -parent ${Page_0}
  ipgui::add_param $IPINST -name "pix_depth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "subimg_height" -parent ${Page_0}
  ipgui::add_param $IPINST -name "subimg_width" -parent ${Page_0}
  ipgui::add_param $IPINST -name "x_init" -parent ${Page_0}
  ipgui::add_param $IPINST -name "y_init" -parent ${Page_0}


}

proc update_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to update ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to validate ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.MEM_WORDS { PARAM_VALUE.MEM_WORDS } {
	# Procedure called to update MEM_WORDS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_WORDS { PARAM_VALUE.MEM_WORDS } {
	# Procedure called to validate MEM_WORDS
	return true
}

proc update_PARAM_VALUE.buffer_length { PARAM_VALUE.buffer_length } {
	# Procedure called to update buffer_length when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.buffer_length { PARAM_VALUE.buffer_length } {
	# Procedure called to validate buffer_length
	return true
}

proc update_PARAM_VALUE.img_height { PARAM_VALUE.img_height } {
	# Procedure called to update img_height when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.img_height { PARAM_VALUE.img_height } {
	# Procedure called to validate img_height
	return true
}

proc update_PARAM_VALUE.img_width { PARAM_VALUE.img_width } {
	# Procedure called to update img_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.img_width { PARAM_VALUE.img_width } {
	# Procedure called to validate img_width
	return true
}

proc update_PARAM_VALUE.n_frames { PARAM_VALUE.n_frames } {
	# Procedure called to update n_frames when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.n_frames { PARAM_VALUE.n_frames } {
	# Procedure called to validate n_frames
	return true
}

proc update_PARAM_VALUE.n_steps { PARAM_VALUE.n_steps } {
	# Procedure called to update n_steps when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.n_steps { PARAM_VALUE.n_steps } {
	# Procedure called to validate n_steps
	return true
}

proc update_PARAM_VALUE.pix_depth { PARAM_VALUE.pix_depth } {
	# Procedure called to update pix_depth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.pix_depth { PARAM_VALUE.pix_depth } {
	# Procedure called to validate pix_depth
	return true
}

proc update_PARAM_VALUE.subimg_height { PARAM_VALUE.subimg_height } {
	# Procedure called to update subimg_height when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.subimg_height { PARAM_VALUE.subimg_height } {
	# Procedure called to validate subimg_height
	return true
}

proc update_PARAM_VALUE.subimg_width { PARAM_VALUE.subimg_width } {
	# Procedure called to update subimg_width when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.subimg_width { PARAM_VALUE.subimg_width } {
	# Procedure called to validate subimg_width
	return true
}

proc update_PARAM_VALUE.x_init { PARAM_VALUE.x_init } {
	# Procedure called to update x_init when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.x_init { PARAM_VALUE.x_init } {
	# Procedure called to validate x_init
	return true
}

proc update_PARAM_VALUE.y_init { PARAM_VALUE.y_init } {
	# Procedure called to update y_init when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.y_init { PARAM_VALUE.y_init } {
	# Procedure called to validate y_init
	return true
}


proc update_MODELPARAM_VALUE.ADDR_WIDTH { MODELPARAM_VALUE.ADDR_WIDTH PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_WIDTH}] ${MODELPARAM_VALUE.ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.x_init { MODELPARAM_VALUE.x_init PARAM_VALUE.x_init } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.x_init}] ${MODELPARAM_VALUE.x_init}
}

proc update_MODELPARAM_VALUE.y_init { MODELPARAM_VALUE.y_init PARAM_VALUE.y_init } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.y_init}] ${MODELPARAM_VALUE.y_init}
}

proc update_MODELPARAM_VALUE.pix_depth { MODELPARAM_VALUE.pix_depth PARAM_VALUE.pix_depth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.pix_depth}] ${MODELPARAM_VALUE.pix_depth}
}

proc update_MODELPARAM_VALUE.img_width { MODELPARAM_VALUE.img_width PARAM_VALUE.img_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.img_width}] ${MODELPARAM_VALUE.img_width}
}

proc update_MODELPARAM_VALUE.img_height { MODELPARAM_VALUE.img_height PARAM_VALUE.img_height } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.img_height}] ${MODELPARAM_VALUE.img_height}
}

proc update_MODELPARAM_VALUE.subimg_width { MODELPARAM_VALUE.subimg_width PARAM_VALUE.subimg_width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.subimg_width}] ${MODELPARAM_VALUE.subimg_width}
}

proc update_MODELPARAM_VALUE.subimg_height { MODELPARAM_VALUE.subimg_height PARAM_VALUE.subimg_height } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.subimg_height}] ${MODELPARAM_VALUE.subimg_height}
}

proc update_MODELPARAM_VALUE.n_steps { MODELPARAM_VALUE.n_steps PARAM_VALUE.n_steps } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.n_steps}] ${MODELPARAM_VALUE.n_steps}
}

proc update_MODELPARAM_VALUE.n_frames { MODELPARAM_VALUE.n_frames PARAM_VALUE.n_frames } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.n_frames}] ${MODELPARAM_VALUE.n_frames}
}

proc update_MODELPARAM_VALUE.buffer_length { MODELPARAM_VALUE.buffer_length PARAM_VALUE.buffer_length } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.buffer_length}] ${MODELPARAM_VALUE.buffer_length}
}

proc update_MODELPARAM_VALUE.MEM_WORDS { MODELPARAM_VALUE.MEM_WORDS PARAM_VALUE.MEM_WORDS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_WORDS}] ${MODELPARAM_VALUE.MEM_WORDS}
}

