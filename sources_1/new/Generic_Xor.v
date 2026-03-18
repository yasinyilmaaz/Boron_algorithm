`timescale 1ns / 1ps

module Generic_Xor
#(parameter bit_size = 64)
(
input  wire      [bit_size-1:0] Xor_Layer_op_1,
output reg      [bit_size-1:0] Xor_Layer_out,
input  wire      [bit_size-1:0] Xor_Layer_op_2
    );

always @(*) begin    
    Xor_Layer_out =  Xor_Layer_op_1 ^ Xor_Layer_op_2;
end

endmodule
