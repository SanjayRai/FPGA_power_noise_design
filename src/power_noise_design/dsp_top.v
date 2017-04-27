//////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2005 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: 13.3
//  /   /         Filename: 
// /___/   /\     Date Last Modified:
// \   \  /  \    Date Created : 22 Aug 2011
//  \___\/\___\   Department : DSV - India
//                
//Device: 7 series
//Purpose: Synthesizable TB for cascaded DSP
//Reference:
//    
//Revision History:
//    1.0 - Initial, ksubram , Mon Apr 02 2012
//    1.1 - Updated for power harness, ksubram , Wed Jun 06 2012
///////////////////////////////////////////////////////////////////////////////
module dsp_top( ref_clk_in,
            reset,
            pass
           );
   parameter width = 8;
   parameter num_dsps = 88; //325T - 140 per column
   parameter NUM_CYCLES = 1000; // Number of random vectors

input           ref_clk_in;
input           reset;
output          pass;

   
   reg [width-1:0] a,b;
   wire [2*width:0] out1,out2;
   reg [width-1:0]  rnd = 1;

   integer ram_cnt, clk_cnt;
   wire dsp_clk;

   assign dsp_clk = ref_clk_in;

  // DUT instantiation
// __SRAI  (* DONT_TOUCH = "TRUE" *)
  dsp   #  (
      .num_dsps(num_dsps/2),
      .width(width)
      ) dsp_i1  (
                 .clk(dsp_clk),
                 .rst(reset),
                 .a(a),
                 .b(b),
                 .out(out1)
                );
// __SRAI  (* DONT_TOUCH = "TRUE" *)
  dsp   #  (
      .num_dsps(num_dsps/2),
      .width(width)
      ) dsp_i2  (
                 .clk(dsp_clk),
                 .rst(reset),
                 .a(b),
                 .b(a),
                 .out(out2)
                );

assign pass = out1&out2;
   // Stimulus
   always @(negedge dsp_clk) begin
      if(reset) begin
	 clk_cnt <= 0;
	 rnd <= 1;
      end
      else begin
	 if(clk_cnt < NUM_CYCLES) begin
	    gen_rand();
	    a <= rnd;
	    gen_rand();      
	    b <= rnd;
	    clk_cnt <= clk_cnt + 1;
	 end
	 else begin
	    clk_cnt <= 0;
	    rnd <= 8'd1;
	 end
      end
   end


   
   task gen_rand ();
      begin
	 rnd <= {rnd[6:0], rnd[7] ^ rnd[5] ^ rnd[4] ^ rnd[3]}; // polynomial for maximal LFSR
      end
   endtask
  
endmodule // top
