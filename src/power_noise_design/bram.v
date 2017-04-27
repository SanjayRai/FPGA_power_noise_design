(* DONT_TOUCH = "TRUE" *)
module bram ( wrclk, wraddr, din, rst, we, porta_en, rdclk, portb_en, reg_en, rdaddr, dout);
parameter REG_EN = 0;
parameter PRT_B_EN = 0;
parameter NON_TP = 0;
parameter A_WID = 11;
parameter D_WID = 16;
parameter OPT_OUT = 1;
parameter IS_RST = 0;
parameter ONE_CLK = 0;
parameter PRT_A_EN = 0;
parameter MODE = "WRITE_FIRST";

input wrclk;
input [A_WID-1:0] wraddr;
input [D_WID-1:0] din;
input rst;
input rdclk;
input porta_en;
input portb_en;
input reg_en;
input [A_WID-1:0] rdaddr;	
input we;
output [D_WID-1:0] dout;

reg [D_WID-1:0] dout;

reg [D_WID-1:0] mem [(1<<A_WID)-1-NON_TP:0];


wire rst_int     = IS_RST ? rst : 1'b0;
wire reg_en_int  = REG_EN ? reg_en : 1'b1;
wire porta_en_int = PRT_A_EN ? porta_en : 1'b1;
wire portb_en_int = PRT_B_EN ? portb_en : 1'b1;

localparam RST_VAL = 'hFA;
wire wrclk_int;

generate
 begin
  if(ONE_CLK == 1)
    assign wrclk_int = rdclk;
  else
    assign wrclk_int = wrclk;
 end
endgenerate

reg [D_WID-1:0] dout_i;

// Write
always @ (posedge wrclk_int) 
  begin
   if(porta_en_int)
    if(we)
     mem[wraddr] <= din;
  end


   reg [A_WID-1:0] rdaddr_r;	
    // Read
    always @ (posedge rdclk)
      begin
       if(portb_en_int)
         begin
  	     rdaddr_r <= rdaddr;	
	 end
      end

     always @ *
       dout = mem[rdaddr_r];		

endmodule	
	      
				
	                
	     
