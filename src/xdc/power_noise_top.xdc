create_clock -name CLK_125MHZ_free -period 8.0 [get_ports CLK_125MHZ_P]
set_property PACKAGE_PIN BA9 [get_ports CLK_125MHZ_P]
set_property IOSTANDARD LVDS [get_ports CLK_125MHZ_P]

set_property PACKAGE_PIN BC7 [get_ports FPGA_out]
set_property IOSTANDARD LVCMOS12 [get_ports FPGA_out]
