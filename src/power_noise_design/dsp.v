///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2005 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: 14.1
//  /   /         Filename: 
// /___/   /\     Date Last Modified:
// \   \  /  \    Date Created : 22 Mar 2012
//  \___\/\___\   Department : DSV - XHD
//                
//Device: 7 series
//Purpose: Power measurement on rich DSP designs
//Reference:
//    
//Revision History:
//    1.0 - Initial version for Power suite, ksubram , Thur Mar 22 2012
//
///////////////////////////////////////////////////////////////////////////////
(* DONT_TOUCH = "TRUE" *)
module dsp
  #  (
      parameter num_dsps = 8,
      parameter width    = 8
      )
   (
    input 	       clk,
    input 	       rst,
    input [width-1:0]  a,
    input [width-1:0]  b,
    output [2*width:0] out
    );

   wire [2*width:0]    c [num_dsps:0];
genvar i;
generate
 for(i=0;i<num_dsps;i=i+1)
   begin:casc
      wire [width-1:0] a_d1=a+i;
      mult # (
              .width(width)
              )
      u (
   	 .clk(clk), 	
         .rst(rst), 
         .a(a_d1),
         .b(b),
         .s(i),
         .c(c[i])
         ); 
   end
endgenerate
	integer j;
        reg [2*width:0] tmp;
	always @(posedge clk) 
	  if(rst)
	     tmp = 0;
	  else
  	     for(j=0;j<num_dsps;j=j+1)
		tmp = tmp + c[j];

assign out = tmp;

endmodule // dsp800

(* DONT_TOUCH = "TRUE" *)
(* use_dsp48 = "yes" *) module mult
           # (
               parameter width = 8 
              )
              (
               input clk, 
               input rst,
               input [width-1:0] a,
               input [width-1:0] b,
               input [2*width:0] s,
//               output reg [width-1:0] a_d1,
               output reg [2*width:0] c
              );

reg [width-1:0] a_d1, b_d1;
reg [2*width-1:9] m_reg;

always @ (posedge clk)
 begin
  if(rst)
    begin  
      a_d1 <= 0;
      b_d1 <= 0;
      c <= 0;
    end
  else
    begin
      a_d1 <= a;
      b_d1 <= b;
      c <= (a_d1 * b_d1)+ s;
    end
end

endmodule // mult

