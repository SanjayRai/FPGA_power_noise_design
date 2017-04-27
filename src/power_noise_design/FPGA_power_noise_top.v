`timescale 1ns / 1ps
module FPGA_power_noise_top #(
   	parameter LUT_REG = 1,
   	parameter NUM_BRAM = 500,
	parameter NUM_DSPS = 275
)(
	 input dut_clk,
	 input reset,
	 output FPGA_out
 );


   	wire dut_reset;
	wire dout_cmac;


   wire [NUM_BRAM-1:0] pass_i;
   wire [NUM_BRAM-1:0] fail_i;   
     (* mark_debug *) wire pass_out;
     (* mark_debug *) wire fail_out;
     (* mark_debug *) wire logic_out_f;
     (* mark_debug *) wire [LUT_REG-1 : 0] logic_out;
	
	// Output logic
        assign logic_out_f = ^logic_out;
	assign FPGA_out = logic_out_f & (pass_out ^ fail_out);
	assign dut_reset = reset;

   genvar x_t;
   generate
       for (x_t = 0; x_t < LUT_REG; x_t = x_t + 1) begin: gen_logic
           (*dont_touch = "true" *)logic_top #(.WIDTH(2000), .NO_INST(1)) logic_inst(
                .clkIn(dut_clk),
                .reset(dut_reset),
                .dout(logic_out[x_t])
                );
        end
    endgenerate


  // BRAM top   
   genvar gen_i;
   generate
      for (gen_i = 0; gen_i < NUM_BRAM; gen_i= gen_i+1) begin:gen_dut
	 bram_top #(.ID(gen_i)) bram_top_inst(
		 .clk         (dut_clk),
		 .rst         (dut_reset),
		 .pass        (pass_i[gen_i]),
		 .fail        (fail_i[gen_i])
		 );
      end
   endgenerate

   
 dsp_top #(.num_dsps(NUM_DSPS)) 
	dsp_top_inst ( .ref_clk_in(dut_clk),
            .reset(dut_reset),
            .pass(dout_cmac)
           );


   assign pass_out = dout_cmac & ( |pass_i);
   assign fail_out = |fail_i;

endmodule

