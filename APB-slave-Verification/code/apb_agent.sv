class apb_agent extends uvm_agent;
  
  `uvm_component_utils(apb_agent)
  
   apb_monitor monitor;
   apb_driver driver;
   uvm_sequencer#(apb_transaction) sequencer;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction 
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active == UVM_ACTIVE) begin
      driver = apb_driver::type_id::create("driver",this);
      sequencer = uvm_sequencer#(apb_transaction)::type_id::create("sequencer", this);
    end
    monitor = apb_monitor::type_id::create("monitor",this);
    
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active == UVM_ACTIVE) begin
      driver.seq_item_port.connect(sequencer.seq_item_export);
    end
  endfunction
  
endclass
      
       
     
    