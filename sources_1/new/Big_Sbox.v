`timescale 1ns / 1ps


module Big_Sbox(
input       [63:0] Big_Sbox_in,
output      [63:0] Big_Sbox_Out
    );

integer i = 0;

wire [3:0] S_box_Inputs [15:0];
assign    S_box_Inputs[0]  = Big_Sbox_in[3:0];
assign    S_box_Inputs[1]  = Big_Sbox_in[7:4];
assign    S_box_Inputs[2]  = Big_Sbox_in[11:8];
assign    S_box_Inputs[3]  = Big_Sbox_in[15:12];
assign    S_box_Inputs[4]  = Big_Sbox_in[19:16];  
assign    S_box_Inputs[5]  = Big_Sbox_in[23:20];  
assign    S_box_Inputs[6]  = Big_Sbox_in[27:24]; 
assign    S_box_Inputs[7]  = Big_Sbox_in[31:28];
assign    S_box_Inputs[8]  = Big_Sbox_in[35:32];
assign    S_box_Inputs[9]  = Big_Sbox_in[39:36];
assign    S_box_Inputs[10] = Big_Sbox_in[43:40];
assign    S_box_Inputs[11] = Big_Sbox_in[47:44];
assign    S_box_Inputs[12] = Big_Sbox_in[51:48];
assign    S_box_Inputs[13] = Big_Sbox_in[55:52];
assign    S_box_Inputs[14] = Big_Sbox_in[59:56];
assign    S_box_Inputs[15] = Big_Sbox_in[63:60];


genvar ii ;
generate 
    for(ii = 0 ; ii <= 15 ; ii = ii + 1) begin
        S_box S_boxes( .S_box_in(S_box_Inputs[ii]), .S_box_out(Big_Sbox_Out[(((ii+1)*4)-1):(ii)*4]));
   end
endgenerate

endmodule
