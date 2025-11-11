# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "BUS_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_MEM_LEN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "DATA_MEM_SUB_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR_MEM_LEN" -parent ${Page_0}
  ipgui::add_param $IPINST -name "INSTR_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.BUS_WIDTH { PARAM_VALUE.BUS_WIDTH } {
	# Procedure called to update BUS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BUS_WIDTH { PARAM_VALUE.BUS_WIDTH } {
	# Procedure called to validate BUS_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_MEM_LEN { PARAM_VALUE.DATA_MEM_LEN } {
	# Procedure called to update DATA_MEM_LEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_MEM_LEN { PARAM_VALUE.DATA_MEM_LEN } {
	# Procedure called to validate DATA_MEM_LEN
	return true
}

proc update_PARAM_VALUE.DATA_MEM_SUB_WIDTH { PARAM_VALUE.DATA_MEM_SUB_WIDTH } {
	# Procedure called to update DATA_MEM_SUB_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_MEM_SUB_WIDTH { PARAM_VALUE.DATA_MEM_SUB_WIDTH } {
	# Procedure called to validate DATA_MEM_SUB_WIDTH
	return true
}

proc update_PARAM_VALUE.INSTR_MEM_LEN { PARAM_VALUE.INSTR_MEM_LEN } {
	# Procedure called to update INSTR_MEM_LEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INSTR_MEM_LEN { PARAM_VALUE.INSTR_MEM_LEN } {
	# Procedure called to validate INSTR_MEM_LEN
	return true
}

proc update_PARAM_VALUE.INSTR_WIDTH { PARAM_VALUE.INSTR_WIDTH } {
	# Procedure called to update INSTR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INSTR_WIDTH { PARAM_VALUE.INSTR_WIDTH } {
	# Procedure called to validate INSTR_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.BUS_WIDTH { MODELPARAM_VALUE.BUS_WIDTH PARAM_VALUE.BUS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BUS_WIDTH}] ${MODELPARAM_VALUE.BUS_WIDTH}
}

proc update_MODELPARAM_VALUE.INSTR_MEM_LEN { MODELPARAM_VALUE.INSTR_MEM_LEN PARAM_VALUE.INSTR_MEM_LEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR_MEM_LEN}] ${MODELPARAM_VALUE.INSTR_MEM_LEN}
}

proc update_MODELPARAM_VALUE.INSTR_WIDTH { MODELPARAM_VALUE.INSTR_WIDTH PARAM_VALUE.INSTR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR_WIDTH}] ${MODELPARAM_VALUE.INSTR_WIDTH}
}

proc update_MODELPARAM_VALUE.DATA_MEM_LEN { MODELPARAM_VALUE.DATA_MEM_LEN PARAM_VALUE.DATA_MEM_LEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_MEM_LEN}] ${MODELPARAM_VALUE.DATA_MEM_LEN}
}

proc update_MODELPARAM_VALUE.DATA_MEM_SUB_WIDTH { MODELPARAM_VALUE.DATA_MEM_SUB_WIDTH PARAM_VALUE.DATA_MEM_SUB_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_MEM_SUB_WIDTH}] ${MODELPARAM_VALUE.DATA_MEM_SUB_WIDTH}
}

