`timescale 1ns / 1ps

module Dec_Non_Generic_Xor(
input  [63:0] Xor_Layer_in,
output [63:0] Xor_Layer_out
    );
    
wire [15:0] Samples [3:0];
assign  Samples[0]  =      Xor_Layer_in  [15:0]  ;//   ^Xor_Layer_in  [31:16]^Xor_Layer_in  [63:48];              // W'0 = (W3 ^ W1 ^ W0)
assign  Samples[1]  =      Xor_Layer_in  [31:16] ;//   ^Xor_Layer_in [63:48];                                   // W'1= (W3 ^ W1)
assign  Samples[2]  =      Xor_Layer_in  [47:32] ;//   ^Xor_Layer_in  [15:0];                                  //W'2 = (W2 ^ W0)
assign  Samples[3]  =      Xor_Layer_in  [63:48] ;//   ^Xor_Layer_in  [31:16]^Xor_Layer_in  [15:0];        


wire [15:0] Xor_Steps [3:0];
assign Xor_Steps[0]     =  Samples[3]^Samples[2];
assign Xor_Steps[1]     =  Samples[1]^Samples[0];
assign Xor_Steps[2]     =  Xor_Steps[0]^Samples[1];
assign Xor_Steps[3]     =  Samples[2]^Xor_Steps[1];

assign   Xor_Layer_out = {Xor_Steps[0] ,Xor_Steps[3],Xor_Steps[2],Xor_Steps[1]} ;   
 
//assign Xor_Steps[0]     =  Samples[0]^Samples[1];
//assign Xor_Steps[1]     =  Samples[2]^Samples[1]^Samples[0];
//assign Xor_Steps[2]     =  Samples[1]^Samples[3]^Samples[2];
//assign Xor_Steps[3]     =  Samples[3]^Samples[2];

//assign   Xor_Layer_out = {Xor_Steps[3] ,Xor_Steps[2],Xor_Steps[1],Xor_Steps[0]} ;  

  
    
endmodule
