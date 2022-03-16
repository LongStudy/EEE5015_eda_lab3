//-----------------------------------------------------------
// FileName: mux2_1_tb.v
// Creator : Terry
// E-mail  : 
// Function: 2 - 1 mux(selection) testbench
// Update  :
// Coryright: SUS Tech
//-----------------------------------------------------------

`timescale 1ns/1ps

module mux2_1_tb();

  // Data type declaration
  reg   a,  b,  s;
  wire  o;

  // Instatiate moudle
  mux2_1 u0_mux2_1 ( o, a, b, s);  
  /* mux2_1 u0_mux2_1 ( .out(o), 
                     .a(a), 
                     .b(b),
                     .s(s)
                   );
  */
  // Stimulus Driver
  initial begin
        a = 0; b = 1; s = 0;
    #10        b = 0;
    #10        b = 1; s = 1;
    #10 a = 1;
    #10 $finish;
  end

  // Response Capture
  // Result Display
  initial begin
    $monitor("@ time=%0t,  o=%b, a=%b, b=%b, s=%b",$time, o,a,b,s);
  end

initial begin
    $vcdpluson; 
  end  

endmodule // mux2_1_tb



