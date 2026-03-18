
module Permutation_Block_Shuffle(
input  wire     [63:0] Block_Shufle_in,
output wire      [63:0] Block_Shufle_out
);
wire [15:0] Samples_Shuffled [3:0];
wire [15:0] Samples [3:0];
assign  Samples[0]  =      Block_Shufle_in  [15:0]   ;
assign  Samples[1]  =      Block_Shufle_in  [31:16]  ;
assign  Samples[2]  =      Block_Shufle_in  [47:32]  ;
assign  Samples[3]  =      Block_Shufle_in  [63:48]  ;

genvar ii;
 generate   for (ii=0;ii<=3; ii = ii +1 ) begin
   Small_Blokc_Shuffle Small_Blokc_Shuffle( .Block_Shuffle_in(Samples[ii]), .Block_Shuffle_out(Samples_Shuffled[ii]) );
 end endgenerate
 
assign   Block_Shufle_out = {Samples_Shuffled[3] ,Samples_Shuffled[2],Samples_Shuffled[1],Samples_Shuffled[0]} ;


endmodule