`include "uvm_macros.svh"
`include "interface.sv"
`include "transaction.sv"
`include "sequencer.sv"
`include "Driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "base_test.sv"
`include "testcase.sv"

`include "assertion.sv"

module tbench_top;
   
  //clock and reset signal declaration
  bit clk;
  bit rst_n;
   
  //reset Generation
  initial begin
    rst_n = 0;
    #10 rst_n =1;
  end
  
  //clock generation
  always #5 clk = ~clk;
  
  add_if intf(clk, rst_n);
  
  ADDER DUT (.clk(intf.clk),
    		 .rst_n(intf.rst_n),
    		 .A(intf.A),
    		 .B(intf.B),
    		 .Sum(intf.Sum)
  );
  
  initial begin
    uvm_config_db#(virtual add_if)::set(uvm_root::get(),"*","vif",intf);
    run_test();
  end
  
  assertion assert0( clk, rst_n, intf.A, intf.B,  intf.Sum);
  
  
  initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end
  
endmodule