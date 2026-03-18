
module Dec_Round_Perm
#(parameter DATA_LEN = 16 , parameter SHIFT_AMOUNT = 15)
(
input  [DATA_LEN-1:0]   In_Round_Perm ,
output [DATA_LEN-1:0]   Out_Round_Perm
    );
 
  
 assign Out_Round_Perm = (In_Round_Perm   >> SHIFT_AMOUNT) | (In_Round_Perm <<  DATA_LEN - SHIFT_AMOUNT);
 
endmodule

