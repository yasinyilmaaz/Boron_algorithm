module Small_Blokc_Shuffle(
input  [15:0] Block_Shuffle_in,
output [15:0] Block_Shuffle_out
);

wire [3:0] Block_Shuffle_regs [3:0];
assign Block_Shuffle_regs [0]	= Block_Shuffle_in[3:0];
assign Block_Shuffle_regs [1]	= Block_Shuffle_in[7:4];
assign Block_Shuffle_regs [2]	= Block_Shuffle_in[11:8];
assign Block_Shuffle_regs [3]	= Block_Shuffle_in[15:12];

assign Block_Shuffle_out = {Block_Shuffle_regs [1], Block_Shuffle_regs [0], Block_Shuffle_regs [3],Block_Shuffle_regs [2]};


endmodule