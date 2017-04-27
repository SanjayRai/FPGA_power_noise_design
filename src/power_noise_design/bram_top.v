(* DONT_TOUCH = "TRUE" *)
module bram_top(input clk, rst, output reg pass, fail);
   parameter ID = 0;
parameter REG_EN = 0;
parameter PRT_B_EN = 0;
parameter NON_TP = 0;
parameter A_WID = 9;
parameter D_WID = 72;
parameter OPT_OUT = 1;
parameter IS_RST = 0;
parameter ONE_CLK = 0;
parameter PRT_A_EN = 0;
parameter MODE = "WRITE_FIRST";


   reg 	rstChk;
   
   reg 	en_a, en_b;
   reg [1:0] enab;
   reg [3:0] rnd;
   
   
   reg[A_WID-1:0] addr_a = 0;
   reg [D_WID-1:0] din_a = 'hF_FFFF_FFFF;
   reg 		  we_a;
 		  
   reg[A_WID-1:0] addr_b = 'h01F;	
   wire [D_WID-1:0] din_b;
   reg 		  we_b;
   
   wire [D_WID-1:0] dout_a;
   wire [D_WID-1:0] dout_b;

   bram #(
	  .A_WID(A_WID),
	  .D_WID(D_WID)	  
	  ) bram_inst( .wrclk(clk), 
		   .wraddr(addr_a), 
		   .din(din_a), 
		   .rst(rst), 
		   .we(we_a), 
		   .porta_en(en_a), 
		   
		   .rdclk(clk), 
		   .portb_en(en_b), 
		   .reg_en(1'b1), 
		   .rdaddr(addr_b), 
		   .dout(dout_b)
		   );

   always @(negedge clk)
	if(rst) begin
	   addr_a <= 0;
	   addr_b <= 'h01F;
	   din_a <= 'hF_FFFF_FFFF;
	end	else begin
	   din_a [35:0] <= ~din_a[35:0];
	   addr_a <= addr_b;
	   addr_b <= addr_a;
	end
	     
    always @(negedge clk)
	if(rst) begin
	   we_a <= 0;
	   en_a <= 0;
	   en_b <= 0;
	end else begin
	   {en_a,en_b} <= 2'b11;
	   we_a <= 1'b1;
	end

   always @(posedge clk)
        if(rst) begin
           pass <= 0;
           fail <= 0;
        end else begin
           if ( (addr_b === 0 && dout_b !== 'hF_FFFF_FFFF) ||
                      (addr_b === 'h01F && dout_b !== 0) ) begin
              $display("ID: PortB failed", ID);
              fail <= 1;
           end else
             pass <= 1;
        end

	
endmodule // dp_ram_top
