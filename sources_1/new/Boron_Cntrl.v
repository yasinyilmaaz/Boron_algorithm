`timescale 1ns / 1ps

module Boron_Cntrl(
    input clk,
    input [63:0] Prev_Text,
    input [79:0] Prev_Key,

    output reg [63:0] Current_Text,
    output reg [79:0] Current_Key,
    output reg [4:0] Permutation_Cycle_Counter,
    output reg fin,
    output reg [63:0] Cipher_Text,
    output reg [79:0] Last_Key
);

    reg [79:0] Master_master_key;
    reg [63:0] Cipher_Text_2;
    
    // VIO ve Debug Sinyalleri
    (* dont_touch = "true" *) wire [63:0] Plain_Text;
    (* dont_touch = "true" *) wire [79:0] Key;
    (* dont_touch = "true" *) wire start;
    (* dont_touch = "true" *) wire reset;
    (* dont_touch = "true" *) wire vio_start;
    (* dont_touch = "true" *) wire vio_reset;
    
    localparam Idle       = 3'b000,
               Round      = 3'b010,
               Before_Fin = 3'b011,
               Finish     = 3'b100;

    reg [2:0] Current_State = Idle;

    // Tur Sayacı
    always @(posedge clk) begin
        if (reset == 1) begin 
            Permutation_Cycle_Counter <= 0;
        end else if (Current_State == Round) begin
            if (Permutation_Cycle_Counter < 24) 
                Permutation_Cycle_Counter <= Permutation_Cycle_Counter + 1;  
            else 
                Permutation_Cycle_Counter <= 0; 
        end
    end

    // Durum Makinesi
    always @(posedge clk) begin
        if (reset == 1) begin
            Current_Text <= 0;
            Current_Key  <= 0;
            fin          <= 0;
            Cipher_Text  <= 0;
            Current_State <= Idle;
        end else begin
            case(Current_State)
                Idle: begin 
                    fin <= 0;
                    if (start == 1) begin
                        Current_State <= Round;
                        Current_Text  <= Plain_Text; 
                        Current_Key   <= Key;  
                    end
                end
                
                Round: begin                                      
                    Current_Text <= Prev_Text;
                    Current_Key  <= Prev_Key;
                    if (Permutation_Cycle_Counter == 23) begin
                        Current_State <= Before_Fin;
                        Last_Key      <= Prev_Key;
                        Cipher_Text   <= Prev_Text;
                    end
                end
                
                Before_Fin: begin 
                    Master_master_key <= Prev_Key;
                    Current_Text      <= Prev_Text;
                    Cipher_Text_2     <= Prev_Key[63:0] ^ Prev_Text;
                    Current_State     <= Finish;
                end

                Finish: begin 
                    fin <= 1; 
                    Cipher_Text   <= Cipher_Text_2; // Son XOR sonucunu ILA görsün diye buraya bastık
                    Current_State <= Idle;
                end
                
                default: Current_State <= Idle;
            endcase
        end
    end

    // VIO Bağlantısı
    vio_0 your_vio_instance (
      .clk(clk),                
      .probe_in0(fin),           
      .probe_in1(Cipher_Text),   
      .probe_out0(Key),          
      .probe_out1(Plain_Text),   
      .probe_out2(vio_start),    
      .probe_out3(vio_reset)     
    );

    assign start = vio_start;
    assign reset = vio_reset;

endmodule