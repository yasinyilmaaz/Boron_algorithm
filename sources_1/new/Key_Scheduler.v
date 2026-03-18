`timescale 1ns / 1ps


module Key_Scheduler
#(parameter Key_Bit_Size     =80, parameter Number_of_Rounds =26)
(
input       [4:0]Counter,
input       [79:0]Prev_Key,
output      [79:0]Updated_Key,
output      [63:0]Round_Key
    );

wire [79:0]Key_Reg_Round;   
Round_Perm #(.DATA_LEN(Key_Bit_Size) , .SHIFT_AMOUNT(13)) Round_Perm(.In_Round_Perm(Prev_Key) , .Out_Round_Perm(Key_Reg_Round));

wire [3:0] Key_Reg_Round_LSB; assign Key_Reg_Round_LSB =  Key_Reg_Round[3:0];
wire [3:0] Key_Reg_Round_LSB_SBox;  
S_box S_box(.S_box_in (Key_Reg_Round_LSB),  .S_box_out(Key_Reg_Round_LSB_SBox) );


wire [4:0] Key_Reg_Round_MSB; assign Key_Reg_Round_MSB =  Key_Reg_Round[63:59];
wire [4:0] Xor_Result;


            
assign    Xor_Result[4:0] =  (Counter) ^ Key_Reg_Round_MSB[4:0];

   // {Updated_Key: 80_bit} = {Rounded Key: 16_Bit} -- {XOR: 5_bit} -- {Rounded Key: 55_Bit} -- {S_box: 4_bit}
assign Updated_Key = {Key_Reg_Round[79:64]  , Xor_Result[4:0],    Key_Reg_Round[58:4],    Key_Reg_Round_LSB_SBox};

//The key used in encryption is least significant 64 bits
assign Round_Key = Updated_Key[63:0];   

endmodule
