module logic_top (
	input clkIn, reset, output dout);
parameter WIDTH = 700; // SLL crossing
parameter NO_INST = 60;

   reg  din;
   wire clk;
   wire [WIDTH-1:0] pout;
	
// __SRAI  BUFG bufg_inst
// __SRAI         (
// __SRAI          .O (clk),
// __SRAI          .I (clkIn)
// __SRAI          );

assign clk = clkIn;


   // Input pattern gen
   always @(negedge clk)
     if(reset)
       din <= 0;
     else
       din <= ~din;

   
stop #(.WIDTH(WIDTH),
       .NO_INST(NO_INST)
      )
     inst_s (.clk(clk),
             .pout(pout),
             .din(din)
            );

ptos #(.WIDTH(WIDTH),
       .NO_INST(NO_INST)
      )
     inst_p (.clk(clk),
             .pin(pout),
             .dout(dout)
            );
			
endmodule
