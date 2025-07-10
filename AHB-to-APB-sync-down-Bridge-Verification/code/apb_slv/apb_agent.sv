//APB Agent

class apb_agent extends uvm_agent;
  `uvm_component_utils(apb_agent)
  virtual apb_intf vif;
  apb_seqr p_seqr;
  apb_drv p_drv;
  apb_monitor p_monitor;
  extern function new(string name="apb_agent",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass
    
    function apb_agent::new(string name="apb_agent",uvm_component parent);
      super.new(name,parent);
    endfunction
    
    function void apb_agent::build_phase(uvm_phase phase);
      super.build_phase(phase);
      p_seqr=apb_seqr::type_id::create("p_seqr",this);
      p_drv=apb_drv::type_id::create("p_drv",this);
      p_monitor=apb_monitor::type_id::create("p_monitor",this);
    endfunction
    
    function void apb_agent::connect_phase(uvm_phase phase);
      p_drv.seq_item_port.connect(p_seqr.seq_item_export);
    endfunction
     