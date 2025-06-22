class transaction extends uvm_sequence_item;
  
  `uvm_object_utils_begin(transaction)
  `uvm_field_int(A,UVM_ALL_ON)
  `uvm_field_int(B,UVM_ALL_ON)
  `uvm_field_int(Sum,UVM_ALL_ON)
  `uvm_field_int(rst_n,UVM_ALL_ON)
  `uvm_object_utils_end
  
  rand bit[3:0] A;
  rand bit[3:0] B;
  bit[4:0] Sum;
  rand bit rst_n;
  
  function new(string name= "transaction");
    super.new(name);
  endfunction

endclass
