`include "apb_coverage.sv"

class apb_env extends uvm_env;
  `uvm_component_utils(apb_env)
  
  apb_agent agent;
  apb_subscriber subscriber;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = apb_agent::type_id::create("agent",this);
    subscriber = apb_subscriber::type_id::create("subscriber", this);

  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.mon_port.connect (subscriber.cov_analysis_export);
  endfunction
  
endclass