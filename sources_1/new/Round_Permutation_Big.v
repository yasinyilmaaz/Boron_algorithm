`timescale 1ns / 1ps

module Round_Permutation_Big(
input  wire     [63:0] Round_Permutation_in,
output wire      [63:0] Round_Permutation_out
);
    
wire [15:0] Samples [3:0];
assign  Samples[0]  =      Round_Permutation_in  [15:0]  ;
assign  Samples[1]  =      Round_Permutation_in  [31:16];
assign  Samples[2]  =      Round_Permutation_in  [47:32];
assign  Samples[3]  =      Round_Permutation_in  [63:48];

localparam  DATA_LEN            =   16,
            SHIFT_AMOUNT        =   15,
            shit_amount_Zero    =   1,
            shit_amount_One     =   4,
            shit_amount_Two     =   7,
            shit_amount_Three    =  9;
            
wire [3:0] Shitf_Amounts [3:0];
assign Shitf_Amounts[0]   =  shit_amount_Zero;
assign Shitf_Amounts[1]   =  shit_amount_One ;
assign Shitf_Amounts[2]   =  shit_amount_Two ;
assign Shitf_Amounts[3]   =  shit_amount_Three;


 Round_Perm #(.DATA_LEN(DATA_LEN) , .SHIFT_AMOUNT(1))    Round_Perm_Zero(.In_Round_Perm(Samples[0]) , .Out_Round_Perm(Round_Permutation_out[15:0]));
 Round_Perm #(.DATA_LEN(DATA_LEN) , .SHIFT_AMOUNT(4))     Round_Perm_One(.In_Round_Perm(Samples[1]) , .Out_Round_Perm(Round_Permutation_out[31:16]));
 Round_Perm #(.DATA_LEN(DATA_LEN) , .SHIFT_AMOUNT(7))     Round_Perm_Two(.In_Round_Perm(Samples[2]) , .Out_Round_Perm(Round_Permutation_out[47:32]));
 Round_Perm #(.DATA_LEN(DATA_LEN) , .SHIFT_AMOUNT(9))   Round_Perm_Three(.In_Round_Perm(Samples[3]) , .Out_Round_Perm(Round_Permutation_out[63:48]));
  
        
    
  
endmodule
