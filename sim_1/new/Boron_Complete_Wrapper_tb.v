`timescale 1ns / 1ps

module Boron_Complete_Wrapper_tb
#(parameter Key_Bit_Size     =80, parameter Number_of_Rounds =26)( );
    
localparam clk_per = 2;
reg clk = 0; always #(clk_per /2) clk <= ~clk;
reg start= 0;
reg reset = 1;
reg [79:0] Key;
reg [63:0] Plain_Text, Cipher_Text;   
reg enc_dec = 0;

// Orijinal haline sadık kalarak sadece DUT (Design Under Test) ismini ekledik
Boron_Complete_Wrapper  #(.Key_Bit_Size(Key_Bit_Size) ,.Number_of_Rounds(Number_of_Rounds))
Boron_Complete_Wrapper_DUT 
(
    .clk(clk),
    .reset(reset),
    .start(start),  
    .Key         (Key),         
    .Cipher_Text (Cipher_Text),
    .Plain_Text  (Plain_Text),
    .enc_dec     (enc_dec)
);

initial begin
    Plain_Text <= 0;
    Key <= 0;
    #50 reset <= 0;   
    #50 start <= 1;

    #500 reset <= 0;
    #50 start <= 0;
    #5 reset <= 1; 
    #10 reset <= 0;
    #10
    Cipher_Text <= 64'h3cf72a8b7518e6f7;
    enc_dec <= 1;
    Key <= 0; 
    #50 start <= 1;
end
 
endmodule