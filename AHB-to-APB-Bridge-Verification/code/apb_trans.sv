//APB Sequence item

class apb_trans extends uvm_sequence_item;
  bit Pclk, Preset;
  bit Pwrite;
  bit [31:0] Paddr;
  bit [31:0] Pwdata;
  rand bit [31:0] Prdata;
  bit Psel;
  bit Penable;
  `uvm_object_utils_begin(apb_trans)
  		`uvm_field_int(Pclk,  UVM_ALL_ON)
  		`uvm_field_int(Preset,  UVM_ALL_ON)
  		`uvm_field_int(Psel,  UVM_ALL_ON)
  		`uvm_field_int(Penable,  UVM_ALL_ON)
  		`uvm_field_int(Pwrite,UVM_ALL_ON)
 	 	`uvm_field_int(Paddr,UVM_ALL_ON)
 	    `uvm_field_int(Pwdata,UVM_ALL_ON)
  		`uvm_field_int(Prdata,UVM_ALL_ON)
	`uvm_object_utils_end
  extern function new(string name="apb_trans");
endclass
    
    function apb_trans::new(string name="apb_trans");
      super.new(name);
    endfunction
