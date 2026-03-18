`timescale 1ns / 1ps


module Dec_Key_Scheduler
#(parameter Key_Bit_Size     =80, parameter Number_of_Rounds =26)
(
input       [4:0]Dec_Counter,
input       [79:0]Prev_Key,
output      [79:0]Dec_Updated_Key
    );

wire [4:0] Key_Reg_Round_MSB; assign Key_Reg_Round_MSB =  Prev_Key[63:59];
wire [4:0] Xor_Result;

wire [4:0]dec_counter_adjust ; assign dec_counter_adjust = Dec_Counter;
assign    Xor_Result =  (dec_counter_adjust) ^ Key_Reg_Round_MSB;


wire [3:0] Key_Reg_Round_LSB; assign Key_Reg_Round_LSB = Prev_Key[3:0];
wire [3:0] Key_Reg_Round_LSB_SBoxed;
Dec_S_box Dec_S_box(.S_box_in(Key_Reg_Round_LSB),  .S_box_out(Key_Reg_Round_LSB_SBoxed));

wire [79:0]Updated_Key;
// {Updated_Key: 80_bit} = {Rounded Key: 16_Bit} -- {XOR: 5_bit} -- {Rounded Key: 55_Bit} -- {S_box: 4_bit}
assign Updated_Key = {Prev_Key[79:64]  , Xor_Result,    Prev_Key[58:4],    Key_Reg_Round_LSB_SBoxed};


Dec_Round_Perm #(.DATA_LEN(Key_Bit_Size) , .SHIFT_AMOUNT(13)) Round_Perm(.In_Round_Perm(Updated_Key) , .Out_Round_Perm(Dec_Updated_Key));
//The key used in decncryption is least significant 64 bits

endmodule
