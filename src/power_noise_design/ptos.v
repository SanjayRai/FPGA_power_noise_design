(* dont_touch = "true" *) module ptos (clk,pin,dout);

parameter WIDTH = 4096;
parameter NO_INST = 60;

input clk;
output  dout;
input [WIDTH-1:0] pin;

(* shreg_extract = "no" *) reg [WIDTH-1:0] ff [NO_INST-1:0];
(* shreg_extract = "no" *) reg [WIDTH-1:0] ff_tmp;
(* shreg_extract = "no" *) reg [WIDTH-1:0] ff_tmp1;
integer i,j;

always @ (posedge clk)
begin
    ff[0] <= pin;
    for (i=0;i<NO_INST-1;i=i+1)
        ff[i+1] <= ff[i];

    ff_tmp <= ff[NO_INST-1];
    ff_tmp1[0] <= ff_tmp[0];
    for (j=0;j<WIDTH-1;j=j+1)
        ff_tmp1[j+1] <= ff_tmp1[j] ^ ff_tmp[j+1] ^ ~ff_tmp1[j+1];

end

assign dout = ff_tmp1[WIDTH-1];

endmodule 
