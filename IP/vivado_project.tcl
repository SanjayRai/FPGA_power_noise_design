# Created : 19:3:37, Thu Nov 10, 2016 : Sanjay Rai

source ../device_type.tcl
create_project project_X project_X -part [DEVICE_TYPE] 

add_files -fileset sources_1 -norecurse {
../IP/clk_wiz_125M_in_100M_out/clk_wiz_125M_in_100M_out.xci
}

