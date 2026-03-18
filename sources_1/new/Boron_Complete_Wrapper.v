module Boron_Complete_Wrapper #(
    parameter Key_Bit_Size      = 80, 
    parameter Number_of_Rounds  = 26
) (
    input clk,
    output [2:0] led 
);

    wire fin_enc, fin_dec; 
    wire [63:0] cipher_to_ila; // ILA için wire ekledik
    reg [26:0] clk_counter; 

    always @(posedge clk) begin
        clk_counter <= clk_counter + 1'b1;
    end

    // Şifreleme Modülü
    (* DONT_TOUCH = "TRUE" *)
    Boron_Wrapper #(
        .Key_Bit_Size(Key_Bit_Size),
        .Number_of_Rounds(Number_of_Rounds)
    ) Boron_Wrapper_inst (
        .clk(clk),
        .fin_out(fin_enc),
        .Cipher_Text(cipher_to_ila) // Sinyali dışarı çıkardık
    );

    // Şifre Çözme Modülü
    (* DONT_TOUCH = "TRUE" *)
    Dec_Boron_Wrapper #(
        .Key_Bit_Size(Key_Bit_Size),
        .Number_of_Rounds(Number_of_Rounds)
    ) Dec_Boron_Wrapper_inst (
        .clk(clk),
        .fin_out(fin_dec)
    );

    // --- ILA (GİZLİ KAMERA) BURADA OLMALI ---
    ila_0 senin_kamera (
        .clk(clk),
        .probe0(fin_enc),
        .probe1(fin_dec),
        .probe2(cipher_to_ila)
    );

    assign led[0] = fin_enc;      
    assign led[1] = fin_dec;      
    assign led[2] = clk_counter[26]; 
    

endmodule