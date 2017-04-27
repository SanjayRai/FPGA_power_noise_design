# Created : 19:3:37, Thu Nov 10, 2016 : Sanjay Rai

proc DEVICE_TYPE {} {
    return xcvu9p-flgb2104-2-i
}

proc HW_DEBUGGER {} {
open_hw
connect_hw_server -url mcmicro:3121
current_hw_target [get_hw_targets */xilinx_tcf/Digilent/210251893419]
set_property PARAM.FREQUENCY 15000000 [get_hw_targets */xilinx_tcf/Digilent/210251893419]
open_hw_target
current_hw_device [lindex [get_hw_devices] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]
}

