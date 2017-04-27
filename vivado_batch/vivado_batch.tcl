# Created : 19:3:37, Thu Nov 10, 2016 : Sanjay Rai

source ../device_type.tcl


set TOP_module power_noise_top

create_project -in_memory -part [DEVICE_TYPE] 

read_ip {
../IP/clk_wiz_125M_in_100M_out/clk_wiz_125M_in_100M_out.xci
}

read_verilog {
../src/power_noise_design/bram.v
../src/power_noise_design/bram_top.v
../src/power_noise_design/dsp.v
../src/power_noise_design/dsp_top.v
../src/power_noise_design/logic_top.v
../src/power_noise_design/ptos.v
../src/power_noise_design/stop.v
../src/power_noise_design/FPGA_top.v
../src/power_noise_design/FPGA_power_noise_top.v
../src/power_noise_top.v
}

read_xdc {
../src/xdc/power_noise_top.xdc
}

synth_design -top $TOP_module -part [DEVICE_TYPE]  -keep_equivalent_registers
opt_design -verbose -directive Explore
report_utilization -name util_1

proc run_rest {ARGV_0} {

upvar 1 $ARGV_0 design_name

write_debug_probes -force $design_name.ltx
write_checkpoint -force $design_name.post_synth_opt.dcp
set_param bitstream.enablePR 4123
set_property BITSTREAM.CONFIG.CONFIGRATE 85.0 [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR YES [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]
place_design -verbose -directive ExtraNetDelay_high
write_checkpoint -force $design_name.post_place.dcp
phys_opt_design  -verbose -directive Explore
write_checkpoint -force $design_name.post_place_phys_opt.dcp
route_design  -verbose -directive Explore
write_checkpoint -force $design_name.post_route.dcp
phys_opt_design  -verbose -directive Explore
write_checkpoint -force $design_name.post_route_phys_opt.dcp
report_design_analysis -complexity -timing -setup -max_paths 10 -congestion -file $design_name.design_analysis_report.txt 
report_timing_summary -file $design_name.timing_summary.rpt
report_drc -file $design_name.drc.rpt
write_bitstream -bin_file $design_name.bit      
write_cfgmem  -format mcs -size 128 -interface SPIx4 -loadbit "up 0x00000000 $design_name.bit " -file "$design_name.mcs"
}

proc prog_spi {ARGV_0} {
upvar 1 $ARGV_0 design_name
open_hw
connect_hw_server -url localhost:3121
current_hw_target [get_hw_targets */xilinx_tcf/Digilent/210251A0102D]
set_property PARAM.FREQUENCY 15000000 [get_hw_targets */xilinx_tcf/Digilent/210251A0102D]
open_hw_target
current_hw_device [lindex [get_hw_devices xcvu9p_0] 0]
refresh_hw_device -update_hw_probes false [lindex [get_hw_devices xcvu9p_0] 0]
create_hw_cfgmem -hw_device [lindex [get_hw_devices] 0] -mem_dev  [lindex [get_cfgmem_parts {mt25qu01g-spi-x1_x2_x4}] 0]
refresh_hw_device [lindex [get_hw_devices xcvu9p_0] 0]
set_property PROGRAM.PRM_FILES "./$design_name.prm" [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
set_property PROGRAM.ADDRESS_RANGE  {use_file} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.FILES "./$design_name.mcs" [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
set_property PROGRAM.PRM_FILE {./$design_name.prm} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0]]
set_property PROGRAM.UNUSED_PIN_TERMINATION {pull-none} [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.BLANK_CHECK  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.ERASE  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.CFG_PROGRAM  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.VERIFY  1 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
set_property PROGRAM.CHECKSUM  0 [ get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]
startgroup 
if {![string equal [get_property PROGRAM.HW_CFGMEM_TYPE  [lindex [get_hw_devices] 0]] [get_property MEM_TYPE [get_property CFGMEM_PART [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]]]] }  { create_hw_bitstream -hw_device [lindex [get_hw_devices] 0] [get_property PROGRAM.HW_CFGMEM_BITFILE [ lindex [get_hw_devices] 0]]; program_hw_devices [lindex [get_hw_devices] 0]; }; 
program_hw_cfgmem -hw_cfgmem [get_property PROGRAM.HW_CFGMEM [lindex [get_hw_devices] 0 ]]

}
#
run_rest TOP_module
#prog_spi TOP_module
