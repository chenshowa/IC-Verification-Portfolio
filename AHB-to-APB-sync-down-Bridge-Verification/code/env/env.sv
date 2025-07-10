//Environment

class env extends uvm_env;
  `uvm_component_utils(env)
  ahb_agent h_agt;
  apb_agent p_agt;
  scoreboard scb;
  extern function new(string name="env",uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern function  void connect_phase(uvm_phase phase);
endclass
    
function env::new(string name="env",uvm_component parent);
  super.new(name,parent);
  
endfunction
    function void env::build_phase(uvm_phase phase);
      super.build_phase(phase);
      h_agt=ahb_agent::type_id::create("h_agt",this);
      p_agt=apb_agent::type_id::create("p_agt",this);
      scb = scoreboard::type_id::create("scb",this);
    endfunction
    
    function void env::connect_phase (uvm_phase phase);
      h_agt.h_monitor.h_port.connect(scb.ahb_value);
      p_agt.p_monitor.p_port.connect(scb.apb_value);
    endfunction