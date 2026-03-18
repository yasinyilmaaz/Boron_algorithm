`timescale 1ns / 1ps


module Dec_Round( 
input  [63:0] Current_Text,
output [63:0] Updated_Text
    );

// Xored Inputs are entered
// 1- S_box     2- Block_Shuffle    3- Round_Permutation  4- Nongeneric Xor Opperation Encrypt
//Opposite Decrypt

wire [63:0] State_Sboxed, State_Block_Shuffled, State_Round_Xored, State_Round_Perumtated;

Dec_Big_Sbox  Big_Sbox_Layer (
.Big_Sbox_in   (State_Block_Shuffled)        ,
.Big_Sbox_Out  (State_Sboxed)
); 


Dec_Block_Shuffle Dec_Block_Shufle(
.Dec_Block_Shuffle_in(State_Round_Perumtated)  ,
.Dec_Block_Shuffle_out(State_Block_Shuffled)
);


Dec_Round_Permutation_Big Round_Permutation_Big(
.Round_Permutation_in   (State_Round_Xored)    ,
.Round_Permutation_out  (State_Round_Perumtated)
);


Dec_Non_Generic_Xor Dec_Non_Generic_Xor_Layer(
.Xor_Layer_out  (State_Round_Xored) ,
.Xor_Layer_in   (Current_Text)
    );

assign Updated_Text=  State_Sboxed ;

endmodule