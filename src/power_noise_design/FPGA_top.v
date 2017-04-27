`timescale 1ns / 1ps
module FPGA_top (
	 input dut_clk,
	 input reset,
	 output FPGA_out
 );

	// Resources FF = LOGIC * SIGNAL  (Should be < 1000000)
   	parameter LOGIC=20000;
	//parameter SIGNAL=1000;
	parameter SIGNAL=2;

   	parameter NUM_BRAM = 500; 
	parameter NUM_DSPs = 275;

   	wire dut_reset;
	wire en_stop_clks=1'b1; // BRAM en
	wire dout_cmac;


   wire [NUM_BRAM-1:0] pass_i;
   wire [NUM_BRAM-1:0] fail_i;   
     (* mark_debug *) wire pass_out;
     (* mark_debug *) wire fail_out;
	wire logic_out;
	
	// Output logic
	assign FPGA_out = logic_out & (pass_out ^ fail_out);
	assign dut_reset = reset;

   logic_top #(.WIDTH(SIGNAL), .NO_INST(LOGIC)) logic_inst(
	.clkIn(dut_clk),
	.reset(dut_reset),
	.dout(logic_out)
	);

  // BRAM top   
   genvar gen_i;
   generate
      for (gen_i = 0; gen_i < NUM_BRAM; gen_i= gen_i+1) begin:gen_dut
	 bram_top #(.ID(gen_i)) bram_top_inst(
		 .clk         (dut_clk),
		 .rst         (dut_reset),
		 .dut_start   (en_stop_clks),//----------> Control through Microblaze
		 .pass        (pass_i[gen_i]),
		 .fail        (fail_i[gen_i])
		 );
      end
   endgenerate

   
 dsp_top #(.num_dsps(NUM_DSPs)) 
	dsp_top_inst ( .ref_clk_in(dut_clk),
            .reset(dut_reset),
            .pass(dout_cmac)
           );


   assign pass_out = dout_cmac & ( |pass_i);
   assign fail_out = |fail_i;

endmodule

