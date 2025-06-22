class apb_transaction extends uvm_sequence_item;
  
  rand bit [7:0]paddr;
  rand bit pwrite;
  rand bit [31:0] pwdata;
  bit [31:0] prdata;
  rand bit psel;
  rand bit penable;
  
  `uvm_object_utils_begin(apb_transaction)
    `uvm_field_int(paddr, UVM_ALL_ON | UVM_PRINT | UVM_COMPARE) 
    `uvm_field_int(pwrite, UVM_ALL_ON | UVM_PRINT | UVM_COMPARE)
    `uvm_field_int(pwdata, UVM_ALL_ON | UVM_PRINT | UVM_COMPARE) 
    `uvm_field_int(prdata, UVM_ALL_ON | UVM_PRINT | UVM_COMPARE)
    `uvm_field_int(psel, UVM_ALL_ON | UVM_PRINT | UVM_COMPARE) 
    `uvm_field_int(penable, UVM_ALL_ON | UVM_PRINT | UVM_COMPARE) 
  `uvm_object_utils_end

  constraint c_addr_range { paddr inside {[8'h00 : 8'hFF]};}

  function new(string name = "");
    super.new(name);
  endfunction
  
  virtual function string convert2string();
    return $sformatf("APB_TXN: addr=0x%08h, pwrite=%b, pwdata=0x%08h, rdata=0x%08h", paddr, pwrite, pwdata, prdata);
  endfunction
  
endclass