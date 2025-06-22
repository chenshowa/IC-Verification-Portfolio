class apb_monitor extends uvm_monitor;
  
  `uvm_component_utils(apb_monitor)
  
  uvm_analysis_port#(apb_transaction) mon_port;
  
  virtual dutintf vintf;
  
  apb_transaction apb_trans;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
    apb_trans=new();
    mon_port = new("mon_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dutintf)::get(this, "*", "vintf", vintf)) begin
      `uvm_error("","failed virtual interface")
    end
  endfunction
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    begin
      forever begin
      @(posedge vintf.clk);

      apb_trans.paddr= vintf.paddr;
      apb_trans.pwdata = vintf.pwdata;
      apb_trans.prdata = vintf.prdata;
      apb_trans.psel = vintf.psel;
      apb_trans.penable = vintf.penable;
        
      mon_port.write(apb_trans);
  //    `uvm_info("",$sformatf("Agent monitor psel= %x,  penable= %x, paddr= %x, pwdata= %x, prdata= %x", vintf.psel, vintf.penable, vintf.paddr, vintf.pwdata, vintf.prdata), UVM_LOW);
      end
    end
  endtask
endclass
    
      
  
    