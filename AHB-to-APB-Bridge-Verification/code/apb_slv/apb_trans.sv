//APB Sequence item

class apb_trans extends uvm_sequence_item;
  bit Pclk, Preset;
  bit Pwrite;
  bit [`ADDR_WIDTH-1:0] Paddr;
  bit [`DATA_WIDTH-1:0] Pwdata;
  rand bit [`DATA_WIDTH-1:0] Prdata;
  bit Psel;
  bit Penable;
  
  rand logic [31:0]   data;
  rand int  unsigned  nready_num;
  rand bit slverr;
  
  constraint slverr_nready_c {
    slverr == 1'b0;
    nready_num inside {[0:1]};
  }
  
  `uvm_object_utils_begin(apb_trans)
  		`uvm_field_int(Pclk,  UVM_ALL_ON)
  		`uvm_field_int(Preset,  UVM_ALL_ON)
  		`uvm_field_int(Psel,  UVM_ALL_ON)
  		`uvm_field_int(Penable,  UVM_ALL_ON)
  		`uvm_field_int(Pwrite,UVM_ALL_ON)
 	 	`uvm_field_int(Paddr,UVM_ALL_ON)
 	    `uvm_field_int(Pwdata,UVM_ALL_ON)
  		`uvm_field_int(Prdata,UVM_ALL_ON)
        `uvm_field_int(data,UVM_DEFAULT) 
        `uvm_field_int(slverr,UVM_DEFAULT) 
    	`uvm_field_int(nready_num,UVM_DEFAULT)  
	`uvm_object_utils_end
  extern function new(string name="apb_trans");
endclass
    
    function apb_trans::new(string name="apb_trans");
      super.new(name);
    endfunction
