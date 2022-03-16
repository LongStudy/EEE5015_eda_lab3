//-----------------------------------------------------------
// FileName: adder32_tb_random.v
// Creator : Terry Ye
// E-mail  : 
// Function: one bit full adder
// Update  :
// Coryright: 
//-----------------------------------------------------------

module adder32_tb_random;

  reg  [31:0] ain;
  reg  [31:0] bin; 
  reg  [0 :0] cin; // drive the input port with the reg type
  wire [31:0] sumout;
  wire        cout; // sample the output port with the wire type

  /*adder_32 u_adder32(
     .a     (ain),
     .b     (bin),
     .c     (cin),   
     .s  (sumout),
     .Co   (cout)   
  );*/

adder32 u_adder32(
     .a_in     (ain),
     .b_in     (bin),
     .c_in     (cin),   
     .sum_out  (sumout),
     .c_out   (cout)   
  );



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
 //integer seed;
 //integer seed=100;
 reg [31:0] seed;
  initial begin
    if(!$value$plusargs("seed=%d",seed)) begin
      seed = 10;
    end else begin
      $display("Random function with the SEED=%d", seed);
    end
  end 

  reg [32:0] adder_sum; // used for smart checker
  always @(negedge clk) begin
    if (~reset_n) begin
      ain = 0;
      bin = 0;
      cin = 0;
    end else begin
      // question 1 : Is the seed different every simulation ? => check the log 
      // question 2 : Are the ain/bin/cin same every clock cycle? => check the log
      // question 3 : if there is an error during one simulation, how to regenerate the same error
      //              with the random seed?  => make run SEED=error_seed
      // question 4 : are the ain/bin/cin sequence same with the same random seed? => compare the two
      //              sim log file
      ain = $random(seed); // $urandom returns a unsigned 32-bit random number
      bin = $random(seed);
      cin = $random(seed);
      adder_sum = ain + bin + cin; // expected results
      $display ("%0t:adder_sum=%0d, ain=%0d, bin=%0d, cin=%0d", $time, adder_sum, ain, bin, cin);
    end
  end

  // watch dog
  // question: how to setup clock cycles for simualtion?
  integer cycle_num;
  initial begin
    if(!$value$plusargs("cycle_num=%d",cycle_num)) begin
      cycle_num=10;
      $display("S`imulation time is %0d cycles", cycle_num);
    end else begin
      $display("Simulation time is %0d cycles", cycle_num);
    end
  
    repeat(cycle_num) @ (posedge clk);

    #4000 $finish;
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
