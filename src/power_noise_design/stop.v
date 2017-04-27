(* dont_touch = "true" *) module stop (
                clk,
                pout,
                din
            );
parameter WIDTH = 4096;
parameter NO_INST = 60;

input clk;
input din;
output [WIDTH-1:0] pout;

(* shreg_extract = "no" *) reg [WIDTH-1:0] ff [NO_INST-1:0];

(* shreg_extract = "no" *) reg [WIDTH-1:0] ff0;

integer i;
always @ (posedge clk)
begin
    ff0[0] <= din;
    for (i=0;i<WIDTH-1;i=i+1)
    ff0[i+1] <= ff0[i];


    ff[0] <= ff0;
    for (i=0;i<NO_INST-1;i=i+1)
        ff[i+1] <= ff[i];
end

assign    pout = ff[NO_INST-1];


endmodule 

