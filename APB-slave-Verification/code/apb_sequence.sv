`include "apb_test_sequence.sv"

class apb_sequence extends uvm_sequence#(apb_transaction);
  `uvm_object_utils(apb_sequence)

  function new(string name = "");
    super.new(name);
  endfunction
    
  task body();
    apb_test_sequence test;
    begin
      repeat (1) begin
      `uvm_do(test)
      end

    end
  endtask
  
endclass


