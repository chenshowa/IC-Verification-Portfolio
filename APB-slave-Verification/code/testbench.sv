`include "uvm_macros.svh"
 //import uvm_pkg::*;
`include "apb_transaction.sv"
`include "apb_sequence.sv"
`include "apb_monitor.sv"
`include "apb_driver.sv"
`include "apb_agent.sv"
`include "apb_env.sv"
`include "apb_test.sv"

`include "assertion.sv"

module top;
  
  dutintf intf();
  apb_slave dut(.dif(intf));
  
  initial begin
    intf.clk =0;
    forever 
      #5 intf.clk = ~intf.clk;
  end
  
  initial begin
    uvm_config_db#(virtual dutintf)::set(null,"*","vintf", intf);
    run_test("apb_test");
  end
  
  initial begin
  #200;
  end

  assertion assert0( intf.clk, intf.rst_n,intf.paddr, intf.pwrite, intf.penable, intf.psel, 
                    intf.prdata, intf.pready, intf.pwdata );
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, top);
  end

endmodule

