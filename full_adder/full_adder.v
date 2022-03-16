//-----------------------------------------------------------
// FileName: full_adder.v
// Creator : Terry Ye
// E-mail  : Terry Ye@SUSTec.com
// Function: one bit full adder
// Update  :
// Coryright: www.SUSTec.com
//-----------------------------------------------------------

module full_adder (       
  // module head: verillog-2001 format
  input  wire a_in,
  input  wire b_in,
  input  wire c_in,     // carry in
  output wire sum_out,
  output wire c_out     // carry out
);

  // method 1 Gate Level describe
  assign sum_out = a_in ^ b_in ^ c_in;
  assign c_out   = (a_in & b_in) | (b_in & c_in) | (a_in & c_in);

  // method 2 RTL design for Adder with the keyword "assign"
  // behavior of the adder can be synthesizable
  // "assign" means connectivity, which is used to describe a combinational circuit
  //assign {c_out, sum_out} = a_in + b_in + c_in;

  // method 3 RTL design for Adder with the keyword "always"
  //reg c_out, sum_out;
  //always @ (a_in, b_in, c_in) begin
  //  {c_out, sum_out} = a_in + b_in + c_in;
  //end

endmodule
