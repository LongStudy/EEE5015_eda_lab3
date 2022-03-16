`timescale 1ns / 100ps
//-----------------------------------------------------------
// FileName: adder32_tb.v
// Creator : Terry Ye
// E-mail  : 
// Function: one bit full adder
// Update  :
// Coryright: 
//-----------------------------------------------------------

module adder32_tb;

  reg  [3:0] ain;
  reg  [3:0] bin; 
  reg  [0 :0] cin; // drive the input port with the reg type
  wire [3:0] sumout;
  wire        cout; // sample the output port with the wire type

  adder_4 u_adder4(
    // task 1. how to create an instance
    // module head: verillog-2001 format
    /*input  wire */ .a  (ain),
    /*input  wire */ .b   (bin),
    /*input  wire */ .c  (cin),     // carry in
    /*output wire */ .s (sumout),
    /*output wire */ .Co  (cout)   // carry out
  );

  // behavior of the adder can be synthesizable
  // "assign" means connectivity
  // assign {c_out, sum_out} = a_in + b_in + c_in;


  //task 2. clock and reset generator
  parameter CLK_PERIOD = 20;
  reg clk, reset_n; // reset_n : active low

  initial begin
    clk = 0;
    forever begin
      #(CLK_PERIOD/2) clk = ~clk;
    end
  end

  initial begin
    reset_n = 0;
    #100 
    reset_n = 1;
  end

  //task 3. drive the stimulus and capture the response
  //here is a testcase
  initial begin
    #110 ain = 0;
         bin = 0;
         cin = 0;
    #20  ain = 1;
         bin = 0;
         cin = 0;
    #20  ain = 1;
         bin = 1;
         cin = 0;
    #20  ain = 1;
         bin = 1;
         cin = 1;

    // questions: is it enough stimulus to verify this adder32?
    // how many stimulus patterns we need to verify the adder32 completely?
    #50  $finish; // here is a system task which can stop the simualtion 
  end

  //task 4. check the result
  always @ (posedge clk) begin
    if (!reset_n) begin
      $display("%t:%m: resetting ...",$time); // counter 5 clock
    end
    else begin
      $display("%t:%m: resetting finish!", $time); // the 6th clock
    end
  end

  initial begin
    #115 if ({cout,sumout} != 2'b00) $display("Error: {cout,sumout}=%b,ain=%b, bin=%b, cin=%b",{cout,sumout}, ain, bin, cin);
    #20  if ({cout,sumout} != 2'b01) $display("Error: {cout,sumout}=%b,ain=%b, bin=%b, cin=%b",{cout,sumout}, ain, bin, cin);
    #20  if ({cout,sumout} != 2'b10) $display("Error: {cout,sumout}=%b,ain=%b, bin=%b, cin=%b",{cout,sumout}, ain, bin, cin);
    #20  if ({cout,sumout} != 2'b11) $display("Error: {cout,sumout}=%b,ain=%b, bin=%b, cin=%b",{cout,sumout}, ain, bin, cin);
  end

  // task 5. dump waveform with the compile option -debug_all
  initial begin
    //$vcdpluson;
  end
endmodule
