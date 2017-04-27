
`timescale 1ns / 1ps
module power_noise_top(
	 input CLK_125MHZ_P,
	 input CLK_125MHZ_N,
	 output FPGA_out
 );

parameter NUM_PN_UNITS = 2;
parameter LUT_REG = 75; //Orig(75)
parameter NUM_BRAM = 800; //Orig(800)
parameter NUM_DSPS = 2500; //Orig(2500)
 wire [(NUM_PN_UNITS-1):0]  FPGA_out_i;

wire  dut_clk_100Mhz;
wire reset;

assign reset = 1'b0;
  clk_wiz_125M_in_100M_out instance_name
   (
    // Clock out ports
    .clk_out1(dut_clk_100Mhz),     // output clk_out1
   // Clock in ports
    .clk_in1_p(CLK_125MHZ_P),    // input clk_in1_p
    .clk_in1_n(CLK_125MHZ_N));    // input clk_in1_n


genvar x_t;
generate
   for (x_t = 0; x_t < NUM_PN_UNITS; x_t = x_t + 1) begin: gen_U_power_noise
    (*dont_touch = "true" *)FPGA_power_noise_top #(
            .LUT_REG(LUT_REG),
            .NUM_BRAM(NUM_BRAM),
            .NUM_DSPS(NUM_DSPS)
    ) U_UUT (
             .dut_clk(dut_clk_100Mhz),
             .reset(reset),
             .FPGA_out(FPGA_out_i[x_t])
     );
    end
endgenerate

assign FPGA_out = ^FPGA_out_i;

endmodule
