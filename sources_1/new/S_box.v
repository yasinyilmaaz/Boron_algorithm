
module S_box(
input       [3:0]S_box_in,
output reg	[3:0]S_box_out
);

always @(*) begin
	case(S_box_in)
	4'h0:	S_box_out = 4'hE; 
	4'h1:	S_box_out = 4'h4; 
	4'h2:	S_box_out = 4'hB; 
	4'h3:	S_box_out = 4'h1; 
	4'h4:	S_box_out = 4'h7; 
	4'h5:	S_box_out = 4'h9; 
	4'h6:	S_box_out = 4'hC; 
	4'h7:	S_box_out = 4'hA; 
	4'h8:	S_box_out = 4'hD; 
	4'h9:	S_box_out = 4'h2; 
	4'hA:	S_box_out = 4'h0; 
	4'hB:	S_box_out = 4'hF; 
	4'hC:	S_box_out = 4'h8; 
	4'hD:	S_box_out = 4'h5; 
	4'hE:	S_box_out = 4'h3; 
	4'hF:	S_box_out = 4'h6; 
	endcase
end


endmodule
