//-----------------------------------------------------------
// FileName: mux2_1.v
// Creator : Terry
// E-mail  : 
// Function: 2 - 1 mux(selection)
// Update  :
// Coryright: SUS Tech
//-----------------------------------------------------------

// module head: verillog-2001 format
module mux2_1 (
  // Port declaration
  output     wire      out,
  input      wire      a, b, sel
);

  // Internal Variables
  wire  sel_, a1, b1;

  // Netlist
  not (sel_, sel);
  and (a1, a, sel);
  and (b1, b, sel);
  or  (out, a1, b1);

endmodule // mux2_1
