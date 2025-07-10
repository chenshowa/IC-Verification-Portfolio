//AHB Agent

class ahb_agent extends uvm_agent;
  `uvm_component_utils(ahb_agent)
  virtual ahb_intf vif;
  ahb_seqr h_seqr;
  ahb_drv h_drv;
  ahb_monitor h_monitor;
  extern function new(string name="ahb_agent",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function void connect_phase(uvm_phase phase);
endclass
    
    function ahb_agent::new(string name="ahb_agent",uvm_component parent);
      super.new(name,parent);
    endfunction
    
    function void ahb_agent::build_phase(uvm_phase phase);
      super.build_phase(phase);
      h_seqr=ahb_seqr::type_id::create("h_seqr",this);
      h_drv=ahb_drv::type_id::create("drv",this);
      h_monitor=ahb_monitor::type_id::create("h_monitor",this);
    endfunction
    
    function void ahb_agent::connect_phase(uvm_phase phase);
      h_drv.seq_item_port.connect(h_seqr.seq_item_export);
    endfunction