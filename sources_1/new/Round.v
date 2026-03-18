`timescale 1ns / 1ps

module Round(
input  [63:0] Current_Text,
output [63:0] Updated_Text
    );

// Xored Inputs are entered
// 1- S_box     2- Block_Shuffle    3- Round_Permutation  4- Nongeneric Xor Opperation
wire [63:0] State_Sboxed, State_Block_Shuffled, State_Round_Perumtated;

Big_Sbox  Big_Sbox_Layer (
.Big_Sbox_in   (Current_Text)        ,
.Big_Sbox_Out  (State_Sboxed)
); 


Permutation_Block_Shuffle Block_Shufle(
.Block_Shufle_in (State_Sboxed)  ,
.Block_Shufle_out(State_Block_Shuffled)
);


Round_Permutation_Big Round_Permutation_Big(
.Round_Permutation_in   (State_Block_Shuffled)    ,
.Round_Permutation_out  (State_Round_Perumtated)
);


Xor_Layer Non_Generic_Xor_Layer(
.Xor_Layer_in  (State_Round_Perumtated) ,
.Xor_Layer_out (Updated_Text)
    );


endmodule
