//-----------------------------------------------------------
// FileName: param_adder_tb_random.v
// Creator : Terry Ye
// E-mail  : Terry Ye@SUSTec.com
// Function: one bit full adder
// Update  :
// Coryright: www.SUSTec.com
//-----------------------------------------------------------

module param_adder_tb_random;
  parameter WIDTH=64;
  reg  [WIDTH-1:0] ain;
  reg  [WIDTH-1:0] bin; 
  reg  [0      :0] cin; // drive the input port with the reg type
  wire [WIDTH-1:0] sumout;
  wire        cout; // sample the output port with the wire type

  // Notice: parametizable instance
  param_adder #(64) u_param_adder
  (
    // module head: verillog-2001 format
    /*input  wire */ .a_in   (ain),
    /*input  wire */ .b_in   (bin),
    /*input  wire */ .c_in   (cin),     // carry in
    /*output wire */ .sum_out(sumout),
    /*output wire */ .c_out  (cout)   // carry out
  );

  // behavior of the adder can be synthesizable
  // "assign" means connectivity
  // assign {c_out, sum_out} = a_in + b_in + c_in;


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

  //// question1: is it enough stimulus to verify this adder32?
  //// how many stimulus patterns we need to verify the adder32 completely?
  //initial begin
  //  #110 ain = 0;
  //       bin = 0;
  //       cin = 0;
  //  #20  ain = 1;
  //       bin = 0;
  //       cin = 0;
  //  #20  ain = 1;
  //       bin = 1;
  //       cin = 0;
  //  #20  ain = 1;
  //       bin = 1;
  //       cin = 1;
  //  #50  $finish; // here is a system task which can stop the simualtion 
  //end

  // solution1: random stimulus to check the adder32
  // we can use the $random system task to generate the stimulus
  // but how to generate the seed?
  // 1. generate the SEED with shell command "date +%s/+%N" in the Makefile
  // 2. trasfer the SEED in the compile command line with the option "+plusargs_save +seed=`data +%N"
  // 3. get the seed in the below code
  integer seed;
  initial begin
    if(!$value$plusargs("seed=%d",seed)) begin
      seed = 100;
    end else begin
      $display("Random function with the SEED=%d", seed);
    end
  end 
  

  reg [WIDTH:0] adder_sum; // used for smart checker
  always @(negedge clk) begin
    if (~reset_n) begin
      ain = 0;
      bin = 0;
      cin = 0;
    end else begin
      ain = $random(seed); // $urandom returns a unsigned 32-bit random number
      bin = $random(seed);
      cin = $random(seed);
      adder_sum = ain + bin + cin;
      $display ("%0t:adder_sum=%0d, ain=%0d, bin=%0d, cin=%0d", $time, adder_sum, ain, bin, cin);
    end
  end

  // watch dog
  // how long does the testcase take?
  initial begin
    #200 $finish;
  end

  // questation2: Is the checker smart to check?
  /* --- stupid checker start -----------------
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
  --- stupid checker end ---------------*/

  // smart checker 
  always @(posedge clk) begin
    if (!reset_n) begin
      $display("%0t:%m: Resetting....",$time);
    end else begin
      if (adder_sum != {cout,sumout}) begin
        $display("ERROR: %0t:%m: adder_sum=%d, {cout,sumout}=%d", $time, adder_sum, {cout, sumout});
      end
    end
  end

  initial begin
    $vcdpluson; 
  end
endmodule