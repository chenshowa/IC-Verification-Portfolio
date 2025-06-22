`define DRIV_if vintf.DRIVER.drv_cb

class apb_driver extends uvm_driver#(apb_transaction);
  `uvm_component_utils(apb_driver)
  
  virtual dutintf vintf;
  
  apb_transaction apb_trans;
  function new(string name, uvm_component parent);
    super.new(name, parent);
    apb_trans = new();
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dutintf)::get(this, "*", "vintf", vintf)) begin
      `uvm_error("","driver virtual interface failed")
    end
  endfunction
  

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `DRIV_if.rst_n <= 0;
    `DRIV_if.paddr <= 0;
    `DRIV_if.pwrite <= 0;
    `DRIV_if.psel <= 0;
    `DRIV_if.pwdata <= 0;
    `DRIV_if.penable <= 0;
    
    #5;
    @(posedge vintf.DRIVER.clk);
    `DRIV_if.rst_n <= 1;
    
    forever begin
      seq_item_port.get_next_item(req);
      `DRIV_if.paddr <= req.paddr;
      `DRIV_if.pwrite <= req.pwrite;
      `DRIV_if.psel <= req.psel;
      `DRIV_if.pwdata <= req.pwdata;
      `DRIV_if.penable <= req.penable;
      
      
      
      if(req.pwrite == 0 && req.penable == 1)   // read condition
       begin
     
         wait(`DRIV_if.pready == 1);

         req.prdata = `DRIV_if.prdata;
//        `uvm_info("apb_driver",$sformatf("req.prdata=%x at time %t", req.prdata, $time), UVM_LOW)
         
       end

      seq_item_port.item_done();
      @(posedge vintf.DRIVER.clk);
    end
  endtask
  
endclass
