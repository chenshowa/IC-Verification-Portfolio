class apb_test extends uvm_test;
  `uvm_component_utils(apb_test)
  
  apb_env env;
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = apb_env::type_id::create("env",this);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    begin
     apb_sequence seq;
     seq = apb_sequence::type_id::create("seq", this);
      `uvm_info("",$sformatf("Inside test"),UVM_LOW)
      seq.start(env.agent.sequencer);
    end
    phase.drop_objection(this);
  endtask
endclass
  