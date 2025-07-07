//AHB Sequence item

class ahb_trans extends uvm_sequence_item;
  bit Hclk;
  bit Hreset;
  rand bit Hwrite;
  bit Hreadyin;
  bit [`DATA_WIDTH-1:0] Hrdata;
  rand bit [`DATA_WIDTH-1:0] Hwdata;
  rand bit [`ADDR_WIDTH-1:0] Haddr;
  bit [1:0] Htrans;
  bit [2:0] Hsize;
  bit Hsel;
  bit Hresp;
  bit Hreadyout;

  `uvm_object_utils_begin(ahb_trans)
  		`uvm_field_int(Hwrite,UVM_ALL_ON)
  		`uvm_field_int(Hreadyin,UVM_ALL_ON)
  		`uvm_field_int(Hrdata,UVM_ALL_ON)
  		`uvm_field_int(Haddr,UVM_ALL_ON)
  		`uvm_field_int(Hwdata,UVM_ALL_ON)
  		`uvm_field_int(Hclk,UVM_ALL_ON)
  		`uvm_field_int(Hreset,UVM_ALL_ON)
  		`uvm_field_int(Hreadyout,UVM_ALL_ON)
  		`uvm_field_int(Hresp,UVM_ALL_ON)
  		`uvm_field_int(Htrans,  UVM_ALL_ON)
  		`uvm_field_int(Htrans,  UVM_ALL_ON)
  		`uvm_field_int(Hsize,UVM_ALL_ON)
  		`uvm_field_int(Hsel,UVM_ALL_ON)
  `uvm_object_utils_end
  extern function new(string name="ahb_trans"); 
endclass
    
    function ahb_trans::new(string name="ahb_trans");
      super.new(name);
    endfunction