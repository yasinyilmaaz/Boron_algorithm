`timescale 1ns / 1ps

module Dec_Boron_Cntrl(
    input clk,
    
    // Ara bağlantı sinyalleri (Wrapper'dan gelenler)
    input [63:0] Prev_Text,
    input [79:0] Prev_Key,

    output Key_Gen_S, 
    output Start_Round_one_S,
    output reg [63:0] Current_Text,
    output reg [79:0] Current_Key,
    output reg [4:0] Dec_Permutation_Cycle_Counter,
    output reg Fin,
    output reg [63:0] Decrypted_Text, // ILA ve Wrapper için isimlendirme güncellendi
    output reg [79:0] key
);

    // VIO'dan gelecek sinyaller ve korunması gereken wire'lar
    (* dont_touch = "true" *) wire reset;
    (* dont_touch = "true" *) wire start;
    (* dont_touch = "true" *) wire [63:0] Cipher_Text;
    (* dont_touch = "true" *) wire [79:0] Key;
    (* dont_touch = "true" *) wire vio_start;
    (* dont_touch = "true" *) wire vio_reset;

    localparam Idle            = 3'b000,
               Round           = 3'b010,
               Key_Gen         = 3'b011,
               Start_Round_one = 3'b101,
               Start_Round_two = 3'b110,
               Finish          = 3'b100;

    reg [2:0] Current_State = Idle;
    reg [79:0] Master_Key; 

    assign Key_Gen_S = (Current_State == Key_Gen) ? 1'b1 : 1'b0;
    assign Start_Round_one_S = (Current_State == Start_Round_two) ? 1'b1 : 1'b0;

    // --- Sayaç Mantığı ---
    always @(posedge clk) begin
        if (reset == 1) begin 
            Dec_Permutation_Cycle_Counter <= 0;
        end else begin
            if (Current_State == Key_Gen) begin
                if (Dec_Permutation_Cycle_Counter <= 23) 
                    Dec_Permutation_Cycle_Counter <= Dec_Permutation_Cycle_Counter + 1;  
            end else if (Current_State == Round) begin
                if (Dec_Permutation_Cycle_Counter >= 1)
                    Dec_Permutation_Cycle_Counter <= Dec_Permutation_Cycle_Counter - 1; 
            end 
        end
    end

    // --- FSM (Durum Makinesi) Mantığı ---
    always @(posedge clk) begin
        if (reset == 1) begin
            Current_Text <= 0;
            Current_Key  <= 0;
            Fin          <= 0;
            Decrypted_Text <= 0;
            Current_State <= Idle;
        end else begin
            case(Current_State)
                Idle: begin 
                    Fin <= 0;
                    if (start == 1) begin
                        Current_State <= Key_Gen;
                        Current_Key   <= Key;  
                    end
                end 

                Key_Gen: begin
                    if (Dec_Permutation_Cycle_Counter == 24) begin
                        Current_State <= Start_Round_one;
                        Master_Key    <= Prev_Key;
                        Current_Key   <= Prev_Key;
                    end else begin
                        Current_Key   <= Prev_Key;
                    end
                end

                Start_Round_one: begin
                    Current_Text  <= Cipher_Text;
                    Current_Key   <= Master_Key;
                    Current_State <= Start_Round_two;
                end 

                Start_Round_two: begin
                    Current_Text  <= Cipher_Text;
                    Current_Key   <= Master_Key;
                    Current_State <= Round;
                end              
                                    
                Round: begin                                      
                    Current_Text <= Prev_Text;
                    Current_Key  <= Prev_Key;
                    if (Dec_Permutation_Cycle_Counter == 0) 
                        Current_State <= Finish;
                end

                Finish: begin
                    // ILA ve VIO'nun veriyi yakalaması için burada donduruyoruz
                    Decrypted_Text <= Current_Text; 
                    key            <= Current_Key;
                    Fin            <= 1;
                    Current_State  <= Idle;
                end

                default: Current_State <= Idle;
            endcase
        end
    end

    // --- VIO IP BAĞLANTISI ---
    vio_0 your_dec_vio (
      .clk(clk),                
      .probe_in0(Fin),            
      .probe_in1(Decrypted_Text), // message -> Decrypted_Text olarak güncellendi
      .probe_out0(Key),          
      .probe_out1(Cipher_Text),  
      .probe_out2(vio_start),    
      .probe_out3(vio_reset)     
    );

    assign start = vio_start;
    assign reset = vio_reset;

endmodule