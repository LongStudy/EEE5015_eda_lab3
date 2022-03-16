//-----------------------------------------------------------
// FileName: param_adder.v
// Creator : Terry Ye
// E-mail  : Terry Ye@SUSTec.com
// Function: full adder with parameters which define the width
// Update  :
// Coryright: www.SUSTec.com
//-----------------------------------------------------------

module param_adder
// parameterization design
#(parameter WIDTH = 32)

(       
  // module head: verillog-2001 format
  input  wire [WIDTH-1:0]a_in,
  input  wire [WIDTH-1:0]b_in,
  input  wire [0      :0]c_in,     // carry in
  output wire [WIDTH-1:0]sum_out,
  output wire [      0:0]c_out     // carry out
);

  // behavior of the adder can be synthesizable
  // "assign" means connectivity
  assign {c_out, sum_out} = a_in + b_in + c_in;

endmodule